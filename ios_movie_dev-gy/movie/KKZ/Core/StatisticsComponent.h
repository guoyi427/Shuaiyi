//
//  统计分析的组件
//
//  Created by wuzhen on 15/7/15.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface StatisticsComponent : NSObject

//【Banner】正在上映点击
#define EVENT_BANNER_CLICK_SOURCE_SHOWING @"banner_click_in_showing"
//【Banner】即将上映点击
#define EVENT_BANNER_CLICK_SOURCE_COMING @"banner_click_in_coming"
//【Banner】影院列表点击
#define EVENT_BANNER_CLICK_SOURCE_CINEMA @"5_cinemas_scrollHeader"
//【购票】电影入口-首页电影列表
#define EVENT_BUY_MOVIE_LIST_SOURCE_MOVIE @"enter_FragmentShowingMovie"
//【购票】电影入口-进入影片页
#define EVENT_BUY_MOVIE_DETAIL_SHOWING_SOURCE_MOVIE @"click_movie_in_showing"
//【购票】电影入口-点击选座购票
#define EVENT_BUY_ENTER_CHOOSE_CINEMA_SOURCE_MOVIE @"enter_choose_cinema"
//【购票】电影入口-选择影城
#define EVENT_BUY_TICKET_SOURCE_MOVIE @"click_buy_ticket_in_movie"
//【购票】电影入口-选择场次
#define EVENT_BUY_IN_CINEMA_SOURCE_MOVIE @"buy_in_cinema_from_movie"
//【购票】电影入口-锁座下单
#define EVENT_BUY_LOCK_SEAT_SOURCE_MOVIE @"lock_seat_from_movie"
//【购票】电影入口-锁座成功
#define EVENT_BUY_LOCK_SEAT_SUCCESS_SOURCE_MOVIE @"lock_seat_success_from_movie"
//【购票】电影入口-支付订单
#define EVENT_BUY_PAY_ORDER_SOURCE_MOVIE @"pay_order_from_movie"
//【购票】电影入口-订单支付成功
#define EVENT_BUY_ORDER_SUCCESS_SOURCE_MOVIE @"pay_order_success_from_movie"
//【购票】电影入口-订单出票成功
#define EVENT_BUY_TICKET_SUCCESS_SOURCE_MOVIE @"pay_order_buy_ticket_success_from_movie"
//【购票】影院入口-进入影院列表
#define EVENT_BUY_ENTER_CINEMA_LIST_SOURCE_CINEMA @"enter_FragmentTabCinema"
//【购票】影院入口-进入影院页
#define EVENT_BUY_CHOOSE_CINEMA_SOURCE_CINEMA @"buy_choose_cinema"
//【购票】影院入口-选择场次
#define EVENT_BUY_IN_CINEMA_SOURCE_CINEMA @"buy_in_cinema_from_cinema"
//【购票】影院入口-锁座下单
#define EVENT_BUY_LOCK_SEAT_SOURCE_CINEMA @"lock_seat_from_cinema"
//【购票】影院入口-锁座成功
#define EVENT_BUY_LOCK_SEAT_SUCCESS_SOURCE_CINEMA @"lock_seat_success_from_cinema"
//【购票】影院入口-支付订单
#define EVENT_BUY_PAY_ORDER_SOURCE_CINEMA @"pay_order_from_cinema"
//【购票】影院入口-订单支付成功
#define EVENT_BUY_ORDER_SUCCESS_SOURCE_CINEMA @"pay_order_success_from_cinema"
//【购票】影院入口-订单出票成功
#define EVENT_BUY_TICKET_SUCCESS_SOURCE_CINEMA @"pay_order_buy_ticket_success_from_cinema"
//【购票】锁定座位
#define EVENT_BUY_LOCK_SEAT @"5_lock_seat"
//【购票】锁座成功
#define EVENT_BUY_LOCK_SEAT_SUCCESS @"lock_seat_success"
//【购票】支付订单
#define EVENT_BUY_PAY_ORDER @"5_pay_order"
//【购票】订单支付成功
#define EVENT_BUY_ORDER_SUCCESS @"5_pay_order_success"
//【购票】订单支付失败
#define EVENT_BUY_ORDER_FAILED @"5_pay_order_failed"
//【购票】出票成功
#define EVENT_BUY_TICKET_SUCCESS @"5_buy_ticket_success"
//【电影】查看即将上映影片详情
#define EVENT_MOVIE_INCOMING_DETAIL @"5_incoming_movies_detail"
//【电影】电影详情点预告片
#define EVENT_MOVIE_PLAY_TRAILER @"5_movies_playTrailer"
//【电影】电影详情想看
#define EVENT_MOVIE_WANT_SEE @"5_movies_wantLook_success"
//【影院】查看影院地图
#define EVENT_CINEMA_MAP @"5_cinemaDetail_map"
//【影院】拨打影城电话
#define EVENT_CINEMA_TELEPHONE @"5_cinemaDetail_telephone"
//【影院】收藏影院
#define EVENT_CINEMA_COLLECT @"5_cinemaDetail_collect"
//【影院】影院列表筛选
#define EVENT_CINEMA_FILTER @"5_cinema_fliter"
//【影院】搜索影院
#define EVENT_CINEMA_SEARCH @"5_cinema_search"
//【账户】添加通讯录好友
#define EVENT_USER_ADD_CONTACT_FRIENT @"5_add_contact_friend"
//【账户】登录
#define EVENT_USER_LOGIN @"5_user_login"
//【账户】登录成功
#define EVENT_USER_LOGIN_SUCCESS @"5_user_login_success"
//【账户】退出登录
#define EVENT_USER_LOGOUT @"signout"
//【社区】发表帖子
#define EVENT_SNS_PUBLISH_POSTER @"5_club_post_publish"
//【分享】分享影院
#define EVENT_SHARE_CINEMA @"share_cinema"
//【分享】分享影片
#define EVENT_SHARE_MOVIE @"share_movie"
//【分享】分享活动
#define EVENT_SHARE_PRIVILEGE @"share_privilege"
//【分享】分享订单
#define EVENT_SHARE_ORDER @"share_order"
//【分享】分享社区帖子
#define EVENT_SHARE_SNS_POSTER @"share_sns_poster"
//【分享】分享订阅号
#define EVENT_SHARE_SUBSCRIBER @"share_subscriber"
//【首页】首页切换底部标签
#define EVENT_HOMEPAGE_SWITCH_TAB @"switch_homepage_tab"

/**
 * 初始化统计分析的组件。
 */
+ (void)initStatisticsComponent;

/**
 * 页面启动的事件。
 */
+ (void)pageViewBeginEvent:(NSString *)pageName;

/**
 * 页面结束的事件。
 */
+ (void)pageViewEndEvent:(NSString *)pageName;

/**
 * 发送事件。
 *
 * @param eventId 事件的ID
 */
+ (void)event:(NSString *)eventId;

/**
 * 发送事件。
 *
 * @param eventId    事件的ID
 * @param attributes 额外的参数
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes;

/**
 * 统计账号登录的事件。
 */
+ (void)loginEvent:(NSString *)uid platform:(NSString *)platform;

/**
 * 统计账号退出的事件。
 */
+ (void)logoutEvent;

@end
