//
//  PCSingleNoteModel.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/3.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCSingleNoteModel.h"
#import "NSDate+MilliSeconds.h"

@implementation PCSingleNoteModel

+ (NSSet *)keySet {
    return [NSSet setWithObjects:@"pic", @"intro", @"pageIndex", @"timeStamp", nil];
}

- (NSDictionary *)presentation {
    return @{@"pic": self.pic? self.pic: [NSString string],
             @"intro": self.intro? self.intro: [NSString string],
             @"pageIndex": self.pageIndex? self.pageIndex: @(2), // 因为第一个不能是1，所以默认为2
             @"timeStamp": self.timeStamp? self.timeStamp: [NSDate millisecondsFrom1970ByNow]};
}

@end
