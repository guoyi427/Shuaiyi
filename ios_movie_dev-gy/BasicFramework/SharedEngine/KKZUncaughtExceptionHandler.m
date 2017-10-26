//
//  UncaughtExceptionHandler.m
//  UncaughtExceptions
//
//  Created by Matt Gallagher on 2010/05/25.
//  Copyright 2010 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "KKZUncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>


#define kSignalException @"kSignalException"
#define kSignalKey @"kSignalKey"
#define kBacktraceKey @"kBacktraceKey"


volatile int32_t KKZUncaughtExceptionCount = 0;
const int32_t KKZUncaughtExceptionMaximum = 10;

const int kExceptionAddressOffset = 4;
const int kExceptionReportAddressCount = 5;



void KKZHandleException(NSException *exception) {
	
    int32_t exceptionCount = OSAtomicIncrement32(&KKZUncaughtExceptionCount);
    
	if (exceptionCount <= KKZUncaughtExceptionMaximum) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
        [userInfo setObject:[KKZUncaughtExceptionHandler backtrace] forKey:kBacktraceKey];
        
        [[[[KKZUncaughtExceptionHandler alloc] init] autorelease]
         performSelectorOnMainThread:@selector(handleException:)
         withObject:[NSException exceptionWithName:[exception name]
                                            reason:[exception reason]
                                          userInfo:userInfo]
         waitUntilDone:YES];
	}
}

void KKZSignalHandler(int signal) {
    
	int32_t exceptionCount = OSAtomicIncrement32(&KKZUncaughtExceptionCount);
    
	if (exceptionCount <= KKZUncaughtExceptionMaximum) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]
                                                                           forKey:kSignalKey];
        [userInfo setObject:[KKZUncaughtExceptionHandler backtrace] forKey:kBacktraceKey];
        
        [[[[KKZUncaughtExceptionHandler alloc] init] autorelease]
         performSelectorOnMainThread:@selector(handleException:)
         withObject:[NSException exceptionWithName:kSignalException
                                            reason:[NSString stringWithFormat:@"Signal %d was raised.", signal]
                                          userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]
                                                                               forKey:kSignalKey]]
         waitUntilDone:YES];
	}
}

void InitUncaughtExceptionHandler() {
	NSSetUncaughtExceptionHandler(&KKZHandleException);
	signal(SIGABRT, KKZSignalHandler);
	signal(SIGILL, KKZSignalHandler);
	signal(SIGSEGV, KKZSignalHandler);
	signal(SIGFPE, KKZSignalHandler);
	signal(SIGBUS, KKZSignalHandler);
	signal(SIGPIPE, KKZSignalHandler);
}



@implementation KKZUncaughtExceptionHandler

+ (NSArray *)backtrace {
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for ( i = kExceptionAddressOffset; i < kExceptionAddressOffset + kExceptionReportAddressCount; i++) {
	 	[backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}

- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex {
	if (anIndex == 0) {
		dismissed = YES;
	}
}

- (void)handleException:(NSException *)exception {
    
    NSString *log = [NSString stringWithFormat:
                     @"You can try to continue but the application may be unstable.\n\n"
                     @"Debug details follow:\n%@\n%@", [exception reason], [[exception userInfo] objectForKey:kBacktraceKey]];
    
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *folderDir = [[documentPaths objectAtIndex:0] stringByAppendingString:@"/ErrorLogs"];
    
	if (![[NSFileManager defaultManager] fileExistsAtPath:folderDir])
		[[NSFileManager defaultManager] createDirectoryAtPath:folderDir withIntermediateDirectories:NO attributes:nil error:nil];
    
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", folderDir, [NSDate date]];
    NSError *error = nil;
    [log writeToFile:filePath atomically:NO encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        DLog(@"%@", error);
    }
    
#ifdef DEBUG
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unhandled exception"
                                                    message:log
                                                   delegate:self
                                          cancelButtonTitle:@"Quit"
                                          otherButtonTitles:@"Continue", nil];
	[alert show];
    [alert release];
#endif
    
	CFRunLoopRef runLoop = CFRunLoopGetCurrent();
	CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
	
	while (!dismissed) {
		for (NSString *mode in (NSArray *)allModes) {
			CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
		}
	}
	
	CFRelease(allModes);
    
	NSSetUncaughtExceptionHandler(NULL);
	signal(SIGABRT, SIG_DFL);
	signal(SIGILL, SIG_DFL);
	signal(SIGSEGV, SIG_DFL);
	signal(SIGFPE, SIG_DFL);
	signal(SIGBUS, SIG_DFL);
	signal(SIGPIPE, SIG_DFL);
	
	if ([[exception name] isEqual:kSignalException]) {
		kill(getpid(), [[[exception userInfo] objectForKey:kSignalKey] intValue]);
	} else {
		[exception raise];
	}
}

@end

