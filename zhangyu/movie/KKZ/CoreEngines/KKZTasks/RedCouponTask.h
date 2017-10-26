//
//  RedCouponTask.h
//  KoMovie
//
//  Created by gree2 on 17/10/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "NetworkTask.h"

@interface RedCouponTask : NetworkTask

@property(nonatomic, assign) float orderBalance;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, strong) NSString *orderNo;

/**
 * 查询订单可用的红包
 *
 * @param orderBalance <#orderBalance description#>
 * @param orderNo      <#orderNo description#>
 * @param block        <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initUserRedCouponFee:(float)orderBalance
                andOrderNo:(NSString *)orderNo
                  finished:(FinishDownLoadBlock)block;

/**
 * 查询我的红包列表。
 *
 * @param page  <#page description#>
 * @param block <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initUserRedCouponFeeListWithPage:(NSInteger)page
                              finished:(FinishDownLoadBlock)block;

/**
 * 查询订单的总金额。可以使用 initUserRedCouponFeeListWithPage
 * 接口代替，initUserRedCouponFeeListWithPage 接口中返回了总额。
 *
 * @param block <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initUserRedAccountsUserfinished:(FinishDownLoadBlock)block;

@end
