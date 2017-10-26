//
//  MessageTask.m
//  KoMovie
//
//  Created by zhoukai on 1/10/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "Cinema.h"
#import "Comment.h"
#import "DataEngine.h"
#import "FriendHomeMessage.h"
#import "HXUserInfo.h"
#import "KKZUser.h"
#import "KotaTicketMessage.h"
#import "MemContainer.h"
#import "MemContainer.h"
#import "MessageTalk.h"
#import "MessageTask.h"
#import "Movie.h"
#import "kotaComment.h"

@implementation MessageTask {
}

- (int)cacheVaildTime {
  return 0;
}

- (id)initQueryMessageUserInfoList:(NSString *)userIds
                          finished:(FinishDownLoadBlock)block {
  self = [super init];

  if (self) {
    self.taskType = TaskTypeQueryMessageUserInfoList;
    self.userIds = userIds;
    self.finishBlock = block;
  }

  return self;
}

//删除约会信息
- (id)initDeleteMessageWithInviteMovieId:(int)inviteMovieId
                                finished:(FinishDownLoadBlock)block {
  self = [super init];

  if (self) {
    self.taskType = TaskTypeAppointmentDeleteMessage;
    self.inviteMovieId = inviteMovieId;
    self.finishBlock = block;
  }

  return self;
}

//约电影消息
- (id)initAppointmentMessageListPageNum:(int)page
                               finished:(FinishDownLoadBlock)block {
  self = [super init];

  if (self) {
    self.taskType = TaskTypeAppointmentMessageList;
    self.pageNum = page;
    self.finishBlock = block;
    self.pageSize = 15;
    self.sessionId = [DataEngine sharedDataEngine].sessionId;
  }

  return self;
}

- (void)getReady {
  if (taskType == TaskTypeQueryMessageUserInfoList) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"querySmallUsers.chtml"]];
    [self addParametersWithValue:self.userIds forKey:@"user_ids"];
    [self setRequestMethod:@"GET"];
  }

  else if (taskType == TaskTypeAppointmentMessageList) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"queryInviteMovies.chtml"]];
    [self addParametersWithValue:self.sessionId forKey:@"session_id"];
    [self addParametersWithValue:[NSString stringWithFormat:@"%d", self.pageNum]
                          forKey:@"pageNum"];
    [self addParametersWithValue:@"15" forKey:@"pageSize"];
    [self setRequestMethod:@"GET"];
  } else if (taskType == TaskTypeAppointmentDeleteMessage) {
    [self
        setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                 @"removieInviteMovie.chtml"]];
    [self addParametersWithValue:[NSString
                                     stringWithFormat:@"%d", self.inviteMovieId]
                          forKey:@"invite_movie_id"];
    [self setRequestMethod:@"GET"];
  }
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {
  if (taskType == TaskTypeQueryMessageUserInfoList) {
    NSDictionary *dict = (NSDictionary *)result;
    //
    //        NSError *error;
    //        NSData	*jsonData = [NSJSONSerialization
    //        dataWithJSONObject:dict
    //                                                          options
    //                                                          :NSJSONWritingPrettyPrinted
    //                                                            error
    //                                                            :&error];

    int status = [dict[@"status"] intValue];

    if (status == 0) {
      NSArray *jsons = [dict objectForKey:@"users"];

      NSMutableArray *hxuserInfos = [[NSMutableArray alloc] init];

      // json --> db对象
      if ([jsons count]) {
        for (NSInteger i = 0; i < jsons.count; i++) {
          NSDictionary *obj = jsons[i];

          NSNumber *existed = nil;

          HXUserInfo *userinfo = (HXUserInfo *)[[MemContainer me]
                   instanceFromDict:obj
                              clazz:[HXUserInfo class]
              updateTypeWhenExisted:UpdateTypeReplace
                              exist:&existed];
          [hxuserInfos addObject:userinfo];
        }
      } else {
        [self deleteCache];
      }

      [self doCallBack:YES
                  info:[NSDictionary dictionaryWithObjectsAndKeys:hxuserInfos,
                                                                  @"results",
                                                                  nil]];
    } else {
    }
  } else if (taskType == TaskTypeAppointmentMessageList) {
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
      }
    } else {
      [self deleteCache];
    }

    BOOL hasmore = false;
    if ([jsons count] == 15) {
      hasmore = true;
    }

    [self doCallBack:YES
                info:[NSDictionary
                         dictionaryWithObjectsAndKeys:@(hasmore), @"hasMore",
                                                      userMessageAll,
                                                      @"results", nil]];
  } else if (taskType == TaskTypeAppointmentDeleteMessage) {

    [self doCallBack:YES info:nil];
  }
}

- (void)requestFailedWithError:(NSError *)error {
  if (taskType == TaskTypeQueryMessageUserInfoList) {
    DLog(@"TaskTypeQueryMessageUserInfoList 失败: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeAppointmentMessageList) {
    DLog(@"TaskTypeAppointmentMessageList 失败: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeAppointmentDeleteMessage) {
    DLog(@"TaskTypeAppointmentDeleteMessage 失败: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
}

@end
