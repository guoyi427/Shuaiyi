//
//  新的好友页面
//
//  Created by 艾广华 on 15/12/7.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import <MessageUI/MessageUI.h>

typedef void (^ClickCancel)();

// 入口已屏蔽
@interface FriendRecommendViewController : CommonViewController

/**
 *  初始化页面
 *
 *  @param block 点击取消按钮的回调函数
 *
 *  @return
 */
- (id)initWithClickCancel:(ClickCancel)block;

@end
