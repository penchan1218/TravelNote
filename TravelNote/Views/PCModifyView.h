//
//  PCModifyView.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/9/3.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCModifyView : UIView

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIView *separator;

@property (nonatomic, weak) UIButton *btn_edit;
@property (nonatomic, weak) UIButton *btn_cancel;

- (id)initWithEditBlock:(void (^)())editBlock andDeleteBlock:(void (^)())deleteBlock;

- (void)showWithArrowPointing:(CGPoint)point;
- (void)hide;

@end
