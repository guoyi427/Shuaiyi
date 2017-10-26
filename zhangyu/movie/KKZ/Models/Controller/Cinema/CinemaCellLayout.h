//
//  CinemaCellLayout.h
//  KoMovie
//
//  Created by KKZ on 16/4/11.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CinemaDetail;

@interface CinemaCellLayout : NSObject

/**
 *  影院信息
 */
@property(nonatomic, strong) CinemaDetail *cinema;

/**
 *   影院名称
 */
@property(nonatomic, assign) CGRect cinemaNameFrame;

/**
 *  影院地址
 */
@property(nonatomic, assign) CGRect cinemaAddressFrame;

/**
 *  影院特色信息
 */
@property(nonatomic, assign) CGRect cinemaIconsFrame;

/**
 *  影院收藏标示
 */
@property(nonatomic, assign) CGRect cinemaCollectIconFrame;

/**
 *  影院距离
 */
@property(nonatomic, assign) CGRect cinemaDistanceFrame;

/**
 *  影院名称的字体大小
 */
@property(nonatomic, assign) CGFloat nameFont;

/**
 *  影院地址的字体大小
 */
@property(nonatomic, assign) CGFloat addressFont;

/**
 *  影院距离的字体大小
 */
@property(nonatomic, assign) CGFloat distanceFont;

/**
 *  影院活动标题的字体大小
 */
@property(nonatomic, assign) CGFloat activityFont;

/**
 *  影院最低票价的字体大小
 */
@property(nonatomic, assign) CGFloat minPriceFont;

/**
 *  影院特色信息的字体大小
 */
@property(nonatomic, assign) CGFloat iconFont;

/**
 *  cell的高度
 */
@property(nonatomic, assign) CGFloat height;

/**
 *  影院特色信息数组
 */
@property(nonatomic, strong) NSMutableArray *flags;


/**
 *  影院活动标签
 */
@property(nonatomic, assign) CGRect activityTitleFrame;

/**
 *  影院最低票价Frame
 */
@property(nonatomic, assign) CGRect minPriceFrame;

/**
 *  影院最低票价Str
 */
@property(nonatomic, copy) NSString *minPrice;

/**
 *  更新Cinema的Frame
 */
//- (instancetype)updateLayoutModel;

@end
