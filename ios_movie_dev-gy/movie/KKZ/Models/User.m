//
//  User.m
//  KoMovie
//
//  Created by Albert on 27/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "User.h"

@implementation User
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *) detailJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[UserDetail class]];
}


/**
 类型转换 有些接口 vipAccount为String

 @return NSValueTransformer
 */
+ (NSValueTransformer *) vipAccountJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            NSString *str = value;
            NSNumberFormatter *numf = [[NSNumberFormatter alloc] init];
            NSNumber *num = [numf numberFromString:str];
            return num;
        }
        
        return value;
    }];
}

@end
