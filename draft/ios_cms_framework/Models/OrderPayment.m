//
//  OrderPayment.m
//  CIASMovie
//
//  Created by avatar on 2017/3/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderPayment.h"

@implementation OrderPayment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dict = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    NSMutableDictionary *dictM = [dict mutableCopy];
    [dictM setObject:@"operator" forKey:@"orderOperator"];
    return dictM;
}

@end
