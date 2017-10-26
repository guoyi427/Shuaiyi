//
//  扩展UIWebController添加弱提示的功能
//
//  Created by wuzhen on 16/8/18.
//  Copyright (c) 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface UIViewController (Hint)

/**
 * 显示弱提示信息，两秒后自动隐藏。
 */
- (void)showHint:(NSString *)hint;

/**
 * 在指定的View中显示弱提示信息。
 *
 * @param autoHide 是否自动隐藏
 */
- (void)showHint:(NSString *)hint autoHide:(BOOL)autoHide;

/**
 * 隐藏提示信息。
 */
- (void)hideHint;

@end
