//
//  VipCardRequest.h
//  CIASMovie
//
//  Created by cias on 2017/2/24.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VipCardListDetail.h"
#import "CardListDetail.h"

@interface VipCardRequest : NSObject
//MARK:储值卡列表
- (void)requestStoreVipCardListParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(NSDictionary *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure;
//MARK:折扣卡列表（返回包含通用卡）
- (void)requestDiscountVipCardListParams:(NSDictionary *_Nullable)params
                                 success:(nullable void (^)(NSDictionary *_Nullable data))success
                                 failure:(nullable void (^)(NSError *_Nullable err))failure;
//MARK:会员卡列表
- (void)requestVipCardListParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(VipCardListDetail *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:检查会员卡是否被绑定
- (void)requestVipCardIsBindedParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(NSDictionary *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:会员卡查询优惠cardDiscountQuery
- (void)requestVipCardDiscountQueryParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(NSDictionary *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure;


//MARK:获取会员卡预留手机号
- (void)requestVipCardPhoneNumParams:(NSDictionary *_Nullable)params
                             success:(nullable void (^)(NSDictionary *_Nullable data))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:绑定会员卡
- (void)requestVipCardBindingParams:(NSDictionary *_Nullable)params
                             success:(nullable void (^)(NSDictionary *_Nullable data))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:会员卡支付接口
- (void)requestPayOrderWithVipCardParams:(NSDictionary *_Nullable)params
                                 success:(nullable void (^)(NSDictionary *_Nullable data))success
                                 failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:会员卡验证码接口
- (void)requestPayOrderCodeWithVipCardParams:(NSDictionary *_Nullable)params
                                 success:(nullable void (^)(NSDictionary *_Nullable data))success
                                 failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:会员卡充值套餐接口
- (void)requestVipCardRechargeValueParams:(NSDictionary *_Nullable)params
                                     success:(nullable void (^)(NSDictionary *_Nullable data))success
                                     failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:会员卡充值订单接口
- (void)requestVipCardRechargeOrderParams:(NSDictionary *_Nullable)params
                                  success:(nullable void (^)(NSDictionary *_Nullable data))success
                                  failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:会员卡开卡类型列表
- (void)requestVipCardTypeListParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(NSDictionary *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:会员卡开卡详情
- (void)requestVipCardTypeDetailParams:(NSDictionary *_Nullable)params
                             success:(nullable void (^)(NSDictionary *_Nullable data))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure;


//MARK:会员卡开卡订单接口
- (void)requestVipCardOpenOrderParams:(NSDictionary *_Nullable)params
                                  success:(nullable void (^)(NSDictionary *_Nullable data))success
                                  failure:(nullable void (^)(NSError *_Nullable err))failure;


//MARK:会员卡详情
- (void)requestVipCardDetailParams:(NSDictionary *_Nullable)params
                               success:(nullable void (^)(CardListDetail *_Nullable data))success
                               failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:会员卡赠送优惠券
- (void)requestVipCardCouponParams:(NSDictionary *_Nullable)params
                           success:(nullable void (^)(NSDictionary *_Nullable data))success
                           failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:会员卡开卡发送验证码
- (void)requestOpenCardCodeParams:(NSDictionary *_Nullable)params
                           success:(nullable void (^)(NSDictionary *_Nullable data))success
                           failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:会员卡开卡协议
- (void)requestOpenCardProtocolParams:(NSDictionary *_Nullable)params
                          success:(nullable void (^)(NSDictionary *_Nullable data))success
                          failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK:会员卡解绑
- (void)requestUnbindCardParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(NSDictionary *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure;



//会员卡开卡提示列表
- (void)requestCanOpenCardListParams:(NSDictionary *_Nullable)params
                             success:(nullable void (^)(NSDictionary *_Nullable data))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure;

@end
