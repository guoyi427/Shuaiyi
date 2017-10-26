//
//  ClubRequest.m
//  KoMovie
//
//  Created by renzc on 16/9/22.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//


#import "ClubPlate.h"
#import "ClubPost.h"
#import "KKZAuthor.h"
#import "ClubPostComment.h"
#import "CPMovieComment.h"
#import "ClubNavTab.h"
#import "NSURL+QueryDictionary.h"

#import "KKZAttach.h"
#import "KKZUtility.h"
#import "MovieCommentData.h"

#import "ClubRequest.h"
#define KKHotCommentUserGroup @"1,2,3,0"
#define KKMoviePostUserGroup @"4,5"


/**
 是否还有更多
 （由于后台没有对"total"进行处理，全部返回了0）
 前端根据获取当前页的帖子个数若小于每页个数则没有更多
 
 @param numOfPage 每页个数
 @param currentPageCount 当前页个数
 @return 是有有更多 yes：有 no： 没有
 */
BOOL ClubPostHaveMore(NSInteger numOfPage, NSInteger currentPageCount)
{
    if (currentPageCount < numOfPage) {
        return NO;
    }
    
    return YES;
}


@implementation ClubRequest


/**
 查询首页社区列表
 
 *  @param success 成功回调
 *  @param failure 成功回调
 */- (void) requestBBSTab:(nullable void (^)(NSArray *_Nullable tabs))success

               failure:(nullable void (^)(NSError * _Nullable err))failure
{
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:nil];
    
    [request GET:KKSSClubSeverPath(@"nav/list")
      parameters:newParams
    resultKeyMap:@{@"result":[ClubNavTab class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             
             if (success) {
                 
                 NSArray *tabs = data[@"result"];
                 [tabs makeObjectsPerformSelector:@selector(handleDate) withObject:nil];
                 
                 success(tabs);
             }
             
         } failure:failure];
    
}
/**
 查询首页社区文章列表
 
 @param URL     社区URL
 @param page    页码
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestClubHomePagePostList:(NSString * _Nonnull)URL
                                page:(NSInteger)page
                             success:(nullable void (^)(NSArray * _Nullable posts, BOOL hasMore))success
                             failure:(nullable void (^)(NSError * _Nullable err))failure
{
    NSString *URL_encode = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *a_URL = [NSURL URLWithString:URL_encode];
    if (a_URL == nil && failure) {
        failure(nil);
    }
    
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:[NSString stringWithFormat:@"%@://%@",a_URL.scheme,a_URL.host] baseParams:nil];
    
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithDictionary:[a_URL uq_queryDictionary]];
    
    [dicParams setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:a_URL.path parameters:newParams success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
        
        if (success) {
            NSError *err = nil;
            
            NSArray *posts = [MTLJSONAdapter modelsOfClass:[ClubPost class] fromJSONArray:responseObject[@"result"][@"result"] error:&err];
            NSInteger total = [responseObject[@"result"][@"total"] integerValue];
            //每页15个
            BOOL more = total > KKPageNum * page;
            success(posts, more);
        }
        
    } failure:failure];
    
}


/**
 *  查询某电影的热门吐槽信息
 *
 *  @param params  请求参数
 *  @param success 成功回调
 *  @param failure 成功回调
 */
