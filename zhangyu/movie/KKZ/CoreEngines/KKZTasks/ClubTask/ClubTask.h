//
//  ClubTask.h
//  KoMovie
//
//  Created by KKZ on 16/2/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "NetworkTask.h"

@interface ClubTask : NetworkTask

/**
 *  收藏帖子接口
 */
- (id)initCollectionPostWithArticleId:(NSInteger)articleId andOprationType:(NSInteger)type Finished:(FinishDownLoadBlock)block;

/**
 *  删除帖子接口
 */
- (id)initDeletePostWithArticleId:(NSInteger)articleId Finished:(FinishDownLoadBlock)block;

/**
 *  删除帖子回复接口
 */
- (id)initDeletePostReplyWithCommentId:(NSInteger)commentId Finished:(FinishDownLoadBlock)block;

/**
 *  是否对该贴点赞过
 */
- (id)initHasedUpWithArticleId:(NSInteger)articleId Finished:(FinishDownLoadBlock)block;

/**
 *  给回复点赞
 */
- (id)initUpCommentWithCommentId:(NSInteger)commentId Finished:(FinishDownLoadBlock)block;


/**
 *  我的订阅号
 */
- (id)initMineSubscriberListWithCurrentPage:(NSInteger)currentPage Finished:(FinishDownLoadBlock)block;

/**
 *  举报词汇列表
 */
- (id)initReportPostWordsFinished:(FinishDownLoadBlock)block;

/**
 *  提交举报
 */
- (id)initCommitReportContentWithArticleId:(NSInteger)articleId andTypeId:(NSString *)typeId andContent:(NSString *)content Finished:(FinishDownLoadBlock)block;

/**
 *  列表当前页
 */
@property (nonatomic, assign) NSInteger currentPage;
/**
 *  帖子id
 */
@property (nonatomic, assign) NSInteger articleId;

/**
 *  当前请求的url
 */
@property (nonatomic, copy) NSString *currentUrl;

/**
 *  导航Id
 */
@property (nonatomic, assign) NSInteger navId;

/**
 *  回复的内容
 */
@property (nonatomic, copy) NSString *replyContent;

/**
 *   收藏还是取消收藏  操作类型 1：添加收藏 2：取消收藏
 */
@property (nonatomic, assign) NSInteger collectionType;

/**
 *  帖子回复的id
 */
@property (nonatomic, assign) NSInteger commentId;

/**
 *  电影id
 */
@property (nonatomic, assign) unsigned int movieId;

/**
 *  影院id
 */
@property (nonatomic, assign) unsigned int cinemaId;

/**
 *  影片是1 影院是2
 */
@property (nonatomic, assign) unsigned int type;

/**
 *  加载数据的条数
 */
@property (nonatomic, assign) NSInteger rows;

/**
 *  用户Id
 */
@property (nonatomic, assign) unsigned int userId;

/**
 *  获取热门吐槽和精华帖时的参数
 */
@property (nonatomic, copy) NSString *userGroup;

/**
 *  模块儿Id
 */
@property (nonatomic, assign) NSInteger plateId;

/**
 *  举报类型
 */
@property (nonatomic, copy) NSString *typeId;

/**
 *  举报内容
 */
@property (nonatomic, copy) NSString *content;

@end
