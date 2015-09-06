//
//  PCChoosePhotosController.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/24.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCChoosePhotosController.h"
#import "PCPhotosManager.h"
#import "PCChoosePhotosCell.h"
#import "PCAddNoteViewController.h"

#import "PCTravelNoteCreator.h"
#import "PCSingleNoteModel.h"

#import "NSDate+MilliSeconds.h"
#import "UIImage+ImagesAbout.h"

#import "PCBaseWebViewController.h"

@interface PCChoosePhotosController () {
    const PCPhotosManager *__photosMgr;
}

@property (strong, nonatomic) NSMutableDictionary *dic_index;       // 图片的index与Note的index的映射
@property (strong, nonatomic) NSMutableArray      *singleNotes;     // 已经准备好的singleNote

@end

@implementation PCChoosePhotosController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dic_index = [NSMutableDictionary dictionary];
    self.singleNotes = [NSMutableArray array];
    self.partsCount = 0;
    
    self.collectionView.alpha = 0.0;
    
    __photosMgr = [PCPhotosManager shared];
    
    [_collectionView registerClass:[PCChoosePhotosCell class] forCellWithReuseIdentifier:@"TNChoosePhotosCell"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:__photosMgr.assets.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    self.collectionView.alpha = 1.0;
}

- (IBAction)lastAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateCompletedDicContentsAtIndex:(NSIndexPath *)indexpath contents:(NSDictionary *)contents {
    /*
     contents的格式为: (需要和PCSingleNoteModel中的属性保持一致)
     pic : Base64 encoded
     intro
     pageIndex : Index of style in template(String)(random by default)
     timeStamp
     */
    
    NSString *key = [NSString stringWithFormat:@"%d", (int)(indexpath.row)];
    
    // 传入contents为nil, 即取消选择
    if (contents == nil) {
        if (self.dic_index[key] != nil) {
            NSInteger map_index = [self.dic_index[key] integerValue];
            if (map_index >= self.singleNotes.count) {
                NSLog(@"并没有这么多的singleNotes, index越界");
                return ;
            }
            [self.singleNotes removeObjectAtIndex:map_index];
            [self.dic_index removeObjectForKey:key];
            for (NSInteger i = map_index; i < self.singleNotes.count; i++) {
                PCSingleNoteModel *model = self.singleNotes[i];
//                model.pageIndex = @(i);
                [self.dic_index setObject:@(i) forKey:[NSString stringWithFormat:@"%d", (int)(model.indexpath.row)]];
            }
            self.partsCount--;
            [self updateCellStatus:NO atIndexPath:indexpath];
        } else {
            NSLog(@"想要移除本不存在的项!");
        }
        return ;
    }
    
    // 信息缺失。
    if (! (contents[@"imageURL"] && contents[@"text"]) ) {
        NSLog(@"内容缺失!");
        return ;
    }
    
    // 添加或者更新图片
    PCSingleNoteModel *model = [[PCSingleNoteModel alloc] initWithInfo:@{@"intro": contents[@"text"],
//                                                                         @"pageIndex": @(self.dic_index.count),
                                                                         @"timestamp": [NSDate millisecondsFrom1970ByNow]}];
    model.indexpath = indexpath;
    __weak PCSingleNoteModel *weakModel = model;
    [__photosMgr takeOutAspectRatioThumbnailPhotoAtIndex:indexpath.row usingBlock:^(UIImage *image, NSInteger index) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            weakModel.pic = [UIImageJPEGRepresentation([UIImage imageWithImage:image scaledToSize:CGSizeMake(800, 800)], 1) base64EncodedStringWithOptions:0];
            weakModel.pic = [UIImageJPEGRepresentation(image, 1) base64EncodedStringWithOptions:0];
        });
    } failureBlock:^(NSError *error) {
        NSLog(@"加载图片出错, 原因 : %@", error.localizedDescription);
    }];
    [self.dic_index setObject:@(self.dic_index.count) forKey:key];
    [self.singleNotes addObject:model];
    self.partsCount++;
    [self updateCellStatus:YES atIndexPath:indexpath];
}

- (void)updateCellStatus:(BOOL)status atIndexPath:(NSIndexPath *)indexpath {
    PCChoosePhotosCell *cell =  (PCChoosePhotosCell *)[_collectionView cellForItemAtIndexPath:indexpath];
    if (cell != nil) {
        [cell setStatus:status];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPartsCount:(NSInteger)partsCount {
    _partsCount = partsCount;
    
    // 只要有图片了就使“下一步”按钮enable
    if (partsCount > 0) {
        [_nextBtn setEnabled:YES];
    } else {
        [_nextBtn setEnabled:NO];
    }
}

- (IBAction)nextAction:(id)sender {
    [PCTravelNoteCreator shared].content = self.singleNotes;
    
    
    MBProgressHUD *hud = [self.navigationController.view HUDForLoadingText:@"正在上传, 请稍后"];
    __weak MBProgressHUD *weakHUD = hud;
    __weak typeof(self) weakSelf = self;
    [[PCTravelNoteCreator shared] uploadNewArticleWithBlock:^(BOOL success, NSString *articleId) {
        weakHUD.mode = MBProgressHUDModeText;
        weakHUD.labelText = success? @"上传成功": @"上传失败";
        [weakHUD hide:YES afterDelay:1];
        
        if (success == YES) {
//            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf showModifyingViewWithArticleId:articleId];
            });
        }
    }];
}

