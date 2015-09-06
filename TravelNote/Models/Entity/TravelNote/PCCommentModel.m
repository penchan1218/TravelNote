//
//  PCCommentModel.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/20.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCCommentModel.h"

@implementation PCCommentModel

+ (NSSet *)keySet {
    return [NSSet setWithObjects:@"commentTime", @"content", @"userId", @"userImgKey", @"userName", nil];
}

- (id)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if (self) {
        self.cellHeight = 84.0;
    }
    
    return self;
}

@end
