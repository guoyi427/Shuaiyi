//
//  Cinema.h
//  CIASMovie
//
//  Created by cias on 2016/12/29.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Cinema : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *cinemaId;
@property (nonatomic, copy)NSString *cinemaName;
@property (nonatomic, copy)NSString *telphone;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *introduction;
@property (nonatomic, strong)NSNumber *opentime;
@property (nonatomic, copy)NSString *driveRoute;
@property (nonatomic, copy)NSString *cityId;
@property (nonatomic, strong)NSNumber *districtId;
@property (nonatomic, copy)NSString *lat;
@property (nonatomic, copy)NSString *lon;
@property (nonatomic, strong)NSNumber *screenCount;
@property (nonatomic, strong)NSNumber *isNear;
@property (nonatomic, strong)NSNumber *isCome;
@property (nonatomic, strong)NSNumber *isMoney;
@property (nonatomic, copy)NSString *discount;//优惠信息	string	影院维度的优惠信息
@property (nonatomic, copy)NSString *discountTag;//优惠标签	string	立减10元，18元起
//@property (nonatomic, strong)NSArray *cinemaFeatures;//不用了
@property (nonatomic, strong)NSArray *serviceFeatures;
@property (nonatomic, copy)  NSString *screenFeatures;

//
@property (nonatomic, copy)NSString *businessHours;

@property (nonatomic, strong) NSString * distance;

/**
 影院简称。 首页右上角需要用到的。
 */
@property (nonatomic, copy) NSString *cinemaShortName;

//- (NSString *)distanceDesc;
- (void)updateLayout;

+(NSArray *)getCinemasByDistanceWithSourceArray:(NSArray*)arr;

@end