- (void)requestMovieHotCommentWithMovieId:(NSInteger)movieId
                              currentPage:(NSInteger)currentPage
                                  rowsNum:(NSInteger)rows
                                userGroup:(NSString *)userGroup
                                  success:(nullable void (^)(NSArray *_Nullable hotComments,NSInteger total,BOOL hasMore))success
                                  failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSPCinphileServerBaseURL//KKSSClubSeverBase
                                                            baseParams:nil];
    /*
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",movieId] forKey:@"movie_ids"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",rows] forKey:@"rows"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",currentPage] forKey:@"page"];
    [dicParams setObject:[NSString stringWithFormat:@"%@",userGroup] forKey:@"user_groups"];
    */
    NSDictionary *dicParams = @{
                                @"movie_id" : @(movieId),
                                @"page" : @(currentPage),
                                @"count" : @KKPageNum
                                };
    K_REQUEST_ENC_SALT = [NSMutableString stringWithString:@"0XmGnObn"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    K_REQUEST_ENC_SALT = [NSMutableString stringWithString:kKsspKey];
    
    [request GET:@"invite/comment/getcomments"//KKSSClubSeverPath(@"movie/article/list")
      parameters:newParams
         success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            
            NSError *err = nil;
            
            NSArray *posts = [MTLJSONAdapter modelsOfClass:[CPMovieComment class] fromJSONArray:responseObject[@"result"]  error:&err];
            
            NSInteger total = posts.count;
            success(posts,total,total> KKPageNum * currentPage);
        }
    } failure:^(NSError * _Nullable err) {
        if (failure) {
            failure(err);
        }
    }];
}

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
                                    failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setValue:cinemaId forKey:@"cinema_ids"];
    [dicParams setObject:[NSNumber numberWithInteger:rows] forKey:@"rows"];
    [dicParams setObject:[NSNumber numberWithInteger:currentPage] forKey:@"page"];
    [dicParams setValue:userGroup forKey:@"user_groups"];
    
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSClubSeverPath(@"cinema/article/list")
      parameters:newParams
         success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            
            NSError *err = nil;
            
            NSArray *posts = [MTLJSONAdapter modelsOfClass:[ClubPost class] fromJSONArray:responseObject[@"result"][@"result"]  error:&err];
            
            NSInteger total = [responseObject[@"result"][@"total"] integerValue];
            success(posts,total,total > KKPageNum * currentPage);
        }
    } failure:^(NSError * _Nullable err) {
        if (failure) {
            failure(err);
        }
    }];
    
}


/**
 *  查询某电影的主题评论信息
 *
 *  @param movieId     电影id 必填
 *  @param currentPage 当前页  必填
 *  @param rows        需要返回行数
 *  @param userGroup   用户群租  必填
 *  @param success     成功回调   @hotComments: [ClubPlate class]
 *  @param failure     失败回调
 */

- (void)requestMoviePlateListWithMovieId:(NSInteger)movieId
                             currentPage:(NSInteger)currentPage
                                 rowsNum:(NSInteger)rows
                                 success:(nullable void (^)(id _Nullable postPlates))success
                                 failure:(nullable void (^)(NSError * _Nullable err))failure{
    
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",movieId] forKey:@"movie_id"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",rows] forKey:@"rows"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",currentPage] forKey:@"page"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    [request GET:KKSSClubSeverPath(@"plate/list") parameters:newParams success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            
            success([ClubPlate mj_objectArrayWithKeyValuesArray:responseObject[@"result"]]);
            
        }
    } failure:^(NSError * _Nullable err) {
        if (failure) {
            failure(err);
        }
    }];
    
}


/**
 *  查询帖子详情
 *
 *  @param articleId 帖子id  必填
 *  @param success   成功回调
 *  @param failure   失败回调
 */
