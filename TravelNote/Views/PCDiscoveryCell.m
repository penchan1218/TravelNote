//
//  PCDiscoveryCell.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/4.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCDiscoveryCell.h"

@implementation PCDiscoveryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self = [[NSBundle mainBundle] loadNibNamed:@"PCDiscoveryCell" owner:self options:nil][0];
    [self baseSetup];
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self baseSetup];
    return self;
}

- (void)baseSetup {
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = HexColor(0xDBDADA, 1.0f).CGColor;
    _img_avatar.layer.borderWidth = 25.0f;
    _btn_follow.layer.cornerRadius = 4.0f;
}

- (void)setupAllElements:(NSDictionary *)dic {
    // 结构:
    // "avatar": <头像>,
    // "nickname": <昵称>,
    // "signature": <个性签名>,
    // "follow": <BOOL型value, 更新状态>
    // "images": <底部照片>
    _img_avatar.image = dic[@"avatar"];
    _lbl_name.text = dic[@"nickname"];
    _lbl_signature.text = dic[@"signature"];
    self.follow = [dic[@"follow"] boolValue];
    [self setupImages:dic[@"images"]];
}

- (void)setupImages:(NSArray *)images {
    if (images == nil ||
        [images isKindOfClass:[NSArray class]] == NO) {
        return ;
    }
    
    switch (images.count) {
        case 3:
            _img_3.image = images[2];
        case 2:
            _img_2.image = images[1];
        case 1:
            _img_1.image = images[0];
            break;
        default:
            break;
    }
}

- (void)clearAllElements {
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
    if (_follow == follow) {
        return ;
    }
    
    _follow = follow;
    if (_follow == YES) {
        [_btn_follow setTitle:@"已关注" forState:UIControlStateNormal];
        _btn_follow.layer.borderColor = HexColor(0xD55353, 1.0f).CGColor;
    } else {
        [_btn_follow setTitle:@"关注" forState:UIControlStateNormal];
        _btn_follow.layer.borderColor = HexColor(0x2DBD75, 1.0f).CGColor;
    }
}

@end
