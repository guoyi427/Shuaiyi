//
//  DateFormatter.m
//  phonebook
//
//  Created by da zhang on 11-4-26.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "DateEngine.h"

#define kMon @"周一"
#define kTues @"周二"
#define kWedn @"周三"
#define kThur @"周四"
#define kFri @"周五"
#define kSat @"周六"
#define kSun @"周日"

static DateEngine * _sharedDataFormatter = nil;

@implementation DateEngine

+ (DateEngine *)sharedDateEngine {
    @synchronized(self) {
        if ( _sharedDataFormatter == nil ) {
            _sharedDataFormatter = [[DateEngine alloc] init];
        }
        return _sharedDataFormatter;
    }
}

- (id)init {
	self = [super init];
    
    if (self) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        refreshHeaderDateFormatter = [[NSDateFormatter alloc] init];
        [refreshHeaderDateFormatter setAMSymbol:@"AM"];
        [refreshHeaderDateFormatter setPMSymbol:@"PM"];
        [refreshHeaderDateFormatter setDateStyle:NSDateFormatterShortStyle];
        [refreshHeaderDateFormatter setTimeStyle:NSDateFormatterShortStyle];   
    }

	return self;
}

/*
 NSDateFormatters are not thread safe;
 */
- (NSString *)stringFromDate:(NSDate *)d {
    //copy date
    NSDate *date = nil;//[[NSDate alloc] initWithTimeInterval:0 sinceDate:d];
    date = [NSDate dateWithTimeInterval:0 sinceDate:d];
    
    @synchronized(dateFormatter) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)stringFromDateY:(NSDate *)d {
    //copy date
    NSDate *date = nil;//[[NSDate alloc] initWithTimeInterval:0 sinceDate:d];
    date = [NSDate dateWithTimeInterval:0 sinceDate:d];
    
    @synchronized(dateFormatter) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:date];
    }
}


