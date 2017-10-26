//
//  ClubTask.m
//  KoMovie
//
//  Created by KKZ on 16/2/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPost.h"
#import "ClubTask.h"
#import "DateEngine.h"
#import "MemContainer.h"
#import "NetworkStatus.h"
#import "UserDefault.h"

#import "KKZUser.h"

#import "ClubPostComment.h"

#import "ClubNavTab.h"

#import "ClubPlate.h"

#import "ClubPostReportWord.h"

#define pageNum 15

@implementation ClubTask

/**
 *  收藏帖子接口
 */
- (id)initCollectionPostWithArticleId:(NSInteger)articleId andOprationType:(NSInteger)type Finished:(FinishDownLoadBlock)block {

    self = [super init];
    if (self) {
        self.taskType = TaskTypeCollectionPost;
        self.articleId = articleId;
        self.finishBlock = block;
        self.collectionType = type;
    }
    return self;
}

- (id)initDeletePostWithArticleId:(NSInteger)articleId Finished:(FinishDownLoadBlock)block {

    self = [super init];
    if (self) {
        self.taskType = TaskTypeDeletePost;
        self.articleId = articleId;
        self.finishBlock = block;
    }
    return self;
}

- (id)initDeletePostReplyWithCommentId:(NSInteger)commentId Finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeDeleteReplyPost;
        self.commentId = commentId;
        self.finishBlock = block;
    }
    return self;
}

- (id)initHasedUpWithArticleId:(NSInteger)articleId Finished:(FinishDownLoadBlock)block {

    self = [super init];
    if (self) {
        self.taskType = TaskTypeHasedUpPost;
        self.articleId = articleId;
        self.finishBlock = block;
    }
    return self;
}

- (id)initUpCommentWithCommentId:(NSInteger)commentId Finished:(FinishDownLoadBlock)block {

    self = [super init];
    if (self) {
        self.taskType = TaskTypeHasUpPostReply;
        self.commentId = commentId;
        self.finishBlock = block;
    }
    return self;
}


/**
 *  我的订阅号
 */
- (id)initMineSubscriberListWithCurrentPage:(NSInteger)currentPage Finished:(FinishDownLoadBlock)block {

    self = [super init];
    if (self) {
        self.taskType = TaskTypeMySubscribeList;
        self.currentPage = currentPage;
        self.finishBlock = block;
    }
    return self;
}

- (id)initReportPostWordsFinished:(FinishDownLoadBlock)block {

    self = [super init];
    if (self) {
        self.taskType = TaskTypePostReportList;
        self.finishBlock = block;
    }
    return self;
}

/**
 *  提交举报
 */
- (id)initCommitReportContentWithArticleId:(NSInteger)articleId andTypeId:(NSString *)typeId andContent:(NSString *)content Finished:(FinishDownLoadBlock)block {

    self = [super init];
    if (self) {
        self.taskType = TaskTypePostReportContent;
        self.articleId = articleId;
        self.typeId = typeId;
        self.content = content;
        self.finishBlock = block;
    }
    return self;
}

