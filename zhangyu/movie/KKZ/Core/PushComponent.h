//
//  推送的组件
//
//  Created by wuzhen on 16/2/15.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//
//  TODO 后期要做到可以多个第三方推送共存，能够防止重复的推送消息显示
//

@interface PushComponent : NSObject

/**
 * AppDelegate 的 didFinishLaunchingWithOptions 函数中调用该方法，初始化友盟推送。
 */
+ (void)applicationDidFinishLaunching:(NSDictionary *)launchOptions;

/**
 * AppDelegate 的 didRegisterForRemoteNotificationsWithDeviceToken 函数中调用该方法，注册设备的标识。
 */
+ (void)registerDeviceToken:(NSData *)deviceToken;

/**
 * AppDelegate 的 didReceiveRemoteNotification 函数中调用该方法，处理接收到的通知。
 */
+ (void)receiveNotification:(NSDictionary *)userInfo showAlertView:(BOOL)showAlertView;

@end
