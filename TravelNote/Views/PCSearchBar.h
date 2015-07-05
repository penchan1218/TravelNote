//
//  PCSearchBar.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/3.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCSearchBar : UIView <UITextFieldDelegate>

@property (nonatomic, copy) NSString *placeHolder;

+ (PCSearchBar *)searchBarInstance;

@end
