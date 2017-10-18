

//
//  ActivityRequest.m
//  CIASMovie
//
//  Created by cias on 2017/3/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "ActivityRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "DataEngine.h"
#import "Activity.h"
#import "KKZBaseRequestParamsMD5.h"

@implementation ActivityRequest

//某个订单支持的活动列表
- (void)requestActivityListParams:(NSDictionary *_Nullable)params
                          success:(nullable void (^)(NSArray *_Nullable data))success
                          failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPOrderBaseURL
                               baseParams:nil];
    
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    
    NSDictionary *newParams = [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/getActivitys"];
    
    [request GET:@"getActivitys"
      parameters:newParams
     resultClass:[Activity class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
  
             if (success) {
                 success(data);
             }
         }
         failure:failure];

}

//使用此活动
- (void)requestUseActivityParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(NSDictionary *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPOrderBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
    [bannerParams setValue:ciasTenantId forKey:@"tenantId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/changeActivity"];
    
    [request GET:@"changeActivity"
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];
}


@end
