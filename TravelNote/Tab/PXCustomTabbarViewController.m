//
//  PXCustomTabbarViewController.m
//  TravelNote
//
//  Created by 朱泌丞 on 15/6/9.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PXCustomTabbarViewController.h"
#import "PXCustomTabbar.h"

@interface PXCustomTabbarViewController ()

@property (weak, nonatomic) PXCustomTabbar *customTabbar;

@end

@implementation PXCustomTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    self.tabBar.translucent = YES;
    self.selectedIndex = 0;
    
    float height = 49.0f;
    PXCustomTabbar *customBar = [[PXCustomTabbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-height, SCREEN_WIDTH, height) TapAction:^(NSInteger index) {
        if (index < 2) {
            self.selectedIndex = index;
        } else if (index > 2) {
            self.selectedIndex = index - 1;
        } else {
            UINavigationController *navVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editNav"];
            [self presentViewController:navVC animated:YES completion:^{
                
            }];
        }
    }];
    customBar.alpha = 0.0;
    [self.view addSubview:customBar];
    _customTabbar = customBar;

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            customBar.alpha = 1.0;
        }];
    });
    
    [[NSNotificationCenter defaultCenter] addObserverForName:TNCustomTabbarShouldHideNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [UIView animateWithDuration:0.1 animations:^{
                                                          customBar.frame = CGRectMake(0, SCREEN_HEIGHT+20, SCREEN_WIDTH, height);
                                                      }];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:TNCustomTabbarShouldShowNotification object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      [UIView animateWithDuration:0.1 animations:^{
                                                          customBar.frame = CGRectMake(0, SCREEN_HEIGHT-height, SCREEN_WIDTH, height);
                                                      }];
                                                  }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
