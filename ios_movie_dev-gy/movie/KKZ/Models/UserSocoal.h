//
//  UserSocoal.h
//  KoMovie
//
//  Created by Albert on 27/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserDetail.h"


/**
 用户社交信息
 */
@interface UserSocoal : UserDetail

/**
 背景图
 */
@property (nonatomic, copy) NSString *bg1;
@property (nonatomic, copy) NSString *channel;

@property (nonatomic, copy) NSNumber *messageCount;
@property (nonatomic, copy) NSNumber *favoriteCount;
@property (nonatomic, copy) NSNumber *followerCount;
@property (nonatomic, copy) NSNumber *friendCount;
@property (nonatomic, copy) NSNumber *commentCount;
@property (nonatomic, copy) NSNumber *likeCount;
@property (nonatomic, copy) NSNumber *collectCount;
@property (nonatomic, copy) NSNumber *orderCount;
@property (nonatomic, copy) NSNumber *ticketCount;

@property (nonatomic, copy) NSString *crazyPayForPassword;
@property (nonatomic, copy) NSNumber *crazyPayForType;

@property (nonatomic, copy) NSString *lastsession;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *resultMsg;
@property (nonatomic, copy) NSNumber *resultStatus;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *weixin;
@property (nonatomic, copy) NSString *weixinId;
@property (nonatomic, copy) NSString *sinaweibo;
@end
