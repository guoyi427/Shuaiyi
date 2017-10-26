//
//  MovieListForCityTask.m
//  KoMovie
//
//  Created by renzc on 16/9/13.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieListForCityTask.h"
#import "Movie.h"
#import "Banner.h"

#define kCountPerPage 100
@implementation MovieListForCityTask

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
  if (self.cityId) {
    [self addParametersWithValue:self.cityId forKey:@"city_id"];
  }
  if (self.beginData) {
    [self addParametersWithValue:self.beginData forKey:@"begin_date"];
  }
  [self addParametersWithValue:@"1000" forKey:@"count"];
  [self addParametersWithValue:@"1" forKey:@"show_promotion"];
  [self setRequestMethod:@"GET"];
}

- (void)requestSucceededWithData:(id)result {
  NSDictionary *dict = (NSDictionary *)result;
  NSMutableArray *movielists = [[NSMutableArray alloc] init];
  NSArray *films = [dict objectForKey:@"movies"];

  if ([films count]) {
    for (NSDictionary *film in films) {

      NSNumber *existed = nil;

      Movie *movie =
          (Movie *)[[MemContainer me] instanceFromDict:film
                                                 clazz:[Movie class]
                                 updateTypeWhenExisted:UpdateTypeReplace
                                                 exist:&existed];
      movie.isAvailable = [NSNumber numberWithBool:YES];

      if ([film[@"trailer"] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *trailerDict = film[@"trailer"];
        movie.movieTrailer = trailerDict[@"trailerPath"];
        //                DLog(@"movie.movieTrailer ==========
        //                %@",movie.movieTrailer);
      }

      //电影相关活动的数组
      NSArray *bannersDic = [film objectForKey:@"banners"];
      NSMutableArray *banners = [[NSMutableArray alloc] initWithCapacity:0];

      for (NSDictionary *bannerDic in bannersDic) {

        Banner *banner =
            (Banner *)[[MemContainer me] instanceFromDict:bannerDic
                                                    clazz:[Banner class]
                                    updateTypeWhenExisted:UpdateTypeReplace
                                                    exist:&existed];

        [banners addObject:banner];
      }

      movie.bannerArray = [banners copy];

      [movielists addObject:movie];
    }
  } else {
  }

  //            [self doCallBack:YES info:[NSDictionary
  //            dictionaryWithObjectsAndKeys:
  //                                       [NSNumber numberWithBool:([films
  //                                       count] >= kCountPerPage)],
  //                                       @"hasMore",
  //                                       movielists, @"movielists", nil]];

  self.responseData = [NSDictionary
      dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:([films count] >=
                                                             kCountPerPage)],
                                   @"hasMore", movielists, @"movielists", nil];
  if ([self.apiCallBackDelegate
          respondsToSelector:@selector(callApiDidSucceed:)]) {
    [self.apiCallBackDelegate callApiDidSucceed:self];
  }
}

- (void)dealloc {
}

@end
