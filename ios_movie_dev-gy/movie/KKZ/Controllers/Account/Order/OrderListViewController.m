//
//  我的 - 订单管理
//
//  Created by da zhang on 11-7-12.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AlertViewY.h"
#import "Cinema.h"
#import "Coupon.h"
#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "HobbyOrderListController.h"
#import "MJRefresh.h"
#import "Movie.h"
#import "Order.h"
#import "ZYOrderDetailViewController.h"
#import "OrderListViewController.h"
#import "OrderTask.h"
#import "PayViewController.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "WebViewController.h"
#import "NoDataViewY.h"
#import "OrderRequest.h"
#import "KoMovie-Swift.h"

typedef void (^finishBlock)();

@interface OrderListViewController ()

/**
 *  周边订单控制器
 */
@property (nonatomic, strong) HobbyOrderListController *hobbyOrderListCtr;

- (void)refreshTicketOrder;

@end

@implementation OrderListViewController


- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshOrderStates" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshOrderListY" object:nil];
    orderTableView.delegate = nil;
    orderTableView.dataSource = nil;

    if (orderTableView) {
        [orderTableView removeFromSuperview];
    }

    if (sectionHeader) {
        [sectionHeader removeFromSuperview];
    }

    DLog(@"orderTableView$$$$$$$$$$$$$%@", orderTableView);
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.clipsToBounds = YES;

    self.kkzTitleLabel.text = @"订单管理";

//    sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith, 60)];
//    sectionHeader.backgroundColor = [UIColor r:245 g:245 b:245];
//    [self.view addSubview:sectionHeader];

    // scrollView
    holder = [[UIScrollView alloc]
            initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith, screentContentHeight - 44)];
    holder.backgroundColor = [UIColor whiteColor];
    holder.showsVerticalScrollIndicator = NO;
    [self.view addSubview:holder];

    ticketList = [[NSMutableArray alloc] initWithCapacity:0];

    isDisapear = NO;

    expandedRow = -1;
    
    orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screentWith, holder.bounds.size.height)
                                                  style:UITableViewStylePlain];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderTableView.backgroundView = nil;
    orderTableView.showsVerticalScrollIndicator = NO;
    orderTableView.backgroundColor = [UIColor clearColor];
    [holder addSubview:orderTableView];

    orderTableView.hidden = YES;

    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 40)];
    orderTableView.tableFooterView = showMoreFooterView;

    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, screentHeight * 0.5 - 120, screentWith, 120)];
    nodataView.alertLabelText = @"未获取到订单列表";

    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, screentHeight * 0.5 - 120, screentWith, 120)];
    noAlertView.alertLabelText = @"正在查询订单列表，请稍候...";

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshOrderStates:)
                                                 name:@"refreshOrderStates"
                                               object:nil];

    //周边订单控制器
    HobbyOrderListController *ctr = [[HobbyOrderListController alloc] init];
    [self addChildViewController:ctr];
    self.hobbyOrderListCtr = ctr;

    //周边订单的视图
    ctr.view.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight - CGRectGetMaxY(self.navBarView.frame) -
                                                                  CGRectGetHeight(sectionHeader.frame));
    ctr.webView.frame = ctr.view.frame;
    webViewY = ctr.view;
    [holder addSubview:ctr.view];
    webViewY.hidden = YES;

    NSArray *segementArr = @[ @{ @"text" : @"影票订单" }, @{ @"text" : @"周边订单" } ];

    __weak typeof(self) weakSelf = self;

    [self setupRefresh];

    //切换

    chooseSegmentView = [[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(14, 12, screentWith - 26, 35)

                                                                 items:segementArr

                                                          iconPosition:IconPositionRight

                                                     andSelectionBlock:^(NSUInteger segmentIndex) {

                                                         [weakSelf didSelectSegmentAtIndex:segmentIndex];

                                                     }];

    chooseSegmentView.color = [UIColor whiteColor];
    chooseSegmentView.selectionColor = appDelegate.kkzBlue;

    [chooseSegmentView updateSegmentsFormat];
    [sectionHeader addSubview:chooseSegmentView];

    [self didSelectSegmentAtIndex:0];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshCell:)
                                                 name:@"refreshOrderListY"
                                               object:nil];
}

- (void)refreshCell:(NSNotification *) not{
    
    //仅当订单详情操作取消订单时才刷新列表
    
    if (self.orderIdY == nil) {
        return;
    }
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"orderId = %@",self.orderIdY];
    
    NSArray *results = [ticketList filteredArrayUsingPredicate:pre];
    if (results.count > 0) {
        Order *order = results.firstObject;
        if ([order.orderStatus isEqualToNumber:@2]) {
             [self refreshTicketOrder];
        }
    }
    
}

