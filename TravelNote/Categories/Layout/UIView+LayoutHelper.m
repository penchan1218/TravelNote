//
//  UIView+LayoutHelper.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/26.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "UIView+LayoutHelper.h"

@implementation UIView (LayoutHelper)

- (NSLayoutConstraint *)fixedBottom {
    for (NSLayoutConstraint *constraint in self.superview.constraints) {
        if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeBottom &&
            constraint.secondItem == self.superview && constraint.secondAttribute == NSLayoutAttributeBottom) {
            [self logWarningText:@"fixed bottom或许是相反的。"];
            return constraint;
        }
        if (constraint.firstItem == self.superview && constraint.firstAttribute == NSLayoutAttributeBottom &&
            constraint.secondItem == self && constraint.secondAttribute == NSLayoutAttributeBottom) {
            return constraint;
        }
    }
    
    [self logWarningText:@"fixed bottom不存在。"];
    return nil;
}

//- (NSLayoutConstraint *)fixedHeigt {
//    for (NSLayoutConstraint *constraint in self.constraints) {
//        if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeHeight &&
//            constraint.) {
//            
//        }
//    }
//}

@end
