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
    
    self.layer.cornerRadius = 4.0f;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1.0f;
    
    NSArray *views = @[_view_note, _view_like, _view_fans, _view_follow];
    for (UIView *view in views) {
        view.layer.borderWidth = 1.0f;
        view.layer.borderColor = borderColor.CGColor;
    }
}

@end
