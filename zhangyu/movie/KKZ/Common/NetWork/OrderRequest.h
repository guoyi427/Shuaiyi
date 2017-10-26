//
//  OrderRequest.h
//  KoMovie
//
//  Created by Albert on 10/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Order.h"

/**
 订单相关
 */
@interface OrderRequest : NSObject

/**
 请求订单列表

 @param page    页码
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestOrderListAt:(NSInteger) page
                    success:(nullable void (^)(NSArray *_Nullable orders, BOOL hasMore))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 请求订单详情
 
 @param orderID 订单ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestOrderDetail:(NSString * _Nonnull) orderID
                    success:(nullable void (^)(Order *_Nullable order))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 查询用户订单手机号
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestOrderMobile:(nullable void (^)(NSString *_Nullable mobile))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 生成影票订单
 
 @param mobile      手机号
 @param seatNO      座位号
 @param seatInfo    座位信息
 @param planID      排期ID
 @param activityID  活动ID
 @param callbackURL 回调地址
 @param success     成功回调
 @param failure     失败回调 oldOrder: 上个未完成订单
 */
- (void) addTicketOrder:(NSString *_Nullable)mobile
                 seatNO:(NSString *_Nonnull)seatNO
               seatInfo:(NSString *_Nonnull)seatInfo
                 planID:(NSNumber *_Nonnull)planID
             activityID:(NSNumber *_Nullable)activityID
                success:(nullable void (^)(Order *_Nullable order))success
                failure:(nullable void (^)(NSError *_Nullable err, Order *_Nullable oldOrder))failure;

/**
 删除订单
 
 @param orderID 订单ID
 @param success     成功回调
 @param failure     失败回调
 */
- (void) deleteOrder:(NSString *_Nonnull)orderID
             success:(nullable void (^)())success
             failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 查询待评价订单

 @param page 页码
 @param success     成功回调
 @param failure     失败回调
 */
- (void) requestOrderComment:(NSInteger) page
                     success:(nullable void (^)(NSArray *_Nullable orderComments, BOOL hasMore))success
                     failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 查询未观影提醒

 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestOrderRemind:(nullable void (^)(Order *_Nullable order))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure;
@end
