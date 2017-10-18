//
//  OrderListData.m
//  CIASMovie
//
//  Created by avatar on 2017/1/22.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderListData.h"
#import "OrderListRecord.h"

@implementation OrderListData

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)recordsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OrderListRecord class]];
}

@end
