//
//  CardDetail.m
//  CIASMovie
//
//  Created by avatar on 2017/3/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CardDetail.h"

@implementation CardDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *) cardRuleJSONTransformer
{
    return  [MTLJSONAdapter dictionaryTransformerWithModelClass:[CardRule class]];
}

@end
