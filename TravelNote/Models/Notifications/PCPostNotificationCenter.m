//
//  PCPostNotificationCenter.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/24.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCPostNotificationCenter.h"

@implementation PCPostNotificationCenter

+ (void)postNotification_hideTabbar_withObj:(id)obj {
    [[NSNotificationCenter defaultCenter] postNotificationName:TNCustomTabbarShouldHideNotification
                                                        object:obj userInfo:nil];
}

+ (void)postNotification_showTabbar_withObj:(id)obj {
    [[NSNotificationCenter defaultCenter] postNotificationName:TNCustomTabbarShouldShowNotification
                                                        object:obj userInfo:nil];
}

+ (void)postNotification_updateUserInfo_withObj:(id)obj {
    [[NSNotificationCenter defaultCenter] postNotificationName:TNShouldUpdateUserInfoNotification
                                                        object:obj userInfo:nil];
}

+ (void)postNotification_followSomeone_withObj:(id)obj userId:(NSString *)userId {
    if (!userId) {
        NSLog(@"关注某人而缺失userId");
        return ;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TNHasFollowedSomeoneNotification
                                                        object:obj userInfo:@{@"userId": userId}];
}

+ (void)postNotification_unfollowSomeone_withObj:(id)obj userId:(NSString *)userId {
    if (!userId) {
        NSLog(@"取消关注某人而缺失userId");
        return ;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TNHasUnfollowedSomeoneNotification
                                                        object:obj userInfo:@{@"userId": userId}];
}

+ (void)postNotification_deleteOneTravelNote_withObj:(id)obj articleId:(NSString *)articleId {
    if (!articleId) {
        NSLog(@"删除游记而缺失articleId");
        return ;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TNHasDeletedOneTravelNoteNotification
                                                        object:obj userInfo:@{@"articleId": articleId}];
}

+ (void)postNotification_editOneTravelNote_withObj:(id)obj articleId:(NSString *)articleId {
    if (!articleId) {
        NSLog(@"编辑游记而缺失articleId");
        return ;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TNShouldEditOneTravelNoteNotification object:obj userInfo:@{@"articleId": articleId}];
}

+ (void)postNotification_likeSomearticle_withObj:(id)obj articleId:(NSString *)articleId {
    if (!articleId) {
        NSLog(@"喜欢游记而缺失articleId");
        return ;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TNHasLikedSomearticleNotification
                                                        object:obj userInfo:@{@"articleId": articleId}];
}

+ (void)postNotification_unlikeSomearticle_withObj:(id)obj articleId:(NSString *)articleId {
    if (!articleId) {
        NSLog(@"取消喜欢游记而缺失articleId");
        return ;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TNHasUnlikedSomearticleNotification
                                                        object:obj userInfo:@{@"articleId": articleId}];
}

+ (void)postNotification_shareToWechat_withObj:(id)obj {
    [[NSNotificationCenter defaultCenter] postNotificationName:TNHasSharedToWechatNotification object:obj userInfo:nil];
}

+ (void)postNotification_cancelSharingToWechat_withObj:(id)obj {
    [[NSNotificationCenter defaultCenter] postNotificationName:TNHasCancelledSharingToWechatNotification object:obj userInfo:nil];
}

@end
