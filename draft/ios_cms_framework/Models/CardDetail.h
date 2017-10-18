//
//  CardDetail.h
//  CIASMovie
//
//  Created by avatar on 2017/3/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "CardRule.h"

@interface CardDetail : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSNumber *balance;
@property (nonatomic, copy)NSString *cardStatus;
@property (nonatomic, strong) CardRule * cardRule;
@property (nonatomic, copy)NSString *expiredDate;
@property (nonatomic, copy)NSString *idNum;
@property (nonatomic, copy)NSString *levelCode;
@property (nonatomic, copy)NSString *levelName;
@property (nonatomic, copy)NSString *mobilePhone;
@property (nonatomic, copy)NSString *score;
@property (nonatomic, copy)NSString *userName;


@end
