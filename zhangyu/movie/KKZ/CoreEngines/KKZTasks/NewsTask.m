//
//  NewsTask.m
//  Aimeili
//
//  Created by zhang da on 12-8-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//
#import "Banner.h"
#import "Constants.h"
#import "DataEngine.h"
#import "MemContainer.h"
#import "Movie.h"
#import "MovieSong.h"
#import "NSStringExtra.h"
#import "NewsTask.h"
#import "UserDefault.h"

#define kCountPerPage 6

@implementation NewsTask

- (id)initNewsBannerWithTarget:(NSString *)tagetType finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeNewsBanner;
        self.typeId = tagetType;
        self.finishBlock = block;
    }
    return self;
}

- (void)getReady {
    if (taskType == TaskTypeNewsBanner) {

        [self setRequestURL:kKSSPServer];
        [self addParametersWithValue:@"banner_query" forKey:@"action"];
        [self addParametersWithValue:self.typeId forKey:@"target_type"];                              //查询资讯
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", USER_CITY] forKey:@"city_id"]; //城市
        [self setRequestMethod:@"GET"];
    }
}

- (int)cacheVaildTime {

    //    if (taskType == TaskTypeNewsBanner) {
    //        return 30;
    //    }
    return 0;
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypeNewsBanner) {
//        NSDictionary *dict = (NSDictionary *) result;
//        DLog(@"news list succeded");
//
//        if ([[dict objectForKey:@"banners"] isKindOfClass:[NSDictionary class]]) {
//            NSDictionary *banner = [dict objectForKey:@"banners"];
//
//            NSNumber *existed = nil;
//            Banner *bannerDB = (Banner *) [[MemContainer me] instanceFromDict:banner
//                                                                        clazz:[Banner class]
//                                                                        exist:&existed];
//            [self doCallBack:YES info:@{ @"banners" : bannerDB }];
//
//        } else {
//            NSArray *banners = [dict objectForKey:@"banners"];
//            NSMutableArray *bannersDBList = [[NSMutableArray alloc] init];
//            if ([banners count]) {
//                for (NSDictionary *bannerJson in banners) {
//                    NSNumber *existed = nil;
//                    Banner *bannerDB = (Banner *) [[MemContainer me] instanceFromDict:bannerJson
//                                                                                clazz:[Banner class]
//                                                                                exist:&existed];
//
//                    [bannersDBList addObject:bannerDB];
//                }
//                [self doCallBack:YES info:@{ @"banners" : bannersDBList }];
//            } else {
//                [self deleteCache];
//            }
//        }
    }
}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeNewsBanner) {
        DLog(@"TaskTypeNewsBanner failed: %@", [error description]);
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
