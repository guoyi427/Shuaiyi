//
//  PopScaleAnimator.m
//  KoMovie
//
//  Created by wuzhen on 16/11/9.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "PopScaleAnimator.h"

@implementation PopScaleAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3f;
}

/**
 *  动画的内容
 *
 *  @param transitionContext 通过transitionContext这个上下文环境可以获取源视图控制器，目标视图控制器
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toViewController = [transitionContext viewControllerForKey:
                                          UITransitionContextToViewControllerKey];
    UIViewController *fromController = [transitionContext viewControllerForKey:
                                        UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    [[transitionContext containerView] sendSubviewToBack:toViewController.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromController.view.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        fromController.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        fromController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end
