//
//  FriendHomeMessage.m
//  KoMovie
//
//  Created by avatar on 14-11-27.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "FriendHomeMessage.h"
#import "DateEngine.h"
#import "MemContainer.h"
#import "NSStringExtra.h"

@implementation FriendHomeMessage

@dynamic homeMessageId;
@dynamic status;
@dynamic isRequest;
@dynamic createTime;



- (void)dealloc{
    
    [super dealloc];
}

+ (NSString *)primaryKey {
    return @"homeMessageId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                  @"homeMessageId": @"id",
                 } retain];
    }
    return map;
}

+ (FriendHomeMessage *)getMovieWithId:(unsigned int)homeMessageId {
    return [[MemContainer me] getObject:[FriendHomeMessage class]
                                 filter:[Predicate predictForKey: @"id" compare:Equal value:@(homeMessageId)], nil];
}
@end
