//
//  PCBaseWebViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/14.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseWebViewController.h"

@interface PCBaseWebViewController ()

@end

@implementation PCBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backBarBtn;
    
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
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
