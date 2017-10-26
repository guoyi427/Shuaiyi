//
//  Fans.m
//  KoMovie
//
//  Created by alfaromeo on 12-4-24.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "Fans.h"


@implementation Fans

@dynamic userId;
@dynamic avatarPath;
@dynamic userName;
@dynamic sinaId;

@dynamic cinemaId;
@dynamic movieId;

+ (NSString *)entityName {
    return @"Fans";
}

- (void)updateDataFromDict:(NSDictionary *)dict {

    [self setObj:[dict stringForKey:@"user_id"] forKey:@"userId"];
    [self setObj:[dict stringForKey:@"weibo_id"] forKey:@"sinaId"];
    [self setObj:[dict objForKey:@"user_name"] forKey:@"userName"];
    [self setObj:[dict objForKey:@"user_avatar"] forKey:@"avatarPath"];
    
}

+ (Fans *)getFansWithId:(NSString *)userId inContext:(NSManagedObjectContext *)context {
    return (Fans *)[Fans getWithPredicate:[NSPredicate predicateWithFormat:@"userId == %@", userId]
                                inContext:context];
}

+ (void)cleanFansForMovie:(NSString *)movieId inContext:(NSManagedObjectContext *)context {
    [Fans deleteWithPredicate:[NSPredicate predicateWithFormat:@"movieId == %@", movieId]
                    inContext:context];
}

+ (void)cleanFansForCinema:(NSString *)cinemaId inContext:(NSManagedObjectContext *)context {
    [Fans deleteWithPredicate:[NSPredicate predicateWithFormat:@"cinemaId == %@", cinemaId]
                    inContext:context];
}

@end
