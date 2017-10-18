//
//  CardRule.h
//  CIASMovie
//
//  Created by avatar on 2017/3/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CardRule : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *allowConsumeType;
@property (nonatomic, copy)NSNumber *everyDayDiscountNum;
@property (nonatomic, copy)NSNumber *everyMonthDiscountNum;
@property (nonatomic, copy)NSNumber *everyPlanDiscountNum;
@property (nonatomic, copy)NSNumber *everyWeekDiscountNum;
@property (nonatomic, copy)NSNumber *maxAddMoney;
@property (nonatomic, copy)NSNumber *minAddMoney;

@end
