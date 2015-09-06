//
//  PCDBCenter.h
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/4.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

static NSString * const TNDatabaseDirectoryRelativePath = @"/TNDatabase";
static NSString * const TNDatabaseRelativePath = @"/TNDatabase/TNDB.sqlite";

static NSString * const TNCachedImagesTableName = @"CachedImagesTable";
static NSString * const TNCachedResizedImagesTableName = @"CachedResizedImagesTable";

@interface PCDBCenter : NSObject


// 首次加载时创建数据库文件以及数据表
+ (void)firstTimeCreatingTables;


// 操作原图数据库
+ (void)insertCachedImagesTable:(NSDictionary *)info;
+ (void)updateCachedImagesTable:(NSDictionary *)info;
+ (void)checkCachedImagesTableThatImageExists:(NSString *)imgKey okBlock:(void (^)(BOOL, NSData *))block;


// 操作存有经调整的图片的数据库
+ (void)insertCachedResizedImagesTable:(NSDictionary *)info;
+ (void)updateCachedResizedImagesTable:(NSDictionary *)info;
+ (void)checkCachedResizedImagesTableThatImageExists:(NSString *)imgKey ofSize:(NSString *)size okBlock:(void (^)(BOOL, NSData *))block;


// 操作所有关于图片的数据库的基本实现方法
+ (void)insertImagesTableNamed:(NSString *)tableName withInfo:(NSDictionary *)info;
+ (void)updateImagesTableNamed:(NSString *)tableName withInfo:(NSDictionary *)info;
+ (void)checkImagesTableNamed:(NSString *)tableName thatImageExists:(NSString *)imgKey ofSize:(NSString *)size okBlock:(void (^)(BOOL, NSData *))block;


// 通用项
+ (instancetype)shared;
+ (void)executeSQLsUsingSharedDBCenterInBlock:(void (^)(FMDatabase *))block;
- (void)executeSQLsInBlock:(void (^)(FMDatabase *))block;

@end
