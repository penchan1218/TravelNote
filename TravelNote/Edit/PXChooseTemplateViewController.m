//
//  PXChooseTemplateViewController.m
//  TravelNote
//
//  Created by 朱泌丞 on 15/6/9.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PXChooseTemplateViewController.h"
#import "PCChoosePhotosController.h"

@interface PXChooseTemplateViewController ()

@end

@implementation PXChooseTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // 根据模板，添加totalParts。
    if ([segue.identifier isEqualToString:@"TNChoosePhotos"]) {
        PCChoosePhotosController *choosePhotosVC = [segue destinationViewController];
        // Note:暂定为1。
        choosePhotosVC.totalParts = 1;
    }
}


@end
