//
//  OrderListOfMovie.h
//  CIASMovie
//
//  Created by avatar on 2017/1/22.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OrderListOfMovie : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *date; //
@property (nonatomic, copy) NSString *pkOrderDetail; //
@property (nonatomic, copy) NSString *orderDetailCode; //
@property (nonatomic, copy) NSString *fkOrderCode; //
@property (nonatomic, copy) NSString *originalPrice; //
@property (nonatomic, copy) NSString *discountMoney; //
@property (nonatomic, copy) NSString *receiveMoney; //
@property (nonatomic, copy) NSString *count; //
@property (nonatomic, copy) NSString *suitId; //
@property (nonatomic, copy) NSString *goodsSkuCode; //
@property (nonatomic, copy) NSString *goodsName; //
@property (nonatomic, copy) NSString *goodsThumbnailUrl; //
@property (nonatomic, assign) long   goodsType; //
@property (nonatomic, copy) NSString *unitPrice; //
@property (nonatomic, strong)NSNumber *createTime; //

@property (nonatomic, copy) NSString *remark; //
@property (nonatomic, copy) NSString *cinemaId; //
@property (nonatomic, copy) NSString *cinemaName; //
@property (nonatomic, strong)NSNumber *planBeginTime; //


@end
