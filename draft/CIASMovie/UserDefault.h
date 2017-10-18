//
//  UserDefault.h
//  Cinephile
//
//  Created by Albert on 7/7/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#ifndef UserDefault_h
#define UserDefault_h

#define USER_DEFAULT_SAVE [[NSUserDefaults standardUserDefaults] synchronize]
//首次登录
#define USER_HASLAUNCHED [[NSUserDefaults standardUserDefaults] boolForKey:@"user_haslaunched"]
#define USER_HASLAUNCHED_WRITE(hasLaunched) [[NSUserDefaults standardUserDefaults] setBool:hasLaunched forKey:@"user_haslaunched"]


//弹框时间
#define USER_ALERTTIME [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_alert_time"] doubleValue]
#define USER_ALERTTIME_WRITE(alertTime) [[NSUserDefaults standardUserDefaults] setValue:@(alertTime) forKey:@"user_alert_time"]

// 用于防止警告连弹
#define USER_EXPIRE_ALERT [[NSUserDefaults standardUserDefaults] valueForKey:@"expire_alert"]
#define USER_EXPIRE_ALERT_WRITE(updateTime) [[NSUserDefaults standardUserDefaults] setValue:updateTime forKey:@"expire_alert"]


//用户注册phoneNum
#define USER_DEFAULT_REGISTERPHONE [[NSUserDefaults standardUserDefaults] valueForKey:@"register_phone"]
#define USER_DEFAULT_REGISTERPHONE_WRITE(phoneNum) [[NSUserDefaults standardUserDefaults] setValue:phoneNum forKey:@"register_phone"]

//用户绑卡phoneNum
#define USER_DEFAULT_BINDPHONE [[NSUserDefaults standardUserDefaults] valueForKey:@"bind_phone"]
#define USER_DEFAULT_BINDPHONE_WRITE(phoneNum) [[NSUserDefaults standardUserDefaults] setValue:phoneNum forKey:@"bind_phone"]

//用户注册code
#define USER_DEFAULT_REGISTERCODE [[NSUserDefaults standardUserDefaults] valueForKey:@"register_code"]
#define USER_DEFAULT_REGISTERCODE_WRITE(phoneCode) [[NSUserDefaults standardUserDefaults] setValue:phoneCode forKey:@"register_code"]

//用户忘记密码code
#define USER_DEFAULT_FORGETCODE [[NSUserDefaults standardUserDefaults] valueForKey:@"forget_code"]
#define USER_DEFAULT_FORGETCODE_WRITE(phoneCode) [[NSUserDefaults standardUserDefaults] setValue:phoneCode forKey:@"forget_code"]
//用户忘记密码phoneNum
#define USER_DEFAULT_FORGETPWPHONE [[NSUserDefaults standardUserDefaults] valueForKey:@"forget_phone"]
#define USER_DEFAULT_FORGETPWPHONE_WRITE(phoneNum) [[NSUserDefaults standardUserDefaults] setValue:phoneNum forKey:@"forget_phone"]

#define USER_DEFAULT_NAME [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"]
#define USER_DEFAULT_NAME_WRITE(name) [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"user_name"]


//用户重置密码code
#define USER_DEFAULT_RESETCODE [[NSUserDefaults standardUserDefaults] valueForKey:@"reset_code"]
#define USER_DEFAULT_RESETCODE_WRITE(phoneCode) [[NSUserDefaults standardUserDefaults] setValue:phoneCode forKey:@"reset_code"]
//用户重置密码phoneNum
#define USER_DEFAULT_RESETPWPHONE [[NSUserDefaults standardUserDefaults] valueForKey:@"reset_phone"]
#define USER_DEFAULT_RESETPWPHONE_WRITE(phoneNum) [[NSUserDefaults standardUserDefaults] setValue:phoneNum forKey:@"reset_phone"]

//用户默认城市
#define USER_CITY [[NSUserDefaults standardUserDefaults] valueForKey:@"user_city"]
#define USER_CITY_WRITE(cityId) [[NSUserDefaults standardUserDefaults] setValue:cityId forKey:@"user_city"]
//用户默认城市名称
#define USER_CITY_NAME [[NSUserDefaults standardUserDefaults] valueForKey:@"user_city_name"]
#define USER_CITY_NAME_WRITE(cityName) [[NSUserDefaults standardUserDefaults] setValue:cityName forKey:@"user_city_name"]


