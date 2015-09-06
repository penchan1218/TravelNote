//
//  PCUserInfoViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/24.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCUserInfoViewController.h"
#import "PCMyInfoSettingViewController.h"
#import "PCBaseWebViewController.h"

@interface PCUserInfoViewController ()

@end

@implementation PCUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat inset = 10.0;
    CGFloat width = 44.0;
    UIButton *btn_setting = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-inset-width, inset, width, width)];
    btn_setting.contentMode = UIViewContentModeCenter;
    [btn_setting setImage:[UIImage imageNamed:@"btn_setting"] forState:UIControlStateNormal];
    [btn_setting addTarget:self action:@selector(settingUserInformation) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:btn_setting];
    self.btn_setting = btn_setting;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TNShouldEditOneTravelNoteNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      NSString *articleId = [note.userInfo objectForKey:@"articleId"];
                                                      
                                                      PCBaseWebViewController *baseWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"TNBaseWebViewController"];
                                                      baseWebView.articleId = articleId;
                                                      baseWebView.URLString = [NSString stringWithFormat:@"http://travel.changjiangcp.com/webs/%@/adjust", articleId];
                                                      baseWebView.webViewType = TNWebViewTypeAdjustAfterFinished;
                                                      baseWebView.title = @"编辑";
                                                      [self.navigationController pushViewController:baseWebView animated:YES];
                                                  }];
}

- (void)settingUserInformation {
    PCMyInfoSettingViewController *settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TNMyInfoSettingViewController"];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
