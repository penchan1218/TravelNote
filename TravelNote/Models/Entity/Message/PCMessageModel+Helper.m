//
//  PCMessageModel+Helper.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/1.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCMessageModel+Helper.h"

@implementation PCMessageModel (Helper)

- (void)reloadCell:(__weak PCMessageCell *)cell {
    [cell clearAllElements];
    
    cell.userName = self.userName;
    cell.lbl_message.text = self.messageText;
    cell.tv_comments.text = self.content;
    cell.fromId = self.fromId;
    
    if (!self.knowCellHeight) {
        [cell setFrame:[[UIScreen mainScreen] bounds]];
        [cell layoutIfNeeded];
        CGSize size_message = [cell.lbl_message sizeThatFits:CGSizeMake(cell.lbl_message._width, CGFLOAT_MAX)];
        CGSize size_comments = [cell.tv_comments sizeThatFits:CGSizeMake(cell.tv_comments._width, CGFLOAT_MAX)];
        if (cell.tv_comments) {
            self.cellHeight = MAX(cell.tv_comments._top+size_comments.height+20+4, self.cellHeight);
        } else {
            self.cellHeight = MAX(cell.lbl_message._top+size_message.height+20+4, self.cellHeight);
        }
        self.knowCellHeight = YES;
    } else {
        if (self.userImgKey != nil) {
            __weak typeof(self) weakSelf = self;
            [self getImageBackThroughKey:self.userImgKey ok:^(UIImage *userImg) {
                if ([weakSelf.fromId isEqual:cell.fromId]) {
                    cell.imgview_avatar.image = userImg;
                }
            } withSizeCut:CGSizeMake(50, 50)];
        }
    }
}

@end
