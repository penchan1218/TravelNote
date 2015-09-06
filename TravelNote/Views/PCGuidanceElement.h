//
//  PCGuidanceElement.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/28.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TNGuidanceSideLeft = 0,
    TNGuidanceSideRight = 1,
    TNGuidanceSideTop = 2,
    TNGuidanceSideBottom = 3
} TNGuidanceSide;

@interface PCGuidanceElement : UIView

@property (weak, nonatomic) UILabel *lbl_guide;

- (id)initWithGuidingTowards:(TNGuidanceSide)side text:(NSString *)text;

@end
