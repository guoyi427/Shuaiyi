//
//  PayTask.h
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "NetworkTask.h"
#import "Ticket.h"
#import <Foundation/Foundation.h>

@interface PayTask : NetworkTask {
  NSString *orderNo;
  PayMethod payType;
  NSString *ecardIds;
  float balance;

  float fee;
}

@property(nonatomic, strong) NSString *ecardIds;
@property(nonatomic, strong) NSString *groupbuyId;
@property(nonatomic, strong) NSString *orderNo;
@property(nonatomic, strong) NSString *accountType;
@property(nonatomic, assign) PayMethod payMethod;
@property(nonatomic, assign) float redMoney;

@property(nonatomic, copy) NSString *callbackUrl;
@property(nonatomic, copy) NSString *notifyUrl;

/**
 * <#Description#>
 *
 * @param eIds       <#eIds description#>
 * @param oNo        <#oNo description#>
 * @param groupbuyId <#groupbuyId description#>
 * @param block      <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initCheckECard:(NSString *)eIds
            forOrder:(NSString *)oNo
            groupbuy:(NSString *)groupbuyId // TODO 参数作废
            finished:(FinishDownLoadBlock)block;

/**
 * 支付订单。
 *
 * @param oNo      <#oNo description#>
 * @param money    <#money description#>
 * @param eIds     <#eIds description#>
 * @param redMoney <#redMoney description#>
 * @param mth      <#mth description#>
 * @param block    <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initPayOrder:(NSString *)oNo
          useMoney:(float)money
            eCards:(NSString *)eIds
      useRedCoupon:(float)redMoney
           payType:(PayMethod)mth
          finished:(FinishDownLoadBlock)block;

/**
 * 查询订单支持的支付方式
 *
 * @param oNo   <#oNo description#>
 * @param block <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initGetPayType:(NSString *)oNo finished:(FinishDownLoadBlock)block;

/**
 * 生成充值订单
 *
 * @param money <#money description#>
 * @param mth   <#mth description#>
 * @param block <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initAddImprestOrder:(float)money
                  payType:(PayMethod)mth
                 finished:(FinishDownLoadBlock)block; //充值

/**
 * 查询订单的兑换券列表
 *
 * @param oNo   <#oNo description#>
 * @param block <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initCouponListforOrder:(NSString *)oNo
                    finished:(FinishDownLoadBlock)block;

/**
 * 绑定兑换券。
 *
 * @param couponsId <#couponsId description#>
 * @param block     <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initBindingCouponforUser:(NSString *)couponsId
                      finished:(FinishDownLoadBlock)block;

/**
 * 支付周边订单。
 *
 * @param order_id     <#order_id description#>
 * @param pay_method   <#pay_method description#>
 * @param callback_url <#callback_url description#>
 * @param notify_url   <#notify_url description#>
 * @param block        <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initEcshopOrder:(NSString *)order_id
            payMethod:(PayMethod)pay_method
          callbackUrl:(NSString *)callback_url
            notifyUrl:(NSString *)notify_url
             finished:(FinishDownLoadBlock)block;

@end
