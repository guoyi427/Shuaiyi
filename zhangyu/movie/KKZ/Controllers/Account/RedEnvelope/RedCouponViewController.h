//
//  我的 - 我的红包页面
//
//  Created by gree2 on 17/10/14.
//  Copyright (c) 2014 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "RedEnvelopeCell.h"
#import "RedEnvelopeHeaderView.h"
#import "ShowMoreIndicator.h"

@class EGORefreshTableHeaderView;
@class NoDataViewY;
@class AlertViewY;

@interface RedCouponViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource> {

    RedEnvelopeHeaderView *headView;
    UITableView *redCouponTableView;
    NSMutableArray *redCouponList;
    ShowMoreIndicator *showMoreFooterView;
    NSInteger currentPage;
    BOOL tableLocked;
    UILabel *noRedAlertLabel;

    NoDataViewY *nodataView;

    AlertViewY *noAlertView;
}

@property (nonatomic, assign) BOOL refreshHeader;

@end
