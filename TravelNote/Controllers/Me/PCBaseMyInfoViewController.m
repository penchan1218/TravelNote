//
//  PCBaseMyInfoViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/23.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCOthersInfoViewController.h"

#import "PCDisplayModel+Helper.h"
#import "PCRecommendModel+Helper.h"

#import "PCUserInformationModel.h"
#import "PCSelfInformationModel.h"
#import "PCOthersInformationModel.h"

#import "PCNetworkManager+Addition.h"
#import "UIRefreshControl+AFNetworking.h"

#import "PCTravelNoteViewController.h"

#import "UIView+LayoutHelper.h"

@interface PCBaseMyInfoViewController ()

@property (strong, nonatomic) NSMutableArray *models_notes;
@property (strong, nonatomic) NSMutableArray *models_likes;
@property (strong, nonatomic) NSMutableArray *models_followers;
@property (strong, nonatomic) NSMutableArray *models_following;

@property (nonatomic, assign) NSInteger page_notes;
@property (nonatomic, assign) NSInteger page_likes;
@property (nonatomic, assign) NSInteger page_followers;
@property (nonatomic, assign) NSInteger page_following;

@property (atomic, assign) BOOL isLoading_notes;
@property (atomic, assign) BOOL isLoading_likes;
@property (atomic, assign) BOOL isLoading_followers;
@property (atomic, assign) BOOL isLoading_following;

@property (nonatomic, assign) BOOL nomore_notes;
@property (nonatomic, assign) BOOL nomore_likes;
@property (nonatomic, assign) BOOL nomore_followers;
@property (nonatomic, assign) BOOL nomore_following;

@end

@implementation PCBaseMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = UIColorFromRGBA(235, 240, 245, 1.0f);
    
    self.models_notes = [NSMutableArray array];
    self.models_likes = [NSMutableArray array];
    self.models_followers = [NSMutableArray array];
    self.models_following = [NSMutableArray array];
    
    self.nomore_notes = YES;
    self.nomore_likes = YES;
    self.nomore_followers = YES;
    self.nomore_following = YES;
    
    if (self.userId) {
        self.myInfoViewControllerType = MyInfoViewControllerTypeOthersInfo;
    } else {
        self.myInfoViewControllerType = MyInfoViewControllerTypeUserInfo;
    }
    
    [self setupUI];
    [self addTapActions];
    [self additionalSetup];
    [self addNotificationObservation];
    
    // 首次加载
    [self redownloadSegment:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.myInfoViewControllerType == MyInfoViewControllerTypeUserInfo) {
        [PCPostNotificationCenter postNotification_showTabbar_withObj:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupUI {
    CGFloat width_header = SCREEN_WIDTH;
    CGFloat height_header = MAX((int)(width_header*0.44), 180);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStyleGrouped];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.clipsToBounds = NO;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView setContentInset:UIEdgeInsetsMake(height_header, 0, 0, 0)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = UIColorFromRGBA(235, 240, 245, 1.0f);
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    PCMyinfoHeaderView *headerView = [[PCMyinfoHeaderView alloc] init];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:headerView];
    self.headerView = headerView;
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[headerView(height_header)]" options:0
                               metrics:@{@"height_header": @(height_header)}
                               views:NSDictionaryOfVariableBindings(headerView, tableView)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|[tableView]-49-|" options:0 metrics:nil
                               views:NSDictionaryOfVariableBindings(tableView)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|[headerView]|" options:0 metrics:nil
                               views:NSDictionaryOfVariableBindings(headerView)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:|-10-[tableView]-10-|" options:0 metrics:nil
                               views:NSDictionaryOfVariableBindings(tableView)]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PCDiscoveryCell"
                                               bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TNDiscoveryCell"];
    if (self.myInfoViewControllerType == MyInfoViewControllerTypeUserInfo) {
        [self.tableView registerClass:[PCDisplayTableViewCell class] forCellReuseIdentifier:TNWithTrashDisplayCell];
    } else {
        [self.tableView registerClass:[PCDisplayTableViewCell class] forCellReuseIdentifier:TNWithoutAvatarOrTrashDisplayCell];
    }
    [self.tableView registerClass:[PCDisplayTableViewCell class] forCellReuseIdentifier:TNWithAvatarDisplayCell];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(shouldRedownloadSegment:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    
    [self.view layoutIfNeeded];
}

