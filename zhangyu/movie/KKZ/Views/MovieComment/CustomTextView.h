//
//  CustomTextView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/15.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextView : UITextView<UITextViewDelegate>

/**
 *  用户未输入的时候显示的文字
 */
@property (nonatomic, strong) NSString *placeHoder;

/**
 *  最大输入字数
 */
@property (nonatomic, assign) NSUInteger maxWordCount;

/**
 *  设置文本
 */
@property (nonatomic, strong) NSString *customText;

@end
