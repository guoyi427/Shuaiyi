//
//  好友管理 - 添加关注页面
//
//  Created by zhang da on 12-8-14.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AddFriendViewController.h"
#import "AddressBook.h"
#import "ContactsViewController.h"
#import "DataEngine.h"
#import "DataManager.h"
#import "EGORefreshTableHeaderView.h"
#import "FriendHomeViewController.h"
#import "KKZUserTask.h"
#import "PlatformUser.h"
#import "ShowMoreIndicator.h"
#import "TaskQueue.h"
#import "UIConstants.h"

static const CGFloat kDividerHeight = 1.f;

@implementation AddFriendViewController

#pragma mark - Init methods
- (id)initWithUser:(NSString *)userId {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.isShowTopBar = NO;
    }
    return self;
}

- (id)initWithUser:(NSString *)userId withShowTopBar:(BOOL)isShow {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.isShowTopBar = isShow;
    }
    return self;
}

#pragma mark - Lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    NSArray *platforms = @[ @{ @"image" : [UIImage imageNamed:@"add_tele_friendY"],
                               @"title" : @"从手机通讯录列表添加" } ];

    UIScrollView *contentHolder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
    contentHolder.alwaysBounceVertical = YES;
    [self.view addSubview:contentHolder];

    NSUInteger count = platforms.count;
    for (int i = 0; i < count; i++) {
        CGRect frame = CGRectMake(0, (75 + kDividerHeight) * i, screentWith, 75);
        UIView *contentCell = [[UIView alloc] initWithFrame:frame];
        [contentHolder addSubview:contentCell];

        UIImageView *platformImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 43, 43)];
        platformImageView.clipsToBounds = YES;
        platformImageView.image = platforms[i][@"image"];
        [contentCell addSubview:platformImageView];

        UILabel *platformNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 16, screentWith - 90, 43)];
        platformNameLabel.font = [UIFont systemFontOfSize:14];
        platformNameLabel.backgroundColor = [UIColor clearColor];
        platformNameLabel.textColor = [UIColor blackColor];
        platformNameLabel.text = platforms[i][@"title"];
        [contentCell addSubview:platformNameLabel];

        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(screentWith - 25, 16 + 12, 10, 18)];
        arrowImageView.image = [UIImage imageNamed:@"arrowGray"];
        [contentCell addSubview:arrowImageView];

        CGFloat left = (i == count - 1 ? 0 : 15);
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(left, 74, screentWith, 1)];
        [divider setBackgroundColor:kDividerColor];
        [contentCell addSubview:divider];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(didSelectedFriendType:)];
        [contentHolder addGestureRecognizer:tap];
    }
}

- (void)didSelectedFriendType:(UITapGestureRecognizer *)gesture {
    UIView *view = [gesture view];
    NSInteger tag = view.tag;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (tag == 0) {
        //统计事件：添加通讯录好友
        StatisEvent(EVENT_USER_ADD_CONTACT_FRIENT);

        ContactsViewController *ctr = [[ContactsViewController alloc] init];
        [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
    }
}

#pragma mark - Override from CommonViewController
- (BOOL)showNavBar {
    return self.isShowTopBar;
}

@end
