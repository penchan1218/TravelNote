//
//  PXCustomTabbar.m
//  TravelNote
//
//  Created by 朱泌丞 on 15/6/9.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PXCustomTabbar.h"
#import "UIView+BGTouchView.h"

@implementation PXCustomTabbar{
    NSArray *_images;
    NSArray *_titles;
}
- (instancetype)initWithFrame:(CGRect)frame TapAction:(void(^)(NSInteger index))tapAction{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGBA(50, 55, 60, 1.0f);
        self.clipsToBounds = NO;
        
        _images = @[@"mainpage",
                    @"compass",
                    @"camera",
                    @"message",
                    @"user",
                    ];
        _titles = @[@"首页",
                    @"发现",
                    @"相机",
                    @"消息",
                    @"我的"];
        
        float radius_center = 30.0f;
        float width_normal = (frame.size.width/2-radius_center)/2;
        
        UIImageView *centerImageView;
        
        NSMutableArray *containerViews = [NSMutableArray array];
        for (NSInteger i = 0; i < 5; i++) {
            UIView *containerView;
            if (i < 2) {
                containerView = [[UIView alloc] initWithFrame:CGRectMake(i * width_normal, 0,
                                                                         width_normal, frame.size.height)];
            } else if (i == 2) {
                containerView = [[UIView alloc] initWithFrame:CGRectMake(width_normal*2, frame.size.height-radius_center*2,
                                                                         radius_center*2, radius_center*2)];
                containerView.layer.cornerRadius = radius_center;
                containerView.backgroundColor = UIColorFromRGBA(50, 55, 60, 1.0f);
            } else {
                containerView = [[UIView alloc] initWithFrame:CGRectMake((i-1)*width_normal + radius_center*2, 0,
                                                                         width_normal, frame.size.height)];
            }
            [self addSubview:containerView];
            [containerViews addObject:containerView];
        }
        
        for (NSInteger i = 0; i < 5; i++) {
            UIView *containerView = containerViews[i];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:_images[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
            UILabel *label;
            imageView.tag = 1000;
            imageView.tintColor = i==0 || i==2? [UIColor whiteColor]: UIColorFromRGBA(175, 176, 178, 1.0f);
            imageView.contentMode = UIViewContentModeCenter;
            [containerView addSubview:imageView];
            if (i == 2) {
                centerImageView = imageView;
                imageView.frame = CGRectMake(5, 5, radius_center*2-10, radius_center*2-10);
                imageView.backgroundColor = THEME_COLOR;
                label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.tag = 1001;
                [containerView addSubview:label];
            } else {
                imageView.translatesAutoresizingMaskIntoConstraints = NO;
                label = [[UILabel alloc] init];
                label.tag = 1001;
                label.textColor = i==0? [UIColor whiteColor]: UIColorFromRGBA(175, 176, 178, 1.0f);
                label.font = [UIFont systemFontOfSize:10.0f];
                label.translatesAutoresizingMaskIntoConstraints = NO;
                label.text = _titles[i];
                [containerView addSubview:label];
                
                [containerView addConstraints:[NSLayoutConstraint
                                               constraintsWithVisualFormat:@"V:|-5-[imageView(25)]-5-[label]-5-|"
                                               options:NSLayoutFormatAlignAllCenterX metrics:nil
                                               views:NSDictionaryOfVariableBindings(imageView, label)]];
                [containerView addConstraint:[NSLayoutConstraint
                                              constraintWithItem:imageView attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                              toItem:containerView attribute:NSLayoutAttributeCenterX
                                              multiplier:1.0f constant:0.0f]];
                [imageView addConstraint:[NSLayoutConstraint
                                          constraintWithItem:imageView attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:imageView attribute:NSLayoutAttributeHeight
                                          multiplier:1.0f constant:0.0f]];
            }
            
            [containerView touchEndedBlock:^(UIView *selfView) {
                if (i != 2) {
                    for (NSInteger j = 0; j < 5; j++) {
                        if (j == 2) {
                            continue;
                        }
                        UIView *view = containerViews[j];
                        UIImageView *imgview = (UIImageView *)[view viewWithTag:1000];
                        UILabel *lbl = (UILabel *)[view viewWithTag:1001];
                        if (view == selfView) {
                            imgview.tintColor = [UIColor whiteColor];
                            lbl.textColor = [UIColor whiteColor];
                        } else {
                            imgview.tintColor = UIColorFromRGBA(175, 176, 178, 1.0f);
                            lbl.textColor = UIColorFromRGBA(175, 176, 178, 1.0f);
                        }
                    }
                }
                tapAction(i);
            }];

        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            centerImageView.layer.cornerRadius = centerImageView.frame.size.width/2;
        });
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
