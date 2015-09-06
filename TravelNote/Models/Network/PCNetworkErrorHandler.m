//
//  PCNetworkErrorHandler.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/20.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCNetworkErrorHandler.h"
#import "PCNetworkManager.h"

@implementation PCNetworkErrorHandler

+ (PCNetworkErrorHandler *)sharedHandler {
    static PCNetworkErrorHandler *__sharedHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedHandler = [[PCNetworkErrorHandler alloc] init];
    });
    return __sharedHandler;
}

- (void)handleError:(NSError *)error ok:(void (^)())block {
    NSLog(@"error code : %ld", (unsigned long)error.code);
//    if (error.code == -1009) {
//        if () {
//            <#statements#>
//        }
//    }
    if ([error.localizedDescription isEqualToString:@"Request failed: forbidden (403)"]) {
        [PCNetworkManager __privateLoginWithOK:^{
            if (block != nil) {
                block();
            }
        }];
    }
}

@end
