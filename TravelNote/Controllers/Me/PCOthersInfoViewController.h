//
//  PCOthersInfoViewController.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/29.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseMyInfoViewController.h"

@interface PCOthersInfoViewController : PCBaseMyInfoViewController

@property (weak, nonatomic) UIButton *btn_follow;
@property (weak, nonatomic) UIActivityIndicatorView *indicator_follow;

@property (nonatomic, assign) BOOL hasFollow;

@end
