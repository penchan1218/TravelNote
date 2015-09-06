//
//  PCDisplayModel+PCDisplayModelHelper.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/31.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCDisplayModel.h"
#import "PCDisplayTableViewCell.h"

@interface PCDisplayModel (Helper)

- (void)reloadCell:(__weak PCDisplayTableViewCell *)cell;

- (void)fixCellHeightWithSpecifiedCoverRatioOfType:(TNDisplayCellType)type;

@end
