//
//  Favorite.h
//  KoMovie
//
//  Created by zhang da on 12-8-16.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "Model.h"


@interface Favorite : Model

@property (nonatomic, assign) unsigned int favoriteId;
@property (nonatomic, retain) NSNumber * favoriteType; //没用

@property (nonatomic, retain) NSNumber * isMyFav;//是否是自己的收藏.1是未评分，2是已评分。 是否是自己的想看，1是想看。 but,加载数据时都改成了1是true，0是false

@property (nonatomic, copy) NSNumber *movieId;
@property (nonatomic, retain) NSString * movieName;
@property (nonatomic, assign) unsigned int userId;
@property (nonatomic, assign) unsigned int kotaId;

@property (nonatomic, retain) NSString * movieImg;//海报
@property (nonatomic, retain) NSString * soundUrl; //只有一句，只显示最新的评论。自己对自己的收藏电影做评论。
@property (nonatomic, retain) NSNumber * soundAttitude;//现在没有态度，支持和反对
@property (nonatomic, retain) NSNumber * soundLength;//长度，秒

@property (nonatomic, retain) NSNumber * movieScore;//我对电影的评分10分制，五颗星，可以显示半颗星。

@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSDate * publishTime;//电影上映时间，ui上有体现。
@property (nonatomic, retain) NSDate * ticketTime;//.....

@property (nonatomic, retain) NSString *commentType;//1是文字 2是语音 空是没有评论
@property (nonatomic, retain) NSString *content;//和上面的commentType是对应的 1的文字评论信息

+ (Favorite *)getFavoriteWithId:(unsigned int)movieId;

@end