- (void)addTapActions {
    [self.headerView.view_notes addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOn:)]];
    [self.headerView.view_fans addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOn:)]];
    [self.headerView.view_follows addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOn:)]];
    [self.headerView.view_likes addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOn:)]];
}

- (void)additionalSetup {
    if (self.myInfoViewControllerType == MyInfoViewControllerTypeUserInfo) {
        self.userInfo = [PCSelfInformationModel sharedInstance];
    } else {
        self.title = @"用户信息";
        self.navigationItem.rightBarButtonItem = nil;
        self.userInfo = [[PCOthersInformationModel alloc] initWithUserId:self.userId];
        [PCPostNotificationCenter postNotification_hideTabbar_withObj:nil];
        
        self.tableView.fixedBottom.constant = 0;
        [self.view layoutIfNeeded];
    }
}

- (void)addNotificationObservation {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shouldUpdateSelfInfo:)
                                                 name:TNShouldUpdateUserInfoNotification
                                               object:self.userInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasDeletedOneTravelNote:)
                                                 name:TNHasDeletedOneTravelNoteNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveHasFollowedNotification:) name:TNHasFollowedSomeoneNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveHasUnFollowedNotification:) name:TNHasUnfollowedSomeoneNotification object:nil];
}

- (void)receiveHasFollowedNotification:(NSNotification *)notif {
    NSString *userId = [notif.userInfo objectForKey:@"userId"];
    [self hasFollowed:YES someone:userId];
}

- (void)receiveHasUnFollowedNotification:(NSNotification *)notif {
    NSString *userId = [notif.userInfo objectForKey:@"userId"];
    [self hasFollowed:NO someone:userId];
}

