//
//  EditProfileChooseView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/24.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"

typedef void (^CAll_BACK)(NSObject *o);

/**************日期选择器****************/
static const CGFloat datePickerHeight = 250.0f;
static const CGFloat commonPickerHeight = 216.0f;

/**************日期选择器工具条**************/
static const CGFloat toolBarHeight = 43.0f;

static const CGFloat leftItemLeft = 20.0f;
static const CGFloat rightItemRight = 20.0f;
static const CGFloat leftItemWidth = 22.0f;
static const CGFloat titleItemWidth = 150.0f;

/**************分割线的高度**************/
static const CGFloat dividerHeight = 0.3f;

@interface EditProfileChooseView : UIView

/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataArr;

/**
 *  需要选择器当前行显示的数据
 */
@property (nonatomic, strong) NSString *dataString;

/**
 *  工具条上的标题
 */
@property (nonatomic, strong) NSString *commonTitleItemString;

/**
 *  显示选择视图
 */
- (void)show;

/**
 *  隐藏选择视图
 */
- (void)close;

/**
 *  block方法传值
 *
 *  @param block
 */
- (void)setMethodBlock:(CAll_BACK)block;

@end
