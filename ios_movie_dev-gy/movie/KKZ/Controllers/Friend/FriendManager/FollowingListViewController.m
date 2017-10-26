//
//  我的关注列表
//
//  Created by alfaromeo on 12-3-30.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AlertViewY.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "FollowCell.h"
#import "FollowingListViewController.h"
#import "FriendHomeViewController.h"
#import "KKZUser.h"
#import "KKZUserTask.h"
#import "MJRefresh.h"
#import "RIButtonItem.h"
#import "RoundCornersButton.h"
#import "ShowMoreIndicator.h"
#import "SinaClient.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "NoDataViewY.h"
#import <ShareSDK/ShareSDK.h>

@interface FollowingListViewController ()

- (void)resetRefreshHeader;

@end

@implementation FollowingListViewController {

    NSMutableArray *favorites;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isFriendComplete" object:nil];
    if (fansTable) {
        [fansTable removeFromSuperview];
    }
}

- (id)initWithShowTopBar:(BOOL)isShow {
    self = [super init];
    if (self) {
        self.isShowTopBar = !isShow;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    noFansAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 290, 40)];
    if ([self.userId isEqualToString:[DataEngine sharedDataEngine].userId]) {

        if (self.isFriend) {
            noFansAlertLabel.text = @"啊哦, 您还没有好友喔~";
        } else {
            noFansAlertLabel.text = @"啊哦, 您还没有关注人喔~";
        }
    } else {
        if (self.isFriend) {
            noFansAlertLabel.text = @"啊哦, TA还没有好友喔~";
        } else {
            noFansAlertLabel.text = @"啊哦, TA还没有关注人喔~";
        }
    }
    noFansAlertLabel.font = [UIFont systemFontOfSize:16.0];
    noFansAlertLabel.textColor = [UIColor grayColor];
    noFansAlertLabel.backgroundColor = [UIColor clearColor];
    noFansAlertLabel.textAlignment = NSTextAlignmentCenter;
    noFansAlertLabel.numberOfLines = 0;
    noFansAlertLabel.hidden = YES;

    searchFans = [[NSMutableArray alloc] init];
    dataSource = [[NSMutableArray alloc] init];
    CGFloat heightY = 0;
    if (self.isFromFriend) {
        heightY = screentContentHeight - 44;
    } else {
        heightY = screentContentHeight - 44 - 50;
    }

    fansTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screentWith, heightY)
                                             style:UITableViewStylePlain];
    fansTable.delegate = self;
    fansTable.dataSource = self;
    fansTable.backgroundColor = [UIColor clearColor];
    fansTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:fansTable];

    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 50)];
    fansTable.tableFooterView = showMoreFooterView;
    tableLocked = NO;

    self.row = -1;

    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 120, screentWith, 120)];
    nodataView.alertLabelText = @"未获取到关注信息";

    //集成刷新控件
    [self setupRefresh];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addFriendComplete)
                                                 name:@"isFriendComplete"
                                               object:nil];
}

