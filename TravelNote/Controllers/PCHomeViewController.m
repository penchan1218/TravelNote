//
//  PCHomeViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/10.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCHomeViewController.h"
#import "PCCustomSegmentView.h"

@implementation PCHomeViewController

- (void)viewDidLoad {
    PCCustomSegmentView *segmentView = [[PCCustomSegmentView alloc] initWithTitles:@[@"广场", @"关注"]
                                                                    filledInBounds:CGSizeMake(200, 44)];
    [segmentView addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentView;
}

- (void)segmentChanged:(PCCustomSegmentView *)segmentView {
    NSLog(@"%ld", (unsigned long)segmentView.index);
}

@end
