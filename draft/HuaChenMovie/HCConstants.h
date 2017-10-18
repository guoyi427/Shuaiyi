//
//  HCConstants.h
//  CIASMovie
//
//  Created by avatar on 2017/5/25.
//  Copyright © 2017年 cias. All rights reserved.
//

#ifndef HCConstants_h
#define HCConstants_h



//开机启动图、个人中心头像区分，3个开机动画，kIsThreeAnimation设置为1

#if K_HUACHEN    //MARK: -- 根据新城V3.3版更改 


//MARK: --项目正式/测试环境配置

#define kIsHuaChenFormal 0    //华臣正式环境
#define kIsHuaChenTest   1    //华臣测试环境

static NSString * _Nonnull const kIsFirstLaunch = @"cmsFirstShow_hc";// 华臣第一次启动

//MARK: --可配置的模板
//MARK: --高级版，功能模块配置
#define kIsSingleCinemaTabbarStyle 0 //单影院tabbar临时  影片，影院，我的 样式 --单影院--不用选择城市和影院了，只此一家
#define kIsHuaChenTmpTabbarStyle 1 //华臣tabbar临时  购票，首页，我的 样式 --临时
#define kIsXinchengTmpTabbarStyle 0 //新城tabbar临时  首页，购票，资讯，我的 样式 --临时
#define kIsXinchengTabbarStyle @"0"//新城tabbar购票，商城，首页，资讯，我的 样式 --高级
#define kIsCMSStandardTabbarStyle @"0"//CMS标准版tabbar 首页，购票，会员卡，我的 样式（中都）--高级

#define kIsXinchengOrderDetailStyle 1//新城定制化   票根页（0，中都， 1，新城，华臣）--高级
//以下两个只有一个为1，目前都用的是新城的排期列表样式
#define kIsXinchengPlanListStyle @"1"//新城定制化   排期列表（中都，新城，华臣）--高级
#define kIsCMSStandardPlanListStyle @"0"//CMS标准版排期列表 --高级

#define kIsHaveOpenCardXinchengPlanList 0//新城排期列表中是否增加开卡引导（0 中都，华臣，1 新城）--高级
#define kIsHaveGoodsInHome     1  //首页是否有卖品展现  （0-没有，中都，华臣 / 1-有，新城）--高级
#define kIsHaveGoodsInOrderDetail 1 //票根页是否有卖品展现（0-没有，华臣，1-有-新城）--高级



//MARK: --基础版，功能模块配置

#define kIsHaveTipLabelInCinemaList 1//影城中是否增加提示标签（0 中都，1 新城，华臣）
static NSString * _Nonnull const kIsHaveJudgement = @"1"; //设置中是否有评价（0 中都，1 新城，华臣）
static NSString * _Nonnull const kIsHaveSystemSet = @"1";//设置中是否有系统设置（0 中都，1 新城，华臣）
//#define kIsHaveJudgement    1  //设置中是否有评价（0 中都，1 新城，华臣）
//#define kIsHaveSystemSet    1  //设置中是否有系统设置（0 中都，1 新城，华臣）
#define kIsHaveCinemaDetail 1  //排期页影院下面是否有详情按钮（0 中都，1 新城，华臣）
#define kIsHaveOrderInHome  1  //首页中是否有未领取订单（0 中都，1 新城，华臣）

//以下两个只有一个为1
#define kIsXinchengCardStyle @"0"//新城会员卡样式
#define kIsCMSStandardCardStyle @"1"//CMS标准版会员卡样式（中都，华臣）
//以下两个只有一个为1
#define kIsXinchengAccountStyle @"1"//新城个人中心电影票，会员卡，优惠券，充值样式（新城，华臣）
#define kIsCMSStandardAccountStyle @"0"//标准版个人中心电影票，充值，绑卡，优惠券样式（中都）
#define kIsBaoShanStandardAccountStyle @"0"//单影院个人中心电影票，优惠券样式（宝山）

//#define kIsHaveVipCard    1 //中都-项目中暂时无法使用会员卡，需要弹出提示框，新城，华臣有会员卡
//#define kIsHaveOpencard @"0"//是否含有开卡功能（0 不能开卡-中都，华臣   1 可以开卡-新城）
static NSString * _Nonnull const kIsHaveOpencard = @"0";//是否含有开卡功能（0 不能开卡-中都，华臣   1 可以开卡-新城）
static NSString * _Nonnull const kIsHaveVipCard = @"1";//中都-项目中暂时无法使用会员卡，需要弹出提示框，新城有会员卡
static NSString * _Nonnull const kIsHaveUnbindcard = @"1";//是否含有解绑功能（0 不能解绑-中都   1 可以解绑-新城，华臣）
//#define kIsHaveUnbindcard 1//是否含有开卡功能（0 不能解绑-中都   1 可以解绑-新城，华臣）
#define kIsHaveActivity @"1"//是否含有活动功能（0 没有活动-中都   1 有活动-新城，华臣）
#define kIsHaveCoupon @"0"//是否含有优惠券功能（0 没有优惠券-中都，华臣   1 有优惠券-新城）
static NSString * _Nonnull const kIsHaveWeixinPay = @"0";//是否含有微信支付功能（0 不能微信支付-中都   1 可以微信支付-新城）

