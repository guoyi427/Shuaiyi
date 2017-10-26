//
//  App.m
//  KoMovie
//
//  Created by XuYang on 12-11-28.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "App.h"
#import "MemContainer.h"

@implementation App

@dynamic appId;
@dynamic appName;
@dynamic appImage;
@dynamic appUrl;
@dynamic appIntro;

+ (NSString *)primaryKey {
    return @"appId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"appIntro": @"intro",
                 @"appUrl": @"downloadUrl",

                 } retain];
    }
    return map;
}

+ (App *)getAppWithId:(int)appId {
    return [[MemContainer me] getObject:[App class]
                                 filter:[Predicate predictForKey: @"appId" compare:Equal value:@(appId)], nil];}


@end
