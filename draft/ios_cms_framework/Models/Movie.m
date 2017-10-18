//
//  Movie.m
//  CIASMovie
//
//  Created by cias on 2016/12/19.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "Movie.h"


@implementation Movie


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *dict = [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
    NSMutableDictionary *dictM = [dict mutableCopy];
    [dictM setObject:@"id" forKey:@"movieId"];
    return dictM;
}

//NSNumber转NSString
+ (NSValueTransformer *)movieIdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        } else if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] || !value) {
#if DEBUG
            NSAssert(value != nil, @"Type error");
#endif
            return [NSNull null];
        } else {
            return [value stringValue];
        }
    }];
}

//NSNumber转NSString
+ (NSValueTransformer *)publishDateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        } else if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] || !value) {
#if DEBUG
//            NSAssert(value != nil, @"Type error");
#endif
            return [NSNull null];
        } else {
            return [value stringValue];
        }
    }];
}




@end
