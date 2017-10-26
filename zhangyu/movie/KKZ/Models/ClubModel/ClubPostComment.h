//
//  ClubPostComment.h
//  KoMovie
//
//  Created by KKZ on 16/2/28.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Mantle/Mantle.h>

#import "KKZAuthor.h"
#import "ClubPost.h"

/**
 回复
 */
@interface ClubPostComment : MTLModel <MTLJSONSerializing>

/**
 *  帖子id
 */
@property (nonatomic, copy) NSNumber *articleId;
/**
 *  回复id
 */
@property (nonatomic, copy) NSNumber *commentId; //

@property (nonatomic, strong) KKZAuthor *commentor;
/**
 *  回复内容
 */
@property (nonatomic, copy) NSString *content; //

/**
 *  回复时间
 */
@property (nonatomic, copy) NSString *createTime; //

/**
 *  回复点赞数量
 */
@property (nonatomic, copy) NSNumber *upNum; //

/**
 我的回复接口 会返回文章
 */
@property (nonatomic, strong) ClubPost *article;

@property (nonatomic) BOOL isUp;
//-------
/**
 *  用户是否点赞过
 */
@property (nonatomic, assign) BOOL commented;

@end
