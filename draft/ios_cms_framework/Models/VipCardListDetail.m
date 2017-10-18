//
//  VipCardListDetail.m
//  CIASMovie
//
//  Created by cias on 2017/2/24.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "VipCardListDetail.h"
#import "VipCard.h"

@implementation VipCardListDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *) rowsJSONTransformer
{
    return  [MTLJSONAdapter arrayTransformerWithModelClass:[VipCard class]];
}

@end
