//
//  CardCinema.h
//  CIASMovie
//
//  Created by avatar on 2017/3/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CardCinema : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSNumber *cardProductId;
@property (nonatomic, copy)NSNumber *cinemaId;
@property (nonatomic, copy)NSString *cinemaName;
@property (nonatomic, copy)NSString *cinemaAddress;
@property (nonatomic, copy)NSNumber *cityId;
@property (nonatomic, copy)NSString *cityName;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSNumber *cardCinemaId;
@property (nonatomic, copy)NSString *note;
@property (nonatomic, copy)NSNumber *supportStatus;
@property (nonatomic, copy)NSNumber *tenantId;
@property (nonatomic, copy)NSString *timestamp;


@end
