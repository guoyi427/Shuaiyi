//
//  UIAlertView+Blocks.h
//  Shibui
//
//  Created by Jiva DeVoe on 12/28/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import "RIButtonItem.h"
#import <UIKit/UIKit.h>

@interface UIAlertView (Blocks)

/**
 * 显示带有提示信息、一个按钮的对话框，不带有标题，按钮点击关闭对话框。
 *
 * @param message 提示信息
 * @param text    按钮的文字
 */
+ (void)showAlertView:(NSString *)message
           buttonText:(NSString *)text;

/**
 * 显示带有提示信息、一个按钮的对话框，不带有标题。
 *
 * @param message      提示信息
 * @param buttonText   按钮的文字
 * @param buttonTapped 按钮的点击事件
 */
+ (void)showAlertView:(NSString *)message
           buttonText:(NSString *)text
         buttonTapped:(void (^)())buttonTapped;

/**
 * 显示带有标题、提示信息、一个按钮的对话框，按钮点击关闭对话框。
 *
 * @param title        标题
 * @param message      提示信息
 * @param buttonText   按钮的文字
 */
+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                    buttonText:(NSString *)text;

/**
 * 显示带有标题、提示信息、一个按钮的对话框。
 *
 * @param title        标题
 * @param message      提示信息
 * @param buttonText   按钮的文字
 * @param buttonTapped 按钮的点击事件
 */
+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                    buttonText:(NSString *)text
                  buttonTapped:(void (^)())buttonTapped;

/**
 * 显示带有提示信息、两个按钮的对话框，不带有标题。
 *
 * @param message      提示信息
 * @param cancelText   取消按钮的文字
 * @param cancelTapped 取消按钮的点击事件
 * @param okText       确定按钮的文字
 * @param okTapped     确定按钮的点击事件
 */
+ (void)showAlertView:(NSString *)message
           cancelText:(NSString *)cancelText
         cancelTapped:(void (^)())cancelTapped
               okText:(NSString *)okText
             okTapped:(void (^)())okTapped;

/**
 * 显示带有标题、提示信息、两个按钮的对话框。
 *
 * @param title        标题
 * @param message      提示信息
 * @param cancelText   取消按钮的文字
 * @param cancelTapped 取消按钮的点击事件
 * @param okText       确定按钮的文字
 * @param okTapped     确定按钮的点击事件
 */
+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                    cancelText:(NSString *)cancelText
                  cancelTapped:(void (^)())cancelTapped
                        okText:(NSString *)okText
                      okTapped:(void (^)())okTapped;

/**
 * 创建对话框。
 *
 * @param title            标题
 * @param message          提示信息
 * @param cancelButtonItem 取消按钮
 * @param otherButtonItems 其他按钮
 *
 * @return UIAlertView
 */
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
   cancelButtonItem:(RIButtonItem *)cancelButtonItem
   otherButtonItems:(RIButtonItem *)otherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

/**
 * 添加按钮。
 *
 * @param item 按钮
 *
 * @return
 */
- (NSInteger)addButtonItem:(RIButtonItem *)item;

@end
