//
//  统计分析的组件
//
//  Created by wuzhen on 15/7/15.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "StatisticsComponent.h"
#import "UMMobClick/MobClick.h"

@implementation StatisticsComponent

/**
 * 初始化统计分析的组件。
 */
+ (void)initStatisticsComponent {
    UMConfigInstance.appKey = kUMengAppKey;
    UMConfigInstance.channelId = kUMengChannelId;
    UMConfigInstance.ePolicy = SEND_INTERVAL;
    [MobClick startWithConfigure:UMConfigInstance]; // 初始化SDK
    [MobClick setEncryptEnabled:YES]; // 启动日志加密
    [MobClick setLogSendInterval:300]; // 5分钟发送一次日志

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    DLog(@"APPversion: %@", version);
    [MobClick setAppVersion:version]; // 设置版本号

#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#else
    [MobClick setLogEnabled:NO];
#endif
}

/**
 * 页面启动的事件。
 */
+ (void)pageViewBeginEvent:(NSString *)pageName {
#ifndef DEBUG
    [MobClick beginLogPageView:pageName];
#endif
}

/**
 * 页面结束的事件。
 */
+ (void)pageViewEndEvent:(NSString *)pageName {
#ifndef DEBUG
    [MobClick endLogPageView:pageName];
#endif
}

/**
 * 发送事件。
 *
 * @param eventId 事件的ID
 */
+ (void)event:(NSString *)eventId {
#ifndef DEBUG
    [self event:eventId
            attributes:nil];
#endif
}

/**
 * 发送事件。
 *
 * @param eventId    事件的ID
 * @param attributes 额外的参数
 */
+ (void)event:(NSString *)eventId attributes:(NSDictionary *)attributes {
    DLog(@"%@: sendEvent: %@", @"StatisticsComponent", eventId);

#ifndef DEBUG
    if (attributes == nil) {
        [MobClick event:eventId];
    } else {
        [MobClick event:eventId attributes:attributes];
    }
// TODO 添加自己服务器的统计
#endif
}

/**
 * 统计账号登录的事件。
 */
+ (void)loginEvent:(NSString *)uid platform:(NSString *)platform {
    DLog(@"%@: sendEvent: LoginEvent, uid: %@", @"StatisticsComponent", uid);

#ifndef DEBUG
    [MobClick profileSignInWithPUID:uid
                           provider:platform];
// TODO 添加自己服务器的统计
#endif
}

/**
 * 统计账号退出的事件。
 */
+ (void)logoutEvent {
    DLog(@"%@: sendEvent: LogoutEvent", @"StatisticsComponent");

#ifndef DEBUG
    [MobClick profileSignOff];
// TODO 添加自己服务器的统计
#endif
}

@end
