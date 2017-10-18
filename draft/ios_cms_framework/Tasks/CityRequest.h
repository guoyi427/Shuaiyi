//
//  CityRequest.h
//  CIASMovie
//
//  Created by hqlgree2 on 29/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityRequest : NSObject
//返回城市数组，不带index
- (void)requestCityListParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(NSArray *_Nullable data))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;

//返回index
- (void)requestCityListSuccess:(nullable void (^)(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes))success
                       failure:(nullable void (^)(NSError * _Nullable err))failure;

@end
