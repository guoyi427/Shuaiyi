//
//  NavigationControl.m
//  KoMovie
//
//  Created by alfaromeo on 12-6-18.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "KKZUtility.h"
#import "NavigationControl.h"
//#import "TabbarController.h"
#import "UserDefault.h"

#define kBounceAnimationDuration .3
#define kFlipAnimationDuration .3
#define kSwipeAnimationDuration .3

@implementation NavigationControl

@synthesize holder;

- (void)dealloc {
  self.holder = nil;

  [viewControllerStack removeAllObjects];
  [viewControllerStack release];
  [mask release];

  [super dealloc];
}

- (id)initWithHolder:(UIWindow *)viewHolder {
  self = [super init];
  if (self) {
    self.holder = viewHolder;
    viewControllerStack = [[NSMutableArray alloc] init];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
      kOriginFrame = CGRectMake(0, 0, screentWith, screentHeight);
    } else {
      kOriginFrame = CGRectMake(0, 20, screentWith, screentContentHeight);
    }
    mask = [[UIView alloc] initWithFrame:kOriginFrame];
    mask.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    mask.hidden = YES;
  }
  return self;
}

- (void)setMaskShow:(bool)show {
  mask.hidden = !show;
}

- (int)numberOfControllers {
  return (int)[viewControllerStack count];
}

- (void)setViewControllerHidden:(BOOL)hide atIndex:(int)idx {
  id viewCtr = nil;
  if ([viewControllerStack count] >= idx) {
    viewCtr = [viewControllerStack objectAtIndex:idx];
  }

  UIView *theView = nil;
  //    if ([viewCtr isKindOfClass:[TabbarController class]]) {
  //        TabbarController *controller = (TabbarController *) viewCtr;
  //        theView = controller.contentView;
  //    } else

  if ([viewCtr isKindOfClass:[UIViewController class]]) {
    UIViewController *controller = (UIViewController *)viewCtr;
    theView = controller.view;
  }
  theView.hidden = hide;
}

- (UIView *)viewForController:(id)ctr {
  //    if ([ctr isKindOfClass:[TabbarController class]]) {
  //        TabbarController *controller = (TabbarController *) ctr;
  //        return controller.contentView;
  //    } else
  if ([ctr isKindOfClass:[UIViewController class]]) {
    UIViewController *controller = (UIViewController *)ctr;
    return controller.view;
  } else {
    return nil;
  }
}

- (void)didShowViewController:(id)newCtr andHideController:(id)currentCtr {
  if (currentCtr && [currentCtr isKindOfClass:[UIViewController class]] &&
      [currentCtr respondsToSelector:@selector(viewDidDisappear:)]) {
    [currentCtr viewDidDisappear:NO];
  }
  if (newCtr && [newCtr isKindOfClass:[UIViewController class]] &&
      [newCtr respondsToSelector:@selector(viewDidAppear:)]) {
    [newCtr viewDidAppear:NO];
  }

  id topViewController = [viewControllerStack lastObject];
  [holder insertSubview:mask
           belowSubview:[self viewForController:topViewController]];
}

- (void)willShowViewController:(id)newCtr andHideController:(id)currentCtr {
  if (currentCtr && [currentCtr isKindOfClass:[UIViewController class]] &&
      [currentCtr respondsToSelector:@selector(viewWillDisappear:)]) {
    [currentCtr viewWillDisappear:NO];
  }
  if (newCtr && [newCtr isKindOfClass:[UIViewController class]] &&
      [newCtr respondsToSelector:@selector(viewWillAppear:)]) {
    [newCtr viewWillAppear:NO];
  }
}

