//
//  处理 URL 形式打开 App 的组件
//
//  Created by wuzhen on 15/5/8.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UrlOpenUtility.h"

#import <objc/runtime.h>


#import "DataEngine.h"
#import "KKZUtility.h"
#import "NSObject+Delegate.h"
#import "NSURL+scheme.h"
#import "TaskQueue.h"
#import "ChooseSeatViewController.h"
#import "ActivityDetailViewController.h"
#import "AttentionViewController.h"
#import "CinemaTicketViewController.h"
#import "ClubPostPictureViewController.h"
#import "CollectedCinemaListViewController.h"
#import "CommonTabBarController.h"
#import "CommonViewController.h"
#import "DirectBroadcastingController.h"
#import "ECardViewController.h"
#import "ImpressIntroViewController.h"
#import "ImprestViewController.h"
#import "MovieDetailViewController.h"
#import "MovieDetailViewController.h"
#import "NewCinemaDetailViewController.h"
#import "OrderDetailViewController.h"
#import "OrderListViewController.h"
#import "RedCouponViewController.h"
#import "PlanRequest.h"

@implementation UrlOpenUtility

/**
 * 根据指定的 URL 启动对应的 Controller。
 * 若成功启动 Controller 则返回 YES，否则返回 NO。
 */
+ (BOOL)handleOpenAppUrl:(NSURL *)url {
    if ([url isEqual:nil]) {
        return NO;
    }

    NSString *urlString = [url absoluteString];
    BOOL isAppOpen = [urlString hasPrefix:APP_OPEN_PATH];
    BOOL isActivityOpen = [urlString hasPrefix:ACTIVITY_OPEN_PATH];

    if (isActivityOpen && ![urlString containsString:@"name="]) { // 原链接地址
        return [self handleActivityOpenUrl:url];
    }

    if (isAppOpen || isActivityOpen) {

        // 需要登录才可以打开的 Controller
        NSDictionary *accountPagers = [NSDictionary
                dictionaryWithObjectsAndKeys:[ECardViewController class], @"CouponList", [ImprestViewController class],
                                             @"AccountCharge", [OrderListViewController class], @"OrderList",
                                             [RedCouponViewController class], @"RedEnvelope",
                                             [AttentionViewController class], @"FriendManager",
                                             [CollectedCinemaListViewController class], @"CollectedCinema",
                                             [OrderDetailViewController class], @"OrderDetail",
                                             [ImpressIntroViewController class], @"AccountBalance", nil];

        // 不需要登录可以直接打开的 Controller
        NSDictionary *directPagers = [NSDictionary
                dictionaryWithObjectsAndKeys:[CommonTabBarController class], @"Homepage", [ChooseSeatViewController class],
                                             @"ChooseSeat", [CinemaTicketViewController class], @"PlanList",
                                             [MovieDetailViewController class], @"MovieDetail",
                                             [ActivityDetailViewController class], @"ActivityDetail",
                                             [DirectBroadcastingController class], @"PanoramaPlayer",
                                             [NewCinemaDetailViewController class], @"CinemaDetail",
                                             [ClubPostPictureViewController class], @"ClubPostDetail", nil];

        NSDictionary *params = [url queryParams];
        NSString *pagerName = [params kkz_stringForKey:@"name"];
        NSString *extra1 = [params kkz_stringForKey:@"extra1"];
        NSString *extra2 = [params kkz_stringForKey:@"extra2"];
        NSString *extra3 = [params kkz_stringForKey:@"extra3"];

        if (!pagerName) {
            return NO;
        }

        if ([@"Homepage" isEqualToString:pagerName]) { // 返回首页
            [self backtoHomepage:extra1];
            return YES;
        }

        // 查询需要登录才可以打开的 Controller 的列表
        Class controllerClass = accountPagers[pagerName];
        if (controllerClass) {

            DLog(@"%@, open need log controller: %@, and is login: %d", url, controllerClass,
                 [appDelegate isAuthorized]);

            if (![appDelegate isAuthorized]) { // 未登录
                [self loginAndStartController:url];
            } else { // 已登录
                [self startUrlOpenController:controllerClass extra1:extra1 extra2:extra2 extra3:extra3];
            }
            return YES;
        }

        // 查询可以直接打开的 Controller 的列表
        controllerClass = directPagers[pagerName];
        if (!controllerClass) {
            controllerClass = NSClassFromString(pagerName);
        }

        DLog(@"%@, open controllerName: %@", url, controllerClass);

        if (!controllerClass) {
            return NO;
        }

        [self startUrlOpenController:controllerClass extra1:extra1 extra2:extra2 extra3:extra3];
        return YES;
    }
    return NO;
}

