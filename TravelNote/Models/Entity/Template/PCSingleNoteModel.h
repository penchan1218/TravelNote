//
//  PCSingleNoteModel.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/3.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseModel.h"

@interface PCSingleNoteModel : PCBaseModel

@property (nonatomic, copy)     NSString    *pic;
@property (nonatomic, copy)     NSString    *intro;
@property (nonatomic, copy)     NSNumber    *pageIndex;
@property (nonatomic, copy)     NSNumber    *timeStamp;

- (NSDictionary *)presentation;

@end
