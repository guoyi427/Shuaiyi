//
//  KKZBaseRequestParams.m
//  NetCore_KKZ
//
//  Created by Albert on 6/22/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "KKZBaseRequestParams.h"
#import <Category_KKZ/NSStringExtra.h>
#import <AFNetworking/AFURLRequestSerialization.h>

NSMutableString *  K_REQUEST_ENC_SALT = nil;

@implementation KKZBaseRequestParams

+ (NSDictionary *)getDecryptParams:(NSDictionary *)params
{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970]*1000;
    [muDic setObject:[NSNumber numberWithDouble:timeStamp] forKey:@"time_stamp"];
    
    NSArray *allValues = [muDic allValues];
    NSMutableArray *allValueStings = [NSMutableArray arrayWithCapacity:allValues.count];
    for (id value in allValues) {
        if ([value isKindOfClass:[NSString class]]) {
            [allValueStings addObject:value];
        }else if ([value isMemberOfClass:[NSValue class]]){
            [allValueStings addObject:[value stringValue]];
        }
    }
    
   // NSArray *sortedValues = [allValueStings sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray *sortedKeys =[[muDic allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    
    NSArray *sortedValues = [muDic objectsForKeys:sortedKeys notFoundMarker:[NSNull null]];
    
    
    NSString * result = [[sortedValues valueForKey:@"description"] componentsJoinedByString:@""];
    if (K_REQUEST_ENC_SALT) {
        result = [NSString stringWithFormat:@"%@%@",result, K_REQUEST_ENC_SALT];
    }
    //由于server对于Percent-encoding没有遵循RFC 3986（"~"并不在RFC 3986保留字符内，但server却把它认定为特殊字符）需要编码处理。
    //  不可在外部对～进行编码，AFPercentEscapedStringFromString()会对 "%7E" 进行二次encode
//    result = [result stringByReplacingOccurrencesOfString:@"~" withString:@"%7E"];
    
    NSString *toMD5Enc = [[KKZPercentEscapedStringFromString(result) MD5String] lowercaseString];
    [muDic setObject:toMD5Enc forKey:@"enc"];
    
    return [muDic copy];
}

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
