//
//  PCAddTitleViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/27.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCAddTitleViewController.h"

@implementation PCAddTitleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    float borderWidth = 1.0f;
    UIColor *borderColor = UIColorFromRGBA(181, 181, 181, 1.0f);
    
    _titleTf.layer.borderWidth = borderWidth;
    _titleTf.layer.borderColor = borderColor.CGColor;
    
    _descriptionTV.layer.borderWidth = borderWidth;
    _descriptionTV.layer.borderColor = borderColor.CGColor;
    
    _descriptionTV.placeHolder = @"简单描述下你的游记咯";
}

- (IBAction)lastAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
