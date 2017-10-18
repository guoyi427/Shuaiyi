//
//  KKZTextUtility.h
//  KoMovie
//
//  Created by wuzhen on 16/8/25.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface KKZTextUtility : NSObject
+ (CGSize)measureText:(NSString *)text
                 font:(UIFont *)font;
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

/*
 *会员卡余额多属性样式
 */
+ (NSMutableAttributedString *) getbalanceStrWithString:(NSString *)balanceStr;

+ (NSMutableAttributedString *) getAttributeStr:(NSString *)str withStartRangeStr:(NSString *)startStr  withEndRangeStr:(NSString *)endStr withFormalColor:(UIColor *)formalColor withSpecialColor:(UIColor *)specialColor withFont:(UIFont *)font;

+ (id)readPersonArrayData;



#pragma mark - 获取沙盒目录 -

/**
 获取沙盒Document目录
 
 @return Document目录
 */
+ (NSString *)getDocumentDirectory;

/**
 获取沙盒Library目录
 
 @return Library目录
 */
+ (NSString *)getLibraryDirectory;

/**
 获取沙盒Library/Caches目录
 
 @return Library/Caches目录
 */
+ (NSString *)getCachesDirectory;

/**
 获取沙盒Preference目录
 
 @return Preference目录
 */
+ (NSString *)getPreferenceDirectory;

/**
 获取沙盒Tmp目录
 
 @return Tmp目录
 */
+ (NSString *)getTmpDirectory;

/** 创建cache/xxx   xxx-->huachen/ xincheng/ zhongdu/ baoshan文件夹 */
+ (void)createUserCacheFile;

/** 获取cache/xxx  xxx-->huachen/ xincheng/ zhongdu/ baoshan文件夹路径 */
+ (NSString *)getUserCachePath;

+ (UILabel *) getLabelWithText:(NSString *)titleStr font:(UIFont *)labelFont textColor:(UIColor *)labelColor textAlignment:(NSTextAlignment)alignment;

+ (UILabel *) getLabelWithAttributedText:(NSAttributedString *)titleStr font:(UIFont *)labelFont textColor:(UIColor *)labelColor textAlignment:(NSTextAlignment)alignment;

@end
