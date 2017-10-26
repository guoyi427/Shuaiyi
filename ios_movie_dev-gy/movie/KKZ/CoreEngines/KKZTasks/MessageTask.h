//
//  MessageTask.h
//  KoMovie
//
//  Created by zhoukai on 1/10/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "NetworkTask.h"

@interface MessageTask : NetworkTask

@property(nonatomic, strong) NSString *sessionId;
@property(nonatomic, strong) NSString *userIds;

@property(nonatomic, strong) NSString *uid;
@property(nonatomic, assign) int pageNum;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, assign) int friendId;
@property(nonatomic, assign) int inviteMovieId;

/**
 * 查询约电影的消息列表。原样保留
 *
 * @param page  <#page description#>
 * @param block <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initAppointmentMessageListPageNum:(int)page
                               finished:(FinishDownLoadBlock)block;

/**
 * 删除约电影的消息。原样保留
 *
 * @param inviteMovieId <#inviteMovieId description#>
 * @param block         <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initDeleteMessageWithInviteMovieId:(int)inviteMovieId
                                finished:(FinishDownLoadBlock)block;


@end
