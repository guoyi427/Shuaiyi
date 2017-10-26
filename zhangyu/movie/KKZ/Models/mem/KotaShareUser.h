//
//  KotaShareUser.h
//  KoMovie
//
//  Created by avatar on 14-11-18.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KotaShareUser : NSObject

@property (nonatomic,strong)NSNumber *distance;
@property (nonatomic,strong)NSNumber *status;
@property (nonatomic,strong)NSNumber *shareId;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, copy) NSString *filmName;
@property (nonatomic, copy) NSString *shareHeadimg;
@property (nonatomic, copy) NSString *shareNickname;
@property (nonatomic,strong)NSNumber *screenDegree;
@property (nonatomic,strong)NSNumber *screenSize;
@property (nonatomic,copy)NSString *lang;
@property (nonatomic,copy)NSDate *createTime;
@property (nonatomic,strong)NSNumber *kotaId;

@end
