//
//  约电影 - 查看更多约电影信息
//
//  Created by xuyang on 13-4-10.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AlertViewY.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "FriendHomeViewController.h"
#import "KKZUser.h"
#import "KotaMovieCell.h"
#import "KotaMovieDetailViewController.h"
#import "KotaMovieListsViewController.h"
#import "KotaShare.h"
#import "KotaShareMovie.h"
#import "MJRefresh.h"
#import "Movie.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "applyForViewController.h"
#import "NoDataViewY.h"

@implementation KotaMovieListsViewController

- (void)dealloc {
    if (kotaTable) {
        [kotaTable removeFromSuperview];
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"待约电影";

    currentPage = 1;
    tableLocked = NO;
    self.movieId = 0;

    expandedRow = -1;
    lastExpandedRow = -1;
    kotaTable = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                              self.contentPositionY + 44,
                                                              screentWith,
                                                              screentContentHeight - 44)
                                             style:UITableViewStylePlain];
    kotaTable.dataSource = self;
    kotaTable.delegate = self;
    kotaTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    kotaTable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:kotaTable];

    kotaMovieList = [[NSMutableArray alloc] initWithCapacity:0];

    //表尾，显示更多
    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 40)];
    kotaTable.tableFooterView = showMoreFooterView;

    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 80, screentWith, 120)];
    noAlertView.alertLabelText = @"加载中，请稍候...";

    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 80, screentWith, 120)];
    nodataView.alertLabelText = @"还没有信息哦";

    //集成刷新控件
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh {
    [kotaTable addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [kotaTable headerBeginRefreshing];

    kotaTable.headerPullToRefreshText = @"下拉可以刷新";
    kotaTable.headerReleaseToRefreshText = @"松开马上刷新";
    kotaTable.headerRefreshingText = @"数据加载中...";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing {
    [self refreshKotaMovieList];
    [nodataView removeFromSuperview];
}

- (void)footerRereshing {
    [self showMoreKotaMovieList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    [kotaTable headerEndRefreshing];
}

//刷新kota
- (void)refreshKotaMovieList {
    currentPage = 1;

    KotaTask *task = [[KotaTask alloc] initKotaFilmListByCityId:@""
                                                           page:currentPage
                                                       pageSize:15
                                                       finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                           [self kotaMovieListFinished:userInfo status:succeeded];
                                                       }];

    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)showMoreKotaMovieList {
    currentPage++;
    KotaTask *task = [[KotaTask alloc] initKotaFilmListByCityId:@""
                                                           page:currentPage
                                                       pageSize:15
                                                       finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                           [self kotaMovieListFinished:userInfo status:succeeded];
                                                       }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        showMoreFooterView.isLoading = YES;
    }
}

#pragma mark handle notifications
- (void)kotaMovieListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];
    showMoreFooterView.isLoading = NO;
    if (noAlertView.superview) {
        [noAlertView removeFromSuperview];
    }
    if (succeeded) {
        showMoreFooterView.hidden = NO;
        if (currentPage == 1) {
            [kotaMovieList removeAllObjects];
        }
        NSArray *arr = [userInfo objectForKey:@"kotaFilms"];

        BOOL hasMore;
        if (arr.count < 15) {
            hasMore = NO;
        } else {
            hasMore = YES;
        }

        if (!hasMore) {
            showMoreFooterView.hasNoMore = YES;
        } else {
            showMoreFooterView.hasNoMore = NO;
        }

        [kotaMovieList addObjectsFromArray:arr];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }

    if (kotaMovieList.count == 0) {
        showMoreFooterView.hidden = YES;
        [kotaTable addSubview:nodataView];
    } else {
        [nodataView removeFromSuperview];
    }

    [kotaTable reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [kotaTable headerEndRefreshing];
}

#pragma mark - Table View Data Source
- (void)configureMovieCell:(KotaMovieCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    KotaShareMovie *kotaMovie = nil;
    kotaMovie = [kotaMovieList objectAtIndex:indexPath.row];

    @try {
        cell.manNum = [NSString stringWithFormat:@"%@", kotaMovie.man];
        cell.womanNum = [NSString stringWithFormat:@"%@", kotaMovie.women];
        cell.succeedNum = [NSString stringWithFormat:@"%@", kotaMovie.successCount];
        cell.movieName = kotaMovie.movieName;
        cell.posterPath = kotaMovie.posterPath;
        [cell reloadData];
    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"CellIdentifier";

    KotaMovieCell *cell = (KotaMovieCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KotaMovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *view_bg = [[UIView alloc] initWithFrame:cell.frame];
        view_bg.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = view_bg;
    }

    [self configureMovieCell:cell atIndexPath:indexPath];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([kotaMovieList count] == 0 && !noAlertView.superview) {
        if (!nodataView.superview) {
            [kotaTable addSubview:noAlertView];
        }
    } else if (kotaMovieList.count > 0 && noAlertView.superview) {
        [noAlertView removeFromSuperview];
    }
    return kotaMovieList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (!isConnected) {
#define kLastShowAlertTime @"lastShowAlertTime"
        NSDate *lastShow = [[NSUserDefaults standardUserDefaults] objectForKey:kLastShowAlertTime];

        if (!lastShow || [lastShow timeIntervalSinceNow] < -2) {
            [UIAlertView showAlertView:@"网络好像有点问题, 稍后再试吧" buttonText:@"好的" buttonTapped:nil];

            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastShowAlertTime];
        }
        return;
    }

    DLog(@"选择了一个cell,申请约电影");

    KotaShareMovie *kotaMovie = nil;
    kotaMovie = [kotaMovieList objectAtIndex:indexPath.row];

    KotaMovieDetailViewController *movieDetail = [[KotaMovieDetailViewController alloc] init];
    movieDetail.movieId = [NSNumber numberWithInt:kotaMovie.filmId];
    [self pushViewController:movieDetail animation:CommonSwitchAnimationSwipeR2L];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging) {
        if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
            [refreshHeaderView setState:EGOOPullRefreshNormal];
        } else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
            [refreshHeaderView setState:EGOOPullRefreshPulling];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (refreshHeaderView.state == EGOOPullRefreshLoading) {
        return;
    }

    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45) {
        if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore && refreshHeaderView.state != EGOOPullRefreshLoading) {
            showMoreFooterView.isLoading = YES;
            [self showMoreKotaMovieList];
        }
    }
}

@end
