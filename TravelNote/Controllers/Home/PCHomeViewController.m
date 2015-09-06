//
//  PCHomeViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/10.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCHomeViewController.h"
#import "PCCustomSegmentView.h"
#import "PCTravelNoteViewController.h"

#import "PCNetworkManager.h"
#import "UIRefreshControl+AFNetworking.h"

#import "PCDisplayModel+Helper.h"
#import "NSDate+MilliSeconds.h"

@interface PCHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) PCCustomSegmentView *segmentView;

@property (weak, nonatomic) UITableView *tableView_ground;
@property (weak, nonatomic) UITableView *tableView_follow;

@property (weak, nonatomic) UIRefreshControl *refreshControl_ground;
@property (weak, nonatomic) UIRefreshControl *refreshControl_follow;

@property (strong, atomic) NSMutableArray *models_ground;
@property (strong, atomic) NSMutableArray *models_follow;

@property (atomic, assign) BOOL isLoading_ground;
@property (atomic, assign) BOOL isLoading_follow;

@property (atomic, assign) NSInteger page_follow;

@property (atomic, assign) BOOL nomore_ground; // YES代表有，NO代表没有
@property (atomic, assign) BOOL nomore_follow; // 同上

@end

@implementation PCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isLoading_ground = NO;
    _isLoading_follow = NO;
    
    _nomore_ground = YES;
    _nomore_follow = YES;
    
    _models_ground = [NSMutableArray array];
    _models_follow = [NSMutableArray array];
    
    PCCustomSegmentView *segmentView = [[PCCustomSegmentView alloc] initWithTitles:@[@"广场", @"关注"]
                                                                    filledInBounds:CGSizeMake(200, 44)];
    [segmentView addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentView;
    _segmentView = segmentView;
    
    _containerScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, 0);
    _containerScrollView.showsHorizontalScrollIndicator = NO;
    _containerScrollView.backgroundColor = UIColorFromRGBA(235, 240, 245, 1.0f);
    
    UITableView *tableView_ground = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-64-49) style:UITableViewStyleGrouped];
    tableView_ground.clipsToBounds = NO;
    tableView_ground.delegate = self;
    tableView_ground.dataSource = self;
    tableView_ground.showsVerticalScrollIndicator = NO;
    tableView_ground.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_ground.backgroundColor = UIColorFromRGBA(235, 240, 245, 1.0f);
    [_containerScrollView addSubview:tableView_ground];
    _tableView_ground = tableView_ground;
    
    [_tableView_ground registerClass:[PCDisplayTableViewCell class] forCellReuseIdentifier:TNWithAvatarDisplayCell];
    
    UIRefreshControl *refreshControlForGround = [[UIRefreshControl alloc] init];
    [refreshControlForGround addTarget:self action:@selector(redownloadGroundData) forControlEvents:UIControlEventValueChanged];
    [tableView_ground addSubview:refreshControlForGround];
    self.refreshControl_ground = refreshControlForGround;
    
    UITableView *tableView_follow = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH+10, 0, SCREEN_WIDTH-20, SCREEN_HEIGHT-64-49) style:UITableViewStyleGrouped];
    tableView_follow.clipsToBounds = NO;
    tableView_follow.delegate = self;
    tableView_follow.dataSource = self;
    tableView_follow.showsVerticalScrollIndicator = NO;
    tableView_follow.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_follow.backgroundColor = UIColorFromRGBA(235, 240, 245, 1.0f);
    [_containerScrollView addSubview:tableView_follow];
    _tableView_follow = tableView_follow;
    
    [_tableView_follow registerClass:[PCDisplayTableViewCell class] forCellReuseIdentifier:TNWithAvatarDisplayCell];
    
    UIRefreshControl *refreshControlForFollow = [[UIRefreshControl alloc] init];
    [refreshControlForFollow addTarget:self action:@selector(redownloadFollowData) forControlEvents:UIControlEventValueChanged];
    [tableView_follow addSubview:refreshControlForFollow];
    self.refreshControl_follow = refreshControlForFollow;
    
    [self download];
    
    [self addNotificationObservation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 这是为了避免containerScrollView出现的时候马上调用协议方法scrollViewDidScroll:造成segmentView的indicator的偏移值错误
        _containerScrollView.delegate = self;
    });
}

