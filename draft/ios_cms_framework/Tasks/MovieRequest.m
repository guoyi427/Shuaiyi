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

//  ---------------------   kkz

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
    if ([DataEngine sharedDataEngine].userId) { // 已登录
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
    if ([DataEngine sharedDataEngine].userId) { // 已登录
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

/**
 *  查询电影明星（导演、主演、配角等）
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 @actorList: 包含对象类型 [Actor class]
 *  @param failure 失败回调
 */
- (void) requestActorListForMovieWithMovieId:(NSInteger )movieId
                                     success:(nullable void (^)(NSArray *_Nullable actorList))success
                                     failure:(nullable void (^)(NSError * _Nullable err))failure{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:@"movie_members"  forKey:@"action"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",movieId]  forKey:@"movie_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPDataServer parameters:newParams success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            
            NSArray *actors = responseObject[@"members"];
            NSMutableArray *actorsM = [[NSMutableArray alloc] initWithCapacity:0];
            [actors enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
//                Actor *star = [Actor mj_objectWithKeyValues:obj[@"star"]];
//                //set character
//                star.character = obj[@"character"];
//                if (star) {
//                    [actorsM addObject:star];
//                }
                [actorsM addObject:obj];
            }];
            
            success(actorsM);
        }
    } failure:^(NSError * _Nullable err) {
        if (failure) {
            failure(err);
        }
    }];
}

@end
