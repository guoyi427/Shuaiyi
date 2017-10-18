//
//  CommonViewController.h
//  CIASMovie
//
//  Created by cias on 2016/12/7.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonViewController : UIViewController<UIGestureRecognizerDelegate>

/**
 *  视图的起点坐标
 */
@property (nonatomic, assign) CGFloat contentPositionY;
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
 *  是否显示导航条上的分割线
 *
 */
- (BOOL)showNavBarLine;


@end
