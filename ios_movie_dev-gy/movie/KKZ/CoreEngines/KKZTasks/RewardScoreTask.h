//
//  RewardScoreTask.h
//  KoMovie
//
//  Created by KKZ on 16/1/12.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "NetworkTask.h"

@interface RewardScoreTask : NetworkTask
@property(nonatomic, strong) NSString *order_id;

/**
 * 查询订单的积分，出票成功的页面调用。
 *
 * @param order_id <#order_id description#>
 * @param block    <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initRewardScoreDataWithOrderId:(NSString *)order_id
                            finished:(FinishDownLoadBlock)block;
@end
