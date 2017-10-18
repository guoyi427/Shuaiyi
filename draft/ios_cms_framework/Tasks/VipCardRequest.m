//
//  VipCardRequest.m
//  CIASMovie
//
//  Created by cias on 2017/2/24.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "VipCardRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "VipCard.h"
#import "DataEngine.h"
#import "CardTypeList.h"
#import "CardTypeDetail.h"
#import "KKZBaseRequestParamsMD5.h"


@implementation VipCardRequest
//储值卡列表（返回包含通用卡）
- (void)requestStoreVipCardListParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(NSDictionary *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardQueryByStoreValue"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardQueryByStoreValue"], newParams);
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardQueryByStoreValue"]
      parameters:newParams
     resultClass:[VipCardListDetail class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(data);
             }
         }
         failure:failure];

}
//折扣卡列表（返回包含通用卡）
- (void)requestDiscountVipCardListParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(NSDictionary *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardQueryByDiscount"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardQueryByDiscount"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardQueryByDiscount"]
      parameters:newParams
     resultClass:[VipCardListDetail class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(data);
             }
         }
         failure:failure];
    
}

//会员卡列表
- (void)requestVipCardListParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(VipCardListDetail *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardQuery"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardQuery"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardQuery"]
      parameters:newParams
     resultClass:[VipCardListDetail class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"cardListrespomsObject:%@", respomsObject);
             DLog(@"cardListData:%@", data);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
    
}

//会员卡查询优惠cardDiscountQuery
- (void)requestVipCardDiscountQueryParams:(NSDictionary *_Nullable)params
                                  success:(nullable void (^)(NSDictionary *_Nullable data))success
                                  failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
//    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardDiscountQuery"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardDiscountQuery"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardDiscountQuery"]
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             //                          DLog(@"requestStoreVipCardListParams == /n%@/n", data);
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];

}

- (void)requestVipCardIsBindedParams:(NSDictionary *_Nullable)params
                             success:(nullable void (^)(NSDictionary *_Nullable data))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL baseParams:nil];
    // set model peaer key
    request.parseKey = @"data";
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardWhetherBind"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardWhetherBind"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardWhetherBind"]
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];
}


- (void)requestVipCardPhoneNumParams:(NSDictionary *_Nullable)params
                             success:(nullable void (^)(NSDictionary *_Nullable data))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL baseParams:nil];
    // set model peaer key
    request.parseKey = @"data";
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardLogin"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardLogin"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardLogin"]
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];
}


//绑定会员卡
- (void)requestVipCardBindingParams:(NSDictionary *_Nullable)params
                            success:(nullable void (^)(NSDictionary *_Nullable data))success
                            failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL baseParams:nil];
    // set model peaer key
    request.parseKey = @"data";
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardBind"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardBind"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardBind"]
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];
}

//MARK: 会员卡支付接口
- (void)requestPayOrderWithVipCardParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSDictionary *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPOrderBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
    [bannerParams setValue:ciasTenantId forKey:@"tenantId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/order/memberCardPay"];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"order/memberCardPay", newParams);
    
    [request GET:@"order/memberCardPay"
      parameters:newParams
     resultClass:nil
         success:^(id  _Nullable data, id  _Nullable responseObject) {
             if (success) {
                success(responseObject);
             }
    } failure:failure];
    
}

//MARK: 会员卡验证码接口
- (void)requestPayOrderCodeWithVipCardParams:(NSDictionary *_Nullable)params
                                 success:(nullable void (^)(NSDictionary *_Nullable data))success
                                 failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPOrderBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
    [bannerParams setValue:ciasTenantId forKey:@"tenantId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/order/sendMessage"];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"order/sendMessage", newParams);
    
    [request GET:@"order/sendMessage"
      parameters:newParams
     resultClass:nil
         success:^(id  _Nullable data, id  _Nullable responseObject) {
             if (success) {
                success(responseObject);
             }
    } failure:failure];
    
}


