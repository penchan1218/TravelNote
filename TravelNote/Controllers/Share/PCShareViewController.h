//
//  PCShareViewController.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/28.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TNSharingCancelledBlock)();

@protocol TNShareToProtocol <NSObject>

@required
- (void)willShareToWechatScene:(NSInteger)scene;

@end

@interface PCShareViewController : UIViewController

@property (weak, nonatomic) id<TNShareToProtocol> delegate;
@property (nonatomic, copy) TNSharingCancelledBlock cancelBlock;

- (void)showChoices;

@end