/**

 *  集成刷新控件

 */

- (void)setupRefresh

{
    [orderTableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [orderTableView headerBeginRefreshing];
    orderTableView.headerPullToRefreshText = @"下拉可以刷新";
    orderTableView.headerReleaseToRefreshText = @"松开马上刷新";
    orderTableView.headerRefreshingText = @"数据加载中...";
}

- (void)headerRereshing {
    self.refreshHeader = YES;
    [self refreshTicketOrder];
    [nodataView removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
//    [self.hobbyOrderListCtr refreshRequestWithURL:Order_Requset_URL];
//    if (self.needRefresh == YES) {
//        self.needRefresh = NO;
//        [self refreshTicketOrder];
//    }
    [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionOrder_manage];
}

- (void)refreshOrderStates:(NSNotification *)notification {
    self.refresh = YES;
}

#pragma mark - button click evnet
- (void)didSelectSegmentAtIndex:(NSInteger)index {
    [holder setContentOffset:CGPointZero];

    if (index == 0) {
        if (self.refresh) {
            [self refreshTicketOrder];
            self.refresh = NO;
        }

        orderTableView.hidden = NO;
        webViewY.hidden = YES;
        [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionTicket_manage];
    } else if (index == 1) {
        orderTableView.hidden = YES;
        webViewY.hidden = NO;
        [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionDerivative_order];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    isDisapear = YES;
    [self resetLoading];
}

#pragma mark utilities
- (void)refreshTicketOrder {

    [nodataView removeFromSuperview];
    if (ticketList.count == 0) {
        [orderTableView addSubview:noAlertView];
        [noAlertView startAnimation];
    }

    ticketPage = 1;
    
    ticketTableLocked = YES;
    
    [self requestOrderList:ticketPage];
}

- (void)showMoreTicketOrder {
    ticketPage++;
    
    [self requestOrderList:ticketPage];
    

}

/**
 MARK: 请求订单列表

 @param page 页码
 */
- (void) requestOrderList:(NSInteger) page
{
    OrderRequest *request = [OrderRequest new];
    __weak typeof(self) weakSelf = self;
    [request requestOrderListAt:page success:^(NSArray * _Nullable orders, BOOL hasMore) {
        
        [weakSelf resetLoading];
        [weakSelf handleQueryOrderTicketsFinishedNotification:orders hasMorw:hasMore];
        
    } failure:^(NSError * _Nullable err) {
        
        [weakSelf resetLoading];
        
        if (err.code == 2) {
            //  找不到对应用户  重新登录
            [[DataEngine sharedDataEngine] startLoginFinished:^(BOOL succeeded) {
//                [weakSelf requestOrderList:ticketPage];
            }];
        }
        
        [appDelegate showAlertViewForTitle:nil message:err.userInfo[KKZRequestErrorMessageKey] cancelButton:@"确定"];
        
    }];
}

- (void)handleTouchOnDeleteAtRow:(int)row {
    [ticketList removeObjectAtIndex:row];
    [orderTableView reloadData];
}

#pragma mark - Table view data source
- (void)configureTicketCell:(OrderTicketCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Order *order = [ticketList objectAtIndex:indexPath.row];
    Ticket *ticket = order.plan;
    @try {
        cell.rowNumInTable = indexPath.row;
        cell.movieType = ticket.screenType;
        cell.movieCountry = ticket.language;
        cell.movieName = order.plan.movie.movieName;
        cell.cinemaName = order.plan.cinema.cinemaName;
        cell.orderStateY = order.orderStatus;
        cell.orderTime = [[DateEngine sharedDateEngine] dateFromString:order.orderTime];
        cell.movieTime = [order movieTimeDesc];
        cell.dealPrice = [order.unitPrice intValue];
        cell.orderState = [order orderStateDesc];
        cell.currentState = (OrderState)[order.orderStatus intValue];
        cell.order = order;
        [cell updateLayout];
    } @catch (NSException *exception) {
        LERR(exception);
    } @finally {
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (ticketList.count > 0) {
        showMoreFooterView.hidden = NO;
    } else {
        showMoreFooterView.hidden = YES;
    }

    return ticketList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *ticketCell = @"ticketIdentifier";

    OrderTicketCell *cell = (OrderTicketCell *) [tableView dequeueReusableCellWithIdentifier:ticketCell];
    if (cell == nil) {
        cell = [[OrderTicketCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ticketCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    [self configureTicketCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Order *aOrder = nil;
    aOrder = [ticketList objectAtIndex:indexPath.row];
    if (aOrder.orderStatus.intValue == 1) {
        return 130;
    } else {
        return 130;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Order *aOrder = nil;
    aOrder = [ticketList objectAtIndex:indexPath.row];

    if ([aOrder.orderStatus isEqual:@(1)]) {

        NSCalendar *calendar = [NSCalendar currentCalendar];

        NSDate *expireDate2 =
                [[[DateEngine sharedDateEngine] dateFromString:aOrder.orderTime] dateByAddingTimeInterval:15 * 60];
        unsigned int unitFlags = NSCalendarUnitMinute | NSCalendarUnitSecond;

        NSDateComponents *d =
                [calendar components:unitFlags
                            fromDate:[NSDate date]
                              toDate:expireDate2
                             options:0]; //计算时间差

        if ([d second] < 0) {

            ZYOrderDetailViewController *viewController = [[ZYOrderDetailViewController alloc] init];
//            DLog(@"%@", aOrder.orderId);
//            viewController.isGotoOne = YES;
//            viewController.orderNo = aOrder.orderId;
//            viewController.myOrder = aOrder;
//            viewController.cinemaId = aOrder.plan.cinema.cinemaId.stringValue;
            viewController.currentOrder = aOrder;
            [self.navigationController pushViewController:viewController animated:true];
//            [self pushViewController:viewController animation:CommonSwitchAnimationBounce];
            
            self.indexPathY = indexPath;
            self.orderIdY = aOrder.orderId;

        } else {

            PayViewController *ctr = [[PayViewController alloc] initWithOrder:aOrder.orderId];
            ctr.myOrder = aOrder;
            [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
            self.needRefresh = YES;
        }

    } else {
        ZYOrderDetailViewController *viewController = [[ZYOrderDetailViewController alloc] init];
//        DLog(@"%@", aOrder.orderId);
//        viewController.isGotoOne = YES;
//        viewController.orderNo = aOrder.orderId;
//        viewController.myOrder = aOrder;
//        viewController.cinemaId =  aOrder.plan.cinema.cinemaId.stringValue;
        viewController.currentOrder = aOrder;
        [self.navigationController pushViewController:viewController animated:true];
//        [self pushViewController:viewController animation:CommonSwitchAnimationBounce];
        self.indexPathY = indexPath;
        self.orderIdY = aOrder.orderId;
    }
}

#pragma mark UIScrollViewDelegate


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom -
                scrollView.contentSize.height >=
        45) {
        if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore && self.refreshHeader == NO) {
            showMoreFooterView.isLoading = YES;

            [self showMoreTicketOrder];
        }
    }
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (!decelerate) {
//    }
//    if (scrollView.contentOffset.y <= - 65) {
//        [self performSelector:@selector(refreshTicketOrder) withObject:nil afterDelay:0.1];
//    }
//
//}

- (void) resetLoading
{
    showMoreFooterView.isLoading = NO;
    [appDelegate hideIndicator];
    ticketTableLocked = NO;
    [noAlertView removeFromSuperview];
    [orderTableView headerEndRefreshing];
    [orderTableView footerEndRefreshing];
}

- (void)handleQueryOrderTicketsFinishedNotification:(NSArray *)orderList hasMorw:(BOOL)hasMore

{


    if (ticketPage == 1) {

        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        self.refreshHeader = NO;
        [orderTableView headerEndRefreshing];

    } else {

        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态

        [orderTableView footerEndRefreshing];
    }

    if (!hasMore) {
        showMoreFooterView.hasNoMore = YES;
        orderTableView.footerHidden = YES;
    }
    
    else {
        showMoreFooterView.hasNoMore = NO;
        orderTableView.footerHidden = NO;
    }

    if (ticketPage == 1) {
        [ticketList removeAllObjects];
    }
    NSArray *arr = orderList;
    ticketNum = arr.count;
    [ticketList addObjectsFromArray:arr];

    if (ticketList.count > 0 && nodataView.superview) {
        [nodataView removeFromSuperview];
    } else if (ticketList.count <= 0 && !nodataView.superview) {
        [orderTableView addSubview:nodataView];
    }

    [orderTableView reloadData];
}

#pragma mark override from CommonViewController

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return false;
}

- (BOOL)showTitleBar {
    return TRUE;
}
@end
