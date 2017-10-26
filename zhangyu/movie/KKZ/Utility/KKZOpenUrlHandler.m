//
//  KKZOpenUrlHandler.m
//  KoMovie
//
//  Created by wuzhen on 15/5/8.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KKZViewController.h"
#import "KKZOpenUrlHandler.h"
#import "NSURL+scheme.h"
#import "ActivityDetailViewController.h"
#import "TicketActivityViewController.h"
#import "CouponActivityViewController.h"
#import "MovieDetailViewControllerNew.h"
#import "CinemaDetailViewController.h"
#import "BuyTicketViewController.h"

@implementation KKZOpenUrlHandler


+ (void) handleOpenApplicationUrl:(NSURL *)url appDelegate:(KKZAppDelegate *)app {
    if ([url isEqual:nil]) {
        return;
    }
    
    NSString *host = url.host;
    NSDictionary* params = [url queryParams];
    
    if ([@"app" isEqualToString:host]) { // komovie://app
        NSString *path = url.path;
        NSString *controllerName;
        
        NSString *extra1 = [params stringForKey:@"extra1"];
        NSString *extra2 = [params stringForKey:@"extra2"];
        NSString *extra3 = [params stringForKey:@"extra3"];
        
        if ([@"/open" isEqualToString:path]) { // komovie://app/open：根据传递的activity的值打开指定的Controller
            controllerName = [params stringForKey:@"name"];
        }
        else if ([@"/page" isEqualToString:path]) { // komovie://app/page：根据传递的activity的值打开设定的某个Controller
            NSString *page = [params stringForKey:@"name"];
            controllerName = [self getOpenViewControllerName:page extra1:extra1 extra2:extra2 extra3:extra3];
        }

        [self startUrlOpenController:controllerName extra1:extra1 extra2:extra2 extra3:extra3 appDelegate:app];
    }
}


+ (void)startUrlOpenController:(NSString *)controllerName extra1:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 appDelegate:(KKZAppDelegate *)app {
    
    if (controllerName && ![controllerName isEqual:nil] && ![@"null" isEqualToString:controllerName]) {
        if ([controllerName isEqualToString:CONTROLLER_ACTIVITY_DETAIL]) { // 展示型活动

            ActivityDetailViewController *ctr = [[ActivityDetailViewController alloc] initWithActivityId:[extra1 intValue]];
            [app pushViewController:ctr animation:ViewSwitchAnimationBounce];
        }
        else if ([controllerName isEqualToString:CONTROLLER_ACTIVITY_ROB_TICKET]) { // 抢票活动
            
            TicketActivityViewController *ctr = [[TicketActivityViewController alloc] initWithActivityId:[extra1 intValue]];
            [app pushViewController:ctr animation:ViewSwitchAnimationBounce];
        }
        else if ([controllerName isEqualToString:CONTROLLER_ACTIVITY_ROB_COUPON]) { // 抢码活动
            
            CouponActivityViewController *ctr = [[CouponActivityViewController alloc] initWithActivityId:[extra1 intValue]];
            [app pushViewController:ctr animation:ViewSwitchAnimationBounce];
        }
        else if ([controllerName isEqualToString:CONTROLLER_MOVIE_DETAIL]) { // 影片详情
            
            int tabIndex = 0;
            if (![extra2 isEqual:nil] && ![extra2 isEqualToString:@""] && ![extra2 isEqualToString:@"null"]) {
                tabIndex = [extra2 intValue];
                if (tabIndex > 0) {
                    tabIndex -= 1;
                }
            }
            
            MovieDetailViewControllerNew *ctr = [[MovieDetailViewControllerNew alloc] initCinemaListForMovie:[extra1 intValue]];
            ctr.segmentIndexNum = tabIndex;
            [app pushViewController:ctr animation:ViewSwitchAnimationBounce];
        }
        else if ([controllerName isEqualToString:CONTROLLER_CINEMA_DETAIL]) { // 影院详情
            
            int tabIndex = 0;
            if (![extra2 isEqual:nil] && ![extra2 isEqualToString:@""] && ![extra2 isEqualToString:@"null"]) {
                tabIndex = [extra2 intValue];
                if (tabIndex > 0) {
                    tabIndex -= 1;
                }
            }
            
            CinemaDetailViewController *ctr = [[CinemaDetailViewController alloc] initWithCinema:[extra1 intValue]];
            ctr.segmentIndexNum = tabIndex;
            if (![extra3 isEqual:nil] && ![extra3 isEqualToString:@""] && ![extra3 isEqualToString:@"null"]) {
                ctr.movieId = [extra3 intValue];
            }
            [app pushViewController:ctr animation:ViewSwitchAnimationBounce];
        }
        else if ([controllerName isEqualToString:CONTROLLER_CHOOSE_SEAT]) { // 选座页面
            
            BuyTicketViewController *ctr = [[BuyTicketViewController alloc] initWithPlanId:extra1];
            ctr.isVip = NO;
            [app pushViewController:ctr animation:ViewSwitchAnimationBounce];
        }
    }
}


+ (NSString *)getOpenViewControllerName:(NSString *)openPageName extra1:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    if ([OPEN_ACTIVITY_DETAIL isEqualToString:openPageName]) { // 活动详情页面
        if (![extra2 isEqual:nil] && ![extra2 isEqualToString:@""] && ![extra2 isEqualToString:@"null"]) {
            if ([@"2" isEqualToString:extra2]) { // 抢票活动
                return CONTROLLER_ACTIVITY_ROB_TICKET;
            }
            else if ([@"3" isEqualToString:extra2]) { // 抢码活动
                return CONTROLLER_ACTIVITY_ROB_COUPON;
            }
        }
        return CONTROLLER_ACTIVITY_DETAIL; // 展示型活动
    }
    else if ([OPEN_MOVIE_DETAIL isEqualToString:openPageName]) { // 影片详情
        return CONTROLLER_MOVIE_DETAIL;
    }
    else if ([OPEN_CINEMA_DETAIL isEqualToString:openPageName]) { // 影院详情
        return CONTROLLER_CINEMA_DETAIL;
    }
    else if ([OPEN_CHOOSE_SEAT isEqualToString:openPageName]) { // 选座页面
        return CONTROLLER_CHOOSE_SEAT;
    }

    return @"";
}


@end



