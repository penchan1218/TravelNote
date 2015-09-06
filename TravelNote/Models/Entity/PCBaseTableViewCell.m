//
//  PCBaseTableViewCell.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/31.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseTableViewCell.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

@implementation UIImageView (SetImageAttachment)

//+ (void)load {
//    Method setImage = class_getInstanceMethod(self, @selector(setImage:));
//    Method newSetImage = class_getInstanceMethod(self, @selector(replacementOfSettingImage:));
//    
//    method_exchangeImplementations(setImage, newSetImage);
//}
//
//- (void)replacementOfSettingImage:(UIImage *)image {
//    [self replacementOfSettingImage:image];

//    BOOL isSubviewOfCell = NO;
//    __weak id superview = self.superview;
//    while (superview != nil && superview != NULL && superview != [NSNull null]) {
//        if ([superview isKindOfClass:[UITableViewCell class]]) {
//            isSubviewOfCell = YES;
//            break;
//        }
//        superview = ((UIView *)superview).superview;
//        NSLog(@"%@", superview);
//    }
//    if (isSubviewOfCell == YES) {
//        if (image == nil) {
//            [self.layer removeAllAnimations];
//            self.alpha = 0.0f;
//        } else {
//            [UIView animateWithDuration:0.4 animations:^{
//                self.alpha = 1.0f;
//            }];
//        }
//    }
//}

@end

@implementation PCBaseTableViewCell

- (void)clearAllElements {}

- (void)hide {
    [self.layer removeAllAnimations];
    self.alpha = 0.0f;
}

- (void)show {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1.0f;
    }];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    
    self.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, -1, -1) cornerRadius:1.0f].CGPath;
}

@end
