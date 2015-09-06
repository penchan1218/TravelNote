//
//  PCGuidanceElement.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/28.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCGuidanceElement.h"

@interface PCGuidanceElement ()

@property (strong, nonatomic) NSArray *arr_imgnames;

@end

@implementation PCGuidanceElement

- (id)initWithGuidingTowards:(TNGuidanceSide)side text:(NSString *)text {
    self = [super init];
    if (self) {
        [self addGuidanceTowards:side withText:text];
    }
    
    return self;
}

- (void)addGuidanceTowards:(TNGuidanceSide)side withText:(NSString *)text {
    UIImageView *imgview_guide = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.arr_imgnames[side]]];
    imgview_guide.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:imgview_guide];
    
    [imgview_guide addConstraint:[NSLayoutConstraint
                                  constraintWithItem:imgview_guide attribute:NSLayoutAttributeWidth
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:imgview_guide attribute:NSLayoutAttributeHeight
                                  multiplier:1.0 constant:0.0]];
    
    UILabel *lbl_guide = [[UILabel alloc] init];
    lbl_guide.textColor = [UIColor whiteColor];
    lbl_guide.font = [UIFont systemFontOfSize:12.0];
    lbl_guide.text = text;
    lbl_guide.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:lbl_guide];
    self.lbl_guide = lbl_guide;
    
    switch (side) {
        case TNGuidanceSideLeft:
            [self addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:@"H:|[imgview_guide(30)][lbl_guide]|"
                                  options:NSLayoutFormatAlignAllCenterY metrics:0
                                  views:NSDictionaryOfVariableBindings(imgview_guide, lbl_guide)]];
            break;
        case TNGuidanceSideRight:
            [self addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:@"H:|[lbl_guide][imgview_guide(30)]|"
                                  options:NSLayoutFormatAlignAllCenterY metrics:0
                                  views:NSDictionaryOfVariableBindings(imgview_guide, lbl_guide)]];
            break;
        case TNGuidanceSideTop:
            [self addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:@"V:|[imgview_guide(30)][lbl_guide]|"
                                  options:NSLayoutFormatAlignAllCenterX metrics:0
                                  views:NSDictionaryOfVariableBindings(imgview_guide, lbl_guide)]];
            break;
        case TNGuidanceSideBottom:
            [self addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:@"V:|[lbl_guide][imgview_guide(30)]|"
                                  options:NSLayoutFormatAlignAllCenterX metrics:0
                                  views:NSDictionaryOfVariableBindings(imgview_guide, lbl_guide)]];
            break;
        default:
            break;
    }
    
    switch (side) {
        case TNGuidanceSideLeft:
        case TNGuidanceSideRight:
            [self addConstraint:[NSLayoutConstraint
                                 constraintWithItem:self attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                 toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:0.0 constant:30]];
            [self addConstraint:[NSLayoutConstraint
                                 constraintWithItem:lbl_guide attribute:NSLayoutAttributeCenterY
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0 constant:0.0]];
            break;
        case TNGuidanceSideTop:
        case TNGuidanceSideBottom:
            [self addConstraint:[NSLayoutConstraint
                                 constraintWithItem:self attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationGreaterThanOrEqual
                                 toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                 multiplier:0.0 constant:30]];
            [self addConstraint:[NSLayoutConstraint
                                 constraintWithItem:lbl_guide attribute:NSLayoutAttributeCenterX
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:self attribute:NSLayoutAttributeCenterX
                                 multiplier:1.0 constant:0.0]];
            break;
        default:
            break;
    }
    

    [self sizeToFit];
}

- (NSArray *)arr_imgnames {
    return @[@"icon_arrow_left",
             @"icon_arrow_right",
             @"icon_arrow_top",
             @"icon_arrow_bottom"];
}

@end
