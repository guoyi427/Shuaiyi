//
//  Plan.m
//  CIASMovie
//
//  Created by hqlgree2 on 29/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import "Plan.h"
#import "Movie.h"

@implementation Plan

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *) filmInfoJSONTransformer
{
    return  [MTLJSONAdapter arrayTransformerWithModelClass:[Movie class]];
}

//NSNumber转NSString
+ (NSValueTransformer *)cinemaIdJSONTransformer {
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
+ (NSValueTransformer *)screenIdJSONTransformer {
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
+ (NSValueTransformer *)filmIdJSONTransformer {
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

//+ (NSValueTransformer *)sessionIdJSONTransformer {
//    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        if ([value isKindOfClass:[NSString class]]) {
//            return value;
//        } else if ([value isKindOfClass:[NSNumber class]]) {
//            return [value stringValue];
//        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] || !value) {
//#if DEBUG
//            NSAssert(value != nil, @"Type error");
//#endif
//            return [NSNull null];
//        } else {
//            return [value stringValue];
//        }
//    }];
//}


@end
