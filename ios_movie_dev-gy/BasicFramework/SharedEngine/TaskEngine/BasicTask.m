//
//  BasicTask.m
//  alfaromeo.dev
//
//  Created by zhang da on 11-5-16.
//  Copyright 2011 alfaromeo.dev. All rights reserved.
//

#import "BasicTask.h"
#import "KKZAppDelegate.h"
#import "DataEngine.h"
#import "TaskQueue.h"


@interface BasicTask ()


@end



@implementation BasicTask

@synthesize taskType;
@synthesize state = _state;
@synthesize identifier = _identifier;


- (void)setState:(BasicTaskState)newState {
    @synchronized (self) {
        BasicTaskState  oldState;
        
        oldState = _state;
        if ( newState == kBasicTaskStateExecuting || oldState == kBasicTaskStateExecuting ) {
            [self willChangeValueForKey:@"isExecuting"];
        }
        if ( newState == kBasicTaskStateFinished || oldState == kBasicTaskStateCancel ) {
            [self willChangeValueForKey:@"isFinished"];
        }
        _state = newState;
        if ( newState == kBasicTaskStateFinished || oldState == kBasicTaskStateCancel ) {
            [self didChangeValueForKey:@"isFinished"];
        }
        if ( newState == kBasicTaskStateExecuting || oldState == kBasicTaskStateExecuting ) {
            [self didChangeValueForKey:@"isExecuting"];
        }
    }
}

- (NSString *)identifier {
    if (!_identifier) {
        _identifier = [[NSProcessInfo processInfo] globallyUniqueString];
    }
    return _identifier;
}

- (id)init {
    self = [super init];
    if (self != nil) {
    }
    return self;
}

- (void)dealloc {

    _identifier = nil;
}

- (void)postNotificationSucceeded:(BOOL)result withInfo:(NSDictionary *)userInfo {
    
    //
    NSDictionary *taskDesc = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:result], @"result",
                              [NSNumber numberWithInt:taskType], @"taskType", nil];
    NSNotification *n = [NSNotification notificationWithName:[NSString stringWithFormat:@"%@-%d",
                                                              TaskFinishedNotification, (int)taskType]
                                                      object:taskDesc
                                                    userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:)
                                                           withObject:n
                                                        waitUntilDone:NO];
    
    DLog(@"-----task %p post notification %d for task %d",  self, result, (int)taskType);
}




#pragma mark * Subclass override points
- (void)operationDidStart {
    
}

- (void)operationWillCancel {
    
}

- (void)operationWillFinish {
    
}



#pragma mark * Overrides
- (BOOL)isConcurrent {
    return YES;//返回yes表示支持异步调用，否则为支持同步调用
}

- (BOOL)isExecuting {
    // any thread
    return self.state == kBasicTaskStateExecuting;
}

- (BOOL)isFinished {
    // any thread
    return self.state == kBasicTaskStateFinished || self.state == kBasicTaskStateCancel;
}

- (void)start {
    
    self.state = kBasicTaskStateExecuting;
    
    @autoreleasepool {
        
        [self operationDidStart];
        
        //DLog(@"----task:%@ stop----",[NSThread currentThread] );
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        while (![self isFinished]
               && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {}
        
    }
    
}
- (void)cancel {
    
    @synchronized (self) {
        DLog(@"-----task %p canceled", self);
        [self operationWillFinish];
        self.state = kBasicTaskStateCancel;
        [self operationWillCancel];
    }
}

- (void)finishWithError:(NSError *)error {
    @synchronized (self) {
        [self operationWillFinish];
        self.state = kBasicTaskStateFinished;
    }
}



@end
