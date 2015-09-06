//
//  PCSearchBar.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/3.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SearchBlock)(NSString *searchTxt);

@interface PCSearchBar : UIView <UITextFieldDelegate>

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, copy, readonly) NSString *text;

+ (PCSearchBar *)searchBarInstanceWithSearchBlock:(SearchBlock)block;

@end
