//
//  Macros.h
//  Cinephile
//
//  Created by Albert on 7/11/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#ifndef Macros_h
#define Macros_h
/******************************系统默认尺寸*******************************/
#define kCommonScreenBounds [UIScreen mainScreen].bounds  //整个APP屏幕尺寸
#define kCommonScreenWidth kCommonScreenBounds.size.width  //整个APP屏幕的宽度
#define kCommonScreenHeight kCommonScreenBounds.size.height //整个APP屏幕的高度
#define ciasNavBarBackgroundColor [UIColor whiteColor] // 白色
#define ciasTitleBarDivider [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] // 白色
#define ciasTitleBarLabelColor [UIColor blackColor] // 白色

#define IS_IOS_8 (([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 8) ? YES : NO)
#define IS_IOS_10 (([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 10) ? YES : NO)

#import <Foundation/Foundation.h>

static NSString *const _Nonnull KPullRefreshingHeaderText = @"拼命加载中…";

/**
 *  上拉加载更多，加载不到跟多
 */
static NSString *const _Nonnull KPullLoadMoreTextNull = @"没有更多";


/**
 *  回到根控制器的通知
 */
static NSString *const _Nonnull YN_POP_TO_ROOT_CONTROLLER_NAME = @"yn pop to root view controller name";

static NSString *const _Nonnull YN_POP_TO_ROOT_CONTROLLER_KEY = @"yn pop to root view controller key";



static NSString * const _Nonnull GFTitleButtonDidRepeatShowClickNotificationCenter = @"GFTitleButtonDidRepeatShowClickNotificationCenter";
static NSString *const _Nonnull CityUpdateSucceededNotification = @"CityUpdateSucceededNotification";
static NSString *const _Nonnull CinemaChangeSucceededNotification = @"CinemaChangeSucceededNotification";

#define TaskTypeOrderChooseNotification @"TaskTypeOrderChooseNotification"


/**
 支付宝支付成功通知
 */
static NSString * _Nonnull const TaskTypeAliPaySucceedNotification = @"TaskTypeAliPaySucceedNotification";
static NSString * _Nonnull const AliPayOpencardSucceedNotification = @"AliPayOpencardSucceedNotification";
static NSString * _Nonnull const AliPayChargeSucceedNotification = @"AliPayChargeSucceedNotification";
/**
 微信支付成功通知
 */
static NSString * _Nonnull const wxpaySucceedNotification = @"wxpaySucceedNotification";
static NSString * _Nonnull const wxpayOpencardSucceedNotification = @"wxpayOpencardSucceedNotification";
static NSString * _Nonnull const wxChargeSucceedNotification = @"wxChargeSucceedNotification";





#endif /* Macros_h */
