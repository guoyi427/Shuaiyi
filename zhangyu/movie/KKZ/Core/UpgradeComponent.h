//
//  UpgradeComponent.h
//  KoMovie
//
//  Created by wuzhen on 16/8/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//
//  版本更新的功能组件
//

@interface UpgradeComponent : NSObject

/**
 * 检查版本更新，如果有新版本提示给用户。
 */
+ (void)checkAppUpdate;

/**
 * 查询最新的版本号。
 */
+ (void)queryLastestUpgradeVersion;

@end
