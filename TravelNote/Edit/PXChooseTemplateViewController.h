//
//  PXChooseTemplateViewController.h
//  TravelNote
//
//  Created by 朱泌丞 on 15/6/9.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCChooseTemplatesScrollView.h"

@interface PXChooseTemplateViewController : UIViewController <PCChooseTemplatesScrollViewDelegate>

@property (weak, nonatomic) IBOutlet PCChooseTemplatesScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *btn_title;

@end
