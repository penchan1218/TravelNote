//
//  PCDisplayModel+PCDisplayModelHelper.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/31.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCDisplayModel+Helper.h"
#import "UIImage+ImagesAbout.h"
#import "NSNumber+TimeFormatSince1970.h"
#import "PCSelfInformationModel.h"

@implementation PCDisplayModel (Helper)

- (void)reloadCell:(PCDisplayTableViewCell *__weak)cell {
    [cell clearAllElements];
    
//    NSShadow *shadow = [[NSShadow alloc] init];
//    shadow.shadowColor = [UIColor blackColor];
//    shadow.shadowOffset = CGSizeMake(0.5, 0.5);
//    shadow.shadowBlurRadius = 1.0;
    
//    NSDictionary *attributes_title = @{NSShadowAttributeName: shadow,
//                                       NSFontAttributeName: cell.lbl_title.font,
//                                       NSForegroundColorAttributeName: cell.lbl_title.textColor};
//    NSDictionary *attributes_place = @{NSShadowAttributeName: shadow,
//                                       NSFontAttributeName: cell.lbl_place.font,
//                                       NSForegroundColorAttributeName: cell.lbl_place.textColor};
    
//    cell.lbl_title.attributedText = [[NSAttributedString alloc] initWithString:self.title attributes:attributes_title];
    cell.lbl_title.text = self.title && self.title.length>0 ? self.title: @"(无标题)";
    cell.lbl_numOfLikes.text = [NSString stringWithFormat:@"%ld", (unsigned long)self.liked];
    cell.lbl_nickname.text = self.userName && self.userName.length>0 ? self.userName:@"(无昵称)";
    cell.isLiked = self.isLiked;
    cell.hasFollowed = self.isFollowing;
    cell.articleid = self._id;
    cell.userId = self.userId;
    
    cell.lbl_time.text = [self.createTime textMessage];
    
    if ([[PCSelfInformationModel sharedInstance].unionid isEqualToString:self.userId]) {
        cell.btn_follow.alpha = 0.0;
    } else {
        cell.btn_follow.alpha = 1.0;
    }
    
#if DEBUG
//    cell.lbl_place.attributedText = [[NSAttributedString alloc] initWithString:@"湖北, 武汉" attributes:attributes_place];
#endif
    
    __weak typeof(self) weakSelf = self;
    
    [self getImageBackThroughKey:self.userImgKey ok:^(UIImage *userImg) {
        if ([weakSelf.userId isEqual:cell.userId]) {
            cell.imgView_avatar.image = userImg;
        }
    } withSizeCut:CGSizeMake(30, 30)];
    
    CGFloat width_coverImg = SCREEN_WIDTH-(12+10)*2;
    CGSize coverSize = CGSizeMake(width_coverImg, (int)(width_coverImg/2));
    [self getImageBackThroughKey:self.coverKey ok:^(UIImage *coverImg) {
        if ([weakSelf._id isEqual:cell.articleid]) {
            cell.imgView_bg.image = coverImg;
        }
    } withSizeCut:coverSize];
}

- (void)fixCellHeightWithSpecifiedCoverRatioOfType:(TNDisplayCellType)type {
    [self fixCellHeightWithSpecifiedCoverRatio:2 ofType:type];
}

- (void)fixCellHeightWithSpecifiedCoverRatio:(CGFloat)ratio ofType:(TNDisplayCellType)type {
    static CGFloat cellHeightWithoutImageOfTypeWithAvatar = 0.0;
    static CGFloat cellHeightWithoutImageOfTypeWithTrash = 0.0;
    static CGFloat cellHeightWithoutImageOfTypeWithoutAvatarOrTrash = 0.0;
    switch (type) {
        case TNDisplayCellTypeWithAvatar: {
            if (cellHeightWithoutImageOfTypeWithAvatar == 0.0) {
                PCDisplayTableViewCell *cell = [[PCDisplayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TNWithAvatarDisplayCell];
                cellHeightWithoutImageOfTypeWithAvatar = cell.frame.size.height;
                NSLog(@"cell height with avatar : %f", cellHeightWithoutImageOfTypeWithAvatar);
            }
            self.cellHeight = cellHeightWithoutImageOfTypeWithAvatar + (SCREEN_WIDTH-44)/ratio;
        }
            break;
        case TNDisplayCellTypeWithTrash: {
            if (cellHeightWithoutImageOfTypeWithTrash == 0.0) {
                PCDisplayTableViewCell *cell = [[PCDisplayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TNWithTrashDisplayCell];
                cellHeightWithoutImageOfTypeWithTrash = cell.frame.size.height;
                NSLog(@"cell height with trash : %f", cellHeightWithoutImageOfTypeWithTrash);
            }
            self.cellHeight = cellHeightWithoutImageOfTypeWithTrash + (SCREEN_WIDTH-44)/ratio;
        }
            break;
        case TNDisplayCellTypeWithoutAvatarOrTrash: {
            if (cellHeightWithoutImageOfTypeWithoutAvatarOrTrash == 0.0) {
                PCDisplayTableViewCell *cell = [[PCDisplayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TNWithoutAvatarOrTrashDisplayCell];
                cellHeightWithoutImageOfTypeWithoutAvatarOrTrash = cell.frame.size.height;
                NSLog(@"cell height without avatar or trash : %f", cellHeightWithoutImageOfTypeWithoutAvatarOrTrash);
            }
            self.cellHeight = cellHeightWithoutImageOfTypeWithoutAvatarOrTrash + (SCREEN_WIDTH-44)/ratio;
        }
            break;
        default:
            break;
    }
    
    self.knowCellHeight = YES;
}

@end
