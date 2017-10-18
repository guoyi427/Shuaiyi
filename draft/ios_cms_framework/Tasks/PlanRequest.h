//
//  PlanRequest.h
//  CIASMovie
//
//  Created by hqlgree2 on 29/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanRequest : NSObject

- (void)requestPlanDateListParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSArray *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure;

- (void)requestPlanListParams:(NSDictionary *_Nullable)params
                          success:(nullable void (^)(NSArray *_Nullable data))success
                          failure:(nullable void (^)(NSError *_Nullable err))failure;



@end
