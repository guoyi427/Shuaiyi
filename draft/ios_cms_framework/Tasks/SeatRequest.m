//
//  SeatRequest.m
//  CIASMovie
//
//  Created by cias on 2017/1/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "SeatRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "Seat.h"
#import "KKZBaseRequestParamsMD5.h"

@implementation SeatRequest



- (void)requestSeatListParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(NSArray *_Nullable data))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    //    [bannerParams setValue:[[CPUserCenter shareInstance] bindedCityId] forKey:@"city_id"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews, @"querySeats"]];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", ciasFilmNews, @"querySeats"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"querySeats"]
      parameters:newParams
     resultClass:[Seat class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
//             DLog(@"requestSeatListParams == /n%@/n", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
}


@end