- (void)requestClubPostDetailWithArticleId:(NSNumber *_Nonnull)articleId
                                   success:(nullable void (^)(ClubPost * _Nullable post))success
                                   failure:(nullable void (^)(NSError * _Nullable err))failure{
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setValue:articleId forKey:@"article_id"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    
    [request GET:KKSSClubSeverPath(@"article/detail")
      parameters:newParams
    resultKeyMap:@{@"result":[ClubPost class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
        
        if (success) {
            success(data[@"result"]);
        }
        
        
    } failure:failure];
    
}


/**
 *  请求赞过某帖子的用户列表
 *
 *  @param articleId 帖子id  必填
 *  @param success   成功回调   @userList: [KKZAuthor class]
 *  @param failure   失败回调
 */



- (void)requestSupportListWithArticleId:(NSInteger)articleId
                                success:(nullable void (^)(NSArray *_Nullable userList))success
                                failure:(nullable void (^)(NSError * _Nullable err))failure{
    
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",articleId] forKey:@"article_id"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSClubSeverPath(@"article/up/list")
      parameters:newParams
    resultKeyMap:@{@"result":[KKZAuthor class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             
             if (success) {
                 success(data[@"result"]);
             }
             
             
         } failure:failure];
    
}
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
                                  success:(nullable void (^)(NSArray *_Nullable clubPostComments,BOOL hasMore))success
                                  failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setValue:articleId forKey:@"article_id"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",currentPage] forKey:@"page"];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",KKPageNum] forKey:@"rows"];
    
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSClubSeverPath(@"comment/list")
      parameters:newParams
         success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            
            NSError *err = nil;
            
            NSArray *replyList = [MTLJSONAdapter modelsOfClass:[ClubPostComment class] fromJSONArray:responseObject[@"result"][@"result"] error:&err];
            
            NSInteger total = [responseObject[@"result"][@"total"] integerValue];
            success(replyList,total > KKPageNum * currentPage);
        }
    } failure:^(NSError * _Nullable err) {
        if (failure) {
            failure(err);
        }
    }];
}


/**
 *  赞帖子
 *
 *  @param articleId 帖子id
 *  @param success   成功回调  @代表成功
 *  @param failure   失败回调
 */
- (void)requestSupportThePostWithArticleId:(NSInteger)articleId
                                   success:(nullable void (^)(id _Nullable responseData))success
                                   failure:(nullable void (^)(NSError * _Nullable err))failure{
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",articleId] forKey:@"article_id"];
    
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    [request GET:KKSSClubSeverPath(@"article/up")
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


/**
 查询我的帖子列表
 
 @param page    页数
 @param count   数量
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestMyPost:(NSInteger)page
              success:(nullable void (^)(NSArray *_Nullable posts, BOOL hasMore))success
              failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dicParams setValue:[NSNumber numberWithInteger:KKPageNum] forKey:@"rows"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSClubSeverPath(@"mine/article/list") parameters:newParams success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
        
        NSError *err = nil;
        
        NSArray *posts = [MTLJSONAdapter modelsOfClass:[ClubPost class] fromJSONArray:responseObject[@"result"] error:&err];
//        NSInteger total = [responseObject[@"total"] integerValue];
        success(posts, ClubPostHaveMore(page, posts.count));
        
    } failure:failure];
    
}

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
                       failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:5];
    [dicParams setValue:movieId forKey:@"movie_ids"];
    [dicParams setValue:pateId forKey:@"plate_ids"];
    [dicParams setValue:@"top" forKey:@"search_state"];
    [dicParams setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dicParams setValue:[NSNumber numberWithInteger:KKPageNum] forKey:@"rows"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSClubSeverPath(@"article/list/search") parameters:newParams success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
        
        NSError *err = nil;
        
        NSArray *posts = [MTLJSONAdapter modelsOfClass:[ClubPost class] fromJSONArray:responseObject[@"result"][@"result"] error:&err];
//        NSInteger total = [responseObject[@"result"][@"total"] integerValue];
        success(posts, ClubPostHaveMore(page, posts.count));
        
    } failure:failure];
    
}


/**
 查询我的回复帖子列表
 
 @param page    页数
 @param count   数量
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestMyPostReply:(NSInteger)page
                   success:(nullable void (^)(NSArray *_Nullable posts, BOOL hasMore))success
                   failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dicParams setValue:[NSNumber numberWithInteger:KKPageNum] forKey:@"rows"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSClubSeverPath(@"mine/comment/list")
      parameters:newParams
    resultKeyMap:@{@"result":[ClubPostComment class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             
             if (success) {
                 NSArray *posts = data[@"result"];
//                 NSInteger total = [responseObject[@"total"] integerValue];
                 success(posts, ClubPostHaveMore(page, posts.count));
             }
             
         } failure:failure];
    
}

/**
 查询我收藏帖子列表列表
 
 @param page    页数
 @param count   数量
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestMyFavorPost:(NSInteger)page
                   success:(nullable void (^)(NSArray *_Nullable posts, BOOL hasMore))success
                   failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dicParams setValue:[NSNumber numberWithInteger:KKPageNum] forKey:@"rows"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSClubSeverPath(@"mine/faverite/list")
      parameters:newParams
    resultKeyMap:nil
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             //responseObject结构为{result:[article:{},article:{},]}
             
             NSArray *posts = responseObject[@"result"];
             
             NSMutableArray *po = [NSMutableArray arrayWithCapacity:posts.count];
             
             [posts enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 
                 if ([obj isKindOfClass:[NSDictionary class]]) {
                     NSDictionary *dic = obj;
                     ClubPost *pos = [MTLJSONAdapter modelOfClass:[ClubPost class] fromJSONDictionary:dic[@"article"] error:nil];
                     if (pos) {
                         [po addObject:pos];
                     }
                     
                 }
                 
             }];
             
             if (success) {
//                 NSInteger total = [responseObject[@"total"] integerValue];
                 success([po copy],ClubPostHaveMore(page, posts.count));
             }
             
         } failure:failure];
    
}

/**
 回复帖子
 
 @param content   内容
 @param articalId 文章ID
 @param success   成功回调
 @param failure   失败回调
 */
- (void)requestCommentPost:(NSString *_Nonnull) content
                 articalId:(NSNumber *_Nonnull) articalId
                   success:(nullable void (^)(ClubPostComment *_Nullable comment, NSString *_Nullable message))success
                   failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setValue:articalId forKey:@"article_id"];
    [dicParams setValue:content forKey:@"content"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request POST:KKSSClubSeverPath(@"comment/add")
      parameters:newParams
    resultKeyMap:@{@"result":[ClubPostComment class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 
                 ClubPostComment *comment = data[@"result"];
                 if (comment && success) {
                     success(comment, nil);
                     
                 }else if (success && comment == nil){
                     success(nil, @"回复失败，请您稍后重试\n友情提示：目前暂时还不支持表情哦");
                 }
                 
                 
             }
             
         } failure:failure];
}


