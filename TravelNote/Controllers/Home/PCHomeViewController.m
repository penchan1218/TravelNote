//
//  PCHomeViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/10.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCHomeViewController.h"
#import "PCCustomSegmentView.h"
#import "PCDisplayTableViewCell.h"

@interface PCHomeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PCHomeViewController

- (void)viewDidLoad {
    PCCustomSegmentView *segmentView = [[PCCustomSegmentView alloc] initWithTitles:@[@"广场", @"关注"]
                                                                    filledInBounds:CGSizeMake(200, 44)];
    [segmentView addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentView;
    
    
}

- (void)segmentChanged:(PCCustomSegmentView *)segmentView {
    NSLog(@"%ld", (unsigned long)segmentView.index);
}

#pragma mark - Protocol - table view

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 2.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 147.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"TNReusableDisplayCell";
    
    PCDisplayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [PCDisplayTableViewCell cellWithLikeOrUnlikeAction:^(NSIndexPath *indexpath, BOOL isliked) {
            
        }];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(PCDisplayTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *titleTexts = @[@"我站在祖国的最东端-黑瞎子岛",
                            @"我的江城舌尖之旅",
                            @"漫步武汉"];
    NSArray *placeTexts = @[@"黑龙江, 佳木斯",
                            @"中国, 武汉",
                            @"中国, 武汉"];
    
    cell.indexpath = indexPath;
    cell.lbl_place.text = placeTexts[indexPath.row];
    cell.lbl_title.text = titleTexts[indexPath.row];
    
    cell.imgView_bg.image = [UIImage imageNamed:[NSString stringWithFormat:@"example_bg_%d", (int)indexPath.row]];
    cell.imgView_avatar.image = [UIImage imageNamed:[NSString stringWithFormat:@"example_avatar_%d", (int)indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击，进入相关页面。");
}

@end
