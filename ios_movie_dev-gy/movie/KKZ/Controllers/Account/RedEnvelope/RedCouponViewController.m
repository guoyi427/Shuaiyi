//
//  我的 - 我的红包页面
//
//  Created by gree2 on 17/10/14.
//  Copyright (c) 2014 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AlertViewY.h"
#import "Constants.h"
#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "MJRefresh.h"
#import "RedCoupon.h"
#import "RedCouponHelpInfoViewController.h"
#import "RedCouponTask.h"
#import "RedCouponViewController.h"
#import "TaskQueue.h"
#import "UIConstants.h"
#import "UserDefault.h"
#import "NoDataViewY.h"

@interface RedCouponViewController ()

- (void)doRedCouponListTask;

- (void)resetRefreshHeader;

@end

@implementation RedCouponViewController

- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"我的红包账户";
    self.kkzTitleLabel.textColor = [UIColor blackColor];

    [self.kkzBackBtn setImage:[UIImage imageNamed:@"blue_back"] forState:UIControlStateNormal];

    // 帮助 button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - 50, 0, 44.0, 44.0)];
    [btn setImage:[UIImage imageNamed:@"kotahelpWhite"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(helpBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:btn];

    headView = [[RedEnvelopeHeaderView alloc] initWithFrame:CGRectMake(0, 0, screentWith, (240.0 - 39.5) / 320 * screentWith)];
    redCouponList = [[NSMutableArray alloc] init];

    redCouponTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
    redCouponTableView.backgroundColor = [UIColor whiteColor];
    redCouponTableView.delegate = self;
    redCouponTableView.dataSource = self;
    redCouponTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:redCouponTableView];
    redCouponTableView.tableHeaderView = headView;

    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 40)];
    redCouponTableView.tableFooterView = showMoreFooterView;

    currentPage = 1;
    tableLocked = NO;

    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, screentHeight * 0.5, screentWith, 120)];
    nodataView.alertLabelText = @"未获取到红包信息";

    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, screentHeight * 0.5, screentWith, 120)];
    noAlertView.alertLabelText = @"正在查询红包信息，请稍候...";

    // 集成刷新控件
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarDefaultStyle];
}

//帮助按钮
- (void)helpBtnClicked:(UIButton *)btn {
    RedCouponHelpInfoViewController *redHelp = [[RedCouponHelpInfoViewController alloc] init];
    [self pushViewController:redHelp animation:NO];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh {
    [redCouponTableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [redCouponTableView headerBeginRefreshing];
    redCouponTableView.headerPullToRefreshText = @"下拉可以刷新";
    redCouponTableView.headerReleaseToRefreshText = @"松开马上刷新";
    redCouponTableView.headerRefreshingText = @"数据加载中...";
}

- (void)headerRereshing {
    self.refreshHeader = YES;
    [self doRedCouponListTask];
    [nodataView removeFromSuperview];
}

- (void)footerRereshing {
    [self showMoreRedCouponList];
}

- (void)doRedCouponListTask {

    [nodataView removeFromSuperview];
    if (redCouponList.count == 0) {
        [redCouponTableView addSubview:noAlertView];
        [noAlertView startAnimation];
    }

    currentPage = 1;

    RedCouponTask *task = [[RedCouponTask alloc] initUserRedCouponFeeListWithPage:currentPage
                                                                         finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                             [self redCouponListFinished:userInfo status:succeeded];
                                                                         }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)showMoreRedCouponList {
    currentPage++;

    RedCouponTask *task = [[RedCouponTask alloc] initUserRedCouponFeeListWithPage:currentPage
                                                                         finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                             [self redCouponListFinished:userInfo status:succeeded];
                                                                         }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)handleTouchToShowMore:(id)sender {
}

#pragma mark handle notifications
- (void)redCouponListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    tableLocked = NO;
    showMoreFooterView.isLoading = NO;

    [appDelegate hideIndicator];
    [noAlertView removeFromSuperview];

    if (currentPage == 1) {

        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        self.refreshHeader = NO;
        [redCouponTableView headerEndRefreshing];

    } else {

        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态

        [redCouponTableView footerEndRefreshing];
    }

    if (succeeded) {

        BOOL hasMore = [[userInfo objectForKey:@"hasMore"] boolValue];
        if (!hasMore) {
            showMoreFooterView.hasNoMore = YES;
            redCouponTableView.footerHidden = YES;
        } else {
            showMoreFooterView.hasNoMore = NO;
            redCouponTableView.footerHidden = NO;
        }

        RedCoupon *lastRed = [userInfo kkz_objForKey:@"lastredCoupon"];
        headView.redAmount = [[userInfo objectForKey:@"totalAmount"] floatValue];
        headView.lastRedCoupon = lastRed;
        [headView updateLayout];
        NSArray *arr = [userInfo kkz_objForKey:@"redCoupons"];

        if (currentPage == 1) {
            [redCouponList removeAllObjects];
        }
        [redCouponList addObjectsFromArray:arr];

        if (currentPage == 1 && redCouponList.count == 0) {
            [redCouponTableView addSubview:nodataView];
            showMoreFooterView.hidden = YES;
        } else {

            showMoreFooterView.hidden = NO;
        }
        if (lastRed) {
            headView.frame = CGRectMake(0, 0, screentWith, (240.0 + 60 - 39.5) / 320 * screentWith);
        } else {
            headView.frame = CGRectMake(0, 0, screentWith, (240.0 - 39.5) / 320 * screentWith);
        }

    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
    redCouponTableView.tableHeaderView = headView;

    [redCouponTableView reloadData];
    [self resetRefreshHeader];
}

- (void)redCouponFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];
    if (succeeded) {
        DLog(@"%@", [userInfo objectForKey:@"remainValue"]);
        headView.redAmount = [[userInfo objectForKey:@"remainValue"] floatValue];
        [headView updateLayout];
        [redCouponTableView reloadData];

    } else {
    }
}

#pragma mark UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
            delay:0.0f
            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
            animations:^{
                redCouponTableView.contentInset = UIEdgeInsetsZero;
            }
            completion:^(BOOL finished) {

                if (redCouponTableView.contentOffset.y <= 0) {
                    [redCouponTableView setContentOffset:CGPointZero animated:YES];
                }
            }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45) {
        if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore && self.refreshHeader == NO) {
            showMoreFooterView.isLoading = YES;
            [self showMoreRedCouponList];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -65) {
        [self doRedCouponListTask];
    }
}

#pragma mark - Table View Data Source
- (void)configureEcardCell:(RedEnvelopeCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (redCouponList.count <= 0) {
        return;
    }
    cell.myRedCoupon = [redCouponList objectAtIndex:indexPath.row];
    [cell updateLayout];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"RedCouponCellIdentifier";

    RedEnvelopeCell *cell = (RedEnvelopeCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RedEnvelopeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self configureEcardCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return redCouponList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark override from CommonViewController
- (BOOL)isNavMainColor {
    return NO;
}

@end
