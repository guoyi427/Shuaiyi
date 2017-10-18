//
//  CouponRequest.m
//  CIASMovie
//
//  Created by cias on 2017/3/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CouponRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "DataEngine.h"
#import "KKZBaseRequestParamsMD5.h"

@implementation CouponRequest

//我绑定的优惠券列表
- (void)requestMyCouponListParams:(NSDictionary *_Nullable)params
                          success:(nullable void (^)(NSArray<Coupon *> *_Nullable data))success
                          failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/webservice/cucapi/getCouponByUser"];
    
    [request GET:@"cucapi/getCouponByUser"
      parameters:newParams
     resultClass:[Coupon class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestMyCouponListParams == /n%@/n", data);

             if (success) {
                 success(data);
             }
         }
         failure:failure];

}

//使用此优惠券
- (void)requestCheckCouponParams:(NSDictionary *_Nullable)params
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
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/getConcessional"];
    
    [request GET:@"getConcessional"
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestCheckCouponParams == /n%@/n", respomsObject);

             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];
}

//  绑定优惠券
- (void)bindCouponWithOrderCode:(NSString *_Nullable)orderCode
             cardCouponsRawCode:(NSString *_Nullable)cardCouponsRawCode
                        success:(nullable void (^)(Coupon *_Nullable newCoupon))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPOrderBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bindParams =
    [NSMutableDictionary dictionaryWithDictionary:@{
                                                    @"orderCode":orderCode,
                                                    @"cardCouponsRawCode":cardCouponsRawCode
                                                    }];
    [bindParams setValue:ciasChannelId forKey:@"channelId"];
    [bindParams setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
    [bindParams setValue:ciasTenantId forKey:@"tenantId"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bindParams withMethod:@"POST" withRequestPath:@"/cias-order-web/getConcessional"];
    
    [request POST:@"offlineBindCoupons" parameters:newParams resultClass:nil success:^(id  _Nullable data, id  _Nullable responseObject) {
        NSLog(@"bing coupon response = %@", responseObject);
        if (success && responseObject[@"data"]) {
            Coupon *newCoupon = [Coupon new];
            newCoupon.batchCode=responseObject[@"data"][@"batchCode"];
            newCoupon.batchId=responseObject[@"data"][@"batchId"];
            newCoupon.couponName=responseObject[@"data"][@"couponName"];
            newCoupon.couponNums=responseObject[@"data"][@"couponNums"];
            newCoupon.couponType=responseObject[@"data"][@"couponType"];
            newCoupon.endTime=responseObject[@"data"][@"endTime"];
            newCoupon.expireDay=responseObject[@"data"][@"expireDay"];
            newCoupon.flowNum=responseObject[@"data"][@"flowNum"];
            newCoupon.couponId=responseObject[@"data"][@"id"];
            newCoupon.remark=responseObject[@"data"][@"remark"];
            newCoupon.rule=responseObject[@"data"][@"rule"];
            newCoupon.startTime=responseObject[@"data"][@"startTime"];
            newCoupon.status=responseObject[@"data"][@"status"];
            newCoupon.tenantId=responseObject[@"data"][@"tenantId"];
            success(newCoupon);
        }
    } failure:failure];
}

@end
