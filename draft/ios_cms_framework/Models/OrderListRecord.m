//
//  OrderListRecord.m
//  CIASMovie
//
//  Created by avatar on 2017/1/22.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderListRecord.h"
#import "OrderListOfMovie.h"

@implementation OrderListRecord

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}


+ (NSValueTransformer *)orderDetailListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OrderListOfMovie class]];
}

+ (NSValueTransformer *)orderTicketJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[OrderTicket class]];
}

@end
