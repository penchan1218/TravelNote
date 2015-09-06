//
//  PCChooseTemplatesScrollView.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/30.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCChooseTemplatesScrollView.h"
#import "UIView+FrameAbout.h"
#import "UIView+BGTouchView.h"

@interface PCChooseTemplatesScrollView () {
    CGFloat factor_width;   //当一个模板居中显示时左右两侧的模板显示的宽度与模板宽度的比例
    CGFloat factor_scale;   //放缩因子
    
    CGFloat width_template; //模板宽度
    CGFloat width_dist;     //两个模板间的距离
    
    CGFloat scale;          //高宽比
    
    CGFloat criticalDist;   //临界距离
    
    CGFloat depth;          //突出显示的深度
}

@property (nonatomic, assign)   NSInteger       _numberOfTemplates;

@property (strong, nonatomic)   NSMutableArray  *_views;
@property (strong, nonatomic)   NSMutableArray  *_imageviews;
@property (strong, nonatomic)   NSMutableArray  *_indicators;

@property (nonatomic, assign)   NSInteger       _selectedIndex;

@end

@implementation PCChooseTemplatesScrollView

- (void)reloadData {
    self._numberOfTemplates = [self.delegate_chooseTemplates numberOfTemplatesInChooseTemplatesScrollView:self];
    
    [self resizeTemplateWidth];
    
    [self resizeScrollViewContentSize];
    
    [self resetupTemplates];
    
    [self handleTemplatesPresentationWithScrollViewOffset:0.0f];
    
    [self changeSelectedOne:0];
    
    self.delegate = self;
}

- (void)resizeTemplateWidth {
    factor_width = 0.25; //这个因子有限制条件, 不能使 width_dist<0
    scale = 1.6;
    factor_scale = 1.5;
    width_template = (self._height/factor_scale-14)/scale;
    width_dist = (self._width-width_template*(1.0f+2*factor_width)) / 2;
    
    criticalDist = ((1-2*factor_width)*width_template+width_dist);
    
    depth = 10.0;
}

- (void)resizeScrollViewContentSize {
    self.contentSize = CGSizeMake((width_template+width_dist)*(self._numberOfTemplates-1)+self._width, self._height);
    [self scrollRectToVisible:CGRectMake(0, 0, self._width, self._height) animated:NO];
}

- (void)resetupTemplates {
    if (self._indicators == nil) {
        self._indicators = [NSMutableArray array];
    } else {
        [self._indicators removeAllObjects];
    }
    
    if (self._imageviews == nil) {
        self._imageviews = [NSMutableArray array];
    } else {
        [self._imageviews removeAllObjects];
    }
    
    if (self._views == nil) {
        self._views = [NSMutableArray array];
    } else {
        while (self._views.count > 0) {
            UIView *view = [self._views lastObject];
            [view removeFromSuperview];
            [self._views removeLastObject];
        }
    }
    
    [self newTemplates];
}

- (void)newTemplates {
    for (NSInteger i = 0; i < MIN(self._numberOfTemplates, 3); i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width_template+14, width_template*scale+14)];
        view.tag = i;
        view.clipsToBounds = NO;
        [self addSubview:view];
        [self._views addObject:view];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 14, width_template, width_template*scale)];
        imageview.contentMode = UIViewContentModeScaleToFill;
        imageview.userInteractionEnabled = YES;
        
        imageview.layer.masksToBounds = NO;
        imageview.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        imageview.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        imageview.layer.shadowOpacity = 0.5;
//        imageview.layer.shadowRadius = 1.0;
        imageview.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(imageview.bounds, -1, -1) cornerRadius:1].CGPath;
        
        imageview.clipsToBounds = NO;
        imageview.tag = i;
        [self.delegate_chooseTemplates chooseTemplatesScrollViewReloadTemplate:imageview];
        [view addSubview:imageview];
        [self._imageviews addObject:imageview];
        
        UIImageView *indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tick_gray"]];
        indicator.userInteractionEnabled = YES;
        indicator.tag = i;
        indicator.contentMode = UIViewContentModeScaleToFill;
//        indicator.alpha = 0.0f;
        [indicator setFrame:CGRectMake(0, 0, 28, 28)];
        [indicator setCenter:CGPointMake(width_template, 14)];
        [view addSubview:indicator];
        [self._indicators addObject:indicator];
        
        CGPoint center = CGPointMake(self._width/2, self._height/2+10);
        
        switch (i) {
            case 0:
                view.center = CGPointMake(center.x+7, center.y-7);
                break;
            case 1:
                view.center = CGPointMake(center.x+width_dist+width_template+7, center.y-7);
                break;
            case 2:
                view.center = CGPointMake(center.x+(width_template+width_dist)*2+7, center.y-7);
                break;
            default:
                break;
        }
        
        __weak typeof(self) weakSelf = self;
        [imageview touchEndedBlock:^(UIView *selfView) {
            [weakSelf.delegate_chooseTemplates chooseTemplatesScrollView:weakSelf previewTemplateAtIndex:selfView.tag];
        }];
        [indicator touchEndedBlock:^(UIView *selfView) {
            [weakSelf changeSelectedOne:selfView.tag];
        }];
        [view touchEndedBlock:^(UIView *selfView) {
            [weakSelf changeSelectedOne:selfView.tag];
        }];
    }
}

