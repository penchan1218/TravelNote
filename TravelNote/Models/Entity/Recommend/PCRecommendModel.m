//
//  PCRecommendModel.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/19.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCRecommendModel.h"

@implementation PCRecommendModel

+ (NSSet *)keySet {
    return [NSSet setWithObjects:@"userId", @"userImgKey", @"userName", @"isFollowed", @"intro", @"isMyself", @"articles", nil];
}

- (id)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    return self;
}

@end

