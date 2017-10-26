//
//  StatisticsParams.h
//  KoMovie
//
//  Created by KKZ on 16/5/12.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsParams : NSObject

//获取当前时间 精确到毫秒 YYYY-MM-dd hh:mm:ss:SSS
+(NSString *)getTimeNowWithMillisecond;

//获取当前时间 精确到秒 YYYY-MM-dd hh:mm:ss
+(NSString *)getTimeNowWithSecond;

//app渠道名称
+(NSString *)getAppChannelName;

//appVersion：应用版本号
+(NSString *)getAppVersion;

//经度
+(NSString *)getLongitude;

//纬度
+(NSString *)getLatitude;

//手机操作系统版本号
+(NSString *)getOsVersion;

//设备id
+(NSString *)getDeviceId;

//手机分辨率(宽x高）
+(NSString *)getDeviceResolution;

//Gps定位城市
+(NSString *)getGpsCityName;

//机器型号
+(NSString *)getDevicePlatform;

//当前网络（WIFI、4G、3G）
+(NSString *)getReachabilityStatus;

//Ip地址
- (NSString *)getDeviceIP;
@end
