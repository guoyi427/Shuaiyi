//
//  RecommendLayout.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/31.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "friendRecommendModel.h"

/***********白色背景***********************/
static const CGFloat whiteBgOriginX = 10.0f;
static const CGFloat whiteBgHeight = 96.0f;

/***********头像视图***********************/
static const CGFloat avatarOriginX = 14.0f;
static const CGFloat avatarOriginY = 15.0f;
static const CGFloat avatarWidth = 65.0f;

/***********姓名视图***********************/
static const CGFloat nameLabelLeft = 15.0f;
static const CGFloat nameLabeRight = 10.0f;
static const CGFloat nameLabelOriginY = 25.0f;
static const CGFloat nameLabelHeight = 18.0f;

/***********关注视图***********************/
static const CGFloat attentionBtnOriginY = 32.0f;
static const CGFloat attentionBtnHeight = 30.0f;
static const CGFloat attentionBtnWidth = 75.0f;
static const CGFloat attentionBtnRight = 15.0f;

/***********备注视图***********************/
static const CGFloat attentionLblTop = 18.0f;
static const CGFloat attentionLblHeight = 12.0f;

@interface RecommendLayout : NSObject

/**
 *  名字标签字体
 */
@property (nonatomic, strong) UIFont *nameLabelFont;

/**
 *  距离标签字体
 */
@property (nonatomic, strong) UIFont *distanceLabelFont;

/**
 *  距离标签的尺寸
 */
@property (nonatomic, assign) CGRect distanceRect;

/**
 *  名字标签的尺寸
 */
@property (nonatomic, assign) CGRect nameLabelRect;

/**
 *  计算cell上数据的尺寸
 *
 *  @param mode 
 */
- (void)calculateCellLayout:(friendRecommendModel *)model;

@end
