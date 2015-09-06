//
//  PCPlaceHolderTextField.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/2.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCPlaceHolderTextField.h"

@interface PCPlaceHolderTextField () {
    UIColor *__placeHolderColor;
    float __inset;
}

@end

@implementation PCPlaceHolderTextField

- (void)drawPlaceholderInRect:(CGRect)rect {
    NSDictionary *attributesDic = @{NSFontAttributeName: self.font,
                                    NSForegroundColorAttributeName: __placeHolderColor==nil? UIColorFromRGBA(148, 147, 147, 1.0f): __placeHolderColor};
    CGRect calRect = [self.placeholder boundingRectWithSize:rect.size
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributesDic context:nil];
    calRect.origin.y = (rect.size.height-calRect.size.height)/2;
    
    [[self placeholder] drawWithRect:calRect
                             options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:attributesDic context:nil];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, __inset==0? 10: __inset, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, __inset==0? 10: __inset, 0);
}

- (void)setPlaceholderColor:(UIColor *)color {
    __placeHolderColor = color;
    [self setNeedsDisplay];
}

- (void)setPlaceholderInset:(float)inset {
    __inset = inset;
    [self setNeedsDisplay];
}

@end
