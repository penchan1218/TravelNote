//
//  PCDisplayTableViewCell.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/10.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LikeOrUnlikeBlock)(NSIndexPath *indexpath, BOOL isliked);

@interface PCDisplayTableViewCell : UITableViewCell {
    BOOL isLiked;
}

+ (instancetype)cellWithLikeOrUnlikeAction:(LikeOrUnlikeBlock)block;

@property (nonatomic, assign) LikeOrUnlikeBlock likeBlock;

@property (nonatomic, copy) NSIndexPath *indexpath;

@property (weak, nonatomic) UIImageView *imgView_bg;

@property (weak, nonatomic) UIImageView *imgView_like;

@property (weak, nonatomic) UIImageView *imgView_avatar;

@property (weak, nonatomic) UILabel *lbl_title;

@property (weak, nonatomic) UILabel *lbl_place;

@end
