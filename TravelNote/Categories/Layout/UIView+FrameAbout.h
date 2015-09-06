//
//  UIView+FrameAbout.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/30.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameAbout)

@property (nonatomic, assign) CGFloat _left;
@property (nonatomic, assign) CGFloat _right;
@property (nonatomic, assign) CGFloat _top;
@property (nonatomic, assign) CGFloat _bottom;

@property (nonatomic, assign) CGPoint _leftTop;
@property (nonatomic, assign) CGPoint _leftBottom;
@property (nonatomic, assign) CGPoint _rightTop;
@property (nonatomic, assign) CGPoint _rightBottom;

@property (nonatomic, assign, readonly) CGFloat _width;
@property (nonatomic, assign, readonly) CGFloat _height;

@end
