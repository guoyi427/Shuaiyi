//
//  软键盘上带有完成ToolBar的UITextField
//
//  Created by wuzhen on 16/8/19.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@class KKZTextField;

#import "KKZKeyboardTopView.h"

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

/**
 键盘TopView的delegate。
 */
@property (nonatomic, weak) id<KKZKeyboardTopViewDelegate> keyboardDelegate;

/**
 * 初始化。
 *
 * @param frame frame
 * @param type  KKZTextFieldType
 *
 * @return KKZTextField
 */
- (id)initWithFrame:(CGRect)frame andFieldType:(KKZTextFieldType)fieldType;

@end