//以下两个只有一个为1
//#define kIsOneAnimation @"0"//是否是1个开机动画（0 不是   1 是-再区分各项目，中都）
//#define kIsThreeAnimation @"1"//是否是3个开机动画（0 不是   1 是-再区分各项目，新城，华臣）
static NSString * _Nonnull const kIsOneAnimation = @"0";//是否是1个开机动画（0 不是   1 是-再区分各项目，中都）
static NSString * _Nonnull const kIsTwoAnimation = @"0";//是否是2个开机动画（0 不是   1 是-再区分各项目，宝山等单影院）
static NSString * _Nonnull const kIsThreeAnimation = @"1";//是否是3个开机动画（0 不是   1 是-再区分各项目，新城，华臣）



//MARK: -------------------是否为华臣项目显示用-----------------------
//MARK: 华臣keychain related

static NSString * _Nonnull const kKeyChainServiceName = @"huachen";
//#define kKeyChainServiceName @"huachen"
#define kKCSessionId @"huachen_session"
#define kKCSessionIdTimestamp @"huachen_session_timestamp"
#define kKCUserId @"huachen_userid"
#define kKCUserName @"huachen_username"

//MARK: 百度地图Key
static NSString * _Nonnull const BaiduMapKey = @"ePsswVLDkIQEQ6O5OWIBNmVR";//华臣的

//MARK: 友盟UMeng
static NSString * _Nonnull const kUMengKey = @"54ab9b68fd98c5867100049e";//华臣的

//MARK: appstoreId
//#define kStoreAppId @"928325853"//华臣的
static NSString * _Nonnull const kStoreAppId = @"928325853";//华臣的
static NSString * _Nonnull const BuglyAppId = @"6d0d955e8e";//华臣的

/*
 *微信
 *info.plist里面的url type 也要改
 */
//MARK:  为空 代表未开通微信支付，会在代码里进行判断
static NSString * _Nonnull const kWeixinKey = @"";////华臣微信 没有支付

#define kAlipayScheme @"huachen"//华臣支付宝回调
//#define kAlipayScheme @"CIASMovie"
//MARK: -------------------是否为新城项目显示用-----------------------




//MARK: 最大座位数
#define maxSelectedSeatNum 4
//MARK: 开场前多少分钟
#define klockTime @"15"
//MARK: 客服电话
//#define kHotLine @"4000566668"
//#define kHotLineForDisplay @"400 056 6668"
static NSString * _Nonnull const kHotLine = @"4000566668";
static NSString * _Nonnull const kHotLineForDisplay = @"400 056 6668";


//MARK: -----------------华臣使用-----------------------
//MARK: 华臣测试环境
#if kIsHuaChenTest
    //渠道号
    #define ciasChannelId  @"331"
    #define ciasChannelKey @"a1a1e027-bf34-6fe9-a50d-8c6802e88328"
    //租户ID
    #define ciasTenantId  @"108"
    //影片、排期、会员卡、相关服务器地址
    #define ciasSSPServerBaseURL @"http://121.40.179.94:8150/webservice/"
    //订单、相关服务器地址
    #define ciasSSPOrderBaseURL @"http://paytest.cias.net.cn/cias-order-web/"
#endif

//MARK: 华臣正式环境
#if kIsHuaChenFormal
    ////渠道号
    #define ciasChannelId  @"19"
    #define ciasChannelKey @"bc38dc7c-2831-28e4-dd6a-112d1ddcf90c"
    //租户ID
    #define ciasTenantId  @"110"
    //影片、排期、会员卡、相关服务器地址
    #define ciasSSPServerBaseURL @"http://api.kokozu.net/webservice/"
    //订单、相关服务器地址
    #define ciasSSPOrderBaseURL @"http://order.kokozu.net/cias-order-web/"
#endif
//MARK: -----------------华臣使用-----------------------



//影讯
#define ciasFilmNews  @"ciasapi/"
//活动
#define ciasMarketNews  @"marketapi/"
//工程配置
#define ciasConfigNews  @"cmsapi/"
//会员卡相关服务器地址后缀
#define memberConfigNews  @"memberapi/"
//卖品相关服务器地址后缀
#define productConfigNews @"saleapi/"

#endif







#endif /* HCConstants_h */
