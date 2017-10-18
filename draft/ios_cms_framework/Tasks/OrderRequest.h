//
//  OrderRequest.h
//  CIASMovie
//
//  Created by cias on 2017/1/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OrderListRecord;
@interface OrderRequest : NSObject
//下单接口
- (void)requestOrderAddParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(NSDictionary *_Nullable data))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;
//下单后订单信息获取接口
- (void)requestGetOrderInfoParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSDictionary *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure;
//支付中接口，进入网关
- (void)requestPayOrderParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(NSDictionary *_Nullable data))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;
//调用支付宝等支付方式
- (void)requestGoPayOrderParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(NSDictionary *_Nullable data))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;
//出票接口
- (void)requestOutTicketInfoParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(NSDictionary *_Nullable data))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;
//MARK: 取消订单
- (void)requestCancelOrderParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(NSDictionary *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failur;
//订单详情
- (void)requestOrderDetailParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(NSDictionary *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure;

//影票订单详情
- (void)requestOrderDetailFromListParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(NSDictionary *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure;

//开卡充值订单详情
- (void)requestCardOrderDetailFromListParams:(NSDictionary *_Nullable)params
                                 success:(nullable void (^)(NSDictionary *_Nullable data))success
                                 failure:(nullable void (^)(NSError *_Nullable err))failure;

- (void)requestOrderUnpayParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSDictionary *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure;

- (void)requestOrderCompleteParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSDictionary *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure;

- (void)requestOrderCancelParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSDictionary *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure;

//订单享受会员卡折扣接口
- (void)requestOrderVipCardDiscountParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSDictionary *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure;
//会员卡余额接口
- (void)requestOrderVipCardBalanceParams:(NSDictionary *_Nullable)params
                                  success:(nullable void (^)(NSDictionary *_Nullable data))success
                                  failure:(nullable void (^)(NSError *_Nullable err))failure;
//卖品信息传给订单接口
- (void)requestOrderGoodsCouponsParams:(NSDictionary *_Nullable)params
                                  success:(nullable void (^)(NSDictionary *_Nullable data))success
                                  failure:(nullable void (^)(NSError *_Nullable err))failure;
//MARK: 订单确认接口 订单详情
- (void)requestConfirmOrderDetailParams:(NSDictionary *_Nullable)params
                                success:(nullable void (^)(NSDictionary *_Nullable data))success
                                failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK: 首页未领取影片的订单
- (void)requestHomeOrderParams:(NSDictionary *_Nullable)params
                                success:(nullable void (^)(NSDictionary *_Nullable data))success
                                failure:(nullable void (^)(NSError *_Nullable err))failure;


@end
