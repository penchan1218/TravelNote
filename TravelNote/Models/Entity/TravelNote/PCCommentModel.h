//
//  PCCommentModel.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/20.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseModel.h"

@interface PCCommentModel : PCBaseModel

@property (nonatomic, copy)     NSNumber    *commentTime;
@property (nonatomic, copy)     NSString    *content;
@property (nonatomic, copy)     NSString    *userId;
@property (nonatomic, copy)     NSString    *userImgKey;
@property (nonatomic, copy)     NSString    *userName;

@end
