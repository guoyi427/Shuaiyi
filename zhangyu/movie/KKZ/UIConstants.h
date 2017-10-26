//
//  UIConstants.h
//  KoMovie
//
//  Created by wuzhen on 14/12/9.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#ifndef KoMovie_UIConstants_h
#define KoMovie_UIConstants_h

#import "UIColor+Hex.h"

// ======== 定义字体大小 ======== //
// TODO 作废
#define kTextSizeTitle 14 //      列表标题的文字大小
#define kTextSizeContent 13 // 列表副标题的文字大小
#define kTextSizeSmall 12 // 列表内容的文字大小
#define kTextSizeButton 13 // 小按钮的文字大小
#define kTextSizeButtonLarge 14 // 大按钮（整行）的文字大小

// ======== 定义尺寸 ======== //

#define kDimensMoviePosterVWidth 70 // 电影竖向海报的宽度
#define kDimensMoviePosterVHeight 98 // 电影竖向海报的高度
#define kDimensKotaUserImageSize 45 // 约电影首页横向头像列表头像图片的大小
#define kDimensControllerHPadding 15 // 每个页面左右的页面边距
#define kDimensDividerHeight 0.7 // 分割线的高度
#define kDimensInputHeight 45 // 输入框的高度
#define kDimensButtonHeightLarge 45 // 大按钮（整行）的高度
#define kDimensButtonHeight 25 // 小按钮的高度
#define kDimensCornerNum 2 // 圆角按钮的圆角大小

#define kButtonCornerNum 3

#define kAppScreenBounds [UIScreen mainScreen].bounds //整个APP屏幕尺寸
#define kAppScreenWidth kAppScreenBounds.size.width //整个APP屏幕的宽度
#define kAppScreenHeight kAppScreenBounds.size.height //整个APP屏幕的高度
#define kScreenScale [UIScreen mainScreen].scale //整个APP屏幕的高度

// ======== 定义颜色值 ======== //
#define kDividerColor HEX(@"#E5E5E5") // 分隔线的颜色
#define kGrayBackground HEX(@"#F5F5F5") // 灰色背景色
#define kOrangeColor HEX(@"FF6900") // 橙色

#define kUIColorDivider HEX(@"#E5E5E5") // 分割线的颜色
#define kUIColorGrayBackground HEX(@"#F5F5F5") // 浅灰色背景的颜色
#define kUIColorOrange HEX(@"#FF6900") // 橙色

#define kText36PX 12 //36px字体大小
#define kText39PX 13 //39px字体大小
#define kText45PX 14 //45px字体大小
#define kText48PX 15 //48px字体大小
#define kText51PX 16 //51px字体大小


//一像素
#define K_ONE_PIXEL (1/[UIScreen mainScreen].scale)

// 弹出框动画时长
#define K_POP_ANIMATION_DURATION 0.4
//淡出动画时长
#define K_YN_ANIMATION_DURATION_DISMISS 0.2

#endif
