//
//  PCMyinfoHeaderView.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/23.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCUserInformationModel.h"

typedef NS_ENUM(NSUInteger, UserInfoSegmentType) {
    UserInfoSegmentTypeNotes        = 0,
    UserInfoSegmentTypeLikes        = 1,
    UserInfoSegmentTypeFollowers    = 2,
    UserInfoSegmentTypeFollowing    = 3
};

@interface PCMyinfoHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *imageview_avatar;
@property (weak, nonatomic) IBOutlet UIImageView *imageview_bg;

@property (weak, nonatomic) IBOutlet UILabel *lbl_nickname;
@property (weak, nonatomic) IBOutlet UILabel *lbl_signature;

@property (weak, nonatomic) IBOutlet UILabel *lbl_num_notes;
@property (weak, nonatomic) IBOutlet UILabel *lbl_num_likes;
@property (weak, nonatomic) IBOutlet UILabel *lbl_num_fans;
@property (weak, nonatomic) IBOutlet UILabel *lbl_num_follows;

@property (weak, nonatomic) IBOutlet UIImageView *shadow_notes;
@property (weak, nonatomic) IBOutlet UIImageView *shadow_likes;
@property (weak, nonatomic) IBOutlet UIImageView *shadow_fans;
@property (weak, nonatomic) IBOutlet UIImageView *shadow_follows;

@property (weak, nonatomic) IBOutlet UIView *view_notes;
@property (weak, nonatomic) IBOutlet UIView *view_likes;
@property (weak, nonatomic) IBOutlet UIView *view_fans;
@property (weak, nonatomic) IBOutlet UIView *view_follows;

@property (atomic, assign) UserInfoSegmentType currType;

- (void)updateInfo:(PCUserInformationModel *)userInfo;

- (void)switchSegmentTo:(UserInfoSegmentType)userInfoSegmentType;

@end
