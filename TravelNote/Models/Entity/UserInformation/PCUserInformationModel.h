//
//  PCUserInformationModel.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/20.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCNetworkManager+Addition.h"

@interface PCUserInformationModel : NSObject

@property (nonatomic, copy)     NSString    *userId;

@property (nonatomic, copy)     NSString    *_id;
@property (nonatomic, copy)     NSString    *openid;
@property (nonatomic, copy)     NSString    *unionid;
@property (nonatomic, copy)     NSString    *groupid;

@property (nonatomic, copy)     NSNumber    *heartCount;
@property (nonatomic, copy)     NSNumber    *articleCount;
@property (nonatomic, copy)     NSNumber    *fansCount;
@property (nonatomic, copy)     NSNumber    *followingCount;
@property (nonatomic, copy)     NSNumber    *currTemp;
@property (nonatomic, copy)     NSNumber    *subscribe_time;

@property (nonatomic, copy)     NSString    *nickname;
@property (nonatomic, copy)     NSString    *intro;
@property (nonatomic, copy)     NSString    *language;
@property (nonatomic, copy)     NSString    *remark;
@property (nonatomic, copy)     NSString    *country;
@property (nonatomic, copy)     NSString    *province;
@property (nonatomic, copy)     NSString    *city;

@property (nonatomic, copy)     NSString    *headImgKey;
@property (nonatomic, copy)     NSString    *bgKey;

@property (strong, nonatomic)   NSArray     *followed;

@property (nonatomic, assign)   BOOL        sex;
@property (nonatomic, assign)   BOOL        isCurrUser;
@property (nonatomic, assign)   BOOL        subscribe;

@property (strong, nonatomic)   UIImage     *userImg;



+ (NSSet *)keySet;



- (id)initWithUserId:(NSString *)userId;
- (void)downloadUserInfo;
- (void)downloadUserImg;
- (void)updateInfo:(NSDictionary *)info;
- (void)updateUserImg:(UIImage *)userImg;
- (void)updateView;
- (void)synchronize;

@end
