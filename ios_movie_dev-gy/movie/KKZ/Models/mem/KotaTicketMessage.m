//
//  KotaTicketMessage.m
//  KoMovie
//
//  Created by avatar on 14-12-2.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "KotaTicketMessage.h"
#import "MemContainer.h"

@implementation KotaTicketMessage

@dynamic cinemaId;
@dynamic cityId;
@dynamic movieId;
@dynamic kotaId;
@dynamic screenDegree;
@dynamic screenSize;
@dynamic ticketId;
@dynamic hallName;
@dynamic cinemaName;
@dynamic lang;
@dynamic ticketTime;
@dynamic seatInfo;
@dynamic seatNo;



- (void)dealloc{
    
    [super dealloc];
}

+ (NSString *)primaryKey {
    return @"kotaId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"kotaId": @"id",
                 } retain];
    }
    return map;
}


+ (KotaTicketMessage *)getKotaTicketMessageWithId:(unsigned int)kotaId {
    return [[MemContainer me] getObject:[KotaTicketMessage class]
                                 filter:[Predicate predictForKey: @"id" compare:Equal value:@(kotaId)], nil];
}
@end
