
//
//  OrderRequest.m
//  CIASMovie
//
//  Created by cias on 2017/1/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "Order.h"
#import "DataEngine.h"
#import "OrderListData.h"
#import "OrderListRecord.h"
#import "OrderDetailOfMovie.h"
#import "UserDefault.h"
#import "KKZBaseRequestParamsMD5.h"

@implementation OrderRequest

- (void)requestOrderAddParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSDictionary *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews, @"placeOrder"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"placeOrder"]
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
   
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];
}
//MARK: 下单后订单信息获取接口
- (void)requestGetOrderInfoParams:(NSDictionary *_Nullable)params
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
    NSString *latString = [BAIDU_USER_LATITUDE length] ? BAIDU_USER_LATITUDE : USER_LATITUDE;
    NSString *lonString = [BAIDU_USER_LONGITUDE length] ? BAIDU_USER_LONGITUDE : USER_LONGITUDE;
    if (latString.length > 0) {
        [bannerParams setObject:latString forKey:@"lat"];
    }
    if (lonString.length > 0) {
        [bannerParams setObject:lonString forKey:@"lon"];
    }
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];


    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/orderPayInfo"];
    
    [request GET:@"orderPayInfo"
      parameters:newParams
     resultClass:[Order class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"orderPatInfo:%@", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
    
}
//MARK: 支付接口
- (void)requestPayOrderParams:(NSDictionary *_Nullable)params
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
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"POST" withRequestPath:@"/cias-order-web/order/payOrder"];
    
    [request POST:@"order/payOrder"
       parameters:newParams
      resultClass:nil
          success:^(id _Nullable data, id _Nullable respomsObject) {
              //             DLog(@"requestUserLoginCodeParams == /n%@/n", data);
              //             DLog(@"requestUserLoginCodeParams == /n%@/n", respomsObject);
              
              if (success) {
                  success(data);
              }
          }
          failure:failure];

}

- (void)requestGoPayOrderParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSDictionary *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPOrderBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasTenantId forKey:@"tenantId"];
    if ([USER_CINEMAID length]>0) {
        [bannerParams setValue:USER_CINEMAID forKey:@"cinemaId"];
    }
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/order/goPay"];
    
//    [request POST:@"order/goPay"
//       parameters:newParams
//      resultClass:nil
//          success:^(id _Nullable data, id _Nullable respomsObject) {
//              if (success) {
//                  success(respomsObject);
//              }
//          }
//          failure:failure];
    [request GET:@"order/goPay"
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];

}

//MARK: 出票接口
- (void)requestOutTicketInfoParams:(NSDictionary *_Nullable)params
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
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/getOutTicketInfo"];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPOrderBaseURL, @"getOutTicketInfo", newParams);
    [request GET:@"getOutTicketInfo"
      parameters:newParams
     resultClass:[Order class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestOutTicketInfoParams:%@", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];

}
//MARK: 取消订单
- (void)requestCancelOrderParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(NSDictionary *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPOrderBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
//    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/order/cancelOrder"];
    
    [request GET:@"order/cancelOrder"
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 success(data);
             }
         }
         failure:failure];
    
}

//MARK: 订单详情
- (void)requestOrderDetailParams:(NSDictionary *_Nullable)params
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
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/orderTicketDetailInfo"];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPOrderBaseURL, @"orderTicketDetailInfo", newParams);
    
    [request GET:@"orderTicketDetailInfo"
      parameters:newParams
     resultClass:[Order class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestOrderDetailParams:%@", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
    
}

//MARK: 影票订单详情
- (void)requestOrderDetailFromListParams:(NSDictionary *_Nullable)params
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
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/orderTicketDetailInfo"];
    
    [request GET:@"orderTicketDetailInfo."
      parameters:newParams
     resultClass:[OrderDetailOfMovie class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
//             DLog(@"%@",data);
             DLog(@"requestOrderDetailFromListParams:%@", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
    
}

//MARK: 充值开卡订单详情
- (void)requestCardOrderDetailFromListParams:(NSDictionary *_Nullable)params
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
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/orderCardDetailInfo"];
    
    [request GET:@"orderCardDetailInfo."
      parameters:newParams
     resultClass:[OrderDetailOfMovie class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             //             DLog(@"%@",data);
            DLog(@"充值订单详情：%@", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
    
}

//MARK: 未支付订单列表
- (void)requestOrderUnpayParams:(NSDictionary *_Nullable)params
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
    [bannerParams setValue:ciasChannelId forKey:@"channel"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/order/queryUnPayedUserOrder"];
    
    [request GET:@"order/queryUnPayedUserOrder"
      parameters:newParams
     resultClass:[OrderListData class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 success(data);
             }
         }
         failure:failure];
}

//MARK: 已完成订单列表
- (void)requestOrderCompleteParams:(NSDictionary *_Nullable)params
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
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/order/queryTradeSuccessUserOrder"];
    
    [request GET:@"order/queryTradeSuccessUserOrder"
      parameters:newParams
     resultClass:[OrderListData class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
//             DLog(@"%@",data);
//             DLog(@"%@",respomsObject);
             
             if (success) {
//                 NSDictionary *orderInfo = [respomsObject objectForKey:@"data"];
//                 NSArray *dataArr = [orderInfo objectForKey:@"records"];
                 success(data);
             }
         }
         failure:failure];
}

//MARK: 已取消订单列表
- (void)requestOrderCancelParams:(NSDictionary *_Nullable)params
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
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/order/queryCancelUserOrder"];
    
    [request GET:@"order/queryCancelUserOrder"
      parameters:newParams
     resultClass:[OrderListData class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
//             DLog(@"%@",data);
//             DLog(@"%@",respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
}

//订单享受会员卡折扣接口
- (void)requestOrderVipCardDiscountParams:(NSDictionary *_Nullable)params
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
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/order/cardDiscountQuery"];
    
    [request GET:@"order/cardDiscountQuery"
       parameters:newParams
      resultClass:nil
          success:^(id _Nullable data, id _Nullable respomsObject) {
              
              if (success) {
                  success(respomsObject);
              }
          }
          failure:failure];
}

//会员卡余额接口
- (void)requestOrderVipCardBalanceParams:(NSDictionary *_Nullable)params
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
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/order/queryCardDetail"];
    
    [request GET:@"order/queryCardDetail"
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];

}

//卖品信息传给订单接口
- (void)requestOrderGoodsCouponsParams:(NSDictionary *_Nullable)params
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

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/saleCoupons"];
    
    [request GET:@"saleCoupons"
      parameters:newParams
     resultClass:[OrderDetailOfMovie class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];

}

//MARK: 订单确认接口 订单详情
- (void)requestConfirmOrderDetailParams:(NSDictionary *_Nullable)params
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
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/order/queryOrderDetail"];
    
    [request GET:@"order/queryOrderDetail"
      parameters:newParams
     resultClass:[OrderListRecord class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(data);
             }
         }
         failure:failure];
}



//MARK: 首页未领取影片的订单
- (void)requestHomeOrderParams:(NSDictionary *_Nullable)params
                       success:(nullable void (^)(NSDictionary *_Nullable data))success
                       failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPOrderBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:@"/cias-order-web/order/getNearestOrder"];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPOrderBaseURL, @"order/getNearestOrder", newParams);
    
    [request GET:@"order/getNearestOrder"
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"homeOrder信息：%@", respomsObject);
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];
}

@end
