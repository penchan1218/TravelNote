//
//  PCPlaceHolderTextView.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/2.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCPlaceHolderTextView.h"

@interface PCPlaceHolderTextView () {
    UIFont *__textFont;
    UIEdgeInsets __textInsets;
}

@property (weak, nonatomic) UILabel *placeHolderLabel;

@end

@implementation PCPlaceHolderTextView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        float inset = 5.0f;
        UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset*2, inset, self.frame.size.width-inset*4, self.frame.size.height-inset*2)];
        __textInsets = UIEdgeInsetsMake(inset, inset, inset, inset);
        self.textContainerInset = __textInsets;
        
        // 设置label默认属性
        placeHolderLabel.userInteractionEnabled = NO;
        placeHolderLabel.adjustsFontSizeToFitWidth = YES;
        placeHolderLabel.textColor = UIColorFromRGBA(148, 147, 147, 1.0f);
        placeHolderLabel.font = __textFont;
        
        [self addSubview:placeHolderLabel];
        _placeHolderLabel = placeHolderLabel;
        
        self.delegate = self;
    }
    return self;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    if (_placeHolderLabel != nil) {
        _placeHolderLabel.font = font;
    } else {
        __textFont = font;
    }
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    if (__textInsets.top  == textContainerInset.top &&
        __textInsets.left == textContainerInset.left) {
        [super setTextContainerInset:textContainerInset];
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = [placeHolder copy];
    _placeHolderLabel.text = placeHolder;
    [_placeHolderLabel sizeToFit];
}

#pragma mark - Protocol - text view

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSMutableString *modifiedStr = [NSMutableString stringWithString:textView.text];
    [modifiedStr replaceCharactersInRange:range withString:text];
    
    if (modifiedStr.length == 0) {
        _placeHolderLabel.alpha = 1.0f;
    } else {
        _placeHolderLabel.alpha = 0.0f;
    }
    
    return YES;
}

@end
