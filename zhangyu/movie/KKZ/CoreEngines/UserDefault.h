//
//  UserDefault.h
//  KKZ
//
//  Created by da zhang on 11-7-21.
//  Copyright 2011年 kokozu. All rights reserved.
//


#define USER_DEFAULT_SAVE [[NSUserDefaults standardUserDefaults] synchronize]

#define USER_DEFAULT_NAME [[NSUserDefaults standardUserDefaults] valueForKey:@"user_name"]
#define USER_DEFAULT_NAME_WRITE(name) [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"user_name"]

#define USER_DEFAULT_ID [[NSUserDefaults standardUserDefaults] valueForKey:@"user_id"]
#define USER_DEFAULT_ID_WRITE(userID) [[NSUserDefaults standardUserDefaults] setValue:userID forKey:@"user_id"]

//是否显示第三方登录按钮
#define THIRD_LOGIN [[NSUserDefaults standardUserDefaults] boolForKey:@"third_login"]
#define THIRD_LOGIN_WRITE(hasThird) [[NSUserDefaults standardUserDefaults] setBool:hasThird forKey:@"third_login"]

//首次登录
#define USER_HASLAUNCHED [[NSUserDefaults standardUserDefaults] boolForKey:@"user_haslaunched"]
#define USER_HASLAUNCHED_WRITE(hasLaunched) [[NSUserDefaults standardUserDefaults] setBool:hasLaunched forKey:@"user_haslaunched"]

//首次走登陆接口
#define USER_LOGINREQUEST [[NSUserDefaults standardUserDefaults] boolForKey:@"user_loginrequest"]
#define USER_LOGINREQUEST_WRITE(hasLogin) [[NSUserDefaults standardUserDefaults] setBool:hasLogin forKey:@"user_loginrequest"]

//城市首次登录
#define CITY_FIRST [[NSUserDefaults standardUserDefaults] boolForKey:@"city_haslaunched"]
#define CITY_FIRST_WRITE(hasLaunched) [[NSUserDefaults standardUserDefaults] setBool:hasLaunched forKey:@"city_haslaunched"]

//首次登录
#define USER_HASAlipay [[NSUserDefaults standardUserDefaults] boolForKey:@"user_hasAliay"]
#define USER_HASAlipay_WRITE(hasAliay) [[NSUserDefaults standardUserDefaults] setBool:hasAliay forKey:@"user_hasAliay"]


//缓存时间
#define USER_CACHE [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_cache"] doubleValue]
#define USER_CACHE_WRITE(cacheTime) [[NSUserDefaults standardUserDefaults] setValue:@(cacheTime) forKey:@"user_cache"]

//用户device_token
#define USER_DEVICE_TOKEN [[NSUserDefaults standardUserDefaults] valueForKey:@"user_device_token"]
#define USER_DEVICE_TOKEN_WRITE(deviceToken) [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:@"user_device_token"]

//用户device_id
#define USER_DEVICE_ID [[NSUserDefaults standardUserDefaults] valueForKey:@"user_device_id"]
#define USER_DEVICE_ID_WRITE(deviceId) [[NSUserDefaults standardUserDefaults] setValue:deviceId forKey:@"user_device_id"]

//用户默认城市
//如果没有默认城市 
#define USER_CITY [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_city"] intValue]
#define USER_CITY_WRITE(cityId) [[NSUserDefaults standardUserDefaults] setValue:cityId forKey:@"user_city"]

//用户经纬度
#define USER_LATITUDE [[NSUserDefaults standardUserDefaults] valueForKey:@"user_latitude"]
#define USER_LATITUDE_WRITE(latitude) [[NSUserDefaults standardUserDefaults] setValue:latitude forKey:@"user_latitude"]

#define USER_LONGITUDE [[NSUserDefaults standardUserDefaults] valueForKey:@"user_longitude"]
#define USER_LONGITUDE_WRITE(longitude) [[NSUserDefaults standardUserDefaults] setValue:longitude forKey:@"user_longitude"]

//用户GPS城市
#define USER_GPS_CITY [[NSUserDefaults standardUserDefaults] valueForKey:@"user_gps_city"]
#define USER_GPS_CITY_WRITE(cityName) [[NSUserDefaults standardUserDefaults] setValue:cityName forKey:@"user_gps_city"]

