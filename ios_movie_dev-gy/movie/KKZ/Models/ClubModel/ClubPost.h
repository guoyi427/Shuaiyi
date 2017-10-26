//
//  ClubPost.h
//  KoMovie
//
//  Created by KKZ on 16/2/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "Share.h"
#import "KKZAuthor.h"

/**
 评论文件格式

 - KKZPostFileTypeImage:             图片文件
 - KKZPostFileTypeAudio:             音频文件
 - KKZPostFileTypeVideo:             视频文件
 - KKZPostFileTypeSubscriptionCount: 订阅号内容
 */
typedef NS_ENUM(NSUInteger, KKZPostFileType) {
    KKZPostFileTypeImage = 1,
    KKZPostFileTypeAudio = 2,
    KKZPostFileTypeVideo = 3,
    KKZPostFileTypeSubscriptionCount = 4,
};

@interface PostFile : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSArray *files;
@property (nonatomic) KKZPostFileType type;
@end

@interface ClubPost : MTLModel <MTLJSONSerializing>
/**
 *  文章id
 */
@property (nonatomic, copy) NSNumber *articleId; //

/**
 *  评论数
 */
@property (nonatomic, copy) NSNumber *replyNum; //
/**
 *  点赞数
 */
@property (nonatomic, copy) NSNumber *upNum; //
/**
 *  标题
 */
@property (nonatomic, copy) NSString *title; //
/**
 *  1图文 2 语音 3 视频 4.订阅号内容
 */
@property (nonatomic, copy) NSNumber *type; //
/**
 *  外部链接地址
 */
@property (nonatomic, copy) NSString *url; //
/**
 *  发布时间
 */
@property (nonatomic, copy) NSString *publishTime; //
/**
 *  发帖人userId
 */
@property (nonatomic, assign) unsigned int userId;
/**
 *  该贴是否被删除
 */
@property (nonatomic, copy) NSString *tip; //

@property (nonatomic, copy) NSString *tags; //

/**
 评论文件 <PostFile>
 */
@property (nonatomic, strong) NSArray *images; //

/**
 *  帖子内容
 */
@property (nonatomic, copy) NSString *content; //

/**
 作者
 */
@property (nonatomic, strong) KKZAuthor *author;

/**
 *  帖子相关电影
 */
@property (nonatomic, copy) NSNumber *movieId; //

/**
 *  该贴我是否已收藏
 */
@property (nonatomic, assign) NSInteger isFaverite; //

/**
 *  该贴我是否已点赞
 */
@property (nonatomic, assign) NSInteger isUp; //

/**
 分享
 */
@property (nonatomic, strong) Share *share; //

//---------------------------

/**
 *  图片数组
 */
@property (nonatomic, strong) NSArray *filesImage;

/**
 *  视频数组
 */
@property (nonatomic, strong) NSArray *filesVideo;

/**
 *  音频数组
 */
@property (nonatomic, strong) NSArray *filesAudio;

+ (instancetype)getClubPostWithArticleId:(NSNumber *)articleId fromArray:(NSArray *)posts;

@end
