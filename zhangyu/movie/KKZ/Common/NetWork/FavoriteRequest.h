//
//  FavoriteRequest.h
//  KoMovie
//  用户偏好 设置
//  Created by renzc on 16/9/20.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteRequest : NSObject


/**
 *  查询用户是否想看某影片
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 isWantWatch 是否想看
 *  @param failure 失败回调
 */
- (void)requestQueryWantWatchWithMovieId:(NSInteger)movieId
                   success:(nullable void (^)(BOOL isWantWatch))success
                   failure:(nullable void (^)(NSError * _Nullable err))failure;


/**
 *  用户取消关注某电影
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 isSuccess 是否成功
 *  @param failure 失败回调
 */
- (void)requestUndoWantSeeMovieWithMovieId:(NSInteger)movieId
                      success:(nullable void (^)(BOOL isSuccess))success
                      failure:(nullable void (^)(NSError * _Nullable err))failure;

/**
 *  用户 关注某电影
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 isSuccess 是否成功
 *  @param failure 失败回调
 */
- (void)requestDoWantSeeMovieWithMovieId:(NSInteger)movieId
                        success:(nullable void (^)(BOOL isSuccess))success
                        failure:(nullable void (^)(NSError * _Nullable err))failure;


@end
