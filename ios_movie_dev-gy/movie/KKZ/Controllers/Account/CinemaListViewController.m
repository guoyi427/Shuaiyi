//
//  我的 - 收藏影院列表页面
//
//  Created by KKZ on 16/1/26.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaListViewController.h"

#import "AlertViewY.h"
#import "CinemaDetail.h"
#import "CinemaTicketViewController.h"
#import "City.h"
#import "Constants.h"
#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "FavoriteTask.h"
#import "LocationEngine.h"
#import "MJRefresh.h"
#import "RIButtonItem.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "UIConstants.h"
#import "UIViewControllerExtra.h"
#import "UserDefault.h"
#import "NoDataViewY.h"

@interface CinemaListViewController ()

- (void)refreshCollectCinemaList;
- (void)resetRefreshHeader;

@end

@implementation CinemaListViewController

- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.clipsToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    self.kkzTitleLabel.text = @"收藏影院";

    cinameTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith, screentContentHeight - 44) style:UITableViewStylePlain];
    cinameTable.delegate = self;
    cinameTable.backgroundColor = [UIColor clearColor];
    cinameTable.dataSource = self;
    cinameTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:cinameTable];

    collectList = [[NSMutableArray alloc] init];

    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 80, screentWith, 120)];
    noAlertView.alertLabelText = @"正在查询已收藏影院，请稍候...";
    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 120, screentWith, 120)];
    nodataView.alertLabelText = @"未获取到收藏影院信息";

    //集成刷新控件
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh {
    [cinameTable addHeaderWithTarget:self
                              action:@selector(headerRereshing)
                             dateKey:@"table"];

    [cinameTable headerBeginRefreshing];
    cinameTable.headerPullToRefreshText = @"下拉可以刷新";
    cinameTable.headerReleaseToRefreshText = @"松开马上刷新";
    cinameTable.headerRefreshingText = @"数据加载中...";
}

- (void)headerRereshing {
    [self refreshCollectCinemaList];
    [nodataView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshCollectCinemaList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [appDelegate hideIndicator];
}

#pragma mark utilities
- (void)refreshCollectCinemaList {
    if (collectList.count == 0) {
        [cinameTable addSubview:noAlertView];
        [noAlertView startAnimation];
        [nodataView removeFromSuperview];
    }

    FavoriteTask *task = [[FavoriteTask alloc]
            initQueryFavForCinema:0
                         finished:^(BOOL succeeded, NSDictionary *userInfo) {

                             [noAlertView removeFromSuperview];
                             if (succeeded) {

                                 [collectList removeAllObjects];
                                 collectList = [userInfo objectForKey:@"cinemasFavedList"];

                                 // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                                 [cinameTable headerEndRefreshing];

                                 if (collectList.count == 0) {
                                     [cinameTable addSubview:nodataView];
                                 } else {
                                     [nodataView removeFromSuperview];
                                 }
                             }
                             [cinameTable reloadData];
                         }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

#pragma mark handle notifications
- (void)cinemaListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    DLog(@"cinema list finished");

    [self resetRefreshHeader];
    if (succeeded) {
        [collectList removeAllObjects];
        NSArray *allDistricts = [userInfo objectForKey:@"collectList"];
        [collectList addObjectsFromArray:allDistricts];
    }
    [cinameTable reloadData];
    querySchedule = YES;
}

#pragma movie cell delegate
- (void)handleTouchOnDetailAtRow:(NSInteger)row {
    CinemaDetail *cinema = [collectList objectAtIndex:row];
    CinemaTicketViewController *ticket = [[CinemaTicketViewController alloc] init];
    ticket.cinemaName = cinema.cinemaName;
    ticket.cinemaAddress = cinema.cinemaAddress;
    ticket.cinemaId = cinema.cinemaId;
    ticket.cinemaCloseTicketTime = cinema.closeTicketTime.stringValue;
    ticket.cinemaDetail = cinema;
    [self pushViewController:ticket animation:CommonSwitchAnimationBounce];
}

- (void)handleTouchOnCancelCollectAtRow:(NSInteger)row {

    [UIAlertView showAlertView:@"您确定要取消收藏该影院吗？"
                    cancelText:@"取消"
                  cancelTapped:nil
                        okText:@"确定"
                      okTapped:^{

                          [self cancelCollectCinema:row];
                      }];
}

- (void)cancelCollectCinema:(NSInteger)row {
    CinemaDetail *cinema = [collectList objectAtIndex:row];
    FavoriteTask *task = [[FavoriteTask alloc]
            initDelFavCinema:cinema.cinemaId.intValue
                    finished:^(BOOL succeeded, NSDictionary *userInfo) {

                        if (succeeded) {
                            [collectList removeObjectAtIndex:row];
                            [cinameTable reloadData];
                        }
                    }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

#pragma mark UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
            delay:0.0f
            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
            animations:^{

                cinameTable.contentInset = UIEdgeInsetsZero;
            }
            completion:^(BOOL finished) {

                if (cinameTable.contentOffset.y <= 0) {
                    [cinameTable setContentOffset:CGPointZero animated:YES];
                }
            }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -65.0f) {
        [self refreshCollectCinemaList];
    }
}

#pragma mark - Table View Data Source
- (void)configureCell:(CollectCinemaCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CinemaDetail *managedObject = [collectList objectAtIndex:indexPath.row];
    @try {
        cell.cinemaName = managedObject.contactName;
        cell.cinemaAddr = managedObject.address;
        cell.cinemaDistance = [managedObject.distanceMetres floatValue];
        cell.rowNum = indexPath.row;
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

    CollectCinemaCell *cell = (CollectCinemaCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CollectCinemaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return collectList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!headerView) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 36)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *headerTitle = [[UILabel alloc] initWithFrame:CGRectMake((screentWith - 120) * 0.5, 11, 120, 14)];
        headerTitle.backgroundColor = [UIColor clearColor];
        headerTitle.textColor = [UIColor r:50 g:50 b:50];
        headerTitle.textAlignment = NSTextAlignmentCenter;
        headerTitle.text = @"共收藏    家影院";
        headerTitle.font = [UIFont systemFontOfSize:13];
        [headerView addSubview:headerTitle];

        collectNumLabel = [[UILabel alloc] initWithFrame:CGRectMake((screentWith - 40) * 0.5, 11, 40, 14)];
        collectNumLabel.backgroundColor = [UIColor clearColor];
        collectNumLabel.textColor = [UIColor r:255 g:105 b:0];
        collectNumLabel.textAlignment = NSTextAlignmentCenter;
        collectNumLabel.text = @"189";
        collectNumLabel.font = [UIFont systemFontOfSize:13];
        [headerView addSubview:collectNumLabel];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 35, screentWith, 1)];
        line.backgroundColor = kDividerColor;
        [headerView addSubview:line];
    }
    collectNumLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) collectList.count];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

@end
