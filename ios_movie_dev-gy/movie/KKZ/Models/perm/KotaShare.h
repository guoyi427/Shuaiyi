//
//  KotaShare.h
//  KoMovie
//
//  Created by XuYang on 13-4-12.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "Model.h"


//一条kota信息
@interface KotaShare : Model

@property (nonatomic,strong)NSNumber *screenDegree;
@property (nonatomic,strong)NSNumber *screenSize;
@property (nonatomic,copy)NSString *lang;
@property (nonatomic,copy)NSString *kotaContent;//content
@property (nonatomic,copy)NSString *kotaStatus;
@property (nonatomic, copy) NSString * shareHeadimg;
@property (nonatomic, copy) NSString * content;

@property (nonatomic, copy) NSString * shareNickname;

@property (nonatomic, assign) int kotaCommentId;
@property (nonatomic, assign) int kotaId;
@property (nonatomic, assign) int kotaType;
@property (nonatomic, assign) int status;
@property (nonatomic, retain) NSString * cinemaName;
@property (nonatomic, retain) NSString * movieName;
@property (nonatomic, assign) int movieId;
@property (nonatomic, retain) NSDate * ticketTime;
@property (nonatomic, assign) int ticketId;
@property (nonatomic, assign) int cinemaId;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, assign) unsigned int userId;
@property (nonatomic, retain) NSString * userSex;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userAvatar;
@property (nonatomic, retain) NSNumber * userFans;//这个人的粉丝

@property (nonatomic, retain) NSNumber * distance;//我与这个人的距离，后台算的。
@property (nonatomic, retain) NSString * posterPath;//电影海报

@property (nonatomic,retain)NSNumber * shareSex;
@property (nonatomic,retain)NSNumber * shareCount;
@property (nonatomic, assign) int loveNum;
@property (nonatomic, assign) int shareUserId;




+ (KotaShare *)getKotaShareWithId:(int)kotaId;
+(NSArray *)filterKotaWithTicketTimeArray:(NSArray*)arr;

@end