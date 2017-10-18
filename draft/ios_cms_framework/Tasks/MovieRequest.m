//
//  MovieRequest.m
//  CIASMovie
//
//  Created by cias on 2016/12/19.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "MovieRequest.h"
#import <NetCore_KKZ/KKZBaseNetRequest.h>
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "Movie.h"
#import "UserDefault.h"
#import "KKZBaseRequestParamsMD5.h"

@implementation MovieRequest

/**
 *  请求电影列表
 *
 *  @param params  参数：选填：cinema_id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestMovieListParams:(NSDictionary *_Nullable)params
                       success:(nullable void (^)(NSArray <Movie*> *_Nullable movies))success
                       failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams = [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/",ciasFilmNews, @"queryHotFilms"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryHotFilms"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryHotFilms"]
      parameters:newParams
     resultClass:[Movie class]
     cacheValidTime:15
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestMovieListParams == /n%@/n", respomsObject);
             //更新最热海报
//NSArray *movies = data;
//             if (movies.count > 0) {
//                 for (int i = 0; i < movies.count; i++) {
//                     Movie *movie = movies[i];
//                     if (movie.bigPosterPath) {
//                         UpdateHotPoster(movie.bigPosterPath);
//                         break;
//                     }
//                 }
//             }
             if (success) {
                 success(data);
             }
         }
         failure:failure];
}

- (void)requestCinemaMovieListParams:(NSDictionary *_Nullable)params
                       success:(nullable void (^)(NSArray *_Nullable movies))success
                       failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    if ([USER_CITY length]) {
        [bannerParams setObject:USER_CITY forKey:@"cityId"];

    }
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/",ciasFilmNews, @"queryHotFilms"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryHotFilms"]
      parameters:newParams
     resultClass:[Movie class]
  cacheValidTime:0
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(data);
             }
         }
         failure:failure];
}

- (void)requestIncomingMovieDateListParams:(NSDictionary *_Nullable)params
                                   success:(nullable void (^)(NSArray *_Nullable movies))success
                                   failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    if ([USER_CITY length]) {
        [bannerParams setObject:USER_CITY forKey:@"cityId"];
    }
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/",ciasFilmNews, @"queryFutureFilmDateList"]];

    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryFutureFilmDateList"]
      parameters:newParams
     resultClass:nil
  cacheValidTime:15
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestIncomingMovieDateListParams == /n%@/n", respomsObject);
             if (success) {
                 NSArray *dataArr = [respomsObject objectForKey:@"data"];
                 success(dataArr);
             }
         }
         failure:failure];

}

- (void)requestIncomingMovieListParams:(NSDictionary *_Nullable)params
                               success:(nullable void (^)(NSArray *_Nullable movies))success
                               failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    if ([USER_CITY length]) {
        [bannerParams setObject:USER_CITY forKey:@"cityId"];
    }
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/",ciasFilmNews, @"queryFutureFilms"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryFutureFilms"]
      parameters:newParams
     resultClass:[Movie class]
  cacheValidTime:15
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestIncomingMovieListParams == /n%@/n", data);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
}


- (void)requestMoviePhotoListParams:(NSDictionary *_Nullable)params
                                   success:(nullable void (^)(NSArray *_Nullable moviePhotos))success
                                   failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews, @"queryFilmSources"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryFilmSources"]
      parameters:newParams
     resultClass:nil
  cacheValidTime:15
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestMoviePhotoListParams == /n%@/n", data);
             if (success) {
                 NSArray *dataArr = [respomsObject objectForKey:@"data"];
                 success(dataArr);
             }
         }
         failure:failure];
    
}


- (void)requestMovieActorListParams:(NSDictionary *_Nullable)params
                            success:(nullable void (^)(NSArray *_Nullable movieActors))success
                            failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews, @"queryFilmPeoples"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryFilmPeoples"]
      parameters:newParams
     resultClass:nil
  cacheValidTime:15
         success:^(id _Nullable data, id _Nullable respomsObject) {
              DLog(@"requestMovieActorListParams == /n%@/n", data);
             if (success) {
                 NSArray *dataArr = [respomsObject objectForKey:@"data"];
                 success(dataArr);
             }
         }
         failure:failure];
    
}

- (void)requestMovieVideoParams:(NSDictionary *_Nullable)params
                            success:(nullable void (^)(NSArray *_Nullable movieVideo))success
                            failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews, @"queryFilmSources"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryFilmSources"]
      parameters:newParams
     resultClass:nil
  cacheValidTime:15
         success:^(id _Nullable data, id _Nullable respomsObject) {
              DLog(@"requestMovieVideoParams == /n%@/n", data);
             if (success) {
                 NSArray *dataArr = [respomsObject objectForKey:@"data"];
                 success(dataArr);
             }
         }
         failure:failure];
    
}


//MARK: 影片详情
- (void)requestMovieDetailParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(Movie *_Nullable movieDetail))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews, @"queryFilmDetail"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryFilmDetail"]
      parameters:newParams
     resultClass:[Movie class]
  cacheValidTime:0
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestMovieDetailParams == /n%@/n", data);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
}

@end
