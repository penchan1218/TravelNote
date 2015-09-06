//
//  PCAddTitleViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/27.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCAddTitleViewController.h"
#import "PCTravelNoteCreator.h"
#import "UIView+BGTouchView.h"
#import "PCBaseImagePickerController.h"

@interface PCAddTitleViewController ()

@property (nonatomic, assign)   BOOL    didSelectCover;

@property (strong, nonatomic)   UIImage *coverImg;

@end

@implementation PCAddTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.didSelectCover = NO;
    
    UIColor *borderColor = UIColorFromRGBA(181, 181, 181, 1.0f);
    
    _titleTf.layer.borderColor = borderColor.CGColor;
    _descriptionTV.layer.borderColor = borderColor.CGColor;
    _imageview_cover.layer.borderColor = borderColor.CGColor;
    
    _descriptionTV.placeHolder = @"简单描述下你的游记咯";
    
    __weak typeof(self) weakSelf = self;
    [self.imageview_cover touchEndedBlock:^(UIView *selfView) {
        [weakSelf willSelectCover];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.titleTf resignFirstResponder];
    [self.descriptionTV resignFirstResponder];
}

- (void)willSelectCover {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择封面"
                                                    delegate:self
                                           cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                           otherButtonTitles:@"拍照", @"从相册中获取", nil];
    [as showInView:self.view];
}

- (IBAction)lastAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextAction:(id)sender {

    [self.titleTf resignFirstResponder];
    [self.descriptionTV resignFirstResponder];
    
    if (self.titleTf.text.length == 0) {
        MBProgressHUD *hud = [self.navigationController.view HUDForStaticText:@"为游记起个标题吧"];
        [hud hide:YES afterDelay:1];
        
        return ;
    }
    
    if (self.didSelectCover == NO) {
        MBProgressHUD *hud = [self.navigationController.view HUDForStaticText:@"请选择一个封面"];
        [hud hide:YES afterDelay:1];
        
        return ;
    }
    
    [PCTravelNoteCreator shared].title = self.titleTf.text;
    [PCTravelNoteCreator shared]._description = self.descriptionTV.text;
    [PCTravelNoteCreator shared].cover = self.coverImg;
    
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TNChoosePhotosController"] animated:YES];
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType {
    PCBaseImagePickerController *picker = [[PCBaseImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    
    [self presentViewController:picker animated:YES completion:nil];
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
    self.imageview_cover.image = edittedImage;
    self.imageview_cover.contentMode = UIViewContentModeScaleAspectFill;
    self.didSelectCover = YES;
    self.coverImg = edittedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
