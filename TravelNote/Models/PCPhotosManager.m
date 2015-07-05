//
//  PCPhotosManager.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/23.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCPhotosManager.h"

typedef NS_ENUM(NSUInteger, PhotoType) {
    Thumbnail,
    AspectRatioThumbnail
};

static PCPhotosManager *__sharedInstance = nil;

@implementation PCPhotosManager

+ (PCPhotosManager *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[PCPhotosManager alloc] init];
        [__sharedInstance setup];
    });
    
    return __sharedInstance;
}

- (void)setup {
    _assets = [NSMutableArray array];
    
    ALAssetsLibrary *assetsLib = [[ALAssetsLibrary alloc] init];
    [assetsLib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos//ALAssetsGroupAlbum //| ALAssetsGroupEvent | ALAssetsGroupFaces
                             usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                 if (group != nil) {
                                     [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                     [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                         if (result != nil) {
                                             [_assets addObject:[[result defaultRepresentation] url]];
                                         }
                                     }];
                                 }
                             } failureBlock:^(NSError *error) {
                                 [self logWarningText:[NSString stringWithFormat:@"打开相册时出现错误:%@", error.localizedDescription]];
                             }];
}

- (void)takeOutThumbnailPhotoAtIndex:(NSInteger)index usingBlock:(void (^)(UIImage *image, NSInteger index))handlerBlock failureBlock:(void (^)(NSError *error))failureBlock {
    [self takeOutPhotoOfType:Thumbnail atIndex:index usingBlock:handlerBlock failureBlock:failureBlock];
}

- (void)takeOutAspectRatioThumbnailPhotoAtIndex:(NSInteger)index usingBlock:(void (^)(UIImage *image, NSInteger index))handlerBlock failureBlock:(void (^)(NSError *error))failureBlock {
    [self takeOutPhotoOfType:AspectRatioThumbnail atIndex:index usingBlock:handlerBlock failureBlock:failureBlock];
}

- (void)takeOutPhotoOfType:(PhotoType)photoType atIndex:(NSInteger)index usingBlock:(void (^)(UIImage *image, NSInteger index))handlerBlock failureBlock:(void (^)(NSError *error))failureBlock {
    if (index >= _assets.count) {
        [self logWarningText:@"index越界。"];
        return ;
    }
    
    if (handlerBlock == nil) {
        [self logWarningText:@"没有handlerBlock，调用无效。"];
        return ;
    }
    
    ALAssetsLibrary *assetsLib = [[ALAssetsLibrary alloc] init];
    [assetsLib assetForURL:_assets[index] resultBlock:^(ALAsset *asset) {
        switch (photoType) {
            case Thumbnail:
                handlerBlock([UIImage imageWithCGImage:[asset thumbnail]], index);
                break;
            case AspectRatioThumbnail:
                handlerBlock([UIImage imageWithCGImage:[asset aspectRatioThumbnail]], index);
                break;
            default:
                break;
        }
    } failureBlock:^(NSError *error) {
        [self logWarningText:@"通过url访问图片失败。"];
        if (failureBlock != nil) {
            failureBlock(error);
        }
    }];
}

@end