//
//  CinemaRequest.m
//  CIASMovie
//
//  Created by cias on 2016/12/29.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "CinemaRequest.h"
#import "Cinema.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "UserDefault.h"
#import "CardCinemaList.h"
#import "KKZBaseRequestParamsMD5.h"

@implementation CinemaRequest


- (void)requestCinemaListParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(NSArray *_Nullable data))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams = [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews, @"queryCinemas"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryCinemas"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryCinemas"]
      parameters:newParams
     resultClass:[Cinema class]
  cacheValidTime:1
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestCinemaListParams == /n%@/n", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
}


- (void)requestOpenCardCinemaListParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(NSDictionary *_Nullable data))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardProductCinemaQuery"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardProductCinemaQuery"], newParams);
    
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardProductCinemaQuery"]
      parameters:newParams
     resultClass:[CardCinemaList class]
  cacheValidTime:1
         success:^(id _Nullable data, id _Nullable respomsObject) {
            DLog(@"requestCinemaListParams == /n%@/n", data);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
    
}


@end
