//
//  AppDelegate.m
//  TravelNote
//
//  Created by 朱泌丞 on 15/6/1.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "AppDelegate.h"
#import "PCNetworkManager.h"
#import "PCPhotosManager.h"
#import "PCSelfInformationModel.h"
#import "AFNetworkActivityIndicatorManager.h"

#import "NSDate+MilliSeconds.h"

#import "PCDBCenter.h"

#import "PCLoginViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    // Override point for customization after application launch.
    
    // 只是为了去除navigationbar底部separator
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    // 设置navigationbar的外表
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:THEME_COLOR];
    
    [WXApi registerApp:@"wx6e2879d101279c4b"];
//    [WXApi registerApp:@"wxd930ea5d5a258f4f" withDescription:@"demo 2.0"];
    
    // 设置缓存
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:256 * 1024 * 1024
                                                            diskCapacity:512 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    // 打开指示器
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
//    NSDictionary *dic_lauchOptions = [[NSUserDefaults standardUserDefaults] objectForKey:@"lauchOptions"];
//    NSLog(@"%@", dic_lauchOptions);
//    if (!dic_lauchOptions && launchOptions) {
//        [[NSUserDefaults standardUserDefaults] setObject:launchOptions forKey:@"lauchOptions"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
    
//#if DEBUG
//    [[NSUserDefaults standardUserDefaults] setObject:@"ozebss3SPx7iLkWxMA5doRgKm8dI" forKey:@"user_openid"];
//    [[NSUserDefaults standardUserDefaults] setObject:@"osnbasg5wmmMVwphIcbFQimwO7ME" forKey:@"user_unionid"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    [self setupWhenLogged];
//#else
//    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_openid"];
//    if (userId) {
//        __weak typeof(self) weakSelf = self;
//        __weak MBProgressHUD *hud = [self.window HUDForLoadingText:nil];
//        [PCNetworkManager checkIfBundled:userId ok:^(BOOL isBundled, NSDictionary *data) {
//            if (isBundled) {
//                [weakSelf setupWhenLogged];
//            } else {
//                [weakSelf setupWhenUnlogged];
//            }
//            [hud hide:YES];
//        }];
//    } else {
//        [self setupWhenUnlogged];
//    }
//#endif
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_openid"];
    if (userId) {
        UIView *lauchView = [[NSBundle mainBundle] loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
        lauchView.frame = [[UIScreen mainScreen] bounds];
        [self.window addSubview:lauchView];
        
        __weak typeof(self) weakSelf = self;
        __weak MBProgressHUD *hud = [lauchView HUDForLoadingText:nil];
        [PCNetworkManager checkIfBundled:userId ok:^(BOOL isBundled, NSDictionary *data) {
            if (isBundled) {
                [weakSelf setupWhenLogged];
            } else {
                [weakSelf setupWhenUnlogged];
            }
            [hud hide:YES];
            [lauchView removeFromSuperview];
        }];
    } else {
        [self setupWhenUnlogged];
    }

    
    
    
    // 暂定
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"] == NO) {
//        [PCNetworkManager __privateLogin];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    } else {
//        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"cookies_data"]];
//        for (NSHTTPCookie *cookie in cookies) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//        }
//    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupWhenLogged {
    // 显式第一次调用
    [PCPhotosManager shared];
    [PCNetworkManager shared];
    
    NSLog(@"%@", NSHomeDirectory());
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"] == NO) {
//#if DEBUG
//        [[NSUserDefaults standardUserDefaults] setObject:@"ozebss3SPx7iLkWxMA5doRgKm8dI" forKey:@"user_openid"];
//#endif
        [PCDBCenter firstTimeCreatingTables];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"user_openid"] != nil) {
        [PCNetworkManager __privateLoginWithOK:^{
            [PCSelfInformationModel sharedInstance];
        }];
    }
    
    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    
}

- (void)setupWhenUnlogged {
    PCLoginViewController *loginVC = [[PCLoginViewController alloc] init];
    self.window.rootViewController = loginVC;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == -2) {
            // 取消
            [PCPostNotificationCenter postNotification_cancelSharingToWechat_withObj:nil];
        } else if (resp.errCode == 0) {
            // 成功
            [PCPostNotificationCenter postNotification_shareToWechat_withObj:nil];
        }
        return ;
    }
    SendAuthResp *aresp = (SendAuthResp *)resp;
    if (aresp.errCode == 0) {
        NSString *code = aresp.code;
        __weak typeof(self) weakSelf = self;
        [PCNetworkManager fetchAccessTokenWithCode:code ok:^(BOOL success, NSDictionary *data) {
            if (success) {
                NSString *openId = data[@"openId"];
                NSString *unionId = data[@"unionId"];
                [[NSUserDefaults standardUserDefaults] setObject:openId forKey:@"user_openid"];
                [[NSUserDefaults standardUserDefaults] setObject:unionId forKey:@"user_unionid"];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"user_data"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [weakSelf setupWhenLogged];
            }
        }];
    } else {
        NSLog(@"微信请求出现错误码 : %d", (int)(aresp.errCode));
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
