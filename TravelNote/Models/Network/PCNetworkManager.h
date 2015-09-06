//
//  PCNetworkManager.h
//  TravelNoteAPITesting
//
//  Created by 陈颖鹏 on 15/7/17.
//  Copyright (c) 2015年 hustunique. All rights reserved.
//

#import "PCAPIClient.h"
#import "PCDBCenter.h"

@interface PCNetworkManager : NSObject

@property (atomic, assign) BOOL isLogged;
@property (atomic, assign) BOOL isLogging;

+ (PCNetworkManager *)shared;
+ (NSURLSessionDataTask *)__privateLogin;
+ (NSURLSessionDataTask *)__privateLoginWithOK:(void (^)())block;




+ (NSURLSessionDataTask *)deleteArticle:(NSString *)articleid ok:(void (^)(BOOL))block; //0
+ (NSURLSessionDataTask *)dislikeArticle:(NSString *)articleid ok:(void (^)(BOOL))block; //1
+ (NSURLSessionDataTask *)fetchArticleEntriesByTimeStamp:(NSNumber *)timestamp previous:(BOOL)previous ok:(void (^)(NSArray *))block; //2
+ (NSURLSessionDataTask *)getArticle:(NSString *)articleid ok:(void (^)(NSDictionary *, NSString *))block; //3
+ (NSURLSessionDataTask *)getArticleContent:(NSString *)articleid; // 4
+ (NSURLSessionDataTask *)getFollowedArticles:(NSInteger)page ok:(void (^)(NSArray *, NSInteger))block; // 5
+ (NSURLSessionDataTask *)getUserFavorites:(NSString *)userId page:(NSInteger)page ok:(void (^)(NSArray *, NSInteger))block; // 6
+ (NSURLSessionDataTask *)getNewArticles:(NSInteger)page ok:(void (^)(NSArray *, NSInteger))block; //7
+ (NSURLSessionDataTask *)getRecommendArticlesWithOK:(void (^)(NSArray *))block; //8
+ (NSURLSessionDataTask *)getUserArticles:(NSString *)user page:(NSInteger)page ok:(void (^)(NSArray *, NSString *, NSInteger))block; //9
+ (NSURLSessionDataTask *)likeArticle:(NSString *)articleid ok:(void (^)(BOOL))block; //10




+ (NSURLSessionDataTask *)getArticleComments:(NSString *)articleid ok:(void (^)(NSArray *, NSString *))block; //11
+ (NSURLSessionDataTask *)addAComment:(NSString *)articleid content:(NSString *)content ok:(void (^)(BOOL, NSString *))block; //12




+ (void)getImageThroughKey:(NSString *)key ok:(void (^)(UIImage *, NSString *))block; //13




+ (NSURLSessionDataTask *)deleteMessages:(NSArray *)messages ok:(void (^)(BOOL))block; //14
+ (NSURLSessionDataTask *)getUserMessages:(NSNumber *)milliseconds ok:(void (^)(NSArray *, NSNumber *))block; //15




+ (NSURLSessionDataTask *)listTempsInformationWithOK:(void (^)(NSArray *))block; //16




+ (NSURLSessionDataTask *)followTheUser:(NSString *)userid ok:(void (^)(BOOL))block; //17
+ (NSURLSessionDataTask *)requestUserInformation:(NSString *)userid ok:(void (^)(NSDictionary *, NSString *))block; //18
+ (NSURLSessionDataTask *)requestLoggedUserIsFollowedTheUser:(NSString *)userid ok:(void (^)(BOOL))block; //19
+ (NSURLSessionDataTask *)searchUserByNickname:(NSString *)nickname ok:(void (^)(NSArray *))block; //20
+ (NSURLSessionDataTask *)unfollowTheUser:(NSString *)userid ok:(void (^)(BOOL))block; //21
+ (NSURLSessionDataTask *)updateTheLoggedUserCurrTemp:(NSInteger)temp; // 22
+ (NSURLSessionDataTask *)updateTheLoggedUserIntro:(NSDictionary *)updatedInfo ok:(void (^)(BOOL))block; //23




+ (NSURLSessionDataTask *)getTemplateCoverThroughURL:(NSString *)url ok:(void (^)(UIImage *))block; //24
+ (NSURLSessionDataTask *)uploadNewArticle:(NSDictionary *)article ok:(void (^)(BOOL, NSString *))block; //25




+ (NSURLSessionDataTask *)getInfoOfFollowers:(NSString *)userId page:(NSInteger)page ok:(void (^)(NSArray *))block; // 26
+ (NSURLSessionDataTask *)getInfoOfFollowing:(NSString *)userId page:(NSInteger)page ok:(void (^)(NSArray *))block; // 27


+ (NSURLSessionDataTask *)fetchAccessTokenWithCode:(NSString *)code ok:(void (^)(BOOL, NSDictionary *))block; // 无需等待码
+ (NSURLSessionDataTask *)checkIfBundled:(NSString *)userId ok:(void (^)(BOOL, NSDictionary *))block; // 无需等待码

@end
