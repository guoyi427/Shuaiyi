//
//  CinemaDetail.h
//  KoMovie
//
//  Created by Albert on 9/5/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "Promotion.h"
#import "Cinema.h"

@interface CinemaDetail : MTLModel <MTLJSONSerializing>

@property(nonatomic, copy) NSNumber *cinemaId;
/**
 *  影院名称
 */
@property(nonatomic, copy) NSString *cinemaName;
/**
 *   影院所在行政区id
 */
@property(nonatomic, copy) NSNumber *districtId;
/**
 *  影院所在行政区名称
 */
@property(nonatomic, copy) NSString *districtName;
/**
 *  平台
 */
@property(nonatomic, copy) NSNumber *platform;
/**
 *   电话
 */
@property(nonatomic, copy) NSString *cinemaTel;
/**
 *  地址
 */
@property(nonatomic, copy) NSString *cinemaAddress;

@property(nonatomic, copy) NSString *longitude;

@property(nonatomic, copy) NSString *latitude;
/**
 *  行车路线
 */
@property(nonatomic, copy) NSString *drivePath;
/**
 *  营业时间
 */
@property(nonatomic, copy) NSString *openTime;
/**
 *  简介
 */
@property(nonatomic, copy) NSString *cinemaIntro;
/**
 *
 */
@property(nonatomic, copy) NSString *photo;
/**
 *  收藏的状态
 */
@property(nonatomic, copy) NSString *collectStatus;
/**
 *  热度
 */
@property(nonatomic, copy) NSNumber *hot;
/**
 *  所在城市id
 */
@property(nonatomic, copy) NSNumber *cityId;
/**
 *  取票类型
 */
@property(nonatomic, copy) NSNumber *ticketType;
/**
 *  剩余的场次
 */
@property(nonatomic, copy) NSNumber *validPlanCount;

/**
 *   影院的最低价
 */
@property(nonatomic, copy) NSString *minPrice;
/**
 *  小图标
 */
@property(nonatomic, copy) NSString *flag;
/**
 *   影院名称（收藏的影院返回数据）
 */
@property(nonatomic, copy) NSString *contactName;
/**
 *  影院地址（收藏的影院返回数据）
 */
@property(nonatomic, copy) NSString *address;
/**
 *  影院头图
 */
@property(nonatomic, copy) NSString *appBigPost;
/**
 *  购票关闭的场次间隔
 */
@property(nonatomic, copy) NSNumber *closeTicketTime;
/**
 *  活动title
 */
@property(nonatomic, copy) NSString *shortTitle;

@property(nonatomic, copy) NSString *notice;

@property(nonatomic, copy) NSString *closeTicketTimeMsg;

@property(nonatomic, copy) NSNumber *point;
/**
 *  <Promotion>
 */
@property(nonatomic, strong) NSArray *promotions;


//----------------------------------------------

/**
 *  收藏
 */
@property(nonatomic) BOOL isCollected;
/**
 *  已购票
 */
@property(nonatomic) BOOL isBuy;


/**
 *  与 GPS 位置的距离（米）
 */
@property(nonatomic, copy) NSNumber *distanceMetres;

/**
 *  支持类型
 */
@property(nonatomic) PlatForm platformType;

@end
