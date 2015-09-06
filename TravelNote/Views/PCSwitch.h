//
//  PCSwitch.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/11.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCSwitch : UIControl

@property (weak, nonatomic) UIView *contentView;
@property (weak, nonatomic) UIView *indicator;

@property (nonatomic, assign) BOOL on;

@end
