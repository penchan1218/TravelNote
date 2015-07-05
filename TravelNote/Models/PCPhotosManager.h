//
//  PCPhotosManager.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/23.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PCPhotosManager : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *assets;

+ (PCPhotosManager *)shared;

- (void)takeOutThumbnailPhotoAtIndex:(NSInteger)index usingBlock:(void (^)(UIImage *image, NSInteger index))handlerBlock failureBlock:(void (^)(NSError *error))failureBlock;

- (void)takeOutAspectRatioThumbnailPhotoAtIndex:(NSInteger)index usingBlock:(void (^)(UIImage *image, NSInteger index))handlerBlock failureBlock:(void (^)(NSError *error))failureBlock;

@end
