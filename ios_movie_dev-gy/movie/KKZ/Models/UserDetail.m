//
//  UserDetail.m
//  KoMovie
//
//  Created by Albert on 26/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserDetail.h"

#import "UserInfo.h"
#include "UserSocoal.h"

@implementation UserDetail
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

+ (Class) classForParsingJSONDictionary:(NSDictionary *)JSONDictionary
{
    if ([JSONDictionary objectForKey:@"userId"] != nil) {
        return [UserInfo class];
    }else{
        return [UserSocoal class];
    }
}

+ (NSValueTransformer *) monthJSONTransformer
{
    return [self stringNumber];
}

+ (NSValueTransformer *) dayJSONTransformer
{
    return [self stringNumber];
}

+ (NSValueTransformer *) sexJSONTransformer
{
    return [self stringNumber];
}

+ (NSValueTransformer *) stringNumber
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            NSString *str = value;
            return [NSNumber numberWithInteger:str.integerValue];
        }
        
        return value;
    }];
}


@end
