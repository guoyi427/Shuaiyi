//
//  意见反馈接口
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "FeedbackTask.h"

@implementation FeedbackTask

- (id)initFeedback:(NSString *)content finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeFeedback;
        self.message = content;
        self.finishBlock = block;
    }
    return self;
}

- (void)getReady {
    if (taskType == TaskTypeFeedback) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
        [self addParametersWithValue:@"feedback_Add" forKey:@"action"];
        [self addParametersWithValue:self.message forKey:@"content"];
        [self addParametersWithValue:@"2" forKey:@"feedback_type"];
        [self setRequestMethod:@"POST"];
    }
}

#pragma mark - Required method
- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypeFeedback) {
        NSDictionary *dict = (NSDictionary *) result;
        DLog(@"TaskTypeFeedback succeded: %@", dict);

        [self doCallBack:YES info:dict];
    }
}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeFeedback) {
        DLog(@"TaskTypeFeedback failed: %@", [error description]);

        [self doCallBack:NO info:[error userInfo]];
    }
}

@end
