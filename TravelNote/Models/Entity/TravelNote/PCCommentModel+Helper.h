//
//  PCCommentModel+Helper.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/31.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCCommentModel.h"
#import "PCCommentsCell.h"

@interface PCCommentModel (Helper)

- (void)reloadCell:(__weak PCCommentsCell *)cell;

@end
