//
//  KKZTextUtility.h
//  KoMovie
//
//  Created by wuzhen on 16/8/25.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface KKZTextUtility : NSObject

/**
 * 测量文字的Size。
 */
+ (CGSize)measureText:(NSString *)text
                 size:(CGSize)size
                 font:(UIFont *)font;

/**
 * 判断指定的字符串是否为空。
 */
+ (BOOL)isTextEmpty:(NSString *)text;

/**
 * 去掉字符串两端的空格。
 */
+ (NSString *)trimText:(NSString *)text;

@end
