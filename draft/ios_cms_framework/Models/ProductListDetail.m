//
//  ProductListDetail.m
//  CIASMovie
//
//  Created by cias on 2017/3/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "ProductListDetail.h"
#import "Product.h"

@implementation ProductListDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *) listJSONTransformer
{
    return  [MTLJSONAdapter arrayTransformerWithModelClass:[Product class]];
}

@end
