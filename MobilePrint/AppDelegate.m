//
//  AppDelegate.m
//  MobilePrint
//
//  Created by GuoYi on 15/4/8.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import "AppDelegate.h"

//      ViewController
#import "MPTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    MPTabBarController * tabBarController = [[MPTabBarController alloc] init];
    self.window .rootViewController = tabBarController;
    
//    [self _privateTest];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Test

- (void)_privateTest {
    NSString * testString = @"阿拉姐夫#阿里间#阿里开始放假##阿里肯定放假#拉开大姐夫#阿里的开机费#阿拉克打飞机#";
    NSError * error = nil;
    /// 正则表达式
    NSRegularExpression * regularExpression = [NSRegularExpression regularExpressionWithPattern:@"#[^#]+#"
                                                                                        options:NSRegularExpressionCaseInsensitive
                                                                                          error:&error];
    NSArray * resultStringArray = [regularExpression matchesInString:testString
                                                             options:NSMatchingReportProgress
                                                               range:NSMakeRange(0, testString.length)];
    NSLog(@"resultStringArray = %@",resultStringArray);
    for (NSTextCheckingResult * result in resultStringArray) {
        NSLog(@"result = %@",[testString substringWithRange:result.range]);
    }
}

@end
