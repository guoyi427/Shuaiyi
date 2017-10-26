//
//  MovieDBTask.m
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "Actor.h"
#import "Category0.h"
#import "Constants.h"
#import "DataEngine.h"
#import "Match.h"
#import "MemContainer.h"
#import "Movie.h"
#import "MovieDBTask.h"
#import "MovieDialogue.h"
#import "MovieProduct.h"
#import "MovieSong.h"
#import "NSArraySort.h"
#import "UserDefault.h"

#define kCountPerPage 10

// http://test.komovie.cn/data/service?movie_id=35781&action=movie_Summary

@implementation MovieDBTask

- (int)cacheVaildTime {
  if (taskType == TaskTypeMovieActorList) {
    return 24 * 60;
  }
  if (taskType == TaskTypeActorMovieList) {
    return 24 * 60;
  }
  if (taskType == TaskTypeQueryMovieSummary) {
    return 24 * 60;
  }
  return 0;
}

- (id)initActorListForMovie:(unsigned int)movieId
                       page:(NSInteger)page
                   finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeMovieActorList;
    self.movieId = [NSString stringWithFormat:@"%u", movieId];
    self.pageNum = page;
    self.finishBlock = block;
  }
  return self;
}

- (id)initMovieListForActor:(unsigned int)actorId
                       page:(NSInteger)page
                   finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeActorMovieList;
    self.pageNum = page;
    self.actorId = [NSString stringWithFormat:@"%u", actorId];
    self.finishBlock = block;
  }
  return self;
}

- (id)initQueryFavForMovie:(unsigned int)movieId
                  finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeQueryMovieFav;
    self.movieId = [NSString stringWithFormat:@"%u", movieId];
    self.finishBlock = block;
  }
  return self;
}

- (id)initHobbyForMovie:(unsigned int)movieId
               finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeMovieHobby;
    self.movieId = [NSString stringWithFormat:@"%u", movieId];
    self.finishBlock = block;
  }
  return self;
}

- (id)initQuerySummaryForMovie:(unsigned int)movieId
                      finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeQueryMovieSummary;
    self.movieId = [NSString stringWithFormat:@"%u", movieId];
    ;
    self.finishBlock = block;
  }
  return self;
}

