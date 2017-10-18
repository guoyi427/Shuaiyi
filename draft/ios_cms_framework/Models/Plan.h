//
//  Plan.h
//  CIASMovie
//
//  Created by hqlgree2 on 29/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Plan : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *cinemaId;
@property (nonatomic, copy)NSString *cinemaName;

@property (nonatomic, copy)NSString *screenId;
@property (nonatomic, copy)NSString *screenName;
@property (nonatomic, copy)NSString *screenImage;
@property (nonatomic, copy)NSString *sessionId;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *filmId;
@property (nonatomic, copy)NSString *isSale;//可售
@property (nonatomic, copy)NSString *isDiscount;//优惠 1 0
@property (nonatomic, copy)NSString *discount;//优惠9.9特价活动
@property (nonatomic, strong)NSArray *filmInfo;
@property (nonatomic, strong)NSArray *sectionInfo;
@property (nonatomic, copy)NSString *sectionId;
@property (nonatomic, strong)NSNumber *lowestPrice;
@property (nonatomic, strong)NSNumber *standardPrice;
@property (nonatomic, strong)NSNumber *marketPrice;
//@property (nonatomic, strong)NSNumber *wx_issale;
//@property (nonatomic, copy)NSString *wx_saleTielt;
//@property (nonatomic, copy)NSString *wx_sessionPic;
@property (nonatomic, copy) NSString *vipName;
@property (nonatomic, strong) NSNumber *vipPrice;

@end
