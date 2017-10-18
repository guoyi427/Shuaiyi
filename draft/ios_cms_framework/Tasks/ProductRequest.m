//
//  ProductRequest.m
//  CIASMovie
//
//  Created by cias on 2017/3/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "ProductRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "ProductListDetail.h"
#import "UserDefault.h"
#import "KKZBaseRequestParamsMD5.h"

@implementation ProductRequest
//卖品列表
- (void)requestProductListParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(NSDictionary *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:USER_CINEMAID forKey:@"cinema_id"];
    [bannerParams setValue:ciasChannelId forKey:@"channel_id"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    [bannerParams setValue:@"1" forKey:@"page"];
    [bannerParams setValue:@"100" forKey:@"page_size"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", productConfigNews, @"saleCoupons"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", productConfigNews, @"saleCoupons"]
      parameters:newParams
     resultClass:[ProductListDetail class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"卖品信息 == /n%@/n", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];

    
}


@end
