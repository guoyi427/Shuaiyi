//
//  SimplePlayerVideo.m
//  KoMovie
//
//  Created by KKZ on 15/10/14.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "SimplePlayerVideo.h"
#import "MemContainer.h"

@implementation SimplePlayerVideo


@dynamic videoId;
@dynamic live;
@dynamic recordId;
@dynamic videoFps;
@dynamic videoMode;
@dynamic videoPath;
@dynamic videoQuality;
@dynamic videoType;
@dynamic videoLength;
@dynamic videoName;




+ (NSString *)primaryKey {
    return @"videoId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"videoId": @"id",
                 } retain];
    }
    return map;
}

+ (SimplePlayerVideo *)getSimplePlayerVideoWithId:(NSString *)videoId
{
    return [[MemContainer me] getObject:[SimplePlayerVideo class]
                                 filter:[Predicate predictForKey:@"id" compare:Equal value:videoId], nil];
    
}

@end
