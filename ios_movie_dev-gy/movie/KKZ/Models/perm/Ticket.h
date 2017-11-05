//
//  Ticket.h
//  KKZ
//
//  Created by alfaromeo on 11-10-3.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import "Model.h"
#import "Cinema.h"
#import "CinemaDetail.h"
#import "Movie.h"
#import <Mantle/Mantle.h>
//typedef enum {
//    TicketStatusShow = 0, //不支持购买
//    
//    TicketStatusCoupon = 1, //兑换券
//    
//    TicketStatusEvent = 6, //活动热卖
//    TicketStatusWait = 8, //即将开售
//    TicketStatusTicket = 9 //选座
//} TicketStatus; //服务器selltype

//一条选座信息，


/**
 平台转换

 @param NSNumber 平台号

 @return 平台
 */
PlatForm KKZPlateform(NSNumber *);

// TODO: 整合planEvalue 模型；将名字Ticket换为Plan
/**
 影片排期
 */
@interface Ticket : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *planId; //featureNo or planid
@property (nonatomic, copy) NSNumber *platformOrig;
@property (nonatomic, assign) PlatForm platform;

@property (nonatomic, strong) Movie *movie; 

@property (nonatomic, copy) NSNumber * movieId;
@property (nonatomic, copy) NSDate * movieTime; 

@property (nonatomic, copy) NSString * language;
@property (nonatomic, copy) NSString * screenType; //2d or 3d
@property (nonatomic, copy) NSNumber * movieLength;//计算离场时间 !!! time_shaft


@property (nonatomic, strong) CinemaDetail *cinema;

@property (nonatomic, copy) NSString * hallName;//“1号厅”
@property (nonatomic, copy) NSString * hallNo;//厅对应的id

@property (nonatomic, copy) NSNumber * dealPrice; // !!!price
@property (nonatomic, copy) NSNumber * standardPrice;
@property (nonatomic, copy) NSNumber * vipPrice;   // 抠电影价格


@property (nonatomic, copy) NSString * seatUrl;//html跳转界面的选座，根据platform
@property (nonatomic, copy) NSNumber * promotionId;
@property (nonatomic, copy) NSString * promotionPrice;
@property (nonatomic) BOOL hasPromotion;
/**
 *  排期标题
 */
@property (nonatomic, strong) NSString *planShortTitle;

//---------

@property (nonatomic, copy) NSNumber * weekDay;//0今天，1明天，2后天。
@property (nonatomic) BOOL isPromotion;//是否是推广

/**
 *  是否是过场的电影
 */
@property (nonatomic, assign) BOOL expireDate;



- (BOOL)supportBuy;
+ (Ticket *)getTicketWithId:(NSInteger)planId;
- (void)updateDataWithDict:(NSDictionary *)dict;

@end
