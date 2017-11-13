//
//  MovieRequest.m
//  KoMovie
//
//  Created by renzc on 16/9/19.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieRequest.h"
#import "Movie.h"
#import "DataEngine.h"
#import <NetCore_KKZ/KKZBaseNetRequest.h>
#import <NetCore_KKZ/KKZBaseRequestParams.h>

@implementation MovieRequest

/**
 *  查询正在上映的电影列表
 *
 *  @param city_id 城市id
 *  @param page    第几页
 *  @param success 成功回调 @movieList: 包含对象类型[Movie class]
 *  @param failure 失败回调
 */

- (void)requestMoviesWithCityId:(NSString *)city_id page:(NSInteger)page
                        success:(nullable void (^)(NSArray *_Nullable movieList))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];

    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:@"movie_Query" forKey:@"action"];
    [dicParams setObject:@"1000" forKey:@"count"];
    [dicParams setObject:@YES forKey:@"show_promotion"];
    [dicParams setObject:city_id forKey:@"city_id"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu", page] forKey:@"page"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:kKSSPServer
              parameters:newParams
            resultKeyMap:@{ @"movies" : [Movie class] }
                 success:^(NSDictionary *_Nullable data, id _Nullable responseObject) {
                     if (success) {
                         success(data[@"movies"]);
                     }
                 }
                 failure:failure];
}

/**
 *  查询即将上映的电影列表
 *
 *  @param city_id 城市id
 *  @param page    第几页
 *  @param success 成功回调 @movieList: 包含对象类型[Movie class]
 *  @param failure 失败回调
 */
- (void)requestInCommingMoviesWithCityId:(NSString *)city_id page:(NSInteger)page
                                 success:(nullable void (^)(NSArray *_Nullable movieList))success
                                 failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];

    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:@"movie_Query" forKey:@"action"];
    [dicParams setObject:@"1" forKey:@"coming"];
    [dicParams setObject:city_id forKey:@"city_id"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu", page] forKey:@"page"];

    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:kKSSPServer
              parameters:newParams
            resultKeyMap:@{ @"movies" : [Movie class] }
                 success:^(NSDictionary *_Nullable data, id _Nullable responseObject) {
                     if (success) {
                         success(data[@"movies"]);
                     }
                 }
                 failure:failure];
}

/**
 *  查询电影详情
 *
 *  @param movieId 电影id
 *  @param success 成功回调 @movieDetail: 类型是[Movie class]
 *  @param failure 失败回调
 */
- (void)requestMovieDetailWithMovieId:(NSInteger)movieId
                              success:(void (^)(id _Nullable))success
                              failure:(void (^)(NSError *_Nullable))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:@"movie_Query" forKey:@"action"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu", movieId] forKey:@"movie_id"];

    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:kKSSPServer
              parameters:newParams
            resultKeyMap:@{ @"movie" : [Movie class] }
                 success:^(NSDictionary *_Nullable data, id _Nullable responseObject) {
                     if (success) {
                         success(data[@"movie"]);
                     }
                 }
                 failure:failure];
}

/**
 *  查询电影媒体库
 *
 *  @param movieId 电影id
 *  @param success 成功回调 @responseObject: 包含剧照、声音、视频三种类型的model
 *  @param failure 失败回调
 */
- (void)requestMovieMediaLibraryWithMovieId:(NSInteger)movieId
                                    success:(nullable void (^)(id _Nullable responseObject))success
                                    failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSMediaServerBase baseParams:nil];

    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:@"1" forKey:@"channel_id"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu", movieId] forKey:@"movie_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:KKSSMediaServerPath(@"media/query")
            parameters:newParams
            success:^(id _Nullable data, id _Nullable responseObject) {
                if (success) {
                    success(responseObject[@"result"]);
                }
            }
            failure:^(NSError *_Nullable err) {
                if (failure) {
                    failure(err);
                }
            }];
}

/**
 *  查询某电影的 喜欢和不喜欢人数
 *
 *  @param movieId 电影id
 *  @param success 成功回调 @responseObject: responseData[@"likeCount"]喜欢  && responseData[@"dislikeCount"] 不喜欢
 *  @param failure 失败回调
 */
- (void)requestMovieSupportWithMovieId:(NSInteger)movieId
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(NSError *_Nullable err))failure {

    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSMediaServerBase baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:[NSString stringWithFormat:@"%tu", movieId] forKey:@"movie_id"];
    //添加上传参数
    if (appDelegate.isAuthorized) { // 已登录
        [dicParams setObject:[DataEngine sharedDataEngine].userId forKey:@"user_id"];
    }

    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:KKSSMediaServerPath(@"movie/relation/query")
            parameters:newParams
            success:^(id _Nullable data, id _Nullable responseObject) {
                if (success) {
                    success(responseObject[@"result"]);
                }
            }
            failure:^(NSError *_Nullable err) {
                if (failure) {
                    failure(err);
                }
            }];
}

/**
 *  关注某电影 / 取消关注
 *
 *  @param movieId  电影id
 *  @param relation 标志用户点击的是 关注/不关注
 *  @param success  成功回调 标志字段(可以不用理会)
 *  @param failure  失败回调
 */
