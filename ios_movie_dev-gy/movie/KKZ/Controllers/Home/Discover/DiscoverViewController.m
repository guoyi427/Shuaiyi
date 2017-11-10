//
//  首页 - 发现
//
//  Created by KKZ on 15/8/6.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ActivityWebViewController.h"
#import "CacheEngine.h"
#import "ClubNavTab.h"
#import "ClubTask.h"
#import "ClubViewController.h"
#import "Constants.h"
#import "DataEngine.h"
#import "DiscoverTabs.h"
#import "DiscoverViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "ImageEngine.h"
#import "KotaListViewController.h"
#import "NotificationEngine.h"
#import "TaskQueue.h"
#import "UIConstants.h"

//WebView网页缓存
#import "RNCachingURLProtocol.h"
#import <objc/runtime.h>

@interface DiscoverViewController () {

    //即将要现实的视图索引
    NSInteger willShowPageIndex;

    //类的名称
    NSString *className;
}

/**
 *  是否已经请求网络的数据
 */
@property (nonatomic, assign) BOOL isRequestNet;

/**
 *  网页控制器
 */
@property (nonatomic, strong) ActivityWebViewController *webVC;

@end

@implementation DiscoverViewController

@synthesize webTitle = _webTitle;

- (void)dealloc {
    //移除对象
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialize methods
- (id)init {
    self = [super init];
    if (self) {

        //初始化类的名称
        className = [NSString stringWithCString:class_getName([self class])
                                       encoding:NSUTF8StringEncoding];

        //增加当前选择视图的索引
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(currentSelectController:)
                                                     name:@"currentPageController"
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(clearWebCacheFlag)
                                                     name:className
                                                   object:nil];
    }
    return self;
}

#pragma mark - UIViewController lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置视图加载的时候的缓存
    //    [self setViewWillLoaded];
    viewPositionY = 20.0f;

//    [self.statusView setBackgroundColor:appDelegate.kkzBlue];
//    [self.navBarView setBackgroundColor:appDelegate.kkzBlue];

    clubViewsMutableDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    clubCtrsMutableDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    //设置视图的背景颜色
    self.view.backgroundColor = [UIColor whiteColor];

    //切换按钮视图
    horizonTableView = [[KKZHorizonTableView alloc] initWithFrame:CGRectMake(15, 4, screentWith - 15 * 2, 36)];
    horizonTableView.itemSpacing = 27.0f;
    horizonTableView.labelColor = [UIColor r:200 g:230 b:255];
    horizonTableView.labelFont = [UIFont boldSystemFontOfSize:16.0f];
    horizonTableView.bigLabelFont = [UIFont boldSystemFontOfSize:18.0f];
    horizonTableView.clickLabelColor = [UIColor whiteColor];
    horizonTableView.backgroundColor = [UIColor clearColor];
    horizonTableView.defaultChooseIndex = 0;
    horizonTableView.delegate = self;
    [self.navBarView addSubview:horizonTableView];

    if (appDelegate.discoveryTabsList.count == 0) {
        [self loadTitleListRequest];
    }

    self.isFirstLoad = YES;

    if (appDelegate.discoveryTabsList.count) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < appDelegate.discoveryTabsList.count; i++) {
            ClubNavTab *tab = appDelegate.discoveryTabsList[i];
            [arr addObject:tab.title];
        }
        horizonTableView.dataSource = arr;
        CGFloat horizonTableViewWidth = horizonTableView.tableViewWidth;
        if (horizonTableViewWidth < screentWith - 15 * 2) {
            horizonTableView.frame = CGRectMake((screentWith - horizonTableViewWidth) * 0.5, 4, horizonTableViewWidth, 36);
        } else {
            horizonTableView.frame = CGRectMake(15, 4, screentWith - 15 * 2, 36);
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarLightStyle];
    if (appDelegate.discoveryTabsList.count == 0) {
        [self loadTitleListRequest];
    }
}

// 只有切换下面底栏tabbar 和  点击 “约电影”等标题进入二级界面再返回的时候 才会走这个方法
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [self setStatusBarLightStyle];
}

- (void)clearWebCacheFlag {
    self.isRequestNet = FALSE;
}

- (void)setViewWillLoaded {

    //设置缓存标识
    [RNCachingURLProtocol clearRequestController:@"HobbyViewController"];
    [RNCachingURLProtocol setRequestController:className];
}

- (BOOL)enableScrollToBack {
    return NO;
}

/**
 *  当前选择的Controller的索引值
 *
 *  @param note
 */
- (void)currentSelectController:(NSNotification *)note {
    int index = [(NSNumber *) [note object] intValue];
    willShowPageIndex = index;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];

    //缓存对象标志为空
    [RNCachingURLProtocol clearRequestController:className];
}

#pragma mark - SubViewController useful methods

