//
//  MatchListTask.h
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "Favorite.h"
#import "NetworkTask.h"

@interface FavoriteTask : NetworkTask {
}

@property(nonatomic, strong) NSString *favoriteId;

@property(nonatomic, strong) NSString *movieId;
@property(nonatomic, strong) NSString *cinemaId;

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *otherId;

@property(nonatomic, assign) float point;

@property(nonatomic, strong) NSNumber *likeType;
@property(nonatomic, strong) NSString *targetId;
@property(nonatomic, strong) NSString *comment;
@property(nonatomic, assign) int pageNum;
@property(nonatomic, assign) int orderByHeat;

@property(nonatomic, strong) NSString *sessionId;

@property(nonatomic, assign) int audioLength;
@property(nonatomic, strong) NSData *audioData;

@property(nonatomic, assign) BOOL isCollect;

/**
 *  收藏影片，想看影片列表
 *
 *  @param uId     自己uid
 *  @param otherId 别人uid
 *  @param isCollect 是否是收藏，还是想看
 *  @param page    <#page description#>
 *  @param block   <#block description#>
 *
 *  @return <#return value description#>
 */
- (id)initFavoriteListForUser:(NSString *)uId
                    otherWith:(NSString *)otherId
                    isCollect:(BOOL)isCollect
                         page:(int)page
                     finished:(FinishDownLoadBlock)block;
/**
 *  收藏，评分
 *
 *  @param movieId <#movieId description#>
 *  @param point   <#point description#>
 *  @param arm     <#arm description#>
 *  @param length  <#length description#>
 *  @param block   <#block description#>
 *
 *  @return <#return value description#>
 */
- (id)initAddFavMovie:(NSUInteger)movieId
            withPoint:(int)point
        withAudioData:(NSData *)arm
      withAudioLength:(int)length
             withText:(NSString *)comment
             finished:(FinishDownLoadBlock)block;

/**
 * 收藏影院
 *
 * @param cinemaId <#cinemaId description#>
 * @param block    <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initAddFavCinema:(NSUInteger)cinemaId finished:(FinishDownLoadBlock)block;

/**
 *  移除收藏的电影
 *
 *  @param movieId <#movieId description#>
 *  @param block   <#block description#>
 *
 *  @return <#return value description#>
 */
- (id)initDelFavMovie:(int)movieId finished:(FinishDownLoadBlock)block;

/**
 * 移除收藏的影院
 *
 * @param cinemaId <#cinemaId description#>
 * @param block    <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initDelFavCinema:(int)cinemaId finished:(FinishDownLoadBlock)block;

/**
 * 查询影院的收藏状态。
 *
 * @param cinemaId <#cinemaId description#>
 * @param block    <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initQueryFavForCinema:(NSUInteger)cinemaId
                   finished:(FinishDownLoadBlock)block;

/**
 *  移除想看
 *
 *  @param movieId <#movieId description#>
 *  @param block   <#block description#>
 *
 *  @return <#return value description#>
 */
- (id)initDelWantLookWithMovieId:(int)movieId
                        finished:(FinishDownLoadBlock)block;

/**
 * 查询电影是否已经 “想看”
 *
 * @param movieId <#movieId description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initQueryWantWatchWithMovieId:(int)movieId
                           finished:(FinishDownLoadBlock)block;

/**
 * 添加 “想看” 某个电影
 *
 * @param movieId <#movieId description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initClickWantWatchWithMovieId:(int)movieId
                           finished:(FinishDownLoadBlock)block;

/**
 * 查询约电影某个电影参与和成功约会的人数。暂时保留
 *
 * @param movieId <#movieId description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initQuerySucceedNumWithMovieId:(int)movieId
                            finished:(FinishDownLoadBlock)block;

/**
 *  评论支持/反对。
 *
 *  @param likeType 1喜欢影片，2喜欢个人中心的消息
 *  @param targetId likeType是1的时候，传影片id；likeType是2的时候，传消息id
 *  @param block    <#block description#>
 *
 *  @return <#return value description#>
 */
- (id)initAddLikeWithUserId:(NSString *)likeuUid
                   withType:(NSNumber *)likeType
               withTargetId:(NSString *)targetId
                   finished:(FinishDownLoadBlock)block;

/**
 * 添加喜欢
 *
 * @param likeuUid <#likeuUid description#>
 * @param likeType <#likeType description#>
 * @param targetId <#targetId description#>
 * @param block    <#block description#>
 *
 * @return <#return value description#>
 */
- (instancetype)initAddKotaLikeWithUserId:(NSString *)likeuUid
                                 withType:(NSNumber *)likeType
                             withTargetId:(NSString *)targetId
                                 finished:(FinishDownLoadBlock)block;

- (void)cancelCurrentTask;

@end
