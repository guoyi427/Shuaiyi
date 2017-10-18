//
//  Coupon.m
//  CIASMovie
//
//  Created by cias on 2017/3/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "Coupon.h"

@implementation Coupon

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dict = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    NSMutableDictionary *dictM = [dict mutableCopy];
    [dictM setObject:@"id" forKey:@"couponId"];
    return dictM;
}


@end
