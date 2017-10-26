//
//  MovieListVc.m
//  KoMovie
//
//  Created by renzc on 16/9/1.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieListVc.h"
//刷新
#import "MJRefresh.h"

#import "AlertViewY.h"
#import "Movie.h"
#import "MovieRequest.h"
#import "NoDataViewY.h"
#import "KKZUtility.h"

@interface MovieListVc () <UITableViewDelegate, UITableViewDataSource,
                           UIGestureRecognizerDelegate>

@end

@implementation MovieListVc

- (void)viewDidLoad {

    [super viewDidLoad];
}

#pragma mark - Table View Data Source
- (void)configureMovieCell:(MovieListCell *)cell
               atIndexPath:(NSIndexPath *)indexPath {

    [super configureMovieCell:cell atIndexPath:indexPath];
    __weak __typeof(self)weakSelf = self;
    [cell rightButtonClickCallback:^{
        Movie *movie = [weakSelf.movieList objectAtIndex:indexPath.row];
        // 有排期去影院列表页
        MovieCinemaListController *ctr = [[MovieCinemaListController alloc] init];
        ctr.movieId =movie.movieId;
        ctr.movie = movie;
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];

//        KKZAnalyticsEvent *event = [KKZAnalyticsEvent new];
//        event.movie_name = movie.movieName;
//        event.movie_id = movie.movieId.stringValue;
//        [KKZAnalytics postActionWithEvent:event action:AnalyticsActionChooseseat_buy];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [self configureMovieCell:self.movieCell atIndexPath:indexPath];
    return self.movieCell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView
        heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    if (self.movieList.count < indexPath.row) {
        return;
    }

    //统计事件：【购票】电影入口-进入影片页
    StatisEvent(EVENT_BUY_MOVIE_DETAIL_SHOWING_SOURCE_MOVIE);

    Movie *amovie = nil;
    if (self.movieList.count > 0) {
        amovie = [self.movieList objectAtIndex:indexPath.row];
    }
    MovieDetailViewController *mvc = [[MovieDetailViewController alloc] initCinemaListForMovie:amovie.movieId];
    mvc.movie = amovie;
    mvc.has3D = amovie.has3D;
    mvc.hasImax = amovie.hasImax;

    
    mvc.isFromMovies = YES;
    [self pushViewController:mvc animation:CommonSwitchAnimationBounce];
}

#pragma - mark 网络模块
- (void)loadNewData {
    [super loadNewData];

    WeakSelf
            MovieRequest *movieRequest = [[MovieRequest alloc] init];
    [movieRequest requestMoviesWithCityId:[NSString stringWithFormat:@"%tu", USER_CITY]
            page:1
            success:^(NSArray *_Nullable movieList) {

                [weakSelf callApiDidSucceed:movieList];

            }
            failure:^(NSError *_Nullable err) {
                [weakSelf callApiDidFailed:err];
            }];
}

- (void)callApiDidSucceed:(id)responseData {
    [super callApiDidSucceed:responseData];
    [self.movieList addObjectsFromArray:responseData];

    for (int i = 0; i < self.movieList.count; i++) {
        MovieCellLayout *layOut = [[MovieCellLayout alloc] init];
        layOut.movie = self.movieList[i];
        layOut.isIncoming = NO;
        [layOut updateMovieCellLayout];
        [self.movieLayoutList addObject:layOut];
    }

    if (self.movieList.count == 0) {
        [self.tableView addSubview:self.noDataView];
    } else {
        [self.tableView reloadData];
        [self.noDataView removeFromSuperview];
    }
}

- (void)callApiDidFailed:(id)responseData {
    if (self.movieList.count > 0) {
        [self.tableView headerEndRefreshing];
        [UIAlertView showAlertView:KNET_FAULT_MSG buttonText:@"确定"];
        return;
    }
    [super callApiDidFailed:responseData];
}

#pragma mark override from CommonViewController
- (BOOL)showNavBar {
    return YES;
}

- (BOOL)showTitleBar {
    return NO;
}

- (BOOL)showBackButton {
    return NO;
}

@end