/**
 查询订阅号文章列表
 
 @param authorId 作者ID（用户ID）
 @param page     页码
 @param success  成功回调
 @param failure  失败回调
 */
- (void) requestSubcribeList:(NSNumber *_Nonnull)authorId
                        page:(NSInteger)page
                     success:(nullable void (^)(NSArray *_Nullable posts, BOOL hasMore))success
                     failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setValue:authorId forKey:@"author_id"];
    [dicParams setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dicParams setValue:[NSNumber numberWithInteger:KKPageNum] forKey:@"rows"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSClubSeverPath(@"article/list")
      parameters:newParams
    resultKeyMap:@{@"result":[ClubPost class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             
             if (success) {
                 NSArray *posts = data[@"result"];
                 NSInteger total = [responseObject[@"total"] integerValue];
                 success(posts, total > KKPageNum * page);
             }
             
         } failure:failure];
    
}


/**
 上传图片
 
 @param imags   图片
 @param success 成功回调
 @param failure 失败回调
 */
- (void) uploadPictures:(NSArray *_Nonnull)imags
                success:(nullable void (^)(NSArray *_Nullable attaches))success
                failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    request.parseKey = @"result";
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:@{@"attach_type":@1}];
    
    [request upload:KKSSClubSeverPath(@"attach/upload")
         parameters:newParams
           fromData:^(id<AFMultipartFormData>  _Nonnull formData) {
               
               [imags enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                   if ([obj isKindOfClass:[UIImage class]]) {
                       
                       UIImage *image = obj;
                       NSData *data = UIImageJPEGRepresentation(image, 1.0);
                       [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"file%@.jpg",@(idx)] fileName:@"file" mimeType:@"jpg"];
                   }
                   
               }];
               
           }
        resultClass:[KKZAttach class]
            success:^(id  _Nullable data, id  _Nullable responseObject) {
                
                if (success) {
                    success(data);
                }
                
            } failure:failure];
    
}

