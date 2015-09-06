//
//  PCNetworkManager.m
//  TravelNoteAPITesting
//
//  Created by 陈颖鹏 on 15/7/17.
//  Copyright (c) 2015年 hustunique. All rights reserved.
//

#import "PCNetworkManager.h"
#import "PCNetworkErrorHandler.h"
#import "NSDate+MilliSeconds.h"

@interface PCNetworkManager ()

@property (strong, atomic) NSMutableArray *tasksQueue;

@end

@implementation PCNetworkManager

static PCNetworkManager *__shared = nil;

+ (PCNetworkManager *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __shared = [[PCNetworkManager alloc] init];
    });
    return __shared;
}

- (id)init {
    self = [super init];
    if (self) {
        self.tasksQueue = [NSMutableArray array];
        self.isLogged = NO;
        
        [self addObserver:self forKeyPath:@"isLogged" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isLogged"]) {
        if ([change[@"new"] boolValue] == YES) {
            [self executeWaitingTasks];
        } else {
            [PCNetworkManager __privateLoginWithOK:nil];
        }
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"isLogged"];
}

+ (NSURLSessionDataTask *)__privateLogin {
    return [self __privateLoginWithOK:nil];
}

+ (NSURLSessionDataTask *)__privateLoginWithOK:(void (^)())block {
    // 登录
    NSString *openid = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_openid"];
    if (openid == nil) {
        NSLog(@"No openid stored!");
        return nil;
    }
    
    __shared.isLogging = YES;
    
    __weak PCNetworkManager *weakSelf = __shared;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@addSession?openId=%@", TNAPIBaseURLString, openid]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            NSLog(@"登录成功");
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block();
                });
            }
            NSHTTPCookieStorage *store = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *cookies = store.cookies;
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:cookies] forKey:@"cookies_data"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            weakSelf.isLogged = YES;
            weakSelf.isLogging = NO;
        } else {
            NSLog(@"登录失败");
            weakSelf.isLogging = NO;
        }
    }];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)deleteArticle:(NSString *)articleid ok:(void (^)(BOOL))block {
    if (__shared.isLogged) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] DELETE:[NSString stringWithFormat:@"articles/%@", articleid] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"deleteArticle"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Delete Article %@ : failed\nFor reason : %@", articleid, error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager deleteArticle:articleid ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:0 parameters:@[articleid, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)dislikeArticle:(NSString *)articleid ok:(void (^)(BOOL))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] PUT:[NSString stringWithFormat:@"articles/%@/dislike", articleid] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"Dislike articles"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Dislike article failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager dislikeArticle:articleid ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:1 parameters:@[articleid, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)fetchArticleEntriesByTimeStamp:(NSNumber *)timestamp previous:(BOOL)previous ok:(void (^)(NSArray *))block {
    if (__shared.isLogged == YES) {
        NSDictionary *parameters;
        if (previous == YES) {
            parameters = @{@"e": timestamp};
        } else {
            parameters = @{@"s": timestamp};
        }
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:@"articles/new/fetch" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(JSON);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"Fetch article entries by timestamp"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Fetch article entries by timestamp failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager fetchArticleEntriesByTimeStamp:timestamp previous:previous ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:2 parameters:@[timestamp, @(previous), block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)getArticle:(NSString *)articleid ok:(void (^)(NSDictionary *, NSString *))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:[NSString stringWithFormat:@"articles/%@", articleid] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(JSON, articleid);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"Get article"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Get Article %@ : failed\nFor reason : %@", articleid, error);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager getArticle:articleid ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:3 parameters:@[articleid, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)getArticleContent:(NSString *)articleid {
    return [[PCAPIClient sharedClient] GET:[NSString stringWithFormat:@"articles/%@/play", articleid] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

+ (NSURLSessionDataTask *)getFollowedArticles:(NSInteger)page ok:(void (^)(NSArray *, NSInteger))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:[NSString stringWithFormat:@"articles/following/page/%d", (int)page] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(JSON, page);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"getFollowedArticles"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Get followed articles failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager getFollowedArticles:page ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:5 parameters:@[@(page), block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)getUserFavorites:(NSString *)userId page:(NSInteger)page ok:(void (^)(NSArray *, NSInteger))block {
    if (!userId) {
        NSLog(@"获取用户喜爱的游记缺失userId");
        userId = @"own";
    }
    
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:[NSString stringWithFormat:@"articles/favorites/%@/page/%ld", userId, (unsigned long)page] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(JSON, page);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"getUserFavorites"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager getUserFavorites:userId page:page ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:6 parameters:@[userId, @(page), block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)getNewArticles:(NSInteger)page ok:(void (^)(NSArray *, NSInteger))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:[NSString stringWithFormat:@"articles/new/page/%d", (int)page] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(JSON, page);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"getNewArticles"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Get new articles failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager getNewArticles:page ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:7 parameters:@[@(page), block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)getRecommendArticlesWithOK:(void (^)(NSArray *))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:@"articles/recommend" parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(JSON);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"getRecommendArticles"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Get recommend articles failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager getRecommendArticlesWithOK:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:8 parameters:@[block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)getUserArticles:(NSString *)user page:(NSInteger)page ok:(void (^)(NSArray *, NSString *, NSInteger))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:[NSString stringWithFormat:@"articles/%@/page/%d", user, (int)page] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(JSON, user, page);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"getUserArticles"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Get user articles failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [self getUserArticles:user page:page ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:9 parameters:@[user, @(page), block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)likeArticle:(NSString *)articleid ok:(void (^)(BOOL))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] PUT:[NSString stringWithFormat:@"articles/%@/like", articleid] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"likeArticle"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Like article failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager likeArticle:articleid ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:10 parameters:@[articleid, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)getArticleComments:(NSString *)articleid ok:(void (^)(NSArray *, NSString *))block{
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:[NSString stringWithFormat:@"articles/%@/comments", articleid] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(JSON, articleid);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"getArticleComments"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Get article comments failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [self getArticleComments:articleid ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:11 parameters:@[articleid, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)addAComment:(NSString *)articleid content:(NSString *)content ok:(void (^)(BOOL, NSString *))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] POST:[NSString stringWithFormat:@"articles/%@/comments", articleid]
                                                           parameters:@{@"id": articleid,
                                                                        @"content": content}
                                                              success:^(NSURLSessionDataTask *task, id JSON) {
                                                                  if (block != nil) {
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          block([JSON[@"success"] boolValue], articleid);
                                                                      });
                                                                  } else {
                                                                      [PCNetworkManager noExecutableBlockLogBy:@"addAComment"];
                                                                  }
                                                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                  NSLog(@"Add a comment failed for reason : %@", error.localizedDescription);
                                                                  [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                                                                      [PCNetworkManager addAComment:articleid content:content ok:block];
                                                                  }];
                                                              }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:12 parameters:@[articleid, content, block]];
    }
    
    return nil;
}

