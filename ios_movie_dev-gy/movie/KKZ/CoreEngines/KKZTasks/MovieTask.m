//
//  MovieTask.m
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "Constants.h"
#import "DataEngine.h"
#import "Gallery.h"
#import "MemContainer.h"
#import "Movie.h"
#import "MovieSong.h"
#import "MovieTask.h"
#import "Song.h"
#import "Trailer.h"

#define pageNum 15

@implementation MovieTask

@synthesize movieId = _movieId;

/**
 *  查询一个电影所有影院的上映日期
 */
- (id)initDateListForMovie:(NSUInteger)movieId andCity:(NSInteger)cityId finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeMovieCinemasPlanList;
        self.movieId = [NSString stringWithFormat:@"%lu", (unsigned long) movieId];
        self.cityId = [NSString stringWithFormat:@"%lu", (unsigned long) cityId];
        self.finishBlock = block;
    }
    return self;
}

/**
 *  查询影片剧照
 */
- (id)initMoviePosterWithMovieid:(NSUInteger)movieId mediaType:(int)mediaType finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeMoviePoster;
        self.movieId = [NSString stringWithFormat:@"%lu", (unsigned long) movieId];
        self.mediaType = mediaType;
        self.finishBlock = block;
    }
    return self;
}

/**
 *  查询影院图集
 */
- (id)initCinemaPosterWithCinemaid:(NSUInteger)cinemaId mediaType:(int)mediaType finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeCinemaPoster;
        self.movieId = [NSString stringWithFormat:@"%lu", (unsigned long) cinemaId];
        self.mediaType = mediaType;
        self.finishBlock = block;
    }
    return self;
}

/**
*  查询对该影片点赞 或者 不喜欢 的情况
 */
- (id)initMovieSupportWithMovieid:(NSUInteger)movieId finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeMovieSupport;
        self.movieId = [NSString stringWithFormat:@"%lu", (unsigned long) movieId];
        self.finishBlock = block;
    }
    return self;
}

/**
 *  点赞 或者 不喜欢
 */
- (id)initSupportMovieWithMovieid:(NSUInteger)movieId andRelation:(NSInteger)relation finished:(FinishDownLoadBlock)block {

    self = [super init];
    if (self) {
        self.taskType = TaskTypeSupportMovie;
        self.movieId = [NSString stringWithFormat:@"%lu", (unsigned long) movieId];
        self.relation = relation;
        self.finishBlock = block;
    }
    return self;
}

/**
 *  预告片
 */
- (id)initMovieTrailerWithMovieId:(unsigned int)movieId finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeMovieTrailerList;
        self.movieId = [NSString stringWithFormat:@"%lu", (unsigned long) movieId];
        self.finishBlock = block;
    }
    return self;
}

/**
 *  电影原声
 */
- (id)initMovieSongsWithMovieId:(unsigned int)movieId finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeMovieSongsList;
        self.movieId = [NSString stringWithFormat:@"%lu", (unsigned long) movieId];
        self.finishBlock = block;
    }
    return self;
}

/**
 *  电影海报
 */
- (id)initMovieGallarysWithMovieId:(unsigned int)movieId finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeMovieGallaryList;
        self.movieId = [NSString stringWithFormat:@"%lu", (unsigned long) movieId];
        self.finishBlock = block;
    }
    return self;
}

