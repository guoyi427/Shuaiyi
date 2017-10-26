//
//  ViewUtility.m
//  KoMovie
//
//  Created by wuzhen on 15/7/15.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "Utility.h"


@implementation Utility



/**
 * 判断 NSString 是否为空。
 */
+ (BOOL)isEmptyText:(NSString *)text {

    if ([text isEqual:nil]) {
        return YES;
    }
    if (text.length == 0) {
        return YES;
    }
    if ([text isEqualToString:@"null"]) {
        return YES;
    }
    if ([text isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([text isEqualToString:@"<null>"]) {
        return YES;
    }
    return NO;
}



@end

