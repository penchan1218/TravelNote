//
//  PCCustomSegmentView.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/10.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCCustomSegmentView.h"

@interface PCCustomSegmentView () {
    UIView *__indicator;
    UIView *__containerView;
    
    NSMutableArray *__lengths;
    float totalLength;
}

@property (strong, nonatomic) NSMutableArray *btns;

@end

@implementation PCCustomSegmentView

- (id)initWithTitles:(NSArray *)titles filledInBounds:(CGSize)size {
    self = [super initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        _titles = [titles copy];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    NSInteger count = _titles.count;
    if (count <= 0) {
        return ;
    }
    
    __lengths = [NSMutableArray arrayWithCapacity:count];
    totalLength = 0.0;
    for (NSInteger i = 0; i < count; i++) {
        NSString *title = _titles[i];
        [__lengths addObject:@([title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.frame.size.height-4)
                                                   options:NSStringDrawingUsesFontLeading
                                                attributes:@{NSFontAttributeName: [self btnFont]} context:nil].size.width)];
        totalLength += [__lengths.lastObject floatValue];
    }
    
    if (totalLength > self.frame.size.width) {
        NSLog(@"title view的宽度不够。");
    }
    
    // 暂未考虑宽度设置不够时的修正情况，先手动调整。
    int spacing = (self.frame.size.width-totalLength)/(_titles.count+1);
    
    __containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 2, self.frame.size.width, self.frame.size.height-6)];
    __containerView.userInteractionEnabled = YES;
    __containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:__containerView];
    
    __indicator = [[UIView alloc] initWithFrame:CGRectMake(spacing, self.frame.size.height-4, [__lengths[0] floatValue], 2)];
    __indicator.backgroundColor = [UIColor whiteColor];
    __indicator.layer.cornerRadius = 1.0;
    [self addSubview:__indicator];
    
    _btns = [NSMutableArray arrayWithCapacity:_titles.count];
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        btn.tag = i;
        [btn.titleLabel setFont:[self btnFont]];
        [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [btn setTitle:_titles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [__containerView addSubview:btn];
        [_btns addObject:btn];
        
        if (i == 0) {
            [btn setTitleColor:[self selectedColor] forState:UIControlStateNormal];
            [__containerView addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:@"H:|-(spacing)-[btn]"
                                  options:0
                                  metrics:@{@"spacing": @(spacing)}
                                  views:NSDictionaryOfVariableBindings(btn)]];
            [__containerView addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:@"V:|[btn]|"
                                  options:0 metrics:nil
                                  views:NSDictionaryOfVariableBindings(btn)]];
        } else {
            [btn setTitleColor:[self unselectedColor] forState:UIControlStateNormal];
            
            UIButton *lastBtn = _btns[i-1];
            [__containerView addConstraints:[NSLayoutConstraint
                                  constraintsWithVisualFormat:@"H:[lastBtn]-(spacing)-[btn]"
                                  options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom
                                  metrics:@{@"spacing": @(spacing)}
                                  views:NSDictionaryOfVariableBindings(lastBtn, btn)]];
        }
        if (i == _titles.count-1) {
            [__containerView addConstraints:[NSLayoutConstraint
                                 constraintsWithVisualFormat:@"H:[btn]-(>=0)-|"
                                 options:0
                                 metrics:nil
                                 views:NSDictionaryOfVariableBindings(btn)]];
        }
    }
}

- (void)adjustPositionWithScale:(CGFloat)scale {
    if (_btns.count == 0) {
        return ;
    }
    
    CGFloat dist = 0;
    for (NSInteger i = _btns.count-2; i >= 0 && i < _btns.count; i++) {
        UIButton *btn = _btns[i];
        dist = btn.frame.origin.x-dist;
    }
    
    UIButton *btn = _btns[0];
    CGFloat originX = btn.frame.origin.x;
    
    CGRect endRect = __indicator.frame;
    endRect.origin.x = originX+dist*scale;
    __indicator.frame = endRect;
}

- (void)btnClicked:(UIButton *)btn {
    NSInteger index = btn.tag;
    self.index = index;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setIndex:(NSInteger)index {
    if (_index == index) {
        return ;
    }
    
    UIButton *lastSelectedBtn = _btns[_index];
    UIButton *selectedBtn = _btns[index];
    [lastSelectedBtn setTitleColor:[self unselectedColor] forState:UIControlStateNormal];
    [selectedBtn setTitleColor:[self selectedColor] forState:UIControlStateNormal];
    
    _index = index;
    
//    CGRect endRect = CGRectMake(selectedBtn.center.x-[__lengths[index] floatValue]/2, __containerView.frame.origin.y+__containerView.frame.size.height, [__lengths[index] floatValue], 2);
//    [UIView animateWithDuration:0.25 animations:^{
//        __indicator.frame = endRect;
//    }];
}

- (UIFont *)btnFont {
    return [UIFont boldSystemFontOfSize:16.0];
}

- (UIColor *)selectedColor {
    return [UIColor whiteColor];
}

- (UIColor *)unselectedColor {
    return UIColorFromRGBA(192, 225, 204, 1.0f);
}

@end
