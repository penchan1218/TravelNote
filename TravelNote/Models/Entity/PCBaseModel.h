//
//  PCBaseModel.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/31.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCNetworkManager+Addition.h"

@class PCBaseModel;

@interface PCBaseModel : NSObject

@property (nonatomic, assign) BOOL knowCellHeight;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSIndexPath *indexpath;


+ (NSSet *)keySet;
- (id)initWithInfo:(NSDictionary *)info;
- (void)reloadCell:(UITableViewCell *)cell;
- (void)getImageBackThroughKey:(NSString *)imgKey ok:(void (^)(UIImage *))block withSizeCut:(CGSize)newSize;

@end