//用户绑定会员卡选择城市，单独使用
#define USER_BIND_CITY [[NSUserDefaults standardUserDefaults] valueForKey:@"user_bind_city"]
#define USER_BIND_CITY_WRITE(cityId) [[NSUserDefaults standardUserDefaults] setValue:cityId forKey:@"user_bind_city"]
//用户绑定会员卡选择城市名称，单独使用
#define USER_BIND_CITY_NAME [[NSUserDefaults standardUserDefaults] valueForKey:@"user_bind_city_name"]
#define USER_BIND_CITY_NAME_WRITE(cityName) [[NSUserDefaults standardUserDefaults] setValue:cityName forKey:@"user_bind_city_name"]



//用户的GPS纬度
#define USER_LATITUDE [[NSUserDefaults standardUserDefaults] valueForKey:@"user_latitude"]
#define USER_LATITUDE_WRITE(latitude) [[NSUserDefaults standardUserDefaults] setValue:latitude forKey:@"user_latitude"]
//用户的GPS经度
#define USER_LONGITUDE [[NSUserDefaults standardUserDefaults] valueForKey:@"user_longitude"]
#define USER_LONGITUDE_WRITE(longitude) [[NSUserDefaults standardUserDefaults] setValue:longitude forKey:@"user_longitude"]
//用户GPS城市
#define USER_GPS_CITY [[NSUserDefaults standardUserDefaults] valueForKey:@"user_gps_city"]
#define USER_GPS_CITY_WRITE(cityName) [[NSUserDefaults standardUserDefaults] setValue:cityName forKey:@"user_gps_city"]

//百度地图定位用户的GPS纬度
#define BAIDU_USER_LATITUDE [[NSUserDefaults standardUserDefaults] valueForKey:@"baidu_user_latitude"]
#define BAIDU_USER_LATITUDE_WRITE(latitude) [[NSUserDefaults standardUserDefaults] setValue:latitude forKey:@"baidu_user_latitude"]
//百度地图定位用户的GPS经度
#define BAIDU_USER_LONGITUDE [[NSUserDefaults standardUserDefaults] valueForKey:@"baidu_user_longitude"]
#define BAIDU_USER_LONGITUDE_WRITE(longitude) [[NSUserDefaults standardUserDefaults] setValue:longitude forKey:@"baidu_user_longitude"]


//用户当前位置
#define USER_CURRENT_ADDRESS [[NSUserDefaults standardUserDefaults] valueForKey:@"user_current_address"]
#define USER_CURRENT_ADDRESS_WRITE(currentAddress) [[NSUserDefaults standardUserDefaults] setValue:currentAddress forKey:@"user_current_address"]
//用户默认影院ID
#define USER_CINEMAID [[NSUserDefaults standardUserDefaults] valueForKey:@"user_cinemaId"]
#define USER_CINEMAID_WRITE(cinemaId) [[NSUserDefaults standardUserDefaults] setValue:cinemaId forKey:@"user_cinemaId"]

//用户绑卡影院ID
#define USER_BINGD_CINEMAID [[NSUserDefaults standardUserDefaults] valueForKey:@"user_bind_cinemaId"]
#define USER_BINGD_CINEMAID_WRITE(cinemaId) [[NSUserDefaults standardUserDefaults] setValue:cinemaId forKey:@"user_bind_cinemaId"]

//用户开卡影院ID
#define USER_OPEN_CINEMAID [[NSUserDefaults standardUserDefaults] valueForKey:@"user_open_cinemaId"]
#define USER_OPEN_CINEMAID_WRITE(cinemaId) [[NSUserDefaults standardUserDefaults] setValue:cinemaId forKey:@"user_open_cinemaId"]

