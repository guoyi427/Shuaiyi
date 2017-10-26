//
//  SingleCenterModel.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/21.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "SingleCenterModel.h"

@implementation SingleCenterModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *) isLastJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

@end
