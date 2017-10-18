//
//  Constants.h
//  CIASMovie
//
//  Created by avatar on 2017/4/17.
//  Copyright © 2017年 cias. All rights reserved.
//

#ifndef ZDConstants_h
#define ZDConstants_h

//开机启动图、个人中心头像区分,1个开机动画，kIsOneAnimation设置为1


#if K_ZHONGDU       //根据新城V3.2更改


//MARK: 环境配置
#define kIsZhongduFormal 1//中都正式环境
#define kIsZhongduTest 0//中都测试环境

static NSString * _Nonnull const kIsFirstLaunch = @"cmsFirstShow_zd";// 中都第一次启动


//MARK: --可配置的模板
//MARK: --高级版，功能模块配置
//以下两个只有一个为1，另一个在基础版里，新城5个tabbar
#define kIsSingleCinemaTabbarStyle 0 //单影院tabbar临时  影片，影院，我的 样式 --单影院--不用选择城市和影院了，只此一家
#define kIsHuaChenTmpTabbarStyle 0 //华臣tabbar临时  购票，首页，我的 样式 --临时
#define kIsXinchengTmpTabbarStyle 0 //新城tabbar临时  首页，购票，资讯，我的 样式 --临时
#define kIsXinchengTabbarStyle @"0"//新城tabbar购票，商城，首页，资讯，我的样式--（新城）---高级
#define kIsCMSStandardTabbarStyle @"1"//CMS标准版tabbar 首页，购票，会员卡，我的 样式（中都）

#define kIsXinchengOrderDetailStyle 0//新城定制化票根页（0，中都， 1，新城，华臣）--高级

//两选一，目前都用的新城的排期列表样式
#define kIsXinchengPlanListStyle @"1"//新城定制化排期列表（中都，华臣）--高级
#define kIsCMSStandardPlanListStyle @"0"//CMS标准版排期列表   --高级

#define kIsHaveOpenCardXinchengPlanList 0//新城排期列表中是否增加开卡引导（0 中都，华臣，1 新城）---高级
#define kIsHaveGoodsInHome     0  //首页是否有卖品展现  （0-没有，中都，华臣 / 1-有，新城）---高级
#define kIsHaveGoodsInOrderDetail 0 //票根页是否有卖品展现（0-没有 中都，华臣，1-有-新城）---高级


//MARK: --基础版，功能模块配置
#define kIsHaveTipLabelInCinemaList 1//影城中是否增加提示标签（1 中都，1 新城，华臣）
static NSString * _Nonnull const kIsHaveJudgement = @"1"; //设置中是否有评价（0 中都，1 新城，华臣）
static NSString * _Nonnull const kIsHaveSystemSet = @"1";//设置中是否有系统设置（0 中都，1 新城，华臣）
//#define kIsHaveJudgement    1   //设置中是否有评价（1 中都，1 新城，华臣）
//#define kIsHaveSystemSet    1   //设置中是否有系统设置（1 中都，1 新城，华臣）
#define kIsHaveCinemaDetail 1   //影院中是否有详情按钮（1 中都，1 新城，华臣）
#define kIsHaveOrderInHome  1   //首页中是否有未领取订单（1 中都，1 新城，华臣）
//以下两个只有一个为1
#define kIsXinchengCardStyle @"0"//新城会员卡样式（新城）
#define kIsCMSStandardCardStyle @"1"//CMS标准版会员卡样式（中都，华臣）
//以下两个只有一个为1
#define kIsXinchengAccountStyle @"0"//新城个人中心电影票，会员卡，优惠券，充值样式（新城，华臣）
#define kIsCMSStandardAccountStyle @"1"//标准版个人中心电影票，充值，绑卡，优惠券样式（中都）
#define kIsBaoShanStandardAccountStyle @"0"//单影院个人中心电影票，优惠券样式（宝山）

