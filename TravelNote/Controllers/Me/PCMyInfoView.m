//
//  PCMyInfoView.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/5.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCMyInfoView.h"

@implementation PCMyInfoView

- (void)awakeFromNib {
    UIColor *borderColor = UIColorFromRGBA(221, 221, 221, 1.0f);
    
    _view_note.tag = 1000;
    _view_like.tag = 1001;
    _view_fans.tag = 1002;
    _view_follow.tag = 1003;
    
    self.layer.cornerRadius = 4.0f;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1.0f;
    
    self.imgview_avatar.layer.cornerRadius = self.imgview_avatar.frame.size.width/2;
    
    NSArray *views = @[_view_note, _view_like, _view_fans, _view_follow];
    for (UIView *view in views) {
        view.layer.borderWidth = 1.0f;
        view.layer.borderColor = borderColor.CGColor;
    }
}

- (void)updateInfo:(__weak PCUserInformationModel *)owner {
    self.lbl_numOfNotes.text = [NSString stringWithFormat:@"%@", owner.articleCount];
    self.lbl_numOfLikes.text = [NSString stringWithFormat:@"%@", owner.heartCount];
    self.lbl_numOfFans.text = [NSString stringWithFormat:@"%@", owner.fansCount];
    self.lbl_numOfFollows.text = [NSString stringWithFormat:@"%@", owner.followingCount];
    self.lbl_notes.text = [NSString stringWithFormat:@"%@篇游记", owner.articleCount];
    
    self.lbl_nickname.text = owner.nickname;
    self.lbl_signature.text = owner.intro;
    
    self.imgview_avatar.image = owner.userImg;
}

- (void)hideSomeElements {
    _btn_img_modify.alpha = 0.0f;
    _btn_txt_modify.alpha = 0.0f;
}

@end
