//
//  PCDisplayModel.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/18.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCDisplayModel.h"

@implementation PCDisplayModel

+ (NSSet *)keySet {
    return [NSSet setWithObjects:@"_id", @"coverKey", @"createTime", @"isFollowing", @"isLiked", @"isPrivate", @"liked", @"temp", @"title", @"userId", @"userImgKey", @"userName", nil];
}

- (id)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if (self) {
        self.cellHeight = 300.0;
    }
    
    return self;
}

@end
