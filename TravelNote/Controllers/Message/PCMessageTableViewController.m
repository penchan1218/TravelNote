//
//  PCMessageTableViewController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/11.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCMessageTableViewController.h"
#import "PCNetworkManager.h"
#import "UIRefreshControl+AFNetworking.h"

#import "PCMessageModel+Helper.h"

#import "PCOthersInfoViewController.h"
#import "PCTravelNoteViewController.h"

@interface PCMessageTableViewController () <UIAlertViewDelegate> {
    NSMutableString *cellContents;
}

@property (strong, nonatomic) NSMutableArray *models_message;

@property (weak, nonatomic) PCMessageModel *message_aboutToDelete;

@property (nonatomic, copy)   NSNumber       *milliseconds;

@end

@implementation PCMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.models_message = [NSMutableArray array];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:[PCMessageCell class] forCellReuseIdentifier:@"TNTextMessageCell"];
    [self.tableView registerClass:[PCMessageCell class] forCellReuseIdentifier:@"TNCommentsMessageCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(redownloadMessages) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self redownloadMessages];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [PCPostNotificationCenter postNotification_showTabbar_withObj:nil];
}

- (void)redownloadMessages {
    [self redownloadMessages:self.milliseconds];
}

- (void)redownloadMessages:(NSNumber *)milliseconds {
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *task = [PCNetworkManager getUserMessages:milliseconds ok:^(NSArray *JSON, NSNumber *milliseconds) {
        NSMutableIndexSet *insertedIndexes = [NSMutableIndexSet indexSet];
        NSMutableArray *insertedModels = [NSMutableArray array];
        for (NSInteger i = 0; i < JSON.count; i++) {
            PCMessageModel *model = [[PCMessageModel alloc] initWithInfo:JSON[i]];
            [insertedModels addObject:model];
            [insertedIndexes addIndex:i];
        }
        [weakSelf.models_message insertObjects:insertedModels atIndexes:insertedIndexes];
        [weakSelf renewIndexpathOfModels];
        [weakSelf renewCellHeightOfModels:insertedModels];
        [weakSelf.tableView reloadData];
        weakSelf.milliseconds = milliseconds;
    }];
    [self.refreshControl setRefreshingWithStateOfTask:task];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol - table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _models_message.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCMessageModel *model = _models_message[indexPath.row];
    return model.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCMessageModel *model = _models_message[indexPath.row];
    
    PCMessageCell *cell;
    if (model.__messageType == MessageTypeComment) {
        cell = [tableView dequeueReusableCellWithIdentifier:TNCommentsMessageCellIdentifier];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:TNTextMessageCellIdentifier];
    }
    [model reloadCell:cell];
    
    __weak typeof(self) weakSelf = self;
    cell.showUserInfoBlock = ^(NSString *userId) {
        if (userId) {
            PCOthersInfoViewController *userInfoVC = [[PCOthersInfoViewController alloc] init];
            userInfoVC.userId = userId;
            [weakSelf.navigationController pushViewController:userInfoVC animated:YES];
        }
    };
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(PCMessageCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.message_aboutToDelete = self.models_message[indexPath.row];
    [[[UIAlertView alloc] initWithTitle:@"将要删除评论"
                               message:@"将要删除该条评论，且不可恢复"
                              delegate:self
                     cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PCMessageCell *cell = (PCMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    PCMessageModel *model = self.models_message[indexPath.row];
    if (model.__messageType == MessageTypeFollow) {
        if (cell && cell.showUserInfoBlock) {
            cell.showUserInfoBlock(cell.fromId);
        }
    } else if (model.__messageType == MessageTypeLike ||
               model.__messageType == MessageTypeComment) {
        NSString *articleid = model.articleId;
        if (articleid != nil) {
            PCTravelNoteViewController *travelNoteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TNTravelNoteViewController"];
            [self.navigationController pushViewController:travelNoteVC animated:YES];
            
            __weak PCTravelNoteViewController *weakTravelNoteVC = travelNoteVC;
            [PCNetworkManager getArticle:articleid ok:^(NSDictionary *JSON, NSString *_articleid) {
                PCTravelNoteModel *model_travelNote = [[PCTravelNoteModel alloc] initWithInfo:JSON];
                weakTravelNoteVC.model_tralvelNote = model_travelNote;
            }];
        }
    }
}

#pragma mark - Protocol - alert view

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        __weak MBProgressHUD *hud = [self.view HUDForLoadingText:@"正在删除"];
        __weak typeof(self) weakSelf = self;
        [PCNetworkManager deleteSingleMessage:self.message_aboutToDelete._id ok:^(BOOL success) {
            if (success) {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"删除成功";
                [hud hide:YES afterDelay:1.0];
                
                NSIndexPath *indexpath = [weakSelf.message_aboutToDelete.indexpath copy];
                [weakSelf.models_message removeObject:weakSelf.message_aboutToDelete];
                [weakSelf renewIndexpathOfModels];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
                weakSelf.message_aboutToDelete = nil;
            } else {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"删除失败";
                [hud hide:YES afterDelay:1.0];
            }
        }];
    } else {
        self.message_aboutToDelete = nil;
    }
}

- (void)renewIndexpathOfModels {
    for (NSInteger i = 0; i < self.models_message.count; i++) {
        PCMessageModel *model = self.models_message[i];
        model.indexpath = [NSIndexPath indexPathForRow:i inSection:0];
    }
}

- (void)renewCellHeightOfModels:(NSArray *)updatedModels {
    PCMessageCell *cell_text = [self.tableView dequeueReusableCellWithIdentifier:TNTextMessageCellIdentifier];
    PCMessageCell *cell_comments = [self.tableView dequeueReusableCellWithIdentifier:TNCommentsMessageCellIdentifier];
    for (PCMessageModel *model in updatedModels) {
        if (model.__messageType == MessageTypeComment) {
            [model reloadCell:cell_comments];
        } else {
            [model reloadCell:cell_text];
        }
    }
}

@end
