//
//  PCDiscoveryViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/3.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCDiscoveryViewController.h"
#import "PCNetworkManager.h"
#import "PCOthersInfoViewController.h"
#import "PCTravelNoteViewController.h"

#import "PCRecommendModel+Helper.h"

@interface PCDiscoveryViewController ()

@property (strong, nonatomic) NSMutableArray *models;

@end

@implementation PCDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    PCSearchBar *searchBar = [PCSearchBar searchBarInstanceWithSearchBlock:^(NSString *searchTxt) {
        [weakSelf searchRequest:searchTxt];
    }];
    searchBar.placeHolder = @"搜索游记、用户";
    self.navigationItem.titleView = searchBar;
    _searchBar = searchBar;
    
//    _tableView.clipsToBounds = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"PCDiscoveryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TNDiscoveryCell"];
    
    _models = [NSMutableArray array];
    
    [self searchRequest:nil];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasFollowedSomeoneNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSDictionary *userInfo = note.userInfo;
        for (PCRecommendModel *model in weakSelf.models) {
            if ([model.userId isEqual:userInfo[@"userId"]]) {
                model.isFollowed = YES;
                
                NSIndexPath *indexpath = model.indexpath;
                PCDiscoveryCell *cell = (PCDiscoveryCell *)[weakSelf.tableView cellForRowAtIndexPath:indexpath];
                if (cell) {
                    cell.follow = YES;
                }
            }
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasUnfollowedSomeoneNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSDictionary *userInfo = note.userInfo;
        for (PCRecommendModel *model in weakSelf.models) {
            if ([model.userId isEqual:userInfo[@"userId"]]) {
                model.isFollowed = NO;
                
                NSIndexPath *indexpath = model.indexpath;
                PCDiscoveryCell *cell = (PCDiscoveryCell *)[weakSelf.tableView cellForRowAtIndexPath:indexpath];
                if (cell) {
                    cell.follow = NO;
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

- (void)searchRequest:(NSString *)searchTxt {
    __weak typeof(self) weakSelf = self;
    if (searchTxt == nil || searchTxt.length == 0) {
        [PCNetworkManager getRecommendArticlesWithOK:^(NSArray *JSON) {
            [weakSelf.models removeAllObjects];
            for (NSInteger i = 0; i < JSON.count; i++) {
                PCRecommendModel *model = [[PCRecommendModel alloc] initWithInfo:JSON[i]];
                [weakSelf.models addObject:model];
                model.indexpath = [NSIndexPath indexPathForRow:0 inSection:weakSelf.models.count-1];
            }
            [weakSelf.tableView reloadData];
        }];
    } else {
        [PCNetworkManager searchUserByNickname:searchTxt ok:^(NSArray *JSON) {
            [weakSelf.models removeAllObjects];
            for (NSInteger i = 0; i < JSON.count; i++) {
                PCRecommendModel *model = [[PCRecommendModel alloc] initWithInfo:JSON[i]];
                [weakSelf.models addObject:model];
                model.indexpath = [NSIndexPath indexPathForRow:0 inSection:weakSelf.models.count-1];
            }
            [weakSelf.tableView reloadData];
        }];
    }
}

#pragma mark - Protocol - table view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_searchBar.isFirstResponder) {
        [_searchBar resignFirstResponder];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCDiscoveryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TNDiscoveryCell"];
    
    PCRecommendModel *model = _models[indexPath.section];
    [model reloadCell:cell];
    
    __weak typeof(self) weakSelf = self;
    cell.showArticleBlock = ^(NSInteger index) {
        if (index < model.articles.count) {
            NSDictionary *article = [model.articles objectAtIndex:index];
            NSString *articleid = article[@"_id"];
            if (articleid != nil) {
                PCTravelNoteViewController *travelNoteVC = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"TNTravelNoteViewController"];
                [weakSelf.navigationController pushViewController:travelNoteVC animated:YES];
                
                __weak PCTravelNoteViewController *weakTravelNoteVC = travelNoteVC;
                [PCNetworkManager getArticle:articleid ok:^(NSDictionary *JSON, NSString *_articleid) {
                    PCTravelNoteModel *model_travelNote = [[PCTravelNoteModel alloc] initWithInfo:JSON];
                    weakTravelNoteVC.model_tralvelNote = model_travelNote;
                }];
            }
        }
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PCRecommendModel *model = _models[indexPath.section];
//    PCBaseMyInfoViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TNUserInfoViewController"];
    PCOthersInfoViewController *userInfoVC = [[PCOthersInfoViewController alloc] init];
    userInfoVC.userId = model.userId;
    [self.navigationController pushViewController:userInfoVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
