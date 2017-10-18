//
//  KKZBaseRequestParamsMD5.h
//  CIASMovie
//
//  Created by avatar on 2017/5/9.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>


//请求参数加密salt定义
FOUNDATION_EXPORT NSMutableString *  K_REQUEST_ENC;

@interface KKZBaseRequestParamsMD5 : NSObject

+ (NSDictionary *)getDecryptParams:(NSDictionary *)params withMethod:(NSString *)method withRequestPath:(NSString *)path;

+ (NSDictionary *)getUserInfoDecryptParams:(NSDictionary *)params withMethod:(NSString *)method withRequestPath:(NSString *)path;


@end
