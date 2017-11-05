//
//  首页 - 周边
//
//  Created by 艾广华 on 16/4/25.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "PeripheryViewController.h"

#define peripheryTitleBarHeight 44;
#define peripheryTitleBarLabelColor [UIColor whiteColor] // 白色

@interface PeripheryViewController ()

@end

@implementation PeripheryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.requestURL = Periphery_HomePage_URL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载导航条
    [self loadNavView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setStatusBarLightStyle];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionProduct_list];
}

- (void)viewDidLayoutSubviews {
    CGRect webFrame = self.webView.frame;
    webFrame.size.height = kCommonScreenHeight - CGRectGetMaxY(self.navBarView.frame) - 49.0f;
    self.webView.frame = webFrame;
}

- (void)loadNavView {
//    self.navBarView.backgroundColor = appDelegate.kkzBlue;
//    self.statusView.backgroundColor = appDelegate.kkzBlue;

    CGFloat height = peripheryTitleBarHeight;
    UILabel *peripheryTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0.0, screentWith - 60 - 60, height)];
    peripheryTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    peripheryTitleLabel.backgroundColor = [UIColor clearColor];
    peripheryTitleLabel.textAlignment = NSTextAlignmentCenter;
    peripheryTitleLabel.textColor = peripheryTitleBarLabelColor;

    peripheryTitleLabel.text = @"电影周边";
    peripheryTitleLabel.textColor = [UIColor whiteColor];

    [self.navBarView addSubview:peripheryTitleLabel];
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return NO;
}

- (BOOL)showNavBar {
    return YES;
}

@end
