//
//  PCLoginViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/24.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCLoginViewController.h"
#import "WXApi.h"
#import "AppDelegate.h"

@interface PCLoginViewController ()

@end

@implementation PCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btn_requestForOauth.layer.borderColor = THEME_COLOR.CGColor;
}

- (IBAction)requestForOauth:(id)sender {
    [self sendAuthRequest];
}

- (void)sendAuthRequest {
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"TravelNote_iOS";
    [WXApi sendAuthReq:req viewController:self delegate:(AppDelegate *)[[UIApplication sharedApplication] delegate]];
//    [WXApi sendReq:req];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