- (NSString *)stringFromDateYYYYMMDD:(NSDate *)date {
    @synchronized(dateFormatter) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)shortDateStringFromDate:(NSDate *)date {
    @synchronized(dateFormatter) {
        [dateFormatter setDateFormat:@"MM月dd日"];
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)shortDateStringFromDateMdHs:(NSDate *)date {
    @synchronized(dateFormatter) {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        return [dateFormatter stringFromDate:date];
    }
}


- (NSString *)shortDateStringFromDateNYR:(NSDate *)date {
    @synchronized(dateFormatter) {
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)shortLineDateStringFromDate:(NSDate *)date {
    @synchronized(dateFormatter) {
        [dateFormatter setDateFormat:@"MM-dd"];
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)shortTimeStringFromDate:(NSDate *)date {
    @synchronized(dateFormatter) {
        [dateFormatter setDateFormat:@"HH:mm"];
        return [dateFormatter stringFromDate:date];
    }
}

- (NSDate *)dateFromString:(NSString *)string {
    @synchronized(dateFormatter) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        return [dateFormatter dateFromString:string];
    }
}

- (NSDate *)dateFromStringY:(NSString *)string {
    @synchronized(dateFormatter) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        return [dateFormatter dateFromString:string];
    }
}

- (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    @synchronized(dateFormatter) {
        [dateFormatter setDateFormat:format];
        return [dateFormatter stringFromDate:date];
    }
}

- (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    @synchronized(dateFormatter) {
//        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [dateFormatter setDateFormat:format];
        return [dateFormatter dateFromString:string];
    }
}

- (NSString *)refreshHeaderStringFromDate:(NSDate *)date {
    @synchronized(refreshHeaderDateFormatter) {
        return [refreshHeaderDateFormatter stringFromDate:date];
    }
}

- (NSString *)weekDayFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    [components setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger weekDay = [components weekday];
    
    switch (weekDay) {
        case 1:
            return kSun;
        case 2:
            return kMon;
        case 3:
            return kTues;
        case 4:
            return kWedn;
        case 5:
            return kThur;
        case 6:
            return kFri;
        case 7:
            return kSat;
        default:
            return nil;
    }
}

- (NSString *)weekDayXingQiFromDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    [components setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger weekDay = [components weekday];
    switch (weekDay) {
        case 1:
            return @"星期日";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            return nil;
    }
}


- (NSString *)weekDayXingQiFromDateCP:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    [components setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger weekDay = [components weekday];
    switch (weekDay) {
            case 1:
            return @"周日";
            case 2:
            return @"周一";
            case 3:
            return @"周二";
            case 4:
            return @"周三";
            case 5:
            return @"周四";
            case 6:
            return @"周五";
            case 7:
            return @"周六";
        default:
            return nil;
    }
}

- (NSString *)relativeStringFromDate:(NSDate *)date {
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday
                                                                        fromDate:[NSDate date]];
    [todayComponents setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger toWeekDay = [todayComponents weekday];
    
    NSDateComponents *newComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday
                                                                      fromDate:date];
    [newComponents setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger newWeekDay = [newComponents weekday];

    NSString *dayStr = [self stringFromDate:date withFormat:@"MM月dd日"];
    NSString *timeStr = [self stringFromDate:date withFormat:@"HH:mm"];
    float timeInterval = [date timeIntervalSinceNow];
    int day = timeInterval/60/60/24;
    if (day > -2 && day <= 2) {
        NSInteger dayInterVal = newWeekDay - toWeekDay;
        if (day >= 0 && dayInterVal < 0) {
            dayInterVal += 7;
        }        
        switch (dayInterVal) {
            case -1: dayStr = @"昨天"; break;
            case 0: dayStr = @"今天"; break;
            case 1: dayStr = @"明天"; break;
            case 2: dayStr = @"后天"; break;
        }
    }
    return [NSString stringWithFormat:@"%@ %@", dayStr, timeStr];
}


//08-10 周三 13:56
- (NSString *)dateWeekTimeStringFromDate:(NSDate *)date
{
    NSString *day = [self shortLineDateStringFromDate:date];
    NSString *week = [self weekDayXingQiFromDateCP:date];
    NSString *time = [self shortTimeStringFromDate:date];
    return [NSString stringWithFormat:@"%@ %@ %@",day, week, time];
}


- (NSString *)relativeDayMMDDStringFromDate:(NSDate *)date {
    NSString *prefix = nil;
    NSString *dayStr = [self stringFromDate:date
                                 withFormat:@"MM月dd日"];
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday
                                                                        fromDate:[NSDate date]];
    [todayComponents setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger toWeekDay = [todayComponents weekday];
    
    NSDateComponents *newComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday
                                                                      fromDate:date];
    [newComponents setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger newWeekDay = [newComponents weekday];
    float timeInterval = [date timeIntervalSinceNow];
    int day = timeInterval/60/60/24;
    if (day > -2 && day <= 2) {
        NSInteger dayInterVal = newWeekDay - toWeekDay;
        switch (dayInterVal) {
            case -1: prefix = @"昨天"; break;
            case 0: prefix = @"今天"; break;
            case 1: prefix = @"明天"; break;
            case 2: prefix = @"后天"; break;
        }
    }
    if (prefix) {
        return [NSString stringWithFormat:@"%@ %@",prefix,dayStr];
    }
    return [NSString stringWithFormat:@"%@",dayStr];
}


- (NSString *)relativeDayMMDDStringFromDateY:(NSDate *)date {
    NSString *prefix = nil;
    NSString *dayStr = [self stringFromDate:date
                                 withFormat:@"MM月dd日"];
    float timeInterval = [date timeIntervalSinceNow];
    int day = (timeInterval + (60 * 60 * 24))/60/60/24;
    if (day > -2 && day <= 2) {
        switch (day) {
            case -1: prefix = @"昨天"; break;
            case 0: prefix = @"今天"; break;
            case 1: prefix = @"明天"; break;
            case 2: prefix = @"后天"; break;
        }
    }
    if (prefix) {
        return [NSString stringWithFormat:@"%@ %@",prefix,dayStr];
    }
    return [NSString stringWithFormat:@"%@",dayStr];
}



- (NSString *)relativeDayMMDDStringFromDateCP:(NSDate *)date {
    NSString *prefix = nil;
    NSString *dayStr = [self stringFromDate:date
                                 withFormat:@"M-d"];
    float timeInterval = [date timeIntervalSinceNow];
    int day = (timeInterval + (60 * 60 * 24))/60/60/24;
    if (day > -2 && day <= 2) {
        switch (day) {
                case -1: prefix = @"昨天"; break;
                case 0: prefix = @"今天"; break;
                case 1: prefix = @"明天"; break;
                case 2: prefix = @"后天"; break;
        }
    }else if(day > 2 && day < 7){
    
        prefix = [self weekDayXingQiFromDateCP:date];
    
    }
    if (prefix) {
        return [NSString stringWithFormat:@"%@ %@",prefix,dayStr];
    }
    return [NSString stringWithFormat:@"%@",dayStr];
}

/**
 影迷卡的转日期格式
 
 @param date 时间
 @return 格式化后的时间
 */
- (NSString *)relativeDayMMDDStringCinephileFromDateCP:(NSDate *)date {
    NSString *prefix = nil;
    NSString *dayStr = [self stringFromDate:date
                                 withFormat:@"M-d"];
    float timeInterval = [date timeIntervalSinceNow];
    int day = (timeInterval + (60 * 60 * 24))/60/60/24;
    if (day > -2 && day <= 1) {
        switch (day) {
            case -1: prefix = @"昨天"; break;
            case 0: prefix = @"今天"; break;
            case 1: prefix = @"明天"; break;
        }
    }else if(day > 1 && day < 7){
        
        prefix = [self weekDayXingQiFromDateCP:date];
        
    }
    if (prefix) {
        return [NSString stringWithFormat:@"%@ %@",prefix,dayStr];
    }
    return [NSString stringWithFormat:@"%@",dayStr];
}

- (NSString *)relativeDateStringFromDate:(NSDate *)date {
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday
                                                                        fromDate:[NSDate date]];
    [todayComponents setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger toWeekDay = [todayComponents weekday];
    
    NSDateComponents *newComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday
                                                                      fromDate:date];
    [newComponents setTimeZone:[NSTimeZone systemTimeZone]];
    NSInteger newWeekDay = [newComponents weekday];
    
    NSString *dayStr = nil;//[self stringFromDate:date withFormat:@"MM月dd日"];
    float timeInterval = [date timeIntervalSinceNow];
    int day = timeInterval/60/60/24;
    if (day > -2 && day <= 2) {
        NSInteger dayInterVal = newWeekDay - toWeekDay;
        if (day >= 0 && dayInterVal < 0) {
            dayInterVal += 7;
        }
        switch (dayInterVal) {
            case -1: dayStr = @"昨天"; break;
            case 0: dayStr = @"今天"; break;
            case 1: dayStr = @"明天"; break;
            case 2: dayStr = @"后天"; break;
        }
    }else {
        dayStr = @"";
    }
    return dayStr;
}

