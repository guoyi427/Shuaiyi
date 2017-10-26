//
//  排期列表页面的Header View
//
//  Created by 艾广华 on 16/4/11.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaMovieView.h"

@class CinemaDetail;

@interface CinemaHeaderView : UIView

/**
 *  影院名字
 */
@property(nonatomic, strong) NSString *cinemaName;

/**
 *  影院地址
 */
@property(nonatomic, strong) NSString *cinemaAddress;

/**
 *  影院数据模型
 */
@property(nonatomic, strong) CinemaDetail *cinemaDetail;

/**
 *  电影数据模型
 */
@property(nonatomic, strong) NSArray *movieList;

/**
 *  特色信息模型 <String>
 */
@property(nonatomic, strong) NSArray *specilaInfoList;

/**
 *  默认选中的电影Id
 */
@property(nonatomic, copy) NSNumber *movieId;

/**
 *  影院头部高度变化
 */
@property(nonatomic, weak) id<CinemHeaderDelegate> delegate;

@end
