//
//  我的社区 - 我的订阅号页面
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ClubTask.h"
#import "EGORefreshTableHeaderView.h"
#import "FriendHomeViewController.h"
#import "ImageEngineNew.h"
#import "KKZUser.h"
#import "MySubscreberCell.h"
#import "MySubscribesController.h"
#import "ShowMoreIndicator.h"
#import "SubscriberHomeViewController.h"
#import "TaskQueue.h"
#import "NoDataViewY.h"

#define navBackgroundColor appDelegate.kkzBlue

#define cellHeight 80

@interface MySubscribesController () {

    ShowMoreIndicator *showMoreFooterView;

    EGORefreshTableHeaderView *refreshHeaderView;
}

@end

@implementation MySubscribesController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isSubscriberComplete" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航栏
    [self addNavView];

    //加载tableview
    [self addTableView];

    [self refreshMySubscribeList];

    [self addTableNotice];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addSubscriberComplete)
                                                 name:@"isSubscriberComplete"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarLightStyle];
}

// 添加列表数据提示信息
- (void)addTableNotice {
    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 100, screentWith, 120)];
    nodataView.alertLabelText = @"未获取到相关订阅号信息";
}

- (void)addTableView {
    mySubscribesView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentHeight - (self.contentPositionY + 44))];
    [self.view addSubview:mySubscribesView];
    mySubscribesView.delegate = self;
    mySubscribesView.dataSource = self;
    mySubscribesView.separatorStyle = UITableViewCellSeparatorStyleNone;

    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - mySubscribesView.bounds.size.height, screentWith, mySubscribesView.bounds.size.height)];
    [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];
    [refreshHeaderView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [mySubscribesView addSubview:refreshHeaderView];

    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];
    mySubscribesView.tableFooterView = showMoreFooterView;
    showMoreFooterView.hidden = YES; //永远隐藏
}

//添加导航栏
- (void)addNavView {
    [self.view setBackgroundColor:navBackgroundColor];
    [self.navBarView setBackgroundColor:navBackgroundColor];
    [self.kkzBackBtn setImage:[UIImage imageNamed:@"backButtonImg"] forState:UIControlStateNormal];
    self.kkzTitleLabel.text = @"我的订阅号";
    self.kkzTitleLabel.textColor = [UIColor whiteColor];
}

#pragma mark - UITableView date source delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mySubscribes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKZUser *user = [self.mySubscribes objectAtIndex:indexPath.row];
    static NSString *mySubscreberIdentifier = @"mySubscreberCell";
    MySubscreberCell *cell = [tableView dequeueReusableCellWithIdentifier:mySubscreberIdentifier];
    if (cell == nil) {
        cell = [[MySubscreberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mySubscreberIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }

    cell.userId = user.userId;
    [cell upLoadData];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"functionBtnClicked");

    KKZUser *user = [self.mySubscribes objectAtIndex:indexPath.row];
    if (user.userGroupId == 5) {
        SubscriberHomeViewController *ctr = [[SubscriberHomeViewController alloc] init];
        ctr.userId = user.userId;
        [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
    } else {
        FriendHomeViewController *ctr = [[FriendHomeViewController alloc] init];
        ctr.userId = user.userId;
        [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
    }
}

// 更新我的订阅列表
- (void)refreshMySubscribeList {
    [nodataView removeFromSuperview];
    currentPage = 1;
    ClubTask *task = [[ClubTask alloc] initMineSubscriberListWithCurrentPage:currentPage Finished:^(BOOL succeeded, NSDictionary *userInfo) {
        [self mySubscribeListFinished:userInfo status:succeeded];
    }];

    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)mySubscribeListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];
    showMoreFooterView.isLoading = NO;

    if (succeeded) {
        if ([userInfo[@"hasMore"] integerValue]) {
            self.hasMore = YES;
            showMoreFooterView.hidden = NO;
            showMoreFooterView.hasNoMore = NO;
        } else {
            self.hasMore = NO;
            showMoreFooterView.hidden = NO;
            showMoreFooterView.hasNoMore = YES;
        }

        NSMutableArray *res = [[NSMutableArray alloc] initWithArray:userInfo[@"usersM"]];
        if (currentPage <= 1) {
            self.mySubscribes = [[NSMutableArray alloc] initWithArray:res];
        } else {
            if (res.count > 0) {
                [self.mySubscribes addObjectsFromArray:res];
            }
        }

        if (self.mySubscribes.count == 0) {
            showMoreFooterView.hidden = YES;
            [mySubscribesView addSubview:nodataView];
        }

        [mySubscribesView reloadData];
    } else {
        //        if (self.mySubscribes.count == 0) {
        //            showMoreFooterView.hidden = YES;
        //            [mySubscribesView addSubview:nodataView];
        //        }
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

- (void)moreMySubscribeList {
    [nodataView removeFromSuperview];
    currentPage += 1;
    ClubTask *task = [[ClubTask alloc] initMineSubscriberListWithCurrentPage:currentPage Finished:^(BOOL succeeded, NSDictionary *userInfo) {
        [self mySubscribeListFinished:userInfo status:succeeded];
    }];

    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //在拖动
    if (scrollView.isDragging) {
        if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
            [refreshHeaderView setState:EGOOPullRefreshNormal];
        } else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
            [refreshHeaderView setState:EGOOPullRefreshPulling];
        }
    } else {
    }

    //进入下方区域+45像素
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45) {
        if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore && refreshHeaderView.state != EGOOPullRefreshLoading) {
        }
    }
}

//拖动（释放手指）停止的时候执行
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (refreshHeaderView.state == EGOOPullRefreshLoading) {
        return;
    }

    //上拉刷新
    //    if (scrollView.contentOffset.y <= -65.0f && self.hasMore) {
    if (scrollView.contentOffset.y <= -65.0f) {
        //        if (!showMoreFooterView.hasNoMore) {
        [self performSelector:@selector(refreshMySubscribeList) withObject:nil afterDelay:0.2];
        //        }
    }

    //下拉刷新
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45 && self.hasMore) {
        if (!showMoreFooterView.isLoading && refreshHeaderView.state != EGOOPullRefreshLoading) {
            [self moreMySubscribeList];
        }
    }
}

- (void)addSubscriberComplete {
    [self refreshMySubscribeList];
}

@end
