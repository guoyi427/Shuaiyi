//
//  处理 URL 形式打开 App 的组件
//
//  Created by wuzhen on 15/5/8.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface UrlOpenUtility : NSObject

#define APP_OPEN_PATH @"komovie://app/page?"
#define ACTIVITY_OPEN_PATH @"http://m.komovie.cn/sub/client?"

/**
 * 处理打开 App 页面的 URL。
 *
 * @return 是否处理成功
 */
+ (BOOL)handleOpenAppUrl:(NSURL *)url;

/**
 * 处理 URL 的 tab 值。
 */
+ (int)handleTabIndex:(NSString *)tab;

@end