// 打开登录页面，登录成功后再打开 URL 对应的 Controller
+ (void)loginAndStartController:url {
    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [[DataEngine sharedDataEngine] startLoginFinished:^(BOOL succeed) {
        if (succeed) {
            [self handleOpenAppUrl:url];
        }
    }
                                       withController:parentCtr];
}

// 返回首页
+ (void)backtoHomepage:(NSString *)tab {
    int tabIndex = [self handleTabIndex:tab];
    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [parentCtr popToViewControllerAnimated:YES];
    [appDelegate setSelectedPage:tabIndex tabBar:YES];
}

// 打开指定的 Controller 且传入参数
+ (BOOL)startUrlOpenController:(Class)controllerClass
                        extra1:(NSString *)extra1
                        extra2:(NSString *)extra2
                        extra3:(NSString *)extra3 {

    NSObject *instance = nil;
    if (extra1 && class_respondsToSelector(controllerClass, @selector(initWithExtraData:extra2:extra3:))) {
        instance = (NSObject *) [[controllerClass alloc] initWithExtraData:extra1 extra2:extra2 extra3:extra3];
    } else {
        instance = [[controllerClass alloc] init];
    }

    if (instance && [instance isKindOfClass:[UIViewController class]]) { // 启动 Controller
        UIViewController *ctr = (UIViewController *) instance;
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
        return YES;
    }

    return NO;
}

/**
 * 处理 URL 中传递的 tab 参数，该值以 1 开始，实际返回的值要减去 1。
 */
+ (int)handleTabIndex:(NSString *)tab {
    if (!tab) {
        return 0;
    }

    int index = [tab intValue];
    index -= 1;
    if (index < 0) {
        index = 0;
    }
    return index;
}

+ (BOOL)handleActivityOpenUrl:(NSURL *)url {
    if (!url) {
        return NO;
    }

    NSArray *contents = [url.absoluteString componentsSeparatedByString:@"?"];
    NSString *body = contents.count > 1 ? (NSString *) [contents objectAtIndex:1] : @"";
    NSArray *params = [body componentsSeparatedByString:@"&"];

    NSMutableDictionary *dictParams = [NSMutableDictionary dictionaryWithCapacity:0];

    for (int i = 0; i < params.count; i++) {
        NSArray *dictParamArray = [params[i] componentsSeparatedByString:@"="];
        NSString *dictParamKey = dictParamArray[0];
        if (dictParamKey.length > 0) {
            NSString *dictParamValue = dictParamArray[1];
            if (dictParamValue.length > 0) {
                dictParams[dictParamArray[0]] = dictParamValue;
            }
        }
    }

    NSString *movie_id = [dictParams kkz_stringForKey:@"movie_id"];
    NSString *tab = [dictParams kkz_stringForKey:@"tab"];
    NSString *cinema_id = [dictParams kkz_stringForKey:@"cinema_id"];

    NSString *plan_id = [dictParams kkz_stringForKey:@"plan_id"];
    NSString *activityId = [dictParams kkz_stringForKey:@"activity_id"];
    NSString *name = [dictParams kkz_stringForKey:@"name"];

    // 影院排期列表页面
    if ([name isEqualToString:@"CinemaTicketViewController"]) {
        CinemaTicketViewController *cdv = [[CinemaTicketViewController alloc] init];
        cdv.movieId = [movie_id toNumber];
        cdv.cinemaId = [cinema_id toNumber];
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:cdv animation:CommonSwitchAnimationBounce];
        return YES;
    }
    // 影片详情页面
    else if ([name isEqualToString:@"MovieDetailViewController"]) {

        MovieDetailViewController *mvc = [[MovieDetailViewController alloc] initCinemaListForMovie:[movie_id toNumber]];
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:mvc animation:CommonSwitchAnimationBounce];

        return YES;
    }
    // 影院排期列表页面
    else if ([name isEqualToString:@"CinemaTicketViewController"]) {
        CinemaTicketViewController *cdv = [[CinemaTicketViewController alloc] init];
        cdv.cinemaId = [cinema_id toNumber];
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:cdv animation:CommonSwitchAnimationBounce];
        return YES;
    }
    // 选座页面
    else if ([name isEqualToString:@"ChooseSeatViewController"]) {
        
        PlanRequest *request = [PlanRequest new];
            [request requestPlanDetail:plan_id success:^(Ticket * _Nullable plan) {
                ChooseSeatViewController *ctr = [[ChooseSeatViewController alloc] init];
                
                ctr.planId = plan.planId;

                CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
                [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
                
            } failure:^(NSError * _Nullable err) {
                
            }];


        return YES;
    }
    // 活动详情
    else if (activityId.length) {
        ActivityDetailViewController *ctr =
                [[ActivityDetailViewController alloc] initWithActivityId:[activityId intValue]];
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
        return YES;
    }

    return NO;
}

@end
