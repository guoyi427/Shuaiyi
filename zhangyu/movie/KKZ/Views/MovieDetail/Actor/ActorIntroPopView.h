//
//  显示演员简介信息的PopView
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface ActorIntroPopView : UIView <UIGestureRecognizerDelegate>

/**
 * 设置显示的内容。
 */
@property (nonatomic, strong) NSString *content;

/**
 * 显示。
 */
- (void)show;

/**
 * 隐藏。
 */
- (void)dismiss;

@end
