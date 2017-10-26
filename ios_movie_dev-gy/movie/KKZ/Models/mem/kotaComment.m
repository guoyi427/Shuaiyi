//
//  kotaComment.m
//  KoMovie
//
//  Created by avatar on 14-12-3.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "kotaComment.h"
#import "MemContainer.h"

@implementation kotaComment


@dynamic kotaCommentId;
@dynamic kotaId;
@dynamic attachLength;
@dynamic commentType;
@dynamic content;
@dynamic attachPath;



- (void)dealloc{
    
    [super dealloc];
}

+ (NSString *)primaryKey {
    return @"kotaCommentId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"kotaCommentId": @"id",
                 } retain];
    }
    return map;
}


+ (kotaComment *)getKotaCommentMessageWithId:(unsigned int)kotaCommentId {
    return [[MemContainer me] getObject:[kotaComment class]
                                 filter:[Predicate predictForKey:@"id" compare:Equal value:@(kotaCommentId)], nil];
}


@end