- (void)getReady {
  if (taskType == TaskTypeMovieActorList) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl, kKSSPDataServer]];

    [self addParametersWithValue:@"movie_members" forKey:@"action"];
    [self addParametersWithValue:self.movieId forKey:@"movie_id"];
    [self setRequestMethod:@"GET"];
  }
  if (taskType == TaskTypeMovieHobby) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
    [self addParametersWithValue:@"goods_Query" forKey:@"action"];
    [self addParametersWithValue:self.movieId forKey:@"movie_id"];
    [self setRequestMethod:@"GET"];
  }
  if (taskType == TaskTypeActorMovieList) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl, kKSSPDataServer]];

    [self addParametersWithValue:@"star_movies" forKey:@"action"];
    [self addParametersWithValue:self.actorId forKey:@"star_id"];
    [self setRequestMethod:@"GET"];
  }
  if (taskType == TaskTypeQueryMovieFav) {
    [self
        setRequestURL:[NSString
                          stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota,
                                           @"qry_favorite_movie_status.chtml"]];

    [self addParametersWithValue:[DataEngine sharedDataEngine].userId
                          forKey:@"userId"];
    [self addParametersWithValue:self.movieId forKey:@"movieId"];

    [self setRequestMethod:@"GET"];
  }
  if (taskType == TaskTypeQueryMovieSummary) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl, kKSSPDataServer]];
    [self addParametersWithValue:@"movie_Summary" forKey:@"action"];
    [self addParametersWithValue:self.movieId forKey:@"movie_id"];
    [self setRequestMethod:@"GET"];
  }
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {
  if (taskType == TaskTypeMovieActorList) {
    NSDictionary *dict = (NSDictionary *)result;

    NSMutableArray *actors = [[NSMutableArray alloc] init];

    NSArray *members = [dict objectForKey:@"members"];

    if ([members count]) {
      for (NSDictionary *member in members) {
        NSDictionary *actor = [member objectForKey:@"star"];
        NSString *character = [member objectForKey:@"character"];

        NSString *actorId = nil;
        if ([actor objectForKey:@"starId"] &&
            [actor objectForKey:@"starId"] != [NSNull null])
          actorId =
              [NSString stringWithFormat:@"%@", [actor objectForKey:@"starId"]];

        if (actorId) {
          NSNumber *existed = nil;
          Actor *newActor =
              (Actor *)[[MemContainer me] instanceFromDict:actor
                                                     clazz:[Actor class]
                                                     exist:&existed];
          newActor.character = character;
          [actors addObject:newActor];
        }
      }
    } else {
      [self deleteCache];
    }
    [self doCallBack:YES info:@{ @"actors" : actors }];
  } else if (taskType == TaskTypeMovieHobby) {
    NSDictionary *dict = (NSDictionary *)result;
    NSArray *goodsRecommends = [dict objectForKey:@"goodsRecommends"];

    if (goodsRecommends.count) {

      NSString *picUrl = [goodsRecommends[0] objectForKey:@"picUrl"];
      NSString *price = [goodsRecommends[0] objectForKey:@"price"];
      NSString *promotionPrice =
          [goodsRecommends[0] objectForKey:@"promotionPrice"];
      NSString *title = [goodsRecommends[0] objectForKey:@"title"];
      NSString *url = [goodsRecommends[0] objectForKey:@"url"];

      [self doCallBack:YES
                  info:@{
                    @"picUrl" : picUrl,
                    @"price" : price,
                    @"promotionPrice" : promotionPrice,
                    @"title" : title,
                    @"url" : url
                  }];
    }
  } else if (taskType == TaskTypeActorMovieList) {
    NSDictionary *dict = (NSDictionary *)result;

    NSArray *movies = [dict objectForKey:@"movies"];
    NSMutableArray *movieDBList = [[NSMutableArray alloc] init];

    if ([movies count]) {

      for (NSDictionary *movie in movies) {
        NSDictionary *movieDetail = [movie objectForKey:@"movie"];

          Movie *movie = [MTLJSONAdapter modelOfClass:[Movie class] fromJSONDictionary:movieDetail error:nil];
          [[MemContainer me] putObject:movie];
          if (movie) {
              [movieDBList addObject:movie];
          }
        
      }
    } else {
      [self deleteCache];
    }
    [self doCallBack:YES info:@{ @"movies" : movieDBList }];
  } else if (taskType == TaskTypeQueryMovieFav) {
    NSDictionary *dict = (NSDictionary *)result;
    // favStatus 0未收藏，1收藏
    [self doCallBack:([[dict kkz_intNumberForKey:@"favStatus"] intValue] == 1)
                info:nil];
  } else if (taskType == TaskTypeQueryMovieSummary) {
    NSDictionary *dict = (NSDictionary *)result;

    //明星。单独查询。这里只是判断是否大于0
    NSMutableArray *actorsDBList = [[NSMutableArray alloc] init];

    //相似影片
    NSArray *movies = [dict objectForKey:@"movies"];
    NSMutableArray *movieDBList = [[NSMutableArray alloc] init];

    if ([movies count]) {
      for (NSDictionary *movie in movies) {

          Movie *newMovie = [MTLJSONAdapter modelOfClass:[Movie class] fromJSONDictionary:movie error:nil];
          [[MemContainer me] putObject:newMovie];
        [movieDBList addObject:newMovie];
      }
    }
    //电影原声
    NSArray *songs = [dict objectForKey:@"songs"];
    NSMutableArray *songDBList = [[NSMutableArray alloc] init];

    if ([songs count]) {
      for (NSDictionary *song in songs) {

        NSString *songId = nil;
        if ([song objectForKey:@"songId"] &&
            [song objectForKey:@"songId"] != [NSNull null])
          songId =
              [NSString stringWithFormat:@"%@", [song objectForKey:@"songId"]];

        if (songId) {
          NSNumber *existed = nil;
          MovieSong *newSong =
              (MovieSong *)[[MemContainer me] instanceFromDict:song
                                                         clazz:[MovieSong class]
                                                         exist:&existed];

          [songDBList addObject:newSong];
        }
      }
    }

    //经典台词
    NSArray *dialogues = [dict objectForKey:@"dialogues"];
    NSMutableArray *dialoguesDBList = [[NSMutableArray alloc] init];

    if ([dialogues count]) {
      for (NSDictionary *dialogue in dialogues) {

        NSString *dialogueId = nil;
        if ([dialogue objectForKey:@"dialogueId"] &&
            [dialogue objectForKey:@"dialogueId"] != [NSNull null])
          dialogueId = [NSString
              stringWithFormat:@"%@", [dialogue objectForKey:@"dialogueId"]];

        if (dialogueId) {
          NSNumber *existed = nil;
          MovieDialogue *newDialogue = (MovieDialogue *)[[MemContainer me]
              instanceFromDict:dialogue
                         clazz:[MovieDialogue class]
                         exist:&existed];

          [dialoguesDBList addObject:newDialogue];
        }
      }
    }

    //影片专区
    NSArray *products = [dict objectForKey:@"products"];
    NSMutableArray *productDBList = [[NSMutableArray alloc] init];

    if ([products count]) {
      for (NSDictionary *product in products) {

        NSString *productId = nil;
        if ([product objectForKey:@"productId"] &&
            [product objectForKey:@"productId"] != [NSNull null])
          productId = [NSString
              stringWithFormat:@"%@", [product objectForKey:@"productId"]];

        if (productId) {
          NSNumber *existed = nil;
          MovieProduct *newProduct = (MovieProduct *)[[MemContainer me]
              instanceFromDict:product
                         clazz:[MovieProduct class]
                         exist:&existed];

          [productDBList addObject:newProduct];
        }
      }
    }

    [self doCallBack:YES
                info:@{
                  @"actors" : actorsDBList,
                  @"movies" : movieDBList,
                  @"sound" : songDBList,
                  @"dialogues" : dialoguesDBList,
                  @"products" : productDBList
                }];
  }
}

- (void)requestFailedWithError:(NSError *)error {
  if (taskType == TaskTypeMovieActorList) {
    DLog(@"TaskTypeMovieActorList task failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeMovieHobby) {
    DLog(@"TaskTypeMovieHobby task failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeActorMovieList) {
    DLog(@"TaskTypeActorMovieList task failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeQueryMovieFav) {
    DLog(@"TaskTypeQueryMovieFav task failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  } else if (taskType == TaskTypeQueryMovieSummary) {
    DLog(@"TaskTypeQueryMovieSummary task failed: %@", [error description]);
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
