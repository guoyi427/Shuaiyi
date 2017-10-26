//
//  圆角的按钮
//
//  Created by gree2 on 21/11/13.
//  Copyright (c) 2013 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface RoundCornersButton : UIButton

/**
 * 圆角按钮的颜色。
 */
@property (nonatomic, retain) UIColor *backgroundColor;

/**
 * 按钮的填充颜色。
 */
@property (nonatomic, retain) UIColor *fillColor;

/**
 * 按钮边框的宽度。
 */
@property (nonatomic, assign) CGFloat rimWidth;

/**
 * 按钮边框的颜色。
 */
@property (nonatomic, retain) UIColor *rimColor;

/**
 * 圆角的大小。
 */
@property (nonatomic, assign) CGFloat cornerNum;

/**
 * 按钮的标题。
 */
@property (nonatomic, retain) NSString *titleName;

/**
 * 按钮标题的字体大小。
 */
@property (nonatomic, retain) UIFont *titleFont;

/**
 * 按钮标题的字体颜色。
 */
@property (nonatomic, retain) UIColor *titleColor;

/**
 * 按钮的子标题。
 */
@property (nonatomic, retain) NSString *subTitleName;

/**
 * 按钮子标题的字体大小。
 */
@property (nonatomic, retain) UIFont *subTitleFont;

/**
 * 按钮子标题的字体颜色。
 */
@property (nonatomic, retain) UIColor *subTitleColor;

@end
