//
//  BannerNew.m
//  CIASMovie
//
//  Created by avatar on 2017/7/5.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "BannerNew.h"

#import "MemContainer.h"

@implementation BannerNew

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (BannerNew *)getBannerWithId:(unsigned int)bannerId
{
    return [[MemContainer me] getObject:[BannerNew class]
                                 filter:[Predicate predictForKey: @"bannerId" compare:Equal value:@(bannerId)], nil];
}

- (NSString *)slideImg {
    return self.imagePath;
}

- (NSString *)slideUrl {
    return self.targetUrl;
}

- (NSString *)slideTitle {
    return self.title;
}

@end
