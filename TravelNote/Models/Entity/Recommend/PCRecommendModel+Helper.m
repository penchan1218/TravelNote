//
//  PCRecommendModel+Helper.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/1.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCRecommendModel+Helper.h"
#import "PCSelfInformationModel.h"

@implementation PCRecommendModel (Helper)

- (void)reloadCell:(__weak PCDiscoveryCell *)cell {
    [cell clearAllElements];
    
    cell.lbl_name.text = self.userName;
    cell.lbl_signature.text = self.intro;
    cell.follow = self.isFollowed;
    cell.userId = self.userId;
    
    if ([[PCSelfInformationModel sharedInstance].unionid isEqualToString:self.userId]) {
        cell.btn_follow.alpha = 0.0;
    } else {
        cell.btn_follow.alpha = 1.0;
    }
    
    __weak typeof(self) weakSelf = self;
    if (self.userImgKey != nil) {
        [self getImageBackThroughKey:self.userImgKey ok:^(UIImage *userImg) {
            if ([weakSelf.userId isEqual:cell.userId]) {
                cell.img_avatar.image = userImg;
            }
        } withSizeCut:CGSizeMake(50, 50)];
    }

    for (NSInteger i = 0; i < self.articles.count; i++) {
        NSDictionary *article = self.articles[i];
        if ([article objectForKey:@"coverKey"] != nil) {
            __weak UIImageView *imageview = cell.imgs[i];
            CGSize size = imageview.frame.size;
            [PCNetworkManager getImageThroughKey:article[@"coverKey"] ok:^(UIImage *coverImg, NSString *coverKey) {
                if ([weakSelf.userId isEqual:cell.userId]) {
                    imageview.image = coverImg;
                }
            } withSizeCut:size];
        } else {
            NSLog(@"CoverImgKey为nil!");
        }
    }
}

@end
