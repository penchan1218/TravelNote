//
//  PCSwitch.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/11.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCSwitch.h"

@interface PCSwitch () {
    NSLayoutConstraint *__cons_indicatorOn;
    NSLayoutConstraint *__cons_indicatorNotOn;
    
    BOOL __firstTimeSetting;
}

@end

@implementation PCSwitch

- (id)init {
    self = [super init];
    if (self) {
        __firstTimeSetting = YES;
        
        float inset = 3.0f;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [[UIView alloc] init];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.backgroundColor = [UIColor whiteColor];
        contentView.layer.borderColor = UIColorFromRGBA(221, 221, 221, 1.0f).CGColor;
        contentView.layer.borderWidth = 1.0f;
        contentView.userInteractionEnabled = NO;
        [self addSubview:contentView];
        _contentView = contentView;
        
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:contentView attribute:NSLayoutAttributeCenterX
                             relatedBy:NSLayoutRelationEqual
                             toItem:self attribute:NSLayoutAttributeCenterX
                             multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:contentView attribute:NSLayoutAttributeCenterY
                             relatedBy:NSLayoutRelationEqual
                             toItem:self attribute:NSLayoutAttributeCenterY
                             multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:contentView attribute:NSLayoutAttributeWidth
                             relatedBy:NSLayoutRelationEqual
                             toItem:self attribute:NSLayoutAttributeWidth
                             multiplier:1.0f constant:0.0f]];
        [self addConstraint:[NSLayoutConstraint
                             constraintWithItem:contentView attribute:NSLayoutAttributeHeight
                             relatedBy:NSLayoutRelationEqual
                             toItem:self attribute:NSLayoutAttributeHeight
                             multiplier:0.5f constant:0.0f]];
        
        UIView *indicator = [[UIView alloc] init];
        indicator.translatesAutoresizingMaskIntoConstraints = NO;
        indicator.userInteractionEnabled = NO;
        indicator.backgroundColor = THEME_COLOR;
        [_contentView addSubview:indicator];
        _indicator = indicator;
        
        [contentView addConstraints:[NSLayoutConstraint
                                     constraintsWithVisualFormat:@"V:|-(inset)-[indicator]-(inset)-|" options:0
                                     metrics:@{@"inset": @(inset)} views:NSDictionaryOfVariableBindings(indicator)]];
        [indicator addConstraint:[NSLayoutConstraint
                                constraintWithItem:indicator attribute:NSLayoutAttributeWidth
                                relatedBy:NSLayoutRelationEqual
                                toItem:indicator attribute:NSLayoutAttributeHeight
                                multiplier:1.0f constant:0.0f]];
        __cons_indicatorNotOn = [NSLayoutConstraint
                                 constraintWithItem:indicator attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:contentView attribute:NSLayoutAttributeLeading
                                 multiplier:1.0f constant:inset];
        __cons_indicatorOn = [NSLayoutConstraint
                              constraintWithItem:contentView attribute:NSLayoutAttributeTrailing
                              relatedBy:NSLayoutRelationEqual
                              toItem:indicator attribute:NSLayoutAttributeTrailing
                              multiplier:1.0f constant:inset];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tapGesture];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            contentView.layer.cornerRadius = contentView.frame.size.height/2;
            indicator.layer.cornerRadius = indicator.frame.size.width/2;
        });
    }
    return self;
}

- (void)setOn:(BOOL)on {
    if (__firstTimeSetting == YES) {
        
        _on = on;
        if (_on == YES) {
            [UIView animateWithDuration:0.1 animations:^{
                [_contentView addConstraint:__cons_indicatorOn];
                [_contentView layoutIfNeeded];
                _indicator.backgroundColor = THEME_COLOR;
            }];
        } else {
            [UIView animateWithDuration:0.1 animations:^{
                [_contentView addConstraint:__cons_indicatorNotOn];
                [_contentView layoutIfNeeded];
                _indicator.backgroundColor = UIColorFromRGBA(221, 221, 221, 1.0f);
            }];
        }
        __firstTimeSetting = NO;
        return ;
    }
    
    if (_on == on) {
        return ;
    }
    
    _on = on;
    if (_on == YES) {
        [UIView animateWithDuration:0.1 animations:^{
            [_contentView removeConstraint:__cons_indicatorNotOn];
            [_contentView addConstraint:__cons_indicatorOn];
            [_contentView layoutIfNeeded];
            _indicator.backgroundColor = THEME_COLOR;
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            [_contentView removeConstraint:__cons_indicatorOn];
            [_contentView addConstraint:__cons_indicatorNotOn];
            [_contentView layoutIfNeeded];
            _indicator.backgroundColor = UIColorFromRGBA(221, 221, 221, 1.0f);
        }];
    }
}


- (void)tapAction {
    self.on = !self.on;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
