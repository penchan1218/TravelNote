//
//  PCCustomSegmentView.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/10.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCCustomSegmentView : UIControl

@property (nonatomic, copy, readonly) NSArray *titles;

@property (nonatomic, assign) NSInteger index;

- (id)initWithTitles:(NSArray *)titles filledInBounds:(CGSize)size;

@end
