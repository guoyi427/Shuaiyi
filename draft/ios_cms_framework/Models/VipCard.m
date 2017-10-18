//
//  VipCard.m
//  CIASMovie
//
//  Created by cias on 2017/2/24.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "VipCard.h"

@implementation VipCard

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *) cardDetailJSONTransformer
{
    return  [MTLJSONAdapter dictionaryTransformerWithModelClass:[CardDetail class]];
}

@end
