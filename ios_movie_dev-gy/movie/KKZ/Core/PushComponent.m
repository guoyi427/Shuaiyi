//
//  推送的组件
//
//  Created by wuzhen on 16/2/15.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "PushComponent.h"

#import "BDMultiDownloader.h"
#import "CacheEngine.h"
#import "ImageEngine.h"
#import "ImageEngineNew.h"
#import "KKZUtility.h"
#import "UIAlertView+Blocks.h"
#import "UMessage.h"
#import "UrlOpenUtility.h"
#import "WebViewController.h"

@implementation PushComponent

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

/**
 * AppDelegate 的 didFinishLaunchingWithOptions 函数中调用该方法，初始化友盟推送。
 */
+ (void)applicationDidFinishLaunching:(NSDictionary *)launchOptions {

    //set AppKey and AppSecret
    [UMessage startWithAppkey:@"4eda21de5270150da7000027" launchOptions:launchOptions];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if (UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title = @"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground; //当点击的时候启动程序

        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init]; //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title = @"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground; //当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES; //需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;

        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1"; //这组动作的唯一标示
        [categorys setActions:@[ action1, action2 ] forContext:(UIUserNotificationActionContextDefault)];

        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];

    } else {
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
#else

    //register remoteNotification types (iOS 8.0以下)
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];

#endif

//for log
#ifdef DEBUG
    [UMessage setLogEnabled:YES];
#else
    [UMessage setLogEnabled:NO];
#endif

    //channel
    [UMessage setChannel:@"App Store"];
}

/**
 * AppDelegate 的 didRegisterForRemoteNotificationsWithDeviceToken 函数中调用该方法，注册设备的标识。
 */
+ (void)registerDeviceToken:(NSData *)deviceToken {
    DLog(@"UMessage, deviceToken: %@", deviceToken);

    [UMessage registerDeviceToken:deviceToken];
}

/**
 * AppDelegate 的 didReceiveRemoteNotification 函数中调用该方法，处理接收到的通知。
 */
+ (void)receiveNotification:(NSDictionary *)userInfo showAlertView:(BOOL)showAlertView {

    DLog(@"UMessage, receive notification: %@, showAlertView: %d", userInfo, showAlertView);

    /**
     * userInfo:
     * {
     *   aps = {
     *     alert = "message";
     *     sound = default;
     *   };
     *   open = "komovie://app/page || http:// || https://";
     *   type = "99[99 清除缓存]";
     * }
     */

    NSString *alert = [[userInfo kkz_objForKey:@"aps"] objectForKey:@"alert"];
    NSString *openPath = [userInfo objectForKey:@"open"];
    NSString *type = [userInfo objectForKey:@"type"];

    //清除本地缓存的 push 不需要显示对话框
    BOOL needShowAlert = (showAlertView && ![type isEqualToString:@"99"]);

    if (needShowAlert) { //显示对话框
        if (openPath) {
            RIButtonItem *okBtn = [RIButtonItem itemWithLabel:@"确定"
                                                       action:^() {
                                                           [self handleReceivedNotification:openPath webTitle:alert type:type];
                                                       }];
            RIButtonItem *cancelBtn = [RIButtonItem itemWithLabel:@"取消"
                                                           action:^(){
                                                           }];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提醒"
                                                                message:alert
                                                       cancelButtonItem:cancelBtn
                                                       otherButtonItems:okBtn, nil];
            [alertView show];
        } else {
            [appDelegate showAlertViewForTitle:@"温馨提醒" message:alert cancelButton:@"确定"];
        }
    } else { //由推送消息或者后台进入，不显示对话框，直接跳转到相应的页面
        [self handleReceivedNotification:openPath webTitle:alert type:type];
    }
}

+ (void)handleReceivedNotification:(NSString *)openPath webTitle:(NSString *)webTitle type:(NSString *)type {

    if (openPath) {
        NSString *lowercasePath = [openPath lowercaseString];

        if ([lowercasePath hasPrefix:@"http://"] || [lowercasePath hasPrefix:@"https://"]) {
            //打开 WebViewController
            WebViewController *ctr = [[WebViewController alloc] initWithTitle:webTitle];
            [ctr loadRequestWithURL:openPath];

            CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
            [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
        } else {
            [UrlOpenUtility handleOpenAppUrl:[NSURL URLWithString:openPath]];
        }
        return;
    }

    //处理 type的逻辑
    if ([type isEqualToString:@"99"]) { //清除本地缓存
        [[CacheEngine sharedCacheEngine] resetCache];
        [[ImageEngine sharedImageEngine] resetCache];
        [[ImageEngineNew sharedImageEngineNew] resetCache];
        [[BDMultiDownloader shared] clearDiskCache];
    }
}

@end
