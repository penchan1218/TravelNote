//
//  PCChoosePhotosCell.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/25.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCChoosePhotosCell.h"

@implementation PCChoosePhotosCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self = [[NSBundle mainBundle] loadNibNamed:@"PCChoosePhotosCell" owner:self options:nil][0];
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    _status = NO;
    self.layer.cornerRadius = 4.0f;
    // 给select button设置为默认状态
    [self enableAddNoteAction];
}

- (void)enableAddNoteAction {
    [_imageView_status setImage:[UIImage imageNamed:@"add_note"]];
    [_shadowView setBackgroundColor:HexColor(0x000000, 0.1)];
}

- (void)disableAddNoteAction {
    [_imageView_status setImage:[UIImage imageNamed:@"note_already_added"]];
    [_shadowView setBackgroundColor:HexColor(0x32B16C, 0.5)];
}

- (void)setStatus:(BOOL)status {
    if (status == _status) {
        return ;
    }
    
    _status = status;
    // 状态改变
    if (status == YES) {
        [self disableAddNoteAction];
    } else {
        [self enableAddNoteAction];
    }
}

@end
