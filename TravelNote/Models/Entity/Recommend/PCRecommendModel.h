//
//  PCRecommendModel.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/19.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseModel.h"

@interface PCRecommendModel : PCBaseModel

// 包括最多不超过3组 _id : coverKey 键值对
@property (nonatomic, strong)   NSMutableArray  *articles;

@property (nonatomic, copy)     NSString        *intro;
@property (nonatomic, assign)   BOOL            isFollowed;
@property (nonatomic, assign)   BOOL            isMyself;
@property (nonatomic, copy)     NSString        *userId;
@property (nonatomic, copy)     NSString        *userImgKey;
@property (nonatomic, copy)     NSString        *userName;

@end
