//
//  我的 - 好友管理页面
//
//  Created by 艾广华 on 15/12/4.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AddFriendViewController.h"
#import "AttentionViewController+layout.h"
#import "AttentionViewController.h"
#import "DataEngine.h"
#import "FansListViewController.h"
#import "FollowingListViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "UrlOpenUtility.h"

@interface AttentionViewController () {

    // table的顶部视图
    UIView *sectionHeader;

    //分段器
    PPiFlatSegmentedControl *chooseSegmentView;

    //当前选择器索引值
    NSInteger _currentSelectIndex;

    //选择器的默认值
    NSInteger _defaultSelectIndex;
}

/**
 *  关注页面
 */
@property (nonatomic, strong) UIView *attentionTableView;

/**
 *  关注列表
 */
@property (nonatomic, strong) FollowingListViewController *followVc;

/**
 *  我的粉丝
 */
@property (nonatomic, strong) UIView *fansTableView;

/**
 *  添加关注
 */
@property (nonatomic, strong) UIView *friendsTableView;

@end

@implementation AttentionViewController

- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    self = [super init];
    if (self) {
        if (extra1) {
            _defaultSelectIndex = [UrlOpenUtility handleTabIndex:extra1];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载顶部视图
    [self loadTopView];
    //加载主页面
    [self loadMainView];
}


- (void)loadTopView {
    CGFloat originY = CGRectGetMaxY(self.navBarView.frame);
    sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, originY, screentWith, 60)];
    sectionHeader.backgroundColor = [UIColor r:245 g:245 b:245];
    [self.view addSubview:sectionHeader];

    NSArray *segementArr = @[ @{ @"text" : @"我的关注" }, @{ @"text" : @"我的粉丝" }, @{ @"text" : @"添加关注" } ];
    __weak typeof(self) weakSelf = self;

    //切换
    chooseSegmentView = [[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(14, 12, kCommonScreenWidth - 26, 35)
                                                                 items:segementArr
                                                          iconPosition:IconPositionRight
                                                     andSelectionBlock:^(NSUInteger segmentIndex) {
                                                         [weakSelf didSelectSegmentAtIndex:segmentIndex];
                                                     }];

    chooseSegmentView.color = [UIColor whiteColor];
    chooseSegmentView.selectionColor = appDelegate.kkzBlue;

    [chooseSegmentView updateSegmentsFormat];
    [sectionHeader addSubview:chooseSegmentView];

    //设置选择器的索引值，如果有默认值则为默认值，否则为0
    _currentSelectIndex = (_defaultSelectIndex > 0 ? _defaultSelectIndex : 0);
}

- (void)loadMainView {
    [chooseSegmentView setSegmentSelected:_currentSelectIndex];
}

- (void)initChatMessageEngine {
}

- (void)didSelectSegmentAtIndex:(NSInteger)index {

    if (index == 0) {
        self.attentionTableView.hidden = NO;
        _fansTableView.hidden = YES;
        _friendsTableView.hidden = YES;
        [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionMy_attention];
    } else if (index == 1) {
        self.fansTableView.hidden = NO;
        _friendsTableView.hidden = YES;
        _attentionTableView.hidden = YES;
        [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionMy_fans];
    } else if (index == 2) {
        self.friendsTableView.hidden = NO;
        _fansTableView.hidden = YES;
        _attentionTableView.hidden = YES;
    }
}

#pragma mark - getter Method

- (UIView *)attentionTableView {

    if (!_attentionTableView) {
        _attentionTableView =
                [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sectionHeader.frame), kCommonScreenWidth,
                                                         kCommonScreenHeight - CGRectGetHeight(self.navBarView.frame) -
                                                                 CGRectGetHeight(sectionHeader.frame) - 20)];
        _attentionTableView.backgroundColor = [UIColor clearColor];
        _attentionTableView.hidden = NO;
        [self.view addSubview:_attentionTableView];

        [self addChildViewController:self.followVc];
        [_attentionTableView addSubview:self.followVc.view];
    }
    return _attentionTableView;
}

- (FollowingListViewController *)followVc {

    if (!_followVc) {
        _followVc = [[FollowingListViewController alloc] initWithShowTopBar:FALSE];
        _followVc.view.backgroundColor = UIColor.clearColor;
        _followVc.view.frame = CGRectMake(0, 0, kCommonScreenWidth, CGRectGetHeight(_attentionTableView.frame));
        _followVc.userId = self.userId;
        _followVc.isFriend = NO;
        _followVc.isMyList =
                [[DataEngine sharedDataEngine]
                                .userId isEqualToString:[NSString stringWithFormat:@"%@", self.userId]];
    }
    return _followVc;
}

- (UIView *)fansTableView {

    if (!_fansTableView) {
        _fansTableView =
                [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sectionHeader.frame), kCommonScreenWidth,
                                                         kCommonScreenHeight - CGRectGetHeight(self.navBarView.frame) -
                                                                 CGRectGetHeight(sectionHeader.frame) - 20)];
        _fansTableView.hidden = YES;
        [self.view addSubview:_fansTableView];

        FansListViewController *fansCtr =
                [[FansListViewController alloc] initWithUser:self.userId
                                              withShowTopBar:FALSE];
        fansCtr.view.frame = CGRectMake(0, 0, kCommonScreenWidth, CGRectGetHeight(_fansTableView.frame));

        [self addChildViewController:fansCtr];
        [_fansTableView addSubview:fansCtr.view];
    }
    return _fansTableView;
}

- (UIView *)friendsTableView {

    if (!_friendsTableView) {
        _friendsTableView =
                [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sectionHeader.frame), kCommonScreenWidth,
                                                         kCommonScreenHeight - CGRectGetHeight(self.navBarView.frame) -
                                                                 CGRectGetHeight(sectionHeader.frame) - 20)];
        _friendsTableView.hidden = YES;
        [self.view addSubview:_friendsTableView];

        AddFriendViewController *friendCtr =
                [[AddFriendViewController alloc] initWithUser:self.userId];
        [self addChildViewController:friendCtr];
        friendCtr.view.frame = CGRectMake(0, 0, kCommonScreenWidth, CGRectGetHeight(_friendsTableView.frame));
        [_friendsTableView addSubview:friendCtr.view];
    }
    return _friendsTableView;
}

#pragma mark - View pulic Method

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return TRUE;
}

- (BOOL)showTitleBar {
    return TRUE;
}

- (BOOL)setRightButton {
    return FALSE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
