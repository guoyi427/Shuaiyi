//
//  约电影 - 查看更多约电影信息
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
@class ImagePlayerView;
@class KotaHeadImageView;
@class EGORefreshTableHeaderView;

@interface KotaMovieListsViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIScrollViewDelegate> {

    UITableView *kotaTable;
    EGORefreshTableHeaderView *refreshHeaderView;
    ShowMoreIndicator *showMoreFooterView;
    ImagePlayerView *imgPlayer;

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
}

@property (nonatomic, assign) KotaListFilterMode filterMode;
@property (nonatomic, strong) NSString *accountStatus;
@property (nonatomic, assign) BOOL cityChanged;

@property (nonatomic, assign) int movieId;

@end
