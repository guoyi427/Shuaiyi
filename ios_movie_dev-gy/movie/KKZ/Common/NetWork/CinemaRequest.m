//
//  CinemaRequest.m
//  KoMovie
//
//  Created by Albert on 9/5/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaRequest.h"

#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>

#import "CinemaDetail.h"
#import "CinemaFeature.h"
#import "Constants.h"
#import <DateEngine_KKZ/DateEngine.h>
#import "ShareContent.h"

@implementation CinemaRequest
/**
 *  请求影院详情
 *
 *  @param params  参数：必填：cinema_id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestCinemaDetail:(NSDictionary * _Nonnull)params
                    success:(nullable void (^)(CinemaDetail *_Nullable cinemaDetail, ShareContent *_Nullable share))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];

    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:params];
    [para setObject:@"cinema_Selfquery" forKey:@"action"];

    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:para];

    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"cinema":[CinemaDetail class], @"share":[ShareContent class]}
//  cacheValidTime:60
         success:^(NSDictionary * _Nullable data, id  _Nullable respomsObject) {
        if (success) {
            success(data[@"cinema"], data[@"share"]);
        }
    } failure:failure];
}

/**
 *  请求影院特色信息
 *
 *  @param params  参数：必填：cinema_id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestCinemaFeatureParams:(NSDictionary *_Nullable)params
                           success:(nullable void (^)(NSArray *_Nullable features))success
                           failure:(nullable void (^)(NSError *_Nullable err))failure {

    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];

    // set model peaer key
    request.parseKey = @"cinemaFeatures";

    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [dicParams setObject:@"cinema_Firebird" forKey:@"action"];

    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:kKSSPServer
                parameters:newParams
               resultClass:[CinemaFeature class]
            cacheValidTime:180
                   success:^(id _Nullable data, id _Nullable respomsObject) {
                       if (success) {
                           success(data);
                       }
                   }
                   failure:failure];
}

/**
 *  请求影院列表
 *
 *  @param cityID  city_id(必填)
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestCinemaList:(NSString *_Nonnull)cityID
                  success:(nullable void (^)(NSArray *_Nullable cinemas, NSArray *_Nullable favedCinemas, NSArray *_Nullable favorCinemas))success
                  failure:(nullable void (^)(NSError *_Nullable err))failure {

    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];

    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    if (cityID.length) {
        [dicParams setObject:cityID forKey:@"city_id"];
    }

    [dicParams setObject:@"cinema_Query" forKey:@"action"];
    [dicParams setObject:@YES forKey:@"show_promotion"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:kKSSPServer
              parameters:newParams
            resultKeyMap:@{
                @"cinemas" : [CinemaDetail class],
                @"faved" : [CinemaDetail class],
                @"favor" : [CinemaDetail class]
            }
                 
                 success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {

                     if (success) {
                         success([data objectForKey:@"cinemas"], [data objectForKey:@"faved"], [data objectForKey:@"favor"]);
                     }
                 }
                 failure:failure];
}

/**
 *  查询城市中上映某影片的影院列表。
 *
 *  @param cityID       city_id(必填)
 *  @param movieID      movieID(必填)
 *  @param beginDate    开始时间YYYY-MM-DD(必填)
 *  @param endDate      结束时间YYYY-MM-DD(必填)
 *  @param success      成功回调
 *  @param failure      失败回调
 */
- (void)requestCinemaList:(NSNumber *_Nonnull)cityID
                  movieID:(NSNumber *_Nonnull)movieID
                beginDate:(NSString *_Nullable)beginDate
                  endDate:(NSString *_Nullable)endDate
                  success:(nullable void (^)(NSArray *_Nullable cinemas, NSArray *_Nullable favedCinemas, NSArray *_Nullable favorCinemas))success
                  failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];

    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];

    [dicParams setValue:cityID forKey:@"city_id"];
    [dicParams setValue:beginDate forKey:@"begin_date"];
    [dicParams setValue:endDate forKey:@"end_date"];
    [dicParams setValue:movieID forKey:@"movie_id"];

    [dicParams setObject:@"cinema_Selfquery" forKey:@"action"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:kKSSPServer
              parameters:newParams
            resultKeyMap:@{
                @"cinemas" : [CinemaDetail class],
                @"faved" : [CinemaDetail class],
                @"favor" : [CinemaDetail class]
            }
                 success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {

                     if (success) {
                         success([data objectForKey:@"cinemas"], [data objectForKey:@"faved"], [data objectForKey:@"favor"]);
                     }
                 }
                 failure:failure];
}

