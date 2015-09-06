//
//  PCMessageCell.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/11.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCMessageCell.h"
#import "UIView+BGTouchView.h"

@implementation PCMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *cells = [[NSBundle mainBundle] loadNibNamed:@"PCMessageCell" owner:self options:nil];
        for (UITableViewCell *cell in cells) {
            if ([cell.reuseIdentifier isEqualToString:reuseIdentifier]) {
                self = (PCMessageCell *)cell;
                break;
            }
        }
        
        self.lbl_message.numberOfLines = 0;
    }
    return self;
}

- (void)awakeFromNib {
    __weak typeof(self) weakSelf = self;
    [self.imgview_avatar touchEndedBlock:^(UIView *selfView) {
        [weakSelf showUserInfo];
    }];
}

- (void)clearAllElements {
    _imgview_avatar.image = nil;
    _imgview_category.image = nil;
    _imgview_poster.image = nil;
    _lbl_message.text = nil;
    _tv_comments.text = nil;
    self.userName = nil;
}

- (IBAction)showUserInfo {
    if (self.showUserInfoBlock) {
        self.showUserInfoBlock(self.fromId);
    }
}

- (void)drawRect:(CGRect)rect {
    // 因为不需要阴影，所以重写该方法并且不调用父类的该方法
}

- (CGFloat)appendComments:(NSString *)newComments {
    CGFloat height = self.frame.size.height;
    height -= _tv_comments.contentSize.height;
    NSLog(@"%f", height);
    NSMutableString *comments = [NSMutableString string];
    if (_tv_comments.text.length > 0) {
        [comments appendFormat:@"%@\n", _tv_comments.text];
    }
    [comments appendString:newComments];
    _tv_comments.text = comments;
    NSLog(@"%f", _tv_comments.contentSize.height);
    return _tv_comments.contentSize.height+height;
}

- (void)setUserName:(NSString *)userName {
    _userName = [userName copy];
    [self.btn_name setTitle:userName forState:UIControlStateNormal];
}

@end
