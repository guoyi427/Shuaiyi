//
//  NavigationControl.h
//  KoMovie
//
//  Created by alfaromeo on 12-6-18.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

typedef enum {
    ViewSwitchAnimationNone = 0,
    ViewSwitchAnimationBounce,   //弹出
    ViewSwitchAnimationWP7Flip,     //翻转
    
    ViewSwitchAnimationFlipR,
    ViewSwitchAnimationFlipL,
    
    ViewSwitchAnimationSwipeL2R, //左到右
    ViewSwitchAnimationSwipeR2L, //右到左
    ViewSwitchAnimationSwipeD2U, //下到上
    ViewSwitchAnimationSwipeU2D  //上到下

} ViewSwitchAnimation;

@interface NavigationControl : NSObject {
    UIWindow *holder;
    
    NSMutableArray *viewControllerStack;
    BOOL stackLock;
    CGRect kOriginFrame;
    
    UIView *mask;
}

@property (nonatomic, retain) UIWindow *holder;


- (id)initWithHolder:(UIWindow *)viewHolder;

- (void)setMaskShow:(bool)show;

- (int)numberOfControllers;
- (void)setViewControllerHidden:(BOOL)hide atIndex:(int)idx;

- (void)pushViewController:(id)ctr animation:(ViewSwitchAnimation)animation onlyOnce:(BOOL)one;

- (void)pushViewController:(id)ctr animation:(ViewSwitchAnimation)animation;
- (void)pushViewController:(id)ctr animation:(ViewSwitchAnimation)animation finished:( void (^)())fBlock;
- (void)switchToViewController:(id)ctr animation:(ViewSwitchAnimation)animation;
- (void)popViewControllerAnimated:(BOOL)animated;
- (void)popViewControllerWithAnimation:(ViewSwitchAnimation)animation;
- (void)popToRootViewControllerWithAnimation:(ViewSwitchAnimation)animation;

@end