/**
 *  请求电影排期日期
 *
 *  @param movieID  movie_id(必填)
 *  @param cityID  cityID(必填)
 *  @param success 成功回调 dates <NSString> e.g 2016-10-17
 *  @param failure 失败回调
 */
- (void)requestDate:(NSNumber *_Nonnull)movieID
             cityID:(NSNumber *_Nonnull)cityID
            success:(nullable void (^)(NSArray *_Nullable dates))success
            failure:(nullable void (^)(NSError *_Nullable err))failure {

    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];

    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    if (movieID) {
        [dicParams setObject:movieID forKey:@"movie_id"];
    }

    [dicParams setValue:cityID forKey:@"city_id"];
    [dicParams setObject:@"plan_Date" forKey:@"action"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:kKSSPServer
              parameters:newParams
            resultKeyMap:NULL
                 success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {

                     if (success) {
                         success([respomsObject objectForKey:@"dates"]);
                     }
                 }
                 failure:failure];
}

/**
 *  查询城市中上映某影片的影院列表
 *
 *  @param movieID  movie_id(必填)
 *  @param beginDate 开始时间
 *  @param endDate   结束时间
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestCinemas:(NSNumber *_Nonnull)movieID
             beginTime:(NSDate *_Nonnull)beginDate
               endDate:(NSDate *_Nonnull)endDate
               success:(nullable void (^)(NSArray *_Nullable dates))success
               failure:(nullable void (^)(NSError *_Nullable err))failure {

    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];

    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    if (movieID) {
        [dicParams setObject:movieID forKey:@"movie_id"];
    }

    if (beginDate) {
        [dicParams setObject:movieID forKey:@"begin_date"];
    }

    if (endDate) {
        [dicParams setObject:movieID forKey:@"end_date"];
    }

    [dicParams setValue:@"plan_Date" forKey:@"action"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:kKSSPServer
              parameters:newParams
            resultKeyMap:NULL
                 success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
                     if (success) {
                         success([respomsObject objectForKey:@"dates"]);
                     }
                 }
                 failure:failure];
}

/**
 *  查询影院的图集
 *
 *  @param cinemaId  cinemaId(必填)
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestGallery:(NSNumber *_Nonnull)cinemaId
               success:(nullable void (^)(NSArray *_Nullable galleryList))success
               failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];

    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setValue:@"media_Query" forKey:@"action"];
    [dicParams setValue:cinemaId forKey:@"target_id"];
    [dicParams setValue:@"20" forKey:@"media_type"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    [request GET:kKSSPServer
              parameters:newParams
            resultKeyMap:NULL
                 success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {

                     if (success) {
                         success([respomsObject objectForKey:@"galleries"]);
                     }
                 }
                 failure:failure];
}

/**
 查询优惠信息

 @param cityID 城市ID
 @param cinemaId 影院ID
 @param movieID 电影ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestPromotionList:(NSNumber *_Nonnull)cityID
                     cinemaId:(NSNumber *_Nonnull)cinemaId
                      movieID:(NSNumber *_Nonnull)movieID
                      success:(nullable void (^)(NSArray *_Nullable promotionList))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setValue:@"activity_Promotion" forKey:@"action"];
    [dicParams setValue:cityID forKey:@"city_id"];
    [dicParams setValue:cinemaId forKey:@"cinema_id"];
    [dicParams setValue:movieID forKey:@"movie_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"promotions":[Promotion class]}
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 success([data objectForKey:@"promotions"]);
             }
         }
         failure:failure];
}

@end
