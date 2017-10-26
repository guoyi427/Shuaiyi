//
//  UpgradeComponent.m
//  KoMovie
//
//  Created by wuzhen on 16/8/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "DataEngine.h"
#import "UpgradeComponent.h"
#import "AppRequest.h"
#import "AppVersion.h"
@implementation UpgradeComponent

/**
 * 检查版本更新，如果有新版本提示给用户。
 */
+ (void)checkAppUpdate {
    THIRD_LOGIN_WRITE(YES);
    
    AppRequest *request = [[AppRequest alloc] init];
    [request requestAppVersionSuccess:^(AppVersion * _Nullable version) {
        [self handleUpdateVersionFinished:version];
    } failure:nil];

}

/**
 * 查询最新的版本号。
 */
+ (void)queryLastestUpgradeVersion {
}

+ (void)handleUpdateVersionFinished:(AppVersion *)version {
    THIRD_LOGIN_WRITE(YES);

    if (!version) {
        return;
    }

    BOOL isNeedUpdateApp = [self isNeedUpdateApp:version];
    if (isNeedUpdateApp) {
        BOOL forceUpdate = version.forceUpdate;

        UIAlertView *alert;
        RIButtonItem *done = [RIButtonItem itemWithLabel:@"马上体验" action:^{
            [UpgradeComponent updateApplication:forceUpdate];
        }];

        if (forceUpdate) {
            alert = [[UIAlertView alloc] initWithTitle:@""
                                               message:version.updateMessage
                                      cancelButtonItem:done
                                      otherButtonItems:nil];
        } else {
            RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"以后再说" action:^{
                appDelegate.appdelegateAlert = nil;
            }];

            alert = [[UIAlertView alloc] initWithTitle:@""
                                               message:version.updateMessage
                                      cancelButtonItem:cancel
                                      otherButtonItems:done, nil];
        }
        [alert show];
        appDelegate.appdelegateAlert = alert;
    }
}

+ (BOOL)isNeedUpdateApp:(AppVersion *)version {
    NSString *serverVersion = version.version;
    NSString *curVersion = [self getAppVersion];
    
    serverVersion = [serverVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    serverVersion = [[NSString stringWithFormat:@"%@0000", serverVersion] substringToIndex:6];
    NSInteger lastestVersion = [serverVersion intValue];
    
    curVersion = [curVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    curVersion = [[NSString stringWithFormat:@"%@0000", curVersion] substringToIndex:6];
    NSInteger currentVersion = [curVersion intValue];
    
    //当前版本大于最新版本：审核中，关闭第三方登录
    THIRD_LOGIN_WRITE(currentVersion <= lastestVersion);
    
    DLog(@"Third login enable: %d", THIRD_LOGIN);
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return lastestVersion > currentVersion;
}

+ (void)updateApplication:(BOOL)forceUpdate {
    NSURL *url = [NSURL URLWithString:kAppUrl];
    [[UIApplication sharedApplication] openURL:url];
    if (forceUpdate) {
        exit(0);
    }
    appDelegate.appdelegateAlert = nil;
}

+ (NSString *)getAppVersion {
    return [[[DataEngine sharedDataEngine] getSoftwareInfo] objectForKey:@"CFBundleVersion"];
}

@end
