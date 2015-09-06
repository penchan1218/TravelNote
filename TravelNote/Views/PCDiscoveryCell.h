//
//  PCDiscoveryCell.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/4.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseTableViewCell.h"

@interface PCDiscoveryCell : PCBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_signature;

@property (weak, nonatomic) IBOutlet UIButton *btn_follow;

@property (weak, nonatomic) IBOutlet UIImageView *img_avatar;
@property (weak, nonatomic) IBOutlet UIImageView *img_1;
@property (weak, nonatomic) IBOutlet UIImageView *img_2;
@property (weak, nonatomic) IBOutlet UIImageView *img_3;
@property (strong, nonatomic, readonly) NSArray *imgs;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_follow;


@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) BOOL follow;


@property (nonatomic, copy) void (^showArticleBlock)(NSInteger);

@end
