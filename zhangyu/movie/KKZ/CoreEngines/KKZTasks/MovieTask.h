//
//  MovieTask.h
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "NetworkTask.h"
#import <Foundation/Foundation.h>

@interface MovieTask : NetworkTask {
}

@property (nonatomic, strong) NSString *movieId;
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) int mediaType;

// 1支持，2反对
@property (nonatomic, assign) NSInteger relation;

- (id)initMoviePosterWithMovieid:(NSUInteger)movieId
                       mediaType:(int)mediaType
                        finished:(FinishDownLoadBlock)block;

- (id)initCinemaPosterWithCinemaid:(NSUInteger)cinemaId
                         mediaType:(int)mediaType
                          finished:(FinishDownLoadBlock)block;

/**
 *  查询对该影片点赞 或者 不喜欢 的情况
 */
- (id)initMovieSupportWithMovieid:(NSUInteger)movieId
                         finished:(FinishDownLoadBlock)block;

/**
 * 查询电影的预告片
 *
 * @param movieId <#movieId description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initMovieTrailerWithMovieId:(unsigned int)movieId
                         finished:(FinishDownLoadBlock)block;

/**
 * 查询电影的原声歌曲。
 *
 * @param movieId <#movieId description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initMovieSongsWithMovieId:(unsigned int)movieId
                       finished:(FinishDownLoadBlock)block;

- (id)initMovieGallarysWithMovieId:(unsigned int)movieId
                          finished:(FinishDownLoadBlock)block;

/**
 *  点赞 或者 不喜欢
 */
- (id)initSupportMovieWithMovieid:(NSUInteger)movieId
                      andRelation:(NSInteger)relation
                         finished:(FinishDownLoadBlock)block;
/**
 *  查询一个电影所有影院的上映日期
 */
- (id)initDateListForMovie:(NSUInteger)movieId
                   andCity:(NSInteger)cityId
                  finished:(FinishDownLoadBlock)block;

@end
