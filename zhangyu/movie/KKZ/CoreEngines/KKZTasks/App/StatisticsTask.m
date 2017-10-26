//
//  统计的接口
//
//  Created by zhoukai on 1/16/14.
//  Copyright (c) 2014 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "DataEngine.h"
#import "StatisticsParams.h"
#import "StatisticsTask.h"

@implementation StatisticsTask {

    StatisticsType statisticsType;
    ChannelType channelType;
    NSString *shareInfo; //影片id，评论id，歌曲id，台词id，kotaid。没有个人主页id
    NSString *sharedUid;
}

- (id)initStatisticsShareByType:(StatisticsType)stype withChannelType:(ChannelType)ctype withSharedUid:(NSString *)uid withShareInfo:(NSString *)si finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeStatisticShare;
        statisticsType = stype;
        channelType = ctype;
        shareInfo = si;
        sharedUid = uid;
        self.finishBlock = block;
    }
    return self;
}

- (id)initStatisticsClubByInf:(NSString *)Inf withArticleId:(NSString *)articleId finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeStatisticClub;
        self.infName = Inf;
        self.articleId = articleId;
        self.finishBlock = block;
    }
    return self;
}

- (void)getReady {

    if (taskType == TaskTypeStatisticShare) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@/%@", kKSSBaseUrl, KKSSPKota, @"add_statistics.chtml"]];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", statisticsType] forKey:@"type"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", channelType] forKey:@"channel"];
        [self addParametersWithValue:sharedUid forKey:@"share_uid"];

        //影片id，评论id，歌曲id，台词id，kotaid。没有个人主页id
        if (statisticsType != StatisticsTypeSnsPoster) {
            [self addParametersWithValue:shareInfo forKey:@"share_info"];
        }
        [self setRequestMethod:@"GET"];
    } else if (taskType == TaskTypeStatisticClub) {
        [self setRequestURL:[NSString stringWithFormat:@"%@", StatisticsSever]];
        [self addParametersWithValue:[StatisticsParams getTimeNowWithSecond] forKey:@"at"];
        [self addParametersWithValue:self.infName forKey:@"inf"];
        [self addParametersWithValue:[NSString stringWithFormat:@"{id:%@}", self.articleId] forKey:@"pas"];
        [self addParametersWithValue:@"1" forKey:@"ty"];
        [self addParametersWithValue:[StatisticsParams getAppVersion] forKey:@"vr"];
        [self addParametersWithValue:[StatisticsParams getGpsCityName] forKey:@"lo"];
        [self addParametersWithValue:[StatisticsParams getDeviceResolution] forKey:@"se"];
        [self addParametersWithValue:[StatisticsParams getAppChannelName] forKey:@"chal"];
        [self addParametersWithValue:[StatisticsParams getDeviceId] forKey:@"dId"];
        [self addParametersWithValue:[StatisticsParams getReachabilityStatus] forKey:@"net"];
        [self addParametersWithValue:[StatisticsParams getOsVersion] forKey:@"sys"];
        [self addParametersWithValue:[StatisticsParams getLongitude] forKey:@"longit"];
        [self addParametersWithValue:[StatisticsParams getLatitude] forKey:@"lati"];
        [self addParametersWithValue:[[StatisticsParams alloc] init].getDeviceIP forKey:@"ip"];
        [self addParametersWithValue:[StatisticsParams getDevicePlatform] forKey:@"mo"];
        [self addParametersWithValue:[DataEngine sharedDataEngine].userId forKey:@"uid"];
        [self setRequestMethod:@"GET"];
    }
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypeStatisticShare) {
        [self doCallBack:YES info:nil];
    } else if (taskType == TaskTypeStatisticClub) {
        [self doCallBack:YES info:nil];
    }
}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeStatisticShare) {
        DLog(@"TaskTypeStatisticShare task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    } else if (taskType == TaskTypeStatisticClub) {
        DLog(@"TaskTypeStatisticClub task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
}

@end
