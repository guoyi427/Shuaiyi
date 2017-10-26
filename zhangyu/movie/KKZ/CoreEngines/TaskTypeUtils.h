//
//  TaskTypeUtils.h
//  KoMovie
//
//  Created by zhoukai on 13-12-2.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//输出 枚举TaskType 字符串

#import <Foundation/Foundation.h>

@interface TaskTypeUtils : NSObject

+(NSString *)stringWithTaskType:(TaskType)taskType;


+(void)printCGRect:(CGRect)rect;
+(void)printCGRect:(CGRect)rect withString:(NSString*)str;
+(void)printCGPoint:(CGPoint)point;
+(void)printCGPoint:(CGPoint)point withString:(NSString*)str;

@end
