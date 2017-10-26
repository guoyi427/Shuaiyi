//
//  NSURL+scheme.h
//  OpenPlatform
//
//  Created by shaobin on 6/11/13.
//  Copyright (c) 2013 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (scheme)

/**
 scheme://user:pass@host:1/path/path2/file.html;params?query#fragment
 
 schemeStr: 符合scheme://user:pass@host:1/path/path2/file.html;params?query的
            URL, 不需要的字段可为空
 queryParams: 用来构造query字段，自动做转义处理
 */
+(NSURL *)urlWith:(NSString *)schemeStr queryParams:(NSDictionary *)params;

/**
 scheme://user:pass@host:1/path/path2/file.html;params?query#fragment
 
 把query参数内容以NSDictionary返回，返回结果自动做反转义处理。
 */
-(NSDictionary *)queryParams;

@end
