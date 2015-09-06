//
//  PCDisplayTableViewCell.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/10.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseTableViewCell.h"

//typedef void (^LikeOrUnlikeBlock)(NSIndexPath *indexpath, BOOL isliked);

static NSString * const TNWithTrashDisplayCell = @"TNWithTrashDisplayCell";
static NSString * const TNWithAvatarDisplayCell = @"TNWithAvatarDisplayCell";
static NSString * const TNWithoutAvatarOrTrashDisplayCell = @"TNWithoutAvatarOrTrashDisplayCell";

@interface PCDisplayTableViewCell : PCBaseTableViewCell <UIAlertViewDelegate>

//+ (instancetype)cellWithLikeOrUnlikeAction:(LikeOrUnlikeBlock)block;

//@property (nonatomic, copy) LikeOrUnlikeBlock likeBlock;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) BOOL hasFollowed;
@property (nonatomic, copy) NSString *articleid;
@property (nonatomic, copy) NSString *userId;

@property (weak, nonatomic) IBOutlet UIImageView *imgView_bg;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_like;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_trash;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_avatar;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_edit;

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UILabel *lbl_time;
@property (weak, nonatomic) UILabel *lbl_place;
@property (weak, nonatomic) IBOutlet UILabel *lbl_numOfLikes;
@property (weak, nonatomic) IBOutlet UILabel *lbl_nickname;


@property (weak, nonatomic) IBOutlet UIView *view_separator;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_likeOrUnlike;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_follow;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator_trash;

@property (nonatomic, assign) BOOL isTrashing;


@property (weak, nonatomic) IBOutlet UIButton *btn_follow;


- (void)unlikeRequest;

- (void)likeRequest;

@end
