//
//  MatchListTask.m
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "CacheEngine.h"
#import "CinemaDetail.h"
#import "City.h"
#import "Comment.h"
#import "DataEngine.h"
#import "FavoriteTask.h"
#import "ImageEngine.h"
#import "MemContainer.h"
#import "Movie.h"
#import "UserDefault.h"

#define kCountPerPage 20

@implementation FavoriteTask //收藏

- (int)cacheVaildTime {
  return 0;
}

//查询收藏,或者想看
- (id)initFavoriteListForUser:(NSString *)uId
                    otherWith:(NSString *)otherId
                    isCollect:(BOOL)isCollect
                         page:(int)page
                     finished:(FinishDownLoadBlock)block {

  self = [super init];
  if (self) {
    if (isCollect) {
      self.taskType = TaskTypeFavoriteMovieList;
    } else {
      self.taskType = TaskTypeFavoriteWantLookList;
    }

    self.userId = uId;
    self.otherId = otherId;
    self.isCollect = isCollect;
    self.pageNum = page;
    self.finishBlock = block;
  }
  return self;
}
//要加point
- (id)initAddFavMovie:(NSUInteger)movieId
            withPoint:(int)point
        withAudioData:(NSData *)arm
      withAudioLength:(int)length
             withText:(NSString *)comment
             finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeAddMovieFav;
    self.point = point;
    self.audioData = arm;
    self.audioLength = length;
    self.movieId = [NSString stringWithFormat:@"%lu", (unsigned long)movieId];
    self.comment = comment;
    self.finishBlock = block;
  }
  return self;
}

- (id)initAddFavCinema:(NSUInteger)cinemaId
              finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeAddCinemaFav;
    self.cinemaId = [NSString stringWithFormat:@"%lu", (unsigned long)cinemaId];
    self.finishBlock = block;
  }
  return self;
}

- (id)initQueryFavForCinema:(NSUInteger)cinemaId
                   finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeCinemaFavStatus;
    self.cinemaId = [NSString stringWithFormat:@"%lu", (unsigned long)cinemaId];
    self.finishBlock = block;
  }
  return self;
}

//删除收藏
- (id)initDelFavMovie:(int)movieId finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeRemoveMovieFav;

    self.movieId = [NSString stringWithFormat:@"%u", movieId];
    self.finishBlock = block;
  }
  return self;
}
- (id)initDelFavCinema:(int)cinemaId finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeRemoveCinemaFav;

    self.cinemaId = [NSString stringWithFormat:@"%u", cinemaId];
    self.finishBlock = block;
  }
  return self;
}
//删除想看
- (id)initDelWantLookWithMovieId:(int)movieId
                        finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeRemoveWantLook;

    self.movieId = [NSString stringWithFormat:@"%u", movieId];
    self.finishBlock = block;
  }
  return self;
}

//成功约会
- (id)initQuerySucceedNumWithMovieId:(int)movieId
                            finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeQuerySucceedNum;
    self.movieId = [NSString stringWithFormat:@"%u", movieId];
    self.finishBlock = block;
  }
  return self;
}

//想看相关
- (id)initQueryWantWatchWithMovieId:(int)movieId
                           finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeQueryWantWatch;
    self.movieId = [NSString stringWithFormat:@"%u", movieId];
    self.finishBlock = block;
  }
  return self;
}

- (id)initClickWantWatchWithMovieId:(int)movieId
                           finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeClickWantWatch;
    self.movieId = [NSString stringWithFormat:@"%u", movieId];
    self.finishBlock = block;
  }
  return self;
}

- (instancetype)initAddLikeWithUserId:(NSString *)likeuUid
                             withType:(NSNumber *)likeType
                         withTargetId:(NSString *)targetId
                             finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeAddLike;
    self.likeType = likeType;
    self.targetId = targetId;
    self.userId = likeuUid;
    self.finishBlock = block;
  }
  return self;
}