- (void)requestSupportMovieWithMovieId:(NSInteger)movieId relation:(NSInteger)relation
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(NSError *_Nullable err))failure {

    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSMediaServerBase baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [dicParams setValue:[NSNumber numberWithInteger:movieId] forKey:@"movie_id"];
    [dicParams setValue:[NSNumber numberWithInteger:relation] forKey:@"relation"];

    //添加上传参数
    if (appDelegate.isAuthorized) { // 已登录
        [dicParams setObject:[DataEngine sharedDataEngine].userId forKey:@"user_id"];
    }

    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:KKSSMediaServerPath(@"movie/relation/save")
            parameters:newParams
            success:^(id _Nullable data, id _Nullable responseObject) {
                if (success) {
                    success(responseObject[@"result"]);
                }
            }
            failure:^(NSError *_Nullable err) {
                if (failure) {
                    failure(err);
                }
            }];
}

/**
 请求影院电影列表

 @param cinemaId cinemaID
 @param success  成功回调 @movieList <Movie>
 @param failure  失败回调
 */
- (void)requestMovieListIn:(NSNumber *_Nonnull)cinemaId
                   success:(nullable void (^)(NSArray *_Nullable movieList))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];

    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:@"movie_Query" forKey:@"action"];
    [dicParams setValue:cinemaId forKey:@"cinema_id"];

    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:kKSSPServer
              parameters:newParams
            resultKeyMap:@{ @"movies" : [Movie class] }
                 success:^(NSDictionary *_Nullable data, id _Nullable responseObject) {
                     if (success) {
                         success(data[@"movies"]);
                     }
                 }
                 failure:failure];
}

- (void)requestScoreList:(nullable void (^)(NSArray *_Nullable movieList))success
                 failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSDictionary *params = [KKZBaseRequestParams getDecryptParams:@{
                                                                    @"action": @"point_Query"
                                                                    }];
    [request GET:kKSSPServer
      parameters:params
    resultKeyMap:@{ @"points" : [Movie class] }
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
        success(responseObject[@"points"]);
    } failure:failure];
}

- (void)requestScoreWithMovieId:(NSNumber *)movieId
                        success:(nullable void (^)(NSDictionary * _Nullable))success
                        failure:(void (^)(NSError * _Nullable))failure {
    
    if (!movieId) {
        return;
    }
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSDictionary *params = [KKZBaseRequestParams getDecryptParams:@{
                                                                    @"action": @"point_Query",
                                                                    @"movie_id": movieId
                                                                    }];
    [request GET:kKSSPServer
      parameters:params
    resultKeyMap:@{ @"point" : [Movie class] }
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             success(responseObject[@"point"]);
         } failure:failure];
}

- (void)requestWantList:(nullable void (^)(NSArray *_Nullable movieList))success
                failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSDictionary *params = [KKZBaseRequestParams getDecryptParams:@{
                                                                    @"action": @"relation_Query"
                                                                    }];
    [request GET:kKSSPServer
      parameters:params
    resultKeyMap:@{ @"relations" : [Movie class] }
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
        success(responseObject[@"relations"]);
    } failure:failure];
}

- (void)requestWantMovieId:(NSNumber *)movieId success:(void (^)(BOOL))success failure:(void (^)(NSError * _Nullable))failure {
    if (!movieId) {
        return;
    }
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSDictionary *params = [KKZBaseRequestParams getDecryptParams:@{
                                                                    @"action": @"relation_Query",
                                                                    @"movie_id": movieId
                                                                    }];
    [request GET:kKSSPServer
      parameters:params
    resultKeyMap:nil
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             BOOL result = [responseObject[@"relation"][@"relation"] boolValue];
             success(result);
         } failure:failure];
}

- (void)addScoreMovieId:(nullable NSNumber *)movieId
                  point:(nullable NSNumber *)point
                success:(nullable void (^)())success
                failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSDictionary *params = [KKZBaseRequestParams
                            getDecryptParams:@{
                                               @"action": @"point_Add",
                                               @"movie_id": movieId,
                                               @"point": point
                                               }];
    [request GET:kKSSPServer parameters:params success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
        success();
    } failure:failure];
}

- (void)addRelationMovieId:(nullable NSString *)movieId
                  relation:(nullable NSString *)relation
                   success:(nullable void (^)())success
                   failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSDictionary *params = [KKZBaseRequestParams
                            getDecryptParams:@{
                                               @"action": @"relation_Add",
                                               @"movie_id": movieId,
                                               @"relation": [relation toNumber]
                                               }];
    [request GET:kKSSPServer parameters:params success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
        success();
    } failure:failure];
}

/*
 coupon_Query   group_id 传3是 兑换码
 coupon_Query   group_id 传4是 优惠券
 coupon_Query   group_id 传1是 现金码
 */
- (void)queryCouponListWithGroupId:(NSInteger)groupId
                           success:(nullable void (^)(NSArray *_Nullable couponList))success
                           failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSDictionary *params = [KKZBaseRequestParams
                            getDecryptParams:@{
                                               @"action": @"coupon_Query",
                                               @"group_id": @(groupId),
                                               }];
    [request GET:kKSSPServer parameters:params success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        success(responseObject[@"coupons"]);
    } failure:failure];
}

- (void)deleteCoupon:(NSString *)couponId
             success:(nullable void (^)())success
             failure:(nullable void (^)(NSError *_Nullable err))failure {
    if (!couponId) {
        return;
    }
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSDictionary *params = [KKZBaseRequestParams
                            getDecryptParams:@{
                                               @"action": @"coupon_Delete",
                                               @"coupon_id": couponId,
                                               }];
    [request GET:kKSSPServer parameters:params success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSInteger code = [responseObject[@"status"] integerValue];;
        if (code == 0) {
            success();
        }
    } failure:failure];
}

@end
