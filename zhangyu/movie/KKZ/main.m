//
//  main.m
//  KKZ
//
//  Created by da zhang on 11-7-20.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TargetConditionals.h>
#import <dlfcn.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
//#if TARGET_IPHONE_SIMULATOR
//            NSString *frameworkPath = [[NSProcessInfo processInfo] environment][@"DYLD_FALLBACK_FRAMEWORK_PATH"];
//            if (frameworkPath) {
//                NSString *webkitLibraryPath = [NSString pathWithComponents:@[frameworkPath, @"WebKit.framework", @"WebKit"]];
//                dlopen([webkitLibraryPath cStringUsingEncoding:NSUTF8StringEncoding], RTLD_LAZY);
//            }
//#else
//            dlopen("/System/Library/Frameworks/WebKit.framework/WebKit", RTLD_LAZY);
//#endif
//        }
        int retVal = UIApplicationMain(argc, argv, nil, @"KKZAppDelegate");
        return retVal;
    }
}