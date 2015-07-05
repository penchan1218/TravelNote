//
//  PCChoosePhotosController.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/24.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCChoosePhotosController : UIViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBtn;

@property (nonatomic, assign, readonly) NSInteger partsCount;
@property (nonatomic, assign) NSInteger totalParts;

@end