- (void)showModifyingViewWithArticleId:(NSString *)articleId {
    PCBaseWebViewController *baseWebView = [self.storyboard instantiateViewControllerWithIdentifier:@"TNBaseWebViewController"];
    baseWebView.articleId = articleId;
    baseWebView.temp = [PCTravelNoteCreator shared].temp;
    baseWebView.URLString = [NSString stringWithFormat:@"http://travel.changjiangcp.com/webs/%@/adjust", articleId];
    baseWebView.webViewType = TNWebViewTypeAdjustWhenFinished;
    baseWebView.title = [PCTravelNoteCreator shared].title;
    [self.navigationController pushViewController:baseWebView animated:YES];
}

#pragma mark - protocol - collection view

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return __photosMgr.assets.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TNChoosePhotosCell";
    
    PCChoosePhotosCell *cell = (PCChoosePhotosCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[PCChoosePhotosCell alloc] init];
        NSLog(@"init choose photos collection cell");
    }
    
    cell.indexpath = indexPath;
    
    __weak PCChoosePhotosCell *weakCell = (PCChoosePhotosCell *)cell;
    
    // 判断这个cell的状态
    NSString *key = [NSString stringWithFormat:@"%d", (int)indexPath.row];
    if (self.dic_index[key] != nil) {
        [weakCell setStatus:YES];
    } else {
        [weakCell setStatus:NO];
    }
    
    [__photosMgr takeOutThumbnailPhotoAtIndex:indexPath.row usingBlock:^(UIImage *image, NSInteger index) {
        if (weakCell.indexpath.row == index) {
            weakCell.imageView_photo.image = image;
        }
    } failureBlock:^(NSError *error) {
        [self logWarningText:@"拿出照片出现错误。"];
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    PCChoosePhotosCell *cell = (PCChoosePhotosCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell != nil) {
        // 如果parts已经满了不能继续添加。
//        if (_partsCount == _totalParts &&
//            cell.status == NO) {
//            return ;
//        }
        
//        PCAddNoteViewController *addNoteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TNAddNoteViewController"];
//        addNoteVC.assetIndex = indexPath.row;
//        if (cell.status == YES) {
//            // 已经存在, 进行修改或取消
//            NSInteger map_index = [self.dic_index[[NSString stringWithFormat:@"%d", (int)indexPath.row]] integerValue];
//            if (map_index >= self.singleNotes.count) {
//                NSLog(@"并没有这么多的singleNotes, index越界");
//                return ;
//            }
//            PCSingleNoteModel *model = self.singleNotes[map_index];
//            addNoteVC.lastUpdatedText = model.intro;
//        }
//        // Note:暂定为作为child vc存在。
//        [self.navigationController addChildViewController:addNoteVC];
//        [self.navigationController.view addSubview:addNoteVC.view];
//        [addNoteVC didMoveToParentViewController:self.navigationController];
//        
//        __weak PCAddNoteViewController *weakAddNoteVC = addNoteVC;
//        [addNoteVC usingBlockWhenEdittingFinished:^(NSInteger index, BOOL modified) {
//            // 根据modified进行不同动作:
//            // NO  -> 不需要进行操作
//            // YES -> 更改或添加相应项
//            if (modified == YES) {
//                if (weakAddNoteVC.textView.text == nil ||
//                    // 取消之
//                    weakAddNoteVC.textView.text.length == 0) {
//                    [self updateCompletedDicContentsAtIndex:indexPath contents:nil];
//                } else {
//                    // 更新之或添加之
//                    NSDictionary *contents = @{@"imageURL": [[PCPhotosManager shared] assets][index],
//                                               @"text": weakAddNoteVC.textView.text};
//                    [self updateCompletedDicContentsAtIndex:indexPath contents:contents];
//                }
//            }
//            
//            [weakAddNoteVC willMoveToParentViewController:nil];
//            [weakAddNoteVC.view removeFromSuperview];
//            [weakAddNoteVC removeFromParentViewController];
//        }];
        
        
        // 修改后 - 不存在编辑文字页面
        if (cell.status == YES) {
            // 已经存在, 取消
            [self updateCompletedDicContentsAtIndex:indexPath contents:nil];
        } else {
            NSDictionary *contents = @{@"imageURL": [[PCPhotosManager shared] assets][indexPath.row],
                                       @"text": [NSString string]};
            [self updateCompletedDicContentsAtIndex:indexPath contents:contents];
        }
    } else {
        [self logWarningText:@"点击-动作处理时cell为nil。"];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float length = (SCREEN_WIDTH-15)/2;
    return CGSizeMake(length, length);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 0, 5);
}

@end
