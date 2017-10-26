//
//  TaskQueue.h
//  TestAsiHttp
//
//  Created by Zhang Da on 11-5-26.
//  Copyright 2010 alfaromeo.dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BasicTask;

@interface TaskQueue : NSObject {
  NSOperationQueue *taskQueue;
  NSString *lock;
}

+ (TaskQueue *)sharedTaskQueue;

- (void)suspend;
- (void)resume;

- (NSString *)addTaskToQueue:(BasicTask *)task;
- (void)cancelAllTasks;

- (void)changeNetworkActivityIndicatorStatus:(BOOL)status;

- (NSInteger)operationCount;

@end
