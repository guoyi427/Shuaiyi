//
//  News.m
//  KoMovie
//
//  Created by gree2 on 19/4/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import "Banner.h"
#import "MemContainer.h"

@implementation Banner


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (Banner *)getBannerWithId:(unsigned int)bannerId
{
    return [[MemContainer me] getObject:[Banner class]
                                 filter:[Predicate predictForKey: @"bannerId" compare:Equal value:@(bannerId)], nil];
}

@end
