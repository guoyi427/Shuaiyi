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
#import "UIColor+Hex.h"
#import "UIImage+Color.h"
#import "SFTrainsitionAnimate.h"

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

@property (nonatomic, strong) SFTrainsitionAnimate *pushAnimatorOfSF;
@property (nonatomic, strong) SFTrainsitionAnimate *popAnimatorOfSF;


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
        
        self.pushAnimatorOfSF = [[SFTrainsitionAnimate alloc] init];
        self.popAnimatorOfSF = [[SFTrainsitionAnimate alloc] initWithAnimateType:animate_pop andDuration:1.5];
        
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

- (void)viewDidLoad{
//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
//    UINavigationBar set
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor]]
                forBarPosition:UIBarPositionAny
                    barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
#if K_HENGDIAN
    //  红色底线
    UIImage *redLineImage = [UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor]];
    [navBar setShadowImage:redLineImage];
#endif

    navBar.translucent = NO;
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarTitleColor]}];
    

    __weak NavigationController *weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        self.delegate =  weakSelf;
    }
    id target = self.interactivePopGestureRecognizer.delegate;
    _screenEdgePanGesture  = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    _screenEdgePanGesture.edges = UIRectEdgeLeft;
    _screenEdgePanGesture.delegate = self;
    self.delegate = self;
    [self.view addGestureRecognizer:_screenEdgePanGesture];
    
}

- (void)cancelViewController{
    
}

- (void)handleNavigationTransition:(UIScreenEdgePanGestureRecognizer *)gestures{
    
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


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    if (self.childViewControllers.count == 3) {
//    
//    }
    if (self.childViewControllers.count == 1) {
        return NO;
    }
    return YES;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)]&&animated == YES ){
        self.interactivePopGestureRecognizer.enabled = NO;
        self.screenEdgePanGesture.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)]&& animated == YES ){
        self.interactivePopGestureRecognizer.enabled = NO;
        self.screenEdgePanGesture.enabled = NO;
    }
    return [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] ){
        self.interactivePopGestureRecognizer.enabled = NO;
        self.screenEdgePanGesture.enabled = NO;
    }
    return [super popToViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.interactivePopGestureRecognizer.enabled = YES;
        self.screenEdgePanGesture.enabled = YES;
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
     else if (operation == UINavigationControllerOperationPush && [toVC isKindOfClass:NSClassFromString(@"MovieDetailViewController")]) {
         if (Constants.isHidAnimation) {
             Constants.isHidAnimation = NO;
             return self.pushFadeAnimator;
         } else {
             return self.pushAnimatorOfSF;
         }
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
    else if (operation == UINavigationControllerOperationPop&& [fromVC isKindOfClass:NSClassFromString(@"MovieDetailViewController")]) {
        if (Constants.isHidAnimation) {
            Constants.isHidAnimation = NO;
            return self.popFadeAnimator;
        } else {
            return self.popAnimatorOfSF;
        }
        
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