- (instancetype)initAddKotaLikeWithUserId:(NSString *)likeuUid
                                 withType:(NSNumber *)likeType
                             withTargetId:(NSString *)targetId
                                 finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeAddKotaLike;
    self.likeType = likeType;
    self.targetId = targetId;
    self.userId = likeuUid;
    self.finishBlock = block;
  }
  return self;
}


- (void)getReady {
  if (taskType == TaskTypeFavoriteMovieList) {
    [self setRequestURL:[NSString
                            stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                             @"query_collect_by_uid.chtml"]];

    [self addParametersWithValue:self.userId forKey:@"user_id"];
    [self addParametersWithValue:self.otherId forKey:@"other_id"];

    [self addParametersWithValue:[NSString stringWithFormat:@"%d", self.pageNum]
                          forKey:@"pageNum"];
    if (self.pageNum == 1 &&
        [self.otherId isEqualToString:[DataEngine sharedDataEngine].userId]) {
      [self addParametersWithValue:[NSString stringWithFormat:@"%d", 18]
                            forKey:@"pageSize"];
    } else {
      [self addParametersWithValue:[NSString stringWithFormat:@"%d", 18]
                            forKey:@"pageSize"];
    }
    [self setRequestMethod:@"GET"];
  } else if (taskType == TaskTypeFavoriteWantLookList) {
    [self setRequestURL:[NSString
                            stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                             @"query_like_film_list.chtml"]];

    [self addParametersWithValue:self.userId forKey:@"user_id"];
    [self addParametersWithValue:self.otherId forKey:@"other_id"];

    [self addParametersWithValue:[NSString stringWithFormat:@"%d", self.pageNum]
                          forKey:@"pageNum"];
    if (self.pageNum == 1 &&
        [self.otherId isEqualToString:[DataEngine sharedDataEngine].userId]) {
      [self addParametersWithValue:[NSString stringWithFormat:@"%d", 18]
                            forKey:@"pageSize"];
    } else {
      [self addParametersWithValue:[NSString stringWithFormat:@"%d", 18]
                            forKey:@"pageSize"];
    }
    [self setRequestMethod:@"GET"];
  } else if (taskType == TaskTypeAddMovieFav) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"add_movie_score.chtml"]];

    [self addParametersWithValue:self.movieId forKey:@"movieId"];
    [self addParametersWithValue:[NSString stringWithFormat:@"%f", self.point]
                          forKey:@"point"];

    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];

    if (self.audioLength > 0) {
      [self addParametersWithValue:[NSString
                                       stringWithFormat:@"%d", self.audioLength]
                            forKey:@"attach_length"];
      [self addParametersWithValue:@"2" forKey:@"comment_type"]; //语音

      [self setUploadBody:self.audioData
                 withName:@"comment_data"
                 fromFile:@"voice.mp3"];
      [self setRequestMethod:@"POST"];
    } else if (self.comment.length != 0) {
      [self addParametersWithValue:@"1" forKey:@"comment_type"]; //文字
      [self addParametersWithValue:self.comment forKey:@"content"];
      [self setRequestMethod:@"POST"];
    } else {
      [self setRequestMethod:@"GET"];
    }
  } else if (taskType == TaskTypeRemoveMovieFav) {
    [self setRequestURL:[NSString
                            stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                             @"remove_favorite_movie.chtml"]];

    [self addParametersWithValue:self.movieId forKey:@"movieId"];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];

    [self setRequestMethod:@"GET"];
  } else if (taskType == TaskTypeRemoveCinemaFav) {
    [self setRequestURL:[NSString
                            stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                             @"removie_favorite_cinema.chtml"]];

    [self addParametersWithValue:self.cinemaId forKey:@"cinema_id"];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];

    [self setRequestMethod:@"GET"];
  } else if (taskType == TaskTypeRemoveWantLook) {
    [self setRequestURL:[NSString
                            stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                             @"remove_forward_movie.chtml"]];

    [self addParametersWithValue:self.movieId forKey:@"film_id"];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];

    [self setRequestMethod:@"GET"];
  } else if (taskType == TaskTypeQuerySucceedNum) {
    [self setRequestURL:
              [NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                         @"getInviteMovieSuccessCount.chtml"]];

    [self addParametersWithValue:self.movieId forKey:@"movie_id"];

    City *city = [City getCityWithId:USER_CITY];

    [self addParametersWithValue:city.cityId.stringValue
                          forKey:@"city_id"];

    [self setRequestMethod:@"GET"];
  } else if (taskType == TaskTypeQueryWantWatch) {
    [self
        setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                 @"look_forward_status.chtml"]];

    [self addParametersWithValue:self.movieId forKey:@"film_id"];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];

    [self setRequestMethod:@"GET"];
  } else if (taskType == TaskTypeClickWantWatch) {
    [self
        setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                 @"look_forward_movie.chtml"]];

    [self addParametersWithValue:self.movieId forKey:@"film_id"];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];
    [self addParametersWithValue:[NSString stringWithFormat:@"%d", USER_CITY]
                          forKey:@"city_id"];
    [self setRequestMethod:@"GET"];
  }

  else if (taskType == TaskTypeAddLike) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"add_relation.chtml"]];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];
    [self addParametersWithValue:self.targetId forKey:@"comment_id"];
    [self addParametersWithValue:[NSString
                                     stringWithFormat:@"%d",
                                                      [self.likeType intValue]]
                          forKey:@"relation"];

    [self setRequestMethod:@"GET"];
  }

  else if (taskType == TaskTypeAddKotaLike) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                   @"add_like.chtml"]];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];

    [self addParametersWithValue:self.userId forKey:@"like_uid"];
    [self addParametersWithValue:self.targetId forKey:@"target_id"];
    [self addParametersWithValue:[NSString
                                     stringWithFormat:@"%d",
                                                      [self.likeType intValue]]
                          forKey:@"like_type"];

    [self setRequestMethod:@"GET"];
  }

    else if (taskType == TaskTypeAddCinemaFav) {
    [self
        setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                                 @"add_favorite_cinema.chtml"]];
    [self addParametersWithValue:self.cinemaId forKey:@"cinema_id"];
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];

    [self setRequestMethod:@"GET"];
  } else if (taskType == TaskTypeCinemaFavStatus) {
    [self setRequestURL:[NSString
                            stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                             @"query_favorite_cinema.chtml"]];
    if (self.cinemaId.length != 0 && ![self.cinemaId isEqualToString:@"0"]) {
      [self addParametersWithValue:self.cinemaId forKey:@"cinema_id"];
    }
    [self addParametersWithValue:[DataEngine sharedDataEngine].sessionId
                          forKey:@"session_id"];

    [self setRequestMethod:@"GET"];
  } else if (self.comment.length != 0) {
    [self addParametersWithValue:@"1" forKey:@"comment_type"]; //文字
    [self addParametersWithValue:self.comment forKey:@"content"];
    [self setRequestMethod:@"POST"];
  } else {
    [self setRequestMethod:@"GET"];
  }
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {
  if (taskType == TaskTypeFavoriteMovieList) {
    DLog(@"match list succeded");
    NSDictionary *dict = (NSDictionary *)result;

    NSArray *favorites = (NSArray *)[dict kkz_objForKey:@"films"];
    NSMutableArray *movieList = [[NSMutableArray alloc] init];

    NSMutableArray *favoriteAll = [[NSMutableArray alloc] init]; //<Favorite>

    if ([favorites count]) {
      for (NSDictionary *favorite in favorites) {
        NSString *fId = [favorite kkz_stringForKey:@"favoriteId"];
        if (fId) {

          NSNumber *existed = nil;

          Favorite *current =
              (Favorite *)[[MemContainer me] instanceFromDict:favorite
                                                        clazz:[Favorite class]
                                                        exist:&existed];

          current.userId = self.otherId.intValue;
          if ([[favorite kkz_intNumberForKey:@"status"] intValue] == 2) {
            current.isMyFav = @1;
          } else {
            current.isMyFav = @0;
          }
          [movieList addObject:current.movieId];
          [favoriteAll addObject:current];
        }
      }
    } else {
      [self deleteCache];
    }

    int total = [dict[@"total"] intValue]; //总数
    int page = [dict[@"page"] intValue];   //第几页
    int count = [dict[@"count"] intValue]; //当页的pageSize，

    int firstPageSize;
    if ([self.otherId isEqualToString:[DataEngine sharedDataEngine].userId]) {
      firstPageSize = 12;
    } else {
      firstPageSize = 12;
    }

    NSInteger fatchCountAll = 0;
    if (self.pageNum == 1) {
      fatchCountAll = favoriteAll.count;
    } else {
      fatchCountAll =
          firstPageSize + (self.pageNum - 2) * 12 + favoriteAll.count;
    }
    [self doCallBack:YES
                info:[NSDictionary
                         dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:(total > fatchCountAll)],
                             @"hasMore", [NSNumber numberWithInt:count],
                             @"count", [NSNumber numberWithInt:total], @"total",
                             [NSNumber numberWithInt:page], @"page", movieList,
                             @"movieList", favoriteAll, @"favoriteAll", nil]];
  } else if (taskType == TaskTypeFavoriteWantLookList) {
    DLog(@"match list succeded %@", result);
    NSDictionary *dict = (NSDictionary *)result;

    NSArray *favorites = (NSArray *)[dict kkz_objForKey:@"films"];

    NSMutableArray *favoriteAll =
        [[NSMutableArray alloc] initWithCapacity:0]; //<Favorite>

    if ([favorites count]) {
      for (NSDictionary *favorite in favorites) {
        NSNumber *existed = nil;

        Favorite *current =
            (Favorite *)[[MemContainer me] instanceFromDict:favorite
                                                      clazz:[Favorite class]
                                                      exist:&existed];

        if ([[favorite kkz_intNumberForKey:@"status"] intValue] == 2) {
          current.isMyFav = @1;
        } else {
          current.isMyFav = @0;
        }
        current.userId = self.otherId.intValue;
        [favoriteAll addObject:current];
      }
    } else {
      [self deleteCache];
    }

    int total = [dict[@"total"] intValue]; //总数
    int page = [dict[@"page"] intValue];   //第几页
    int count = [dict[@"count"] intValue]; //当页的pageSize，

    int firstPageSize;
    if ([self.otherId isEqualToString:[DataEngine sharedDataEngine].userId]) {
      firstPageSize = 12;
    } else {
      firstPageSize = 12;
    }

    NSInteger fatchCountAll = 0;
    if (self.pageNum == 1) {
      fatchCountAll = favoriteAll.count;
    } else {
      fatchCountAll =
          firstPageSize + (self.pageNum - 2) * 12 + favoriteAll.count;
    }

    [self doCallBack:YES
                info:[NSDictionary
                         dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:(total > fatchCountAll)],
                             @"hasMore", [NSNumber numberWithInt:count],
                             @"count", [NSNumber numberWithInt:total], @"total",
                             [NSNumber numberWithInt:page], @"page",
                             favoriteAll, @"favoriteAll", nil]];
  } else if (taskType == TaskTypeAddMovieFav) {
    NSDictionary *dict = (NSDictionary *)result;
    [self doCallBack:YES info:dict];
  } else if (taskType == TaskTypeRemoveMovieFav) {

    [self doCallBack:YES info:@{ @"movieId" : self.movieId }];
  } else if (taskType == TaskTypeRemoveCinemaFav) {

    [self doCallBack:YES info:@{ @"cinemaId" : self.cinemaId }];
  } else if (taskType == TaskTypeRemoveWantLook) {

    [self doCallBack:YES info:@{ @"movieId" : self.movieId }];
  }

  else if (taskType == TaskTypeQuerySucceedNum) {

    NSDictionary *dict = (NSDictionary *)result;
    NSNumber *num = [NSNumber numberWithInt:[dict[@"count"] intValue]];
    NSNumber *numActive =
        [NSNumber numberWithInt:[dict[@"movieSuccessCount"] intValue]];
    [self doCallBack:YES info:@{ @"num" : num, @"numActive" : numActive }];
  }

  else if (taskType == TaskTypeQueryWantWatch) {

    NSDictionary *dict = (NSDictionary *)result;

    int status = [dict[@"status"] intValue];
    if (status == 0) {

      NSNumber *tag = [NSNumber numberWithInt:[dict[@"tag"] intValue]];

      // tag == 0 未添加
      [self doCallBack:YES info:@{ @"tag" : tag }];
    }
  } else if (taskType == TaskTypeClickWantWatch) {
    NSDictionary *dict = (NSDictionary *)result;

    NSNumber *status = (NSNumber *)dict[@"status"];
    if ([status intValue] == 0) {
      [self doCallBack:YES info:@{ @"movieId" : self.movieId }];
    }
  }

  else if (taskType == TaskTypeAddLike) {
    NSDictionary *dict = (NSDictionary *)result;

    NSNumber *status = [NSNumber numberWithInt:[dict[@"status"] intValue]];
    if ([status intValue] == 0) {
      [self doCallBack:YES info:@{ @"status" : status }];
    }
  }

  else if (taskType == TaskTypeAddKotaLike) {
    NSDictionary *dict = (NSDictionary *)result;

    NSNumber *status = [NSNumber numberWithInt:[dict[@"status"] intValue]];
    if ([status intValue] == 0) {
      [self doCallBack:YES info:@{ @"status" : status }];
    }
  }

  else if (taskType == TaskTypeAddCinemaFav) {
    NSDictionary *dict = (NSDictionary *)result;

    [self doCallBack:YES info:dict];
  } else if (taskType == TaskTypeCinemaFavStatus) {
    DLog(@"relation new succeded");
    NSDictionary *dict = (NSDictionary *)result;
    NSMutableArray *cinemasFavedList = [[NSMutableArray alloc] init];
    NSMutableArray *cinemaidFavedList = [[NSMutableArray alloc] init];

    NSMutableArray *cinemas = [dict objectForKey:@"cinemas"];

    if ([cinemas count]) {
      for (NSDictionary *cinema in cinemas) {

          NSError *errMTL = nil;
          CinemaDetail *current = [MTLJSONAdapter modelOfClass:[CinemaDetail class] fromJSONDictionary:cinema error:&errMTL];


        [cinemaidFavedList addObject:current.cinemaId];
        [cinemasFavedList addObject:current];
      }
    }
    [self doCallBack:YES info:@{ @"cinemasFavedList" : cinemasFavedList }];
  }
}

