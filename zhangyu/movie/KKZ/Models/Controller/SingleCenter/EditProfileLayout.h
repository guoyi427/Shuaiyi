//
//  EditProfileLayout.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/23.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

/*****************文本cell的标题****************/
static const CGFloat textCellTitleTop = 18.0f;
static const CGFloat textCellTitlelHeight = 16.0f;
static const CGFloat textCellTitleWidth = 100.0f;
static const CGFloat textCellTitleLeft = 15.0f;

/*****************文本cell的子标题****************/
static const CGFloat textCellDetailTitleTop = 15.0f;
static const CGFloat textCellDetailTitleRight = 10.0f;
static const CGFloat textCellDetailTitleBottom = 76.0f;

/*****************文本cell的右箭头****************/
static const CGFloat textCellArrowImgRight = 15.0f;

@interface EditProfileLayout : NSObject

/**
 *  文本cell的高度
 */
@property (nonatomic, assign) CGFloat textCellHeight;

/**
 *  文本cell的子标题尺寸
 */
@property (nonatomic, assign) CGRect textCellDetailTitleFrame;

/**
 *  文本cell的箭头尺寸
 */
@property (nonatomic, assign) CGRect textCellArrowFrame;

/**
 *  文本cell的箭头图片
 */
@property (nonatomic, strong) UIImage *textCellArrowImg;

/**
 *  文本cell的副标题字体
 */
@property (nonatomic, strong) UIFont *textCellDetailTitleFont;

/**
 *  计算文本CELL的尺寸
 *
 *  @param frame
 */
- (void)caculationLayoutFrame:(UserInfo *)model;

@end
