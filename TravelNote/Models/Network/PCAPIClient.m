//
//  PCAPIClient.m
//  TravelNoteAPITesting
//
//  Created by 陈颖鹏 on 15/7/17.
//  Copyright (c) 2015年 hustunique. All rights reserved.
//

#import "PCAPIClient.h"

@implementation PCAPIClient

+ (instancetype)sharedClient {
    static PCAPIClient *__sharedClient = nil;
    static dispatch_once_t onceToke;
    
    dispatch_once(&onceToke, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.HTTPCookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
        config.HTTPShouldSetCookies = YES;
        __sharedClient = [[PCAPIClient alloc] initWithBaseURL:[NSURL URLWithString:TNAPIBaseURLString]
                                         sessionConfiguration:config];
    });
    
    return __sharedClient;
}

@end
