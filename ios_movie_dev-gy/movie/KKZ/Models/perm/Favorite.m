//
//  Match.m
//  Aimeili
//
//  Created by zhang da on 12-8-16.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "Favorite.h"
#import "MemContainer.h"

@implementation Favorite

@dynamic favoriteId;
@dynamic favoriteType;
@dynamic isMyFav;

@dynamic movieId;
@dynamic movieName;
@dynamic userId;

@dynamic movieImg;
@dynamic soundUrl;
@dynamic soundAttitude;
@dynamic soundLength;

@dynamic movieScore;

@dynamic kotaId;

@dynamic commentType;
@dynamic content;

@dynamic createTime;
@dynamic publishTime;
@dynamic ticketTime;

+ (NSString *)primaryKey {
    return @"movieId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"movieName": @"filmName",
                 @"movieImg": @"posterPath",
                 @"soundUrl": @"attachPath",
                 @"movieScore": @"point",
                 @"soundAttitude": @"attitude",
                 @"soundLength": @"attachLength",
                 @"isMyFav": @"status",
                 @"userId": @"user_id",
                 @"thumbPathSmall": @"pathSquare",
                 @"thumbPath": @"pathVerticalS",
                 @"posterPath": @"pathHorizonB",
                 @"createTime" : @"favoriteTime",
                 @"ticketTime" : @"featureTime",
                 } retain];
    }
    return map;
}

+ (NSDictionary *)formatMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"createTime": @"yyyy-MM-dd HH:mm:ss",
                 @"publishTime": @"yyyy-MM-dd",
                 @"ticketTime": @"yyyy-MM-dd HH:mm:ss",
                 } retain];
    }
    return map;
}

+ (Favorite *)getFavoriteWithId:(unsigned int)movieId {
    return [[MemContainer me] getObject:[Favorite class]
                                 filter:[Predicate predictForKey: @"movieId" compare:Equal value:@(movieId)], nil];
}

@end
