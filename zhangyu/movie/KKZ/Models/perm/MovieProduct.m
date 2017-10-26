//
//  MovieProduct.m
//  KoMovie
//
//  Created by XuYang on 13-8-8.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "MovieProduct.h"
#import "MemContainer.h"


@implementation MovieProduct

@dynamic productId;
@dynamic productImg;
@dynamic productName;
@dynamic productIntro;
@dynamic productUrl;
@dynamic hot;
@dynamic movieId;
@dynamic productPrice;
@dynamic isBanner;
@dynamic bannerImage;

+ (NSString *)primaryKey {
    return @"productId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"productImg": @"productImage",
                 @"productUrl": @"productLink",
                 @"productPrice": @"price",
                 } retain];
    }
    return map;
}

+ (MovieProduct *)getProductWithId:(unsigned int)productId{
    return [[MemContainer me] getObject:[MovieProduct class]
                                 filter:[Predicate predictForKey: @"productId" compare:Equal value:@(productId)], nil];
}





@end
