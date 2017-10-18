//
//  UIColor+Hex.h
//  KoMovie
//
//  Created by wuzhen on 15/7/29.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//
//  从十六进制字符串获取颜色，color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
//

#import <UIKit/UIKit.h>

#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:1.0f]


@interface UIColor (Hex)


+ (UIColor *)colorWithHex:(NSString *)color;
+ (UIColor *)colorWithHex:(NSString *)color a:(CGFloat)alpha;


@end

