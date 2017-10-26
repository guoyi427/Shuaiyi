//
//  Coupon.h
//  KKZ
//
//  Created by alfaromeo on 12-2-3.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "Model.h"

//电子兑换券
@interface CheckCoupon : Model

@property (nonatomic, assign) int type;//cardid
@property (nonatomic, retain) NSString * couponId;//cardid
@property (nonatomic, retain) NSNumber * cardCount;
@property (nonatomic, retain) NSString * remainCount;//是否可用
@property (nonatomic, retain) NSNumber * disable;
@property (nonatomic, retain) NSString * description;//描述
@property (nonatomic, retain) NSString * cardName;
@property (nonatomic, retain) NSString * maskName;//使用的，兑换券名字
@property (nonatomic, retain) NSNumber * cardPrice;

@property (nonatomic, assign) BOOL selected;//兑换券是否被选中

///
@property (nonatomic, retain) NSNumber * vipPrice;
@property (nonatomic, retain) NSString * note; //有效期的文字描述，服务器直接返回
@property (nonatomic, retain) NSString * source;//...兑换券来源
@property (nonatomic, retain) NSString * desc;//描述
@property (nonatomic, retain) NSDate * validDate;//兑换券可使用的截止日期
@property (nonatomic, retain) NSString * expireDate;//兑换券可使用的截止日期
@property (nonatomic, retain) NSString * validCinemas;//...

+ (CheckCoupon *)getCouponWithcouponId:(NSString *)couponId;
- (void)updateDataFromDict:(NSDictionary *)dict;

@end
