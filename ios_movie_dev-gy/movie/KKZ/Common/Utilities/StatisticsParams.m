//
//  StatisticsParams.m
//  KoMovie
//
//  Created by KKZ on 16/5/12.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "FMDeviceManager.h"
#import "LocationEngine.h"
#import "StatisticsParams.h"
#import "UIDeviceExtra.h"
#import "UserDefault.h"
#import <AdSupport/ASIdentifierManager.h>
#import <SystemConfiguration/SystemConfiguration.h>
#include <arpa/inet.h>
#import <dlfcn.h>
#include <ifaddrs.h>
#include <net/if.h>
#include <netdb.h>

@implementation StatisticsParams
+ (NSString *)getTimeNowWithMillisecond {
    NSString *date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"]; //当前时间统计到毫秒
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}

+ (NSString *)getTimeNowWithSecond {
    NSString *date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //当前时间统计到秒
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}

+ (NSString *)getAppChannelName {
    return kChannelName;
}

+ (NSString *)getAppVersion {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

+ (NSString *)getLongitude {
    double longitude = [LocationEngine sharedLocationEngine].longitude;
    return [NSString stringWithFormat:@"%f", longitude];
}

+ (NSString *)getLatitude {
    double latitude = [LocationEngine sharedLocationEngine].latitude;
    return [NSString stringWithFormat:@"%f", latitude];
}

+ (NSString *)getOsVersion {
    CGFloat osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    return [NSString stringWithFormat:@"%f", osVersion];
}

+ (NSString *)getDeviceId {
    return APP_UUID;
}

+ (NSString *)getDeviceResolution {
    return [NSString stringWithFormat:@"%f*%f", screentWith, screentHeight];
}

+ (NSString *)getGpsCityName {
    return USER_GPS_CITY;
}

+ (NSString *)getDevicePlatform {
    return [[UIDevice currentDevice] platform];
}

+ (NSString *)getReachabilityStatus {
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state = [[NSString alloc] init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];

            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5: {
                    state = @"WIFI";
                } break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return state;
}

- (NSString *)hostname {
    char baseHostName[256]; // Thanks, Gunnar Larisch
    int success = gethostname(baseHostName, 255);
    if (success != 0) return nil;
    baseHostName[255] = '/0';

#if TARGET_IPHONE_SIMULATOR
    return [NSString stringWithFormat:@"%s", baseHostName];
#else
    return [NSString stringWithFormat:@"%s.local", baseHostName];
#endif
}
//从host获取地址
- (NSString *)getIPAddressForHost:(NSString *)theHost {
    struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {
        herror("resolv");
        return NULL;
    }
    struct in_addr **list = (struct in_addr **) host->h_addr_list;
    NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
    return addressString;
}

//这是本地host的IP地址
- (NSString *)getDeviceIP {
    if (!USERY_IP) {
        struct hostent *host = gethostbyname([[self hostname] UTF8String]);
        if (!host) {
            herror("resolv");
            USERY_IP_WRITE(@"无法获取IP地址");
            return nil;
        }
        struct in_addr **list = (struct in_addr **) host->h_addr_list;
        USERY_IP_WRITE([NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding]);
        return USERY_IP;
    }
    DLog(@"USERY_IP === %@",USERY_IP);
    return USERY_IP;
}

@end