- (void)getReady {
    if (taskType == TaskTypeMovieCinemasPlanList) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
        [self addParametersWithValue:@"plan_Date" forKey:@"action"];
        [self addParametersWithValue:self.movieId forKey:@"movie_id"];
        [self addParametersWithValue:self.cityId forKey:@"city_id"];
        [self setRequestMethod:@"GET"];

    } else if (taskType == TaskTypeMovieTrailerList) {
        [self setRequestURL:[NSString stringWithFormat:@"%@media/trailer/list", KKSSMediaServerAPI]];
        [self addParametersWithValue:self.movieId
                                forKey:@"movie_id"];
        [self addParametersWithValue:@"1"
                                forKey:@"channel_id"];
        [self setRequestMethod:@"GET"];
    } else if (taskType == TaskTypeMovieSongsList) {
        [self setRequestURL:[NSString stringWithFormat:@"%@media/song/list", KKSSMediaServerAPI]];
        [self addParametersWithValue:self.movieId
                                forKey:@"movie_id"];
        [self addParametersWithValue:@"1"
                                forKey:@"channel_id"];
        [self setRequestMethod:@"GET"];
    }

    else if (taskType == TaskTypeMovieGallaryList) {
        [self setRequestURL:[NSString stringWithFormat:@"%@media/gallery/list", KKSSMediaServerAPI]];
        [self addParametersWithValue:self.movieId
                                forKey:@"movie_id"];
        [self addParametersWithValue:@"1"
                                forKey:@"channel_id"];
        [self setRequestMethod:@"GET"];
    }

    else if (taskType == TaskTypeMoviePoster) {
        [self setRequestURL:[NSString stringWithFormat:@"%@media/query", KKSSMediaServerAPI]];
        [self addParametersWithValue:self.movieId
                                forKey:@"movie_id"];
        [self addParametersWithValue:@"1"
                                forKey:@"channel_id"];
        [self setRequestMethod:@"GET"];
    }

    else if (taskType == TaskTypeCinemaPoster) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
        [self addParametersWithValue:@"media_Query" forKey:@"action"];
        [self addParametersWithValue:self.movieId forKey:@"target_id"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", self.mediaType] forKey:@"media_type"]; //media_type
        [self setRequestMethod:@"GET"];
    } else if (taskType == TaskTypeMovieSupport) {
        [self setRequestURL:[NSString stringWithFormat:@"%@movie/relation/query", KKSSMediaServerAPI]];
        [self addParametersWithValue:self.movieId forKey:@"movie_id"];
        //添加上传参数
        if (appDelegate.isAuthorized) { // 已登录
            [self addParametersWithValue:[DataEngine sharedDataEngine].userId
                                    forKey:@"user_id"];
        }

        [self setRequestMethod:@"GET"];
    } else if (taskType == TaskTypeSupportMovie) {
        [self setRequestURL:[NSString stringWithFormat:@"%@movie/relation/save", KKSSMediaServerAPI]];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld", (long) self.relation] forKey:@"relation"];
        [self addParametersWithValue:self.movieId forKey:@"movie_id"];

        [self addParametersWithValue:[DataEngine sharedDataEngine].userId
                                forKey:@"user_id"];

        [self setRequestMethod:@"GET"];
    }
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {

    if (taskType == TaskTypeMovieCinemasPlanList) {
        DLog(@"movie info succeded %@", result);
        NSDictionary *dict = (NSDictionary *) result;
        if ([dict[@"dates"] isKindOfClass:[NSArray class]]) {
            NSArray *dates = dict[@"dates"];
            [self doCallBack:YES info:@{ @"dates" : dates }];
        } else {
            [self doCallBack:YES info:nil];
        }
    } else if (taskType == TaskTypeMoviePoster) {

        DLog(@"movie gallery succeded %@", result);
        NSDictionary *dict = (NSDictionary *) result;

        //剧照解析
        NSDictionary *galleryDic = [[dict objectForKey:@"result"] valueForKey:@"gallery"];
        NSString *galleryTotal = [NSString stringWithFormat:@"%d", [[galleryDic objectForKey:@"total"] intValue]];
        NSArray *gallerys = [galleryDic valueForKey:@"gallery"];
        NSMutableArray *galleryList = [[NSMutableArray alloc] init];
        if ([gallerys count]) {
            for (NSDictionary *gallery in gallerys) {
                Gallery *galleryModel = [[Gallery alloc] initWithDict:gallery];
                [galleryList addObject:galleryModel];
            }
        }

        //音频解析
        NSDictionary *songDic = [[dict objectForKey:@"result"] valueForKey:@"song"];
        NSString *songTotal = [NSString stringWithFormat:@"%d", [[songDic objectForKey:@"total"] intValue]];
        NSDictionary *songs = [songDic valueForKey:@"trailer"];
        Song *songModel = [[Song alloc] initWithDict:songs];
        NSMutableArray *songList = [[NSMutableArray alloc] init];
        [songList addObject:songModel];

        //视频解析
        NSDictionary *trailerDic = [[dict objectForKey:@"result"] valueForKey:@"trailer"];
        NSString *trailerTotal = [NSString stringWithFormat:@"%d", [[trailerDic objectForKey:@"total"] intValue]];
        NSDictionary *trailers = [trailerDic valueForKey:@"trailer"];
        Trailer *trailerModel = [[Trailer alloc] initWithDict:trailers];
        NSMutableArray *trailerList = [[NSMutableArray alloc] init];
        [trailerList addObject:trailerModel];

        [self doCallBack:YES
                      info:@{ @"gallery" : galleryList,
                              @"galleryCount" : galleryTotal,
                              @"song" : songList,
                              @"songCount" : songTotal,
                              @"trailer" : trailerList,
                              @"trailerCount" : trailerTotal }];
    }

    else if (taskType == TaskTypeCinemaPoster) {

        //        DLog(@"movie gallery succeded %@",result);
        NSDictionary *dict = (NSDictionary *) result;

        NSArray *posters = [dict objectForKey:@"galleries"];
        NSMutableArray *movieGalleryList = [[NSMutableArray alloc] init];
        [self doCallBack:YES
                      info:@{ @"posters" : posters,
                              @"movieGallaries" : movieGalleryList }];
    } else if (taskType == TaskTypeMovieSupport) {

        NSDictionary *dict = (NSDictionary *) result;

        [self doCallBack:YES info:dict];
    } else if (taskType == TaskTypeSupportMovie) {

        NSDictionary *dict = (NSDictionary *) result;

        [self doCallBack:YES info:dict];
    } else if (taskType == TaskTypeMovieTrailerList) {

        NSDictionary *dict = (NSDictionary *) result;

        NSArray *trailerS = dict[@"result"];

        NSMutableArray *trailerList = [[NSMutableArray alloc] init];

        if (trailerS.count) {

            for (int i = 0; i < trailerS.count; i++) {
                NSDictionary *trailerDict = trailerS[i];
                //视频解析
                Trailer *trailerModel = [[Trailer alloc] initWithDict:trailerDict];
                [trailerList addObject:trailerModel];
            }

            [self doCallBack:YES
                          info:[NSDictionary dictionaryWithObjectsAndKeys:
                                                     trailerList, @"trailerList", nil]];
        }

    }

    else if (taskType == TaskTypeMovieSongsList) {

        NSDictionary *dict = (NSDictionary *) result;

        NSArray *songs = [dict objectForKey:@"result"];
        NSMutableArray *songsM = [[NSMutableArray alloc] initWithCapacity:0];

        if (songs.count) {
            for (int i = 0; i < songs.count; i++) {

                NSDictionary *songDict = songs[i];
                NSNumber *existed = nil;

                MovieSong *movieSong = (MovieSong *) [[MemContainer me] instanceFromDict:songDict
                                                                                   clazz:[MovieSong class]
                                                                   updateTypeWhenExisted:UpdateTypeMerge
                                                                                   exist:&existed]; //更换了数据存储方式 UpdateTypeReplace
                movieSong.songId = [songDict[@"id"] intValue];

                [songsM addObject:movieSong];
            }
        }

        [self doCallBack:YES
                      info:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [NSNumber numberWithBool:(songsM.count >= pageNum)], @"hasMore", songsM, @"songsM", nil]];
    }

    else if (taskType == TaskTypeMovieGallaryList) {

        NSDictionary *dict = (NSDictionary *) result;
        //剧照解析
        NSArray *gallerys = [dict valueForKey:@"result"];
        NSMutableArray *galleryList = [[NSMutableArray alloc] init];
        if ([gallerys count]) {
            for (NSDictionary *gallery in gallerys) {
                Gallery *galleryModel = [[Gallery alloc] initWithDict:gallery];
                [galleryList addObject:galleryModel];
            }
        }

        [self doCallBack:YES
                      info:[NSDictionary dictionaryWithObjectsAndKeys:
                                                 [NSNumber numberWithBool:(galleryList.count >= pageNum)], @"hasMore", galleryList, @"galleryList", nil]];
    }
}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeMovieCinemasPlanList) {
        DLog(@"TaskTypeMovieCinemasPlanList failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeMoviePoster) {
        DLog(@"TaskTypeMoviePoster failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeCinemaPoster) {
        DLog(@"TaskTypeCinemaPoster failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeMovieSupport) {
        DLog(@"TaskTypeMovieSupport failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeSupportMovie) {
        DLog(@"TaskTypeSupportMovie failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeMovieTrailerList) {
        DLog(@"TaskTypeMovieTrailerList failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeMovieSongsList) {
        DLog(@"TaskTypeMovieSongsList failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeMovieGallaryList) {
        DLog(@"TaskTypeMovieGallaryList failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
}

- (void)requestSucceededConnection {
    //if needed do something after connected to net, handle here
}

// upload process
- (void)uploadBytesWritten:(NSInteger)written
         totalBytesWritten:(NSInteger)totalWritten
 totalBytesExpectedToWrite:(NSInteger)totalExpectedToWrite {
    //just for upload task
}

@end