//会员卡充值套餐接口
- (void)requestVipCardRechargeValueParams:(NSDictionary *_Nullable)params
                                  success:(nullable void (^)(NSDictionary *_Nullable data))success
                                  failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL baseParams:nil];
    // set model peaer key
    request.parseKey = @"data";
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardRechargePackage"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardRechargePackage"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardRechargePackage"]
      parameters:newParams
     resultClass:nil
         success:^(id  _Nullable data, id  _Nullable responseObject) {
             DLog(@"充值套餐：%@", responseObject);
             if (success) {
                 success(responseObject);
             }
         } failure:failure];
}



//会员卡充值订单接口
- (void)requestVipCardRechargeOrderParams:(NSDictionary *_Nullable)params
                                  success:(nullable void (^)(NSDictionary *_Nullable data))success
                                  failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL baseParams:nil];
    // set model peaer key
    request.parseKey = @"data";
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"createOrder"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"createOrder"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"createOrder"]
      parameters:newParams
     resultClass:nil
         success:^(id  _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 success(responseObject);
             }
         } failure:failure];
}


//会员卡开卡类型列表
- (void)requestVipCardTypeListParams:(NSDictionary *_Nullable)params
                             success:(nullable void (^)(NSDictionary *_Nullable data))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure {
    
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardProductQuery"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardProductQuery"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardProductQuery"]
      parameters:newParams
     resultClass:[CardTypeList class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(data);
             }
         }
         failure:failure];
    
}


//会员卡开卡详情
- (void)requestVipCardTypeDetailParams:(NSDictionary *_Nullable)params
                               success:(nullable void (^)(NSDictionary *_Nullable data))success
                               failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardProductDetail"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardProductDetail"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardProductDetail"]
      parameters:newParams
     resultClass:[CardTypeDetail class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(data);
             }
         }
         failure:failure];
}


//会员卡开卡订单接口
- (void)requestVipCardOpenOrderParams:(NSDictionary *_Nullable)params
                                  success:(nullable void (^)(NSDictionary *_Nullable data))success
                                  failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL baseParams:nil];
    // set model peaer key
    request.parseKey = @"data";
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"createOrder"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"createOrder"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"createOrder"]
      parameters:newParams
     resultClass:nil
         success:^(id  _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 success(responseObject);
             }
         } failure:failure];
}


//会员卡详情
- (void)requestVipCardDetailParams:(NSDictionary *_Nullable)params
                           success:(nullable void (^)(CardListDetail *_Nullable data))success
                           failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardDetail"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardDetail"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardDetail"]
      parameters:newParams
     resultClass:[CardListDetail class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"cardDetailData: %@", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
}




//MARK:会员卡赠送优惠券
- (void)requestVipCardCouponParams:(NSDictionary *_Nullable)params
                           success:(nullable void (^)(NSDictionary *_Nullable data))success
                           failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
//    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardSendCoupon"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardSendCoupon"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardSendCoupon"]
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestVipCardCouponParams == /n%@/n", data);
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];
}


//MARK:会员卡开卡发送验证码
- (void)requestOpenCardCodeParams:(NSDictionary *_Nullable)params
                          success:(nullable void (^)(NSDictionary *_Nullable data))success
                          failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardMobileWhetherUse"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardMobileWhetherUse"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardMobileWhetherUse"]
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];
}

//MARK: 会员卡开卡协议
- (void)requestOpenCardProtocolParams:(NSDictionary *_Nullable)params
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
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardProductProtocol"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardProductProtocol"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardProductProtocol"]
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestOpenCardProtocolParams%@", respomsObject);
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];
}

//MARK:会员卡解绑
- (void)requestUnbindCardParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(NSDictionary *_Nullable data))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardUnbind"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardUnbind"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardUnbind"]
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];
}



//会员卡开卡提示列表
- (void)requestCanOpenCardListParams:(NSDictionary *_Nullable)params
                             success:(nullable void (^)(NSDictionary *_Nullable data))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure {
    
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"memberId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", memberConfigNews, @"cardProductQueryOne"]];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardProductQueryOne"], newParams);
    
    [request GET:[NSString stringWithFormat:@"%@%@", memberConfigNews, @"cardProductQueryOne"]
      parameters:newParams
     resultClass:[CardTypeDetail class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"排期页开卡信息:%@", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
    
}

@end
