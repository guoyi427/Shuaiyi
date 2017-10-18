//
//  KKZBaseRequestParamsMD5.m
//  CIASMovie
//
//  Created by avatar on 2017/5/9.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "KKZBaseRequestParamsMD5.h"
#import <Category_KKZ/NSStringExtra.h>
#import <AFNetworking/AFURLRequestSerialization.h>

NSMutableString *  K_REQUEST_ENC = nil;

@implementation KKZBaseRequestParamsMD5

+ (NSDictionary *)getDecryptParams:(NSDictionary *)params withMethod:(NSString *)method withRequestPath:(NSString *)path
{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970]*1000;
    [muDic setObject:[NSNumber numberWithDouble:timeStamp] forKey:@"timestamp"];
    unsigned int nonce = arc4random();
    [muDic setObject:[NSNumber numberWithUnsignedInt:nonce] forKey:@"nonce"];
    
    [muDic setValue:ciasTenantId forKey:@"tenantId"];

    [muDic setValue:[DataEngine sharedDataEngine].sessionId forKey:@"accessToken"];
    
    //先对字典进行排序，按照key的大小，升序
    NSArray *allKeyArray = [muDic allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending; // 升序
        //return result == NSOrderedAscending;  // 降序
    }];
    
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [muDic objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
    
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0 ; i < afterSortKeyArray.count; i++) {
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",afterSortKeyArray[i],valueArray[i]];
        [signArray addObject:keyValue];
    }
    
    //signString用于签名的原始参数集合
    NSString *signString = [signArray componentsJoinedByString:@"&"];
    
    NSString *mdStr = [NSString stringWithFormat:@"%@%@?%@%@", method, path, signString, ciasChannelKey];
    DLog(@"待签名字符串:%@", mdStr);
    NSString *toMD5Enc = [[mdStr MD5String] lowercaseString];
    [muDic setObject:toMD5Enc forKey:@"sign"];
    
    return [muDic copy];
}


+ (NSDictionary *)getUserInfoDecryptParams:(NSDictionary *)params withMethod:(NSString *)method withRequestPath:(NSString *)path {
    
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970]*1000;
    [muDic setObject:[NSNumber numberWithDouble:timeStamp] forKey:@"timestamp"];
    
    [muDic setValue:ciasTenantId forKey:@"tenantId"];

    unsigned int nonce = arc4random();
    [muDic setObject:[NSNumber numberWithUnsignedInt:nonce] forKey:@"nonce"];
    
    [muDic setValue:[DataEngine sharedDataEngine].sessionId forKey:@"accessToken"];
    
    //先对字典进行排序，按照key的大小，升序
    NSArray *allKeyArray = [muDic allKeys];
    NSArray *afterSortKeyArray = [allKeyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending; // 升序
        //return result == NSOrderedAscending;  // 降序
    }];
    
    //通过排列的key值获取value
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortsing in afterSortKeyArray) {
        NSString *valueString = [muDic objectForKey:sortsing];
        [valueArray addObject:valueString];
    }
    
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0 ; i < afterSortKeyArray.count; i++) {
        NSString *keyValue = [NSString stringWithFormat:@"%@=%@",afterSortKeyArray[i],valueArray[i]];
        [signArray addObject:keyValue];
    }
    
    //signString用于签名的原始参数集合
    NSString *signString = [signArray componentsJoinedByString:@"&"];
    
    NSString *mdStr = [NSString stringWithFormat:@"%@%@?%@%@", method, path, signString, ciasChannelKey];
    DLog(@"待签名字符串:%@", mdStr);
    NSString *toMD5Enc = [[mdStr MD5String] lowercaseString];
    [muDic setObject:toMD5Enc forKey:@"sign"];
    
    return [muDic copy];
    
    
}

//MARK: 暂不用
NSString * KKZPercentEscapedStringFromString(NSString *string) {
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=~?/";// java 对~转码，iOS适配java转码规则
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}


@end
