//
//  OrderRequest.m
//  KoMovie
//
//  Created by Albert on 10/10/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "OrderRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "CacheEngine.h"
#import "CommentOrder.h"

#define kCountPerPage 10

@implementation OrderRequest

- (void) requestOrderListAt:(NSInteger) page
                    success:(nullable void (^)(NSArray *_Nullable orders, BOOL hasMore))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [dicParams setValue:@"order_Query" forKey:@"action"];
    [dicParams setValue:@0 forKey:@"order_type"];
    [dicParams setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dicParams setValue:@(kCountPerPage) forKey:@"count"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"orders":[Order class]}
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             if (success) {
                 
                 NSInteger total = [[respomsObject objectForKey:@"total"] integerValue];
                 NSArray *orders = data[@"orders"];
                 success(orders, kCountPerPage*page < total);
                 
             }
         }
         failure:failure];

}


/**
 请求订单详情

 @param orderID 订单ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestOrderDetail:(NSString * _Nonnull) orderID
                    success:(nullable void (^)(Order *_Nullable order))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [dicParams setValue:@"order_Query" forKey:@"action"];
    [dicParams setValue:orderID forKey:@"order_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"orders":[Order class]}
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 NSArray *orders = [data objectForKey:@"orders"];
                 success(orders.firstObject);
                 
             }
         }
         failure:failure];

}


/**
 查询用户订单手机号
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestOrderMobile:(nullable void (^)(NSString *_Nullable mobile))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [dicParams setValue:@"user_Mobile" forKey:@"action"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:nil
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 NSString *mobile = [respomsObject objectForKey:@"mobile"];
                 success(mobile);
                 
             }
         }
         failure:failure];
}

/**
 生成影票订单

 @param mobile      手机号
 @param seatNO      座位号
 @param seatInfo    座位信息
 @param planID      排期ID
 @param activityID  活动ID
 @param callbackURL 回调地址
 @param success     成功回调
 @param failure     失败回调  oldOrder: 上个未完成订单
 */
- (void) addTicketOrder:(NSString *_Nullable)mobile
                 seatNO:(NSString *_Nonnull)seatNO
               seatInfo:(NSString *_Nonnull)seatInfo
                 planID:(NSNumber *_Nonnull)planID
             activityID:(NSNumber *_Nullable)activityID
                success:(nullable void (^)(Order *_Nullable order))success
                failure:(nullable void (^)(NSError *_Nullable err, Order *_Nullable oldOrder))failure;
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [dicParams setValue:@"order_Add" forKey:@"action"];
    [dicParams setValue:mobile forKey:@"mobile"];
    [dicParams setValue:seatNO forKey:@"seat_no"];
    [dicParams setValue:seatInfo forKey:@"seat_info"];
    [dicParams setValue:planID forKey:@"plan_id"];
    [dicParams setValue:activityID forKey:@"activity_id"];
    [dicParams setValue:@12 forKey:@"pay_method"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request POST:kKSSPServer
       parameters:newParams
     resultKeyMap:@{@"order":[Order class]}
          success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 success([data objectForKey:@"order"]);
                 
             }
         }
         failure:^(NSError * _Nullable err) {
             
             NSDictionary *responseDic = [err.userInfo objectForKey:KKZRequestErrorResponse];
             NSNumber *code = [responseDic objectForKey:@"errorCode"];
             Order *order = nil;
             if (code.integerValue == 806) {
                 //有未完成订单
                 NSDictionary *responseDic = [err.userInfo objectForKey:KKZRequestErrorResponse];
                 NSError *err = nil;
                 order = [MTLJSONAdapter modelOfClass:[Order class] fromJSONDictionary:[responseDic objectForKey:@"unpaid"] error:&err];
             }
             
             if (failure) {
                 failure(err, order);
             }
         }];
}


/**
 删除订单

 @param orderID 订单ID
 @param success     成功回调
 @param failure     失败回调
 */
- (void) deleteOrder:(NSString *_Nonnull)orderID
             success:(nullable void (^)())success
             failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [dicParams setValue:@"order_Delete" forKey:@"action"];
    [dicParams setValue:orderID forKey:@"order_id"];

    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:nil
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             
             [[CacheEngine sharedCacheEngine] deleteCacheIdLike:@"order_Query"];
             
             if (success) {
                 success();
             }
         }
         failure:failure];

}
/**
 查询待评价订单
 
 @param page 页码
 @param success     成功回调
 @param failure     失败回调
 */
- (void) requestOrderComment:(NSInteger) page
                     success:(nullable void (^)(NSArray *_Nullable orderComments, BOOL hasMore))success
                     failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [dicParams setValue:@"comment_Order" forKey:@"action"];
    [dicParams setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dicParams setValue:@20 forKey:@"count"];//固定20
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"orders":[CommentOrder class]}
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 NSArray *orders = [data objectForKey:@"orders"];
                 NSInteger total = [[respomsObject objectForKey:@"total"] integerValue];
                 success(orders, total > orders.count);
                 
             }
         }
         failure:failure];

}
/**
 查询未观影提醒
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestOrderRemind:(nullable void (^)(Order *_Nullable order))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [dicParams setValue:@"order_Remind" forKey:@"action"];
    [dicParams setValue:@0 forKey:@"order_type"];
    [dicParams setValue:@(kCountPerPage) forKey:@"count"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"order":[Order class]}
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             if (success) {
                 Order *order = data[@"order"];
                 success(order.orderId ? order : nil);
             }
         }
         failure:failure];

}


@end
