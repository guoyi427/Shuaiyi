//
//  影院详情页面
//
//  Created by 艾广华 on 15/12/8.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "NSObject+Delegate.h"

@class CinemaDetail;

@interface NewCinemaDetailViewController
    : CommonViewController <HandleUrlProtocol>

/**
 *  初始化影院详情页面
 *
 *  @param cinemaId 影院Id
 *
 *  @return
 */
- (id)initWithCinema:(NSInteger)cinemaId;

/**
 *  影院名字
 */
@property(nonatomic, strong) NSString *cinemaName;

/**
 *  影院数据模型
 */
@property(nonatomic, strong) CinemaDetail *cinemaDetail;

/**
 *  特色信息模型<CinemaFeature>
 */
@property(nonatomic, strong) NSArray *specilaInfoList;

@end
