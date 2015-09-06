//
//  PCTemplateModel.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/30.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseModel.h"

@interface PCTemplateModel : PCBaseModel

@property (nonatomic, copy)     NSString    *name;
@property (nonatomic, copy)     NSNumber    *tempId;
@property (nonatomic, copy)     NSString    *url;

@property (strong, nonatomic)   UIImage     *coverImg;

@end