//用户当前位置
#define USER_CURRENT_ADDRESS [[NSUserDefaults standardUserDefaults] valueForKey:@"user_current_address"]
#define USER_CURRENT_ADDRESS_WRITE(currentAddress) [[NSUserDefaults standardUserDefaults] setValue:currentAddress forKey:@"user_current_address"]


//用户默认影院
#define USER_CINEMA [[[NSUserDefaults standardUserDefaults] valueForKey:@"user_cinema"] intValue]
#define USER_CINEMA_WRITE(cinemaId) [[NSUserDefaults standardUserDefaults] setValue:@(cinemaId) forKey:@"user_cinema"]

//用户收藏的影院
#define COLLECT_CINEMA [[NSUserDefaults standardUserDefaults] arrayForKey:@"collect_cinemas"]
#define COLLECT_CINEMA_WRITE(cinemas) [[NSUserDefaults standardUserDefaults] setObject:cinemas forKey:@"collect_cinemas"]

//判断选择商圈的方式
#define CIRCLE_MAP [[NSUserDefaults standardUserDefaults] valueForKey:@"choose_cirlce_by_map"]
#define CIRCLE_MAP_WRITE(byMap) [[NSUserDefaults standardUserDefaults] setValue:byMap forKey:@"choose_cirlce_by_map"]

//订单手机号
#define BOOKING_PHONE [[NSUserDefaults standardUserDefaults] valueForKey:@"booking_phone"]
#define BOOKING_PHONE_WRITE(phone) [[NSUserDefaults standardUserDefaults] setValue:phone forKey:@"booking_phone"]

//绑定手机号
#define BINDING_PHONE [[NSUserDefaults standardUserDefaults] valueForKey:@"binding_phone"]
#define BINDING_PHONE_WRITE(phone) [[NSUserDefaults standardUserDefaults] setValue:phone forKey:@"binding_phone"]

//splash更新时间
#define SPLASH_URL [[NSUserDefaults standardUserDefaults] valueForKey:@"splash_image_url"]
#define SPLASH_URL_WRITE(url) [[NSUserDefaults standardUserDefaults] setValue:url forKey:@"splash_image_url"]

#pragma mark other update flag section
//锁定座位的时间
#define LOCK_SEAT_TIME [[NSUserDefaults standardUserDefaults] valueForKey:@"lock_seat"]
#define LOCK_SEAT_TIME_WRITE(updateTime) [[NSUserDefaults standardUserDefaults] setValue:updateTime forKey:@"lock_seat"]

// 用于用户的通知存取
#define USER_REMOTE_PUSH [[NSUserDefaults standardUserDefaults] valueForKey:@"remote_push"]
#define USER_REMOTE_PUSH_WRITE(remote) [[NSUserDefaults standardUserDefaults] setValue:remote forKey:@"remote_push"]

// 用于用户的支付宝钱包Token
#define USER_AlIPAY_TOKEN [[NSUserDefaults standardUserDefaults] valueForKey:@"ali_token"]
#define USER_AlIPAY_TOKEN_WRITE(token) [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"ali_token"]

// 用于记录web请求时间
#define USER_EXPIRE_REQUEST [[NSUserDefaults standardUserDefaults] valueForKey:@"expire_request"]
#define USER_EXPIRE_REQUEST_WRITE(updateTime) [[NSUserDefaults standardUserDefaults] setValue:updateTime forKey:@"expire_request"]

// 用于防止当前控制器多次初始化
#define CONTROLLER_INIT_TIME [[NSUserDefaults standardUserDefaults] valueForKey:@"init_time"]
#define CONTROLLER_INIT_TIME_WRITE(updateTime) [[NSUserDefaults standardUserDefaults] setValue:updateTime forKey:@"init_time"]

// 用于防止警告连弹
#define USER_EXPIRE_ALERT [[NSUserDefaults standardUserDefaults] valueForKey:@"expire_alert"]
#define USER_EXPIRE_ALERT_WRITE(updateTime) [[NSUserDefaults standardUserDefaults] setValue:updateTime forKey:@"expire_alert"]

