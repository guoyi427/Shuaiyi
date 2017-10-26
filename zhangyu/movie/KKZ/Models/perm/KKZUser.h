//
//  User.h
//  KoMovie
//
//  Created by XuYang on 13-4-12.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "Model.h"


@interface KKZUser : Model

@property (nonatomic, retain) NSString * avatarPath;
@property (nonatomic, retain) NSString * homeImagePath;//个人主页上标题背景图
@property (nonatomic, retain) NSString * mobile;//电话号码



@property (nonatomic, retain) NSString * headImg;//头像
@property (nonatomic, retain) NSString * latitude;//
@property (nonatomic, retain) NSString * longitude;

@property (nonatomic, assign) unsigned int userId;
@property (nonatomic, retain) NSString * userName;//@"userName": @"nickname",
@property (nonatomic, retain) NSString * declaration;//用户宣言
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * nickName;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * userNamePY;
@property (nonatomic, retain) NSString * userNameFirst;//用来索引
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSNumber * sex;
@property (nonatomic, retain) NSString * birthDay;
@property (nonatomic, retain) NSString * birthMonth;
@property (nonatomic, retain) NSString * level;//影评人的级别

@property (nonatomic,assign) unsigned int friendId;

@property (nonatomic, assign) int status;
@property (nonatomic, retain) NSString * movieName;//电影名

@property (nonatomic, retain) NSDate * movieTime;//电影开场时间
@property (nonatomic, retain) NSDate * updateTime;//更新信息的时间

@property (nonatomic, retain) NSNumber * favoriteCount;//左边是别人关注我的。
@property (nonatomic, retain) NSNumber * followerCount;
@property (nonatomic, retain) NSNumber * isVip;

@property (nonatomic,retain) NSNumber * messageCount; //私信数量
@property (nonatomic,retain) NSNumber * collectCount; //看过几部电影
@property (nonatomic,retain) NSNumber * likeCount; //想看电影数量
@property (nonatomic,retain) NSNumber * commentCount; //发过评论数量
@property (nonatomic,retain) NSNumber * friendCount; //好友数量

@property (nonatomic, retain) NSString * userGroup;//用户组 例如特约撰稿人等
@property (nonatomic, assign) NSInteger userGroupId;//用户组 例如特约撰稿人等

@property (nonatomic, retain) NSString * userRel;//发帖人和用户之间的关系



+ (KKZUser *)getUserWithId:(unsigned int)userId;
- (void)updateDataFromUser:(NSDictionary *)dict;
- (void)updateDataFromFavoritesList:(NSDictionary *)dict;
- (void)updateDataFromUserFollowerList:(NSDictionary *)dict;

- (void)updateDataFromKotaShare:(NSDictionary *)dict;
- (void)updateDataFromKotaRequest:(NSDictionary *)dict;

-(NSString *)avatarPathFinal;

-(NSString *)nicknameFinal;

@end
