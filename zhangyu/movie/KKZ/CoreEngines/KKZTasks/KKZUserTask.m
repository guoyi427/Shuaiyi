//
//  FavListTask.m
//  Aimeili
//
//  Created by da zhang on 12-8-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "Cinema.h"
#import "Comment.h"
#import "Cryptor.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "FriendHomeMessage.h"
#import "KKZUser.h"
#import "KKZUserTask.h"
#import "KotaTicketMessage.h"
#import "MemContainer.h"
#import "Movie.h"
#import "NSStringExtra.h"
#import "PlatformUser.h"
#import "UserMessage.h"
#import "kotaComment.h"

@implementation KKZUserTask

- (id)initFavoriteListFor:(unsigned int)uId
                     page:(NSInteger)page
               searchText:(NSString *)searchText
                 finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.userId = [NSString stringWithFormat:@"%u", uId];
    self.pageNum = page;
    self.searchText = searchText;
    self.pageSize = 10;
    self.taskType = TaskTypeFavoriteList;
    self.finishBlock = block;
  }
  return self;
}

- (id)initFollowingListFor:(unsigned int)uId
                      page:(NSInteger)page
                searchText:(NSString *)searchText
                  finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.userId = [NSString stringWithFormat:@"%u", uId];
    self.pageNum = page;
    self.searchText = searchText;
    self.pageSize = 10;
    self.taskType = TaskTypeFollowingList;
    self.finishBlock = block;
  }
  return self;
}

- (id)initFriendListFor:(unsigned int)uId
                   page:(NSInteger)page
             searchText:(NSString *)searchText
                   sort:(NSString *)sort
               finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.userId = [NSString stringWithFormat:@"%u", uId];
    self.pageNum = page;
    self.searchText = searchText;
    self.sort = sort;
    self.pageSize = 10;
    self.taskType = TaskTypeFriendList;
    self.finishBlock = block;
  }
  return self;
}


- (id)initFriendHomeListFor:(unsigned int)userId
                       page:(NSInteger)page
                   finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.userId = [NSString stringWithFormat:@"%u", userId];
    self.pageNum = page;
    self.pageSize = 15;
    self.taskType = TaskTypeUserFriendHomeList;
    self.finishBlock = block;
  }
  return self;
}

- (id)initMyHomeListFor:(unsigned int)userId
                   page:(NSInteger)page
               finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.userId = [NSString stringWithFormat:@"%u", userId];
    self.pageNum = page;
    self.pageSize = 15;
    self.taskType = TaskTypeUserMyHomeList;
    self.finishBlock = block;
  }
  return self;
}

- (id)initAddFriend:(unsigned int)userId finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.userId = [NSString stringWithFormat:@"%u", userId];
    self.pageSize = 10;
    self.taskType = TaskTypeAddFriend;
    self.finishBlock = block;
  }
  return self;
}

- (id)initGetInvitedFriend:(NSString *)sessionId username:(NSString *)username {
  self = [super init];
  if (self) {
    self.sessionId = sessionId;
    self.username = username;
    self.taskType = TaskTypeInvitedFriend;
  }
  return self;
}

- (id)initDelFriend:(unsigned int)userId finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.userId = [NSString stringWithFormat:@"%u", userId];
    self.taskType = TaskTypeDelFriend;
    self.finishBlock = block;
  }
  return self;
}

- (id)initUserRelationWith:(unsigned int)userId
                  finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeKotaUserRelation;
    self.userId = [NSString stringWithFormat:@"%u", userId];
    self.finishBlock = block;
  }
  return self;
}

- (id)initSinaWeiboUserListWith:(NSString *)userId
                          token:(NSString *)token
                        ForPage:(NSInteger)page
                    isNewFriend:(NSString *)isNewFriend
                       finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.pageNum = page;
    self.userId = userId;
    self.pageSize = 10;
    self.token = token;
    self.isNewFriend = isNewFriend;
    self.taskType = TaskTypeSinaWeiboFriendList;
    self.finishBlock = block;
  }
  return self;
}

//验证通讯录电话号码||查询通讯录所有联系人
- (id)initIdentifyPhoneNum:(NSString *)phoneArray
                      page:(NSInteger)page
               isNewFriend:(NSString *)isNewFriend
                  finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.phoneArray = phoneArray;
    self.taskType = TaskTypeIdentifyPhoneNum;
    self.isNewFriend = isNewFriend;
    self.finishBlock = block;
  }
  return self;
}

