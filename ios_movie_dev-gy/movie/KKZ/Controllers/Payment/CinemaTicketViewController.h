//
//  排期列表页面
//
//  Created by 艾广华 on 16/4/11.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

@class CinemaDetail;
@interface CinemaTicketViewController : CommonViewController

/**
 *  影院名字
 */
@property (nonatomic, strong) NSString *cinemaName;

/**
 *  影院地址
 */
@property (nonatomic, strong) NSString *cinemaAddress;

/**
 *  影院Id
 */
@property (nonatomic, copy) NSNumber *cinemaId;

/**
 *  电影Id
 */
@property (nonatomic, copy) NSNumber *movieId;

/**
 *  影院停止卖票时间
 */
@property (nonatomic, strong) NSString *cinemaCloseTicketTime;

/**
 *  初始化的日期时间
 */
@property (nonatomic, strong) NSString *initialSelectedDate;

/**
 *  影院详情
 */
@property (nonatomic, strong) CinemaDetail *cinemaDetail;

@end
