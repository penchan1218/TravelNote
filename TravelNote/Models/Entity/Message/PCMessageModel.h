//
//  PCMessageModel.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/26.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseModel.h"

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeLike,
    MessageTypeComment,
    MessageTypeFollow
};

@interface PCMessageModel : PCBaseModel

@property (nonatomic, copy)     NSString    *messageType;
@property (nonatomic, copy)     NSString    *_id;
@property (nonatomic, copy)     NSString    *fromId;
@property (nonatomic, copy)     NSString    *userImgKey;
@property (nonatomic, copy)     NSString    *userName;
@property (nonatomic, copy)     NSString    *toId;
@property (nonatomic, copy)     NSString    *articleId;
@property (nonatomic, copy)     NSString    *articleTitle;
@property (nonatomic, copy)     NSString    *content;
@property (nonatomic, copy)     NSNumber    *createTime;
@property (nonatomic, assign)   BOOL        read;


@property (nonatomic, assign, readonly)     MessageType     __messageType;
@property (nonatomic, copy, readonly)       NSString        *messageText;

@end