- (NSString *)formattedStringFromDate:(NSDate *)d {
	if (!d) return @"";
    
    //copy date
    NSDate *date = [NSDate dateWithTimeInterval:0 sinceDate:d];
	
	NSTimeInterval timeInterval = [date timeIntervalSinceNow];
	NSInteger minute = fabs(timeInterval / 60);
	
//    DLog(@"now:%@ -- date:%@ -- timeinterval1:%f -- timeinterval2:%f",
//         [NSDate date], date, timeInterval, [date timeIntervalSinceDate:[NSDate date]]);
    
	if (minute < 60) {
        if (minute <1) return @"刚刚";
		return [NSString stringWithFormat:@"%d分钟前",(int)(minute <= 1? 1: minute)];
	} else {
        NSInteger hour = (minute / 60);
        if (hour < 24) {
            return [NSString stringWithFormat:@"%d小时前",(int)(hour<=1? 1: hour)];
        } else {
            NSInteger day = (hour / 24);
            if (day < 7) {
                return [NSString stringWithFormat:@"%d天前",(int)(day<=1? 1: day)];
            } else if ( day >= 7 && day < 30) {
                NSInteger week = (day / 7);
                return [NSString stringWithFormat:@"%d周前",(int)(week<=1? 1: week)];
            } else {
                NSInteger month = (day / 30);
                if (month < 12) {
                    return [NSString stringWithFormat:@"%d月前",(int)(month<=1? 1: month)];
                } else {
                    return [self stringFromDate:date withFormat:@"MM月dd日 HH:mm"];
                }
            }
        }
    }
}





