//
//  PopFadeAnimator.m
//  KoMovie
//
//  Created by wuzhen on 16/11/9.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "PopFadeAnimator.h"

@implementation PopFadeAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

/**
 *  动画的内容
 *
 *  @param transitionContext 通过transitionContext这个上下文环境可以获取源视图控制器，目标视图控制器
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIViewController *toViewController = [transitionContext viewControllerForKey:
                                          UITransitionContextToViewControllerKey];
    UIViewController *fromController = [transitionContext viewControllerForKey:
                                        UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    [[transitionContext containerView] sendSubviewToBack:toViewController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        toViewController.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        toViewController.view.alpha = 1.0f;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end
