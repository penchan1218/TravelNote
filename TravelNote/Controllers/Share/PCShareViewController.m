//
//  PCShareViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/28.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCShareViewController.h"
#import "UIView+BGTouchView.h"

@interface PCShareViewController ()

@property (nonatomic, weak) UIView *view_choices;

@property (nonatomic, assign) NSInteger curr_choices;

@end

@implementation PCShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    
    UIView *view_choices = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-60-20-20, SCREEN_WIDTH, 100)];
    view_choices.backgroundColor = UIColorFromRGBA(235, 240, 245, 1.0f);
    [self.view addSubview:view_choices];
    self.view_choices = view_choices;
    
    UILabel *label_shareTo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    label_shareTo.textAlignment = NSTextAlignmentCenter;
    label_shareTo.textColor = UIColorFromRGBA(160, 160, 160, 1.0);
    label_shareTo.font = [UIFont systemFontOfSize:12.0];
    label_shareTo.text = @"分享至:";
    [view_choices addSubview:label_shareTo];
    
    [self addChoiceWithImageName:@"icon_wechat_session" title:@"微信好友"];
    [self addChoiceWithImageName:@"icon_wechat_timeline" title:@"朋友圈"];
    [self addChoiceWithImageName:@"icon_wechat_favorite" title:@"收藏"];
    
    [self hideChoices];
}

- (void)hideChoices {
    [self hideChoices:nil];
}

- (void)hideChoices:(void (^)(BOOL))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 0.0;
        self.view_choices.transform = CGAffineTransformMakeTranslation(0, 100);
    } completion:completion];
}

- (void)showChoices {
    [self showChoices:nil];
}

- (void)showChoices:(void (^)(BOOL))completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 1.0;
        self.view_choices.transform = CGAffineTransformIdentity;
    } completion:completion];
}

- (void)addChoiceWithImageName:(NSString *)imgName title:(NSString *)title {
    NSInteger curr_choices = self.curr_choices;
    UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(60*curr_choices, 20, 60, 60)];
    imgview.contentMode = UIViewContentModeCenter;
    imgview.tag = curr_choices;
    imgview.image = [UIImage imageNamed:imgName];
    [self.view_choices addSubview:imgview];
    self.curr_choices ++;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(60*curr_choices, 80, 60, 10)];
    lbl.font = [UIFont systemFontOfSize:10.0];
    lbl.textColor = UIColorFromRGBA(160, 160, 160, 1.0);
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = title;
    [self.view_choices addSubview:lbl];
    
    __weak typeof(self) weakSelf = self;
    [imgview touchEndedBlock:^(UIView *selfView) {
        if (weakSelf.delegate) {
            [weakSelf.delegate willShareToWechatScene:selfView.tag];
            
            [weakSelf willMoveToParentViewController:nil];
            [weakSelf.view removeFromSuperview];
            [weakSelf removeFromParentViewController];
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    __weak typeof(self) weakSelf = self;
    [self hideChoices:^(BOOL finished) {
        if (weakSelf.cancelBlock) {
            weakSelf.cancelBlock();
        }
        
        [weakSelf willMoveToParentViewController:nil];
        [weakSelf.view removeFromSuperview];
        [weakSelf removeFromParentViewController];
    }];
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
