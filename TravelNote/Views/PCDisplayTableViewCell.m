//
//  PCDisplayTableViewCell.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/10.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCDisplayTableViewCell.h"
#import "UIView+BGTouchView.h"
#import "PCNetworkManager.h"
#import "UIView+LayoutHelper.h"

@implementation PCDisplayTableViewCell

//+ (instancetype)cellWithLikeOrUnlikeAction:(LikeOrUnlikeBlock)block {
//    
//    PCDisplayTableViewCell *cell = [[PCDisplayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TNReusableDisplayCell"];
//    
//    cell = [[NSBundle mainBundle] loadNibNamed:@"PCDisplayTableViewCell" owner:cell options:nil][0];
//    
////    cell.imgView_avatar = (UIImageView *)[cell viewWithTag:1002];
////    cell.lbl_place = (UILabel *)[cell viewWithTag:1004];
//    
//    cell.likeBlock = block;
//    [cell addLikeOrUnlikeAction];
//    
//    return cell;
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"PCDisplayTableViewCell" owner:self options:nil];
        for (UITableViewCell *cell in cells) {
            if ([cell.reuseIdentifier isEqualToString:reuseIdentifier]) {
                self = (PCDisplayTableViewCell *)cell;
                break;
            }
        }
        
        if ([reuseIdentifier isEqualToString:TNWithAvatarDisplayCell]) {
            [self addLikeOrUnlikeAction];
        } else if ([reuseIdentifier isEqualToString:TNWithTrashDisplayCell]) {
            [self addTrashAction];
            [self addEditAction];
        } else if ([reuseIdentifier isEqualToString:TNWithoutAvatarOrTrashDisplayCell]) {
            [self addLikeOrUnlikeAction];
        }
    }
    
    return self;
}

- (void)likeRequest {
    __weak typeof(self) weakSelf = self;
    if (self.articleid != nil) {
        [PCNetworkManager likeArticle:self.articleid ok:^(BOOL success) {
            if (success) {
                [weakSelf hasLikedOrUnliked:!weakSelf.isLiked
                         animatedFromCenter:[weakSelf.indicator_likeOrUnlike.superview convertPoint:weakSelf.indicator_likeOrUnlike.center toView:weakSelf.contentView]];
                weakSelf.isLiked = !weakSelf.isLiked;
                weakSelf.lbl_numOfLikes.text = [NSString stringWithFormat:@"%ld", (unsigned long)([weakSelf.lbl_numOfLikes.text integerValue]+1)];
                
                [PCPostNotificationCenter postNotification_likeSomearticle_withObj:nil articleId:weakSelf.articleid];
            }
        }];
    } else {
        NSLog(@"Like request failed for no articleid.");
    }
}

- (void)unlikeRequest {
    __weak typeof(self) weakSelf = self;
    if (self.articleid != nil) {
        [PCNetworkManager dislikeArticle:self.articleid ok:^(BOOL success) {
            if (success) {
                [weakSelf hasLikedOrUnliked:!weakSelf.isLiked
                         animatedFromCenter:[weakSelf.indicator_likeOrUnlike.superview convertPoint:weakSelf.indicator_likeOrUnlike.center toView:weakSelf.contentView]];
                weakSelf.isLiked = !weakSelf.isLiked;
                weakSelf.lbl_numOfLikes.text = [NSString stringWithFormat:@"%ld", (unsigned long)([weakSelf.lbl_numOfLikes.text integerValue]-1)];
                
                [PCPostNotificationCenter postNotification_unlikeSomearticle_withObj:nil articleId:weakSelf.articleid];
            }
        }];
    } else {
        NSLog(@"Dislike request failed for no articleid.");
    }
}

- (void)addLikeOrUnlikeAction {
    __weak PCDisplayTableViewCell *weakSelf = self;
    [_imgView_like touchEndedBlock:^(UIView *selfView) {
        weakSelf.imgView_like.alpha = 0.0f;
        [weakSelf.indicator_likeOrUnlike startAnimating];
        if (weakSelf.isLiked == NO) {
            [weakSelf likeRequest];
        } else {
            [weakSelf unlikeRequest];
        }
//        if (weakSelf.likeBlock) {
//            weakSelf.likeBlock(weakSelf.indexpath, !weakSelf.isLiked);
//        }
    }];
}

