//
//  ClubRequest.h
//  KoMovie
//
//  Created by renzc on 16/9/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ClubPost.h"
#import "ClubPostComment.h"

#define KKPageNum 5

@interface ClubRequest : NSObject

/**
 查询首页社区列表
 
 *  @param success 成功回调
 *  @param failure 成功回调
 */
- (void)requestBBSTab:(nullable void (^)(NSArray *_Nullable tabs))success
              failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 查询首页社区文章列表

 @param URL     社区URL
 @param page    页码
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestClubHomePagePostList:(NSString *_Nonnull)URL
                               page:(NSInteger)page
                            success:(nullable void (^)(NSArray *_Nullable posts, BOOL hasMore))success
                            failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  查询某电影的热门吐槽信息 userGroup  (1,2,3热门吐槽)(4,5社区精华)
 *
 *  @param movieId     电影id 必填
 *  @param currentPage 当前页  必填
 *  @param rows        需要返回行数
 *  @param userGroup   用户群租  必填
 *  @param success     成功回调  @hotComments: [ClubPost class]   @total:总条数   @hasMore:是否还有更多
 *  @param failure     失败回调
 */

- (void)requestMovieHotCommentWithMovieId:(NSInteger)movieId
                              currentPage:(NSInteger)currentPage
                                  rowsNum:(NSInteger)rows
                                userGroup:(NSString * _Nonnull)userGroup
                                  success:(nullable void (^)(NSArray *_Nullable hotComments,NSInteger total,BOOL hasMore))success
                                  failure:(nullable void (^)(NSError * _Nullable err))failure;

/**
 *  查询某影院的热门吐槽信息
 *
 *  @param params  请求参数
 *  @param success 成功回调
 *  @param failure 成功回调
 */
- (void)requestCinemaHotCommentWithCinemaId:(NSNumber *_Nonnull)cinemaId
                                currentPage:(NSInteger)currentPage
                                    rowsNum:(NSInteger)rows
                                  userGroup:(NSString *_Nonnull)userGroup
                                    success:(nullable void (^)(NSArray *_Nullable hotComments,NSInteger total,BOOL hasMore))success
                                    failure:(nullable void (^)(NSError * _Nullable err))failure;

/**
 *  查询某电影的主题评论信息
 *
 *  @param movieId     电影id 必填
 *  @param currentPage 当前页  必填
 *  @param rows        需要返回行数
 *  @param success     成功回调  @hotComments: [ClubPlate class]
 *  @param failure     失败回调
 */

- (void)requestMoviePlateListWithMovieId:(NSInteger)movieId
                             currentPage:(NSInteger)currentPage
                                 rowsNum:(NSInteger)rows
                                 success:(nullable void (^)(id _Nullable postPlates))success
                                 failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  查询帖子详情
 *
 *  @param articleId 帖子id  必填
 *  @param success   成功回调     @postPlates: [ClubPost class]
 *  @param failure   失败回调
 */
- (void)requestClubPostDetailWithArticleId:(NSNumber *_Nonnull)articleId
                                   success:(nullable void (^)(ClubPost * _Nullable post))success
                                   failure:(nullable void (^)(NSError * _Nullable err))failure;

/**
 *  请求赞过某帖子的用户列表
 *
 *  @param articleId 帖子id  必填
 *  @param success   成功回调   @userList: [KKZAuthor class]
 *  @param failure   失败回调
 */
- (void)requestSupportListWithArticleId:(NSInteger)articleId
                                success:(nullable void (^)(NSArray *_Nullable userList))success
                                failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  请求某帖子的 跟帖列表
 *
 *  @param articleId   帖子id  必填
 *  @param currentPage 当前页  必填
 *  @param success     成功回调  @clubPostCommentModels: [ClubPostComment class]
 *  @param failure     失败回调
 */
- (void)requestPostReplyListWithArticleId:(NSNumber *_Nonnull)articleId
                              currentPage:(NSInteger)currentPage
                                  success:(nullable void (^)(NSArray *_Nullable clubPostCommentModels, BOOL hasMore))success
                                  failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  赞帖子
 *
 *  @param articleId 帖子id
 *  @param success   成功回调  @代表成功
 *  @param failure   失败回调
 */
- (void)requestSupportThePostWithArticleId:(NSInteger)articleId
                                   success:(nullable void (^)(id _Nullable responseData))success
                                   failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 查询我的帖子列表
 
 @param page    页数
 @param count   数量
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestMyPost:(NSInteger)page
              success:(nullable void (^)(NSArray *_Nullable posts, BOOL hasMore))success
              failure:(nullable void (^)(NSError * _Nullable err))failure;

/**
 根据影片板块查询帖子列表
 
 @param movieId 电影ID
 @param pateId  模块ID
 @param page    页码
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestMoviePlatePosts:(NSNumber *_Nonnull)movieId
                        pateId:(NSNumber *_Nonnull)pateId
                          page:(NSInteger)page
                       success:(nullable void (^)(NSArray *_Nullable posts, BOOL hasMore))success
                       failure:(nullable void (^)(NSError * _Nullable err))failure;

/**
 查询我的回复帖子列表
 
 @param page    页数
 @param count   数量
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestMyPostReply:(NSInteger)page
                   success:(nullable void (^)(NSArray *_Nullable posts, BOOL hasMore))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 查询我收藏帖子列表列表
 
 @param page    页数
 @param count   数量
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestMyFavorPost:(NSInteger)page
                   success:(nullable void (^)(NSArray *_Nullable posts, BOOL hasMore))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 回复帖子
 
 @param content   内容
 @param articalId 文章ID
 @param success   成功回调
 @param failure   成功回调
 */
- (void)requestCommentPost:(NSString *_Nonnull)content
                 articalId:(NSNumber *_Nonnull)articalId
                   success:(nullable void (^)(ClubPostComment *_Nullable comment, NSString *_Nullable message))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 查询订阅号文章列表
 
 @param authorId 作者ID（用户ID）
 @param page     页码
 @param success  成功回调
 @param failure  成功回调
 */
- (void) requestSubcribeList:(NSNumber *_Nonnull)authorId
                        page:(NSInteger)page
                     success:(nullable void (^)(NSArray *_Nullable posts, BOOL hasMore))success
                     failure:(nullable void (^)(NSError *_Nullable err))failure;
/**
 上传图片
 
 @param imags   图片
 @param success 成功回调
 @param failure 失败回调
 */
- (void) uploadPictures:(NSArray * _Nonnull)imags
                success:(nullable void (^)(NSArray *_Nullable attaches))success
                failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 上传音频
 
 @param audios  音频
 @param success 成功回调
 @param failure 失败回调
 */
- (void) uploadAudio:(NSArray *_Nonnull)audios
             success:(nullable void (^)(NSArray *_Nullable attaches))success
             failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 上传视频
 
 @param videos  视频
 @param success 成功回调
 @param failure 失败回调
 */
- (void) uploadVideo:(NSArray *_Nonnull)videos
             success:(nullable void (^)(NSArray *_Nullable attaches))success
             failure:(nullable void (^)(NSError *_Nullable err))failure;



/**
 发布贴子 注意在MovieCommentData内设置关联信息

 @param type     帖子类型 1 图文，2 语音，3 视频
 @param content  内容
 @param attaches 附件列表
 @param success  成功回调
 @param failure  失败回调
 */
- (void) requestCreatArticle:(NSInteger)type
                     content:(NSString *_Nullable)content
                    attaches:(NSArray *_Nullable)attaches
                     success:(nullable void (^)(ClubPost *_Nullable post))success
                     failure:(nullable void (^)(NSError *_Nullable err))failure;
@end
