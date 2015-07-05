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

@interface PCChoosePhotosController () {
    const PCPhotosManager *__photosMgr;
}

@property (strong, nonatomic) NSMutableDictionary *completedDic;

@end

@implementation PCChoosePhotosController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化储存已选择图片的Dic;
    _completedDic = [NSMutableDictionary dictionary];
    self.partsCount = 0;
    
    __photosMgr = [PCPhotosManager shared];
    
    [_collectionView registerClass:[PCChoosePhotosCell class] forCellWithReuseIdentifier:@"TNChoosePhotosCell"];
}

- (IBAction)lastAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateCompletedDicContentsAtIndex:(NSIndexPath *)indexpath contents:(NSDictionary *)contents {
    // contents的格式为:
    // {@"imageURL": <image URL>,
    //  @"text"    : <附文>}
    
    // 传入contents为nil, 即取消选择
    if (contents == nil) {
        if (_completedDic[[NSString stringWithFormat:@"%d", (int)indexpath.row]] != nil) {
            [_completedDic removeObjectForKey:[NSString stringWithFormat:@"%d", (int)indexpath.row]];
            self.partsCount--;
            [self updateCellStatus:NO atIndexPath:indexpath];
        } else {
            [self logWarningText:@"想要移除本不存在的项。"];
        }
        return ;
    }
    
    // 信息缺失。
    if (! (contents[@"imageURL"] && contents[@"text"]) ) {
        [self logWarningText:@"内容缺失。"];
        return ;
    }
    
    // 添加或者更新图片
    [_completedDic setObject:contents forKey:[NSString stringWithFormat:@"%d", (int)indexpath.row]];
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
    
    // 根据更新了的_partCount与totalParts对比，进行相应的操作。
    if (_partsCount == _totalParts) {
        // parts数量达到，“下一步”按钮激活。
        [_nextBtn setTitle:@"下一步"];
        [_nextBtn setEnabled:YES];
    } else if (_partsCount < _totalParts) {
        // parts数量尚未达到，仍需要添加。
        [_nextBtn setTitle:nil];
        [_nextBtn setEnabled:NO];
    } else {
        // 非法：parts数量超出，不应该出现这种情况，请排除原因。
        [self logWarningText:@"parts数量超出，不应该出现这种情况，请排除原因。"];
    }
    
    // 更新_tipsLabel的文字
    [_tipsLabel setText:[NSString stringWithFormat:@"%d / %d", (int)_partsCount, (int)_totalParts]];
}


//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"TNAddTitle"]) {
//        // 测试placeholder
//        PCAddTitleViewController *desVC = [segue destinationViewController];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            desVC.descriptionTV.placeHolder = @"Just test placeHolder";
//        });
//    }
//}


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
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak PCChoosePhotosCell *weakCell = (PCChoosePhotosCell *)cell;
    
    // 判断这个cell的状态
    if (_completedDic[[NSString stringWithFormat:@"%d", (int)indexPath.row]] != nil) {
        [weakCell setStatus:YES];
    } else {
        [weakCell setStatus:NO];
    }
    
    [__photosMgr takeOutThumbnailPhotoAtIndex:indexPath.row usingBlock:^(UIImage *image, NSInteger index) {
        weakCell.imageView_photo.image = image;
    } failureBlock:^(NSError *error) {
        [self logWarningText:@"拿出照片出现错误。"];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    PCChoosePhotosCell *cell = (PCChoosePhotosCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell != nil) {
        // 如果parts已经满了不能继续添加。
        if (_partsCount == _totalParts &&
            cell.status == NO) {
            return ;
        }
        
        PCAddNoteViewController *addNoteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TNAddNoteViewController"];
        addNoteVC.assetIndex = indexPath.row;
        if (cell.status == YES) {
            // 已经存在, 进行修改或取消
            addNoteVC.lastUpdatedText = _completedDic[[NSString stringWithFormat:@"%d", (int)indexPath.row]][@"text"];
        }
        // Note:暂定为作为child vc存在。
        [self.navigationController addChildViewController:addNoteVC];
        [self.navigationController.view addSubview:addNoteVC.view];
        [addNoteVC didMoveToParentViewController:self.navigationController];
        
        __weak PCAddNoteViewController *weakAddNoteVC = addNoteVC;
        [addNoteVC usingBlockWhenEdittingFinished:^(NSInteger index, BOOL modified) {
            // 根据modified进行不同动作:
            // NO  -> 不需要进行操作
            // YES -> 更改或添加相应项
            if (modified == YES) {
                if (weakAddNoteVC.textView.text == nil ||
                    // 取消之
                    weakAddNoteVC.textView.text.length == 0) {
                    [self updateCompletedDicContentsAtIndex:indexPath contents:nil];
                } else {
                    // 更新之或添加之
                    NSDictionary *contents = @{@"imageURL": [[PCPhotosManager shared] assets][index],
                                               @"text": weakAddNoteVC.textView.text};
                    [self updateCompletedDicContentsAtIndex:indexPath contents:contents];
                }
            }
            
            [weakAddNoteVC willMoveToParentViewController:nil];
            [weakAddNoteVC.view removeFromSuperview];
            [weakAddNoteVC removeFromParentViewController];
        }];
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
