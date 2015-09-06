//
//  UIImage+ImagesAbout.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/6/26.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "UIImage+ImagesAbout.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (ImagesAbout)

- (UIImage *)roundedImageWithRadius:(float)radius {
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:radius] addClip];
    // Draw your image
    [self drawInRect:bounds];
    
    // Get the image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    if (image.size.width <= newSize.width &&
        image.size.height <= newSize.height) {
        return image;
    }
    CGFloat ratio = image.size.width / image.size.height;
    CGSize size_final = CGSizeZero;
    if (ratio > 1) {
        size_final = CGSizeMake(newSize.width, newSize.width/ratio);
    } else {
        size_final = CGSizeMake(newSize.height*ratio, newSize.height);
    }
    UIGraphicsBeginImageContextWithOptions(size_final, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, size_final.width, size_final.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
