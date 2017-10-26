//
//  Fans.h
//  KoMovie
//
//  Created by alfaromeo on 12-4-24.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//废弃

#import "CustomManagedObject.h"

@interface Fans : CustomManagedObject

@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * avatarPath;
@property (nonatomic, strong) NSString * userName;
@property (nonatomic, strong) NSString * sinaId;

@property (nonatomic, strong) NSString * cinemaId;
@property (nonatomic, strong) NSString * movieId;

+ (Fans *)getFansWithId:(NSString *)userId inContext:(NSManagedObjectContext *)context;
+ (void)cleanFansForMovie:(NSString *)movieId inContext:(NSManagedObjectContext *)context;
+ (void)cleanFansForCinema:(NSString *)cinemaId inContext:(NSManagedObjectContext *)context;

@end
