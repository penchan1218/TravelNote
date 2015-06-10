//
//  PCDisplayTableViewCell.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/10.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCDisplayTableViewCell.h"
#import "UIView+BGTouchView.h"

@implementation PCDisplayTableViewCell

+ (instancetype)cellWithLikeOrUnlikeAction:(LikeOrUnlikeBlock)block {
    
    PCDisplayTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"PCDisplayTableViewCell" owner:nil options:nil][0];
    
    cell.imgView_bg = (UIImageView *)[cell viewWithTag:1000];
    cell.imgView_like = (UIImageView *)[cell viewWithTag:1001];
    cell.imgView_avatar = (UIImageView *)[cell viewWithTag:1002];
    cell.lbl_title = (UILabel *)[cell viewWithTag:1003];
    cell.lbl_place = (UILabel *)[cell viewWithTag:1004];
    
    cell.imgView_bg.layer.cornerRadius = 5.0f;
    cell.imgView_avatar.layer.cornerRadius = 20.0f;
    
    cell.likeBlock = block;
    [cell addLikeOrUnlikeAction];
    
    return cell;
}

- (void)addLikeOrUnlikeAction {
    [_imgView_like touchEndedBlock:^(UIView *selfView) {
        // 动画效果。
        isLiked = !isLiked;
        if (isLiked) {
            _imgView_like.image = [UIImage imageNamed:@"heart_check"];
        } else {
            _imgView_like.image = [UIImage imageNamed:@"heart_normal"];
        }
    }];
    
    if (self.likeBlock) {
        self.likeBlock(self.indexpath, isLiked);
    }
}

@end
