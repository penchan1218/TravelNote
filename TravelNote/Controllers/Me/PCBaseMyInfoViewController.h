//
//  PCBaseMyInfoViewController.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/23.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCBaseModel.h"

#import "PCMyinfoHeaderView.h"

typedef enum : NSUInteger {
    MyInfoViewControllerTypeUserInfo,
    MyInfoViewControllerTypeOthersInfo
} MyInfoViewControllerType;

@interface PCBaseMyInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, assign) MyInfoViewControllerType myInfoViewControllerType;

@property (nonatomic, weak) UIScrollView *scrollView;

@property (weak, nonatomic) PCMyinfoHeaderView  *headerView;
@property (weak, nonatomic) UITableView         *tableView;
@property (weak, nonatomic) UIRefreshControl    *refreshControl;

@property (strong, nonatomic) PCUserInformationModel *userInfo;

// 用作重写
- (void)receiveHasFollowedNotification:(NSNotification *)notif;
- (void)receiveHasUnFollowedNotification:(NSNotification *)notif;

@end