- (void)getReady {

    if (taskType == TaskTypeMySubscribeList) { //我的订阅号
        [self setRequestURL:[NSString stringWithFormat:@"%@mine/subscribe/list", KKSSClubSeverAPI]];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld", (long) self.currentPage] forKey:@"page"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", pageNum] forKey:@"rows"];
        [self setRequestMethod:@"GET"];
    } else if (taskType == TaskTypeCollectionPost) {
        [self setRequestURL:[NSString stringWithFormat:@"%@article/faverite", KKSSClubSeverAPI]];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld", (long) self.articleId] forKey:@"article_id"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld", (long) self.collectionType] forKey:@"type"];
        [self setRequestMethod:@"GET"];
    } else if (taskType == TaskTypeDeletePost) {
        [self setRequestURL:[NSString stringWithFormat:@"%@article/del", KKSSClubSeverAPI]];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld", (long) self.articleId] forKey:@"article_id"];
        [self setRequestMethod:@"GET"];
    } else if (taskType == TaskTypeDeleteReplyPost) {
        [self setRequestURL:[NSString stringWithFormat:@"%@comment/del", KKSSClubSeverAPI]];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld", (long) self.commentId] forKey:@"comment_id"];
        [self setRequestMethod:@"GET"];
    } else if (taskType == TaskTypeHasedUpPost) {
        [self setRequestURL:[NSString stringWithFormat:@"%@article/del", KKSSClubSeverAPI]];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld", (long) self.articleId] forKey:@"article_id"];
        [self setRequestMethod:@"GET"];
    } else if (taskType == TaskTypeHasUpPostReply) {
        [self setRequestURL:[NSString stringWithFormat:@"%@comment/up", KKSSClubSeverAPI]];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld", (long) self.commentId] forKey:@"comment_id"];
        [self setRequestMethod:@"GET"];
    } else if (taskType == TaskTypePostReportList) {
        [self setRequestURL:[NSString stringWithFormat:@"%@content/report/type/list", KKSSClubSeverAPI]];
        [self setRequestMethod:@"GET"];
    } else if (taskType == TaskTypePostReportContent) {
        [self setRequestURL:[NSString stringWithFormat:@"%@content/report", KKSSClubSeverAPI]];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld", (long) self.articleId] forKey:@"article_id"];
        [self addParametersWithValue:self.typeId forKey:@"type_ids"];
        [self addParametersWithValue:self.content forKey:@"content"];
        [self setRequestMethod:@"GET"];
    }
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypeCollectionPost) {
        NSDictionary *dict = (NSDictionary *) result;
        [self doCallBack:YES info:dict];
    } else if (taskType == TaskTypeDeletePost) {
        NSDictionary *dict = (NSDictionary *) result;
        [self doCallBack:YES info:dict];
    } else if (taskType == TaskTypeDeleteReplyPost) {
        NSDictionary *dict = (NSDictionary *) result;
        [self doCallBack:YES info:dict];
    } else if (taskType == TaskTypeHasedUpPost) {
        NSDictionary *dict = (NSDictionary *) result;
        //        是否点赞过 0 否 1 是
        [self doCallBack:YES info:dict];
    } else if (taskType == TaskTypeHasUpPostReply) {
        NSDictionary *dict = (NSDictionary *) result;
        //        是否点赞过 0 否 1 是
        [self doCallBack:YES info:dict];
    } else if (taskType == TaskTypeMySubscribeList) {
        NSDictionary *dict = (NSDictionary *) result;

        NSArray *users = [dict objectForKey:@"result"];
        NSMutableArray *usersM = [[NSMutableArray alloc] initWithCapacity:0];
        if (users.count) {

            for (int i = 0; i < users.count; i++) {
                NSNumber *existed = nil;
                NSDictionary *userDict = users[i];
                KKZUser *user = (KKZUser *) [[MemContainer me] instanceFromDict:userDict clazz:[KKZUser class] updateTypeWhenExisted:UpdateTypeMerge exist:&existed];
                user.headImg = userDict[@"head"];
                user.userName = userDict[@"title"];
                user.declaration = userDict[@"desc"];
                [usersM addObject:user];
            }
        }
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    [NSNumber numberWithBool:(usersM.count >= pageNum)], @"hasMore", usersM, @"usersM", nil]];
    } else if (taskType == TaskTypePostReportList) {
        NSDictionary *dict = (NSDictionary *) result;
        NSArray *reportWords = dict[@"result"];
        NSMutableArray *reportWordsM = [[NSMutableArray alloc] initWithCapacity:0];
        if (reportWords.count) {
            for (int i = 0; i < reportWords.count; i++) {
                NSDictionary *reportWordDict = reportWords[i];

                NSNumber *existed = nil;

                ClubPostReportWord *reportWord = (ClubPostReportWord *) [[MemContainer me] instanceFromDict:reportWordDict clazz:[ClubPostReportWord class] updateTypeWhenExisted:UpdateTypeReplace exist:&existed];

                [reportWordsM addObject:reportWord];
            }
        }

        [self doCallBack:YES info:[NSDictionary dictionaryWithObject:reportWordsM forKey:@"reportWordsM"]];
    } else if (taskType == TaskTypePostReportContent) {

        NSDictionary *dict = (NSDictionary *) result;

        [self doCallBack:YES info:dict];
    }
}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeCollectionPost) {
        DLog(@"TaskTypeCollectionPost 数据传输失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeDeletePost) {
        DLog(@"TaskTypeDeletePost 数据传输失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeDeleteReplyPost) {
        DLog(@"TaskTypeDeleteReplyPost 数据传输失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeHasedUpPost) {
        DLog(@"TaskTypeHasedUpPost 数据传输失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeHasUpPostReply) {
        DLog(@"TaskTypeHasUpPostReply 数据传输失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeMySubscribeList) {
        DLog(@"TaskTypeMySubscribeList 数据传输失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypePostReportList) {
        DLog(@"TaskTypePostReportList 数据传输失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypePostReportContent) {
        DLog(@"TaskTypePostReportContent 数据传输失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
}

@end
