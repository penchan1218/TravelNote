//
//  PCSelfInformationModel.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/20.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCSelfInformationModel.h"
#import "PCNetworkManager.h"

@implementation PCSelfInformationModel

+ (PCSelfInformationModel *)sharedInstance {
    static PCSelfInformationModel *__sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 当前没有数据库，暂时存在UserDefaults中
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_information"];
        if (data != nil) {
            __sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [__sharedInstance downloadUserInfo];
        } else {
            __sharedInstance = [[PCSelfInformationModel alloc] initWithUserId:@"own"];
            __sharedInstance.unionid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_unionid"];
        }
    });
    return __sharedInstance;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    NSSet *keySet = [[self class] keySet];
    for (NSString *key in keySet) {
        id object = [self valueForKeyPath:key];
        if (object != nil) {
            [aCoder encodeObject:object forKey:key];
        }
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        NSSet *keySet = [[self class] keySet];
        for (NSString *key in keySet) {
            id object = [aDecoder decodeObjectForKey:key];
            if (object != nil) {
                [info setObject:object forKey:key];
            }
        }
        [self updateInfo:info];
        [self downloadUserInfo];
    }
    return self;
}

- (void)updateInfo:(NSDictionary *)info {
    [super updateInfo:info];
    NSLog(@"%@", self.intro);
    [self updateView];
}

- (void)updateUserImg:(UIImage *)userImg {
    [super updateUserImg:userImg];
    [self updateView];
}

- (void)synchronize {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self] forKey:@"user_information"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end