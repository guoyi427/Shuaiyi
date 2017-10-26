//
//  StillsWaterFlowViewController.h
//  KoMovie
//
//  Created by gree2 on 14/11/20.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//
//  剧照列表页面
//

#import <UIKit/UIKit.h>
#import "StillsSmallCell.h"
#import "CommonViewController.h"

@class EGORefreshTableHeaderView;

@interface StillsWaterFlowViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource> {
    EGORefreshTableHeaderView *refreshHeaderView;
    UITableView *stillsTable;
    NSMutableArray *stillList;
    BOOL tableLocked;
    UILabel *noCinemaAlertLabel;
    UILabel *accountTitleLabel;
}

@property (nonatomic, copy) NSNumber *movieId;
@property (nonatomic, assign) int mediaType;
@property (nonatomic, strong) NSString *titleStr;
@property (nonatomic, assign) BOOL isCinema;

@end
