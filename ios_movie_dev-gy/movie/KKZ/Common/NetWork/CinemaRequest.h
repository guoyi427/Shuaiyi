//
//  CinemaRequest.h
//  KoMovie
//
//  Created by Albert on 9/5/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>

@class CinemaDetail;
@class ShareContent;

@interface CinemaRequest : NSObject

/**
 *  请求影院详情
 *
 *  @param params  参数：必填：cinema_id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestCinemaDetail:(NSDictionary *_Nonnull)params
                    success:(nullable void (^)(CinemaDetail *_Nullable cinemaDetail, ShareContent *_Nullable share))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  请求影院特色信息
 *
 *  @param params  参数：必填：cinema_id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestCinemaFeatureParams:(NSDictionary *_Nullable)params
                           success:(nullable void (^)(NSArray *_Nullable features))success
                           failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  请求影院列表
 *
 *  @param cityID  city_id(必填)
 *  @param success 成功回调 cinemas：影院列表 favedCinemas：买过票的影院 favorCinemas：收藏的影院列表
 *  @param failure 失败回调
 */
- (void)requestCinemaList:(NSString *_Nonnull)cityID
                  success:(nullable void (^)(NSArray *_Nullable cinemas, NSArray *_Nullable favedCinemas, NSArray *_Nullable favorCinemas))success
                  failure:(nullable void (^)(NSError *_Nullable err))failure;

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
                  failure:(nullable void (^)(NSError *_Nullable err))failure;

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
            failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  查询影院的图集
 *
 *  @param cinemaId  cinemaId(必填)
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestGallery:(NSNumber *_Nonnull)cinemaId
               success:(nullable void (^)(NSArray *_Nullable galleryList))success
               failure:(nullable void (^)(NSError *_Nullable err))failure;

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
                      failure:(nullable void (^)(NSError *_Nullable err))failure;

@end
