//
//  PCUserInformationModel.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/20.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCUserInformationModel.h"

@implementation PCUserInformationModel

+ (NSSet *)keySet {
    return [NSSet setWithObjects:@"userId",@"_id",@"openid",@"unionid",@"groupid",@"heartCount",@"articleCount",@"fansCount",@"followingCount",@"currTemp",@"subscribe_time",@"nickname",@"intro",@"language",@"remark",@"country",@"province",@"city",@"headImgKey",@"bgKey",@"followed",@"sex",@"isCurrUser",@"subscribe", nil];
}

- (id)initWithUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.userId = userId;
        
        [self addNotificationObservation];
        
        [self downloadUserInfo];
    }
    return self;
}

- (void)addNotificationObservation {
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasFollowedSomeoneNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSString *userId = [note.userInfo objectForKey:@"userId"];
                                                      
                                                      if ([userId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_unionid"]]) {
                                                          if ([weakSelf.userId isEqualToString:@"own"] ||
                                                              [weakSelf.userId isEqualToString:userId]) {
                                                              weakSelf.fansCount = @([weakSelf.fansCount integerValue]+1);
                                                              weakSelf.followingCount = @([weakSelf.followingCount integerValue]+1);
                                                          }
                                                      } else {
                                                          if ([weakSelf.userId isEqualToString:@"own"]) {
                                                              weakSelf.followingCount = @([weakSelf.followingCount integerValue]+1);
                                                          } else if ([weakSelf.userId isEqualToString:userId]) {
                                                              weakSelf.fansCount = @([weakSelf.fansCount integerValue]+1);
                                                          }
                                                      }
                                                      
                                                      [weakSelf updateView];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasUnfollowedSomeoneNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSString *userId = [note.userInfo objectForKey:@"userId"];
                                                      
                                                      if ([userId isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"user_unionid"]]) {
                                                          if ([weakSelf.userId isEqualToString:@"own"] ||
                                                              [weakSelf.userId isEqualToString:userId]) {
                                                              weakSelf.fansCount = @([weakSelf.fansCount integerValue]-1);
                                                              weakSelf.followingCount = @([weakSelf.followingCount integerValue]-1);
                                                          }
                                                      } else {
                                                          if ([weakSelf.userId isEqualToString:@"own"]) {
                                                              weakSelf.followingCount = @([weakSelf.followingCount integerValue]-1);
                                                          } else if ([weakSelf.userId isEqualToString:userId]) {
                                                              weakSelf.fansCount = @([weakSelf.fansCount integerValue]-1);
                                                          }
                                                      }
                                                      
                                                      [weakSelf updateView];
                                                  }];
    if ([self.userId isEqualToString:@"own"]) {
        [[NSNotificationCenter defaultCenter] addObserverForName:TNHasLikedSomearticleNotification object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          weakSelf.heartCount = @([weakSelf.heartCount integerValue]+1);
                                                          [weakSelf updateView];
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserverForName:TNHasUnlikedSomearticleNotification object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          weakSelf.heartCount = @([weakSelf.heartCount integerValue]-1);
                                                          [weakSelf updateView];
                                                      }];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSSet *)filteredKeySet:(NSDictionary *)info {
    NSMutableSet *filteredKeySet = [NSMutableSet set];
    NSSet *keySet = [[self class] keySet];
    for (NSString *key in keySet) {
        if (info[key] != nil) {
            [filteredKeySet addObject:key];
        }
    }
    return filteredKeySet;
}

- (void)updateInfo:(NSDictionary *)info {
    NSSet *filteredKeySet = [self filteredKeySet:info];
    for (NSString *key in filteredKeySet) {
        [self setValue:info[key] forKeyPath:key];
    }
}

- (void)updateUserImg:(UIImage *)userImg {
    self.userImg = userImg;
}

- (void)downloadUserInfo {
    __weak typeof(self) weakSelf = self;
    if (self.userId != nil) {
        [PCNetworkManager requestUserInformation:self.userId ok:^(NSDictionary *JSON, NSString *userId) {
            [weakSelf updateInfo:JSON];
            [weakSelf downloadUserImg];
        }];
    } else {
        NSLog(@"加载个人信息 - userId为nil");
    }
}

- (void)downloadUserImg {
    __weak typeof(self) weakSelf = self;
    if (self.headImgKey != nil) {
        [PCNetworkManager getImageThroughKey:self.headImgKey ok:^(UIImage *userImg, NSString *userImgKey) {
            [weakSelf updateUserImg:userImg];
        } withSizeCut:CGSizeMake(56, 56)];
    } else {
        NSLog(@"加载个人信息 - headImgKey为nil");
    }
}

- (void)updateView {
    [PCPostNotificationCenter postNotification_updateUserInfo_withObj:self];
}

- (void)synchronize {}

@end
