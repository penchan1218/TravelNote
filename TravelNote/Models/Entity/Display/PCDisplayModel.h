//
//  PCDisplayModel.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/18.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseModel.h"

typedef enum : NSUInteger {
    TNDisplayCellTypeWithTrash,
    TNDisplayCellTypeWithAvatar,
    TNDisplayCellTypeWithoutAvatarOrTrash
} TNDisplayCellType;

@interface PCDisplayModel : PCBaseModel

@property (nonatomic, copy)     NSString    *_id;
@property (nonatomic, copy)     NSString    *coverKey;
@property (nonatomic, copy)     NSNumber    *createTime;
@property (nonatomic, assign)   BOOL        isFollowing;
@property (nonatomic, assign)   BOOL        isLiked;
@property (nonatomic, assign)   BOOL        isPrivate;
@property (nonatomic, assign)   NSInteger   liked;
@property (nonatomic, assign)   NSInteger   temp;
@property (nonatomic, copy)     NSString    *title;
@property (nonatomic, copy)     NSString    *userId;
@property (nonatomic, copy)     NSString    *userImgKey;
@property (nonatomic, copy)     NSString    *userName;

//@property (nonatomic, assign) BOOL hasFollowed;


//@property (nonatomic, assign) TNDisplayCellType displayCellType;
//@property (nonatomic, assign) BOOL knowHasFollowed;

@end
