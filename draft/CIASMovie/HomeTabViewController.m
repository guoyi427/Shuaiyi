//
//  HomeTabViewController.m
//  CIASMovie
//
//  Created by cias on 2016/12/6.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "HomeTabViewController.h"
#import "CPTabBarView.h"
#import "UIColor+Hex.h"
#import "UIImage+Color.h"
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"
#import "BSConstants.h"

@interface HomeTabViewController ()

@property (nonatomic, strong) CPTabBarView *tabbar;

@end

@implementation HomeTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    self.view.backgroundColor = [UIColor whiteColor];
//    [Constants.rootNav.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
//                                           forBarPosition:UIBarPositionAny
//                                               barMetrics:UIBarMetricsDefault];
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    NSInteger tabbarStyle = 0;
    
#if K_XINGYI
    tabbarStyle = 0;
#elif K_HENGDIAN
    tabbarStyle = 1;
#endif
    
    #if kIsXinchengTmpTabbarStyle
//        self.viewControllers = @[@"HomeViewController", @"TicketViewController", @"CIASMovie.CSMallViewController", @"UserViewController"];
    if (tabbarStyle==0) {
        self.viewControllers = @[@"HomeViewController", @"TicketViewController", @"CIASMovie.DiscoverViewController", @"UserViewController"];
    } else if (tabbarStyle==1) {
        self.viewControllers = @[@"HDHomeViewController", @"TicketViewController", @"HengDian.DiscoverViewController", @"UserViewController"];
    }
    
    #endif
    
    #if kIsSingleCinemaTabbarStyle
        self.viewControllers = @[@"BaoShan.MovieListViewController", @"XingYiPlanListViewController", @"UserViewController"];
    #endif
    
    #if kIsHuaChenTmpTabbarStyle
        self.viewControllers = @[@"HomeViewController", @"TicketViewController", @"UserViewController"];
    #endif
    
    if ([kIsXinchengTabbarStyle isEqualToString:@"1"]) {
        self.viewControllers = @[@"TicketViewController", @"MallViewController", @"HomeViewController", @"DiscoverViewController", @"UserViewController"];
    }
    if ([kIsCMSStandardTabbarStyle isEqualToString:@"1"]) {
        self.viewControllers = @[@"HomeViewController", @"TicketViewController", @"ZhongDuMovie.VipcardViewController", @"UserViewController"];
    }
    
    self.viewControllersMap = [NSMutableDictionary dictionaryWithCapacity:self.viewControllers.count];
    self.currentIndex = -1;
    
    #if kIsXinchengTmpTabbarStyle
        [self showVC:0];
    #endif
    
    #if kIsSingleCinemaTabbarStyle
        [self showVC:0];
    #endif
    
    #if kIsHuaChenTmpTabbarStyle
        [self showVC:0];
    #endif
    
    if ([kIsXinchengTabbarStyle isEqualToString:@"1"]) {
        [self showVC:2];
    }
    if ([kIsCMSStandardTabbarStyle isEqualToString:@"1"]) {
        [self showVC:0];
    }
    
    CPTabBarView *bottomView = [[CPTabBarView alloc]init];
    [self.view addSubview:bottomView];
    self.tabbar = bottomView;
    
    [bottomView didSelec:^(NSInteger index) {
        DLog(@"%@",@(index));
        [self showVC:index];
    }];
    
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@CPTAB_BAR_HEIGHT);
    }];
    
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.bottom.equalTo(bottomView.mas_top);
    }];

}

- (void)setSelectedTabAtIndex:(NSInteger)index{
    [self showVC:index];
    [self.tabbar selectAtIndex:index];
}

- (void) sithchTabHandler:(NSNotification *)not
{
    NSNumber *indexNum = [not.userInfo objectForKey:YN_POP_TO_ROOT_CONTROLLER_KEY];
    
    [self showVC:indexNum.integerValue];
    [self.tabbar selectAtIndex:indexNum.integerValue];
}



- (void) showVC:(NSInteger)index
{
    if (self.currentIndex == index) {
        return;
    }
    
//    if (index == 1) {
//        [self.tabbar selectAtIndex:self.currentIndex];
//        return;
//    }
    
    //remove previous VC
    
    UIViewController *preVC = [self viewControllerAt:self.currentIndex];
    if (preVC) {
        [preVC willMoveToParentViewController:nil];
        [preVC.view removeFromSuperview];
        [preVC removeFromParentViewController];
    }
    
    
    //add new vc to view
    
    UIViewController *newVC = [self viewControllerAt:index];
    [self addChildViewController:newVC];
    [self.contentView addSubview:newVC.view];
    [newVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [newVC didMoveToParentViewController:self];
    
    
    self.currentIndex = index;
    
}

- (UIViewController *) viewControllerAt:(NSInteger)index
{
    if (index > self.viewControllers.count && index < 0) {
        return nil;
    }
    NSString *vcName = self.viewControllers[index];
    
    UIViewController *vc = [self.viewControllersMap objectForKey:vcName];
    if (!vc) {
        vc = [[NSClassFromString(vcName) alloc] init];
        if (vc != nil) {
            [self.viewControllersMap setObject:vc forKey:vcName];
        }
    }
    
    return vc;
}




@end
