//
//  MovieRequest.h
//  KoMovie
//  电影相关查询
//  Created by renzc on 16/9/19.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieRequest : NSObject

/**
 *  查询正在上映的电影列表
 *
 *  @param city_id 城市id 必填
 *  @param page    第几页
 *  @param success 成功回调 @movieList: 包含对象类型[Movie class]
 *  @param failure 失败回调
 */
- (void)requestMoviesWithCityId:(NSString *_Nonnull)city_id
                           page:(NSInteger)page
                        success:(nullable void (^)(NSArray *_Nullable movieList))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  查询即将上映的电影列表
 *
 *  @param city_id 城市id 必填
 *  @param page    第几页
 *  @param success 成功回调 @movieList: 包含对象类型[Movie class]
 *  @param failure 失败回调
 */
- (void)requestInCommingMoviesWithCityId:(NSString *_Nonnull)city_id page:(NSInteger)page
                                 success:(nullable void (^)(NSArray *_Nullable movieList))success
                                 failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  查询电影详情
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 @movieDetail: 类型是[Movie class]
 *  @param failure 失败回调
 */
- (void)requestMovieDetailWithMovieId:(NSInteger)movieId
                              success:(nullable void (^)(id _Nullable movieDetail))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  查询电影媒体库
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 @responseObject: 包含剧照、声音、视频三种类型的model
 *  @param failure 失败回调
 */
- (void)requestMovieMediaLibraryWithMovieId:(NSInteger)movieId
                                    success:(nullable void (^)(id _Nullable responseObject))success
                                    failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  查询某电影的 喜欢和不喜欢人数
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 @responseObject: responseData[@"likeCount"]喜欢  && responseData[@"dislikeCount"] 不喜欢
 *  @param failure 失败回调
 */
- (void)requestMovieSupportWithMovieId:(NSInteger)movieId
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  关注某电影 / 取消关注
 *
 *  @param movieId  电影id 必填
 *  @param relation 标志用户点击的是 关注/不关注
 *  @param success  成功回调 标志字段(可以不用理会)
 *  @param failure  失败回调
 */
- (void)requestSupportMovieWithMovieId:(NSInteger)movieId relation:(NSInteger)relation
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(NSError *_Nullable err))failure;
/**
 请求影院电影列表
 
 @param cinemaId cinemaID
 @param success  成功回调 @movieList <Movie>
 @param failure  失败回调
 */
- (void)requestMovieListIn:(NSNumber *_Nonnull)cinemaId
                   success:(nullable void (^)(NSArray *_Nullable movieList))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure;

- (void)requestScoreList:(nullable void (^)(NSArray *_Nullable movieList))success
                 failure:(nullable void (^)(NSError *_Nullable err))failure;

- (void)requestWantList:(nullable void (^)(NSArray *_Nullable movieList))success
                failure:(nullable void (^)(NSError *_Nullable err))failure;

/// point 分数  1~10
- (void)addScoreMovieId:(nullable NSString *)movieId
                  point:(nullable NSString *)point
                success:(nullable void (^)())success
                failure:(nullable void (^)(NSError *_Nullable err))failure;

/// relation 1: 喜欢
- (void)addRelationMovieId:(nullable NSString *)movieId
                  relation:(nullable NSString *)relation
                   success:(nullable void (^)())success
                   failure:(nullable void (^)(NSError *_Nullable err))failure;

/*
 coupon_Query   group_id 传3是 兑换码
 coupon_Query   group_id 传4是 优惠券
 coupon_Query   group_id 传1是 现金码
 */
- (void)queryCouponListWithGroupId:(NSInteger)groupId
                           success:(nullable void (^)(NSArray *_Nullable couponList))success
                           failure:(nullable void (^)(NSError *_Nullable err))failure;


@end
