//
//  MovieDBTask.h
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "NetworkTask.h"
#import <Foundation/Foundation.h>

@interface MovieDBTask : NetworkTask {
}

@property(nonatomic, strong) NSString *actorId;
@property(nonatomic, strong) NSString *movieId;
@property(nonatomic, strong) NSString *categoryId;
@property(nonatomic, strong) NSString *searchKey;
@property(nonatomic, assign) NSInteger pageNum;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, strong) NSString *matchId;

/**
 * 查询影片的明星。
 *
 * @param movieId <#movieId description#>
 * @param page    <#page description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initActorListForMovie:(unsigned int)movieId
                       page:(NSInteger)page // 没有分页
                   finished:(FinishDownLoadBlock)block;

/**
 * 查询演员出演的电影列表。
 *
 * @param actorId <#actorId description#>
 * @param page    <#page description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initMovieListForActor:(unsigned int)actorId
                       page:(NSInteger)page
                   finished:(FinishDownLoadBlock)block;

/**
 * 查询是否已经对某个影片评分。约电影模块使用，暂时保留
 *
 * @param movieId <#movieId description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initQueryFavForMovie:(unsigned int)movieId
                  finished:(FinishDownLoadBlock)block;

/**
 * 查询电影的摘要信息。
 * TODO 目前只使用了song，废弃掉，直接调用查询原声的接口。
 *
 * @param movieId <#movieId description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initQuerySummaryForMovie:(unsigned int)movieId
                      finished:(FinishDownLoadBlock)block;

/**
 * 查询电影的周边商品。
 *
 * @param movieId <#movieId description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initHobbyForMovie:(unsigned int)movieId
               finished:(FinishDownLoadBlock)block;

@end
