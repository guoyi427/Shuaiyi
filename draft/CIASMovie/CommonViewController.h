//
//  CommonViewController.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/3.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "UIViewController+NavAnim.h"
#import <UIKit/UIKit.h>


/******************************系统默认尺寸*******************************/
#define kCommonScreenBounds [UIScreen mainScreen].bounds //整个APP屏幕尺寸
#define kCommonScreenWidth kCommonScreenBounds.size.width //整个APP屏幕的宽度
#define kCommonScreenHeight kCommonScreenBounds.size.height //整个APP屏幕的高度

#define kCommonTextSize 13 // 列表副标题的文字大小

typedef enum : NSUInteger {
    rightButtonTag = 5000,
} buttonTag;

@interface CommonViewController : UIViewController <UIGestureRecognizerDelegate> {
@public
    UIView *_changeStatusView;
}
/**
 *  视图的起点坐标
 */
@property (nonatomic, assign) CGFloat contentPositionY;

/**
 *  视图的高度
 */
@property (nonatomic, assign) CGFloat KCommonContentHeight;

/**
 *  导航视图
 */
@property (nonatomic, strong) UIImageView *navBarView;

/**
 *  导航视图标题
 */
@property (nonatomic, strong) UILabel *kkzTitleLabel;

/**
 *  导航视图返回按钮
 */
@property (nonatomic, strong) UIButton *kkzBackBtn;

/**
 *  状态栏视图
 */
@property (nonatomic, strong) UIView *statusView;

/**
 *  导航条右边按钮
 */
@property (nonatomic, strong) UIButton *kkzRightBtn;

/**
 *  变化后的导航条右边按钮
 */
@property (nonatomic, strong) UIButton *changeRightBtn;

/**
 *  变化后的导航栏上面的文字
 */
@property (nonatomic, strong) UILabel *changeTitleLabel;

/**
 *  即将出现时的动画
 */
@property (nonatomic, assign) CommonSwitchAnimation appearAnimation;

/**
 *  变化的导航条视图
 */
@property (nonatomic, strong) UIView *changeStatusView;

/**
 *  第一次appear
 */
@property (nonatomic, assign) BOOL firstAppear;

/**
 *  是否显示导航条，默认是 TRUE。
 *
 */
- (BOOL)showNavBar;

/**
 *  是否显示导航条标题，默认是 TRUE。
 *
 */
- (BOOL)showTitleBar;

/**
 *  是否显示导航条返回按钮，默认是 TRUE。
 *
 */
- (BOOL)showBackButton;

/**
 *  是否定制右边按钮
 *
 */
- (BOOL)setRightButton;

/**
 *  是否显示导航条上的分割线
 *
 */
- (BOOL)showNavBarLine;

/**
 *  是否允许通过右滑手势返回
 *
 */
- (BOOL)enableScrollToBack;

/**
 *  返回右边按钮的图片
 *
 */
- (NSString *)rightButtonImageName;

/**
 *  变化后的状态栏的右边按钮图片名字
 *
 *  @return
 */
- (NSString *)changeRightButtonImage;

/**
 *  变化后的状态栏上面的文字
 *
 *  @return
 */
- (NSString *)changeNavBarTitle;

/**
 *  返回按钮点击方法
 */
- (void)cancelViewController;

/**
 *  按钮点击抬起事件
 *
 *  @param sender
 */
- (void)commonBtnClick:(UIButton *)sender;

/**
 *  按钮点击按钮事件
 *
 *  @param sender
 */
- (void)commonBtnDownClick:(UIButton *)sender;

/**
 *  按钮取消事件
 *
 *  @param checkNetConnectState
 */
- (void)commonBtnCancelClick:(UIButton *)sender;

/**
 *  检查网络连接状态
 *
 *  @return TRUE 代表网络已经连接上
 */
- (BOOL)checkNetConnectState;

/**
 *  计算文本尺寸
 *
 *  @param font
 *  @param inputString
 *  @param inputSize
 *
 */
- (CGSize)customTextSize:(UIFont *)font text:(NSString *)inputString size:(CGSize)inputSize;

/**
 *  显示变色的导航条
 *
 *  @param changeColor
 */
- (void)setColorfulStatusBar:(UIColor *)changeColor;

/**
 *  设置正常的导航条
 *
 *  @param normalColor
 */
- (void)setNormalStatusBar:(UIColor *)normalColor;

/**
 *  设置白色的状态栏
 */
- (void)setStatusBarLightStyle;

/**
 *  设置默认的状态栏
 */
- (void)setStatusBarDefaultStyle;

/**
 *  切换到另一个页面
 *
 *  @param controller
 *  @param animation
 */
- (void)pushViewController:(UIViewController *)controller animation:(CommonSwitchAnimation)animation;

/**
 *  POP回上一个页面
 *
 *  @param animated 是否需要动画
 */
- (void)popViewControllerAnimated:(BOOL)animated;

/**
 *  POP回根视图
 *
 *  @param animated 是否需要动画
 */
- (void)popToViewControllerAnimated:(BOOL)animated;


-(void)callApiDidSucceed:(id)responseData;
-(void)callApiDidFailed:(id)responseData;



@end
