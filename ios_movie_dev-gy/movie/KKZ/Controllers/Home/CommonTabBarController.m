//
//  首页
//
//  Created by 艾广华 on 16/1/23.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonTabBarController.h"
#import "TabbarItem.h"

@interface CommonTabBarController () <TabbarItemDelegate> {

    //TabBar对象
    UIImageView *tabbar;

    //红色未读视图
    UIImageView *messageImage;
}

/**
 *  已经初始化过类的字典
 */
@property (nonatomic, strong) NSMutableDictionary *viewControllers;

/**
 *  按钮的集合数组
 */
@property (nonatomic, strong) NSMutableArray *itemArrays;

/**
 *  当前选择的页数
 */
@property (nonatomic, assign) int selectedPage;

/**
 *  当前视图的尺寸
 */
@property (nonatomic, assign) CGRect currentFrame;

@end

@implementation CommonTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置默认选择页数
    _selectedPage = 0;

    //默认选择第一个
    [self loadDefaultView];

    //加载底部导航栏
    [self loadBottomBarView];
}

- (void)loadBottomBarView {

    //TabBar图片对象
    tabbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, kCommonScreenHeight - [self tabbarHeight], kCommonScreenWidth, [self tabbarHeight])];
    tabbar.userInteractionEnabled = YES;
    //    tabbar.backgroundColor = [UIColor clearColor];
    tabbar.backgroundColor = [UIColor r:245 g:245 b:245];
    tabbar.alpha = 0.95;
    //    [self addEffe];
    [self.view addSubview:tabbar];

    //TabBar上面的按钮
    NSArray *titleArr = @[ @"电影", @"影院", @"订单", @"我的" ];
    NSArray *normalImgArr = @[ @"tab_home", @"tab_cinema", @"tab_order", @"tab_account" ];
    NSArray *selectImgArr = @[ @"tab_homeH", @"tab_cinemaH", @"tab_orderH", @"tab_accountH" ];
    CGFloat itemWidth = 64;
    CGFloat diff = (kCommonScreenWidth - itemWidth * titleArr.count) / (titleArr.count+1);
    CGFloat originX = diff;
    for (int i = 0; i < titleArr.count; i++) {

        //循环初始化按钮
        TabbarItem *item = [[TabbarItem alloc] initWithFrame:CGRectMake(originX, 2, itemWidth, 42)
                                                       title:titleArr[i]
                                                 normalImage:normalImgArr[i]
                                           hightlightedImage:selectImgArr[i]
                                                 normalColor:[UIColor r:123 g:123 b:123]
                                           hightlightedColor:[UIColor r:36 g:148 b:254]
                                                       index:i];
        item.delegate = self;
        [tabbar addSubview:item];
        [self.itemArrays addObject:item];

        //如果是最后一个按钮加提示标记
        if (i == 3) {
            // 红色未读消息提示
            messageImage = [[UIImageView alloc] initWithFrame:CGRectMake(43, 2, 7, 7)];
            [messageImage setBackgroundColor:[UIColor redColor]];
            messageImage.layer.masksToBounds = YES;
            messageImage.layer.cornerRadius = 3.5;
            messageImage.hidden = YES;
            [item addSubview:messageImage];
        }
        originX += diff + itemWidth;
    }

    //TabBar的顶部分割线
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 1)];
    divider.backgroundColor = [UIColor whiteColor];
    [tabbar addSubview:divider];

    TabbarItem *currentItem = self.itemArrays[_selectedPage];
    currentItem.activated = YES;
}

- (void)loadDefaultView {
    UIViewController *currentController = [self itemAtIndex:_selectedPage];
    currentController.view.frame = self.currentFrame;
    [self.view addSubview:currentController.view];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (UIViewController *)itemAtIndex:(NSInteger)index {

    //选择数组里的控制器
    NSString *className = [self _configuredChildViewControllers][index];
    UIViewController *controller = self.viewControllers[className];
    if (!controller) {

        //初始化控制器
        controller = [[NSClassFromString(className) alloc] init];
        controller.view.frame = self.currentFrame;
        [self addChildViewController:controller];
        [self.viewControllers setValue:controller
                                forKey:className];
    }
    return controller;
}

- (void)tabbarItem:(TabbarItem *)item
    touchedAtIndex:(int)idx {
    //选择页数
    if (tabbar.userInteractionEnabled) {
        [self setSelectedPage:idx];
    }
}

- (void)setSelectedPage:(int)value {
    appDelegate.selectedTab = value;

    //统计事件：首页切换底部标签
    NSArray *tabsName = @[ @"首页", @"电影", @"订单", @"我的" ];
    NSString *tabName = tabsName[value];
    NSDictionary *attrs = @{
        @"tabIndex" : [NSString stringWithFormat:@"%d", value],
        @"tabName" : tabName
    };
    StatisEventWithAttributes(EVENT_HOMEPAGE_SWITCH_TAB, attrs);

    //切换当前选择视图
    [[NSNotificationCenter defaultCenter] postNotificationName:@"currentPageController"
                                                        object:[NSNumber numberWithInt:value]];

    if (value != _selectedPage) {

        //当前显示的视图
        UIViewController *selectSubViewController = [self itemAtIndex:_selectedPage];
        selectSubViewController.view.userInteractionEnabled = NO;

        //即将显示的视图
        UIViewController *newCtr = [self itemAtIndex:value];
        newCtr.view.userInteractionEnabled = NO;
        tabbar.userInteractionEnabled = NO;

        if (newCtr) {
            //添加当前视图到页面上
            [self.view insertSubview:newCtr.view
                        belowSubview:tabbar];

            TabbarItem *preItem = self.itemArrays[_selectedPage];
            preItem.activated = NO;
            //当前默认选择的页数
            _selectedPage = value;
            //按钮的状态改变
            TabbarItem *current = self.itemArrays[_selectedPage];
            current.activated = YES;
            
            //恢复点击事件
            selectSubViewController.view.userInteractionEnabled = TRUE;
            [selectSubViewController.view removeFromSuperview];
            newCtr.view.userInteractionEnabled = TRUE;
            tabbar.userInteractionEnabled = YES;
        }
    }
}

- (NSMutableDictionary *)viewControllers {

    if (!_viewControllers) {
        _viewControllers = [[NSMutableDictionary alloc] init];
    }
    return _viewControllers;
}

- (NSMutableArray *)itemArrays {

    if (!_itemArrays) {
        _itemArrays = [[NSMutableArray alloc] init];
    }
    return _itemArrays;
}

- (CGRect)currentFrame {
    _currentFrame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
    return _currentFrame;
}

- (NSArray *)_configuredChildViewControllers {

    //初始化类的数组
    NSArray *configurations = @[
        @"MoviesNewViewController",
        @"MovieAndCinemaViewController",
        @"OrderListViewController",
        @"UserCenterViewController"
    ];
    return configurations;
}

- (float)tabbarHeight {
    return 49;
}

- (void)addEffe {
    // 定义毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    effe = [[UIVisualEffectView alloc] initWithEffect:blur];
    effe.frame = CGRectMake(0, 0, screentWith, screentHeight);
    [tabbar addSubview:effe];
}

#pragma mark - Override from CommonViewController
- (BOOL)showNavBar {
    return NO;
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return NO;
}

@end
