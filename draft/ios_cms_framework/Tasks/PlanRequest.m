//
//  PlanRequest.m
//  CIASMovie
//
//  Created by hqlgree2 on 29/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import "PlanRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "PlanDate.h"
#import "Plan.h"
#import "KKZBaseRequestParamsMD5.h"

@implementation PlanRequest


- (void)requestPlanDateListParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSArray *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    request.parseKey = @"data";
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    [dic setValue:ciasChannelId forKey:@"channelId"];
    NSMutableDictionary *bannerParams = [NSMutableDictionary dictionaryWithDictionary:[dic copy]];
//    [bannerParams setValue:[params objectForKey:@"cinemaId"] forKey:@"cinemaId"];
//    [bannerParams setValue:[params objectForKey:@"filmId"] forKey:@"filmId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams = [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews, @"queryPlanDates"]];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryPlanDates"], newParams);
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryPlanDates"]
      parameters:newParams
     resultClass:[PlanDate class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
//             DLog(@"requestPlanDateListParams == /n%@/n", data);
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

- (void)requestPlanListParams:(NSDictionary *_Nullable)params
                          success:(nullable void (^)(NSArray *_Nullable data))success
                          failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                                                            baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    [dic setValue:ciasChannelId forKey:@"channelId"];
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:[dic copy] withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews, @"queryPlans"]];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryPlans"], newParams);
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryPlans"]
      parameters:newParams
     resultClass:[Plan class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"排期日期数据%@", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
     

}


@end
