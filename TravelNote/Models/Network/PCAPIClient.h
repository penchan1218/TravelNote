//
//  PCAPIClient.h
//  TravelNoteAPITesting
//
//  Created by 陈颖鹏 on 15/7/17.
//  Copyright (c) 2015年 hustunique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

static NSString * const TNBaseURLString = @"http://travel.changjiangcp.com";
static NSString * const TNAPIBaseURLString = @"http://travel.changjiangcp.com/api/";

@interface PCAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
