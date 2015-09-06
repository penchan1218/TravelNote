//
//  PCTravelNoteCreator.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/3.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCTravelNoteCreator.h"
#import "PCSingleNoteModel.h"
#import "NSDate+MilliSeconds.h"
#import "UIImage+ImagesAbout.h"

@implementation PCTravelNoteCreator

+ (PCTravelNoteCreator *)shared {
    static PCTravelNoteCreator *__shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[PCTravelNoteCreator alloc] init];
    });
    
    return __shared;
}

- (void)clear {
    self.title = @"暂无";
    self._description = @"暂无";
    self.createTime = [NSDate millisecondsFrom1970ByNow];
    
    self.cover = [[UIImage alloc] init];
    self.content = [NSArray array];
    
    self.isPrivate = NO;
    
    self.maximumTemps = 4;
    
    self.temp = @(1);
}

- (void)uploadNewArticleWithBlock:(void (^)(BOOL, NSString *))block {
    [PCNetworkManager uploadNewArticle:[self presentation] ok:^(BOOL success, NSString *articleId) {
        if (block != nil) {
            block(success, articleId);
        }
    }];
}

- (NSDictionary *)presentation {
    return @{@"title": self.title,
             @"cover": [UIImageJPEGRepresentation([UIImage imageWithImage:self.cover scaledToSize:CGSizeMake(800, 800)], 1) base64EncodedStringWithOptions:0],
             @"description": self._description,
             @"createTime": self.createTime,
             @"temp": self.temp,
             @"content": self.content,
             @"isPrivate": @(self.isPrivate)};
}

- (void)setContent:(NSArray *)content {
    NSMutableArray *newContent = [NSMutableArray array];
    for (NSInteger i = 0; i < content.count; i++) {
        PCSingleNoteModel *model = content[i];
        int randomNum = arc4random() % self.maximumTemps;
        if (i == 0) {
            while (randomNum == 0) {
                randomNum = arc4random() % self.maximumTemps;
            }
        }
        model.pageIndex = @(randomNum+1);
        [newContent addObject:[model presentation]];
    }
    
    _content = newContent;
}

- (void)set_description:(NSString *)_description {
    if (_description.length > 0) {
        __description = [_description copy];
    }
}

@end
