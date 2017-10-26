//
//  CommonTask.m
//  phonebook
//
//  Created by zhang da on 11-4-26.
//  Copyright 2011 alfaromeo.dev. All rights reserved.
//

#import "CommonTask.h"
#import "TaskQueue.h"
#import "DataEngine.h"

@implementation CommonTask

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)dealloc {
	
}

- (BOOL)isConcurrent {
    return YES;
}

- (void)doWork {}

- (void)finishWork {}

// Called by QBasicTask when the operation starts.  This kicks of an asynchronous NSURLConnection.
- (void)operationDidStart {
    [super operationDidStart];

	[self doWork];
	//must call this method!
	[self finishWithError:nil];
}

// Called by QBasicTask when the operation has finished.  We do various bits of tidying up.
- (void)operationWillFinish {
    [self finishWork];
}

@end
