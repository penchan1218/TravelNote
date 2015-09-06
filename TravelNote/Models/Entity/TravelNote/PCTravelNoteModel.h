//
//  PCTravelNoteModel.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/19.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseModel.h"

@interface PCTravelNoteModel : PCBaseModel

@property (nonatomic, copy)     NSString    *_id;

@property (nonatomic, copy)     NSString    *title;
@property (nonatomic, copy)     NSString    *_description;
@property (nonatomic, copy)     NSNumber    *createTime;
@property (nonatomic, copy)     NSString    *userId;
@property (nonatomic, copy)     NSString    *userName;

@property (nonatomic, copy)     NSString    *userImgKey;
@property (nonatomic, copy)     NSString    *coverKey;

@property (nonatomic, assign)   BOOL        isLiked;
@property (nonatomic, assign)   BOOL        isFollowed;
@property (nonatomic, assign)   BOOL        isPrivate;
@property (nonatomic, assign)   NSInteger   liked;
@property (nonatomic, assign)   NSInteger   temp;

- (void)setDescription:(NSString *)_description;

@end
