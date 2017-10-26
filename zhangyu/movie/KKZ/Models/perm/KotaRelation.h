//
//  KotaRelation.h
//  KoMovie
//
//  Created by XuYang on 13-4-30.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//废弃

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CustomManagedObject.h"

typedef enum {
    //    KotaRelationTypeShare = 0,
    KotaRelationTypeApply = 1,
    KotaRelationTypeAgree = 2,
    KotaRelationTypeDisagree = 3,
    KotaRelationTypeSucceed = 4,
    KotaRelationTypeRegist = 5,
    KotaRelationTypeAvatar = 6,
    KotaRelationTypeShare = 7,
} KotaRelationType;

@interface KotaRelation : CustomManagedObject

@property (nonatomic, retain) NSString * cinemaId;
@property (nonatomic, retain) NSString * cinemaName;
@property (nonatomic, retain) NSString * kotaId;
@property (nonatomic, retain) NSString * kotaNo;
@property (nonatomic, retain) NSNumber * kotaState;
@property (nonatomic, retain) NSDate * kotaTime;
@property (nonatomic, strong) NSString * movieId;
@property (nonatomic, retain) NSString * movieName;
@property (nonatomic, retain) NSDate * movieTime;
@property (nonatomic, retain) NSString * ticketId;
@property (nonatomic, retain) NSString * shareId;
@property (nonatomic, retain) NSString * shareName;
@property (nonatomic, retain) NSString * shareSex;
@property (nonatomic, retain) NSString * shareSeatInfo;
@property (nonatomic, retain) NSString * requestId;
@property (nonatomic, retain) NSString * requestName;
@property (nonatomic, retain) NSString * requestSex;
@property (nonatomic, retain) NSString * requestSeatInfo;
@property (nonatomic, retain) NSString * seatNo;


+ (KotaRelation *)getKotaWithId:(NSString *)kotaId inContext:(NSManagedObjectContext *)context;
+ (KotaRelation *)getKotaWithNo:(NSString *)kotaNo inContext:(NSManagedObjectContext *)context;

@end
