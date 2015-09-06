//
//  PCCommentsCell.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/13.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCCommentsCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+BGTouchView.h"

@implementation PCCommentsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    NSArray *xibs = [[NSBundle mainBundle] loadNibNamed:@"PCCommentsCell" owner:self options:nil];
    for (PCCommentsCell *cell in xibs) {
        if ([cell.reuseIdentifier isEqualToString:reuseIdentifier]) {
            self = cell;
            break;
        }
    }
    
    self.lbl_comments.numberOfLines = 0;
    self.lbl_nickname.clipsToBounds = YES;
    self.lbl_comments.clipsToBounds = YES;
    
    __weak typeof(self) weakSelf = self;
    [self.imgview_avatar touchEndedBlock:^(UIView *selfView) {
        if (weakSelf.showUserInfoBlock) {
            weakSelf.showUserInfoBlock(weakSelf.userId);
        }
    }];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    
}

- (void)awakeFromNib {
    // Initialization code
    _imgview_avatar.layer.cornerRadius = _imgview_avatar.frame.size.height/2;
}

- (void)clearAllElements {
    _lbl_time.text = nil;
    _lbl_nickname.text = nil;
    _lbl_comments.text = nil;
    
    _imgview_avatar.image = nil;
}

@end
