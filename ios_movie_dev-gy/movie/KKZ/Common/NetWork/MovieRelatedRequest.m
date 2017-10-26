//
//  MovieRelatedRequest.m
//  KoMovie
//
//  Created by renzc on 16/9/20.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieRelatedRequest.h"
#import "MovieHobbyModel.h"
#import "Actor.h"
#import "Movie.h"

@implementation MovieRelatedRequest

/**
 *  查询某电影的周边
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 @hobbyList: 包含对象类型 [MovieHobbyModel class]
 *  @param failure 失败回调
 */
- (void) requestHobbiesForMovieWithMovieId:(NSInteger)movieId
                                   success:(nullable void (^)(NSArray *_Nullable hobbyList))success
                                   failure:(nullable void (^)(NSError * _Nullable err))failure
{
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:@"goods_Query"  forKey:@"action"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",movieId]  forKey:@"movie_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer parameters:newParams success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            success([MovieHobbyModel mj_objectArrayWithKeyValuesArray:responseObject[@"goodsRecommends"]]);
        }
    } failure:^(NSError * _Nullable err) {
        if (failure) {
            failure(err);
        }
    }];
    
}


/**
 *  查询电影明星（导演、主演、配角等）
 *
 *  @param movieId 电影id 必填
 *  @param success 成功回调 @actorList: 包含对象类型 [Actor class]
 *  @param failure 失败回调
 */
- (void) requestActorListForMovieWithMovieId:(NSInteger )movieId
                                     success:(nullable void (^)(NSArray *_Nullable actorList))success
                                     failure:(nullable void (^)(NSError * _Nullable err))failure{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:@"movie_members"  forKey:@"action"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",movieId]  forKey:@"movie_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPDataServer parameters:newParams success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            
            NSArray *actors = responseObject[@"members"];
            NSMutableArray *actorsM = [[NSMutableArray alloc] initWithCapacity:0];
            [actors enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                Actor *star = [Actor mj_objectWithKeyValues:obj[@"star"]];
                //set character
                star.character = obj[@"character"];
                if (star) {
                    [actorsM addObject:star];
                }
            }];
            
            success(actorsM);
        }
    } failure:^(NSError * _Nullable err) {
        if (failure) {
            failure(err);
        }
    }];
    
}


/**
 *  查询某明星的 电影列表
 *
 *  @param starId  明星id 必填
 *  @param success 成功回调 @movieList 包含对象类型 [Movie class]
 *  @param failure 失败回调
 */
- (void) requestMovieListForActorWithStarId:(NSInteger)starId
                                    success:(nullable void (^)(NSArray *_Nullable movieList))success
                                    failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:@"star_movies"  forKey:@"action"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",starId]  forKey:@"star_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];

    
    [request GET:kKSSPDataServer
      parameters:newParams
         success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            
            NSArray *actors = responseObject[@"movies"];
            NSMutableArray *actorsM = [[NSMutableArray alloc] initWithCapacity:0];
            [actors enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                Movie *mo = [MTLJSONAdapter modelOfClass:[Movie class] fromJSONDictionary:obj[@"movie"] error:nil];
                
                if (mo) {
                    [actorsM addObject:mo];

                }
                
            }];
            
            success([actorsM copy]);
        }
    } failure:^(NSError * _Nullable err) {
        if (failure) {
            failure(err);
        }
    }];
    
}



@end
