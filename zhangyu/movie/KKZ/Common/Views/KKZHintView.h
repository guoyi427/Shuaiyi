//
//  弱提示的View
//
//  Created by wuzhen on 16/8/26.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MBProgressHUD.h"

@interface KKZHintView : NSObject

/**
 * 显示弱提示的View，默认添加到window中，2秒后自动隐藏。
 *
 * @param hint 提示文字
 */
+ (MBProgressHUD *)showHint:(NSString *)hint;

/**
 * 显示弱提示的View，默认添加到window中。
 *
 * @param hint     提示文字
 * @param autoHide 是否自动隐藏
 */
+ (MBProgressHUD *)showHint:(NSString *)hint autoHide:(BOOL)autoHide;

/**
 * 显示弱提示的View
 *
 * @param hint     提示文字
 * @param autoHide 是否自动隐藏
 * @param view     弱提示View要附加到的View
 */
+ (MBProgressHUD *)showHint:(NSString *)hint autoHide:(BOOL)autoHide addedTo:(UIView *)view;

@end