/**
 上传音频
 
 @param audios  音频
 @param success 成功回调
 @param failure 失败回调
 */
- (void) uploadAudio:(NSArray *_Nonnull)audios
             success:(nullable void (^)(NSArray *_Nullable attaches))success
             failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    request.parseKey = @"result";
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:@{@"attach_type":@2}];
    
    [request upload:KKSSClubSeverPath(@"attach/upload")
         parameters:newParams
           fromData:^(id<AFMultipartFormData>  _Nonnull formData) {
               
               [audios enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                   if ([obj isKindOfClass:[NSData class]]) {
                       NSData *data = obj;
                       [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"file%@.mp3",@(idx)] fileName:@"file" mimeType:@"mp3"];
                   }
                   
               }];
               
               
               
           }
        resultClass:[KKZAttach class]
            success:^(id  _Nullable data, id  _Nullable responseObject) {
                
                if (success) {
                    success(data);
                }
                
            } failure:failure];
    
}

/**
 上传视频
 
 @param videos  视频
 @param success 成功回调
 @param failure 失败回调
 */
- (void) uploadVideo:(NSArray *_Nonnull)videos
             success:(nullable void (^)(NSArray *_Nullable attaches))success
             failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    
    request.parseKey = @"result";
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:@{@"attach_type":@3}];
    
    [request upload:KKSSClubSeverPath(@"attach/upload")
         parameters:newParams
           fromData:^(id<AFMultipartFormData>  _Nonnull formData) {
               
               [videos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                   if ([obj isKindOfClass:[NSData class]]) {
                       NSData *data = obj;
                       [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"file%@.mp4",@(idx)] fileName:@"file" mimeType:@"mp4"];
                   }
                   
               }];
               
           }
        resultClass:[KKZAttach class]
            success:^(id  _Nullable data, id  _Nullable responseObject) {
                
                if (success) {
                    success(data);
                }
                
            } failure:failure];
    
}


/**
 发布贴子
 
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
                     failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSClubSeverBase baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setValue:content forKey:@"content"];
    [dicParams setValue:[NSNumber numberWithInteger:type] forKey:@"type"];
    //attaches
    if (attaches.count > 0) {
        NSArray *attachesIds = [attaches valueForKeyPath:@"attachId"];
        NSString *ids = [attachesIds componentsJoinedByString:@","];
        [dicParams setValue:ids forKey:@"attaches"];
    }
    
    //电影ID
    NSString *movie_id = [MovieCommentData sharedInstance].movieId;
    
    //影院ID
    NSString *cinema_id = [MovieCommentData sharedInstance].cinemaId;
    if ([[MovieCommentData sharedInstance] isSetMovieId]) {
        [dicParams setValue:movie_id forKey:@"movie_id"];
    }else if ([[MovieCommentData sharedInstance] isSetCinemaId]) {
        [dicParams setValue:cinema_id forKey:@"cinema_id"];
    }
    
    //订单ID
    NSString *order_id = [MovieCommentData sharedInstance].orderId;
    if (![KKZUtility stringIsEmpty:order_id] && ![order_id isEqualToString:@"0"]) {
        [dicParams setValue:order_id
                     forKey:@"order_id"];
    }
    
    //导航ID
    NSString *nav_id = [NSString stringWithFormat:@"%ld",(long)[MovieCommentData sharedInstance].navId];
    if (![KKZUtility stringIsEmpty:nav_id] && ![nav_id isEqualToString:@"0"]) {
        [dicParams setValue:nav_id
                     forKey:@"nav_id"];
    }
    
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request POST:KKSSClubSeverPath(@"article/create")
      parameters:newParams
    resultKeyMap:@{@"result":[ClubPost class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             
             if (success) {
                 
                 success(data[@"result"]);
             }
             
         } failure:failure];
}

@end
