//
//  DateFormatter.h
//  phonebook
//
//  Created by da zhang on 11-4-26.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double DateEngine_KKZVersionNumber;

//! Project version string for DateEngine_KKZ.
FOUNDATION_EXPORT const unsigned char DateEngine_KKZVersionString[];

@interface DateEngine : NSObject {
    NSDateFormatter *dateFormatter;
    NSDateFormatter *refreshHeaderDateFormatter;
}

+ (DateEngine *)sharedDateEngine;
//周三
- (NSString *)weekDayFromDate:(NSDate *)date;
//星期三
- (NSString *)weekDayXingQiFromDate:(NSDate *)date;
//今天 13:39
- (NSString *)relativeStringFromDate:(NSDate *)date;

//08-10 周三 13:56
- (NSString *)dateWeekTimeStringFromDate:(NSDate *)date;

/**
 *  根据日期返回字符串(例如:昨天 xx月xx日，前面的名字只能是昨天，今天，明天，其它的情况前面都不显示)  注：只显示本周内的
 *
 *  @param date 日期对象
 *
 *  @return
 */
- (NSString *)relativeDayMMDDStringFromDate:(NSDate *)date;

/**
 *  根据日期返回字符串(例如:昨天 xx月xx日，前面的名字只能是昨天，今天，明天，其它的情况前面都不显示)
 *
 *  @param date 日期对象
 *
 *  @return
 */
- (NSString *)relativeDayMMDDStringFromDateY:(NSDate *)date;

- (NSString *)relativeDateStringFromDate:(NSDate *)date;
- (NSInteger)compareDate:(NSDate *)date;
- (NSString *)stringFromDate:(NSDate *)date;
- (NSString *)stringFromDateY:(NSDate *)d;
- (NSString *)stringFromDateYYYYMMDD:(NSDate *)date;
- (NSString *)shortDateStringFromDate:(NSDate *)date;
- (NSString *)shortLineDateStringFromDate:(NSDate *)date;
- (NSString *)shortTimeStringFromDate:(NSDate *)date;

/**
 *  yyyy-MM-dd HH:mm:ss
 */
- (NSDate *)dateFromString:(NSString *)string;

/**
 *  yyyy-MM-dd
 */
- (NSDate *)dateFromStringY:(NSString *)string;

- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
//刚刚 分钟前
- (NSString *)formattedStringFromDate:(NSDate *)date;
- (NSString *)countDownStringFromDate:(NSDate *)date;

- (NSString *)shortDateStringFromDateMdHs:(NSDate *)date;

- (NSString *)refreshHeaderStringFromDate:(NSDate *)date;

- (float)hourFromTime:(NSDate *)date apm:(BOOL)isAPM;
- (float)minuteFromTime:(NSDate *)date;
- (NSInteger)yearFromTime:(NSDate *)date;
/**
 *  获取月份
 *
 *  @param date 日期
 *
 *  @return 月份
 */
- (NSInteger)monthFromTime:(NSDate *)date;
/**
 *  获取 日
 *
 *  @param date 日期
 *
 *  @return 日
 */
- (NSInteger)dayFromTime:(NSDate *)date;
- (NSDate *)timeFromHour:(float)hour withBaseDate:(NSDate *)baseDate;
- (NSDate *)getDayNearDay:(NSDate *)theDay withDayInterval:(NSInteger)dayInterval;

- (BOOL)compareDay:(NSDate *)theDay withDay:(NSDate *)anotherDay;
- (NSInteger)calDayIntervalBetweenDay:(NSDate *)theDay andDay:(NSDate *)anotherDay;
- (NSInteger)calWeekDayIntervalBetweenDay:(NSDate *)theDay andDay:(NSDate *)anotherDay;

- (NSInteger)calDayInWeek:(NSDate *)date;

- (NSString *)getAstroWithMonth:(NSDate *)date;

- (NSString *)shortDateStringFromDateNYR:(NSDate *)date;
- (NSString *)formattedStringFromDateNew:(NSDate *)d;

- (NSDate *)getDayNearDayNew:(NSDate *)theDay withDayInterval:(NSInteger)dayInterval;
- (NSString *)relativeDayMMDDStringFromDateCP:(NSDate *)date;

/**
 影迷卡的转日期格式

 @param date 时间
 @return 格式化后的时间
 */
- (NSString *)relativeDayMMDDStringCinephileFromDateCP:(NSDate *)date;
- (NSString *)weekDayXingQiFromDateCP:(NSDate *)date;

/**
 *  英语月份 e.g. december
 *
 *  @param date 日期
 *
 *  @return 月份
 */
- (NSString *)enMonth:(NSDate *)date;

@end

