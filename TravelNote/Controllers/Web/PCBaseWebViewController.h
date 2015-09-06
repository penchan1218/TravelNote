//
//  PCBaseWebViewController.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/14.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TNWebViewTypeAdjustWhenFinished,
    TNWebViewTypeAdjustAfterFinished,
    TNWebViewTypePreviewWorks,
    TNWebViewTypePreviewTemplates
} TNWebViewType;

@interface PCBaseWebViewController : UIViewController 

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, copy) NSNumber *temp;
@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *URLString;
@property (strong, nonatomic) UIImage *coverImg;
@property (nonatomic, assign) TNWebViewType webViewType;

@end
