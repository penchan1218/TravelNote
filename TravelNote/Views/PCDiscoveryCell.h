//
//  PCDiscoveryCell.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/4.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCDiscoveryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_avatar;
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_signature;

@property (weak, nonatomic) IBOutlet UIButton *btn_follow;
@property (weak, nonatomic) IBOutlet UIImageView *img_1;
@property (weak, nonatomic) IBOutlet UIImageView *img_2;
@property (weak, nonatomic) IBOutlet UIImageView *img_3;

@property (nonatomic, assign) BOOL follow;

@property (nonatomic, assign) NSInteger idx;

- (void)clearAllElements;

- (void)setupAllElements:(NSDictionary *)dic;

@end
