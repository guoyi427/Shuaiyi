//
//  CouponTask.h
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "NetworkTask.h"

@interface CouponTask : NetworkTask {
}

@property(nonatomic, strong) NSString *cardType;
@property(nonatomic, strong) NSString *cinemaId;
@property(nonatomic, strong) NSString *activityId;

/**
 * 查询充值的会员卡的价格。
 *
 * @param cardNo <#cardNo description#>
 * @param block  <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initVipCardCheck:(NSString *)cardNo finished:(FinishDownLoadBlock)block;

@end
