//
//  PCCommentsCell.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/13.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseTableViewCell.h"

static NSString * const TNCommentsCell = @"TNCommentsCell";

@interface PCCommentsCell : PCBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgview_avatar;
@property (weak, nonatomic) IBOutlet UILabel *lbl_nickname;
@property (weak, nonatomic) IBOutlet UILabel *lbl_comments;
@property (weak, nonatomic) IBOutlet UILabel *lbl_time;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) void (^showUserInfoBlock)(NSString *);

@end
