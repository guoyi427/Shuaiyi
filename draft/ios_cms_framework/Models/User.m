//
//  User.m
//  CIASMovie
//
//  Created by avatar on 2017/1/19.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "User.h"

@implementation User
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dict = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    NSMutableDictionary *dictM = [dict mutableCopy];
    [dictM setObject:@"id" forKey:@"userId"];
    return dictM;
}

@end
