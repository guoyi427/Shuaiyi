//
//  Cinema.h
//  KKZ
//
//  Created by alfaromeo on 11-10-3.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Model.h"

typedef enum {
    PlatFormNone = 0, //不支持售票
    PlatFormCoupon,   //兑换券
    PlatFormWeb,     //网页选座
    PlatFormTicket   //在线选座
} PlatForm; //服务器sell_ability


@interface Cinema : Model {
@private

}

//------
@property (nonatomic, assign) int cinemaId;
@property (nonatomic, retain) NSString * cinemaAddress;
@property (nonatomic, retain) NSString * address;

@property (nonatomic, assign) int cityId;
//cityName
//districtId
@property (nonatomic, retain) NSString * districtName;//地理区域
@property (nonatomic, retain) NSNumber * longitude;//经度
@property (nonatomic, retain) NSNumber * latitude;//纬度

//hot
@property (nonatomic, assign) int platform;//“查看场次”,"买兑换券"，“在线选座“
@property (nonatomic, retain) NSNumber * platFormNum;//“查看场次”,"买兑换券"，“在线选座“
@property (nonatomic, retain) NSString * cinemaName;
@property (nonatomic, retain) NSString * contactName;

@property (nonatomic, retain) NSNumber * ticketType;//是否支持二维码  //
@property (nonatomic, retain) NSNumber * validPlanCount;//剩余场次数量
//machineType
@property (nonatomic, retain) NSNumber * minPrice; //最低一口价 //minPrice
@property (nonatomic, retain) NSString * cinemaPhone; //cinemaTel


//@property (nonatomic, retain) NSString * cinemaOpentime; //营业时间
//@property (nonatomic, retain) NSString * cinemaIntro; //

@property (nonatomic, retain) NSString * drivePath;//路线
@property (nonatomic, retain) NSString * flag;//标签

//@property (nonatomic, retain) NSNumber * sortId;//sinemaid用来排序

@property (nonatomic, retain) NSString * closeTicketTime; // 影院禁止购票的排期提前的时间：分钟


//用于显示城市影院列表
@property (nonatomic, retain) NSNumber * distance;// 手机计算出的公里数


@property (nonatomic, retain) NSString * shortTitle; //首单9.9元
//@property (nonatomic, retain) NSString * promotionId;
@property (nonatomic, retain) NSString * notice;//影院声明

//@property (nonatomic, assign) BOOL isCollected;//是否为收藏的影院

//显示影片对应的城区和影院列表时使用, 记录对应的影片id
//@property (nonatomic, assign) int movieId;

//- (CLLocationCoordinate2D)cinemaCenter;
//- (NSString *)distanceDesc;
//- (NSString *)cinemaType;
//- (NSArray *)cinemaFlags;

+ (Cinema *)getCinemaWithId:(NSUInteger)cinemaId;
//- (void)updateLayout;

//CinemaListController
//+(NSArray *)getCinemaNearWithSourceArray:(NSArray*)arr;
//+(NSArray *)getCinemaWithSourceArray:(NSArray*)arr;

//+(NSArray *)getCinemaWithDistrictName:(NSString*)districtName sourceArray:(NSArray*)arr;
//MovieCinemaController
//+(NSArray *)getMovieCinemaAllWithSourceArray:(NSArray*)arr;
//+(NSArray *)getMovieCinemaNearWithSourceArray:(NSArray*)arr;
//+(NSArray *)getMovieCinemaWithDistrictName:(NSString*)districtName sourceArray:(NSArray*)arr;

@end
