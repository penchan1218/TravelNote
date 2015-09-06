//
//  PCCommentModel+Helper.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/31.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCCommentModel+Helper.h"
#import "NSNumber+TimeFormatSince1970.h"

@implementation PCCommentModel (Helper)

- (void)reloadCell:(__weak PCCommentsCell *)cell {
    [cell clearAllElements];
    
    cell.lbl_nickname.text = self.userName;
    cell.lbl_comments.text = self.content;
    cell.lbl_time.text = [self.commentTime textMessage];
    cell.userId = self.userId;

    if (!self.knowCellHeight) {
        [cell setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [cell layoutIfNeeded];
        CGSize size_comments = [cell.lbl_comments sizeThatFits:CGSizeMake(cell.lbl_comments._width, CGFLOAT_MAX)];
        self.cellHeight = MAX(self.cellHeight, cell.lbl_comments._top+4+size_comments.height+20);
        self.knowCellHeight = YES;
    } else {
        __weak typeof(self) weakSelf = self;
        [self getImageBackThroughKey:self.userImgKey ok:^(UIImage *userImg) {
            if ([weakSelf.userId isEqual:cell.userId]) {
                cell.imgview_avatar.image = userImg;
            }
        } withSizeCut:CGSizeMake(44, 44)];
    }
}

@end
