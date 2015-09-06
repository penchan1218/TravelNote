//
//  PCMyInfoView.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/5.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCUserInformationModel.h"

@interface PCMyInfoView : UIView

@property (nonatomic, weak) IBOutlet UIView *view_items;
@property (nonatomic, weak) IBOutlet UIView *view_note;
@property (nonatomic, weak) IBOutlet UIView *view_like;
@property (nonatomic, weak) IBOutlet UIView *view_fans;
@property (nonatomic, weak) IBOutlet UIView *view_follow;

@property (nonatomic, weak) IBOutlet UILabel *lbl_numOfNotes;
@property (nonatomic, weak) IBOutlet UILabel *lbl_numOfLikes;
@property (nonatomic, weak) IBOutlet UILabel *lbl_numOfFans;
@property (nonatomic, weak) IBOutlet UILabel *lbl_numOfFollows;
@property (nonatomic, weak) IBOutlet UILabel *lbl_notes;

@property (nonatomic, weak) IBOutlet UILabel *lbl_nickname;
@property (nonatomic, weak) IBOutlet UILabel *lbl_signature;
@property (nonatomic, weak) IBOutlet UIImageView *imgview_avatar;

@property (nonatomic, weak) IBOutlet UIButton *btn_img_modify;
@property (nonatomic, weak) IBOutlet UIButton *btn_txt_modify;

- (void)updateInfo:(PCUserInformationModel *)userInfo;

- (void)hideSomeElements;

@end
