//
//  PCOthersInfoViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/29.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCOthersInfoViewController.h"
#import "PCPostNotificationCenter.h"
#import "PCSelfInformationModel.h"

@interface PCOthersInfoViewController ()

@end

@implementation PCOthersInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (![self.userId isEqualToString:[PCSelfInformationModel sharedInstance].unionid]) {
        CGFloat inset = 10.0;
        UIButton *btn_follow = [[UIButton alloc] init];
        btn_follow.alpha = 0.0;
        [btn_follow setContentEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
        [btn_follow.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [btn_follow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn_follow setTitle:@"关注" forState:UIControlStateNormal];
        
        btn_follow.layer.cornerRadius = 4.0;
        btn_follow.layer.borderWidth = 1.0;
        btn_follow.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [btn_follow addTarget:self action:@selector(shouldFollow) forControlEvents:UIControlEventTouchUpInside];
        [btn_follow sizeToFit];
        [btn_follow setCenter:CGPointMake(SCREEN_WIDTH-inset-btn_follow._width/2, inset+btn_follow._height/2)];
        [self.headerView addSubview:btn_follow];
        self.btn_follow = btn_follow;
        
        UIActivityIndicatorView *indicator_follow = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator_follow.hidesWhenStopped = YES;
        [indicator_follow setCenter:btn_follow.center];
        [self.headerView addSubview:indicator_follow];
        self.indicator_follow = indicator_follow;
        
        [self.indicator_follow startAnimating];
    }
}

- (void)shouldFollow {
    self.btn_follow.alpha = 0.0;
    [self.indicator_follow startAnimating];
    
    __weak typeof(self) weakSelf = self;
    if (self.hasFollow) {
        [PCNetworkManager unfollowTheUser:self.userInfo.userId ok:^(BOOL success) {
            weakSelf.hasFollow = success? NO: YES;
            if (success) {
                [PCPostNotificationCenter postNotification_unfollowSomeone_withObj:nil userId:weakSelf.userInfo.userId];
            }
        }];
    } else {
        [PCNetworkManager followTheUser:self.userInfo.userId ok:^(BOOL success) {
            weakSelf.hasFollow = success? YES: NO;
            if (success) {
                [PCPostNotificationCenter postNotification_followSomeone_withObj:nil userId:weakSelf.userInfo.userId];
            }
        }];
    }
}

- (void)hasFollow:(BOOL)hasFollow {
    [self.indicator_follow stopAnimating];
    
    NSString *title = hasFollow?@"已关注":@"关注";
    UIColor  *titleColor = hasFollow?UIColorFromRGBA(213, 94, 96, 1.0f):[UIColor whiteColor];
    [self.btn_follow setTitle:title forState:UIControlStateNormal];
    [self.btn_follow setTitleColor:titleColor forState:UIControlStateNormal];
    self.btn_follow.layer.borderColor = titleColor.CGColor;
    [self.btn_follow sizeToFit];
    [self.btn_follow setCenter:self.indicator_follow.center];
    
    self.btn_follow.alpha = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUserInfo:(PCUserInformationModel *)userInfo {
    [super setUserInfo:userInfo];
    
    __weak typeof(self) weakSelf = self;
    [PCNetworkManager requestLoggedUserIsFollowedTheUser:userInfo.userId ok:^(BOOL hasFollow) {
        weakSelf.hasFollow = hasFollow;
    }];
}

- (void)setHasFollow:(BOOL)hasFollow {
    _hasFollow = hasFollow;
    
    [self hasFollow:hasFollow];
}

#pragma mark - override

- (void)receiveHasFollowedNotification:(NSNotification *)notif {
    [super receiveHasFollowedNotification:notif];
    
    NSString *userId = [notif.userInfo objectForKey:@"userId"];
    if ([self.userInfo.userId isEqualToString:userId]) {
        self.hasFollow = YES;
    }
}

- (void)receiveHasUnFollowedNotification:(NSNotification *)notif {
    [super receiveHasUnFollowedNotification:notif];
    
    NSString *userId = [notif.userInfo objectForKey:@"userId"];
    if ([self.userInfo.userId isEqualToString:userId]) {
        self.hasFollow = NO;
    }
}

@end
