//
//  Order.m
//  CIASMovie
//
//  Created by cias on 2017/1/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "Order.h"
#import "OrderTicket.h"

@implementation Order

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)orderTicketJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[OrderTicket class]];
}

+ (NSValueTransformer *)orderMainJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[OrderMain class]];
}

+ (NSValueTransformer *)discountJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Activity class]];
}

@end