- (void)pushViewController:(id)ctr
                 animation:(ViewSwitchAnimation)animation
                  finished:(void (^)())fBlock {
  if (!ctr || stackLock)
    return;

  stackLock = YES;
  id topViewController = [viewControllerStack lastObject];
  NSDate *updateTime = CONTROLLER_INIT_TIME;
  NSString *currentCtrName = NSStringFromClass([ctr class]);
  NSString *topCtrName = NSStringFromClass([topViewController class]);

  if ([updateTime timeIntervalSinceNow] > -1 &&
      [currentCtrName isEqualToString:topCtrName]) {
    stackLock = NO;
    return;
  }

  CONTROLLER_INIT_TIME_WRITE([NSDate date]);

  UIView *newTopView = [self viewForController:ctr];
  UIView *currentTopView = [self viewForController:topViewController];

  if ([ctr isKindOfClass:[CommonViewController class]]) {
    ((CommonViewController *)ctr).appearAnimation = animation;
  }

  [self willShowViewController:nil andHideController:topViewController];

  [holder addSubview:newTopView];
  [viewControllerStack addObject:ctr];

  if (animation == ViewSwitchAnimationBounce) {

    newTopView.transform =
        CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);

    if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
      [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }

    [UIView animateWithDuration:kBounceAnimationDuration
        animations:^{

          newTopView.transform =
              CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
          newTopView.frame = kOriginFrame;
        }
        completion:^(BOOL finished) {

          newTopView.transform = CGAffineTransformIdentity;
          currentTopView.frame = kOriginFrame;
          stackLock = NO;
          [self didShowViewController:nil andHideController:topViewController];
          if (fBlock) {
            fBlock();
          }
          [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
  } else if (animation == ViewSwitchAnimationFlipL ||
             animation == ViewSwitchAnimationFlipR) {

    [UIView
        transitionFromView:currentTopView
                    toView:newTopView
                  duration:kFlipAnimationDuration
                   options:(animation == ViewSwitchAnimationFlipL
                                ? UIViewAnimationOptionTransitionFlipFromLeft
                                : UIViewAnimationOptionTransitionFlipFromRight)
                completion:^(BOOL finished) {

                  currentTopView.frame = kOriginFrame;
                  stackLock = NO;
                  [self didShowViewController:nil
                            andHideController:topViewController];
                  fBlock();
                }];

  } else if (animation == ViewSwitchAnimationSwipeD2U ||
             animation == ViewSwitchAnimationSwipeU2D ||
             animation == ViewSwitchAnimationSwipeL2R ||
             animation == ViewSwitchAnimationSwipeR2L) {

    CGRect originFrame = kOriginFrame;
    CGRect newFrame = kOriginFrame;
    if (animation == ViewSwitchAnimationSwipeD2U) {
      originFrame.origin.y = screentHeight;
      newFrame.origin.y = -screentHeight;
    } else if (animation == ViewSwitchAnimationSwipeU2D) {
      originFrame.origin.y = -screentHeight;
      newFrame.origin.y = screentHeight;
    } else if (animation == ViewSwitchAnimationSwipeL2R) {
      originFrame.origin.x = -screentWith;
      newFrame.origin.x = screentWith;
    } else if (animation == ViewSwitchAnimationSwipeR2L) {
      originFrame.origin.x = screentWith;
      newFrame.origin.x = -screentWith;
    }
    newTopView.frame = originFrame;

    [UIView animateWithDuration:kSwipeAnimationDuration
        animations:^{
          newTopView.frame = kOriginFrame;
          currentTopView.frame = newFrame;
        }
        completion:^(BOOL finished) {

          currentTopView.frame = kOriginFrame;
          stackLock = NO;
          [self didShowViewController:nil andHideController:topViewController];
          fBlock();
        }];
  } else if (animation == ViewSwitchAnimationWP7Flip) {

    [newTopView removeFromSuperview];

    [UIView animateWithDuration:.2
        animations:^{

          CATransform3D t = CATransform3DIdentity;
          t = CATransform3DTranslate(t, -140, 0, 0.0);
          t.m34 = 1.0 / -4000;
          t = CATransform3DRotate(t, -80.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
          t = CATransform3DTranslate(t, 180, 0, 0.0);
          currentTopView.layer.transform = t;
        }
        completion:^(BOOL finished) {

          CATransform3D t = CATransform3DIdentity;
          t = CATransform3DTranslate(t, -140, 0, 0.0);
          t.m34 = 1.0 / -4000;
          t = CATransform3DRotate(t, 30.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
          t = CATransform3DTranslate(t, 180, 0, 0.0);
          newTopView.layer.transform = t;
          [holder addSubview:newTopView];

          [UIView animateWithDuration:.1
              animations:^{

                newTopView.layer.transform =
                    CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 0);
              }
              completion:^(BOOL finished) {

                currentTopView.layer.transform =
                    CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 0);
                stackLock = NO;
                [self didShowViewController:nil
                          andHideController:topViewController];
                fBlock();
              }];
        }];
  } else {
    newTopView.frame = kOriginFrame;
    stackLock = NO;
    [self didShowViewController:nil andHideController:topViewController];
    fBlock();
  }
}

- (void)pushViewController:(id)ctr animation:(ViewSwitchAnimation)animation {
  [self pushViewController:ctr animation:animation finished:nil];
}

- (void)switchToViewController:(id)ctr
                     animation:(ViewSwitchAnimation)animation {
  [self pushViewController:ctr
                 animation:animation
                  finished:^{

                    if ([viewControllerStack count] > 1) {
                      id ctrToRemove = [viewControllerStack
                          objectAtIndex:[viewControllerStack count] - 2];

                      [ctr setValue:[ctrToRemove
                                        valueForKeyPath:@"appearAnimation"]
                          forKeyPath:@"appearAnimation"];

                      if (ctrToRemove) {
                        UIView *viewToRemove =
                            [self viewForController:ctrToRemove];
                        [viewToRemove removeFromSuperview];
                        [viewControllerStack removeObject:ctrToRemove];
                      }
                    }
                  }];
}

- (void)popViewControllerWithAnimation:(ViewSwitchAnimation)animation {
  if (stackLock)
    return;

  id topViewController = [viewControllerStack lastObject];
  id activeViewController = nil;
  if ([viewControllerStack count] >= 2) {
    activeViewController =
        [viewControllerStack objectAtIndex:[viewControllerStack count] - 2];
  } else {
    activeViewController = [KKZUtility getCurrentScreenController];
  }

  if (!topViewController) {
    stackLock = NO;
    return;
  }
  stackLock = YES;
  [self willShowViewController:activeViewController andHideController:nil];

  UIView *newTopView = [self viewForController:activeViewController];
  UIView *currentTopView = [self viewForController:topViewController];

  if (animation == ViewSwitchAnimationBounce) {
    if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
      [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }

    [UIView animateWithDuration:kBounceAnimationDuration
        animations:^{

          currentTopView.transform =
              CGAffineTransformScale(CGAffineTransformIdentity, .2, .2);
          currentTopView.alpha = .0;
        }
        completion:^(BOOL finished) {

          [currentTopView removeFromSuperview];
          currentTopView.alpha = 1;
          [viewControllerStack removeLastObject];
          stackLock = NO;
          [self didShowViewController:activeViewController
                    andHideController:nil];
          [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];

  } else if (animation == ViewSwitchAnimationSwipeD2U ||
             animation == ViewSwitchAnimationSwipeU2D ||
             animation == ViewSwitchAnimationSwipeL2R ||
             animation == ViewSwitchAnimationSwipeR2L) {

    CGRect originFrame = kOriginFrame;
    CGRect newFrame = kOriginFrame;
    if (animation == ViewSwitchAnimationSwipeD2U) {
      originFrame.origin.y = screentHeight;
      newFrame.origin.y = -screentHeight;
    } else if (animation == ViewSwitchAnimationSwipeU2D) {
      originFrame.origin.y = -screentHeight;
      newFrame.origin.y = screentHeight;
    } else if (animation == ViewSwitchAnimationSwipeL2R) {
      originFrame.origin.x = -screentWith;
      newFrame.origin.x = screentWith;
    } else if (animation == ViewSwitchAnimationSwipeR2L) {
      originFrame.origin.y = screentWith;
      newFrame.origin.y = -screentWith;
    }
    newTopView.frame = originFrame;

    [UIView animateWithDuration:kSwipeAnimationDuration
        animations:^{

          newTopView.frame = kOriginFrame;
          currentTopView.frame = newFrame;
        }
        completion:^(BOOL finished) {

          [currentTopView removeFromSuperview];
          [viewControllerStack removeLastObject];
          stackLock = NO;
          [self didShowViewController:activeViewController
                    andHideController:nil];
        }];

  } else if (animation == ViewSwitchAnimationFlipL ||
             animation == ViewSwitchAnimationFlipR) {

    [UIView
        transitionFromView:currentTopView
                    toView:newTopView
                  duration:kFlipAnimationDuration
                   options:(animation == ViewSwitchAnimationFlipL
                                ? UIViewAnimationOptionTransitionFlipFromLeft
                                : UIViewAnimationOptionTransitionFlipFromRight)
                completion:^(BOOL finished) {

                  [currentTopView removeFromSuperview];
                  [viewControllerStack removeLastObject];
                  stackLock = NO;
                  [self didShowViewController:activeViewController
                            andHideController:nil];
                }];

  } else if (animation == ViewSwitchAnimationWP7Flip) {

    [UIView animateWithDuration:.2
        animations:^{
          CATransform3D t = CATransform3DIdentity;
          t = CATransform3DTranslate(t, -140, 0, 0.0);
          t.m34 = 1.0 / -4000;
          t = CATransform3DRotate(t, 80.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
          t = CATransform3DTranslate(t, 180, 0, 0.0);

          currentTopView.layer.transform = t;
        }
        completion:^(BOOL finished) {
          [currentTopView removeFromSuperview];

          CATransform3D t = CATransform3DIdentity;
          t = CATransform3DTranslate(t, -140, 0, 0.0);
          t.m34 = 1.0 / -4000;
          t = CATransform3DRotate(t, -40.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
          t = CATransform3DTranslate(t, 180, 0, 0.0);

          newTopView.layer.transform = t;

          [UIView animateWithDuration:.2
              animations:^{

                newTopView.layer.transform =
                    CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 0);
              }
              completion:^(BOOL finished) {
                [viewControllerStack removeLastObject];
                stackLock = NO;
                [self didShowViewController:activeViewController
                          andHideController:nil];

              }];

        }];

  } else {
    [currentTopView removeFromSuperview];
    [viewControllerStack removeLastObject];
    stackLock = NO;
    [self didShowViewController:activeViewController andHideController:nil];
  }
}

- (void)popViewControllerAnimated:(BOOL)animated {

  id topViewController = [viewControllerStack lastObject];
  if (!topViewController) {
    return;
  }

  ViewSwitchAnimation animation = ViewSwitchAnimationNone;

  if (animated) {
    if ([topViewController isKindOfClass:[UINavigationController class]]) {
      animation = ViewSwitchAnimationBounce;
    } else if ([topViewController isKindOfClass:[CommonViewController class]]) {
      animation = ((CommonViewController *)topViewController).appearAnimation;
    }

    switch (animation) {
    case ViewSwitchAnimationSwipeL2R: {
      animation = ViewSwitchAnimationSwipeR2L;
      break;
    }
    case ViewSwitchAnimationSwipeR2L: {
      animation = ViewSwitchAnimationSwipeL2R;
      break;
    }
    case ViewSwitchAnimationSwipeD2U: {
      animation = ViewSwitchAnimationSwipeU2D;
      break;
    }
    case ViewSwitchAnimationSwipeU2D: {
      animation = ViewSwitchAnimationSwipeD2U;
      break;
    }
    default:
      break;
    }
  }

  [self popViewControllerWithAnimation:animation];
}

- (void)pushViewController:(id)ctr
                 animation:(ViewSwitchAnimation)animation
                  onlyOnce:(BOOL)one {
  if (stackLock) {
    return;
  }

  if (!ctr || stackLock) {
    return;
  }

  stackLock = YES;
  NSMutableArray *toRemove = [[NSMutableArray alloc] init];

  id activeViewController = nil;
  if ([viewControllerStack count] > 0) {
    activeViewController = [viewControllerStack objectAtIndex:0];
  }
  for (id viewController in viewControllerStack) {
    if (viewController != activeViewController) {
      UIView *ctrView = nil;
      if ([viewController isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = (UIViewController *)viewController;
        ctrView = controller.view;
      }
      [toRemove addObject:viewController];
      [ctrView removeFromSuperview];
    }
  }

  [viewControllerStack removeObjectsInArray:toRemove];
  [toRemove removeAllObjects];
  [toRemove release];

  id topViewController = [viewControllerStack lastObject];

  if (ctr == topViewController) {
    return;
  }

  UIView *newTopView = [self viewForController:ctr];
  UIView *currentTopView = [self viewForController:topViewController];

  [self willShowViewController:nil andHideController:topViewController];

  [holder addSubview:newTopView];
  [viewControllerStack addObject:ctr];

  if (animation == ViewSwitchAnimationBounce) {
    newTopView.transform =
        CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);

    [UIView animateWithDuration:kBounceAnimationDuration
        animations:^{

          newTopView.transform =
              CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
          newTopView.frame = kOriginFrame;
        }
        completion:^(BOOL finished) {

          newTopView.transform = CGAffineTransformIdentity;
          currentTopView.frame = kOriginFrame;
          stackLock = NO;
          [self didShowViewController:nil andHideController:topViewController];
        }];

  } else if (animation == ViewSwitchAnimationFlipL ||
             animation == ViewSwitchAnimationFlipR) {

    [UIView
        transitionFromView:currentTopView
                    toView:newTopView
                  duration:kFlipAnimationDuration
                   options:(animation == ViewSwitchAnimationFlipL
                                ? UIViewAnimationOptionTransitionFlipFromLeft
                                : UIViewAnimationOptionTransitionFlipFromRight)
                completion:^(BOOL finished) {

                  currentTopView.frame = kOriginFrame;
                  stackLock = NO;
                  [self didShowViewController:nil
                            andHideController:topViewController];
                }];

  } else if (animation == ViewSwitchAnimationSwipeD2U ||
             animation == ViewSwitchAnimationSwipeU2D ||
             animation == ViewSwitchAnimationSwipeL2R ||
             animation == ViewSwitchAnimationSwipeR2L) {

    CGRect originFrame = kOriginFrame;
    CGRect newFrame = kOriginFrame;
    if (animation == ViewSwitchAnimationSwipeD2U) {
      originFrame.origin.y = screentHeight;
      newFrame.origin.y = -screentHeight;
    } else if (animation == ViewSwitchAnimationSwipeU2D) {
      originFrame.origin.y = -screentHeight;
      newFrame.origin.y = screentHeight;
    } else if (animation == ViewSwitchAnimationSwipeL2R) {
      originFrame.origin.x = -screentWith;
      newFrame.origin.x = screentWith;
    } else if (animation == ViewSwitchAnimationSwipeR2L) {
      originFrame.origin.x = screentWith;
      newFrame.origin.x = -screentWith;
    }
    newTopView.frame = originFrame;

    [UIView animateWithDuration:kSwipeAnimationDuration
        animations:^{

          newTopView.frame = kOriginFrame;
          currentTopView.frame = newFrame;
        }
        completion:^(BOOL finished) {

          currentTopView.frame = kOriginFrame;
          stackLock = NO;
          [self didShowViewController:nil andHideController:topViewController];
        }];

  } else if (animation == ViewSwitchAnimationWP7Flip) {
    [newTopView removeFromSuperview];

    [UIView animateWithDuration:.2
        animations:^{

          CATransform3D t = CATransform3DIdentity;
          t = CATransform3DTranslate(t, -140, 0, 0.0);
          t.m34 = 1.0 / -4000;
          t = CATransform3DRotate(t, -80.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
          t = CATransform3DTranslate(t, 180, 0, 0.0);
          currentTopView.layer.transform = t;
        }
        completion:^(BOOL finished) {

          CATransform3D t = CATransform3DIdentity;
          t = CATransform3DTranslate(t, -140, 0, 0.0);
          t.m34 = 1.0 / -4000;
          t = CATransform3DRotate(t, 30.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
          t = CATransform3DTranslate(t, 180, 0, 0.0);
          newTopView.layer.transform = t;
          [holder addSubview:newTopView];

          [UIView animateWithDuration:.1
              animations:^{

                newTopView.layer.transform =
                    CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 0);
              }
              completion:^(BOOL finished) {

                currentTopView.layer.transform =
                    CATransform3DRotate(CATransform3DIdentity, 0, 0, 0, 0);
                stackLock = NO;
                [self didShowViewController:nil
                          andHideController:topViewController];
              }];
        }];
  } else {
    newTopView.frame = kOriginFrame;
    stackLock = NO;
    [self didShowViewController:nil andHideController:topViewController];
  }
}

- (void)popToRootViewControllerWithAnimation:(ViewSwitchAnimation)animation {
  if (stackLock) {
    return;
  }

  id topViewController = [viewControllerStack lastObject];
  id activeViewController = nil;
  if ([viewControllerStack count] > 0) {
    activeViewController = [viewControllerStack objectAtIndex:0];
  }

  if (!topViewController)
    return;

  NSMutableArray *toRemove = [[NSMutableArray alloc] init];

  for (id viewController in viewControllerStack) {
    if (viewController != topViewController &&
        viewController != activeViewController) {
      UIView *ctrView = nil;
      if ([viewController isKindOfClass:[UIViewController class]]) {
        UIViewController *controller = (UIViewController *)viewController;
        ctrView = controller.view;
      }
      [toRemove addObject:viewController];
      [ctrView removeFromSuperview];
    }
  }

  [viewControllerStack removeObjectsInArray:toRemove];
  [toRemove removeAllObjects];
  [toRemove release];

  stackLock = YES;

  [self willShowViewController:activeViewController
             andHideController:topViewController];

  UIView *newTopView = [self viewForController:activeViewController];
  UIView *currentTopView = [self viewForController:topViewController];

  if (animation == ViewSwitchAnimationBounce) {
    [UIView animateWithDuration:kBounceAnimationDuration
        animations:^{

          currentTopView.transform =
              CGAffineTransformScale(CGAffineTransformIdentity, .2, .2);
          currentTopView.alpha = .1;
        }
        completion:^(BOOL finished) {

          [currentTopView removeFromSuperview];
          currentTopView.alpha = 1;
          [viewControllerStack removeLastObject];
          stackLock = NO;
          [self didShowViewController:activeViewController
                    andHideController:topViewController];
        }];
  } else if (animation == ViewSwitchAnimationSwipeD2U ||
             animation == ViewSwitchAnimationSwipeU2D ||
             animation == ViewSwitchAnimationSwipeL2R ||
             animation == ViewSwitchAnimationSwipeR2L) {

    CGRect originFrame = kOriginFrame;
    CGRect newFrame = kOriginFrame;
    if (animation == ViewSwitchAnimationSwipeD2U) {
      originFrame.origin.y = screentHeight;
      newFrame.origin.y = -screentHeight;
    } else if (animation == ViewSwitchAnimationSwipeU2D) {
      originFrame.origin.y = -screentHeight;
      newFrame.origin.y = screentHeight;
    } else if (animation == ViewSwitchAnimationSwipeL2R) {
      originFrame.origin.x = -screentWith;
      newFrame.origin.x = screentWith;
    } else if (animation == ViewSwitchAnimationSwipeR2L) {
      originFrame.origin.y = screentWith;
      newFrame.origin.y = -screentWith;
    }
    newTopView.frame = originFrame;

    [UIView animateWithDuration:kSwipeAnimationDuration
        animations:^{

          newTopView.frame = kOriginFrame;
          currentTopView.frame = newFrame;
        }
        completion:^(BOOL finished) {

          [currentTopView removeFromSuperview];
          [viewControllerStack removeLastObject];
          stackLock = NO;
          [self didShowViewController:activeViewController
                    andHideController:nil];
        }];
  } else {
    [currentTopView removeFromSuperview];
    [viewControllerStack removeLastObject];
    stackLock = NO;
    [self didShowViewController:activeViewController andHideController:nil];
  }
}

@end
