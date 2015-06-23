//
//  NSObject+PCLog.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/23.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "NSObject+PCLog.h"

@implementation NSObject (PCLog)

- (void)logWarningText:(NSString *)text {
    NSMutableString *log = [NSMutableString stringWithFormat:@"\n\n--------!Warning!--------from <%@>\n", NSStringFromClass([self class])];
    if (text != nil) {
        [log appendString:[NSString stringWithFormat:@"%@\n\n", text]];
    }
    
    NSLog(@"%@", log);
}

@end
