//
//  City.m
//  CIASMovie
//
//  Created by hqlgree2 on 29/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import "City.h"
#import "NSStringExtra.h"
#import "MemContainer.h"

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

//  ---------------- kkz
+ (City *)getCityWithId:(int)cityId {
    City *city = [[MemContainer me] getObject:[City class]
                                       filter:[Predicate predictForKey:@"cityId" compare:Equal value:@(cityId)], nil];
    
    DLog(@"cityId%@$$$$$$$$$$$$+++++++++++++++,cityName%@",city.cityId, city.cityName);
    
    return city;
    
}

+ (City *)getCityWithName:(NSString *)cityName {
    
    City *city = [[MemContainer me] getObject:[City class]
                                       filter:[Predicate predictForKey:@"cityName" compare:FuzzyMatch value:cityName], nil];
    DLog(@"cityName%@+++++++++++++++$$$$$$$$$$$$,cityId%@",city.cityName,city.cityId);
    
    if (city == nil || [city isEqual:nil]) {
        city = [[MemContainer me] getObject:[City class]
                                     filter:[Predicate predictForKey:@"cityPinYin" compare:FuzzyMatch value:cityName], nil];
    }
    
    return city;
}


@end
