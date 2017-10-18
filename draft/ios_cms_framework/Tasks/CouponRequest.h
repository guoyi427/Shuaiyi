//
//  CouponRequest.h
//  CIASMovie
//
//  Created by cias on 2017/3/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coupon.h"

@interface CouponRequest : NSObject

//我绑定的优惠券列表
- (void)requestMyCouponListParams:(NSDictionary *_Nullable)params
                          success:(nullable void (^)(NSArray <Coupon *> *_Nullable data))success
                          failure:(nullable void (^)(NSError *_Nullable err))failure;

//使用此优惠券
- (void)requestCheckCouponParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(NSDictionary *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure;

//绑定优惠券
- (void)bindCouponWithOrderCode:(NSString *_Nullable)orderCode
             cardCouponsRawCode:(NSString *_Nullable)cardCouponsRawCode
                        success:(nullable void (^)(Coupon *_Nullable newCoupon))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;

@end
