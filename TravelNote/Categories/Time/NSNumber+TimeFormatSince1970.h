//
//  NSNumber+TimeFormatSince1970.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/23.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (TimeFormatSince1970)

- (NSDate *)toDate;

- (NSString *)textMessage;

@end
