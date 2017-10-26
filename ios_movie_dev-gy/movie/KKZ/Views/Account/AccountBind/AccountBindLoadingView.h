//
//  绑定、解绑账号操作的提示框
//
//  Created by 艾广华 on 15/12/23.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

typedef void (^animationFinished)();

@interface AccountBindLoadingView : UIView

/**
 *  标题字符串
 */
@property (nonatomic, strong) NSString *titleString;

/**
 *  初始化成功视图
 */
- (id)initWithSucessFrame:(CGRect)frame;

/**
 *  开始动画
 */
- (void)startAnimation;

/**
 *  停止动画
 */
- (void)stopAnimation;

/**
 *  开始显示成功页面
 */
- (void)beginShowSuccessView:(animationFinished)block;

/**
 * 隐藏。
 */
- (void)hiden;

/**
 * 显示加载中的提示框。
 */
+ (AccountBindLoadingView *)showWithTitle:(NSString *)title;

/**
 * 显示加载中的提示框。
 */
+ (AccountBindLoadingView *)showWithTitle:(NSString *)title atView:(UIView *)showView;

@end
