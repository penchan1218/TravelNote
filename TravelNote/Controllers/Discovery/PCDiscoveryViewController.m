//
//  PCDiscoveryViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/3.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCDiscoveryViewController.h"
#import "PCSearchBar.h"
#import "PCDiscoveryCell.h"

@implementation PCDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PCSearchBar *searchBar = [PCSearchBar searchBarInstance];
    searchBar.placeHolder = @"搜索游记、用户";
    self.navigationItem.titleView = searchBar;
    
    [_tableView registerNib:[UINib nibWithNibName:@"PCDiscoveryCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TNDiscoveryCell"];
}

#pragma mark - Protocol - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.f;
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
    [cell clearAllElements];
    cell.idx = indexPath.section;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PCDiscoveryCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Example
//    NSDictionary *dic = @{@"avatar": [UIImage imageNamed:@"avatar"],
//                          @"nickname": @"nickname",
//                          @"signature": @"signature",
//                          @"follow": @(NO),
//                          @"images": @[[UIImage imageNamed:@"img_1"],
//                                       [UIImage imageNamed:@"img_2"],
//                                       [UIImage imageNamed:@"img_3"]]};
//    [cell setupAllElements:dic];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"index %d selected!", (int)indexPath.section);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
