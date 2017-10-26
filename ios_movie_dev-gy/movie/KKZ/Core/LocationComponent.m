//
//  定位的组件
//
//  Created by wuzhen on 15/7/13.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "LocationComponent.h"

#import "City.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "UserDefault.h"

@implementation LocationComponent

/**
 * 查询当前GPS定位城市是否与之前选择的城市不同。
 */
+ (void)queryGPSCityChange {
    if (USER_GPS_CITY && USER_CITY) {

        DLog(@"queryGPSCity: city=%d, cityId=%d", USER_CITY, [USER_GPS_CITY intValue]);

        City *gpsCity = [City getCityWithName:USER_GPS_CITY];
        BOOL gpsAvaild = (gpsCity.cityId > 0 && ![gpsCity.cityName isEqualToString:@"null"] && ![gpsCity.cityName isEqual:nil]);

        if (USER_CITY != gpsCity.cityId.intValue && gpsAvaild) {
            RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
            cancel.action = ^{

                appDelegate.cityChange = YES;
                appDelegate.locationAlert = nil;
            };

            RIButtonItem *ok = [RIButtonItem itemWithLabel:@"好的"];
            ok.action = ^{

                USER_CITY_WRITE(gpsCity.cityId);

                appDelegate.cityChange = YES;

                [[NSNotificationCenter defaultCenter] postNotificationName:@"locationCityChanged" object:nil userInfo:[NSDictionary dictionaryWithObject:gpsCity.cityId.stringValue forKey:@"changedCityId"]];
                appDelegate.locationAlert = nil;
            };

            NSString *message = [NSString stringWithFormat:@"系统检测到您当前的所在城市是%@，是否切换？", gpsCity.cityName];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:message cancelButtonItem:cancel otherButtonItems:ok, nil];
            [alertView show];
            appDelegate.locationAlert = alertView;
        }
    }
}

@end
