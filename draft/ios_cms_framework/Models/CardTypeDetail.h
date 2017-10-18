//
//  CardTypeDetail.h
//  CIASMovie
//
//  Created by avatar on 2017/3/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CardTypeDetail : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *beginTime;
@property (nonatomic, copy)NSString *cardLevel;
@property (nonatomic, copy)NSString *cardLevelName;
@property (nonatomic, copy)NSString *cardNotice;
@property (nonatomic, copy)NSString *cardPrivilege;
@property (nonatomic, copy)NSString *cardType;//
@property (nonatomic, copy)NSString *cardTypeName;
@property (nonatomic, copy)NSNumber *cinemaId;
@property (nonatomic, copy)NSString *cinemaName;
@property (nonatomic, copy)NSArray  *cinemas;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *discountDesc;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *expireDate;

@property (nonatomic, copy)NSNumber *expireType;
@property (nonatomic, copy)NSString *expireValue;
@property (nonatomic, copy)NSNumber *cardId;//id
@property (nonatomic, copy)NSString *imagefile;//
@property (nonatomic, copy)NSString *logo;
@property (nonatomic, copy)NSNumber *maxAddMoney;//
@property (nonatomic, copy)NSNumber *minAddMoney;//
@property (nonatomic, copy)NSString *name;//
@property (nonatomic, copy)NSString *note;
@property (nonatomic, copy)NSString *protocol;
//@property (nonatomic, copy)NSString *score;//
@property (nonatomic, copy)NSNumber *rechargeMoney;
@property (nonatomic, copy)NSString *relationId;
@property (nonatomic, copy)NSNumber *saleMoney;
@property (nonatomic, copy)NSNumber *serviceMoney;
@property (nonatomic, copy)NSNumber *status;

@property (nonatomic, copy)NSString *stock;
@property (nonatomic, copy)NSNumber *synStatus;
@property (nonatomic, copy)NSNumber *tenantId;
@property (nonatomic, copy)NSString *timestamp;

@end
