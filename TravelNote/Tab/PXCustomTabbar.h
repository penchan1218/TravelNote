//
//  PXCustomTabbar.h
//  TravelNote
//
//  Created by 朱泌丞 on 15/6/9.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXCustomTabbar : UIView
- (instancetype)initWithFrame:(CGRect)frame TapAction:(void(^)(NSInteger index))tapAction;
@end