+ (void)getImageThroughKey:(NSString *)key ok:(void (^)(UIImage *, NSString *))block {
    if (__shared.isLogged == YES) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/static/img/%@", TNBaseURLString, key]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0f];
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil) {
                if (block != nil) {
                    UIImage *imgFromNet = [UIImage imageWithData:data];
                    [PCDBCenter insertCachedImagesTable:@{@"imgKey": key,
                                                          @"imgData": UIImageJPEGRepresentation(imgFromNet, 1),
                                                          @"imgSize": NSStringFromCGSize(CGSizeZero),
                                                          @"cacheTime": [NSDate millisecondsFrom1970ByNow]}];
                    block(imgFromNet, key);
                } else {
                    [PCNetworkManager noExecutableBlockLogBy:@"getImageThroughKey"];
                }
            } else {
                NSLog(@"Get image failed for reason : %@", error.localizedDescription);
                [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                    [self getImageThroughKey:key ok:block];
                }];
            }
        }];
        [task resume];
    } else {
        [PCNetworkManager addWaitingTaskOfType:13 parameters:@[key, block]];
    }
}

+ (NSURLSessionDataTask *)deleteMessages:(NSArray *)messages ok:(void (^)(BOOL))block {
    if (__shared.isLogged) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@messages", TNAPIBaseURLString]]];
        request.HTTPMethod = @"DELETE";
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        request.HTTPBody = [NSJSONSerialization dataWithJSONObject:@{@"messageId": messages} options:0 error:nil];
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                if (block) {
                    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block([[JSON objectForKey:@"success"] boolValue]);
                    });
                } else {
                    [PCNetworkManager noExecutableBlockLogBy:@"deleteMessages"];
                }
            } else {
                NSLog(@"delete messages failed for reason : %@", error.localizedDescription);
//                [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
//                    [PCNetworkManager deleteMessages:messages ok:block];
//                }];
                if (block) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(NO);
                    });
                } else {
                    [PCNetworkManager noExecutableBlockLogBy:@"deleteMessages"];
                }
            }
        }];
        
        [task resume];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:14 parameters:@[messages, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)getUserMessages:(NSNumber *)milliseconds ok:(void (^)(NSArray *, NSNumber *))block {
    if (__shared.isLogged == YES) {
        NSDictionary *parameters = nil;
        if (milliseconds != nil) {
            parameters = @{@"s": milliseconds};
        }
        
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:@"messages" parameters:parameters success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(JSON, [NSDate millisecondsFrom1970ByNow]);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"getUserMessages"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Get user messages failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager getUserMessages:milliseconds ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:15 parameters:@[milliseconds? milliseconds: @(0), block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)listTempsInformationWithOK:(void (^)(NSArray *))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:@"temps" parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(JSON);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"listTempsInformationWithOK"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"List temps information failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager listTempsInformationWithOK:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:16 parameters:@[block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)followTheUser:(NSString *)userid ok:(void (^)(BOOL))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] PUT:[NSString stringWithFormat:@"user/%@/follow", userid] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"followTheUser"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Follow user failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager followTheUser:userid ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:17 parameters:@[userid, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)requestUserInformation:(NSString *)userid ok:(void (^)(NSDictionary *, NSString *))block{
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:[NSString stringWithFormat:@"user/%@", userid] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(JSON, userid);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"requestUserInformation"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Request user information failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [self requestUserInformation:userid ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:18 parameters:@[userid, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)requestLoggedUserIsFollowedTheUser:(NSString *)userid ok:(void (^)(BOOL))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:[NSString stringWithFormat:@"user/%@/isfollowed", userid] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block([JSON[@"isfollowed"] boolValue]);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"requestLoggedUserIsFollowedTheUser"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Request logged user is f ollowed the user failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager requestLoggedUserIsFollowedTheUser:userid ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:19 parameters:@[userid, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)searchUserByNickname:(NSString *)nickname ok:(void (^)(NSArray *))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:[[NSString stringWithFormat:@"user/search/%@", nickname] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(JSON);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"searchUserByNickname"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Search user by nick name failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager searchUserByNickname:nickname ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:20 parameters:@[nickname, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)unfollowTheUser:(NSString *)userid ok:(void (^)(BOOL))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] PUT:[NSString stringWithFormat:@"user/%@/unfollow", userid] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(YES);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"unfollowTheUser"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Unfollow user failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager unfollowTheUser:userid ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:21 parameters:@[userid, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)updateTheLoggedUserCurrTemp:(NSInteger)temp {
    return [[PCAPIClient sharedClient] PUT:[NSString stringWithFormat:@"user/own/%d", (int)temp] parameters:nil success:^(NSURLSessionDataTask *task, id JSON) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

+ (NSURLSessionDataTask *)updateTheLoggedUserIntro:(NSDictionary *)updatedInfo ok:(void (^)(BOOL))block {
    if (__shared.isLogged == YES) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user/own/info", TNAPIBaseURLString]]];
        [request setHTTPMethod:@"PUT"];
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:updatedInfo options:0 error:nil]];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil) {
                if (block != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(YES);
                    });
                } else {
                    [PCNetworkManager noExecutableBlockLogBy:@"updateTheLoggedUserIntro"];
                }
            } else {
                NSLog(@"Update the logged user intro failed for reason : %@", error.localizedDescription);
                [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                    [PCNetworkManager updateTheLoggedUserIntro:updatedInfo ok:block];
                }];
            }
        }];
        [task resume];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:23 parameters:@[updatedInfo, block]];
    }
    
    return  nil;
}

