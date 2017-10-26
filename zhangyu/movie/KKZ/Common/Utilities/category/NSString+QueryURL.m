//
//  NSString+QueryURL.m
//  KoMovie
//
//  Created by 艾广华 on 16/3/2.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "NSString+QueryURL.h"

@implementation NSString (QueryURL)

- (NSMutableDictionary *)getParams {
    NSString *original = [self  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    NSArray *urlArrays = [original componentsSeparatedByString:@"?"];
    [paramsDic setValue:urlArrays[0] forKey:paramURL];
    /*
     pay_mark =
     {"clientIp":"192.168.18.161","clientMac":"4C-BB-58-81-FE-A1"}
     */
    [paramsDic setValue:urlArrays[1] forKey:parameter];
//    NSArray *parames = [urlArrays[1] componentsSeparatedByString:@"&"];
//    for (NSString *valueString in parames) {
//        NSArray *keyValues = [valueString componentsSeparatedByString:@"="];
//        NSString *value = keyValues[1];
//        [paramsDic setValue:value
//                     forKey:keyValues[0]];
//    }
    return paramsDic;
}

@end