- (void)addNotificationObservation {
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasFollowedSomeoneNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSDictionary *userInfo = note.userInfo;
        for (PCDisplayModel *model in weakSelf.models_ground) {
            if ([model.userId isEqual:userInfo[@"userId"]]) {
                NSIndexPath *indexpath = model.indexpath;
                model.isFollowing = YES;
                
                PCDisplayTableViewCell *cell = (PCDisplayTableViewCell *)[weakSelf.tableView_ground cellForRowAtIndexPath:indexpath];
                if (cell) {
                    cell.hasFollowed = YES;
                }
            }
        }
        
        [weakSelf redownloadFollowData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasUnfollowedSomeoneNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSString *userId = note.userInfo[@"userId"];
        for (PCDisplayModel *model in weakSelf.models_ground) {
            if ([model.userId isEqualToString:userId]) {
                NSIndexPath *indexpath = model.indexpath;
                model.isFollowing = NO;
                
                PCDisplayTableViewCell *cell = (PCDisplayTableViewCell *)[weakSelf.tableView_ground cellForRowAtIndexPath:indexpath];
                if (cell) {
                    cell.hasFollowed = NO;
                }
            }
        }
        
        NSMutableArray *models_follow = [NSMutableArray arrayWithArray:self.models_follow];
        NSMutableIndexSet *deletedSections = [NSMutableIndexSet indexSet];
        for (PCDisplayModel *model in models_follow) {
            if ([model.userId isEqualToString:userId]) {
                [self.models_follow removeObject:model];
                [deletedSections addIndex:model.indexpath.section];
            }
        }
        for (NSInteger i = 0; i < self.models_follow.count; i++) {
            PCDisplayModel *model = self.models_follow[i];
            model.indexpath = [NSIndexPath indexPathForRow:0 inSection:i];
        }
        [self.tableView_follow deleteSections:deletedSections withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasLikedSomearticleNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSString *articleId = [note.userInfo objectForKey:@"articleId"];
                                                      for (PCDisplayModel *model in self.models_ground) {
                                                          if ([model._id isEqualToString:articleId]) {
                                                              model.isLiked = YES;
                                                              model.liked++;
                                                              
                                                              PCDisplayTableViewCell *cell = (PCDisplayTableViewCell *)[self.tableView_ground cellForRowAtIndexPath:model.indexpath];
                                                              if (cell) {
                                                                  cell.isLiked = YES;
                                                                  cell.lbl_numOfLikes.text = [NSString stringWithFormat:@"%ld", (unsigned long)model.liked];
                                                              }
                                                          }
                                                      }
                                                      
                                                      for (PCDisplayModel *model in self.models_follow) {
                                                          if ([model._id isEqualToString:articleId]) {
                                                              model.isLiked = YES;
                                                              model.liked++;
                                                              
                                                              PCDisplayTableViewCell *cell = (PCDisplayTableViewCell *)[self.tableView_ground cellForRowAtIndexPath:model.indexpath];
                                                              if (cell) {
                                                                  cell.isLiked = YES;
                                                                  cell.lbl_numOfLikes.text = [NSString stringWithFormat:@"%ld", (unsigned long)model.liked];
                                                              }
                                                          }
                                                      }
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasUnlikedSomearticleNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSString *articleId = [note.userInfo objectForKey:@"articleId"];
                                                      for (PCDisplayModel *model in self.models_ground) {
                                                          if ([model._id isEqualToString:articleId]) {
                                                              model.isLiked = NO;
                                                              model.liked--;
                                                              
                                                              PCDisplayTableViewCell *cell = (PCDisplayTableViewCell *)[self.tableView_follow cellForRowAtIndexPath:model.indexpath];
                                                              if (cell) {
                                                                  cell.isLiked = NO;
                                                                  cell.lbl_numOfLikes.text = [NSString stringWithFormat:@"%ld", (unsigned long)model.liked];
                                                              }
                                                          }
                                                      }
                                                      
                                                      for (PCDisplayModel *model in self.models_follow) {
                                                          if ([model._id isEqualToString:articleId]) {
                                                              model.isLiked = NO;
                                                              model.liked--;
                                                              
                                                              PCDisplayTableViewCell *cell = (PCDisplayTableViewCell *)[self.tableView_follow cellForRowAtIndexPath:model.indexpath];
                                                              if (cell) {
                                                                  cell.isLiked = NO;
                                                                  cell.lbl_numOfLikes.text = [NSString stringWithFormat:@"%ld", (unsigned long)model.liked];
                                                              }
                                                          }
                                                      }
                                                  }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [PCPostNotificationCenter postNotification_showTabbar_withObj:self];
}

- (void)download {
    [self redownloadGroundData];
    [self redownloadFollowData];
}

- (void)redownloadGroundData {
    if (self.isLoading_ground == YES) {
        [self.refreshControl_ground endRefreshing];
        return ;
    }
    
    self.isLoading_ground = YES;
    
    __weak PCHomeViewController *weakSelf = self;
    NSURLSessionDataTask *task = [PCNetworkManager fetchArticleEntriesByTimeStamp:[NSDate millisecondsFrom1970ByNow] previous:YES ok:^(NSArray *JSON) {
        NSLog(@"%@", JSON);
        if (JSON.count == 0) {
            weakSelf.nomore_ground = NO;
            [weakSelf showNoMoreHUD];
            
            weakSelf.models_ground = [NSMutableArray array];
        } else {
            weakSelf.nomore_ground = YES;
            NSMutableArray *models_ground = [NSMutableArray array];
            for (NSInteger i = 0; i < JSON.count; i++) {
                PCDisplayModel *model = [[PCDisplayModel alloc] initWithInfo:JSON[i]];
                [model fixCellHeightWithSpecifiedCoverRatioOfType:TNDisplayCellTypeWithAvatar];
                [models_ground addObject:model];
                model.indexpath = [NSIndexPath indexPathForRow:0 inSection:models_ground.count-1];
            }
            
            weakSelf.models_ground = models_ground;
        }
        
        [weakSelf.tableView_ground reloadData];
        weakSelf.isLoading_ground = NO;
    }];
    
    [self.refreshControl_ground setRefreshingWithStateOfTask:task];
}

- (void)redownloadFollowData {
    if (self.isLoading_follow == YES) {
        [self.refreshControl_follow endRefreshing];
        return ;
    }
    
    self.isLoading_follow = YES;
    
    self.page_follow = 0;
    
    __weak PCHomeViewController *weakSelf = self;
    NSURLSessionDataTask *task = [PCNetworkManager getFollowedArticles:++self.page_follow ok:^(NSArray *JSON, NSInteger page) {
        if (JSON.count == 0) {
            weakSelf.nomore_follow = NO;
            [weakSelf showNoMoreHUD];
            
            weakSelf.models_follow = [NSMutableArray array];
        } else {
            weakSelf.nomore_follow = YES;
            NSMutableArray *models_follow = [NSMutableArray array];
            for (NSInteger i = 0; i < JSON.count; i++) {
                PCDisplayModel *model = [[PCDisplayModel alloc] initWithInfo:JSON[i]];
                [model fixCellHeightWithSpecifiedCoverRatioOfType:TNDisplayCellTypeWithAvatar];
                [models_follow addObject:model];
                model.indexpath = [NSIndexPath indexPathForRow:0 inSection:models_follow.count-1];
            }
            
            weakSelf.models_follow = models_follow;
        }
        
        [weakSelf.tableView_follow reloadData];
        weakSelf.isLoading_follow = NO;
    }];
    
    [self.refreshControl_follow setRefreshingWithStateOfTask:task];
}

- (void)showNoMoreHUD {
    MBProgressHUD *hud = [self.view HUDForStaticText:@"没有更多了╮(╯﹏╰）╭"];
    [hud hide:YES afterDelay:1];
}

- (void)downloadMoreGroundData {
    if (self.nomore_ground == NO) {
//        [self showNoMoreHUD];
        return ;
    }
    
    if (self.isLoading_ground == YES) {
        return ;
    }
    
    self.isLoading_ground = YES;
    
    __weak typeof(self) weakSelf = self;
    PCDisplayModel *model = [_models_ground objectAtIndex:_models_ground.count-1];
    [PCNetworkManager fetchArticleEntriesByTimeStamp:model.createTime previous:YES ok:^(NSArray *JSON) {
        if (JSON.count == 0) {
            weakSelf.nomore_ground = NO;
            [weakSelf showNoMoreHUD];
        }
        NSMutableIndexSet *updatedSections = [NSMutableIndexSet indexSet];
        for (NSInteger i = 0; i < JSON.count; i++) {
            PCDisplayModel *model = [[PCDisplayModel alloc] initWithInfo:JSON[i]];
            [model fixCellHeightWithSpecifiedCoverRatioOfType:TNDisplayCellTypeWithAvatar];
            [weakSelf.models_ground addObject:model];
            model.indexpath = [NSIndexPath indexPathForRow:0 inSection:weakSelf.models_ground.count-1];
            [updatedSections addIndex:weakSelf.models_ground.count-1];
        }
        [weakSelf.tableView_ground insertSections:updatedSections withRowAnimation:UITableViewRowAnimationFade];
        weakSelf.isLoading_ground = NO;
    }];
}

- (void)downloadMoreFollowData {
    if (self.nomore_follow == NO) {
//        [self showNoMoreHUD];
        return ;
    }
    
    if (self.isLoading_follow == YES) {
        return ;
    }
    
    self.isLoading_follow = YES;
    
    __weak typeof(self) weakSelf = self;
    [PCNetworkManager getFollowedArticles:++self.page_follow ok:^(NSArray *JSON, NSInteger page) {
        if (JSON.count == 0) {
            weakSelf.nomore_follow = NO;
            [weakSelf showNoMoreHUD];
        }
        NSMutableIndexSet *updatedSections = [NSMutableIndexSet indexSet];
        for (NSInteger i = 0; i < JSON.count; i++) {
            PCDisplayModel *model = [[PCDisplayModel alloc] initWithInfo:JSON[i]];
            [model fixCellHeightWithSpecifiedCoverRatioOfType:TNDisplayCellTypeWithAvatar];
            [weakSelf.models_follow addObject:model];
            model.indexpath = [NSIndexPath indexPathForRow:0 inSection:weakSelf.models_follow.count-1];
            [updatedSections addIndex:weakSelf.models_follow.count-1];
        }
        [weakSelf.tableView_follow insertSections:updatedSections withRowAnimation:UITableViewRowAnimationFade];
        weakSelf.isLoading_follow = NO;
    }];
}

- (void)segmentChanged:(PCCustomSegmentView *)segmentView {
    [_containerScrollView scrollRectToVisible:CGRectMake(segmentView.index*SCREEN_WIDTH,  0, SCREEN_WIDTH, _containerScrollView.frame.size.height) animated:YES];
}

#pragma mark - Protocol - table view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.containerScrollView) {
        CGFloat scale = scrollView.contentOffset.x/SCREEN_WIDTH;
        [self.segmentView adjustPositionWithScale:scale];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.containerScrollView) {
        NSInteger index = scrollView.contentOffset.x/SCREEN_WIDTH;
        self.segmentView.index = index;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView_ground) {
        return self.models_ground.count;
    }
    
    if (tableView == self.tableView_follow) {
        return self.models_follow.count;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCDisplayModel *model = nil;
    if (tableView == self.tableView_ground) {
        model = self.models_ground[indexPath.section];
    } else if (tableView == self.tableView_follow) {
        model = self.models_follow[indexPath.section];
    }
    
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PCDisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TNWithAvatarDisplayCell];
    
    PCDisplayModel *model = nil;
    if (tableView == self.tableView_ground) {
        model = _models_ground[indexPath.section];
        if (indexPath.section == _models_ground.count-2) {
            [self downloadMoreGroundData];
        }
    } else if (tableView == self.tableView_follow) {
        model = _models_follow[indexPath.section];
        if (indexPath.section == _models_follow.count-2) {
            [self downloadMoreFollowData];
        }
    }
    
    [model reloadCell:cell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PCDisplayModel *model_display = nil;
    if (tableView == self.tableView_ground) {
        model_display = _models_ground[indexPath.section];
    } else if (tableView == self.tableView_follow) {
        model_display = _models_follow[indexPath.section];
    }
    NSString *articleid = model_display._id;
    if (articleid != nil) {
        PCTravelNoteViewController *travelNoteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TNTravelNoteViewController"];
        [self.navigationController pushViewController:travelNoteVC animated:YES];
        
        __weak PCTravelNoteViewController *weakTravelNoteVC = travelNoteVC;
        [PCNetworkManager getArticle:articleid ok:^(NSDictionary *JSON, NSString *_articleid) {
            PCTravelNoteModel *model_travelNote = [[PCTravelNoteModel alloc] initWithInfo:JSON];
            weakTravelNoteVC.model_tralvelNote = model_travelNote;
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

//#pragma mark - Protocol - PCRenewTableViewCellHeightProtocol
//
//- (void)shouldRenewTableViewCellHeightWithModel:(PCBaseModel *__weak)model atIndexpath:(NSIndexPath *)indexpath {
//    if (indexpath.section < self.models_ground.count &&
//        model == self.models_ground[indexpath.section]) {
//        [self.tableView_ground reloadSections:[NSIndexSet indexSetWithIndex:indexpath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//    } else if (indexpath.section < self.models_follow.count &&
//               model == self.models_follow[indexpath.section]) {
//        [self.tableView_follow reloadSections:[NSIndexSet indexSetWithIndex:indexpath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//    } else {
//        NSLog(@"找不到相应的model");
//    }
//}

@end
