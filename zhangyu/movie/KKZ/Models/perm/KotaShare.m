//
//  KotaShare.m
//  KoMovie
//
//  Created by XuYang on 13-4-12.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "KotaShare.h"
#import "MemContainer.h"
#import "DateEngine.h"

@implementation KotaShare

@dynamic screenDegree;
@dynamic screenSize;
@dynamic lang;
@dynamic kotaContent;
@dynamic kotaStatus;
@dynamic shareHeadimg;
@dynamic content;
@dynamic shareNickname;
@dynamic loveNum;


@dynamic kotaId;
@dynamic kotaType;
@dynamic cinemaName;
@dynamic movieName;
@dynamic movieId;
@dynamic ticketTime;
@dynamic createTime;
@dynamic cinemaId;
@dynamic userId;
@dynamic userSex;
@dynamic distance;
@dynamic posterPath;
@dynamic userAvatar;
@dynamic userName;
@dynamic userFans;

@dynamic shareSex;
@dynamic shareCount;
@dynamic ticketId;
@dynamic status;


+ (NSString *)primaryKey {
    return @"kotaId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"userId": @"shareId",
                 @"movieName": @"filmName",
                 @"movieId": @"filmId",
                 } retain];
    }
    return map;
}

+ (NSDictionary *)formatMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"ticketTime": @"yyyy-MM-dd HH:mm:ss",
                 @"createTime": @"yyyy-MM-dd HH:mm:ss",
                 } retain];
    }
    return map;
}

+ (KotaShare *)getKotaShareWithId:(int)kotaId{
    return [[MemContainer me] getObject:[KotaShare class]
                                 filter:[Predicate predictForKey: @"kotaId" compare:Equal value:@(kotaId)], nil];

}

+ (NSArray *)filterKotaWithTicketTimeArray:(NSArray*)arr {
    NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
    for (KotaShare *kota in arr) {
        if (kota.ticketTime) {
            
            NSDate *oneHourAfter = [NSDate dateWithTimeIntervalSince1970:([[NSDate date] timeIntervalSince1970] + 60*60)];
            NSTimeInterval oneHourAfterInt = [oneHourAfter timeIntervalSince1970];
            
            NSTimeInterval ticketTimeInt = [kota.ticketTime timeIntervalSince1970];
            
            int isExpired = ticketTimeInt - oneHourAfterInt;
            
            if (isExpired  >= 0) {
                [array addObject:kota];
            }

        }else{
            [array addObject:kota];
        }
        
    }
    
    return [array autorelease];
}

@end
