//
//  PXChooseTemplateViewController.m
//  TravelNote
//
//  Created by 朱泌丞 on 15/6/9.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PXChooseTemplateViewController.h"
#import "PCAddTitleViewController.h"
#import "PCNetworkManager.h"

#import "PCTemplateModel+Helper.h"
#import "PCTravelNoteCreator.h"

#import "PCBaseWebViewController.h"

@interface PXChooseTemplateViewController ()

@property (strong, nonatomic) NSMutableArray *templates;

@property (nonatomic, assign) NSInteger _selectedIndex;

@end

@implementation PXChooseTemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [[PCTravelNoteCreator shared] clear];
    
    self.templates = [NSMutableArray array];
    
    _btn_title.layer.cornerRadius = _btn_title.frame.size.height/2;
    _btn_title.layer.borderColor = [UIColor blackColor].CGColor;
    
    __weak typeof(self) weakSelf = self;
    [PCNetworkManager listTempsInformationWithOK:^(NSArray *JSON) {
        if (JSON.count > 0) {
            for (NSDictionary *dic in JSON) {
                PCTemplateModel *model = [[PCTemplateModel alloc] initWithInfo:dic];
                [weakSelf.templates addObject:model];
                model.indexpath = [NSIndexPath indexPathForRow:weakSelf.templates.count-1 inSection:0];
            }
            weakSelf.scrollView.delegate_chooseTemplates = weakSelf;
            weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if ([segue.identifier isEqualToString:@"TNAddTitle"]) {
        PCTemplateModel *model = self.templates[self._selectedIndex];
        [PCTravelNoteCreator shared].temp = model.tempId;
    }
}

#pragma mark - Protocol - PCChooseTemplates scroll view

- (NSInteger)numberOfTemplatesInChooseTemplatesScrollView:(PCChooseTemplatesScrollView *__weak)scrollView {
    return self.templates.count;
}

- (void)chooseTemplatesScrollViewReloadTemplate:(UIImageView *__weak)imageview {
    PCTemplateModel *model = self.templates[imageview.tag];
    [model reloadTemplate:imageview];
}

- (void)chooseTemplatesScrollView:(PCChooseTemplatesScrollView *__weak)scrollView didSelectTemplateAtIndex:(NSInteger)index {
    self._selectedIndex = index;
    
    PCTemplateModel *model = self.templates[index];
    NSLog(@"%@", model.name);
//    [_btn_title setTitle:[NSString stringWithFormat:@"当前选择：%@", model.name]
//                forState:UIControlStateNormal];
}

- (void)chooseTemplatesScrollView:(PCChooseTemplatesScrollView *__weak)scrollView didShowTemplateAtIndex:(NSInteger)index {
    PCTemplateModel *model = self.templates[index];
    [_btn_title setTitle:model.name
                forState:UIControlStateNormal];
}

- (void)chooseTemplatesScrollView:(PCChooseTemplatesScrollView *__weak)scrollView previewTemplateAtIndex:(NSInteger)index {
    PCTemplateModel *model = self.templates[index];
    
    PCBaseWebViewController *baseWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"TNBaseWebViewController"];
    baseWebView.URLString = [NSString stringWithFormat:@"http://travel.changjiangcp.com/view/example/%ld", (unsigned long)([model.tempId integerValue])];
    baseWebView.webViewType = TNWebViewTypePreviewTemplates;
    baseWebView.coverImg = model.coverImg;
    baseWebView.title = model.name;
    [self.navigationController pushViewController:baseWebView animated:YES];
}

@end
