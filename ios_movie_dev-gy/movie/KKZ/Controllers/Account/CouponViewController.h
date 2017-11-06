//
//  CouponViewController.h
//  KoMovie
//
//  Created by kokozu on 27/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

typedef enum : NSUInteger {
    /// 优惠券
    CouponType_coupon = 4,
    /// 兑换码
    CouponType_Redeem = 3,
    /// 储值卡
    CouponType_Stored = 1,
} CouponType;

@interface CouponViewController : CommonViewController

@property (nonatomic, assign) CouponType type;

@end
