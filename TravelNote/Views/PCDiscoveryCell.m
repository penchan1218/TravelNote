//
//  PCDiscoveryCell.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/4.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCDiscoveryCell.h"
#import "PCNetworkManager.h"
#import "UIView+BGTouchView.h"

@implementation PCDiscoveryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [[NSBundle mainBundle] loadNibNamed:@"PCDiscoveryCell" owner:self options:nil][0];
    return self;
}

- (void)awakeFromNib {
    self.layer.borderColor = HexColor(0xDBDADA, 1.0f).CGColor;
    _lbl_name.adjustsFontSizeToFitWidth = YES;
    _imgs = @[_img_1, _img_2, _img_3];
    
    __weak typeof(self) weakSelf = self;
    [_img_1 touchEndedBlock:^(UIView *selfView) {
        [weakSelf showArticleAtIndex:0];
    }];
    [_img_2 touchEndedBlock:^(UIView *selfView) {
        [weakSelf showArticleAtIndex:1];
    }];
    [_img_3 touchEndedBlock:^(UIView *selfView) {
        [weakSelf showArticleAtIndex:2];
    }];
}

- (void)showArticleAtIndex:(NSInteger)index {
    if (self.showArticleBlock) {
        self.showArticleBlock(index);
    } else {
        NSLog(@"展示游记而缺少showArticleBlock!");
    }
}

- (IBAction)shouldFollow:(id)sender {
    if (self.userId != nil) {
        _btn_follow.alpha = 0.0f;
        [_indicator_follow startAnimating];
        
        __weak typeof(self) weakSelf = self;
        if (self.follow == YES) {
            [PCNetworkManager unfollowTheUser:self.userId ok:^(BOOL success) {
                weakSelf.follow = !success;
                if (success) {
                    [PCPostNotificationCenter postNotification_unfollowSomeone_withObj:nil userId:weakSelf.userId];
                }
            }];
        } else {
            [PCNetworkManager followTheUser:self.userId ok:^(BOOL success) {
                weakSelf.follow = success;
                if (success) {
                    [PCPostNotificationCenter postNotification_followSomeone_withObj:nil userId:weakSelf.userId];
                }
            }];
        }
    } else {
        NSLog(@"关注操作信息不全 - 缺乏userId");
    }
}

- (void)clearAllElements {
    _btn_follow.alpha = 0.0f;
    [_indicator_follow startAnimating];
    [self clearImages];
    [self clearText];
}

- (void)clearImages {
    _img_avatar.image = nil;
    _img_1.image = nil;
    _img_2.image = nil;
    _img_3.image = nil;
}

- (void)clearText {
    _lbl_name.text = nil;
    _lbl_signature.text = nil;
}

- (void)setFollow:(BOOL)follow {
    _btn_follow.alpha = 1.0f;
    [_indicator_follow stopAnimating];
    _follow = follow;
    UIColor *color = _follow? HexColor(0xD55353, 1.0f): HexColor(0x2DBD75, 1.0f);
    NSString *title = _follow? @"已关注": @"关注";
    [_btn_follow setTitle:title forState:UIControlStateNormal];
    [_btn_follow setTitleColor:color forState:UIControlStateNormal];
    _btn_follow.layer.borderColor = color.CGColor;
}

@end