#define USER_NETWORT_ALERT [[NSUserDefaults standardUserDefaults] valueForKey:@"network_alert"]
#define USER_NETWORT_ALERT_WRITE(updateTime) [[NSUserDefaults standardUserDefaults] setValue:updateTime forKey:@"network_alert"]

// 用于记录是否分享Kota买票
#define USER_KOTA_TICKET [[NSUserDefaults standardUserDefaults] boolForKey:@"kota_ticket"]
#define USER_KOTA_TICKET_WRITE(shareKota) [[NSUserDefaults standardUserDefaults] setBool:shareKota forKey:@"kota_ticket"]

// 用于记录是否是手机登录
#define USER_LOGIN_PHONE [[NSUserDefaults standardUserDefaults] boolForKey:@"login_phoneName"]
#define USER_LOGIN_PHONE_WRITE(phoneNum) [[NSUserDefaults standardUserDefaults] setBool:phoneNum forKey:@"login_phoneName"]


#define SHAKE_BACK [[NSUserDefaults standardUserDefaults] valueForKey:@"SHAKE_BACK"]
#define SHAKE_BACK_WRITE(alert) [[NSUserDefaults standardUserDefaults] setValue:alert forKey:@"SHAKE_BACK"]

//记录tabbar的位置
#define TABBAR_INDEX [[NSUserDefaults standardUserDefaults] valueForKey:@"tabbar_index"]
#define TABBAR_INDEX_WRITE(indexY) [[NSUserDefaults standardUserDefaults] setValue:indexY forKey:@"tabbar_index"]



//tabbar的位置是否切换
#define TABBAR_INDEX_ISCHANGE [[NSUserDefaults standardUserDefaults] boolForKey:@"tabbar_index_change"]
#define UTABBAR_INDEX_ISCHANGE_WRITE(isChange) [[NSUserDefaults standardUserDefaults] setBool:isChange forKey:@"tabbar_index_change"]




//微信支付（购票 + 充值）
#define PAY_WEIXIN_TYPE [[NSUserDefaults standardUserDefaults] valueForKey:@"pay_weixin_type"]
#define PAY_WEIXIN_TYPE_WRITE(indexY) [[NSUserDefaults standardUserDefaults] setValue:indexY forKey:@"pay_weixin_type"]


// 用于记录app登录的情况下，环信是否登录
#define USER_LOGIN_HUANXIN [[NSUserDefaults standardUserDefaults] boolForKey:@"login_huanxin"]
#define USER_LOGIN_HUANXIN_WRITE(huanxin) [[NSUserDefaults standardUserDefaults] setBool:huanxin forKey:@"login_huanxin"]


//记录用户的唯一标示
#define APP_UUID [[NSUserDefaults standardUserDefaults] valueForKey:@"app_uuid"]
#define APP_UUID_WRITE(appUuid) [[NSUserDefaults standardUserDefaults] setValue:appUuid forKey:@"app_uuid"]


//记录用户的IP地址
#define USERY_IP [[NSUserDefaults standardUserDefaults] valueForKey:@"user_ip"]
#define USERY_IP_WRITE(userIp) [[NSUserDefaults standardUserDefaults] setValue:userIp forKey:@"user_ip"]


//记录是否通过通知打开
#define OPEN_FROM_APNS [[NSUserDefaults standardUserDefaults] valueForKey:@"from_apns_userId"]
#define OPEN_FROM_APNS_WRITE(fromApnsUserId) [[NSUserDefaults standardUserDefaults] setValue:fromApnsUserId forKey:@"from_apns_userId"]



//是否需要弹出网络不好的弹出框
#define Need_ALERT [[NSUserDefaults standardUserDefaults] boolForKey:@"alert_net_status"]
#define Need_ALERT_WRITE(alertNetStatus) [[NSUserDefaults standardUserDefaults] setBool:alertNetStatus forKey:@"alert_net_status"]

//记录上次输入的登录手机号
#define LOGIN_MOBILE_INPUT [[NSUserDefaults standardUserDefaults] valueForKey:@"login_mobile_input"]
#define LOGIN_MOBILE_INPUT_WRITE(mobile) [[NSUserDefaults standardUserDefaults] setValue:mobile forKey:@"login_mobile_input"]