- (void)setupRefresh {
    [fansTable addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [fansTable headerBeginRefreshing];
    fansTable.headerPullToRefreshText = @"下拉可以刷新";
    fansTable.headerReleaseToRefreshText = @"松开马上刷新";
    fansTable.headerRefreshingText = @"数据加载中...";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing {
    self.refreshHeaderF = YES;
    [self refreshFavoritesList];
    [nodataView removeFromSuperview];
}

- (void)footerRereshing {
    [self showMoreFans];
}

- (void)refreshFriendList {
    [self refreshFavoritesList];
}

- (void)refreshFavoritesList {
    [nodataView removeFromSuperview];

    currentPage = 1;

    KKZUserTask *task = nil;

    if (self.isFriend) {
        task = [[KKZUserTask alloc]
                initFriendListFor:self.userId.intValue
                             page:currentPage
                       searchText:@""
                             sort:@"1"
                         finished:^(BOOL succeeded, NSDictionary *userInfo) {
                             [self favoritesListFinished:userInfo status:succeeded];
                         }];
    } else {
        task = [[KKZUserTask alloc]
                initFavoriteListFor:self.userId.intValue
                               page:currentPage
                         searchText:@""
                           finished:^(BOOL succeeded, NSDictionary *userInfo) {
                               [self favoritesListFinished:userInfo status:succeeded];
                           }];
    }

    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)showMoreFans {
    currentPage++;

    KKZUserTask *task = nil;

    if (self.isFriend) {
        task = [[KKZUserTask alloc]
                initFriendListFor:self.userId.intValue
                             page:currentPage
                       searchText:@""
                             sort:@"1"
                         finished:^(BOOL succeeded, NSDictionary *userInfo) {
                             [self favoritesListFinished:userInfo status:succeeded];
                         }];
    } else {
        task = [[KKZUserTask alloc]
                initFavoriteListFor:self.userId.intValue
                               page:currentPage
                         searchText:@""
                           finished:^(BOOL succeeded, NSDictionary *userInfo) {
                               [self favoritesListFinished:userInfo status:succeeded];
                           }];
    }
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

#pragma mark - handle notifications
- (void)favoritesListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];

    tableLocked = NO;
    [self resetRefreshHeader];

    showMoreFooterView.isLoading = NO;

    if (currentPage == 1) {
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        self.refreshHeaderF = NO;
        [fansTable headerEndRefreshing];
    } else {
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [fansTable footerEndRefreshing];
    }

    NSArray *arr = nil;
    if (self.isFriend) {
        arr = (NSArray *) [userInfo objectForKey:@"friends"];
    } else {
        arr = (NSArray *) [userInfo objectForKey:@"favorites"];
    }

    if ([self.userId isEqualToString:[DataEngine sharedDataEngine].userId]) {
        if (self.isFriend) {
            noFansAlertLabel.text = @"啊哦, 您还没有好友喔~";
        } else {
            noFansAlertLabel.text = @"啊哦, 您还没有关注人喔~";
        }
    } else {
        if (self.isFriend) {
            noFansAlertLabel.text = @"啊哦, TA还没有好友喔~";
        } else {
            noFansAlertLabel.text = @"啊哦, TA还没有关注人喔~";
        }
    }

    if (currentPage == 1 && arr.count == 0) {
        showMoreFooterView.hidden = YES;
        noFansAlertLabel.hidden = NO;
    } else {
        showMoreFooterView.hidden = NO;
        noFansAlertLabel.hidden = YES;
    }

    if (succeeded) {
        BOOL hasMore = [[userInfo kkz_objForKey:@"hasMore"] boolValue];
        if (!hasMore) {
            showMoreFooterView.hasNoMore = YES;
            fansTable.footerHidden = YES;
        } else {
            showMoreFooterView.hasNoMore = NO;
            fansTable.footerHidden = NO;
        }
        if (currentPage <= 1) {
            favorites = [NSMutableArray arrayWithArray:arr];

        } else {
            [favorites addObjectsFromArray:arr];
        }

        [fansTable reloadData];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }

    if (favorites.count == 0) {
        [fansTable addSubview:nodataView];
        showMoreFooterView.hidden = YES;
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

                fansTable.contentInset = UIEdgeInsetsZero;

            }
            completion:^(BOOL finished) {

                if (fansTable.contentOffset.y <= 0) {

                    [fansTable setContentOffset:CGPointZero animated:YES];
                }

            }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45) {
        if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore && self.refreshHeaderF == NO) {
            showMoreFooterView.isLoading = YES;
            [self showMoreFans];
        }
    }
}

#pragma mark - Table view data source
- (void)configureCell:(FollowCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([self.userId isEqualToString:[DataEngine sharedDataEngine].userId]) {
        cell.cellType = MyAttentionCellType; //w d hao you
    } else {
        cell.cellType = OtherFriendCellType; //ta d
    }

    KKZUser *user = favorites[indexPath.row];
    cell.user = user;
    [cell updateLayout];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return favorites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";

    FollowCell *cell = (FollowCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[FollowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    }

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return kFollowCellHeight;
}

- (void)addFriendComplete {
    [self refreshFavoritesList];
}

#pragma mark override from CommonViewController
- (BOOL)showNavBar {
    return !self.isShowTopBar;
}

@end