- (void)selectedTitleForDiscoverWithIndex:(NSInteger)index withUrl:(NSString *)urlString {

    if (self.indexY == index && self.isFirstLoad == NO) {
        return;
    } else {
        self.indexY = index;
    }
    self.BackFromChild = NO;
    self.isFirstLoad = NO;

    ClubNavTab *tab = appDelegate.discoveryTabsList[index];
    //    NSDictionary *tab = tabsView.tabs[index];

    self.childWebTitle = tab.title;

    if ([urlString hasPrefix:@"komovie://"]) {

        NSArray *contents = [urlString componentsSeparatedByString:@"?"];
        NSString *body = contents.count > 1 ? (NSString *) [contents objectAtIndex:1] : @"";
        NSArray *params = [body componentsSeparatedByString:@"&"];
        NSArray *strUrlParams = [params[0] componentsSeparatedByString:@"="];
        NSString *strUrl = strUrlParams[1];

        if ([strUrl isEqualToString:@"KotaListViewController"]) {
            kotaView.hidden = NO;
            clubView.hidden = YES;
            self.webVC.view.hidden = YES;

            if (!self.kotaViewCtr) {
                KotaListViewController *ctr = [[KotaListViewController alloc] init];
                [self addChildViewController:ctr];
                self.kotaViewCtr = ctr;
                ctr.view.frame = CGRectMake(0, viewPositionY + 44, screentWith, screentContentHeight - 44 - 49);
                kotaView = ctr.view;
                [self.view addSubview:kotaView];
            }
            self.BackFromChild = YES;

        } else if ([strUrl isEqualToString:@"ClubViewController"]) {
            self.webVC.view.hidden = YES;
            clubView.hidden = YES;
            kotaView.hidden = YES;
            if (![clubViewsMutableDict objectForKey:[tab.navId stringValue]]) {
                ClubViewController *ctr = [[ClubViewController alloc] init];
                [self addChildViewController:ctr];
                ctr.view.frame = CGRectMake(0, viewPositionY + 44, screentWith, screentContentHeight - 44 - 49);
                [self.view addSubview:ctr.view];
                ctr.clubTab = tab;
                [ctr refreshClubList];
                [clubViewsMutableDict setValue:ctr.view forKey:[tab.navId stringValue]];
            }
            clubView = [clubViewsMutableDict objectForKey:[tab.navId stringValue]];
            clubView.hidden = NO;
            self.BackFromChild = YES;
            [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionNews_list];
        }

    } else {
        self.currentUrl = urlString;
        self.webVC.view.hidden = NO;
        kotaView.hidden = YES;
        clubView.hidden = YES;
        [self loadActivityWebViewWithRequestURL:urlString];
        [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionOperation_list];
    }
}

/**
 *  社区导航的tabs
 */
- (void)loadTitleListRequest {

    ClubRequest *request = [ClubRequest new];
    [request requestBBSTab:^(NSArray *_Nullable tabs) {
        appDelegate.discoveryTabsList = tabs;
        if (appDelegate.discoveryTabsList.count) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i < appDelegate.discoveryTabsList.count; i++) {
                ClubNavTab *tab = appDelegate.discoveryTabsList[i];
                [arr addObject:tab.title];
            }
            horizonTableView.dataSource = arr;

            CGFloat horizonTableViewWidth = horizonTableView.tableViewWidth;
            if (horizonTableViewWidth < screentWith - 15 * 2) {
                horizonTableView.frame = CGRectMake((screentWith - horizonTableViewWidth) * 0.5, 4, horizonTableViewWidth, 36);
            } else {
                horizonTableView.frame = CGRectMake(15, 4, screentWith - 15 * 2, 36);
            }
        }
    }
                   failure:nil];
}

#warning 如果返回的tab包含两个网页，只有第一个网页能够打开
- (void)loadActivityWebViewWithRequestURL:(NSString *)requestURL {
    if (!_webVC) {
        _webVC = [[ActivityWebViewController alloc] initWithRequestURL:requestURL];
        _webVC.view.backgroundColor = [UIColor redColor];
        [self addChildViewController:_webVC];
        [self.view addSubview:_webVC.view];

        //视图尺寸
        CGRect webViewFrame = _webVC.view.frame;
        webViewFrame.origin.y = CGRectGetMaxY(self.navBarView.frame);
        webViewFrame.size.height = kCommonScreenHeight - CGRectGetMaxY(self.navBarView.frame) - 49.0f;
        _webVC.view.frame = webViewFrame;

        //网页尺寸
        CGRect webFrame = _webVC.webView.frame;
        webFrame.origin.x = 0.0f;
        webFrame.origin.y = 0.0f;
        webFrame.size.height = kCommonScreenHeight - CGRectGetMaxY(self.navBarView.frame) - 49.0f;
        webFrame.size = webFrame.size;
        _webVC.webView.frame = webFrame;
    }
}

#pragma mark override from CommonViewController

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return NO;
}

- (void)horizonTableView:(UICollectionView *)tableView
     didSelectRowAtIndex:(NSInteger)index {
    ClubNavTab *tab = appDelegate.discoveryTabsList[index];
    [self selectedTitleForDiscoverWithIndex:index
                                      withUrl:tab.url];
}

- (BOOL)horizonTableViewNeedToEnlargeTheTitleLabelOnClickLabel {
    return YES;
}

@end