- (void)hasFollowed:(BOOL)hasFollowed someone:(NSString *)userId {
    for (PCDisplayModel *model in self.models_likes) {
        if ([model.userId isEqualToString:userId]) {
            model.isFollowing = hasFollowed;
            
            if (self.headerView.currType == UserInfoSegmentTypeLikes) {
                PCDisplayTableViewCell *cell = (PCDisplayTableViewCell *)[self.tableView cellForRowAtIndexPath:model.indexpath];
                if (cell) {
                    cell.hasFollowed = hasFollowed;
                }
            }
        }
    }
    for (PCRecommendModel *model in self.models_followers) {
        if ([model.userId isEqualToString:userId]) {
            model.isFollowed = hasFollowed;
            
            if (self.headerView.currType == UserInfoSegmentTypeFollowers) {
                PCDiscoveryCell *cell = (PCDiscoveryCell *)[self.tableView cellForRowAtIndexPath:model.indexpath];
                if (cell) {
                    cell.follow = hasFollowed;
                }
            }
        }
    }
    
    switch (self.myInfoViewControllerType) {
        case MyInfoViewControllerTypeUserInfo: {
            if (!hasFollowed) {
                NSMutableArray *models_following = [NSMutableArray arrayWithArray:self.models_following];
                NSMutableIndexSet *deletedSections = [NSMutableIndexSet indexSet];
                for (PCRecommendModel *model in models_following) {
                    if ([model.userId isEqualToString:userId]) {
                        [self.models_following removeObject:model];
                        [deletedSections addIndex:model.indexpath.section];
                    }
                }
                for (NSInteger i = 0; i < self.models_following.count; i++) {
                    PCRecommendModel *model = self.models_following[i];
                    model.indexpath = [NSIndexPath indexPathForRow:0 inSection:i];
                }
                if (self.headerView.currType == UserInfoSegmentTypeFollowing) {
                    [self.tableView deleteSections:deletedSections withRowAnimation:UITableViewRowAnimationFade];
                }
            }
        }
            break;
        case MyInfoViewControllerTypeOthersInfo: {
            for (PCRecommendModel *model in self.models_following) {
                if ([model.userId isEqualToString:userId]) {
                    model.isFollowed = hasFollowed;
                    
                    if (self.headerView.currType == UserInfoSegmentTypeFollowing) {
                        PCDiscoveryCell *cell = (PCDiscoveryCell *)[self.tableView cellForRowAtIndexPath:model.indexpath];
                        if (cell) {
                            cell.follow = hasFollowed;
                        }
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

- (void)shouldRedownloadSegment:(UIRefreshControl *)rc {
    if (rc.refreshing) {
        [self redownloadSegment:YES];
    }
}

- (void)clearModels {
    switch (self.headerView.currType) {
        case UserInfoSegmentTypeNotes: {
            [self.models_notes removeAllObjects];
            self.nomore_notes = YES;
            self.page_notes = 0;
        }
            break;
        case UserInfoSegmentTypeLikes: {
            [self.models_likes removeAllObjects];
            self.nomore_likes = YES;
            self.page_likes = 0;
        }
            break;
        case UserInfoSegmentTypeFollowers: {
            [self.models_followers removeAllObjects];
            self.nomore_followers = YES;
            self.page_followers = 0;
        }
            break;
        case UserInfoSegmentTypeFollowing: {
            [self.models_following removeAllObjects];
            self.nomore_following = YES;
            self.page_following = 0;
        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (BOOL)ifCurrSegmentHasMore {
    UserInfoSegmentType type = self.headerView.currType;
    return (type==UserInfoSegmentTypeNotes && self.nomore_notes)||
           (type==UserInfoSegmentTypeLikes && self.nomore_likes)||
           (type==UserInfoSegmentTypeFollowers && self.nomore_followers)||
           (type==UserInfoSegmentTypeFollowing && self.nomore_following);
}

- (void)redownloadSegment:(BOOL)shouldRedownload {
//    if (self.isLoading_notes || self.isLoading_likes || self.isLoading_followers || self.isLoading_following) {
//        [self.refreshControl endRefreshing];
//        return ;
//    }
    
    __weak MBProgressHUD *hud_waiting = nil;
    if (shouldRedownload) {
        [self.refreshControl beginRefreshing];
        hud_waiting = [self.view HUDForLoadingText:@"正在加载"];
        
        [self clearModels];
    }
    
    if (![self ifCurrSegmentHasMore]) {
        [hud_waiting hide:NO];
        return ;
    }
    
    __weak typeof(self) weakSelf = self;
    if (self.headerView.currType == UserInfoSegmentTypeNotes) {
        self.isLoading_notes = YES;
        
        NSURLSessionDataTask *task = [PCNetworkManager getUserArticles:self.userInfo.userId page:++self.page_notes ok:^(NSArray *JSON, NSString *userid, NSInteger page) {
            if (JSON.count > 0) {
                NSMutableIndexSet *insertedIndexes = [NSMutableIndexSet indexSet];
                for (NSDictionary *info in JSON) {
                    PCDisplayModel *model = [[PCDisplayModel alloc] initWithInfo:info];
                    if (weakSelf.myInfoViewControllerType == MyInfoViewControllerTypeUserInfo) {
                        [model fixCellHeightWithSpecifiedCoverRatioOfType:TNDisplayCellTypeWithTrash];
                    } else if (weakSelf.myInfoViewControllerType == MyInfoViewControllerTypeOthersInfo) {
                        [model fixCellHeightWithSpecifiedCoverRatioOfType:TNDisplayCellTypeWithoutAvatarOrTrash];
                    }
                    [weakSelf.models_notes addObject:model];
                    model.indexpath = [NSIndexPath indexPathForRow:0 inSection:weakSelf.models_notes.count-1];
                    [insertedIndexes addIndex:model.indexpath.section];
                }
                if (weakSelf.headerView.currType == UserInfoSegmentTypeNotes) {
//                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView insertSections:insertedIndexes withRowAnimation:UITableViewRowAnimationFade];
                }
            } else {
                weakSelf.page_notes--;
                weakSelf.nomore_notes = NO;
                [weakSelf showNoMoreHUD];
            }
            
            weakSelf.isLoading_notes = NO;
            [hud_waiting hide:YES];
        }];
        [self.refreshControl setRefreshingWithStateOfTask:task];
    } else if (self.headerView.currType == UserInfoSegmentTypeLikes) {
        self.isLoading_likes = YES;
        
        NSURLSessionDataTask *task = [PCNetworkManager getUserFavorites:self.userInfo.userId page:++self.page_likes ok:^(NSArray *JSON, NSInteger page) {
            if (JSON.count > 0) {
                NSMutableIndexSet *insertedIndexes = [NSMutableIndexSet indexSet];
                for (NSDictionary *info in JSON) {
                    PCDisplayModel *model = [[PCDisplayModel alloc] initWithInfo:info];
                    [model fixCellHeightWithSpecifiedCoverRatioOfType:TNDisplayCellTypeWithAvatar];
                    [weakSelf.models_likes addObject:model];
                    model.indexpath = [NSIndexPath indexPathForRow:0 inSection:weakSelf.models_likes.count-1];
                    [insertedIndexes addIndex:model.indexpath.section];
                }
                if (weakSelf.headerView.currType == UserInfoSegmentTypeLikes) {
//                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView insertSections:insertedIndexes withRowAnimation:UITableViewRowAnimationFade];
                }
            } else {
                weakSelf.page_likes--;
                weakSelf.nomore_likes = NO;
                [weakSelf showNoMoreHUD];
            }
            
            weakSelf.isLoading_likes = NO;
            [hud_waiting hide:YES];
        }];
        [self.refreshControl setRefreshingWithStateOfTask:task];
    } else if (self.headerView.currType == UserInfoSegmentTypeFollowers) {
        self.isLoading_followers = YES;
        
        NSURLSessionDataTask *task = [PCNetworkManager getInfoOfFollowers:self.userInfo.userId page:++self.page_followers ok:^(NSArray *JSON) {
            if (JSON.count > 0) {
                NSMutableIndexSet *insertedIndexes = [NSMutableIndexSet indexSet];
                for (NSDictionary *info in JSON) {
                    PCRecommendModel *model = [[PCRecommendModel alloc] initWithInfo:info];
                    [weakSelf.models_followers addObject:model];
                    model.indexpath = [NSIndexPath indexPathForRow:0 inSection:weakSelf.models_followers.count-1];
                    [insertedIndexes addIndex:model.indexpath.section];
                }
                if (weakSelf.headerView.currType == UserInfoSegmentTypeFollowers) {
//                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView insertSections:insertedIndexes withRowAnimation:UITableViewRowAnimationFade];
                }
            } else {
                weakSelf.page_followers--;
                weakSelf.nomore_followers = NO;
                [weakSelf showNoMoreHUD];
            }
            
            weakSelf.isLoading_followers = NO;
            [hud_waiting hide:YES];
        }];
        [self.refreshControl setRefreshingWithStateOfTask:task];
    } else if (self.headerView.currType == UserInfoSegmentTypeFollowing) {
        self.isLoading_following = YES;
        
        NSURLSessionDataTask *task = [PCNetworkManager getInfoOfFollowing:self.userInfo.userId page:++self.page_following ok:^(NSArray *JSON) {
            if (JSON.count > 0) {
                NSMutableIndexSet *insertedIndexes = [NSMutableIndexSet indexSet];
                for (NSDictionary *info in JSON) {
                    PCRecommendModel *model = [[PCRecommendModel alloc] initWithInfo:info];
                    [weakSelf.models_following addObject:model];
                    model.indexpath = [NSIndexPath indexPathForRow:0 inSection:weakSelf.models_following.count-1];
                    [insertedIndexes addIndex:model.indexpath.section];
                }
                if (weakSelf.headerView.currType == UserInfoSegmentTypeFollowing) {
//                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView insertSections:insertedIndexes withRowAnimation:UITableViewRowAnimationFade];
                }
            } else {
                weakSelf.page_following--;
                weakSelf.nomore_following = NO;
                [weakSelf showNoMoreHUD];
            }
            
            weakSelf.isLoading_following = NO;
            [hud_waiting hide:YES];
        }];
        [self.refreshControl setRefreshingWithStateOfTask:task];
    } else {
        [hud_waiting hide:YES];
        [self.refreshControl endRefreshing];
        return ;
    }
    
    if (shouldRedownload) {
        [self redownloadUserInfo];
    }
}

- (void)tapOn:(UITapGestureRecognizer *)tapGesture {
    switch (tapGesture.view.tag) {
        case 1000: {
            [self.headerView switchSegmentTo:UserInfoSegmentTypeNotes];
            if (self.page_notes == 0 && self.isLoading_notes == NO) {
                [self redownloadSegment:YES];
                return ;
            }
        }
            break;
        case 1001: {
            [self.headerView switchSegmentTo:UserInfoSegmentTypeLikes];
            if (self.page_likes == 0 && self.isLoading_likes == NO) {
                [self redownloadSegment:YES];
                return ;
            }
        }
            break;
        case 1002: {
            [self.headerView switchSegmentTo:UserInfoSegmentTypeFollowers];
            if (self.page_followers == 0 && self.isLoading_followers == NO) {
                [self redownloadSegment:YES];
                return ;
            }
        }
            break;
        case 1003: {
            [self.headerView switchSegmentTo:UserInfoSegmentTypeFollowing];
            if (self.page_following == 0 && self.isLoading_following == NO) {
                [self redownloadSegment:YES];
                return ;
            }
        }
            break;
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (void)redownloadUserInfo {
    [self.userInfo downloadUserInfo];
}

- (void)shouldUpdateSelfInfo:(NSNotification *)notif {
    [self.headerView updateInfo:self.userInfo];
}

- (void)hasDeletedOneTravelNote:(NSNotification *)notif {
    NSString *articleId = [notif.userInfo objectForKey:@"articleId"];
    if (articleId) {
        __weak typeof(self) weakSelf = self;
        
        NSMutableIndexSet *deletedSections_notes = [NSMutableIndexSet indexSet];
        NSMutableIndexSet *deletedSections_likes = [NSMutableIndexSet indexSet];
        NSArray *deletedModels_notes = [NSArray arrayWithArray:weakSelf.models_notes];
        NSArray *deletedModels_likes = [NSArray arrayWithArray:weakSelf.models_likes];
        
        for (PCDisplayModel *model in deletedModels_notes) {
            if ([model._id isEqualToString:articleId]) {
                [deletedSections_notes addIndex:model.indexpath.section];
                [weakSelf.models_notes removeObject:model];
            }
        }
        for (NSInteger i = 0; i < weakSelf.models_notes.count; i++) {
            PCDisplayModel *model = weakSelf.models_notes[i];
            model.indexpath = [NSIndexPath indexPathForRow:0 inSection:i];
        }
        if (weakSelf.headerView.currType == UserInfoSegmentTypeNotes) {
            [weakSelf.tableView deleteSections:deletedSections_notes withRowAnimation:UITableViewRowAnimationFade];
        }
        weakSelf.userInfo.articleCount = @([weakSelf.userInfo.articleCount integerValue]-deletedSections_notes.count);
        
        for (PCDisplayModel *model in deletedModels_likes) {
            if ([model._id isEqualToString:articleId]) {
                [deletedSections_likes addIndex:model.indexpath.section];
                [weakSelf.models_likes removeObject:model];
            }
        }
        for (NSInteger i = 0; i < weakSelf.models_likes.count; i++) {
            PCDisplayModel *model = weakSelf.models_likes[i];
            model.indexpath = [NSIndexPath indexPathForRow:0 inSection:i];
        }
        if (weakSelf.headerView.currType == UserInfoSegmentTypeLikes) {
            [weakSelf.tableView deleteSections:deletedSections_likes withRowAnimation:UITableViewRowAnimationFade];
        }
        weakSelf.userInfo.heartCount = @([weakSelf.userInfo.heartCount integerValue]-deletedSections_likes.count);
        
        [weakSelf.userInfo updateView];
    }
}

- (void)showNoMoreHUD {
    MBProgressHUD *hud = [self.view HUDForStaticText:@"没有更多了╮(╯﹏╰）╭"];
    [hud hide:YES afterDelay:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol - table view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset_y = scrollView.contentOffset.y;
    CGFloat height_header = self.headerView.frame.size.height;
    self.headerView.fixedTop.constant = -MIN(MAX(offset_y, -height_header), -64)-height_header;
//    [scrollView setContentInset:UIEdgeInsetsMake(-MIN(MAX(offset_y, -height_header), -64), 0, 0, 0)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.headerView.currType) {
        case UserInfoSegmentTypeNotes:
            return self.models_notes.count;
        case UserInfoSegmentTypeLikes:
            return self.models_likes.count;
        case UserInfoSegmentTypeFollowers:
            return self.models_followers.count;
        case UserInfoSegmentTypeFollowing:
            return self.models_following.count;
        default:
            return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (self.headerView.currType) {
        case UserInfoSegmentTypeFollowers:
        case UserInfoSegmentTypeFollowing:
            return 15.0f;
        case UserInfoSegmentTypeNotes:
        case UserInfoSegmentTypeLikes:
        default:
            return 5.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (self.headerView.currType) {
        case UserInfoSegmentTypeFollowers:
        case UserInfoSegmentTypeFollowing:
            return 0.001f;
        case UserInfoSegmentTypeLikes:
        case UserInfoSegmentTypeNotes:
        default:
            return 5.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.headerView.currType == UserInfoSegmentTypeNotes ||
        self.headerView.currType == UserInfoSegmentTypeLikes) {
        PCDisplayModel *model = nil;
        if (self.headerView.currType == UserInfoSegmentTypeNotes) {
            model = self.models_notes[indexPath.section];
        } else if (self.headerView.currType == UserInfoSegmentTypeLikes) {
            model = self.models_likes[indexPath.section];
        }
        
        return model.cellHeight;
    }
    
    if (self.headerView.currType == UserInfoSegmentTypeFollowing ||
        self.headerView.currType == UserInfoSegmentTypeFollowers) {
        // 接下来根据storyboard的设置计算高度
        float top_inset_y_top = 10.0f;
        float top_inset_y_bottom = 6.0f;
        float avatar_height = 50.0f;
        float bottom_inset_y_top = 12.0f;
        float bottom_inset_y_bottom = 12.0f;
        float tableView_inset = 12.0f;
        float img_inset = 10.0f;
        float img_dist = 10.0f;
        float img_height = (SCREEN_WIDTH - 2*tableView_inset - 2*img_inset - 2*img_dist)/3;
        return top_inset_y_top+top_inset_y_bottom+avatar_height+bottom_inset_y_top+bottom_inset_y_bottom+img_height;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier_discovery = @"TNDiscoveryCell";
    PCDisplayTableViewCell *cell = nil;
    NSArray *models = nil;
    switch (self.headerView.currType) {
        case UserInfoSegmentTypeNotes: {
            if (self.myInfoViewControllerType == MyInfoViewControllerTypeUserInfo) {
                cell = [tableView dequeueReusableCellWithIdentifier:TNWithTrashDisplayCell];
            } else {
                cell = [tableView dequeueReusableCellWithIdentifier:TNWithoutAvatarOrTrashDisplayCell];
            }
            
            models = self.models_notes;
        }
            break;
        case UserInfoSegmentTypeLikes: {
            cell = [tableView dequeueReusableCellWithIdentifier:TNWithAvatarDisplayCell];
            models = self.models_likes;
        }
            break;
        case UserInfoSegmentTypeFollowers: {
            cell = [tableView dequeueReusableCellWithIdentifier:identifier_discovery];
            models = self.models_followers;
        }
            break;
        case UserInfoSegmentTypeFollowing: {
            cell = [tableView dequeueReusableCellWithIdentifier:identifier_discovery];
            models = self.models_following;
        }
            break;
        default:
            break;
    }
    
    if (indexPath.section == models.count-2) {
        [self redownloadSegment:NO];
    }
    
    if (models && models.count > indexPath.section) {
        PCBaseModel *model = models[indexPath.section];
        [model reloadCell:cell];
        
        if (self.headerView.currType == UserInfoSegmentTypeFollowing ||
            self.headerView.currType == UserInfoSegmentTypeFollowers) {
            PCRecommendModel *recommendModel = (PCRecommendModel *)model;
            PCDiscoveryCell *discoveryCell = (PCDiscoveryCell *)cell;
            
            __weak typeof(self) weakSelf = self;
            discoveryCell.showArticleBlock = ^(NSInteger index) {
                if (index < recommendModel.articles.count) {
                    NSDictionary *article = [recommendModel.articles objectAtIndex:index];
                    NSString *articleid = article[@"_id"];
                    if (articleid != nil) {
                        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                        PCTravelNoteViewController *travelNoteVC = [sb instantiateViewControllerWithIdentifier:@"TNTravelNoteViewController"];
                        [weakSelf.navigationController pushViewController:travelNoteVC animated:YES];
                        
                        __weak PCTravelNoteViewController *weakTravelNoteVC = travelNoteVC;
                        [PCNetworkManager getArticle:articleid ok:^(NSDictionary *JSON, NSString *_articleid) {
                            PCTravelNoteModel *model_travelNote = [[PCTravelNoteModel alloc] initWithInfo:JSON];
                            weakTravelNoteVC.model_tralvelNote = model_travelNote;
                        }];
                    }
                }
            };
        }
    } else {
        NSLog(@"有越界危险");
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (self.headerView.currType == UserInfoSegmentTypeNotes ||
        self.headerView.currType == UserInfoSegmentTypeLikes) {
        
        PCDisplayModel *model_display = nil;
        if (self.headerView.currType == UserInfoSegmentTypeNotes) {
            model_display = _models_notes[indexPath.section];
        } else if (self.headerView.currType == UserInfoSegmentTypeLikes) {
            model_display = _models_likes[indexPath.section];
        }
        
        NSString *articleid = model_display._id;
        if (articleid != nil) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            PCTravelNoteViewController *travelNoteVC = [sb instantiateViewControllerWithIdentifier:@"TNTravelNoteViewController"];
            [self.navigationController pushViewController:travelNoteVC animated:YES];
            
            __weak PCTravelNoteViewController *weakTravelNoteVC = travelNoteVC;
            [PCNetworkManager getArticle:articleid ok:^(NSDictionary *JSON, NSString *_articleid) {
                PCTravelNoteModel *model_travelNote = [[PCTravelNoteModel alloc] initWithInfo:JSON];
                weakTravelNoteVC.model_tralvelNote = model_travelNote;
            }];
        }
        
    } else if (self.headerView.currType == UserInfoSegmentTypeFollowers ||
               self.headerView.currType == UserInfoSegmentTypeFollowing) {
        
        PCRecommendModel *model;
        if (self.headerView.currType == UserInfoSegmentTypeFollowers) {
            model = _models_followers[indexPath.section];
        } else if (self.headerView.currType == UserInfoSegmentTypeFollowing) {
            model = _models_following[indexPath.section];
        }
        
//        PCMeViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TNUserInfoViewController"];
//        PCBaseMyInfoViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TNUserInfoViewController"];
        PCOthersInfoViewController *userInfoVC = [[PCOthersInfoViewController alloc] init];
        userInfoVC.userId = model.userId;
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
}

- (void)setScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    [scrollView removeFromSuperview];
}

//#pragma mark - Protocol - PCRenewTableViewCellHeightProtocol
//
//- (void)shouldRenewTableViewCellHeightWithModel:(PCBaseModel *__weak)model atIndexpath:(NSIndexPath *)indexpath {
//    if (indexpath.section < self.models_notes.count &&
//        model == self.models_notes[indexpath.section] &&
//        self.headerView.currType == UserInfoSegmentTypeNotes) {
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexpath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//    } else if (indexpath.section < self.models_likes.count &&
//               model == self.models_likes[indexpath.section] &&
//               self.headerView.currType == UserInfoSegmentTypeLikes) {
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexpath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}

@end