- (NSString *)formattedStringFromDateNew:(NSDate *)d {
    if (!d) return @"";
    
    //copy date
    NSDate *date = [NSDate dateWithTimeInterval:0 sinceDate:d];
    
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    NSInteger minute = fabs(timeInterval / 60);
    
    //    DLog(@"now:%@ -- date:%@ -- timeinterval1:%f -- timeinterval2:%f",
    //         [NSDate date], date, timeInterval, [date timeIntervalSinceDate:[NSDate date]]);
    
    
    NSDate* now = [NSDate date];
    NSDateComponents *componentNow = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                    | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitHour
                                                                   fromDate:now];
    
    NSDateComponents *componentD = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                    | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitHour
                                                                   fromDate:d];
    NSInteger yearNow = [componentNow year];
    NSInteger yearD = [componentD year];
    
    if(yearNow - yearD > 0){
      return [self stringFromDate:date withFormat:@"yyyy-MM-dd"];
    }
    else{
        if (minute < 60) {
            if (minute <1) return @"刚刚";
            return [NSString stringWithFormat:@"%d分钟前",(int)(minute <= 1? 1: minute)];
        }
        else {
            NSInteger hour = (minute / 60);
            if (hour < 24) {
                return [NSString stringWithFormat:@"%d小时前",(int)(hour<=1? 1: hour)];
            } else {
                NSInteger day = (hour / 24);
                if (day < 3) {
                    return [NSString stringWithFormat:@"%d天前",(int)(day<=1? 1: day)];
                }else {
                    return [self stringFromDate:date withFormat:@"MM-dd"];
                    
                }
            }
        }
    }

}



- (NSString *)countDownStringFromDate:(NSDate *)date {
    int timeInterval = [date timeIntervalSinceNow];
    
    if (timeInterval<0) {
        return [self stringFromDate:date withFormat:@"MM/dd HH:mm"];
    } else {
        int hour = timeInterval/3600;
        int min = (timeInterval%3600)/60;
        int sec = (timeInterval%3600)-min*60;
        return [NSString stringWithFormat:@"%02d时%02d分%02d秒", hour, min, sec];
    }
}

- (float)hourFromTime:(NSDate *)date apm:(BOOL)isAPM {
    if (!date) return 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                               fromDate:date];
    
    float hour = components.hour%(isAPM? 12: 24) + components.minute/60.0;
    return (hour == 0? (isAPM? 12: 24): hour);
}

- (float)minuteFromTime:(NSDate *)date {
    if (!date) return 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                               fromDate:date];
    return components.minute;
}

- (NSInteger)yearFromTime:(NSDate *)date {
    if (!date) return 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:date];
    return components.year;
}

/**
 *  获取月份
 *
 *  @param date 日期
 *
 *  @return 月份
 */
- (NSInteger)monthFromTime:(NSDate *)date {
    if (!date) return 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:date];
    return components.month;
}

/**
 *  获取 日
 *
 *  @param date 日期
 *
 *  @return 日
 */
- (NSInteger)dayFromTime:(NSDate *)date {
    if (!date) return 0;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date];
    return components.day;
}

