//
//  NSNumber+TimeFormatSince1970.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/23.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "NSNumber+TimeFormatSince1970.h"
#import "NSDate+MilliSeconds.h"

@implementation NSNumber (TimeFormatSince1970)

- (NSDate *)toDate {
    long long millisecond = [self longLongValue];
    NSTimeInterval interval = millisecond/1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

- (NSString *)textMessage {
    NSTimeInterval seconds = ([[NSDate millisecondsFrom1970ByNow] doubleValue] - [self doubleValue]) / 1000;
    NSTimeInterval minutes = seconds / 60;
    NSTimeInterval hours = minutes / 60;
    NSTimeInterval days = hours / 24;
    
    NSString *textMsg = nil;
    
    if (days >= 1) {
        textMsg = [NSString stringWithFormat:@"%ld天前", (unsigned long)days];
    } else if (hours >= 1) {
        textMsg = [NSString stringWithFormat:@"%ld小时前", (unsigned long)hours];
    } else if (minutes >= 1) {
        textMsg = [NSString stringWithFormat:@"%ld分钟前", (unsigned long)minutes];
    } else {
        textMsg = [NSString stringWithFormat:@"%ld秒前", (unsigned long)seconds];
    }
    
    return textMsg;
}

@end
