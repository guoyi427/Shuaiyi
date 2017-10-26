//
//  NSString+QueryURL.h
//  KoMovie
//
//  Created by 艾广华 on 16/3/2.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *paramURL = @"paramURL";
static NSString *parameter = @"parameter";

@interface NSString (QueryURL)

/**
 *  获取URL的参数和请求的地址
 *
 *  @return
 */
- (NSMutableDictionary *)getParams;

@end
