//
//  KotaFilm.m
//  KoMovie
//
//  Created by zhoukai on 3/20/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "KotaFilmNew.h"


@implementation KotaFilmNew

@dynamic index;
@dynamic posterPath0;
@dynamic filmId;
@dynamic filmName;
@dynamic isOK;

+ (NSString *)primaryKey {
    return @"filmId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"posterPath0": @"posterPath",
                 } retain];
    }
    return map;
}

@end
