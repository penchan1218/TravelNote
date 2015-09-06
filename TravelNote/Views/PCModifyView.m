//
//  PCModifyView.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/9/3.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCModifyView.h"
#import <QuartzCore/QuartzCore.h>

@interface PCModifyView () {
    CGFloat offset_y_arrow;
    CGFloat height_btn;
    CGFloat width_btn;
}

@property (nonatomic, copy) void (^editBlock)();
@property (nonatomic, copy) void (^deleteBlock)();

@end

@implementation PCModifyView

- (id)initWithEditBlock:(void (^)())editBlock andDeleteBlock:(void (^)())deleteBlock {
    self = [self init];
    if (self) {
        self.editBlock = editBlock;
        self.deleteBlock = deleteBlock;
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        offset_y_arrow = 4.0;
        height_btn = 44.0;
        width_btn = 100.0;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, offset_y_arrow, width_btn, height_btn*2)];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UIButton *btn_edit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width_btn, height_btn)];
    [btn_edit setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [btn_edit setTitle:@"编辑" forState:UIControlStateNormal];
    [btn_edit addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn_edit];
    self.btn_edit = btn_edit;
    
    UIButton *btn_cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, height_btn, width_btn, height_btn)];
    [btn_cancel setTitleColor:UIColorFromRGBA(252, 75, 115, 1.0) forState:UIControlStateNormal];
    [btn_cancel setTitle:@"删除" forState:UIControlStateNormal];
    [btn_cancel addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:btn_cancel];
    self.btn_cancel = btn_cancel;
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, height_btn, width_btn, ONE_PIXEL)];
    separator.backgroundColor = UIColorFromRGBA(160, 160, 160, 0.8);
    [contentView addSubview:separator];
    self.separator = separator;
}

- (void)editAction {
    if (self.editBlock) {
        self.editBlock();
    }
}

- (void)deleteAction {
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

- (void)hide {
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(self._left, self._top, width_btn, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showWithArrowPointing:(CGPoint)point {
    [self showWithArrowPointing:point completionBlock:nil];
}

- (void)showWithArrowPointing:(CGPoint)point completionBlock:(void (^)())completionBlock {
    self.frame = CGRectMake(point.x-offset_y_arrow-width_btn/5*4, point.y, width_btn, 0);
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(self._left, self._top, width_btn, offset_y_arrow+height_btn*2);
        [self layoutIfNeeded];
    }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat width_line = 1.0;
    CGFloat offset_x_arrow = width/5*4;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, UIColorFromRGBA(160, 160, 160, 0.8).CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, width_line);
    
    // 箭头
    CGContextMoveToPoint(context, offset_x_arrow, offset_y_arrow);
    CGContextAddLineToPoint(context, offset_x_arrow+offset_y_arrow, 0);
    CGContextAddLineToPoint(context, offset_x_arrow+offset_y_arrow*2, offset_y_arrow);
    
    // 四周边框
    CGContextAddLineToPoint(context, width-width_line/2, offset_y_arrow);
    CGContextAddLineToPoint(context, width-width_line/2, height-width_line/2);
    CGContextAddLineToPoint(context, width_line/2, height-width_line/2);
    CGContextAddLineToPoint(context, width_line/2, offset_y_arrow);
    CGContextAddLineToPoint(context, offset_x_arrow, offset_y_arrow);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
