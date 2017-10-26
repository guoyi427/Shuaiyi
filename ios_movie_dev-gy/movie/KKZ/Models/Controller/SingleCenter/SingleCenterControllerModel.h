//
//  SingleCenterControllerModel.h
//  KoMovie
//
//  Created by 艾广华 on 16/1/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleCenterControllerModel : NSObject

/**
 *  设置页面上每个cell上的标题
 *
 *  @return
 */
+ (NSArray *)getSettingCellTitleString;

/**
 *  设置页面上每个cell上的子标题显示与否
 *
 *  @return 
 */
+ (NSArray *)getSettingCellDetailShowOrHiden;

/**
 *  设置页面上每个cell上的右边箭头显示与否
 *
 *  @return
 */
+ (NSArray *)getSettingCellArrowShowOrHiden;

/**
 *  设置页面上每个cell上面的section标题区域显示与否
 *
 *  @return
 */
+ (NSArray *)getSettingCellSectionShowOrHiden;

/**
 *  获取页面上每个cell上面的section标题
 *
 *  @return
 */
+ (NSArray *)getSettingCellSectionTitleString;

/**
 *  设置页面上每个cell右边的标题区域显示与否
 *
 *  @return
 */
+ (NSArray *)getSettingCellRightTitleShowOrHiden;

/**
 *  设置页面上每个cell下面的分割线显示与否
 *
 *  @return
 */
+ (NSArray *)getSettingCellSeprateLineShowOrHiden;

@end
