//
//  ActivityRequest.h
//  CIASMovie
//
//  Created by cias on 2017/3/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityRequest : NSObject
//某个订单支持的活动列表
- (void)requestActivityListParams:(NSDictionary *_Nullable)params
                          success:(nullable void (^)(NSArray *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure;

//使用此活动
- (void)requestUseActivityParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(NSDictionary *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure;

@end
