//
//  NSURL+scheme.m
//  OpenPlatform
//
//  Created by shaobin on 6/11/13.
//  Copyright (c) 2013 Alipay. All rights reserved.
//

#import "NSURL+scheme.h"
#import <Foundation/Foundation.h>

@implementation NSURL (scheme)

+(NSURL *)urlWith:(NSString *)schemeStr queryParams:(NSDictionary *)params {
    NSURL *url = [NSURL URLWithString:schemeStr];
    NSString *prefix = url.query ? @"&" : @"?";
    
    NSMutableArray* keyValuePairs = [NSMutableArray array];
    for (NSString* key in [params allKeys]) {
        id value = [params objectForKey:key];
        if(![value isKindOfClass:[NSString class]]) {
            DLog(@"warning: %@ is not NSString Class", value);
        }
        
        CFStringRef escapedStr = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                         (CFStringRef)value,
                                                                         NULL,
                                                                         (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                         kCFStringEncodingUTF8);
        [keyValuePairs addObject:[NSString stringWithFormat:@"%@=%@", key, escapedStr]];
        CFRelease(escapedStr);
    }
    NSString *queryStr = [keyValuePairs componentsJoinedByString:@"&"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", schemeStr, prefix, queryStr];
    return [NSURL URLWithString:urlString];
}

-(NSDictionary *)queryParams {
    if(!self.query) {
        return  nil;
    }
    
    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
    NSArray *keyValuePairs = [self.query componentsSeparatedByString:@"&"];
    for(id kv in keyValuePairs) {
        NSArray *kvPair = [kv componentsSeparatedByString:@"="];
        NSString *key = [kvPair objectAtIndex:0];
        NSString *value = [kvPair objectAtIndex:1];
        CFStringRef origStr =
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                (CFStringRef)(value),
                                                                CFSTR(""),
                                                                kCFStringEncodingUTF8);
        [ret setValue:(__bridge NSString*)(origStr) forKey:key];
        CFRelease(origStr);
    }
    
    return ret;
}
@end
