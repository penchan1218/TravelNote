//
//  PCNetworkManager+Addition.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/6.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCNetworkManager+Addition.h"
#import "UIImage+ImagesAbout.h"
#import "NSDate+MilliSeconds.h"

@implementation PCNetworkManager (Addition)

+ (void)getImageThroughKey:(NSString *)key ok:(void (^)(UIImage *, NSString *))block withSizeCut:(CGSize)newSize {
    __weak typeof(self) weakSelf = self;
    if (newSize.width == 0 &&
        newSize.height == 0) {
        [PCDBCenter checkCachedImagesTableThatImageExists:key okBlock:^(BOOL exist, NSData *imgData) {
            if (exist) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block([UIImage imageWithData:imgData], key);
                });
            } else {
                [weakSelf getImageThroughKey:key ok:^(UIImage *img, NSString *imgKey) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(img, imgKey);
                    });
                }];
            }
        }];
        return ;
    }
    
    [PCDBCenter checkCachedResizedImagesTableThatImageExists:key ofSize:NSStringFromCGSize(newSize) okBlock:^(BOOL exist, NSData *imgData) {
        if (exist) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block([UIImage imageWithData:imgData], key);
            });
        } else {
            [weakSelf getImageThroughKey:key ok:^(UIImage *img, NSString *imgKey) {
                UIImage *returnedImg = nil;
                CGSize returnedImgSize = CGSizeZero;
                if (newSize.width == img.size.width &&
                    newSize.height == img.size.height) {
                    returnedImg = img;
                } else {
                    returnedImg = [UIImage imageWithImage:img scaledToSize:newSize];
                    returnedImgSize = newSize;
                }
//                NSLog(@"original:%@, size: %ld ; resized:%@, size: %ld", NSStringFromCGSize(img.size), UIImageJPEGRepresentation(img, 1).length, NSStringFromCGSize(returnedImg.size), UIImageJPEGRepresentation(returnedImg, 1).length);
                
//                NSInteger returnedImgLength = UIImageJPEGRepresentation(returnedImg, 1).length;
//                NSData *compressedImgData = UIImageJPEGRepresentation(returnedImg, 0.1);
//                NSInteger compressedImgLength = compressedImgData.length;
//                UIImage *compressedImg = [UIImage imageWithData:compressedImgData];
//                CGSize compressedImgSize = compressedImg.size;
//                NSLog(@"return size:%@, return length:%ld\n"
//                      @"compressed size:%@, compressed length:%ld", NSStringFromCGSize(returnedImgSize), returnedImgLength, NSStringFromCGSize(compressedImgSize), compressedImgLength);
                if (key && returnedImg) {
                    [PCDBCenter insertCachedResizedImagesTable:@{@"imgKey": imgKey,
                                                                 @"imgData": UIImageJPEGRepresentation(returnedImg, 1),
                                                                 @"imgSize": NSStringFromCGSize(returnedImgSize),
                                                                 @"cacheTime": [NSDate millisecondsFrom1970ByNow]}];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(returnedImg, imgKey);
                });
            }];
        }
    }];
}

+ (NSURLSessionDataTask *)deleteSingleMessage:(NSString *)messageId ok:(void (^)(BOOL))block {
    if (messageId) {
        return [self deleteMessages:@[messageId] ok:block];
    } else {
        NSLog(@"删除评论而缺少articleId");
    }
    
    return nil;
}

@end
