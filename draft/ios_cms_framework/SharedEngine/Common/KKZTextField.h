//
//  KKZTextField.h
//  Cinephile
//
//  Created by wuzhen on 16/11/22.
//  Copyright © 2016年 Kokozu. All rights reserved.
//

@class KKZTextField;

typedef enum {
    KKZTextFieldNormal,
    KKZTextFieldWithClear,
    KKZTextFieldWithClearAndSecret,
} KKZTextFieldType;

@protocol KKZTextFieldDelegate <NSObject>

@optional
- (void)kkzTextFieldDeleteBackward:(KKZTextField *)field;

- (void)kkzTextFieldClear:(KKZTextField *)field;

@end

@interface KKZTextField : UITextField

/**
 * KKZTextFieldType。
 */
@property (nonatomic, assign) KKZTextFieldType fieldType;

/**
 * 是否显示软键盘的TopView。
 */
@property (nonatomic, assign) BOOL showKeyboardTopView;

@property (nonatomic, assign) NSInteger rightViewHeight;

/**
 * 最大输入字数。
 */
@property (nonatomic, assign) NSInteger maxWordCount;

/**
 * 删除按钮的图片。
 */
@property (nonatomic, strong) UIImage *clearImage;

/**
 * 显示密码的图片。
 */
@property (nonatomic, strong) UIImage *secretVisibleImage;

/**
 * 不显示密码的图片。
 */
@property (nonatomic, strong) UIImage *secretInvisibleImage;

/**
 * 点击删除键删除字符的回调。
 */
@property (nonatomic, weak) id<KKZTextFieldDelegate> kkzDelegate;

/**
 * 获取到焦点时的边框颜色。
 */
@property (nonatomic, strong) UIColor *focusedBorderColor;

/**
 * 获取到焦点时的背景色。
 */
@property (nonatomic, strong) UIColor *focusedBackgroundColor;

@end
