//
//  Product.m
//  CIASMovie
//
//  Created by cias on 2017/3/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "Product.h"

@implementation Product

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"couponBrief":@"couponBrief",
             @"couponName":@"couponName",
             @"productId":@"id",
             @"couponType":@"couponType",
             @"showPictureUrl":@"showPictureUrl",
             @"saleChannel":@"saleChannel",
             @"saleLimit":@"saleLimit",
             
             };
}


//+ (NSValueTransformer *)showPictureUrlJSONTransformer {
//    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
//}
@end