+ (NSURLSessionDataTask *)getTemplateCoverThroughURL:(NSString *)url ok:(void (^)(UIImage *))block {
    if (__shared.isLogged == YES) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TNBaseURLString, url]] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0f];
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error == nil) {
                if (block != nil) {
                    UIImage *originalImg = [UIImage imageWithData:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        block(originalImg);
                    });
                } else {
                    [PCNetworkManager noExecutableBlockLogBy:@"getTemplateCoverThroughURL"];
                }
            } else {
                NSLog(@"Get template cover failed for reason : %@", error.localizedDescription);
                [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                    [PCNetworkManager getTemplateCoverThroughURL:url ok:block];
                }];
            }
        }];
        [task resume];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:24 parameters:@[url, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)uploadNewArticle:(NSDictionary *)article ok:(void (^)(BOOL, NSString *))block {
    if (__shared.isLogged == YES) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@articles", TNAPIBaseURLString]]];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:article options:0 error:nil]];
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"Upload new article failed for reason : %@", error.localizedDescription);
            }
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(error == nil, error!=nil? nil: [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] objectForKey:@"articleId"]);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"uploadNewArticle"];
            }
        }];
        [task resume];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:25 parameters:@[article, block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)getInfoOfFollowers:(NSString *)userId page:(NSInteger)page ok:(void (^)(NSArray *))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:[NSString stringWithFormat:@"user/%@/followers/page/%ld", userId, (unsigned long)page] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(responseObject);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"getInfoOfFollowers"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Get info of followers failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager getInfoOfFollowers:userId page:page ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:26 parameters:@[userId, @(page), block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)getInfoOfFollowing:(NSString *)userId page:(NSInteger)page ok:(void (^)(NSArray *))block {
    if (__shared.isLogged == YES) {
        NSURLSessionDataTask *task = [[PCAPIClient sharedClient] GET:[NSString stringWithFormat:@"user/%@/following/page/%ld", userId, (unsigned long)page] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if (block != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(responseObject);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"getInfoOfFollowing"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Get info of following failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager getInfoOfFollowing:userId page:page ok:block];
            }];
        }];
        return task;
    } else {
        [PCNetworkManager addWaitingTaskOfType:27 parameters:@[userId, @(page), block]];
    }
    
    return nil;
}

