//
//  PCTravelNoteModel.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/19.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCTravelNoteModel.h"

@implementation PCTravelNoteModel

+ (NSSet *)keySet {
    return [NSSet setWithObjects:@"_id", @"title", @"description", @"createTime", @"userId", @"userName", @"userImgKey", @"coverKey", @"isLiked", @"isPrivate", @"liked", @"temp", nil];
}

- (void)setDescription:(NSString *)_description {
    self._description = _description;
}

- (id)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if (self) {
        if (self.userId != nil) {
            // 获取已登录的人是否已经关注
            __weak typeof(self) weakSelf = self;
            [PCNetworkManager requestLoggedUserIsFollowedTheUser:self.userId ok:^(BOOL isFollowed) {
                weakSelf.isFollowed = isFollowed;
            }];
        }
    }
    return self;
}

@end
