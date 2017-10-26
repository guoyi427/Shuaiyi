//
//  Parser.h
//  basic
//
//  Created by zhang da on 14-6-6.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parser : NSObject

+ (NSString *)parseString:(id)value;
+ (NSDate *)parseDate:(id)value format:(NSString *)format;
+ (NSNumber *)parseNumber:(id)value;

@end
