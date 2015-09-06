//
//  PCMessageCell.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/11.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseTableViewCell.h"
#import "PCPlaceHolderTextView.h"

static NSString * const TNTextMessageCellIdentifier = @"TNTextMessageCell";
static NSString * const TNCommentsMessageCellIdentifier = @"TNCommentsMessageCell";

@interface PCMessageCell : PCBaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgview_avatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgview_category;
@property (weak, nonatomic) IBOutlet UIImageView *imgview_poster;

@property (weak, nonatomic) IBOutlet UIButton *btn_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_message;
@property (weak, nonatomic) IBOutlet PCPlaceHolderTextView *tv_comments;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *fromId;

@property (nonatomic, copy) void (^showUserInfoBlock)(NSString *);

//- (CGFloat)appendComments:(NSString *)newComments;

@end
