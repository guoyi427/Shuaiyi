//
//  AppTemplate.m
//  CIASMovie
//
//  Created by cias on 2017/2/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "AppTemplate.h"

@implementation AppTemplate

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
//    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    return @{
             @"AppTemplateNum":@"template",
             @"all":@"all",
             @"detail":@"detail",
             @"home":@"home",
             @"list":@"list",
             @"tenantId":@"tenantId",
             @"type":@"type",

             };
}

+ (NSValueTransformer *)homeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[HomeConfig class]];
}


@end
