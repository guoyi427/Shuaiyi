//
//  IncomingListForCity.m
//  KoMovie
//
//  Created by renzc on 16/9/13.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "IncomingListForCityTask.h"
#import "Movie.h"

#define kCountPerPage 100
@implementation IncomingListForCityTask

- (void)configureParams:(NSDictionary *)privateParams {
  self.cityId =
      [NSString stringWithFormat:@"%d", [privateParams[@"city_id"] intValue]];
  self.pageNum = [privateParams[@"pageNum"] intValue];
}

- (int)cacheVaildTime {
  return 2;
}

- (void)getReady {
  [self setRequestURL:kKSSPServer];
  [self addParametersWithValue:@"movie_Query" forKey:@"action"];
  [self addParametersWithValue:@"1" forKey:@"coming"];
  [self addParametersWithValue:self.cityId forKey:@"city_id"];
  if (self.pageNum > 0) {
    [self
        addParametersWithValue:[NSString stringWithFormat:@"%ld", self.pageNum]
                        forKey:@"page"];
    [self
        addParametersWithValue:[NSString stringWithFormat:@"%d", kCountPerPage]
                        forKey:@"count"];
  }
  [self setRequestMethod:@"GET"];
}

- (void)requestSucceededWithData:(id)result {
  DLog(@"incoming list succeded: %@", result);
  NSDictionary *dict = (NSDictionary *)result;
  NSMutableArray *movielists = [[NSMutableArray alloc] init];

  NSArray *films = [dict objectForKey:@"movies"];

  if ([films count]) {
    for (NSDictionary *film in films) {

      NSNumber *existed = nil;
      Movie *newMovie =
          (Movie *)[[MemContainer me] instanceFromDict:film
                                                 clazz:[Movie class]
                                                 exist:&existed];

      newMovie.isComing = [NSNumber numberWithBool:YES];
      newMovie.remainDay = [NSNumber
          numberWithInteger:[[DateEngine sharedDateEngine]
                                calWeekDayIntervalBetweenDay:[newMovie
                                                                 getPublishDate]
                                                      andDay:[NSDate date]]];

      if ([film[@"trailer"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *trailerDict = film[@"trailer"];
        newMovie.movieTrailer = trailerDict[@"trailerPath"];
        //                DLog(@"movie.movieTrailer ==========
        //                %@",newMovie.movieTrailer);
      }

      if (![existed boolValue]) {
      }
      [movielists addObject:newMovie];
    }
  } else {
  }
  //    [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
  //                               [NSNumber numberWithBool:([films count] >=
  //                               kCountPerPage)], @"hasMore",
  //                               movielists, @"movielists", nil]];

  self.responseData = [NSDictionary
      dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:([films count] >=
                                                             kCountPerPage)],
                                   @"hasMore", movielists, @"movielists", nil];
  if ([self.apiCallBackDelegate
          respondsToSelector:@selector(callApiDidSucceed:)]) {
    [self.apiCallBackDelegate callApiDidSucceed:self];
  }
}

@end
