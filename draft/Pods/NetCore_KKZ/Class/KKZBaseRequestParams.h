//
//  KKZBaseRequestParams.h
//  NetCore_KKZ
//
//  Created by Albert on 6/22/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求参数加密salt定义
FOUNDATION_EXPORT NSMutableString *  K_REQUEST_ENC_SALT;

@interface KKZBaseRequestParams : NSObject
+ (NSDictionary *)getDecryptParams:(NSDictionary *)params;
@end
