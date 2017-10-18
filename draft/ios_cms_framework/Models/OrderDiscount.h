//
//  OrderDiscount.h
//  CIASMovie
//
//  Created by avatar on 2017/3/30.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OrderDiscount : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *activityId;//
@property (nonatomic, copy)NSString *activityName;
@property (nonatomic, copy)NSString *code;
@property (nonatomic, copy)NSNumber *createTime;
@property (nonatomic, copy)NSString *discountMoney;
@property (nonatomic, copy)NSString *fkOrderCode;
@property (nonatomic, copy)NSString *fkOrderDetailCode;
@property (nonatomic, copy)NSString *pkOrderDiscount;
@property (nonatomic, copy)NSString *receiveMoney;
@property (nonatomic, copy)NSString *type;


@end
