//
//  FriendHomeMessage.h
//  KoMovie
//
//  Created by avatar on 14-11-27.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "Model.h"

@interface FriendHomeMessage : Model


/*0 约电影 
 1 邀约 
 2 同意了 KOTA 邀约，未购票
 3 拒绝
 4 同意了 KOTA 邀约，已购票
 7 普通 KOTA 分享
 10 分享电影
 11 分享歌曲
 12 分享台词
 13 分享评论
 14 看过xx电影
 15 成为好友
 16 想看
 17 看过
//comment里 有一个commentType 1 是影片2是影院
*/

@property (nonatomic, assign) int homeMessageId;
@property (nonatomic, assign) int movieId;
@property (nonatomic, assign) int userId;
@property (nonatomic, assign) int commentId;
@property (nonatomic, assign) int shareUserId;
@property (nonatomic, assign) int requestUserId;
@property (nonatomic, assign) int cinemaId;
@property (nonatomic, assign) int kotaCommentId;
@property (nonatomic, assign) int requestKotaCommentId;
@property (nonatomic, assign) int kotaId;
@property (nonatomic, assign) int status;
@property (nonatomic, assign) int isRequest;
@property (nonatomic, retain) NSString * createTime;


+ (FriendHomeMessage *)getMovieWithId:(unsigned int)homeMessageId;

@end