+ (NSURLSessionDataTask *)fetchAccessTokenWithCode:(NSString *)code ok:(void (^)(BOOL, NSDictionary *))block {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth2?code=%@&device=ios", TNBaseURLString, code]]];
    NSLog(@"%@", request.URL.absoluteString);
//    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:@{@"code": code, @"device": @"ios"} options:0 error:nil]];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if (block) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    block([responseObject[@"success"] boolValue], responseObject[@"data"]);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"fetchAccessTokenWithCode"];
            }
        } else {
            NSLog(@"fetchAccessTokenWithCode failed for reason : %@", error.localizedDescription);
//            NSLog(@"采用陈颖鹏的openid进行测试");
//            if (block) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    block(YES, @{@"openId": @"ozebss3SPx7iLkWxMA5doRgKm8dI"});
//                });
//            } else {
//                [PCNetworkManager noExecutableBlockLogBy:@"fetchAccessTokenWithCode"];
//            }
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager fetchAccessTokenWithCode:code ok:block];
            }];
        }
    }];
    
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)checkIfBundled:(NSString *)userId ok:(void (^)(BOOL, NSDictionary *))block {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/oauth2/isBundled?userId=%@&device=ios", TNBaseURLString, userId]]];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            if (block) {
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    block([responseObject[@"isBundled"] boolValue], responseObject[@"data"]);
                });
            } else {
                [PCNetworkManager noExecutableBlockLogBy:@"checkIfBundled"];
            }
        } else {
            NSLog(@"checkIfBundled failed for reason : %@", error.localizedDescription);
            [[PCNetworkErrorHandler sharedHandler] handleError:error ok:^{
                [PCNetworkManager checkIfBundled:userId ok:block];
            }];
        }
    }];
    
    [task resume];
    return task;
}

