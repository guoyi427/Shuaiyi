//
//  CardListDetail.h
//  CIASMovie
//
//  Created by avatar on 2017/3/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "CardDetail.h"
#import "CardTypeDetail.h"

@interface CardListDetail : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSNumber *businessType;
@property (nonatomic, copy)NSString *businessTypeName;
@property (nonatomic, strong) CardDetail * cardDetail;
@property (nonatomic, copy)NSString *cardNo;
@property (nonatomic, copy)NSString *cardNoView;
@property (nonatomic, copy)NSString *channelId;
@property (nonatomic, copy)NSNumber *cinemaId;
@property (nonatomic, copy)NSNumber *cinemaLineId;
@property (nonatomic, copy)NSString *cinemaLineName;
@property (nonatomic, copy)NSString *cinemaName;
@property (nonatomic, copy)NSNumber *codeType;
@property (nonatomic, copy)NSString *codeTypeName;
@property (nonatomic, copy)NSNumber *createTime;
@property (nonatomic, copy)NSString *expireDate;
@property (nonatomic, copy)NSString *cardOrderId;
@property (nonatomic, copy)NSNumber *memberId;
@property (nonatomic, copy)NSString *mobile;
@property (nonatomic, copy)NSString *note;
@property (nonatomic, copy)NSString *onlineStatus;
@property (nonatomic, strong)CardTypeDetail *product;
@property (nonatomic, copy)NSNumber *productId;
@property (nonatomic, copy)NSString *productLogo;
@property (nonatomic, copy)NSString *targetAccount;
@property (nonatomic, copy)NSString *targetAccountName;
@property (nonatomic, copy)NSNumber *tenantId;
@property (nonatomic, copy)NSNumber *timestamp;
@property (nonatomic, copy)NSNumber *useType;
@property (nonatomic, copy)NSString *useTypeName;


@end
