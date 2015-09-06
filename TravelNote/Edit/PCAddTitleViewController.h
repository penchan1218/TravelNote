//
//  PCAddTitleViewController.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/27.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPlaceHolderTextView.h"

@interface PCAddTitleViewController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UITextField *titleTf;
@property (weak, nonatomic) IBOutlet PCPlaceHolderTextView *descriptionTV;
@property (weak, nonatomic) IBOutlet UIImageView *imageview_cover;

@end