- (NSDate *)timeFromHour:(float)hour withBaseDate:(NSDate *)baseDate {
    int theHour = (int)hour;
    int theMinute = (hour - theHour)*60;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                    | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:baseDate];
    components.hour = theHour;
    components.minute = theMinute;
    components.second = 0;
    
    return [calendar dateFromComponents:components];
}

- (BOOL)compareDay:(NSDate *)theDay withDay:(NSDate *)anotherDay {
	if (theDay == nil || anotherDay == nil) return NO;
	NSDateComponents *theDayCompon = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay 
                                                                     fromDate:theDay];
	
	NSDateComponents *anotherDayCompon = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay 
                                                                         fromDate:anotherDay];

    return ([theDayCompon year]==[anotherDayCompon year]) &&
    ([theDayCompon month]==[anotherDayCompon month]) &&
    ([theDayCompon day]==[anotherDayCompon day]);
}

- (NSInteger)getDaysNumFromYear:(NSInteger)theYear andMonth:(NSInteger)theMonth {
	switch (theMonth) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			return 31;
		case 2: {
			if ( (theYear%4==0 && theYear%100!=0)|| (theYear%400==0) ) return 29;
			else return 28;
            
		}
		default:
			return 30;
	}
}

- (NSDate *)getDayNearDay:(NSDate *)theDay withDayInterval:(NSInteger)dayInterval {
    
	NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear 
                                    | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitHour 
                                                                   fromDate:theDay];
	NSInteger year = [components year];	
	NSInteger month = [components month];
	NSInteger day = [components day];
	
    NSInteger interval = 1, count = dayInterval;
    if (dayInterval < 0) {
        interval = -1;
        count *= -1;
    }
    for (int i = 0; i<count; i++) {
        if ( day==1 ) {
            if (interval == -1) {
                if ( month == 1 ) {
                    year --;
                    month = 12;
                    day = 31;
                } else {
                    month --;
                    day = [self getDaysNumFromYear:year andMonth:month];
                }
                
            } else day ++;
        } else if ( day==[self getDaysNumFromYear:year andMonth:month] ) {
            if (interval == 1) {
                if ( month == 12 ) {
                    year ++;
                    month = 1;
                    day = 1;
                } else {
                    month ++;
                    day = 1;
                }
                
            } else day --;
        } else day += interval;
    }
    
    [components setYear:year];
	[components setMonth:month];
	[components setDay:day];
    [components setHour:0];
    [components setMinute:1];
	
	return  [[NSCalendar currentCalendar] dateFromComponents:components];
}




- (NSDate *)getDayNearDayNew:(NSDate *)theDay withDayInterval:(NSInteger)dayInterval {
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                    | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitHour
                                                                   fromDate:theDay];

    NSInteger day = [components day];
    
    day += dayInterval;
    [components setDay:day];
    
    return  [[NSCalendar currentCalendar] dateFromComponents:components];
}


- (NSInteger)calDayIntervalBetweenDay:(NSDate *)theDay andDay:(NSDate *)anotherDay {
    NSTimeInterval time=[theDay timeIntervalSinceDate:anotherDay];
    int days=((int)time)/(3600*24);
    return  days;
//	NSInteger dayInterval = 0;
//	NSDate *tempDay;
//	if ([theDay timeIntervalSinceDate:anotherDay]<=0) {
//		tempDay = theDay;
//		while (YES) {
//			if ([self compareDay:tempDay withDay:anotherDay]) 
//                return dayInterval*-1;
//			tempDay = [self getDayNearDay:tempDay withDayInterval:1];
//			dayInterval ++;
//		}
//	} else {
//		tempDay = anotherDay;
//		while (YES) {
//			if ([self compareDay:tempDay withDay:theDay]) 
//                return dayInterval;
//			tempDay = [self getDayNearDay:tempDay withDayInterval:1];
//			dayInterval ++;
//		}
//	}
//	return 0;
}


