//
//  NSURLRequest+NSURLRequestWithIgnoreSSL.m
//  KoMovie
//
//  Created by 艾广华 on 16/3/3.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "NSURLRequest+NSURLRequestWithIgnoreSSL.h"

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end
