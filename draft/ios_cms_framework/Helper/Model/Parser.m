//
//  Parser.m
//  basic
//
//  Created by zhang da on 14-6-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "Parser.h"

static NSNumberFormatter *_numberF;
static NSDateFormatter *_dateF;

@implementation Parser

+ (NSNumberFormatter *)numberFormatter {
    if (!_numberF) {
        @synchronized([Parser class]) {
            if (!_numberF) {
                DLog(@"number formatter init");
                _numberF = [[NSNumberFormatter alloc] init];
            }
        }
    }
    return _numberF;
    
}

+ (NSDateFormatter *)dateFormatter {
    if (!_dateF) {
        @synchronized([Parser class]) {
            if (!_dateF) {
                DLog(@"date formatter init");
                _dateF = [[NSDateFormatter alloc] init];
            }
        }
    }
    return _dateF;
}

+ (NSString *)parseString:(id)value {
    if (!value) {
        return @"";
    }
    if (![value isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", value];
    }
    return value;
}

+ (NSDate *)parseDate:(id)value format:(NSString *)format {
    if (![value isKindOfClass:[NSDate class]]) {
        if ([value isKindOfClass:[NSString class]]) {
            if (!format) {
                format = @"yyyy-MM-dd HH:mm:ss";
            }
            NSDateFormatter *myDateF = [[NSDateFormatter alloc] init];
            [myDateF setDateFormat:format];
            return [myDateF dateFromString:value];
        }
    }
    return value;
}

+ (NSNumber *)parseNumber:(id)value {
    if (![value isKindOfClass:[NSNumber class]] && value) {
        
        NSNumberFormatter *myNumberF = [[NSNumberFormatter alloc] init];
        [myNumberF setNumberStyle:NSNumberFormatterDecimalStyle];
        
        return [myNumberF numberFromString:value];
    }
    return value;
}

@end
