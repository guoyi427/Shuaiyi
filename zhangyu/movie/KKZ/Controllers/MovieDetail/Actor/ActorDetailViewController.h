//
//  ActorDetailViewController.h
//  Aimeili
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//
//  演员详情页面
//

#import "ActorMovieCell.h"
#import "ActorDetailView.h"
#import "Actor.h"
#import "CommonViewController.h"

@class EGORefreshTableHeaderView;
@class RefreshButton;
@class ShowMoreIndicator;
@class UIImageControl;
@class RefreshButton;

@interface ActorDetailViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource, ActorMovieCellDelegate> {
    
    NSInteger currentPage;
    BOOL tableLocked;
    
    ActorDetailView *detailView;
    UITableView *matchListTable;
    
    ShowMoreIndicator *showMoreFooterView;
    EGORefreshTableHeaderView *refreshHeaderView;
    
    UIView *maskView;
    BOOL userRefresh;
}

@property (nonatomic, assign) unsigned int userId;
@property (nonatomic, strong) Actor *actorD;

@end