- (void)changeSelectedOne:(NSInteger)tag {
    NSInteger count = self._indicators.count;
    
    NSInteger old_index = self._selectedIndex%count;
    NSInteger new_index = tag%count;
    if (old_index >= count || old_index < 0 ||
        new_index >= count || new_index < 0) {
        NSLog(@"选择模板 - 出现数组越界错误!");
        return ;
    }
    
    UIImageView *old_indicator = self._indicators[old_index];
    old_indicator.image = [UIImage imageNamed:@"icon_tick_gray"];
//    old_indicator.alpha = 0.0f;
    
    UIImageView *new_indicator = self._indicators[new_index];
    new_indicator.image = [UIImage imageNamed:@"icon_tick"];
//    [UIView animateWithDuration:0.2 animations:^{
//        new_indicator.alpha = 1.0f;
//    }];
    
    self._selectedIndex = tag;
}

- (void)decideIndicatorShouldShow:(NSInteger)tag {
    NSInteger count = self._indicators.count;
    
    NSInteger index = tag%count;
    if (index >= count || index < 0) {
        NSLog(@"选择模板 - 出现数组越界错误!");
        return ;
    }
    
    UIImageView *indicator = self._indicators[index];
    if (tag == self._selectedIndex) {
//        indicator.alpha = 1.0f;
        indicator.image = [UIImage imageNamed:@"icon_tick"];
    } else {
        indicator.image = [UIImage imageNamed:@"icon_tick_gray"];
//        indicator.alpha = 0.0f;
    }
}

- (void)handleTemplatesPresentationWithScrollViewOffset:(CGFloat)offset {
    for (UIView *view in self._views) {
        NSInteger tag = view.tag;
        UIImageView *indicator = self._indicators[tag%3];
        UIImageView *imageview = self._imageviews[tag%3];
        
        if ((offset-view._right) >= criticalDist) {
            if (view.tag+3 <= self._numberOfTemplates-1) {
                view.tag = imageview.tag = indicator.tag = tag+3;
                view._right = view._right+(width_dist+width_template)*3;
                [self.delegate_chooseTemplates chooseTemplatesScrollViewReloadTemplate:imageview];
                
                [self decideIndicatorShouldShow:view.tag];
            }
        } else if (view._left-offset-self._width >= criticalDist) {
            if (view.tag-3 >= 0) {
                view.tag = imageview.tag = indicator.tag = tag-3;
                view._left = view._left-(width_dist+width_template)*3;
                [self.delegate_chooseTemplates chooseTemplatesScrollViewReloadTemplate:imageview];
                
                [self decideIndicatorShouldShow:view.tag];
            }
        }
        
        CGFloat recoveryDist = width_dist/2+width_template/2+1;
        CGFloat degree = MIN(fabs(view.center.x-7-offset-self._width/2), recoveryDist)/recoveryDist;
        CGFloat actual_scale = factor_scale - degree*(factor_scale-1);
//        CGFloat actual_depth = (1-degree) * depth;
        CGAffineTransform transform_2D = CGAffineTransformMakeScale(actual_scale, actual_scale);
//        imageview.layer.transform = CATransform3DTranslate(CATransform3DMakeAffineTransform(transform_2D), 0, 0, actual_depth);
        view.transform = transform_2D;
        
        if (actual_scale > 1) {
            if ([self.delegate_chooseTemplates respondsToSelector:@selector(chooseTemplatesScrollView:didShowTemplateAtIndex:)]) {
                [self.delegate_chooseTemplates chooseTemplatesScrollView:self didShowTemplateAtIndex:view.tag];
            }
        }
    }
}

- (void)setDelegate_chooseTemplates:(id<PCChooseTemplatesScrollViewDelegate>)delegate_chooseTemplates {
    _delegate_chooseTemplates = delegate_chooseTemplates;
    
    if (delegate_chooseTemplates != nil) {
        [self reloadData];
    }
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
    if (delegate == self || delegate == nil) {
        [super setDelegate:delegate];
    } else {
        NSLog(@"由于本类实现了<UIScrollViewDelegate>协议，不允许其他对象成为该对象的delegate");
    }
}

- (void)set_selectedIndex:(NSInteger)_selectedIndex {
    __selectedIndex = _selectedIndex;
    
    if ([self.delegate_chooseTemplates respondsToSelector:@selector(chooseTemplatesScrollView:didSelectTemplateAtIndex:)]) {
        [self.delegate_chooseTemplates chooseTemplatesScrollView:self didSelectTemplateAtIndex:_selectedIndex];
    }
}

#pragma mark - Protocol - scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self handleTemplatesPresentationWithScrollViewOffset:scrollView.contentOffset.x];
}

@end
