//
//  ProductRequest.h
//  CIASMovie
//
//  Created by cias on 2017/3/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductRequest : NSObject
//卖品列表
- (void)requestProductListParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(NSDictionary *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure;

@end
