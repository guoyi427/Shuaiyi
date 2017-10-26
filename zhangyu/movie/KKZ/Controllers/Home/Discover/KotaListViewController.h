//
//  首页 - 发现 - 约电影
//
//  Created by xuyang on 13-4-10.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "KotaListCell.h"
#import "KotaTask.h"
#import "ShowMoreIndicator.h"

@class AlertViewY;
@class NoDataViewY;
@class BannerPlayerView;
@class KotaHeadImageView;
@class EGORefreshTableHeaderView;

@interface KotaListViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate> {

    UITableView *kotaTable;
    EGORefreshTableHeaderView *refreshHeaderView;
    ShowMoreIndicator *showMoreFooterView;
    BannerPlayerView *imgPlayer;

    UIView *bottomMask;
    UIView *filterView, *filterButtonBg;
    UIControl *filterMaskView;

    UIControl *ctrHolder;
    BOOL rigistFinished;
    BOOL locationON;

    int currentPage;
    int expandedRow, lastExpandedRow;
    int rowCount;
    BOOL tableLocked;
    BOOL filterShow;

    UIButton *logingBtn;
    UIImageView *headerArrowImg;
    UIImageView *applySuccessTipImg;
    UIControl *_overlayView, *tipImageCover;

    NSMutableArray *kotaMovieList, *kotaUserList, *kotaList;

    UIImageView *headview;

    KotaHeadImageView *userImagesView;

    UIView *headViewY;
    UIView *headerView;

    CGFloat height;
    UIView *titleView;
    UILabel *noNewsAlertLabel;

    AlertViewY *noAlertView;
    NoDataViewY *nodataView;

    UIView *sectionFooter;
}

@property (nonatomic, assign) KotaListFilterMode filterMode;
@property (nonatomic, strong) NSString *accountStatus;
@property (nonatomic, assign) BOOL cityChanged;
@property (nonatomic, assign) NSInteger rowsNum;

@property (nonatomic, assign) int movieId;

@end
