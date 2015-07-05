//
//  PCPlaceHolderTextField.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/2.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCPlaceHolderTextField.h"

@implementation PCPlaceHolderTextField

- (void)drawPlaceholderInRect:(CGRect)rect {
    NSDictionary *attributesDic = @{NSFontAttributeName: self.font,
                                    NSForegroundColorAttributeName:UIColorFromRGBA(148, 147, 147, 1.0f)};
    CGRect calRect = [self.placeholder boundingRectWithSize:rect.size
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributesDic context:nil];
    calRect.origin.y = (rect.size.height-calRect.size.height)/2;
    
    [[self placeholder] drawWithRect:calRect
                             options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:attributesDic context:nil];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 0);
}

@end
