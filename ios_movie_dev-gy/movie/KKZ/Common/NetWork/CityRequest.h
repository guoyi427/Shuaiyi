//
//  CityRequest.h
//  KoMovie
//
//  Created by Albert on 23/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityRequest : NSObject

/**
 查询城市列表

 @param success 成功回调 cities{index : City} cityIndexes<NSString> 索引
 @param failure 失败会掉
 */
- (void)requestCityListSuccess:(nullable void (^)(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes))success
                  failure:(nullable void (^)(NSError * _Nullable err))failure;

/**
 本地加载城市列表
 
 @param success 成功回调 cities{index : City} cityIndexes<NSString> 索引
 @param failure 失败会掉
 */
- (void)loadCityListSuccess:(nullable void (^)(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes))success
                       failure:(nullable void (^)(NSError * _Nullable err))failure;
@end
