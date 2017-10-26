//
//  RewardScoreTask.m
//  KoMovie
//
//  Created by KKZ on 16/1/12.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "RewardScoreTask.h"
#import "UserDefault.h"

@implementation RewardScoreTask
- (id)initRewardScoreDataWithOrderId:(NSString *)order_id
                            finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeRewardScore;
        self.order_id = order_id;
        self.finishBlock = block;
    }
    return self;
}

- (void)getReady {
    
    if (taskType == TaskTypeRewardScore) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
        [self addParametersWithValue:@"order_Integral" forKey:@"action"];
        [self addParametersWithValue:self.order_id forKey:@"order_id"];
        [self setRequestMethod:@"GET"];
    }
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypeRewardScore) {
        NSDictionary *dict = (NSDictionary *)result;
        NSDictionary *integral = dict[@"integral"];
        
        [self doCallBack:YES info:integral];
    }
}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeRewardScore) {
        [self doCallBack:NO info:[error userInfo]];
    }
}

@end
