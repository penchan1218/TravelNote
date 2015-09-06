//
//  PCMyInfoSettingViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/10.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCMyInfoSettingViewController.h"
#import "PCSelfInformationModel.h"
#import "PCNetworkManager.h"
#import "UIView+BGTouchView.h"
#import "PCBaseImagePickerController.h"
#import "UIImage+ImagesAbout.h"

@interface PCMyInfoSettingViewController ()

@property (nonatomic, assign) BOOL _modified;

@property (nonatomic, copy) NSString *old_nickname;
@property (nonatomic, copy) NSString *old_intro;

@property (nonatomic, assign) BOOL isAvatarChanged;

@end

@implementation PCMyInfoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __modified = NO;
    
    CGColorRef borderColor = UIColorFromRGBA(221, 221, 221, 1.0f).CGColor;
    
    _view_modifyAvatar.layer.borderColor = borderColor;
    _tf_nickname.layer.borderColor = borderColor;
    _tv_chiefInfo.layer.borderColor = borderColor;
    _view_privacy.layer.borderColor = borderColor;
    
    _imgview_avatar.layer.cornerRadius = _imgview_avatar.frame.size.width/2;
    
    _imgview_avatar.image = [[PCSelfInformationModel sharedInstance] userImg];
    _tf_nickname.text = [[PCSelfInformationModel sharedInstance] nickname];
    _tv_chiefInfo.text = [[PCSelfInformationModel sharedInstance] intro];
    
    self.old_nickname = _tf_nickname.text;
    self.old_intro = _tv_chiefInfo.text;

    PCSwitch *switch_custom = [[PCSwitch alloc] init];
    switch_custom.translatesAutoresizingMaskIntoConstraints = NO;
    [switch_custom addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [_view_privacy addSubview:switch_custom];
    _switch_custom = switch_custom;
    switch_custom.on = NO;
    
    [_view_privacy addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"H:[_switch_custom(35)]-10-|" options:0 metrics:nil
                                   views:NSDictionaryOfVariableBindings(_switch_custom)]];
    [_view_privacy addConstraints:[NSLayoutConstraint
                                   constraintsWithVisualFormat:@"V:|[_switch_custom]|" options:0 metrics:nil
                                   views:NSDictionaryOfVariableBindings(_switch_custom)]];
    
    
    [self.imgview_accessory setImage:[[UIImage imageNamed:@"icon_accessory"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    __weak typeof(self) weakSelf = self;
//    [self.imgview_accessory touchEndedBlock:^(UIView *selfView) {
//        [weakSelf showSelectTypeOfImagePicker];
//    }];
    [self.view_modifyAvatar touchEndedBlock:^(UIView *selfView) {
        [weakSelf showSelectTypeOfImagePicker];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [PCPostNotificationCenter postNotification_hideTabbar_withObj:nil];
}

- (void)showSelectTypeOfImagePicker {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择头像"
                                                    delegate:self
                                           cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                           otherButtonTitles:@"照相", @"从相册中获取", nil];
    [as showInView:self.view];
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType {
    PCBaseImagePickerController *picker = [[PCBaseImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)switchChanged:(PCSwitch *)Switch {
    // 作品设置为私有
}

- (IBAction)checkModification:(id)sender {
    [self resignFirstResponder];
    [self checkIfModified];
    
    // 根据是否已更改内容决定是否弹出提示框
    if (__modified == YES) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"注意"
                                                            message:@"将要丢失所有修改"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertview show];
    } else {
        [self cancelModification];
    }
}

- (BOOL)resignFirstResponder {
    [self.tf_nickname resignFirstResponder];
    [self.tv_chiefInfo resignFirstResponder];
    return [super resignFirstResponder];
}

- (IBAction)saveModification:(id)sender {
    if (self.tf_nickname.text.length == 0) {
        MBProgressHUD *hud = [self.view HUDForStaticText:@"昵称不可为空"];
        [hud hide:YES afterDelay:1];
        
        return ;
    }
    
    [self resignFirstResponder];
    [self checkIfModified];
    
    if (__modified == YES) {
        NSString *intro = self.tv_chiefInfo.text.length > 0? [self.tv_chiefInfo.text copy]: @"暂无";
        NSString *userName = [self.tf_nickname.text copy];
        NSString *encoding = @"base64";
        NSString *photo = self.isAvatarChanged? [UIImageJPEGRepresentation([UIImage imageWithImage:self.imgview_avatar.image scaledToSize:CGSizeMake(80, 80)], 1) base64EncodedStringWithOptions:0]: [NSString string];
        
        NSDictionary *updatedInfo = @{@"intro": intro,
                                      @"userName": userName,
                                      @"encoding": encoding,
                                      @"photo": photo};
        
        __weak MBProgressHUD *weakHUD = [self.navigationController.view HUDForLoadingText:nil];
        __weak typeof(self) weakSelf = self;
        [PCNetworkManager updateTheLoggedUserIntro:updatedInfo ok:^(BOOL success) {
            weakHUD.mode = MBProgressHUDModeText;
            if (success == YES) {
                [[PCSelfInformationModel sharedInstance] downloadUserInfo];
                
                weakHUD.labelText = @"修改成功";
                [weakHUD hide:YES afterDelay:1];
                weakSelf.isAvatarChanged = NO;
                weakSelf._modified = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } else {
                weakHUD.labelText = @"修改失败";
                [weakHUD hide:YES afterDelay:1];
            }
        }];
    }
}

- (void)checkIfModified {
    if (![self.old_nickname isEqualToString:_tf_nickname.text] || ![self.old_intro isEqualToString:_tv_chiefInfo.text]) {
        __modified = YES;
    }
}

- (void)cancelModification {
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Protocol - alert view

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        // 确定返回
        [self cancelModification];
    }
}

#pragma mark - Protocol - action sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    } else if (buttonIndex == 1) {
        [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark - Protocol - image picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *edittedImage = info[UIImagePickerControllerEditedImage];
    self.imgview_avatar.image = edittedImage;
    self._modified = YES;
    self.isAvatarChanged = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
