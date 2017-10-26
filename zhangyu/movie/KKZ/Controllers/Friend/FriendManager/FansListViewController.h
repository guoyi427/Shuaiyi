//
//  我的粉丝列表
//
//  Created by zhang da on 12-8-14.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "FollowCell.h"

@class EGORefreshTableHeaderView;
@class ShowMoreIndicator;
@class NoDataViewY;
@class AlertViewY;

@interface FansListViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {

    ShowMoreIndicator *showMoreFooterView;
    NSInteger currentPage;

    UITableView *fansListTable;

    UIButton *amlFansBtn, *sinaFansBtn;

    UILabel *noFansAlertLabel;
    BOOL tableLocked;

    NoDataViewY *nodataView;
    AlertViewY *noAlertView;
}

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL refreshHeader;

- (id)initWithUser:(NSString *)userId;

/**
 *  初始化页面
 *
 *  @param userId
 *  @param isShow
 *
 *  @return
 */
- (id)initWithUser:(NSString *)userId
    withShowTopBar:(BOOL)isShow;

- (void)refreshFansList;

@end
