//
//  Activity.h
//  CIASMovie
//
//  Created by cias on 2017/3/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Activity : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *activityId;
@property (nonatomic, copy)NSString *activityName;
@property (nonatomic, copy)NSString *activityTypeName;
@property (nonatomic, copy)NSString *label;
@property (nonatomic, copy)NSString *note;
@property (nonatomic, copy)NSString *code;//储值卡会员卡号

@property (nonatomic, copy)NSString *activityType; //0是身份卡 1是普通活动
@property (nonatomic, copy)NSString *type; //0是身份卡 1是普通活动
@property (nonatomic, strong)NSNumber *platform;//1自营  2系统方
@property (nonatomic, copy)NSString *payLimit;//0-不限，1-会员，2-非会员

@end
