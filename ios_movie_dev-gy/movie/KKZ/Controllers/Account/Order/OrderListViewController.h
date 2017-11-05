//
//  我的 - 订单管理
//
//  Created by da zhang on 11-7-12.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "NSStringExtra.h"
#import "Order.h"
#import "OrderTicketCell.h"
#import "PPiFlatSegmentedControl.h"
#import "ShowMoreIndicator.h"
#import "UIViewControllerExtra.h"

@class EGORefreshTableHeaderView;
@class NoDataViewY;
@class AlertViewY;

@interface OrderListViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource> {

    UILabel *noOrderAlertLabel, *noCouponAlertLabel;
    UIView *noOrderAlertView, *noCouponAlertView;
    UILabel *orderTableState, *couponTableState;
    UIButton *userNameButton;
    UITableView *orderTableView;
    ShowMoreIndicator *showMoreFooterView;
    UIControl *rigistHolder;

    int expandedRow;

    BOOL isDisapear;

    BOOL ticketTableLocked;
    BOOL visiablity;
    int ticketOrderCount, couponOrderCount, sosOrderCount;

    NSInteger ticketPage, couponPage;
    NSMutableArray *ticketList, *couponList;
    NSInteger ticketNum, couponNum;
    BOOL markSection1, markSection2;

    PPiFlatSegmentedControl *chooseSegmentView;
    UIView *sectionHeader, *headview;

    UITableView *movieTable;
    UILabel *noFansAlertLabel;

    NoDataViewY *nodataView;
    AlertViewY *noAlertView;

    UIScrollView *holder;

    UIView *webViewY;
}


@property (nonatomic, copy) NSString *validcoupongOrderCount;
@property (nonatomic, assign) int selectedSection;

@property (nonatomic, assign) BOOL refresh;
@property (nonatomic, assign) BOOL refreshHeader;

@property (nonatomic, strong) NSIndexPath *indexPathY;
@property (nonatomic, copy) NSString *orderIdY;

@property (nonatomic, assign) BOOL needRefresh;

@end
