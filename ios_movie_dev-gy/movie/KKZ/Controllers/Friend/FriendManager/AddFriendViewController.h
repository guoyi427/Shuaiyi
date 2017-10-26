//
//  好友管理 - 添加关注页面
//
//  Created by zhang da on 12-8-14.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

@interface AddFriendViewController : CommonViewController

@property (nonatomic, strong) NSString *userId;

/**
 * 是否显示顶部导航栏。
 */
@property (nonatomic, assign) BOOL isShowTopBar;

- (id)initWithUser:(NSString *)userId;

/**
 *  初始化页面
 *
 *  @param userId
 *  @param isShow
 *
 *  @return
 */
- (id)initWithUser:(NSString *)userId
    withShowTopBar:(BOOL)isShow;

@end
