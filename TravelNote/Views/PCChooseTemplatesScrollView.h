//
//  PCChooseTemplatesScrollView.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/30.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCChooseTemplatesScrollView;

@protocol PCChooseTemplatesScrollViewDelegate <NSObject>

@optional

- (void)chooseTemplatesScrollView:(__weak PCChooseTemplatesScrollView *)scrollView didShowTemplateAtIndex:(NSInteger)index;
- (void)chooseTemplatesScrollView:(__weak PCChooseTemplatesScrollView *)scrollView didSelectTemplateAtIndex:(NSInteger)index;

@required

- (NSInteger)numberOfTemplatesInChooseTemplatesScrollView:(__weak PCChooseTemplatesScrollView *)scrollView;
- (void)chooseTemplatesScrollViewReloadTemplate:(__weak UIImageView *)imageview;
- (void)chooseTemplatesScrollView:(PCChooseTemplatesScrollView *__weak)scrollView previewTemplateAtIndex:(NSInteger)index;

//- (UIImage *)chooseTemplatesScrollView:(__weak PCChooseTemplatesScrollView *)scrollView templateAtIndex:(NSInteger)index;

@end

@interface PCChooseTemplatesScrollView : UIScrollView <UIScrollViewDelegate>

@property (weak, nonatomic) id<PCChooseTemplatesScrollViewDelegate> delegate_chooseTemplates;

- (void)reloadData;

@end