//用户默认影院名称
#define USER_CINEMA_NAME [[NSUserDefaults standardUserDefaults] valueForKey:@"user_cinema_name"]
#define USER_CINEMA_NAME_WRITE(cinemaName) [[NSUserDefaults standardUserDefaults] setValue:cinemaName forKey:@"user_cinema_name"]

//用户默认影院 简称
#define USER_CINEMA_SHORT_NAME [[NSUserDefaults standardUserDefaults] valueForKey:@"user_short_cinema_name"]
#define USER_CINEMA_SHORT_NAME_WRITE(cinemaName) [[NSUserDefaults standardUserDefaults] setValue:cinemaName forKey:@"user_short_cinema_name"]

//用户默认影院地址
#define USER_CINEMA_ADDRESS [[NSUserDefaults standardUserDefaults] valueForKey:@"user_cinema_address"]
#define USER_CINEMA_ADDRESS_WRITE(cinemaAddress) [[NSUserDefaults standardUserDefaults] setValue:cinemaAddress forKey:@"user_cinema_address"]
//选择影院的经纬度
#define CINEMA_LATITUDE [[NSUserDefaults standardUserDefaults] valueForKey:@"cinema_latitude"]
#define CINEMA_LATITUDE_WRITE(latitude) [[NSUserDefaults standardUserDefaults] setValue:latitude forKey:@"cinema_latitude"]

#define CINEMA_LONGITUDE [[NSUserDefaults standardUserDefaults] valueForKey:@"cinema_longitude"]
#define CINEMA_LONGITUDE_WRITE(longitude) [[NSUserDefaults standardUserDefaults] setValue:longitude forKey:@"cinema_longitude"]


//splash更新时间
#define SPLASH_URL [[NSUserDefaults standardUserDefaults] URLForKey:@"splash_url"]
#define SPLASH_URL_WRITE(url) [[NSUserDefaults standardUserDefaults] setURL:url forKey:@"splash_url"]

//热门海报
#define POSTER_URL [[NSUserDefaults standardUserDefaults] URLForKey:@"poster_url"]
#define POSTER_URL_WRITE(url) [[NSUserDefaults standardUserDefaults] setURL:url forKey:@"poster_url"]

//记录设备的唯一标识
#define APP_UUID [[NSUserDefaults standardUserDefaults] valueForKey:@"app_uuid"]
#define APP_UUID_WRITE(appUuid) [[NSUserDefaults standardUserDefaults] setValue:appUuid forKey:@"app_uuid"]

//xc_tabbar的唯一标识
#define APP_TABBAR_LOC [[NSUserDefaults standardUserDefaults] valueForKey:@"app_tabber_loc"]
#define APP_TABBAR_LOC_WRITE(tabberLoc) [[NSUserDefaults standardUserDefaults] setValue:tabberLoc forKey:@"app_tabber_loc"]

//hc_tabbar的唯一标识
#define APP_TABBAR_LOC_HC [[NSUserDefaults standardUserDefaults] valueForKey:@"app_tabber_loc_hc"]
#define APP_TABBAR_LOC_WRITE_HC(tabberLocHc) [[NSUserDefaults standardUserDefaults] setValue:tabberLocHc forKey:@"app_tabber_loc_hc"]

//登录页面输入的手机号码
#define LOGIN_INPUT_PHONE [[NSUserDefaults standardUserDefaults] valueForKey:@"login_input_phone"]
#define LOGIN_INPUT_PHONE_WRITE(phone) [[NSUserDefaults standardUserDefaults] setValue:phone forKey:@"login_input_phone"]



//储值卡支付成功后记录一下会员卡号
#define VipCard_Store [[NSUserDefaults standardUserDefaults] valueForKey:@"card_No"]
#define VipCard_Store_WRITE(cardNo) [[NSUserDefaults standardUserDefaults] setValue:cardNo forKey:@"card_No"]

//记录设备的唯一标识
#define APP_TABBAR_LOC [[NSUserDefaults standardUserDefaults] valueForKey:@"app_tabber_loc"]
#define APP_TABBAR_LOC_WRITE(tabberLoc) [[NSUserDefaults standardUserDefaults] setValue:tabberLoc forKey:@"app_tabber_loc"]


#endif /* UserDefault_h */
