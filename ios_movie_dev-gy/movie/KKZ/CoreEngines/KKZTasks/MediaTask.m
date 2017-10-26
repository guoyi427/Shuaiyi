//
//  MovieTask.m
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "MediaTask.h"
#import "Constants.h"
#import "Movie.h"
#import "MovieTrailer.h"
#import "DataEngine.h"
#import "MemContainer.h"

@implementation MediaTask

- (id)initMedia:(int)targetId mediaType:(MediaType)type finished:(FinishDownLoadBlock)block;
{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeMediaTrailer;
        self.targetId = [NSString stringWithFormat:@"%d",targetId];
        self.type = type;
        self.finishBlock = block;
    }
    return self;
}


- (void)getReady {
    if (taskType == TaskTypeMediaTrailer) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
        [self addParametersWithValue:@"media_Query" forKey:@"action"];
        [self addParametersWithValue:self.targetId forKey:@"target_id"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d",self.type] forKey:@"media_type"];
        [self setRequestMethod:@"GET"];
    }
}

- (int)cacheVaildTime {
    if (taskType == TaskTypeMediaTrailer) {
        return 30;
    }
    return 0;
}



#pragma mark required method
- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypeMediaTrailer) {
        NSDictionary *dict = (NSDictionary *)result;
        NSArray *trailerDict = [dict kkz_objForKey:@"trailers"];
        NSNumber *existed = nil;
        MovieTrailer *movieTrailer = nil;
        if (trailerDict.count>0) {
            NSDictionary *dic = [trailerDict objectAtIndex:0];
             movieTrailer = (MovieTrailer *)[[MemContainer me] instanceFromDict:dic
                                                                                       clazz:[MovieTrailer class]
                                                                                       exist:&existed];
        }
        if (movieTrailer) {
            [self doCallBack:YES info:@{@"movieTrailer": movieTrailer}];

        }else{
            [self doCallBack:YES info:nil];

        }
        }else{
            [self doCallBack:NO info:nil];
        }
        
    
}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeMediaTrailer) {
        DLog(@"movie gallery failed: %@", [error description]);
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
