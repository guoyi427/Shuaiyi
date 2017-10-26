//
//  Activity.h
//  KKZ
//
//  Created by alfaromeo on 12-3-6.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Activity : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber *activityId;

@property (nonatomic, copy) NSString * picBig;
@property (nonatomic, copy) NSString * picSmall;
@property (nonatomic, copy) NSString * picMid;//暂无使用

@property (nonatomic, copy) NSString * activityTitle;
@property (nonatomic, copy) NSString * activityContent;//活动介绍
@property (nonatomic, copy) NSString * activityUrl;//和activityUrl相同



@property (nonatomic, copy) NSString * shareContent;//分享的内容、标题
@property (nonatomic, copy) NSString * sharePicUrl;//分享的图片



@property (nonatomic, copy) NSString * activityPrice;
@property (nonatomic, copy) NSString * cardType;//兑换券类型，是数组，
@property (nonatomic, copy) NSNumber * type; //选座，强兑换券，html5
@property (nonatomic, copy) NSNumber * movieId;
@property (nonatomic) BOOL  needRegister;//1,0。目前都是1需要注册。（是否显示“我要参加”按钮）

@property (nonatomic, copy) NSDate * endTime;//过了结束时间，下面的按钮式灰色
@property (nonatomic, copy) NSDate * startTime;//活动没开始不能参加。
@property (nonatomic, copy) NSDate * createTime;//
@property (nonatomic, copy) NSDate * expireDate;//
@property (nonatomic, copy) NSNumber * expireDays;//

@property (nonatomic, copy) NSNumber * count;//“活动数量”，票的总数量
@property (nonatomic, copy) NSNumber * remainCount;//票的剩余数量
@property (nonatomic, copy) NSNumber * members;//已参加人数
@property (nonatomic, copy) NSNumber * cntPerOrder;//兑换码(抢票)一账号限制的张数。
+ (NSArray *)getActivityWithSourceArray:(NSArray *)arr;
@end
