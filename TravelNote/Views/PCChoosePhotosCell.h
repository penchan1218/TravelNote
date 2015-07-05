//
//  PCChoosePhotosCell.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/25.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCChoosePhotosCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView_photo;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_status;


@property (nonatomic, assign) BOOL status;

@end
