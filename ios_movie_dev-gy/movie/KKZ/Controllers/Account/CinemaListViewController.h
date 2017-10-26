//
//  我的 - 收藏影院列表页面
//
//  Created by KKZ on 16/1/26.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CollectCinemaCell.h"
#import "CommonViewController.h"

@class EGORefreshTableHeaderView;
@class AlertViewY;
@class NoDataViewY;

@protocol cinemaListViewControllerDelegate <NSObject>

- (void)cinemaListDidSelectCiname:(int)cId;

@end

@interface CinemaListViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource, CollectCinemaCellDelegate> {

    UILabel *noCinemaAlertLabel;
    UITableView *cinameTable;
    BOOL querySchedule;
    NSMutableArray *collectList;
    UIView *headerView;
    UILabel *collectNumLabel;

    AlertViewY *noAlertView;
    NoDataViewY *nodataView;
}

@property (nonatomic, weak) id<cinemaListViewControllerDelegate> delegate;

@end
