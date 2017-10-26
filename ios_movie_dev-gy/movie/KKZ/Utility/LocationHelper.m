//
//  LocationHelper.m
//  KoMovie
//
//  Created by wuzhen on 15/7/13.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "LocationHelper.h"
#import "UserDefault.h"
#import "City.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"


@implementation LocationHelper



/**
 * 查询当前GPS定位城市是否与之前选择的城市不同。
 */
+ (void)queryGPSCityChange {

    if (USER_GPS_CITY && USER_CITY) {

        DLog(@"queryGPSCity: city=%d, cityId=%d", USER_CITY, [USER_GPS_CITY intValue]);

        City *gpsCity = [City getCityWithName:USER_GPS_CITY];
        BOOL gpsAvaild = (gpsCity.cityId > 0 && ![gpsCity.cityName isEqualToString:@"null"] && ![gpsCity.cityName isEqual:nil]);

        if (USER_CITY != gpsCity.cityId && gpsAvaild) {
            RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
            cancel.action = ^{

            };

            RIButtonItem *ok = [RIButtonItem itemWithLabel:@"好的"];
            ok.action = ^{
                USER_CITY_WRITE(gpsCity.cityId);

                [[NSNotificationCenter defaultCenter] postNotificationName:@"locationCityChanged" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", gpsCity.cityId] forKey:@"changedCityId"]];
            };
            
            NSString *alertStr = [NSString stringWithFormat:@"系统检测到您当前的所在城市是%@，是否切换？", gpsCity.cityName];
            UIAlertView *alertAt = [[UIAlertView alloc] initWithTitle:@"" message:alertStr cancelButtonItem:cancel otherButtonItems:ok, nil];
            [alertAt show];
        }
    }
}



@end

