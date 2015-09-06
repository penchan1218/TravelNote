//
//  PCPostNotificationCenter.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/24.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const TNShouldUpdateUserInfoNotification = @"TNShouldUpdateUserInfoNotification";

static NSString * const TNCustomTabbarShouldHideNotification = @"TNCustomTabbarShouldHideNotification";
static NSString * const TNCustomTabbarShouldShowNotification = @"TNCustomTabbarShouldShowNotification";

static NSString * const TNHasFollowedSomeoneNotification = @"TNHasFollowedSomeoneNotification";
static NSString * const TNHasUnfollowedSomeoneNotification = @"TNHasUnfollowedSomeoneNotification";

static NSString * const TNHasDeletedOneTravelNoteNotification = @"TNHasDeletedOneTravelNoteNotification";
static NSString * const TNShouldEditOneTravelNoteNotification = @"TNShouldEditOneTravelNoteNotification";

static NSString * const TNHasLikedSomearticleNotification = @"TNHasLikedSomearticleNotification";
static NSString * const TNHasUnlikedSomearticleNotification = @"TNHasUnlikedSomearticleNotification";

static NSString * const TNHasSharedToWechatNotification = @"TNHasSharedToWechatNotification";
static NSString * const TNHasCancelledSharingToWechatNotification = @"TNHasCancelledSharingToWechatNotification";

@interface PCPostNotificationCenter : NSObject

+ (void)postNotification_hideTabbar_withObj:(id)obj;
+ (void)postNotification_showTabbar_withObj:(id)obj;

+ (void)postNotification_updateUserInfo_withObj:(id)obj;

+ (void)postNotification_followSomeone_withObj:(id)obj userId:(NSString *)userId;
+ (void)postNotification_unfollowSomeone_withObj:(id)obj userId:(NSString *)userId;

+ (void)postNotification_deleteOneTravelNote_withObj:(id)obj articleId:(NSString *)articleId;
+ (void)postNotification_editOneTravelNote_withObj:(id)obj articleId:(NSString *)articleId;

+ (void)postNotification_likeSomearticle_withObj:(id)obj articleId:(NSString *)articleId;
+ (void)postNotification_unlikeSomearticle_withObj:(id)obj articleId:(NSString *)articleId;

+ (void)postNotification_shareToWechat_withObj:(id)obj;
+ (void)postNotification_cancelSharingToWechat_withObj:(id)obj;

@end
