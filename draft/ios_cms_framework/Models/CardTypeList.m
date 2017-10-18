//
//  CardTypeList.m
//  CIASMovie
//
//  Created by avatar on 2017/3/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CardTypeList.h"
#import "CardTypeDetail.h"
@implementation CardTypeList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *) rowsJSONTransformer
{
    return  [MTLJSONAdapter arrayTransformerWithModelClass:[CardTypeDetail class]];
}

@end