-(NSInteger)compareDate:(NSDate *)date{
//    //1
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
//    NSDate *today = [cal dateFromComponents:components];
//    components = [cal components:(NSEraCalendarUnit|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
//    NSDate *otherDate = [cal dateFromComponents:components];
//    if([today isEqualToDate:otherDate]) {
//        return @"今天";
//    }
    
    //2
    NSDate * today = [NSDate date];
    NSDate * tommorrow = [NSDate dateWithTimeIntervalSinceNow:86400];
    NSDate * aftertommorrow = [NSDate dateWithTimeIntervalSinceNow:86400*2];
    NSDate * refDate = date;
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today descriptionWithLocale:[NSLocale currentLocale]] substringToIndex:10];
    NSString * tommorrowString = [[tommorrow descriptionWithLocale:[NSLocale currentLocale]] substringToIndex:10];
    NSString * aftertommorrowString = [[aftertommorrow descriptionWithLocale:[NSLocale currentLocale]] substringToIndex:10];
    NSString * refDateString = [[refDate descriptionWithLocale:[NSLocale currentLocale]] substringToIndex:10];
    
    if ([refDateString isEqualToString:todayString])
    {
        return 0;
    } else if ([refDateString isEqualToString:tommorrowString])
    {
        return 1;
    }
    else if ([refDateString isEqualToString:aftertommorrowString])
    {
        return 2;
    }
    return -1;
    
}

- (NSInteger)calWeekDayIntervalBetweenDay:(NSDate *)theDay andDay:(NSDate *)anotherDay {
    NSTimeInterval time=[theDay timeIntervalSinceDate:anotherDay];
    int days=((int)time)/(3600*24);
    return  days;
	NSInteger dayInterval = 0;
	NSDate *tempDay;
	if ([theDay timeIntervalSinceDate:anotherDay]<=0) {
		tempDay = theDay;
		while (YES) {
			if ([self compareDay:tempDay withDay:anotherDay])
                return dayInterval*-1;
			tempDay = [self getDayNearDay:tempDay withDayInterval:1];
			dayInterval ++;
		}
	} else {
		tempDay = anotherDay;
		while (YES) {
			if ([self compareDay:tempDay withDay:theDay])
                return dayInterval;
			tempDay = [self getDayNearDay:tempDay withDayInterval:1];
			dayInterval ++;
		}
	}
	return 0;
}

- (NSInteger)calDayInWeek:(NSDate *)date{
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  
    NSDate *today = [NSDate date];
    
    NSDateComponents *todaysComponents =
    [gregorian components:NSCalendarUnitWeekOfMonth fromDate:today];
    
    NSUInteger todaysWeek = [todaysComponents weekOfMonth];
    
        
    NSDateComponents *otherComponents =
    [gregorian components:NSCalendarUnitWeekOfMonth fromDate:date];
    
    
    NSUInteger anotherWeek = [otherComponents weekOfMonth];
    
    if(todaysWeek==anotherWeek){
        return 0;
    }else if(todaysWeek+1==anotherWeek){
        return 1;
    }
    return -1;
}

-(NSString *)getAstroWithMonth:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                    | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitMinute | NSCalendarUnitHour
                                                                   fromDate:date];
	NSInteger month = [components month];
	NSInteger day = [components day];
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (month<1||month>12||day<1||day>31){
        return nil;
    }
    if(month==2 && day>29)
    {
        return nil;
    }else if(month==4 || month==6 || month==9 || month==11) {
        if (day>30) {
            return nil;
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(month*2-(day < [[astroFormat substringWithRange:NSMakeRange((month-1), 1)] intValue] - (-19))*2,2)]];
    return result;
}

/**
 *  英语月份 e.g. december
 *
 *  @param date 日期
 *
 *  @return 月份
 */
- (NSString *)enMonth:(NSDate *)date
{
    
    NSDateFormatter *dateFormatterEn = [[NSDateFormatter alloc]init];
    dateFormatterEn.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSInteger monthI = [self monthFromTime:date];
    
    NSString *month = nil;
    
    if (monthI <= dateFormatterEn.monthSymbols.count && monthI >= 0) {
        
        month = dateFormatterEn.monthSymbols[monthI - 1];
    }
    
    return month;
}

@end

