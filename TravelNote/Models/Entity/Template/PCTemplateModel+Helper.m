//
//  PCTemplateModel+Helper.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/1.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCTemplateModel+Helper.h"

@implementation PCTemplateModel (Helper)

- (void)reloadTemplate:(__weak UIImageView *)imageview {
    // placeholder image
    imageview.image = nil;
    
    if (!self.coverImg) {
        if (self.url != nil) {
            __weak typeof(self) weakSelf = self;
            [PCNetworkManager getTemplateCoverThroughURL:self.url ok:^(UIImage *coverImg) {
                weakSelf.coverImg = coverImg;
                if (weakSelf.indexpath.row == imageview.tag) {
                    imageview.image = coverImg;
                }
            }];
        }
    } else {
        imageview.image = self.coverImg;
    }
}

@end
