//
//  NSString+TimeFormmat.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/20.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "NSString+TimeFormmat.h"

@implementation NSString (TimeFormmat)

- (NSDate *)toDate {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    });
    
    return [dateFormatter dateFromString:self];
}

@end
