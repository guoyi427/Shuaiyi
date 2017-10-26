//
//  KotaTicketMessage.h
//  KoMovie
//
//  Created by avatar on 14-12-2.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface KotaTicketMessage : Model

@property (nonatomic, assign) int cinemaId;
@property (nonatomic, assign) int cityId;
@property (nonatomic, assign) int movieId;
@property (nonatomic, assign) int kotaId;
@property (nonatomic, assign) int screenDegree;
@property (nonatomic, assign) int screenSize;
@property (nonatomic, assign) int ticketId;
@property (nonatomic, retain) NSString * hallName;
@property (nonatomic, retain) NSString * cinemaName;
@property (nonatomic, retain) NSString * lang;
@property (nonatomic, retain) NSString * ticketTime;

@property (nonatomic, retain) NSString * seatInfo;
@property (nonatomic, retain) NSString * seatNo;



+ (KotaTicketMessage *)getKotaTicketMessageWithId:(unsigned int)kotaId;

@end
