//
//  PXCustomTabbar.m
//  TravelNote
//
//  Created by 朱泌丞 on 15/6/9.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PXCustomTabbar.h"
#import "UIView+BGTouchView.h"
#define HexColor(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation PXCustomTabbar{
    NSArray *_images;
}
- (instancetype)initWithFrame:(CGRect)frame TapAction:(void(^)(NSInteger index))tapAction{
    self = [super initWithFrame:frame];
    if (self) {
        _images = @[@"mainpage",
                    @"compass",
                    @"camera",
                    @"message",
                    @"user",
                    ];
        float width = self.frame.size.width / 5.0f;
        NSMutableArray *imageViews = [NSMutableArray array];
        
        for (int i = 0; i < 5 ;i++){
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_images[i]]];
            [imageViews addObject:imageView];
            imageView.frame = CGRectMake(i * width, 0, width, self.frame.size.height);
            imageView.contentMode = UIViewContentModeCenter;
            imageView.tag = i==0?1:0;
            imageView.backgroundColor =  imageView.tag == 0?HexColor(0x37393e):HexColor(0x1b1d1f);
            [imageView touchEndedBlock:^(UIView *selfView) {
                if (i != 2) {
                    for (UIImageView *imageView in imageViews) {
                        imageView.tag = 0;
                        if (imageView == (UIImageView *)selfView) {
                            imageView.tag = 1;
                        }
                        imageView.backgroundColor =  imageView.tag == 0?HexColor(0x37393e):HexColor(0x1b1d1f);
                    }
                }
                tapAction(i);
            }];
            [self addSubview:imageView];
        }
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