- (void)getReady {
  if (taskType == TaskTypeFavoriteList) {
    //查询好友
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"query_favorites.chtml"]];

    [self addParametersWithValue:self.userId forKey:@"user_id"];

    if (self.searchText && self.searchText.length > 0) {
      [self addParametersWithValue:self.searchText
                            forKey:@"searchText"]; //查询文本，模糊查询
      [self addParametersWithValue:[NSString stringWithFormat:@"1"]
                            forKey:@"pageNum"];
      [self addParametersWithValue:[NSString stringWithFormat:@"%d", 100]
                            forKey:@"pageSize"];
    } else {
      [self
          addParametersWithValue:[NSString stringWithFormat:@"%ld",
                                                            (long)self.pageNum]
                          forKey:@"pageNum"];
      [self addParametersWithValue:[NSString
                                       stringWithFormat:@"%d", self.pageSize]
                            forKey:@"pageSize"];
    }

    [self setRequestMethod:@"GET"];
  }

  if (taskType == TaskTypeSearchFriendMovie) {
    [self setRequestURL:[NSString
                            stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                             @"queryUserLastOrderMovie.chtml"]];

    [self addParametersWithValue:self.userId forKey:@"user_id"];

    [self setRequestMethod:@"GET"];
  }

  if (taskType == TaskTypeFollowingList) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"query_followers.chtml"]];

    [self addParametersWithValue:self.userId forKey:@"user_id"];

    if (self.searchText && self.searchText.length > 0) {
      [self addParametersWithValue:self.searchText
                            forKey:@"searchText"]; //查询文本，模糊查询
      [self addParametersWithValue:[NSString stringWithFormat:@"1"]
                            forKey:@"pageNum"];
      [self addParametersWithValue:[NSString stringWithFormat:@"%d", 100]
                            forKey:@"pageSize"];
    } else {
      [self
          addParametersWithValue:[NSString stringWithFormat:@"%ld",
                                                            (long)self.pageNum]
                          forKey:@"pageNum"];
      [self addParametersWithValue:[NSString
                                       stringWithFormat:@"%d", self.pageSize]
                            forKey:@"pageSize"];
    }

    [self setRequestMethod:@"GET"];
  }
  if (taskType == TaskTypeFriendList) {
    //查询好友
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"query_new_friends.chtml"]];

    [self addParametersWithValue:self.userId forKey:@"user_id"];
    [self addParametersWithValue:self.sort forKey:@"sort"];

    if ([self.sort isEqualToString:@"2"]) { //查询好友，按字母排序
      self.pageSize = 1000;
    }

    if (self.searchText && self.searchText.length > 0) {
      self.pageSize = 1000;
      [self addParametersWithValue:self.searchText
                            forKey:@"searchText"]; //查询文本，模糊查询
      [self addParametersWithValue:[NSString stringWithFormat:@"1"]
                            forKey:@"pageNum"];
      [self addParametersWithValue:[NSString
                                       stringWithFormat:@"%d", self.pageSize]
                            forKey:@"pageSize"];
    } else {
      [self
          addParametersWithValue:[NSString stringWithFormat:@"%ld",
                                                            (long)self.pageNum]
                          forKey:@"pageNum"];
      [self addParametersWithValue:[NSString
                                       stringWithFormat:@"%d", self.pageSize]
                            forKey:@"pageSize"];
    }

    [self setRequestMethod:@"GET"];
  }

  if (taskType == TaskTypeUserFriendHomeList) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"queryFriendCenter.chtml"]];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];
    [self addParametersWithValue:self.userId forKey:@"friend_id"];

    [self addParametersWithValue:[NSString stringWithFormat:@"%ld",
                                                            (long)self.pageNum]
                          forKey:@"pageNum"];
    [self addParametersWithValue:[NSString stringWithFormat:@"%d", 15]
                          forKey:@"pageSize"];

    [self setRequestMethod:@"GET"];
  }

  if (taskType == TaskTypeUserMyHomeList) {

    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"queryCenter.chtml"]];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];
    [self addParametersWithValue:self.userId forKey:@"user_id"];
    [self addParametersWithValue:[NSString stringWithFormat:@"%ld",
                                                            (long)self.pageNum]
                          forKey:@"pageNum"];
    [self addParametersWithValue:[NSString stringWithFormat:@"%d", 15]
                          forKey:@"pageSize"];

    [self setRequestMethod:@"GET"];
  }

  if (taskType == TaskTypeAddFriend) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"add_friend.chtml"]];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];
    [self addParametersWithValue:self.userId forKey:@"friend_id"];

    [self setRequestMethod:@"GET"];
  }
  if (taskType == TaskTypeInvitedFriend) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"pull_friend.chtml"]];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];
    [self addParametersWithValue:self.username forKey:@"username"];

    [self setRequestMethod:@"GET"];
  }

  if (taskType == TaskTypeDelFriend) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"remove_friend.chtml"]];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];
    [self addParametersWithValue:self.userId forKey:@"friend_id"];

    [self setRequestMethod:@"GET"];
  }
  if (taskType == TaskTypeSinaWeiboFriendList) {
    [self setRequestURL:[NSString
                            stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                             @"import_friend_by_sina.chtml"]];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];

    [self addParametersWithValue:self.userId forKey:@"sina_uid"];
    [self addParametersWithValue:self.token forKey:@"sina_token"];

    if (self.isNewFriend) {
      self.pageSize = 200;
      [self addParametersWithValue:self.isNewFriend forKey:@"is_new_friend"];
      [self addParametersWithValue:[NSString stringWithFormat:@"%d", 1]
                            forKey:@"pageNum"];
      [self addParametersWithValue:[NSString
                                       stringWithFormat:@"%d", self.pageSize]
                            forKey:@"pageSize"];
    } else {
      [self
          addParametersWithValue:[NSString stringWithFormat:@"%ld",
                                                            (long)self.pageNum]
                          forKey:@"pageNum"];
      [self addParametersWithValue:[NSString
                                       stringWithFormat:@"%d", self.pageSize]
                            forKey:@"pageSize"];
    }

    [self setRequestMethod:@"GET"];
  }
  if (taskType == TaskTypeIdentifyPhoneNum) {
    [self setRequestURL:[NSString
                            stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                             @"import_friend_by_mobile.chtml"]];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];
    [self addParametersWithValue:self.phoneArray forKey:@"usernames"];

    if (self.isNewFriend) {
      [self addParametersWithValue:self.isNewFriend forKey:@"is_new_friend"];
    }

    [self setRequestMethod:@"POST"];
  }
  if (taskType == TaskTypeKotaUserRelation) {
    [self setRequestURL:[NSString
                            stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                             @"query_friend_isexist.chtml"]];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];
    [self addParametersWithValue:self.userId forKey:@"friend_id"];

    [self setRequestMethod:@"GET"];
  }
}

