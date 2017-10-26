//
//  TaskQueue.m
//  TestAsiHttp
//
//  Created by Zhang Da on 11-5-26.
//  Copyright 2010 alfaromeo.dev. All rights reserved.
//

#import "TaskQueue.h"

#import "NetworkTask.h"
#import "CommonTask.h"

#import "DataEngine.h"

static TaskQueue *_taskQueue = nil;

@interface TaskQueue ()

- (void)monitor;

@end

@implementation TaskQueue

//@synthesize session = _session;

+ (TaskQueue *)sharedTaskQueue {
  @synchronized(_taskQueue) {
    if (!_taskQueue) {
      _taskQueue = [[TaskQueue alloc] init];
    }
  }
  return _taskQueue;
}

#pragma mark Constructors
- (id)init {
  self = [super init];
  if (self) {
    taskQueue = [[NSOperationQueue alloc] init];
    [taskQueue setMaxConcurrentOperationCount:30];
    //[self monitor];
    lock = @"lock";
  }

  return self;
}

- (void)dealloc {
}

- (void)suspend {
  if (taskQueue && ![taskQueue isSuspended]) {
    [taskQueue setSuspended:YES];
  }
}

- (void)resume {
  if (taskQueue && [taskQueue isSuspended]) {
    [taskQueue setSuspended:NO];
  }
}

#pragma mark Utility
- (void)monitor {
#ifdef DEBUG
  if ([taskQueue operationCount]) {
    @synchronized(lock) {
      DLog(@"running requests:\n^^^^^^^^^^^\n%@\n^^^^^^^^^^^",
           [taskQueue operations]);
    }
  }
  [self performSelector:@selector(monitor) withObject:nil afterDelay:5];
#endif
}

- (NSString *)addTaskToQueue:(BasicTask *)task {

  if (!task)
    return nil;

  if ([task isKindOfClass:[NetworkTask class]]) {

    if (![[NetworkUtil me] reachable]) {
      //            return NO;
    }

    @synchronized(lock) {
      for (BasicTask *aTask in [taskQueue operations]) {
        if ([aTask isKindOfClass:[NetworkTask class]]) {
          if ([((NetworkTask *)aTask)
                      .netReqId
                  isEqualToString:((NetworkTask *)task).netReqId]) {
            return nil;
          }
        }
      }
    }

    [(NetworkTask *)task getReady];
    DLog(@"+++ %lu ++ %lu ++++ %lu +++++",
         (unsigned long)taskQueue.operationCount,
         (unsigned long)taskQueue.operations.count,
         (long)taskQueue.maxConcurrentOperationCount);
  }

  [self resume];

  @synchronized(lock) {
    [taskQueue addOperation:task];
  }

  if ([task respondsToSelector:@selector(netReqId)]) {
    return ((NetworkTask *)task).netReqId;
  }

  return nil;
}

- (void)startCallApi {
}

- (NSInteger)operationCount {
  return taskQueue.operationCount;
}

- (void)cancelAllTasks {
  if (taskQueue) {
    [taskQueue cancelAllOperations];
  }
}

- (void)changeNetworkActivityIndicatorStatus:(BOOL)status {

  if (status == YES) {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  } else {
    @synchronized(lock) {
      int count = 0;
      for (BasicTask *aTask in [taskQueue operations]) {
        if ([aTask isKindOfClass:[NetworkTask class]]) {
          count++;
        }
      }
      if (count <= 1) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [UIApplication sharedApplication].networkActivityIndicatorVisible =
              NO;
        });
      }
    }
  }
}

@end
