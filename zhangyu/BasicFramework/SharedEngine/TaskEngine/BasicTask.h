//
//  BasicTask.h
//  alfaromeo.dev
//
//  Created by zhang da on 11-5-16.
//  Copyright 2011 alfaromeo.dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

enum BasicTaskState {
    kBasicTaskStateInited,
    kBasicTaskStateCancel,
    kBasicTaskStateExecuting,
    kBasicTaskStateFinished
};

typedef enum BasicTaskState BasicTaskState;


@interface BasicTask : NSOperation {
    TaskType taskType;
}

@property (nonatomic, assign) TaskType taskType;
@property (nonatomic, assign) BasicTaskState state;
@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@end



@interface BasicTask (SubClassSupport)

- (void)operationDidStart;
- (void)operationWillCancel;
- (void)operationWillFinish;

- (void)finishWithError:(NSError *)error;
- (void)postNotificationSucceeded:(BOOL)result withInfo:(NSDictionary *)userInfo;




@end
