//
//  带有PlaceHolder的UITextView
//
//  Created by wuzhen on 16/8/18.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface KKZTextView : UITextView <UITextViewDelegate>

/**
 * 未输入时显示的文字。
 */
@property (nonatomic, strong) NSString *placeHoderText;

/**
 * 未输入时提示文字的字体颜色。
 */
@property (nonatomic, assign) UIColor *placeHolderTextColor;

/**
 * 最大输入字数
 */
@property (nonatomic, assign) NSInteger maxWordCount;

/**
 输入内容改变 回调

 @param a_block 回调
 */
- (void) textChange:(void(^)())a_block;

@end