- (void)hasLikedOrUnliked:(BOOL)hasLiked animatedFromCenter:(CGPoint)center {
//    UILabel *lbl_mark = [[UILabel alloc] init];
//    lbl_mark.font = [UIFont boldSystemFontOfSize:14.0];
//    lbl_mark.textColor = hasLiked? UIColorFromRGBA(238, 11, 31, 1.0): UIColorFromRGBA(120, 120, 120, 1.0);
//    lbl_mark.text = hasLiked? @"+1": @"-1";
//    [lbl_mark sizeToFit];
//    lbl_mark.center = center;
//    [self.contentView addSubview:lbl_mark];
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        lbl_mark.transform = CGAffineTransformMakeTranslation(0, hasLiked? -20: 20);
//        lbl_mark.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        [lbl_mark removeFromSuperview];
//    }];
    
    UIImageView *imgview_mark = [[UIImageView alloc] initWithFrame:self.imgView_like.bounds];
    imgview_mark.contentMode = UIViewContentModeScaleAspectFit;
    imgview_mark.image = [UIImage imageNamed:hasLiked? @"heart_check": @"heart_normal"];
    [imgview_mark sizeToFit];
    imgview_mark.center = center;
    [self.contentView addSubview:imgview_mark];
    
    [UIView animateWithDuration:0.25 animations:^{
        imgview_mark.transform = CGAffineTransformMakeScale(1.5, 1.5);
        imgview_mark.alpha = 0.0;
    } completion:^(BOOL finished) {
        [imgview_mark removeFromSuperview];
    }];
}

- (void)addEditAction {
    __weak typeof(self) weakSelf = self;
    [_imgView_edit touchEndedBlock:^(UIView *selfView) {
        [PCPostNotificationCenter postNotification_editOneTravelNote_withObj:nil articleId:weakSelf.articleid];
    }];
}

- (void)addTrashAction {
    __weak typeof(self) weakSelf = self;
    [_imgView_trash touchEndedBlock:^(UIView *selfView) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"将要删除游记"
                                        message:[NSString stringWithFormat:@"将要删除游记 - %@", self.lbl_title.text]
                                                    delegate:weakSelf
                                           cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [av show];
    }];
}

- (void)setIsLiked:(BOOL)isLiked {
    [self.indicator_likeOrUnlike stopAnimating];
    self.imgView_like.alpha = 1.0f;
    
    if (_isLiked == isLiked) {
        return ;
    }
    
    _isLiked = isLiked;
    // 动画效果。
    if (_isLiked) {
        _imgView_like.image = [UIImage imageNamed:@"heart_check"];
    } else {
        _imgView_like.image = [UIImage imageNamed:@"heart_normal"];
    }
}

- (void)setIsTrashing:(BOOL)isTrashing {
    _isTrashing = isTrashing;
    if (isTrashing) {
        self.imgView_trash.alpha = 0.0;
        [self.indicator_trash startAnimating];
    } else {
        self.imgView_trash.alpha = 1.0;
        [self.indicator_trash stopAnimating];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.view_separator.fixedHeigt.constant = ONE_PIXEL;
}

- (void)clearAllElements {
    _imgView_bg.image = nil;
    _imgView_avatar.image = nil;
    _lbl_title.text = nil;
    _lbl_nickname.text = nil;
    
    self.isTrashing = NO;
    
//    _lbl_place.text = nil;
    
//    _lbl_title.attributedText = nil;
//    _lbl_place.attributedText = nil;
}

- (void)setHasFollowed:(BOOL)hasFollowed {
    _btn_follow.alpha = 1.0f;
    [_indicator_follow stopAnimating];
    _hasFollowed = hasFollowed;
    UIColor *color = hasFollowed? HexColor(0xD55353, 1.0f): THEME_COLOR;
    NSString *title = hasFollowed? @"已关注": @"关注";
    [_btn_follow setTitle:title forState:UIControlStateNormal];
    [_btn_follow setTitleColor:color forState:UIControlStateNormal];
    _btn_follow.layer.borderColor = color.CGColor;
}

- (IBAction)shouldFollow:(id)sender {
    self.btn_follow.alpha = 0.0f;
    [self.indicator_follow startAnimating];
    
    __weak typeof(self) weakSelf = self;
    if (self.hasFollowed) {
        if (self.userId) {
            [PCNetworkManager unfollowTheUser:self.userId ok:^(BOOL success) {
                weakSelf.hasFollowed = !success;
                if (success) {
                    [PCPostNotificationCenter postNotification_unfollowSomeone_withObj:nil userId:weakSelf.userId];
                }
            }];
        } else {
            NSLog(@"取消关注而缺少userId");
        }
    } else {
        if (self.userId) {
            [PCNetworkManager followTheUser:self.userId ok:^(BOOL success) {
                weakSelf.hasFollowed = success;
                if (success) {
                    [PCPostNotificationCenter postNotification_followSomeone_withObj:nil userId:weakSelf.userId];
                }
            }];
        } else {
            NSLog(@"取消关注而缺少userId");
        }
    }
}

#pragma mark - Protocol - alert view

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.isTrashing = YES;
        
        __weak typeof(self) weakSelf = self;
        [PCNetworkManager deleteArticle:self.articleid ok:^(BOOL success) {
            if (success) {
                [PCPostNotificationCenter postNotification_deleteOneTravelNote_withObj:nil articleId:weakSelf.articleid];
            }
            
            weakSelf.isTrashing = NO;
        }];
    }
}

@end
