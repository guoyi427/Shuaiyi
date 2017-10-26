//
//  City.m
//  KKZ
//
//  Created by alfaromeo on 11-10-27.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import "City.h"
#import "NSStringExtra.h"
#import "MemContainer.h"


@implementation City


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

- (NSString *)nameFirst {
    if (!_nameFirst) {
        @synchronized([City class]) {
            if (!_nameFirst) {
                _nameFirst = [[self.cityPinYin substringToIndex:1] uppercaseString];
            }
        }
    }
    return _nameFirst;
}


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
