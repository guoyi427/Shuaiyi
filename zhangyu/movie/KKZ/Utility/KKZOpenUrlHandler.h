//
//  KKZOpenUrlHandler.h
//  KoMovie
//
//  Created by wuzhen on 15/5/8.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface KKZOpenUrlHandler : NSObject {
    
}

// 活动详情页面的 Controller
#define OPEN_ACTIVITY_DETAIL @"ActivityDetail"
#define CONTROLLER_ACTIVITY_DETAIL @"ActivityDetailViewController"
#define CONTROLLER_ACTIVITY_ROB_TICKET @"TicketActivityViewController"
#define CONTROLLER_ACTIVITY_ROB_COUPON @"CouponActivityViewController"

// 影片详情页面的 Controller
#define OPEN_MOVIE_DETAIL @"MovieDetail"
#define CONTROLLER_MOVIE_DETAIL @"MovieDetailViewControllerNew"

// 影院详情页面的 Controller
#define OPEN_CINEMA_DETAIL @"CinemaDetail"
#define CONTROLLER_CINEMA_DETAIL @"CinemaDetailViewController"

// 选择座位页面的 Controller
#define OPEN_CHOOSE_SEAT @"ChooseSeat"
#define CONTROLLER_CHOOSE_SEAT @"BuyTicketViewController"

+ (void) handleOpenApplicationUrl:(NSURL *)url appDelegate:(KKZAppDelegate *)app;

@end
