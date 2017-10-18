//
//  City.m
//  CIASMovie
//
//  Created by hqlgree2 on 29/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import "City.h"
#import "NSStringExtra.h"

@implementation City
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

//NSNumber转NSString
+ (NSValueTransformer *)cityidJSONTransformer {
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

- (NSString *)nameFirst {
    if (!_nameFirst) {
        @synchronized([City class]) {
            if (!_nameFirst) {
                _nameFirst = [[self.pinyin substringToIndex:1] uppercaseString];
            }
        }
    }
    return _nameFirst;
}




@end
