//
//  PassbookTask.h
//  KoMovie
//
//  Created by KKZ on 15/8/18.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "NetworkTask.h"

@interface PassbookTask : NetworkTask
@property(nonatomic, strong) NSString *order_id;
/**
 * Passbook接口。需要调查是否可用
 *
 * @param order_id <#order_id description#>
 * @param block    <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initPassbookDataWithOrderId:(NSString *)order_id
                         finished:(FinishDownLoadBlock)block;
@end
