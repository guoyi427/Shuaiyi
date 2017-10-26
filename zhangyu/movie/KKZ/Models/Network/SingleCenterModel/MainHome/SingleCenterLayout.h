//
//  SingleCenterLayout.h
//  KoMovie
//
//  Created by 艾广华 on 16/1/15.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SingleCenterModel.h"

#define TABLEVIEW_CELL_HEIGHT 50

@interface SingleCenterLayout : NSObject

/**
 *  图标的尺寸
 */
@property (nonatomic, assign) CGRect iconFrame;

/**
 *  箭头的尺寸
 */
@property (nonatomic, assign) CGRect arrowFrame;

/**
 *  箭头的图片
 */
@property (nonatomic, strong) UIImage *arrowImg;

/**
 *  分割线尺寸
 */
@property (nonatomic, assign) CGRect sepLineFrame;

/**
 *  标题的尺寸
 */
@property (nonatomic, assign) CGRect titleLabelFrame;

/**
 *  标题的字体
 */
@property (nonatomic, strong) UIFont *titleFont;

/**
 *  个数的尺寸
 */
@property (nonatomic, assign) CGRect countLabelFrame;

/**
 *  个数的字体
 */
@property (nonatomic, strong) UIFont *countLabelFont;

/**
 *  更新自动布局对象
 *
 *  @param model
 */
- (void)updateLayoutModel:(SingleCenterModel *)model;

@end
