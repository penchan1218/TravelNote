//
//  PCNetworkManager+Addition.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/6.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCNetworkManager.h"

@interface PCNetworkManager (Addition)

+ (void)getImageThroughKey:(NSString *)key ok:(void (^)(UIImage *, NSString *))block withSizeCut:(CGSize)newSize;

+ (NSURLSessionDataTask *)deleteSingleMessage:(NSString *)messageId ok:(void (^)(BOOL))block;

@end
