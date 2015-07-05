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
            imageView.backgroundColor =  imageView.tag == 0?HexColor(0x37393e, 1.0):HexColor(0x1b1d1f, 1.0);
            [imageView touchEndedBlock:^(UIView *selfView) {
                if (i != 2) {
                    for (UIImageView *imageView in imageViews) {
                        imageView.tag = 0;
                        if (imageView == (UIImageView *)selfView) {
                            imageView.tag = 1;
                        }
                        imageView.backgroundColor =  imageView.tag == 0?HexColor(0x37393e, 1.0):HexColor(0x1b1d1f, 1.0);
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
