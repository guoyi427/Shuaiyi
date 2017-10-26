//
//  CPMovieComment.h
//  Cinephile
//
//  Created by Albert on 17/12/2016.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CPMovieComment :MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSNumber *commentId;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSURL *userIcon;

/**
 不是好友 yes：不是好友 no：是好友
 */
@property (nonatomic) BOOL isNotFriend;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSNumber *movieId;
@property (nonatomic, copy) NSDate *createTime;
@property (nonatomic, copy) NSNumber *sex;
/**
 是否点赞：1已点赞0未点赞
 */
@property (nonatomic, copy) NSNumber *isUP;
/**
 点赞数
 */
@property (nonatomic, copy) NSNumber *upNum;

/**
 是否为置顶
 */
@property (nonatomic, copy) NSNumber *isTop;

/**
 评论状态       0:正常， 1:屏蔽
 */
@property (nonatomic, strong) NSNumber *status;

- (NSString *) formatedTime;
@end
