//
//  UIView+HUDHelper.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/4.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface UIView (HUDHelper)

- (MBProgressHUD *)HUDForStaticText:(NSString *)text;

- (MBProgressHUD *)HUDForLoadingText:(NSString *)text;

@end
