//
//  CardCinemaList.m
//  CIASMovie
//
//  Created by avatar on 2017/3/14.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CardCinemaList.h"
#import "CardCinema.h"

@implementation CardCinemaList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *) rowsJSONTransformer
{
    return  [MTLJSONAdapter arrayTransformerWithModelClass:[CardCinema class]];
}

@end
