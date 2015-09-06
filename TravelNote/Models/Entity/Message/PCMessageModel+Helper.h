//
//  PCMessageModel+Helper.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/1.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCMessageModel.h"
#import "PCMessageCell.h"

@interface PCMessageModel (Helper) 

- (void)reloadCell:(__weak PCMessageCell *)cell;

@end
