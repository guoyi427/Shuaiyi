//
//  OrderDetailOfMovie.m
//  CIASMovie
//
//  Created by avatar on 2017/1/22.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderDetailOfMovie.h"

@implementation OrderDetailOfMovie

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)discountJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[OrderDiscount class]];
}

+ (NSValueTransformer *)orderMainJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[OrderMain class]];
}

+ (NSValueTransformer *)orderTicketJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[OrderTicket class]];
}

+ (NSValueTransformer *)paymentJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[OrderPayment class]];
}

+ (NSValueTransformer *)orderDetailGoodsListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OrderProduct class]];
}


@end
