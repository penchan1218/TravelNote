//
//  NSDate+MilliSeconds.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/4.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MilliSeconds)

+ (NSNumber *)millisecondsFrom1970ByNow;

- (NSNumber *)millisecondsFrom1970;

@end
