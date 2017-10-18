//
//  CardListDetail.m
//  CIASMovie
//
//  Created by avatar on 2017/3/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CardListDetail.h"

@implementation CardListDetail
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dict = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    NSMutableDictionary *dictM = [dict mutableCopy];
    [dictM setObject:@"id" forKey:@"cardOrderId"];
    return dictM;
}


+ (NSValueTransformer *) cardDetailJSONTransformer
{
    return  [MTLJSONAdapter dictionaryTransformerWithModelClass:[CardDetail class]];
}

+ (NSValueTransformer *) productJSONTransformer
{
    return  [MTLJSONAdapter dictionaryTransformerWithModelClass:[CardTypeDetail class]];
}


@end