- (void)requestFailedWithError:(NSError *)error {

  if (taskType == TaskTypeFavoriteMovieList) {
    DLog(@"TaskTypeFavoriteMovieList list failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeFavoriteWantLookList) {
    DLog(@"TaskTypeFavoriteWantLookList list failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeAddMovieFav) {
    DLog(@"TaskTypeAddMovieFav failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeRemoveMovieFav) {
    DLog(@"TaskTypeRemoveMovieFav failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeRemoveCinemaFav) {
    DLog(@"TaskTypeRemoveCinemaFav failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeRemoveWantLook) {
    DLog(@"TaskTypeRemoveWantLook failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeQuerySucceedNum) {
    DLog(@"TaskTypeQuerySucceedNum failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeQueryWantWatch) {
    DLog(@"TaskTypeQueryWantWatch failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeClickWantWatch) {
    DLog(@"TaskTypeClickWantWatch failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeAddLike) {
    DLog(@"TaskTypeQueryWantWatchNum failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }

  else if (taskType == TaskTypeAddKotaLike) {
    DLog(@"TaskTypeAddKotaLike failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
  else if (taskType == TaskTypeAddCinemaFav) {
    DLog(@"TaskTypeAddCinemaFav failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeCinemaFavStatus) {
    DLog(@"TaskTypeCinemaFavStatus failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
}

- (void)requestSucceededConnection {
  // if needed do something after connected to net, handle here
}

- (void)cancelCurrentTask {
  [self cancel];
}

// upload process
- (void)uploadBytesWritten:(NSInteger)written
         totalBytesWritten:(NSInteger)totalWritten
 totalBytesExpectedToWrite:(NSInteger)totalExpectedToWrite {
  // just for upload task
}

@end
