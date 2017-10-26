//
//  PlanRequest.m
//  KoMovie
//
//  Created by Albert on 13/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "PlanRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "Seat.h"

@implementation PlanRequest


/**
 请求影院排期

 @param movieId  电影ID
 @param cinemaId 影院ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestPlanList:(NSNumber * _Nonnull) movieId inCineam:(NSNumber *_Nonnull)cinemaId
                 success:(nullable void (^)(NSArray *_Nullable plans))success
                 failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [dicParams setValue:@"plan_Query" forKey:@"action"];
    [dicParams setValue:@YES forKey:@"show_promotion"];
    [dicParams setValue:movieId forKey:@"movie_id"];
    [dicParams setValue:cinemaId forKey:@"cinema_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"plans":[Ticket class]}
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             
             if (success) {

                 success([data objectForKey:@"plans"]);
             }
         }
         failure:failure];
    
}

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
                 failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [dicParams setValue:@"plan_Query" forKey:@"action"];
    [dicParams setValue:@YES forKey:@"show_promotion"];
    [dicParams setValue:movieId forKey:@"movie_id"];
    NSString *ids = [cinemaIds componentsJoinedByString:@","];
    [dicParams setValue:ids forKey:@"cinema_ids"];
    [dicParams setValue:beginDate forKey:@"begin_date"];
    [dicParams setValue:endDate forKey:@"end_date"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"plans":[Ticket class]}
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 
                 success([data objectForKey:@"plans"]);
             }
         }
         failure:failure];
    
}


/**
 请求排期详情
 
 @param planID  排期ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestPlanDetail:(NSString * _Nonnull) planID
                   success:(nullable void (^)(Ticket *_Nullable plan))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [dicParams setValue:@"plan_Query" forKey:@"action"];
    [dicParams setValue:planID forKey:@"plan_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"plan":[Ticket class]}
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 Ticket *plan = [data objectForKey:@"plan"];
                 success(plan);
                 
             }
         }
         failure:failure];
}




/**
 请求影院电影位子
 
 @param cinemaId cinemaId
 @param planId   planId
 @param hall_id  hall_id
 @param success  成功回调 <Seat>
 @param failure  失败回调
 */
- (void)requestCinemaSeat:(NSNumber * _Nonnull) cinemaId
                   planId:(NSNumber *_Nonnull)planId
                   hallId:(NSString *_Nonnull)hall_id
                  success:(nullable void (^)(NSArray *_Nullable seats, NSString *_Nullable notice))success
                  failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:4];
    
    [dicParams setValue:@"seat_Hall" forKey:@"action"];
    [dicParams setValue:cinemaId forKey:@"cinema_id"];
    [dicParams setValue:planId forKey:@"plan_id"];
    [dicParams setValue:hall_id forKey:@"hall_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"seats":[Seat class]}
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             
             NSString *not = [respomsObject objectForKey:@"notice"];
             
             if (success) {
                 NSArray *seats = [data objectForKey:@"seats"];
                 success(seats, not);
             }
         }
         failure:failure];
}



/**
 请求影院电影选中的位子列表
 
 @param planId  plan_id
 @param success 成功回调 <Seat>
 @param failure 失败回调
 */
- (void)requestCinemaUnavailableSeat:(NSNumber *_Nonnull)planId
                             success:(nullable void (^)(NSArray *_Nullable seats))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [dicParams setValue:@"seat_Query" forKey:@"action"];
    [dicParams setValue:planId forKey:@"plan_id"];
    [dicParams setValue:@TRUE forKey:@"only_unavailable"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"seats":[Seat class]}
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 NSArray *seats = [data objectForKey:@"seats"];
                 success(seats);
             }
         }
         failure:failure];

}



@end