- (int)cacheVaildTime {
  return 0;
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {
  if (taskType == TaskTypeFavoriteList) {
    DLog(@"following list succeded %@", result);
    NSDictionary *dict = (NSDictionary *)result;

    NSMutableArray *favoriteList = [[NSMutableArray alloc] init];

    NSArray *users = [dict objectForKey:@"favorites"];
    if ([users count]) {
      for (NSDictionary *aUser in users) {
        NSString *uId = [aUser kkz_stringForKey:@"uid"];

        if (uId) {
          NSNumber *existed = nil;
          KKZUser *current =
              (KKZUser *)[[MemContainer me] instanceFromDict:aUser
                                                       clazz:[KKZUser class]
                                       updateTypeWhenExisted:UpdateTypeReplace
                                                       exist:&existed];
          [current updateDataFromFavoritesList:aUser];

          [favoriteList addObject:current];
        }
      }
    } else {
      [self deleteCache];
    }

    [self doCallBack:YES
                info:[NSDictionary
                         dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:([users count] >=
                                                       self.pageSize)],
                             @"hasMore",
                             [NSNumber numberWithInteger:[users count]],
                             @"count", favoriteList, @"favorites", nil]];
  } else if (taskType == TaskTypeSearchFriendMovie) {

    DLog(@"following list succeded %@", result);
    NSDictionary *dict = (NSDictionary *)result;
    NSString *posterPath = nil;

    if ([dict[@"url"] isEqual:[NSNull null]] || dict[@"url"] == [NSNull null] ||
        dict[@"url"] == nil) {
      posterPath = nil;

      [self doCallBack:YES info:nil];
    } else {
      posterPath = dict[@"url"];

      [self doCallBack:YES
                  info:[NSDictionary
                           dictionaryWithObjectsAndKeys:posterPath,
                                                        @"posterPathBg", nil]];
    }
  }

  else if (taskType == TaskTypeFollowingList) {
    DLog(@"TaskTypeFollowingList list succeded");
    NSDictionary *dict = (NSDictionary *)result;

    NSArray *jsons = dict[@"followers"];
    NSMutableArray *followers = [[NSMutableArray alloc] init];

    if ([jsons count]) {
      for (NSInteger i = jsons.count - 1; i >= 0; i--) {
        NSDictionary *aUser = jsons[i];
        NSString *uId = [aUser kkz_stringForKey:@"uid"];
        if (uId) {
          NSNumber *existed = nil;
          KKZUser *current =
              (KKZUser *)[[MemContainer me] instanceFromDict:aUser
                                                       clazz:[KKZUser class]
                                       updateTypeWhenExisted:UpdateTypeMerge
                                                       exist:&existed];

          [current updateDataFromUserFollowerList:aUser];
          [followers addObject:current];
        }
      }
    } else {
      [self deleteCache];
    }

    int page = [dict[@"page"] intValue];
    int total = [dict[@"total"] intValue];
    int count = [dict[@"count"] intValue];

    [self doCallBack:YES
                info:[NSDictionary
                         dictionaryWithObjectsAndKeys:
                             [NSNumber
                                 numberWithBool:(total > page * self.pageSize)],
                             @"hasMore", [NSNumber numberWithInt:count],
                             @"count", [NSNumber numberWithInt:total], @"total",
                             [NSNumber numberWithInt:page], @"page", followers,
                             @"followers", nil]];
  } else if (taskType == TaskTypeFriendList) {
    DLog(@"following list succeded");
    NSDictionary *dict = (NSDictionary *)result;
    NSMutableArray *friendList = [[NSMutableArray alloc] init];

    NSArray *users = [dict objectForKey:@"friends"];
    if ([users count]) {
      for (NSDictionary *aUser in users) {
        NSString *uId = [aUser kkz_stringForKey:@"uid"];

        if (uId) {

          NSNumber *existed = nil;
          KKZUser *current =
              (KKZUser *)[[MemContainer me] instanceFromDict:aUser
                                                       clazz:[KKZUser class]
                                       updateTypeWhenExisted:UpdateTypeMerge
                                                       exist:&existed];
          [current updateDataFromUserFollowerList:aUser];
          [friendList addObject:current];
        }
      }
    } else {
    }

    [self
        doCallBack:YES
              info:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:([users count] >=
                                                               self.pageSize)],
                                     @"hasMore",
                                     [NSNumber numberWithInteger:[users count]],
                                     @"count", friendList, @"friends", nil]];
  } else if (taskType == TaskTypeUserMyHomeList) {
    DLog(@"TaskTypeUserMyHomeList list succeded %@", result);

    NSDictionary *dict = (NSDictionary *)result;

    // comment里 有一个targetType 1 是影片2是影院

    //        0,7 约电影
    //        16 想看
    //        13 评论

    NSArray *jsons = [dict objectForKey:@"result"];

    NSMutableArray *userMessageAll = [[NSMutableArray alloc] init];

    if ([jsons count]) {
      for (int i = 0; i < jsons.count; i++) {
        NSDictionary *aKota = jsons[i];

        if ([aKota objectForKey:@"id"] &&
            [aKota objectForKey:@"id"] != [NSNull null]) {

          NSNumber *existed = nil;
          FriendHomeMessage *newKota = (FriendHomeMessage *)[[MemContainer me]
              instanceFromDict:aKota
                         clazz:[FriendHomeMessage class]
                         exist:&existed];

          newKota.createTime = [aKota objectForKey:@"createTime"];

          if (![existed boolValue]) {
          }
          if (aKota[@"comment"]) {

            if ([aKota[@"comment"] isKindOfClass:[NSDictionary class]]) {

              NSDictionary *commentDic = aKota[@"comment"];
              if ([commentDic objectForKey:@"commentId"] &&
                  [commentDic objectForKey:@"commentId"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                Comment *comment = (Comment *)[[MemContainer me]
                         instanceFromDict:commentDic
                                    clazz:[Comment class]
                    updateTypeWhenExisted:UpdateTypeMerge
                                    exist:&existed1];

                newKota.commentId = comment.commentId;
              }
            }
          }

          if (aKota[@"movie"]) {

            if ([aKota[@"movie"] isKindOfClass:[NSDictionary class]]) {

              NSDictionary *movieDic = aKota[@"movie"];

              if ([movieDic objectForKey:@"movieId"] &&
                  [movieDic objectForKey:@"movieId"] != [NSNull null]) {

                  Movie *movie = [MTLJSONAdapter modelOfClass:[Movie class] fromJSONDictionary:movieDic error:nil];
                  [[MemContainer me] putObject:movie];

                newKota.movieId = movie.movieId.intValue;
              }
            }
          }

          if (aKota[@"kota"]) {

            if ([aKota[@"kota"] isKindOfClass:[NSDictionary class]]) {

              NSDictionary *kotaDic = aKota[@"kota"];

              if ([kotaDic objectForKey:@"id"] &&
                  [kotaDic objectForKey:@"id"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                KotaTicketMessage *kotaM = (KotaTicketMessage *)[
                    [MemContainer me] instanceFromDict:kotaDic
                                                 clazz:[KotaTicketMessage class]
                                                 exist:&existed1];

                newKota.kotaId = kotaM.kotaId;
              }
            }
          }

          if (aKota[@"kotaComment"]) {

            if ([aKota[@"kotaComment"] isKindOfClass:[NSDictionary class]]) {

              NSDictionary *kotaCommentDic = aKota[@"kotaComment"];

              if ([kotaCommentDic objectForKey:@"id"] &&
                  [kotaCommentDic objectForKey:@"id"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                kotaComment *kotaC = (kotaComment *)[[MemContainer me]
                    instanceFromDict:kotaCommentDic
                               clazz:[kotaComment class]
                               exist:&existed1];

                newKota.kotaCommentId = kotaC.kotaCommentId;
              }
            }
          }

          if (aKota[@"requestKotaComment"]) {

            if ([aKota[@"requestKotaComment"]
                    isKindOfClass:[NSDictionary class]]) {

              NSDictionary *kotaCommentDic = aKota[@"requestKotaComment"];

              if ([kotaCommentDic objectForKey:@"id"] &&
                  [kotaCommentDic objectForKey:@"id"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                kotaComment *kotaC = (kotaComment *)[[MemContainer me]
                    instanceFromDict:kotaCommentDic
                               clazz:[kotaComment class]
                               exist:&existed1];

                newKota.requestKotaCommentId = kotaC.kotaCommentId;
              }
            }
          }

          if (aKota[@"shareUser"]) {

            if ([aKota[@"shareUser"] isKindOfClass:[NSDictionary class]]) {

              NSDictionary *shareUserDic = aKota[@"shareUser"];
              if ([shareUserDic objectForKey:@"userId"] &&
                  [shareUserDic objectForKey:@"userId"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                KKZUser *user = (KKZUser *)[[MemContainer me]
                         instanceFromDict:shareUserDic
                                    clazz:[KKZUser class]
                    updateTypeWhenExisted:UpdateTypeReplace
                                    exist:&existed1];

                newKota.shareUserId = user.userId;
              }
            }
          }

          if (aKota[@"requestUser"]) {

            if ([aKota[@"requestUser"] isKindOfClass:[NSDictionary class]]) {

              NSDictionary *userDic = aKota[@"requestUser"];
              if ([userDic objectForKey:@"userId"] &&
                  [userDic objectForKey:@"userId"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                KKZUser *user = (KKZUser *)[[MemContainer me]
                         instanceFromDict:userDic
                                    clazz:[KKZUser class]
                    updateTypeWhenExisted:UpdateTypeReplace
                                    exist:&existed1];

                newKota.requestUserId = user.userId;
              }
            }
          }

          if (aKota[@"cinema"]) {

            if ([aKota[@"cinema"] isKindOfClass:[NSDictionary class]]) {

              NSDictionary *cinemaDic = aKota[@"cinema"];
              if ([cinemaDic objectForKey:@"cinemaId"] &&
                  [cinemaDic objectForKey:@"cinemaId"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                Cinema *cinema =
                    (Cinema *)[[MemContainer me] instanceFromDict:cinemaDic
                                                            clazz:[Cinema class]
                                                            exist:&existed1];

                newKota.cinemaId = cinema.cinemaId;
              }
            }
          }

          [userMessageAll addObject:newKota];
        }
      }
    } else {
      [self deleteCache];
    }

    int total = [dict[@"total"] intValue];  // 总数
    int page = [dict[@"pageNum"] intValue]; // 第几页
    int count = [dict[@"count"] intValue];  // 当页页码size
    //        BOOL hasmore = false;
    //        if ([jsons count] == 15) {
    //            hasmore = true;
    //        }

    [self doCallBack:YES
                info:[NSDictionary
                         dictionaryWithObjectsAndKeys:
                             [NSNumber
                                 numberWithBool:(userMessageAll.count >= 10)],
                             @"hasMore", [NSNumber numberWithInt:count],
                             @"count", [NSNumber numberWithInt:total], @"total",
                             [NSNumber numberWithInt:page], @"page",
                             userMessageAll, @"results", nil]];
  }

  else if (taskType == TaskTypeUserFriendHomeList) {
    DLog(@"message list succeded %@", result);

    NSDictionary *dict = (NSDictionary *)result;

    //        0,7 约电影
    //        16 想看
    //        13 评论

    NSArray *jsons = [dict objectForKey:@"result"];

    NSMutableArray *userMessageAll = [[NSMutableArray alloc] init];

    if ([jsons count]) {
      for (int i = 0; i < jsons.count; i++) {
        NSDictionary *aKota = jsons[i];

        if ([aKota objectForKey:@"id"] &&
            [aKota objectForKey:@"id"] != [NSNull null]) {

          NSNumber *existed = nil;

          FriendHomeMessage *newKota = (FriendHomeMessage *)[[MemContainer me]
                   instanceFromDict:aKota
                              clazz:[FriendHomeMessage class]
              updateTypeWhenExisted:UpdateTypeReplace
                              exist:&existed];

          newKota.createTime = [aKota objectForKey:@"createTime"];

          if (![existed boolValue]) {
          }

          if (aKota[@"comment"]) {
            if ([aKota[@"comment"] isKindOfClass:[NSDictionary class]]) {
              NSDictionary *commentDic = aKota[@"comment"];
              if ([commentDic objectForKey:@"commentId"] &&
                  [commentDic objectForKey:@"commentId"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                Comment *comment = (Comment *)[[MemContainer me]
                         instanceFromDict:commentDic
                                    clazz:[Comment class]
                    updateTypeWhenExisted:UpdateTypeReplace
                                    exist:&existed1];

                newKota.commentId = comment.commentId;
              }
            }
          }

          if (aKota[@"movie"]) {
            if ([aKota[@"movie"] isKindOfClass:[NSDictionary class]]) {

              NSDictionary *movieDic = aKota[@"movie"];

              if ([movieDic objectForKey:@"movieId"] &&
                  [movieDic objectForKey:@"movieId"] != [NSNull null]) {

                  Movie *movie = [MTLJSONAdapter modelOfClass:[Movie class] fromJSONDictionary:movieDic error:nil];
                  [[MemContainer me] putObject:movie];

                newKota.movieId = movie.movieId.intValue;
              }
            }
          }

          if (aKota[@"kotaComment"]) {

            if ([aKota[@"kotaComment"] isKindOfClass:[NSDictionary class]]) {

              NSDictionary *kotaCommentDic = aKota[@"kotaComment"];

              if ([kotaCommentDic objectForKey:@"id"] &&
                  [kotaCommentDic objectForKey:@"id"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                kotaComment *kotaC = (kotaComment *)[[MemContainer me]
                    instanceFromDict:kotaCommentDic
                               clazz:[kotaComment class]
                               exist:&existed1];

                newKota.kotaCommentId = kotaC.kotaCommentId;
              }
            }
          }

          if (aKota[@"requestKotaComment"]) {

            if ([aKota[@"requestKotaComment"]
                    isKindOfClass:[NSDictionary class]]) {

              NSDictionary *kotaCommentDic = aKota[@"requestKotaComment"];

              if ([kotaCommentDic objectForKey:@"id"] &&
                  [kotaCommentDic objectForKey:@"id"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                kotaComment *kotaC = (kotaComment *)[[MemContainer me]
                    instanceFromDict:kotaCommentDic
                               clazz:[kotaComment class]
                               exist:&existed1];

                newKota.requestKotaCommentId = kotaC.kotaCommentId;
              }
            }
          }

          if (aKota[@"kota"]) {

            if ([aKota[@"kota"] isKindOfClass:[NSDictionary class]]) {

              NSDictionary *kotaDic = aKota[@"kota"];

              if ([kotaDic objectForKey:@"id"] &&
                  [kotaDic objectForKey:@"id"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                KotaTicketMessage *kotaM = (KotaTicketMessage *)[
                    [MemContainer me] instanceFromDict:kotaDic
                                                 clazz:[KotaTicketMessage class]
                                                 exist:&existed1];

                newKota.kotaId = kotaM.kotaId;
              }
            }
          }

          if (aKota[@"shareUser"]) {
            if ([aKota[@"shareUser"] isKindOfClass:[NSDictionary class]]) {
              NSDictionary *shareUserDic = aKota[@"shareUser"];
              if ([shareUserDic objectForKey:@"userId"] &&
                  [shareUserDic objectForKey:@"userId"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                KKZUser *user = (KKZUser *)[[MemContainer me]
                         instanceFromDict:shareUserDic
                                    clazz:[KKZUser class]
                    updateTypeWhenExisted:UpdateTypeReplace
                                    exist:&existed1];

                newKota.shareUserId = user.userId;
              }
            }
          }

          if (aKota[@"requestUser"]) {
            if ([aKota[@"requestUser"] isKindOfClass:[NSDictionary class]]) {

              NSDictionary *userDic = aKota[@"requestUser"];
              if ([userDic objectForKey:@"userId"] &&
                  [userDic objectForKey:@"userId"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                KKZUser *user = (KKZUser *)[[MemContainer me]
                         instanceFromDict:userDic
                                    clazz:[KKZUser class]
                    updateTypeWhenExisted:UpdateTypeReplace
                                    exist:&existed1];

                newKota.requestUserId = user.userId;
              }
            }
          }

          if (aKota[@"cinema"]) {
            if ([aKota[@"cinema"] isKindOfClass:[NSDictionary class]]) {

              NSDictionary *cinemaDic = aKota[@"cinema"];
              if ([cinemaDic objectForKey:@"cinemaId"] &&
                  [cinemaDic objectForKey:@"cinemaId"] != [NSNull null]) {

                NSNumber *existed1 = nil;
                Cinema *cinema = (Cinema *)[[MemContainer me]
                         instanceFromDict:cinemaDic
                                    clazz:[Cinema class]
                    updateTypeWhenExisted:UpdateTypeMerge
                                    exist:&existed1];

                newKota.cinemaId = cinema.cinemaId;
              }
            }
          }

          [userMessageAll addObject:newKota];
        }
      }
    } else {
      [self deleteCache];
    }

    int total = [dict[@"total"] intValue];  // 总数
    int page = [dict[@"pageNum"] intValue]; // 第几页
    int count = [dict[@"count"] intValue];  // 当页页码size

    [self doCallBack:YES
                info:[NSDictionary
                         dictionaryWithObjectsAndKeys:
                             [NSNumber
                                 numberWithBool:(userMessageAll.count >= 10)],
                             @"hasMore", [NSNumber numberWithInt:count],
                             @"count", [NSNumber numberWithInt:total], @"total",
                             [NSNumber numberWithInt:page], @"page",
                             userMessageAll, @"results", nil]];
  }

  if (taskType == TaskTypeAddFriend) {
    DLog(@"add Friend succeded");
    [self doCallBack:YES info:nil];
  }

  if (taskType == TaskTypeInvitedFriend) {
    DLog(@"TaskTypeInvitedFriend Friend succeded  %@", result);
    [self postNotificationSucceeded:YES withInfo:nil];
  }

  if (taskType == TaskTypeDelFriend) {
    DLog(@"delFriend succeded %@", result);

    [self doCallBack:YES info:@{ self.userId : @"userId" }];
  }
  if (taskType == TaskTypeKotaUserRelation) {
    NSDictionary *dict = (NSDictionary *)result;
    DLog(@"TaskTypeKotaUserRelation task succeded: %@", dict);

    [self doCallBack:YES
                info:[NSDictionary
                         dictionaryWithObjectsAndKeys:
                             [dict kkz_intNumberForKey:@"tag"], @"tag", nil]];
  }
  if (taskType == TaskTypeSinaWeiboFriendList) {
    DLog(@"TaskTypeSinaWeiboFriendList succeded %@", result);

    NSDictionary *dict = (NSDictionary *)result;

    NSMutableArray *friendList = [[NSMutableArray alloc] init];
    NSMutableArray *friendDBAll = [[NSMutableArray alloc] init];

    NSArray *users = [dict objectForKey:@"result"];
    int totalNum = [[dict kkz_intNumberForKey:@"total"] intValue];
    int page = totalNum / 10;
    if (totalNum % 10) {
      page += 1;
    }
    if (users && [users isKindOfClass:[NSArray class]]) {
    } else {
      users = [[NSArray alloc] init];
    }

    if ([users count]) {
      for (NSDictionary *aUser in users) {
        NSString *userId = nil;
        if ([aUser objectForKey:@"username"] &&
            [aUser objectForKey:@"username"] != [NSNull null]) {
          userId = [aUser kkz_stringForKey:@"username"];

          PlatformUser *newUser = [[PlatformUser alloc] init];
          [newUser updateDataFromDict:aUser];
          [friendList addObject:userId];
          [friendDBAll addObject:newUser];

          newUser.userPlat = [NSNumber numberWithInt:PlatUserSinaWeibo];
        }
      }
    } else {
      [self deleteCache];
    }

    [self
        doCallBack:YES
              info:[NSDictionary
                       dictionaryWithObjectsAndKeys:@([friendDBAll count]),
                                                    @"hasMore",
                                                    //[NSNumber
                                                    //numberWithBool:([users
                                                    //count] >= self.pageSize)],
                                                    //@"hasMore",
                                                    [NSNumber
                                                        numberWithInt:page],
                                                    @"count", friendList,
                                                    @"friendList", friendDBAll,
                                                    @"friends", nil]];
  }
  if (taskType == TaskTypeIdentifyPhoneNum) {
    DLog(@"TaskTypeIdentifyPhoneNum succeded");

    NSDictionary *dict = (NSDictionary *)result;
    [self doCallBack:YES info:dict];
  }
}

- (void)requestFailedWithError:(NSError *)error {
  if (taskType == TaskTypeFollowingList) {
    DLog(@"following list failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
  if (taskType == TaskTypeFavoriteList) {
    DLog(@"TaskTypeFavoriteList list failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
  if (taskType == TaskTypeFriendList) {
    DLog(@"TaskTypeFriendList list failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
  if (taskType == TaskTypeUserMyHomeList) {
    DLog(@"TaskTypeUserMyHomeList failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
  if (taskType == TaskTypeUserFriendHomeList) {
    DLog(@"TaskTypeUserFriendHomeList failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
  if (taskType == TaskTypeAddFriend) {
    DLog(@"TaskTypeAddFriend failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
  if (taskType == TaskTypeInvitedFriend) {
    DLog(@"TaskTypeInvitedFriend failed: %@", [error description]);
    [self postNotificationSucceeded:NO withInfo:[error userInfo]];
  }
  if (taskType == TaskTypeDelFriend) {
    DLog(@"TaskTypeDelFriend failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
  if (taskType == TaskTypeKotaUserRelation) {
    DLog(@"TaskTypeKotaUserRelation failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
  if (taskType == TaskTypeSinaWeiboFriendList) {
    DLog(@"TaskTypeSinaWeiboFriendListfailed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
  if (taskType == TaskTypeIdentifyPhoneNum) {
    DLog(@"TaskTypeIdentifyPhoneNum failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
  if (taskType == TaskTypeSearchFriendMovie) {
    DLog(@"TaskTypeSearchFriendMovie failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
}

- (void)requestSucceededConnection {
  // if needed do something after connected to net, handle here
}

// upload process
- (void)uploadBytesWritten:(NSInteger)written
         totalBytesWritten:(NSInteger)totalWritten
 totalBytesExpectedToWrite:(NSInteger)totalExpectedToWrite {
  // just for upload task
}

@end
