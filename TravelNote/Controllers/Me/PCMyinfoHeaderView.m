//
//  PCMyinfoHeaderView.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/23.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCMyinfoHeaderView.h"

@implementation PCMyinfoHeaderView

//- (id)initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if (self) {
//        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PCMyinfoHeaderView"
//                                                       owner:self options:nil];
//        self = views[0];
//        self.frame = frame;
//        
//        self.imageview_avatar.layer.borderColor = [UIColor whiteColor].CGColor;
//    }
//    
//    return self;
//}

- (id)init {
    self = [super init];
    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"PCMyinfoHeaderView"
                                                       owner:self options:nil];
        self = views[0];
        
        self.imageview_avatar.layer.borderColor = [UIColor whiteColor].CGColor;
//        self.lbl_nickname.numberOfLines = 0;
        self.lbl_signature.numberOfLines = 0;
        self.lbl_nickname.adjustsFontSizeToFitWidth = YES;
        self.lbl_signature.adjustsFontSizeToFitWidth = YES;
        self.currType = UserInfoSegmentTypeNotes;
    }
    
    return self;
}

- (void)awakeFromNib {
    self.imageview_avatar.layer.cornerRadius = self.imageview_avatar.frame.size.width/2;
}

- (void)updateInfo:(PCUserInformationModel *)owner {
    self.lbl_num_notes.text = [NSString stringWithFormat:@"%@", owner.articleCount];
    self.lbl_num_likes.text = [NSString stringWithFormat:@"%@", owner.heartCount];
    self.lbl_num_fans.text = [NSString stringWithFormat:@"%@", owner.fansCount];
    self.lbl_num_follows.text = [NSString stringWithFormat:@"%@", owner.followingCount];
    
    self.lbl_nickname.text = owner.nickname;
    self.lbl_signature.text = owner.intro;
    
    self.imageview_avatar.image = owner.userImg;
}

- (void)switchSegmentTo:(UserInfoSegmentType)userInfoSegmentType {
    UserInfoSegmentType currType = self.currType;
    self.currType = userInfoSegmentType;
    
    UIImageView *fromView = nil;
    UIImageView *toView = nil;
    
    switch (currType) {
        case UserInfoSegmentTypeNotes:
            fromView = self.shadow_notes;
            break;
        case UserInfoSegmentTypeLikes:
            fromView = self.shadow_likes;
            break;
        case UserInfoSegmentTypeFollowers:
            fromView = self.shadow_fans;
            break;
        case UserInfoSegmentTypeFollowing:
            fromView = self.shadow_follows;
            break;
        default:
            break;
    }
    switch (userInfoSegmentType) {
        case UserInfoSegmentTypeNotes:
            toView = self.shadow_notes;
            break;
        case UserInfoSegmentTypeLikes:
            toView = self.shadow_likes;
            break;
        case UserInfoSegmentTypeFollowers:
            toView = self.shadow_fans;
            break;
        case UserInfoSegmentTypeFollowing:
            toView = self.shadow_follows;
            break;
        default:
            break;
    }
    
    if (!fromView ||
        !toView ||
        fromView == toView) {
        return ;
    }
    
    [UIView animateWithDuration:0.125 animations:^{
        fromView.alpha = 0.0;
        toView.alpha = 1.0;
    }];
}

@end
