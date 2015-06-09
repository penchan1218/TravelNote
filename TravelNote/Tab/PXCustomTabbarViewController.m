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

@end

@implementation PXCustomTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    NSLog(@"%@",self.childViewControllers);
    self.selectedIndex = 0;
    float height = self.view.frame.size.width * 50.0f / 375.0f;
    PXCustomTabbar *customBar = [[PXCustomTabbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - height, self.view.frame.size.width, height) TapAction:^(NSInteger index) {
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
    [self.view addSubview:customBar];
    // Do any additional setup after loading the view.
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
