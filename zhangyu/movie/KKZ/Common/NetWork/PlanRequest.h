//
//  PlanRequest.h
//  KoMovie
//
//  Created by Albert on 13/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Ticket.h"

/**
 查询排期相关的接口
 */
@interface PlanRequest : NSObject

/**
 请求影院排期
 
 @param movieId  电影ID
 @param cinemaId 影院ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestPlanList:(NSNumber * _Nonnull) movieId inCineam:(NSNumber *_Nonnull)cinemaId
                 success:(nullable void (^)(NSArray *_Nullable plans))success
                 failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 请求多个影院排期
 
 @param movieId  电影ID
 @param cinemaIds 影院ID列表
 @param beginDate 开始日期
 @param endDate 结束日期
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestPlanList:(NSNumber * _Nonnull) movieId
               inCineams:(NSArray<NSNumber *> *_Nonnull)cinemaIds
               beginDate:(NSString * _Nonnull)beginDate
                 endDate:(NSString * _Nonnull)endDate
                 success:(nullable void (^)(NSArray *_Nullable plans))success
                 failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 请求排期详情
 
 @param planID  排期ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestPlanDetail:(NSString * _Nonnull) planID
                   success:(nullable void (^)(Ticket *_Nullable plan))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure;



/**
 请求影院电影位子

 @param cinemaId cinemaId
 @param planId   planId
 @param hall_id  hall_id
 @param success  成功回调 <Seat> notice
 @param failure  失败回调
 */
- (void)requestCinemaSeat:(NSNumber * _Nonnull)cinemaId
                   planId:(NSNumber *_Nonnull)planId
                   hallId:(NSString *_Nonnull)hall_id
                  success:(nullable void (^)(NSArray *_Nullable seats, NSString *_Nullable notice))success
                  failure:(nullable void (^)(NSError *_Nullable err))failure;



/**
 请求影院电影选中的位子列表

 @param planId  plan_id
 @param success 成功回调 <Seat>
 @param failure 失败回调
 */
- (void)requestCinemaUnavailableSeat:(NSNumber *_Nonnull)planId
                             success:(nullable void (^)(NSArray *_Nullable seats))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure;

@end
