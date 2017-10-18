//
//  BannerRequest.m
//  CIASMovie
//
//  Created by cias on 2016/12/29.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "BannerRequest.h"
#import <NetCore_KKZ/KKZBaseNetRequest.h>
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "Banner.h"
#import "KKZBaseRequestParamsMD5.h"

@implementation BannerRequest

- (void)requestBannerListParams:(NSDictionary *_Nullable)params
                       success:(nullable void (^)(NSArray *_Nullable banners))success
                       failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    [bannerParams setObject:@"wx_banners" forKey:@"action"];
    //    [bannerParams setValue:[[CPUserCenter shareInstance] bindedCityId] forKey:@"city_id"];
    
    NSDictionary *newParams = [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/webservice/"];
    
    [request GET:@""
      parameters:newParams
     resultClass:[Banner class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestBannerListParams == /n%@/n", data);
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



@end
