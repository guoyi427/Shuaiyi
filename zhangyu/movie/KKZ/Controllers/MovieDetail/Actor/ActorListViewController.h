//
//  FansListViewController
//  aimeili
//
//  Created by zhang da on 12-8-14.
//  Copyright (c) 2012年 zhang da. All rights reserved.
//
//  演员列表页面
//

#import "CommonViewController.h"

@class EGORefreshTableHeaderView;
@class ShowMoreIndicator;

@interface ActorListViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource> {

    EGORefreshTableHeaderView *refreshHeaderView;
    ShowMoreIndicator *showMoreFooterView;
    NSInteger currentPage;

    UITableView *fansListTable;

    UIButton *amlFansBtn, *sinaFansBtn;

    UILabel *noFansAlertLabel;
    BOOL tableLocked, taskFinish;
    NSMutableArray *stars;
}

@property (nonatomic, copy) NSNumber *movieId;

@end
