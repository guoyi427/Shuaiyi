//
//  CardTypeDetail.m
//  CIASMovie
//
//  Created by avatar on 2017/3/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CardTypeDetail.h"
#import "CardCinema.h"
#import "Cinema.h"

@implementation CardTypeDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dict = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    NSMutableDictionary *dictM = [dict mutableCopy];
    [dictM setObject:@"id" forKey:@"cardId"];
    return dictM;
}


+ (NSValueTransformer *) cinemasJSONTransformer
{
    return  [MTLJSONAdapter arrayTransformerWithModelClass:[CardCinema class]];
}

@end
