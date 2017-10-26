//
//  FavoriteRequest.m
//  KoMovie
//
//  Created by renzc on 16/9/20.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "FavoriteRequest.h"
#import "DataEngine.h"

@implementation FavoriteRequest

/**
 *  查询用户是否想看某影片
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 isWantWatch 是否想看
 *  @param failure 失败回调
 */
- (void)requestQueryWantWatchWithMovieId:(NSInteger)movieId
                                 success:(void (^)(BOOL isWantWatch))success
                                 failure:(void (^)(NSError * _Nullable))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:[DataEngine sharedDataEngine].sessionId? [DataEngine sharedDataEngine].sessionId:@""  forKey:@"session_id"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",movieId] forKey:@"film_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"look_forward_status.chtml")
      parameters:newParams
         success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            success([responseObject[@"tag"] boolValue]);
        }
    } failure:^(NSError * _Nullable err) {
        if (failure) {
            failure(err);
        }
    }];
    
}

/**
 *  用户取消关注某电影
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 isSuccess 是否成功
 *  @param failure 失败回调
 */
- (void)requestUndoWantSeeMovieWithMovieId:(NSInteger )movieId
                                   success:(nullable void (^)(BOOL isSuccess))success
                                   failure:(nullable void (^)(NSError * _Nullable err))failure{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:[DataEngine sharedDataEngine].sessionId? [DataEngine sharedDataEngine].sessionId:@""  forKey:@"session_id"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",movieId] forKey:@"film_id"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"remove_forward_movie.chtml")
      parameters:newParams
         success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            success([responseObject[@"tag"] boolValue]);
        }
    } failure:^(NSError * _Nullable err) {
        if (failure) {
            failure(err);
        }
    }];
    
}


/**
 *  用户 关注某电影
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 isSuccess 是否成功
 *  @param failure 失败回调
 */
- (void)requestDoWantSeeMovieWithMovieId:(NSInteger)movieId
                                 success:(nullable void (^)(BOOL isSuccess))success
                                 failure:(nullable void (^)(NSError * _Nullable err))failure{
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];    [dicParams setObject:[DataEngine sharedDataEngine].sessionId? [DataEngine sharedDataEngine].sessionId:@""  forKey:@"session_id"];
    [dicParams setObject:[NSString stringWithFormat:@"%d", USER_CITY]? [NSString stringWithFormat:@"%d", USER_CITY]:@"" forKey:@"city_id" ];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",movieId] forKey:@"film_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"look_forward_movie.chtml")
      parameters:newParams
         success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError * _Nullable err) {
        if (failure) {
            failure(err);
        }
    }];
}


@end
