//
//  SeatRequest.h
//  CIASMovie
//
//  Created by cias on 2017/1/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeatRequest : NSObject


- (void)requestSeatListParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(NSArray *_Nullable data))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;


@end
