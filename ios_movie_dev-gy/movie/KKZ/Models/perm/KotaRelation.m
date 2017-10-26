//
//  KotaRelation.m
//  KoMovie
//
//  Created by XuYang on 13-4-30.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "KotaRelation.h"


@implementation KotaRelation

@dynamic cinemaId;
@dynamic cinemaName;
@dynamic kotaId;
@dynamic kotaState;
@dynamic kotaTime;
@dynamic movieId;
@dynamic movieName;
@dynamic movieTime;
@dynamic shareId;
@dynamic requestId;
@dynamic ticketId;
@dynamic shareSeatInfo;
@dynamic requestSeatInfo;
@dynamic shareName;
@dynamic shareSex;
@dynamic requestName;
@dynamic requestSex;
@dynamic kotaNo;
@dynamic seatNo;

+ (NSString *)entityName
{
    return @"KotaRelation";
}

- (void)updateDataFromDict:(NSDictionary *)dict
{
    [self setObj:[dict dateForKey:@"createTime" withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"kotaTime"];
    
    [self setObj:[dict stringForKey:@"cinemaName"] forKey:@"cinemaName"];
    [self setObj:[dict stringForKey:@"filmName"] forKey:@"movieName"];
    [self setObj:[dict stringForKey:@"qid"] forKey:@"ticketId"];
    [self setObj:[dict dateForKey:@"ticketTime" withFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"movieTime"];
    [self setObj:[dict stringForKey:@"kotaId"] forKey:@"kotaNo"];

    [self setObj:[dict stringForKey:@"shareId"] forKey:@"shareId"];
    [self setObj:[dict stringForKey:@"shareNickname"] forKey:@"shareName"];
    [self setObj:[dict stringForKey:@"shareSex"] forKey:@"shareSex"];

    [self setObj:[dict stringForKey:@"requestId"] forKey:@"requestId"];
    [self setObj:[dict stringForKey:@"requestNickname"] forKey:@"requestName"];
    [self setObj:[dict stringForKey:@"requestSex"] forKey:@"requestSex"];

    [self setObj:[dict stringForKey:@"shareSeatInfo"] forKey:@"shareSeatInfo"];
    [self setObj:[dict stringForKey:@"requestSeatInfo"] forKey:@"requestSeatInfo"];
    [self setObj:[dict stringForKey:@"shareSeatNo"] forKey:@"seatNo"];

    [self setObj:[dict intNumberForKey:@"status"] forKey:@"kotaState"];
}

+ (KotaRelation *)getKotaWithId:(NSString *)kotaId inContext:(NSManagedObjectContext *)context
{
    return (KotaRelation *)[KotaRelation getWithPredicate:[NSPredicate predicateWithFormat:@"kotaId == %@",kotaId] inContext:context];
}

+ (KotaRelation *)getKotaWithNo:(NSString *)kotaNo inContext:(NSManagedObjectContext *)context
{
    return (KotaRelation *)[KotaRelation getWithPredicate:[NSPredicate predicateWithFormat:@"kotaNo == %@",kotaNo] inContext:context];
}


@end
