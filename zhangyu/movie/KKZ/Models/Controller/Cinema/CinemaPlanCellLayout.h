//
//  CinemaPlanCellLayout.h
//  KoMovie
//
//  Created by 艾广华 on 16/4/15.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ticket.h"

/***************电影类型************/
static const CGFloat movieTypeFont = 12.0f;

/***************厅数类型************/
static const CGFloat movieHallFont = 11.0f;

/***************VIP价钱标签************/
static const CGFloat priceLabelFont = 17.0f;

/***************折扣价钱标签************/
static const CGFloat discountFont = 12.0f;

/**************当前电影类型最大的宽度************/
static CGFloat currentMaxMovieTypeWidth = 0.0f;

/**************当前折扣价格最大的宽度************/
static CGFloat currentMaxDiscountWidth = 0.0f;

@interface CinemaPlanCellLayout : NSObject

/**
 *  电影类型的尺寸
 */
@property (nonatomic, assign) CGSize movieTypeSize;

/**
 *  电影厅数的尺寸
 */
@property (nonatomic, assign) CGSize movieHallSize;

/**
 *  价钱的尺寸
 */
@property (nonatomic, assign) CGSize priceLabelSize;

/**
 *  排期标签尺寸
 */
@property (nonatomic, assign) CGSize planLableSize;

/**
 *  更新排期Cell上的尺寸
 *
 *  @param ticket
 */
- (void)updateCinemaPlanCellLayout:(Ticket *)ticket;

/**
 *  获取当前电影类型的最大长度
 *
 *  @return
 */
+ (CGFloat)getCurrentMaxMovieTypeWidth;

/**
 *  获取当前折扣价格的最大长度
 *
 *  @return
 */
+ (CGFloat)getCurrentMaxDiscountWidth;

/**
 *  重置所有静态变量的最大长度
 */
+ (void)resetMaxWidthVariable;

@end
