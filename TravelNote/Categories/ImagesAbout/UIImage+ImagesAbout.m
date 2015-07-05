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

@end
