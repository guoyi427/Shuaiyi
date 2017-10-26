//
//  NavigationController.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/23.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "NavigationController.h"
#import "PushScaleAnimator.h"
#import "PopScaleAnimator.h"
#import "PushFadeAnimator.h"
#import "PopFadeAnimator.h"

@interface NavigationController ()<UINavigationControllerDelegate>

/**
 *  push scale 动画
 */
@property (nonatomic, strong) PushScaleAnimator *pushScaleAnimator;

/**
 *  pop scale 动画
 */
@property (nonatomic, strong) PopScaleAnimator *popScaleAnimator;

/**
 *  push fade 动画
 */
@property (nonatomic, strong) PushFadeAnimator *pushFadeAnimator;

/**
 *  pop fade 动画
 */
@property (nonatomic, strong) PopFadeAnimator *popFadeAnimator;

/**
 *  切换的动画
 */
@property (nonatomic, assign) CommonSwitchAnimation Animation;

/**
 *  百分比动画
 */
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionAnimation;

@end

@implementation NavigationController

-(id) initWithRootViewController:(UIViewController *)rootViewController {
    
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.delegate = self;
        
        //初始化push尺寸动画
        self.pushScaleAnimator = [PushScaleAnimator new];
        
        //初始化pop尺寸变化动画
        self.popScaleAnimator = [PopScaleAnimator new];
        
        //初始化push渐显动画
        self.pushFadeAnimator = [PushFadeAnimator new];
        
        //初始化pop渐隐动画
        self.popFadeAnimator = [PopFadeAnimator new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeSwitchAnimation:)
                                                     name:@"changeSwitchAnimation"
                                                   object:nil];
        
        //滑动返回手势
//        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                                                        action:@selector(pan:)];
//        [self.view addGestureRecognizer:panRecognizer];
        
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer*)recognizer
{
    UIView* view = self.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:view];
        if (location.x <  40 && self.viewControllers.count > 1) {
            self.interactionAnimation = [UIPercentDrivenInteractiveTransition new];
            [self popViewControllerAnimated:YES];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.interactionAnimation updateInteractiveTransition:d];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:view].x > 0) {
            [self.interactionAnimation finishInteractiveTransition];
        } else {
            [self.interactionAnimation cancelInteractiveTransition];
        }
        self.interactionAnimation = nil;
    }
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush && self.Animation == CommonSwitchAnimationBounce) {
        return self.pushScaleAnimator;
    }
    else if (operation == UINavigationControllerOperationPop && self.Animation == CommonSwitchAnimationBounce) {
        return self.popScaleAnimator;
    }
    else if (operation == UINavigationControllerOperationPush && self.Animation == CommonSwitchAnimationFade) {
        return self.pushFadeAnimator;
    }
    else if (operation == UINavigationControllerOperationPop && self.Animation == CommonSwitchAnimationFade) {
        return self.popFadeAnimator;
    }

    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController{
    return self.interactionAnimation;
}


- (void)changeSwitchAnimation:(NSNotification *)note {
    NSNumber *switchAnimate = (NSNumber *)[note object];
    self.Animation = [switchAnimate intValue];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
