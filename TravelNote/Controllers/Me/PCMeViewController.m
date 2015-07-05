//
//  PCMeViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/5.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCMeViewController.h"
#import "PCDisplayTableViewCell.h"

@interface PCMeViewController ()

@end

@implementation PCMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Protocol - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0f;
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
    cell.lbl_place.text = placeTexts[indexPath.row%3];
    cell.lbl_title.text = titleTexts[indexPath.row%3];
    
    cell.imgView_bg.image = [UIImage imageNamed:[NSString stringWithFormat:@"example_bg_%d", (int)indexPath.row%3]];
    cell.imgView_avatar.image = [UIImage imageNamed:[NSString stringWithFormat:@"example_avatar_%d", (int)indexPath.row%3]];
}

@end
