//
//  Coupon.h
//  CIASMovie
//
//  Created by cias on 2017/3/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Coupon : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *batchCode;
@property (nonatomic, strong)NSNumber *batchId;
@property (nonatomic, copy)NSString *couponName;
@property (nonatomic, copy)NSString *couponNums;
@property (nonatomic, strong)NSNumber *couponType;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, strong)NSNumber *expireDay;
@property (nonatomic, copy)NSString *flowNum;
@property (nonatomic, strong)NSNumber *couponId;
@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString *rule;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, strong)NSNumber *status;
@property (nonatomic, strong)NSNumber *tenantId;

@end
