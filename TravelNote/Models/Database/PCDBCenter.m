//
//  PCDBCenter.m
//  TravelNote
//
//  Created by 陈颖鹏 on 15/8/4.
//  Copyright (c) 2015年 朱泌丞. All rights reserved.
//

#import "PCDBCenter.h"

static NSString *__dbAbsolutePath;

@interface PCDBCenter ()

@property (strong, nonatomic) dispatch_queue_t dbQueue;

@end

@implementation PCDBCenter

#pragma mark - methods to perform on CachedImagesTable

+ (void)insertCachedImagesTable:(NSDictionary *)info {
    [self insertImagesTableNamed:TNCachedImagesTableName withInfo:info];
}

+ (void)updateCachedImagesTable:(NSDictionary *)info {
    [self updateImagesTableNamed:TNCachedImagesTableName withInfo:info];
}

+ (void)checkCachedImagesTableThatImageExists:(NSString *)imgKey okBlock:(void (^)(BOOL, NSData *))block {
    [self checkImagesTableNamed:TNCachedImagesTableName thatImageExists:imgKey ofSize:NSStringFromCGSize(CGSizeZero) okBlock:block];
}

#pragma mark - methods to perform on CachedResizedImagesTable

+ (void)insertCachedResizedImagesTable:(NSDictionary *)info {
    [self insertImagesTableNamed:TNCachedResizedImagesTableName withInfo:info];
}

+ (void)updateCachedResizedImagesTable:(NSDictionary *)info {
    [self updateImagesTableNamed:TNCachedResizedImagesTableName withInfo:info];
}

+ (void)checkCachedResizedImagesTableThatImageExists:(NSString *)imgKey ofSize:(NSString *)size okBlock:(void (^)(BOOL, NSData *))block {
    [self checkImagesTableNamed:TNCachedResizedImagesTableName thatImageExists:imgKey ofSize:size okBlock:block];
}

#pragma mark - basic methods to perform on tables about images

+ (void)insertImagesTableNamed:(NSString *)tableName withInfo:(NSDictionary *)info {
    if (!info[@"imgKey"] || !info[@"imgData"] || !info[@"cacheTime"] || !info[@"imgSize"]) {
        NSLog(@"数据库储存image而信息不全!");
        return ;
    }
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (imgKey, imgSize, imgData, cacheTime) VALUES (:imgKey, :imgSize, :imgData, :cacheTime)", tableName];
    
    __weak typeof(self) weakSelf = self;
    [self checkImagesTableNamed:tableName thatImageExists:info[@"imgKey"] ofSize:info[@"imgSize"] okBlock:^(BOOL exist, NSData *imgData) {
        if (exist) {
            [weakSelf updateImagesTableNamed:tableName withInfo:info];
        } else {
            [weakSelf executeSQLsUsingSharedDBCenterInBlock:^(FMDatabase *db) {
                [db executeUpdate:sql withParameterDictionary:info];
            }];
        }
    }];
}

+ (void)updateImagesTableNamed:(NSString *)tableName withInfo:(NSDictionary *)info {
    if (!info[@"imgKey"] || !info[@"imgData"] || !info[@"cacheTime"] || !info[@"imgSize"]) {
        NSLog(@"数据库更新image而信息不全!");
        return ;
    }
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET imgData=:imgData, cacheTime=:cacheTime where imgKey=:imgKey and imgSize=:imgSize", tableName];
    
    [self executeSQLsUsingSharedDBCenterInBlock:^(FMDatabase *db) {
        [db executeUpdate:sql withParameterDictionary:info];
    }];
}

+ (void)checkImagesTableNamed:(NSString *)tableName thatImageExists:(NSString *)imgKey ofSize:(NSString *)size okBlock:(void (^)(BOOL, NSData *))block {
    if (imgKey == nil || imgKey.length == 0 ||
        size == nil || size.length == 0) {
        NSLog(@"数据库查询image而imgKey或size不对!");
        return ;
    }
    
    if (block == nil) {
        NSLog(@"查询数据库后没有可执行的block!");
        return ;
    }
    
    NSString *sql = [NSString stringWithFormat:@"SELECT imgData FROM %@ where imgKey=? and imgSize=?", tableName];
    
    [self executeSQLsUsingSharedDBCenterInBlock:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql, imgKey, size];
        if (rs == nil) {
            NSLog(@"查询数据库出现问题 - 无法执行查询语句");
            block(NO, nil);
        } else {
            if (![rs next]) {
                block(NO, nil);
            } else {
                block(YES, [rs dataForColumnIndex:0]);
            }
        }
        [rs close];
    }];
}

#pragma mark - call when executing SQL

+ (void)executeSQLsUsingSharedDBCenterInBlock:(void (^)(FMDatabase *))block {
    [[self shared] executeSQLsInBlock:block];
}

- (void)executeSQLsInBlock:(void (^)(FMDatabase *))block {
    if (block != nil) {
        dispatch_async(self.dbQueue, ^{
            FMDatabase *db = [FMDatabase databaseWithPath:__dbAbsolutePath];
            [db open];
            block(db);
            [db close];
        });
    } else {
        NSLog(@"操作数据库 - 没有可执行的block!");
    }
}

#pragma mark - call when first time creating tables

+ (void)firstTimeCreatingTables {
    [self createDatabaseDirectory];
    
    [self executeSQLsUsingSharedDBCenterInBlock:^(FMDatabase *db) {
        NSString *sqls_createTables = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"_DatabaseTables" ofType:@"sql"] encoding:NSUTF8StringEncoding error:nil];
        [db executeStatements:sqls_createTables];
    }];
}

+ (void)createDatabaseDirectory {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *documentAbsolutePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbDirectoryAbsolutePath = [NSString stringWithFormat:@"%@%@", documentAbsolutePath, TNDatabaseDirectoryRelativePath];
    if (![fm fileExistsAtPath:dbDirectoryAbsolutePath]) {
        [fm createDirectoryAtPath:dbDirectoryAbsolutePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - common things

+ (instancetype)shared {
    static PCDBCenter *__shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[PCDBCenter alloc] init];
    });
    
    return __shared;
}

- (id)init {
    self = [super init];
    if (self) {
        __dbAbsolutePath = [NSString stringWithFormat:@"%@%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0], TNDatabaseRelativePath];
        self.dbQueue = dispatch_queue_create("com.TravelNote.db", DISPATCH_QUEUE_SERIAL);
    }
    
    return self;
}

@end
