//
//  MovieRequest.h
//  CIASMovie
//
//  Created by cias on 2016/12/19.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Movie;

@interface MovieRequest : NSObject
/**
 *  请求电影列表
 *
 *  @param params  参数：选填：cinema_id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestMovieListParams:(NSDictionary *_Nullable)params
                       success:(nullable void (^)(NSArray <Movie *> *_Nullable movies))success
                       failure:(nullable void (^)(NSError *_Nullable err))failure;

- (void)requestCinemaMovieListParams:(NSDictionary *_Nullable)params
                       success:(nullable void (^)(NSArray *_Nullable movies))success
                       failure:(nullable void (^)(NSError *_Nullable err))failure;


- (void)requestIncomingMovieDateListParams:(NSDictionary *_Nullable)params
                               success:(nullable void (^)(NSArray *_Nullable movies))success
                               failure:(nullable void (^)(NSError *_Nullable err))failure;

- (void)requestIncomingMovieListParams:(NSDictionary *_Nullable)params
                       success:(nullable void (^)(NSArray *_Nullable movies))success
                       failure:(nullable void (^)(NSError *_Nullable err))failure;

- (void)requestMoviePhotoListParams:(NSDictionary *_Nullable)params
                               success:(nullable void (^)(NSArray *_Nullable moviePhotos))success
                               failure:(nullable void (^)(NSError *_Nullable err))failure;

- (void)requestMovieActorListParams:(NSDictionary *_Nullable)params
                            success:(nullable void (^)(NSArray *_Nullable movieActors))success
                            failure:(nullable void (^)(NSError *_Nullable err))failure;
- (void)requestMovieVideoParams:(NSDictionary *_Nullable)params
                            success:(nullable void (^)(NSArray *_Nullable movieVideo))success
                            failure:(nullable void (^)(NSError *_Nullable err))failure;
//MARK: 影片详情
- (void)requestMovieDetailParams:(NSDictionary *_Nullable)params
                        success:(nullable void (^)(Movie *_Nullable movieDetail))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;

@end
