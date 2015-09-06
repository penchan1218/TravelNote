//
//  PCMessageModel.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/26.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCMessageModel.h"

@implementation PCMessageModel

+ (NSSet *)keySet {
    return [NSSet setWithObjects:@"messageType", @"_id", @"fromId", @"userImgKey", @"userName", @"toId", @"articleId", @"articleTitle", @"content", @"createTime", @"read", nil];
}

- (id)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if (self) {
        self.cellHeight = 90.0;
    }
    
    return self;
}

- (void)setMessageType:(NSString *)messageType {
    if ([messageType isEqualToString:@"like"]) {
        ___messageType = MessageTypeLike;
    } else if ([messageType isEqualToString:@"comment"]) {
        ___messageType = MessageTypeComment;
    } else if ([messageType isEqualToString:@"follow"]) {
        ___messageType = MessageTypeFollow;
    }

}

- (NSString *)messageText {
    switch (___messageType) {
        case MessageTypeLike:
            return [NSString stringWithFormat:@"喜欢了你的游记: %@", self.articleTitle];
        case MessageTypeFollow:
            return @"关注了你的主页!";
        case MessageTypeComment:
            return [NSString stringWithFormat:@"评论了你的游记: %@", self.articleTitle];
        default:
            return @" ";
    }
}

@end
