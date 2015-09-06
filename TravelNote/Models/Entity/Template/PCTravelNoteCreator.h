//
//  PCTravelNoteCreator.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/3.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCTravelNoteCreator : NSObject

@property (nonatomic, copy)     NSString    *title;
@property (nonatomic, copy)     NSString    *_description;
@property (nonatomic, copy)     NSNumber    *createTime;
@property (nonatomic, assign)   BOOL        isPrivate;

@property (nonatomic, assign)   NSInteger   maximumTemps;

@property (strong, nonatomic)   UIImage     *cover;
@property (strong, nonatomic)   NSArray     *content;

@property (nonatomic, copy)     NSNumber    *temp;


+ (PCTravelNoteCreator *)shared;

- (void)clear;

- (NSDictionary *)presentation;

- (void)uploadNewArticleWithBlock:(void (^)(BOOL success, NSString *))block;

@end
