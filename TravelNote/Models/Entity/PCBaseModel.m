//
//  PCBaseModel.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/7/31.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCBaseModel.h"

@implementation PCBaseModel

- (id)initWithInfo:(NSDictionary *)info {
    self = [super init];
    if (self) {
        NSSet *keySet = [[self class] keySet];
        for (NSString *key in keySet) {
            if (info[key] != nil) {
                [self setValue:info[key] forKeyPath:key];
            }
        }
        
        self.knowCellHeight = NO;
    }
    return self;
}

- (void)getImageBackThroughKey:(NSString *)imgKey ok:(void (^)(UIImage *))block withSizeCut:(CGSize)newSize {
    if (imgKey != nil) {
        [PCNetworkManager getImageThroughKey:imgKey ok:^(UIImage *img, NSString *_imgKey) {
            if (block != nil) {
                block(img);
            } else {
                NSLog(@"获取图片后没有可执行的block!");
            }
        } withSizeCut:newSize];
    } else {
        NSLog(@"获取图片而imgKey为nil!");
    }
}

- (void)reloadCell:(UITableViewCell *)cell {}

+ (NSSet *)keySet { return [NSSet set]; }

@end
