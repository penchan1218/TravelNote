//
//  PCAddNoteViewController.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/26.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCAddNoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;



@property (nonatomic, assign) NSInteger assetIndex;
@property (nonatomic, copy) NSString *lastUpdatedText;

@property (nonatomic, copy) void (^completionBlock)(NSInteger index, BOOL modified);

- (void)usingBlockWhenEdittingFinished:(void (^)(NSInteger index, BOOL modified))block;

@end
