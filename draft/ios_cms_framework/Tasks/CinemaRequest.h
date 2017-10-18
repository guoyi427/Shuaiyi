//
//  CinemaRequest.h
//  CIASMovie
//
//  Created by cias on 2016/12/29.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaRequest : NSObject

- (void)requestCinemaListParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(NSArray *_Nullable data))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK: 开卡影院列表
- (void)requestOpenCardCinemaListParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(NSDictionary *_Nullable data))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;


@end
