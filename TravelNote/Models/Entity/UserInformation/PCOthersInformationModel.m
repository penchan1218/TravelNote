//
//  PCOthersInformationModel.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/27.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCOthersInformationModel.h"

@implementation PCOthersInformationModel

- (void)updateInfo:(NSDictionary *)info {
    [super updateInfo:info];
    [self updateView];
}

- (void)updateUserImg:(UIImage *)userImg {
    [super updateUserImg:userImg];
    [self updateView];
}

@end