//
//  PCSelfInformationModel.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/20.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCUserInformationModel.h"

@interface PCSelfInformationModel : PCUserInformationModel <NSCoding>

+ (PCSelfInformationModel *)sharedInstance;

@end
