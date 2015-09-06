//
//  NSDate+MilliSeconds.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/4.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "NSDate+MilliSeconds.h"

@implementation NSDate (MilliSeconds)

+ (NSNumber *)millisecondsFrom1970ByNow {
    return [[NSDate date] millisecondsFrom1970];
}

- (NSNumber *)millisecondsFrom1970 {
    int64_t millisecondsOfLongType = [self timeIntervalSince1970]*1000;
    return @(millisecondsOfLongType);
}

@end
