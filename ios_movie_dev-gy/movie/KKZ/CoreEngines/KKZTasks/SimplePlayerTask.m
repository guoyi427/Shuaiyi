//
//  SimplePlayerTask.m
//  KoMovie
//
//  Created by KKZ on 15/10/13.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "SimplePlayerTask.h"
#import "UserDefault.h"
#import "SimplePlayerVideo.h"
#import "MemContainer.h"
#import "NetworkStatus.h"

@implementation SimplePlayerTask
- (id)initSimplePlayerDataWithRecord_id:(NSString *)record_id
                               finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeSimplePlayer;
        self.record_id = record_id;
        self.finishBlock = block;
    }
    return self;
}

- (void)getReady {
    
    if (taskType == TaskTypeSimplePlayer) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@",kKSSBaseUrl, KKSSPKota,@"queryVideos.chtml"]];
        [self addParametersWithValue:@"1" forKey:@"channel"];
        [self addParametersWithValue:@"iOS" forKey:@"cpu"];
        [self addParametersWithValue:[UIDevice currentDevice].model forKey:@"device"];
        
        NSString *netStatus = [NetworkStatus getNetWorkStates];
        
        [self addParametersWithValue:netStatus forKey:@"network_status"];
        [self addParametersWithValue:[[UIDevice currentDevice] systemVersion] forKey:@"os"];
        [self addParametersWithValue:self.record_id forKey:@"record_id"];
        
        int w = screentWith;
        
        if (screentWith == 414)
        {
           w = screentWith * 3;
        }else{
        
           w = screentWith * 2;
        }
        
        int h = screentHeight;

        [self addParametersWithValue:[NSString stringWithFormat:@"%d",w] forKey:@"screen_width"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d",h] forKey:@"screen_height"];

        
        [self setRequestMethod:@"GET"];
    }
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypeSimplePlayer) {
        DLog(@"获取video信息成功 %@", result);
        NSDictionary *dict = (NSDictionary *)result;
        NSDictionary *defaultVideoDic = dict[@"defaultVideo"];
        NSMutableArray *videosM = [[NSMutableArray alloc] init];
        NSArray *videos = dict[@"videos"];
        NSMutableArray *videoQualities = [[NSMutableArray alloc] init];

        
        
        NSString *defaultVideoId = @"";
        NSString *defaultVideoQuality = @"";
        NSInteger defaultVideoIndex = 0;
        NSString *defaultVideoMode = @"";
        
        if ([defaultVideoDic isKindOfClass:[NSDictionary class]]) {
            
            defaultVideoId = [NSString stringWithFormat:@"%@",defaultVideoDic[@"id"]];
            defaultVideoQuality = [NSString stringWithFormat:@"%@",defaultVideoDic[@"videoQuality"]];
            defaultVideoMode = [NSString stringWithFormat:@"%@",defaultVideoDic[@"videoMode"]];

        }
        
        SimplePlayerVideo *defaultVideo;
        
        if ([videos count]) {
            for (NSDictionary *video in videos) {
                
                NSNumber *existed = nil;
                
                
                SimplePlayerVideo *current = (SimplePlayerVideo *)[[MemContainer me] instanceFromDict:video
                                                                        clazz:[SimplePlayerVideo class]
                                                        updateTypeWhenExisted:UpdateTypeReplace
                                                                        exist:&existed];
                
                if (current.videoQuality.length) {
                    [videoQualities addObject:current.videoQuality];
                    
                    if ([current.videoQuality isEqualToString:defaultVideoQuality]) {
                        defaultVideoIndex = videosM.count;
                    }
                    
                }
                if ([defaultVideoId isEqualToString:current.videoId]) {
                    current.isDefaultVideo = YES;
                    defaultVideo = current;

                }else{
                    current.isDefaultVideo = NO;
                }
                
                
                if (![existed boolValue]) {
                    
                }
                [videosM addObject:current];
                
            }
           
        }
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:videosM,@"videoList",defaultVideo,@"defaultVideo",videoQualities,@"videoQualities",defaultVideoQuality,@"defaultVideoQuality",@(defaultVideoIndex),@"defaultVideoIndex",defaultVideoMode,@"defaultVideoMode",nil]];
        
    }
}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeSimplePlayer) {
        DLog(@"simplePlayer数据传输失败: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
}


@end
