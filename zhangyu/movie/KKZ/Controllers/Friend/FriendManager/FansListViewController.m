//
//  粉丝列表
//
//  Created by zhang da on 12-8-14.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AlertViewY.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "FansListViewController.h"
#import "FollowCell.h"
#import "FriendHomeViewController.h"
#import "KKZUser.h"
#import "KKZUserTask.h"
#import "MJRefresh.h"
#import "NoDataViewY.h"
#import "ShowMoreIndicator.h"
#import "TaskQueue.h"

@interface FansListViewController ()

/**
 *  是否显示顶部导航栏
 */
@property (nonatomic, assign) BOOL isShowTopBar;

- (void)resetRefreshHeader;

@end

@implementation FansListViewController {

    NSMutableArray *followers;
}

- (void)dealloc {
    DLog(@"FansListViewController dealloc");

    if (fansListTable) {
        [fansListTable removeFromSuperview];
    }
}

- (id)initWithUser:(NSString *)uId {
    self = [super init];
    if (self) {
        self.userId = uId;
    }
    return self;
}

- (id)initWithUser:(NSString *)userId
    withShowTopBar:(BOOL)isShow {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.isShowTopBar = !isShow;
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    followers = [[NSMutableArray alloc] init];
    currentPage = 1;

    followers = [[NSMutableArray alloc] init];

    fansListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentContentHeight - 44 - 50)
                                                 style:UITableViewStylePlain];
    fansListTable.delegate = self;
    fansListTable.dataSource = self;
    fansListTable.backgroundColor = [UIColor clearColor];
    fansListTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:fansListTable];

    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 50)];
    fansListTable.tableFooterView = showMoreFooterView;

    tableLocked = NO;

    noFansAlertLabel.font = [UIFont systemFontOfSize:16.0];
    noFansAlertLabel.textColor = [UIColor grayColor];
    noFansAlertLabel.backgroundColor = [UIColor clearColor];
    noFansAlertLabel.textAlignment = NSTextAlignmentCenter;
    noFansAlertLabel.numberOfLines = 4;
    noFansAlertLabel.hidden = YES;
    [fansListTable addSubview:noFansAlertLabel];

    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 120, screentWith, 120)];
    noAlertView.alertLabelText = @"正在查询粉丝列表，请稍候...";

    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 120, screentWith, 120)];
    nodataView.alertLabelText = @"还没有信息哦";

    //集成刷新控件
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh {
    [fansListTable addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [fansListTable headerBeginRefreshing];
    fansListTable.headerPullToRefreshText = @"下拉可以刷新";
    fansListTable.headerReleaseToRefreshText = @"松开马上刷新";
    fansListTable.headerRefreshingText = @"数据加载中...";
}

- (void)headerRereshing {
    self.refreshHeader = YES;
    [self performSelector:@selector(refreshFansList) withObject:nil afterDelay:.3];
    [nodataView removeFromSuperview];
}

- (void)footerRereshing {
    [self showMoreFans];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

#pragma mark utilities
- (void)refreshFansList {
    if (followers.count == 0) {
        [fansListTable addSubview:noAlertView];
        [noAlertView startAnimation];
        [nodataView removeFromSuperview];
    }

    currentPage = 1;

    KKZUserTask *task = [[KKZUserTask alloc]
            initFollowingListFor:self.userId.intValue
                            page:currentPage
                      searchText:nil
                        finished:^(BOOL succeeded, NSDictionary *userInfo) {
                            [self followingListFinished:userInfo status:succeeded];
                        }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        tableLocked = currentPage == 1;
    }
}

- (void)showMoreFans {
    currentPage++;

    KKZUserTask *task = [[KKZUserTask alloc]
            initFollowingListFor:self.userId.intValue
                            page:currentPage
                      searchText:nil
                        finished:^(BOOL succeeded, NSDictionary *userInfo) {
                            [self followingListFinished:userInfo status:succeeded];
                        }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

#pragma mark handle notifications
- (void)followingListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    DLog(@"fans list finished");

    [appDelegate hideIndicator];
    [noAlertView removeFromSuperview];

    if (currentPage == 1) {
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        self.refreshHeader = NO;
        [fansListTable headerEndRefreshing];
    } else {
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [fansListTable footerEndRefreshing];
    }

    showMoreFooterView.isLoading = NO;
    tableLocked = NO;

    NSArray *arr = (NSArray *) [userInfo objectForKey:@"followers"];

    if (currentPage == 1 && arr.count == 0) {
        showMoreFooterView.hidden = YES;
        noFansAlertLabel.hidden = NO;
    } else {
        showMoreFooterView.hidden = NO;
        noFansAlertLabel.hidden = YES;
    }

    if (succeeded) {
        BOOL hasMore = [[userInfo objectForKey:@"hasMore"] boolValue];
        if (!hasMore) {
            showMoreFooterView.hasNoMore = YES;
            fansListTable.footerHidden = YES;
        } else {
            showMoreFooterView.hasNoMore = NO;
            fansListTable.footerHidden = NO;
        }

        if (currentPage <= 1) {
            followers = [NSMutableArray arrayWithArray:arr];
        } else {
            [followers addObjectsFromArray:arr];
        }
        [fansListTable reloadData];

    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }

    if (followers.count == 0) {
        [fansListTable addSubview:nodataView];
        showMoreFooterView.hidden = YES;

        if ([self.userId isEqualToString:[DataEngine sharedDataEngine].userId]) {
            nodataView.alertLabelText = @"啊哦, 您还没有粉丝喔~";
        } else {
            nodataView.alertLabelText = @"啊哦, TA还没有粉丝喔~";
        }
    } else {
        [nodataView removeFromSuperview];
        showMoreFooterView.hidden = NO;
    }
}

#pragma mark UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
            delay:0.0f
            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
            animations:^{

                fansListTable.contentInset = UIEdgeInsetsZero;
            }
            completion:^(BOOL finished) {

                if (fansListTable.contentOffset.y <= 0) {
                    [fansListTable setContentOffset:CGPointZero animated:YES];
                }
            }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45 && self.refreshHeader == NO) {
        if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore) {
            showMoreFooterView.isLoading = YES;
            [self showMoreFans];
        }
    }
}

#pragma mark - Table View Data Source
- (void)configureCell:(FollowCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    @try {
        cell.cellType = MyFansCellType;
        cell.user = followers[indexPath.row];
        [cell updateLayout];
    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"CellIdentifier";

    FollowCell *cell = (FollowCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return followers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kFollowCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    KKZUser *user = followers[indexPath.row];
    @try {
        if (![[NetworkUtil me] reachable]) {
            return;
        }

        FriendHomeViewController *ctr = [[FriendHomeViewController alloc] init];
        ctr.userId = user.userId;
        [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
    }
    @catch (NSException *exception) {

    }
    @finally {
    }
}

#pragma mark override from CommonViewController
- (BOOL)showNavBar {
    return !self.isShowTopBar;
}

@end