- (void)executeWaitingTasks {
    while (self.tasksQueue.count > 0) {
        if (self.isLogged == YES) {
            NSDictionary *APIDic = [self.tasksQueue objectAtIndex:0];
            if (APIDic != nil) {
                NSInteger APIType = [APIDic[@"type"] integerValue];
                NSArray *parameters = APIDic[@"parameters"];
                switch (APIType) {
                    case 0: {
                        NSString *articleId = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager deleteArticle:articleId ok:okblock];
                    }
                        break;
                    case 1: {
                        NSString *articleid = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager dislikeArticle:articleid ok:okblock];
                    }
                        break;
                    case 2: {
                        NSNumber *timestamp = parameters[0];
                        BOOL previous = [parameters[1] boolValue];
                        id okblock = parameters[2];
                        [PCNetworkManager fetchArticleEntriesByTimeStamp:timestamp previous:previous ok:okblock];
                    }
                        break;
                    case 3: {
                        NSString *articleid = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager getArticle:articleid ok:okblock];
                    }
                        break;
                    case 4:
                        break;
                    case 5: {
                        NSInteger page = [parameters[0] integerValue];
                        id okblock = parameters[1];
                        [PCNetworkManager getFollowedArticles:page ok:okblock];
                    }
                        break;
                    case 6: {
                        NSString *userId = parameters[0];
                        NSInteger page = [parameters[1] integerValue];
                        id okblock = parameters[2];
                        [PCNetworkManager getUserFavorites:userId page:page ok:okblock];
                    }
                        break;
                    case 7: {
                        NSInteger page = [parameters[0] integerValue];
                        id okblock = parameters[1];
                        [PCNetworkManager getNewArticles:page ok:okblock];
                    }
                        break;
                    case 8: {
                        id okblock = parameters[0];
                        [PCNetworkManager getRecommendArticlesWithOK:okblock];
                    }
                        break;
                    case 9: {
                        NSString *userid = parameters[0];
                        NSInteger page = [parameters[1] integerValue];
                        id okblock = parameters[2];
                        [PCNetworkManager getUserArticles:userid page:page ok:okblock];
                    }
                        break;
                    case 10: {
                        NSString *articleid = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager likeArticle:articleid ok:okblock];
                    }
                        break;
                    case 11: {
                        NSString *articleid = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager getArticleComments:articleid ok:okblock];
                    }
                        break;
                    case 12: {
                        NSString *articleid = parameters[0];
                        NSString *content = parameters[1];
                        id okblock = parameters[2];
                        [PCNetworkManager addAComment:articleid content:content ok:okblock];
                    }
                        break;
                    case 13: {
                        NSString *imgKey = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager getImageThroughKey:imgKey ok:okblock];
                    }
                        break;
                    case 14: {
                        NSArray *messages = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager deleteMessages:messages ok:okblock];
                    }
                        break;
                    case 15: {
                        NSNumber *timestamp = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager getUserMessages:timestamp ok:okblock];
                    }
                        break;
                    case 16: {
                        id okblock = parameters[0];
                        [PCNetworkManager listTempsInformationWithOK:okblock];
                    }
                        break;
                    case 17: {
                        NSString *userId = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager followTheUser:userId ok:okblock];
                    }
                        break;
                    case 18: {
                        NSString *userId = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager requestUserInformation:userId ok:okblock];
                    }
                        break;
                    case 19: {
                        NSString *userId = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager requestLoggedUserIsFollowedTheUser:userId ok:okblock];
                    }
                        break;
                    case 20: {
                        NSString *nickname = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager searchUserByNickname:nickname ok:okblock];
                    }
                        break;
                    case 21: {
                        NSString *userId = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager unfollowTheUser:userId ok:okblock];
                    }
                        break;
                    case 22:
                        break;
                    case 23: {
                        NSDictionary *userInfo = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager updateTheLoggedUserIntro:userInfo ok:okblock];
                    }
                        break;
                    case 24: {
                        NSString *url = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager getTemplateCoverThroughURL:url ok:okblock];
                    }
                        break;
                    case 25: {
                        NSDictionary *article = parameters[0];
                        id okblock = parameters[1];
                        [PCNetworkManager uploadNewArticle:article ok:okblock];
                    }
                        break;
                    case 26: {
                        NSString *userId = parameters[0];
                        NSInteger page = [parameters[1] integerValue];
                        id okblock = parameters[2];
                        [PCNetworkManager getInfoOfFollowers:userId page:page ok:okblock];
                    }
                        break;
                    case 27: {
                        NSString *userId = parameters[0];
                        NSInteger page = [parameters[1] integerValue];
                        id okblock = parameters[2];
                        [PCNetworkManager getInfoOfFollowing:userId page:page ok:okblock];
                    }
                        break;
                    default:
                        break;
                }
                [self.tasksQueue removeObjectAtIndex:0];
            } else {
                NSLog(@"Task queue中没有任务却进入了循环");
                break;
            }
        } else {
            break;
        }
    }
}

+ (void)noExecutableBlockLogBy:(NSString *)action {
    NSLog(@"%@ without an executable block!", action);
}

+ (void)addWaitingTaskOfType:(NSInteger)type parameters:(NSArray *)parameters {
    if (parameters != nil) {
        [__shared.tasksQueue addObject:@{@"type": @(type),
                                         @"parameters": parameters}];
    } else {
        [__shared.tasksQueue addObject:@{@"type": @(type)}];
    }
    
    if (!__shared.isLogging) {
        [self __privateLogin];
    }
}

@end
