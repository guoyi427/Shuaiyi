//
//  NotificationEngine.h
//  KoMovie
//
//  Created by zhang da on 13-5-1.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 本类主要是处理服务器发送的 push 通知
 */
@interface NotificationEngine : NSObject

+ (NotificationEngine *)sharedInstance;

/**
 * 处理服务器发送的 push。
 *
 * @param showAlertView 接收到通知后是否显示对话框
 */
- (void)handleRomoteNotification:(NSDictionary *)userInfo showAlertView:(BOOL)showAlertView;

/**
 * TODO: delete
 */
- (void)handleLocalCallFromURL:(NSURL *)url;

//- (void)handleRomoteNotification:(NSDictionary *)userInfo;

//- (void)handleLocalCallFromURLOfActivity:(NSURL *)url;
//- (BOOL)isBPush:(NSDictionary *)userInfo;

@end
