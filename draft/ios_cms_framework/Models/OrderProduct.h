//
//  OrderProduct.h
//  CIASMovie
//
//  Created by avatar on 2017/3/20.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OrderProduct : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *cinemaId;
@property (nonatomic, copy)NSString *cinemaName;
@property (nonatomic, copy)NSString *count;//
@property (nonatomic, copy)NSNumber *couponsMakeType;
@property (nonatomic, copy)NSString *couponsType;
@property (nonatomic, copy)NSNumber *createTime;
@property (nonatomic, copy)NSNumber *date;
@property (nonatomic, copy)NSString *discountMoney;
@property (nonatomic, copy)NSString *fkOrderCode;
@property (nonatomic, copy)NSString *goodsCouponsCode;
@property (nonatomic, copy)NSString *goodsName;
@property (nonatomic, copy)NSString *goodsSkuCode;
@property (nonatomic, copy)NSString *goodsThumbnailUrl;
@property (nonatomic, copy)NSNumber *goodsType;
@property (nonatomic, copy)NSString *lockNo;
@property (nonatomic, copy)NSString *orderDetailCode;
@property (nonatomic, copy)NSString *originalPrice;
@property (nonatomic, copy)NSString *pkOrderDetail;
@property (nonatomic, copy)NSNumber *planBeginTime;
@property (nonatomic, copy)NSString *receiveMoney;
@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString *desc;

@property (nonatomic, copy)NSNumber *status;
@property (nonatomic, copy)NSString *suitId;
@property (nonatomic, copy)NSString *unLockCode;
@property (nonatomic, copy)NSString *unitPrice;


@end
