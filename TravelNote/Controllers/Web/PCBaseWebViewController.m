//
//  PCBaseWebViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/14.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseWebViewController.h"
#import "PCTravelNoteCreator.h"
#import "UIImage+ImagesAbout.h"
#import "WXApi.h"

#import "PCShareViewController.h"

@interface PCBaseWebViewController () <TNShareToProtocol>

@property (nonatomic, assign) BOOL isSharing;

@property (weak, nonatomic) MBProgressHUD *hud;

@end

@implementation PCBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backBarBtn;
    
    if (self.webViewType != TNWebViewTypeAdjustAfterFinished) {
        UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithTitle:@"分享"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self action:@selector(shouldShareTo:)];
        self.navigationItem.rightBarButtonItem = shareBtn;
    }
    
//    NSString *modelTestBundlePath = [[NSBundle mainBundle] pathForResource:@"modelTest" ofType:@"bundle"];
//    NSBundle *modelTestBundle = [NSBundle bundleWithPath:modelTestBundlePath];
//    NSString *htmlString = [NSString stringWithContentsOfURL:[modelTestBundle URLForResource:@"model1" withExtension:@"html"] encoding:NSUTF8StringEncoding error:nil];
//    [_webView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:modelTestBundlePath]];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSArray *contentArr = @[@{@"text":@"在伊斯坦布尔遇见了很多不同的人，有趣的事，这是一个幸福的地方我会再来的。",
//                                  @"userImg":@"1.jpg"},
//                                @{
//                                    @"text":@"一个人飞往伊斯坦布尔，第一次去这么远的地方。",
//                                    @"userImg": @"3.jpg"
//                                    },
//                                @{
//                                    @"userImg": @"4.jpg",
//                                    @"text": @"这家酒店非常不错，观景台的视角非常好，大早上起床爬上来感觉呼吸都是美的。"
//                                    },
//                                @{
//                                    @"userImg": @"5.jpg",
//                                    @"text": @"在城堡的议事厅里面，这里应该是国王以前议事的地方。"
//                                    },
//                                @{
//                                    @"text": @"在格雷梅自驾是一种特别的享受，听着音乐一路感受沿途的风景~",
//                                    @"userImg": @"6.jpg"
//                                    },
//                                @{
//                                    @"text":@"快日落的时，我们赶去玫瑰谷，夕阳正好打在脸上，拍照的好时机。",
//                                    @"userImg": @"7.jpg"
//                                    },
//                                @{
//                                    @"text":@"来到海边的第二天报了去棉花堡的行程，天气很冷，沿途都是雪山。",
//                                    @"userImg": @"8.jpg"
//                                    }];
//        
//        NSDictionary *data = @{@"title":@"在伊斯坦布尔遇见你",
//                               @"nickName": @"Sunny",
//                               @"coverImg": @"2.jpg",
//                               @"contents": contentArr};
//        
//        NSString *jsonString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:data
//                                                                                              options:0
//                                                                                                error:nil] encoding:NSUTF8StringEncoding];
//        NSString *formatString = [NSString stringWithFormat:@"testInit('%@');", jsonString];
//        [_webView stringByEvaluatingJavaScriptFromString:formatString];
//    });
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_URLString]];
    [self.webView loadRequest:request];
    
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasSharedToWechatNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      if (!weakSelf.hud) {
                                                          weakSelf.hud = [weakSelf.view HUDForLoadingText:nil];
                                                      }
                                                      weakSelf.hud.mode = MBProgressHUDModeText;
                                                      weakSelf.hud.labelText = @"分享成功";
                                                      [weakSelf.hud hide:YES afterDelay:2];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:TNHasCancelledSharingToWechatNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                  }];
}

- (void)shouldShareTo:(id)sender {
    if (!self.isSharing) {
        PCShareViewController *shareVC = [[PCShareViewController alloc] init];
        shareVC.delegate = self;
        [self addChildViewController:shareVC];
        [self.view addSubview:shareVC.view];
        [shareVC didMoveToParentViewController:self];
        [shareVC showChoices];
        
        __weak typeof(self) weakSelf = self;
        shareVC.cancelBlock = ^{
            weakSelf.isSharing = NO;
        };
        
        self.isSharing = YES;
    }
}

- (void)shareToWechat:(int)scene {
    self.isSharing = YES;

    WXMediaMessage *message = [[WXMediaMessage alloc] init];
    if (self.webViewType == TNWebViewTypeAdjustWhenFinished) {
        UIImage *cover = [UIImage imageWithImage:[PCTravelNoteCreator shared].cover scaledToSize:CGSizeMake(40, 40)];
        [message setTitle:[PCTravelNoteCreator shared].title];
        [message setThumbImage:cover];
    } else if (self.webViewType == TNWebViewTypePreviewWorks ||
               self.webViewType == TNWebViewTypePreviewTemplates) {
        if (self.coverImg) {
            UIImage *cover = [UIImage imageWithImage:self.coverImg scaledToSize:CGSizeMake(40, 40)];
            [message setThumbImage:cover];
        }
        [message setTitle:self.title];
    }
    
    WXWebpageObject *ext = [WXWebpageObject object];
    if (self.webViewType != TNWebViewTypePreviewTemplates) {
        ext.webpageUrl = [NSString stringWithFormat:@"http://travel.changjiangcp.com/view/%@/%@", self.articleId, self.temp];
    } else {
        ext.webpageUrl = self.URLString;
    }
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = scene;
    [WXApi sendReq:req];
    
    self.isSharing = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [PCPostNotificationCenter postNotification_hideTabbar_withObj:nil];
}

- (void)backAction {
    switch (self.webViewType) {
        case TNWebViewTypeAdjustWhenFinished:
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            break;
        case TNWebViewTypeAdjustAfterFinished:
        case TNWebViewTypePreviewWorks:
        case TNWebViewTypePreviewTemplates:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [self.webView stopLoading];
    [self.webView removeFromSuperview];
    self.webView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Protocol - TNShareToProtocol

- (void)willShareToWechatScene:(NSInteger)scene {
    switch (scene) {
        case 0:
            [self shareToWechat:WXSceneSession];
            break;
        case 1:
            [self shareToWechat:WXSceneTimeline];
            break;
        case 2:
            [self shareToWechat:WXSceneFavorite];
        default:
            break;
    }
}

@end
