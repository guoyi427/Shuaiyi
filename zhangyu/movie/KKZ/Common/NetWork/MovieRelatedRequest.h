//
//  MovieRelatedRequest.h
//  KoMovie
//  电影相关 查询
//  Created by renzc on 16/9/20.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieRelatedRequest : NSObject

/**
 *  查询某电影的周边
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 @hobbyList: 包含对象类型 [MovieHobbyModel class]
 *  @param failure 失败回调
 */
- (void) requestHobbiesForMovieWithMovieId:(NSInteger)movieId
               success:(nullable void (^)(NSArray *_Nullable hobbyList))success
               failure:(nullable void (^)(NSError * _Nullable err))failure;


/**
 *  查询电影明星（导演、主演、配角等）
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 @actorList: 包含对象类型 [Actor class]
 *  @param failure 失败回调
 */
- (void) requestActorListForMovieWithMovieId:(NSInteger)movieId
                        success:(nullable void (^)(NSArray *_Nullable actorList))success
                        failure:(nullable void (^)(NSError * _Nullable err))failure;


/**
 *  查询某明星的 电影列表
 *
 *  @param starId  明星id 必填
 *  @param success 成功回调 @movieList 包含对象类型 [Movie class]
 *  @param failure 失败回调
 */
- (void) requestMovieListForActorWithStarId:(NSInteger)starId
                          success:(nullable void (^)(NSArray *_Nullable movieList))success
                          failure:(nullable void (^)(NSError * _Nullable err))failure;


@end
