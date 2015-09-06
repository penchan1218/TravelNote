//
//  PCMyInfoSettingViewController.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/10.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPlaceHolderTextField.h"
#import "PCPlaceHolderTextView.h"
#import "PCSwitch.h"

@interface PCMyInfoSettingViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *view_modifyAvatar;
@property (weak, nonatomic) IBOutlet UIView *view_nickname;
@property (weak, nonatomic) IBOutlet UIView *view_chiefInfo;
@property (weak, nonatomic) IBOutlet UIView *view_privacy;
@property (weak, nonatomic) IBOutlet UIImageView *imgview_accessory;

@property (weak, nonatomic) IBOutlet UIImageView *imgview_avatar;
@property (weak, nonatomic) IBOutlet PCPlaceHolderTextField *tf_nickname;
@property (weak, nonatomic) IBOutlet PCPlaceHolderTextView *tv_chiefInfo;

@property (weak, nonatomic) PCSwitch *switch_custom;

@end
