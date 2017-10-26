//
//  PopAnimator.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/23.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "PopAnimator.h"

@implementation PopAnimator

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
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
        fromController.view.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        fromController.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        fromController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

@end
