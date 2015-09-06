//
//  UIImage+ImagesAbout.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/26.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImagesAbout)

- (UIImage *)roundedImageWithRadius:(float)radius;

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

@end