//以下两个只有一个为1，另一个在高级版里   4个tabbar
//#define kIsHaveVipCard   0 //中都-项目中暂时无法使用会员卡，需要弹出提示框
//#define kIsHaveOpencard @"0"//是否含有开卡功能（0 不能开卡-中都，华臣   1 可以开卡-新城）
static NSString * _Nonnull const kIsHaveOpencard = @"0";//是否含有开卡功能（0 不能开卡-中都，华臣   1 可以开卡-新城）
static NSString * _Nonnull const kIsHaveVipCard = @"0";//中都-项目中暂时无法使用会员卡，需要弹出提示框，新城有会员卡
static NSString * _Nonnull const kIsHaveUnbindcard = @"0";//是否含有解绑功能（0 不能解绑-中都   1 可以解绑-新城，华臣）
//#define kIsHaveUnbindcard 0//是否含有开卡功能（0 不能解绑-中都   1 可以解绑-新城，华臣）
#define kIsHaveActivity @"0"//是否含有活动功能（0 没有活动-中都   1 有活动-新城，华臣）
#define kIsHaveCoupon @"0"//是否含有优惠券功能（0 没有优惠券-中都，华臣   1 有优惠券-新城）
static NSString * _Nonnull const kIsHaveWeixinPay = @"0";//是否含有微信支付功能（0 不能微信支付-中都   1 可以微信支付-新城）

//以下两个只有一个为1
//#define kIsOneAnimation @"1"//是否是1个开机动画（0 不是   1 是-再区分各项目，中都）
//#define kIsThreeAnimation @"0"//是否是3个开机动画（0 不是   1 是-再区分各项目，新城，华臣）
static NSString * _Nonnull const kIsOneAnimation = @"1";//是否是1个开机动画（0 不是   1 是-再区分各项目，中都）
static NSString * _Nonnull const kIsTwoAnimation = @"0";//是否是2个开机动画（0 不是   1 是-再区分各项目，宝山等单影院）
static NSString * _Nonnull const kIsThreeAnimation = @"0";//是否是3个开机动画（0 不是   1 是-再区分各项目，新城，华臣）

//MARK: -------------------是否为中都项目显示用-----------------------
//MARK: 新城keychain related
static NSString * _Nonnull const kKeyChainServiceName = @"zhongdu";
//#define kKeyChainServiceName @"zhongzu"
#define kKCSessionId @"zhongdu_session"
#define kKCSessionIdTimestamp @"zhongdu_session_timestamp"
#define kKCUserId @"zhongdu_userid"
#define kKCUserName @"zhongdu_username"

//MARK: 百度地图Key
static NSString * _Nonnull const BaiduMapKey = @"1egVAFU0XWwEu6uYGsWFCeGK36IfyeAB";//中都的

//MARK: 友盟UMeng
static NSString * _Nonnull const kUMengKey = @"57d7a94d67e58e1093001736";//中都的

//#define BaiduMapKey @"WpF1rNk0iDkCTcU704MLWRu3"
//MARK: appstoreId
//#define kStoreAppId @""//中都的
static NSString * _Nonnull const kStoreAppId = @"";//中都的

static NSString * _Nonnull const BuglyAppId = @"bfd191819c";//中都的

/*
 *微信
 *info.plist里面的url type 也要改
 */
//MARK:  为空 代表未开通微信支付，会在代码里进行判断
static NSString * _Nonnull const kWeixinKey = @"";////中都的微信 没有支付

#define kAlipayScheme @"zhongdu"//中都支付宝回调


//MARK: 最大座位数
#define maxSelectedSeatNum 4
//MARK: 开场前多少分钟
#define klockTime @"15"
//MARK: 客服电话
//#define kHotLine @"4000009666"
//#define kHotLineForDisplay @"400 000 9666"
static NSString * _Nonnull const kHotLine = @"4000009666";
static NSString * _Nonnull const kHotLineForDisplay = @"400 000 9666";



//MARK: -------------------是否为中都项目显示用----------------------

//MARK: 中都测试环境
#if kIsZhongduTest
    //渠道号
    #define ciasChannelId  @"262"
    #define ciasChannelKey @""

    //租户ID
    #define ciasTenantId  @"85"

    //影片、排期、会员卡、相关服务器地址
    #define ciasSSPServerBaseURL @"http://121.40.179.94:8150/webservice/"

    //订单、相关服务器地址
    #define ciasSSPOrderBaseURL @"http://paytest.cias.net.cn/cias-order-web/"
#endif

//MARK: 中都正式环境
#if kIsZhongduFormal
    //渠道号
    #define ciasChannelId  @"7"
    #define ciasChannelKey @""

    //租户ID
    #define ciasTenantId  @"97"

    //影片、排期、会员卡、相关服务器地址
    #define ciasSSPServerBaseURL @"http://api.kokozu.net/webservice/"

    //订单、相关服务器地址
    #define ciasSSPOrderBaseURL @"http://order.kokozu.net/cias-order-web/"
#endif


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



#endif /* ZDConstants_h */


