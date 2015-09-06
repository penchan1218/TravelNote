//
//  UIView+HUDHelper.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/4.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "UIView+HUDHelper.h"

@implementation UIView (HUDHelper)

- (MBProgressHUD *)HUDForStaticText:(NSString *)text {
    MBProgressHUD *hud = [self HUDForDefaultText:text];
    hud.mode = MBProgressHUDModeText;
    return hud;
}

- (MBProgressHUD *)HUDForLoadingText:(NSString *)text {
    return [self HUDForDefaultText:text];
}

- (MBProgressHUD *)HUDForDefaultText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = text;
    return hud;
}

@end
