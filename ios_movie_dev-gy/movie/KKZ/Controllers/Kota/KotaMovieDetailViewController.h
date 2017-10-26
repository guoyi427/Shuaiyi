//
//  约电影的详情页面
//
//  Created by avatar on 14-11-24.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AlertViewY.h"
#import "CommonViewController.h"
#import "KotaTask.h"
#import "MovieTrailer.h"
#import "NSStringExtra.h"
#import "PPiFlatSegmentedControl.h"
#import "RatingView.h"
#import "ShowMoreIndicator.h"
#import "UIViewControllerExtra.h"

#import "MoviePlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@class EGORefreshTableHeaderView;
@class Movie;
@class RefreshButton;
@class ShowMoreIndicator;
@class NoDataViewY;

@interface KotaMovieDetailViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource, RatingViewDelegate, UIGestureRecognizerDelegate, MoviePlayerViewControllerDataSource, MoviePlayerViewControllerDelegate> {

    ShowMoreIndicator *showMoreTicketBtn, *showMoreCouponBtn;

    PPiFlatSegmentedControl *chooseSegmentView;

    UIView *sectionHeader;

    UITableView *kotaDetailTableView;

    UIImageView *headview;

    UIView *noDetailAlertView;

    UILabel *noDetailAlertLabel;

    NSMutableArray *kotaInfoList;
    UIButton *backBtn;

    BOOL isDisapear;

    NSInteger expandedRow;

    NSMutableArray *kotaList;

    NSInteger currentPage;

    UIView *headerView, *headerTopView, *blackView, *playView;

    UIImageView *postImageView, *scoreImg, *wantLookImg, *trailerImg;
    RatingView *starView;

    UILabel *totleScoreLalel, *markNumLabel, *wantWathLabel, *scoreLabel, *wantLookLabel, *trailerLabel;

    CGRect scoreRect, wantLookRect, playTrailerRect;

    UILabel *movieTitleLabel;

    UIImageView *homeBackgroundView;

    MPMoviePlayerController *vedioPlayer;

    ShowMoreIndicator *showMoreFooterView;

    UIImageView *topView;

    UIView *postImageViewBg;

    AlertViewY *noAlertView;

    NoDataViewY *nodataView;

    BOOL effictiveClick;
    MoviePlayerViewController *movieVC;
}

@property (nonatomic, strong) NSNumber *movieId;
@property (nonatomic, strong) MovieTrailer *movieTrailer;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) Movie *movie;
@property (nonatomic, assign) BOOL myAppointMent;
@property (nonatomic, assign) NSInteger indexPRow;
@property (nonatomic, strong) MPMoviePlayerViewController *playerViewController;

@end
