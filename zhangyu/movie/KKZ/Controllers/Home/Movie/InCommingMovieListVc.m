//
//  InCommingMovieListVc.m
//  KoMovie
//
//  Created by renzc on 16/9/1.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "InCommingMovieListVc.h"
#import "Movie.h"
#import "MovieRequest.h"
#import <Kingfisher/Kingfisher-Swift.h>
#import "KKZUtility.h"
@interface InCommingMovieListVc () <UITableViewDelegate, UITableViewDataSource,
                                    UIGestureRecognizerDelegate> {
}
@end

@implementation InCommingMovieListVc

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - tableview相关
- (void)configureMovieCell:(MovieListCell *)cell
               atIndexPath:(NSIndexPath *)indexPath {
    [super configureMovieCell:cell atIndexPath:indexPath];
    
    __weak __typeof(self)weakSelf = self;
    [cell rightButtonClickCallback:^{
        Movie *movie = [weakSelf.movieList objectAtIndex:indexPath.row];
        if (movie.hasPlan == YES) {
            // 有排期去影院列表页
            MovieCinemaListController *ctr = [[MovieCinemaListController alloc] init];
            ctr.movieId =movie.movieId;
            ctr.movie = movie;
            CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
            [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
        }else {
            MovieDetailViewController *mvc = [[MovieDetailViewController alloc] initCinemaListForMovie:movie.movieId];
            CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
            [parentCtr pushViewController:mvc animation:CommonSwitchAnimationBounce];
        }

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [super tableView:tableView didSelectRowAtIndexPath:indexPath];

    if (self.movieList.count < indexPath.row) {
        return;
    }

    //统计事件：查看即将上映影片详情
    StatisEvent(EVENT_MOVIE_INCOMING_DETAIL);

    Movie *amovie = nil;
    if (self.movieList.count > 0) {
        amovie = [self.movieList objectAtIndex:indexPath.row];
    }

    if (amovie.hasPromotion) {
        
        MovieDetailViewController *mvc = [[MovieDetailViewController alloc] initCinemaListForMovie:amovie.movieId];
        
        mvc.isFromMovies = YES;
        mvc.has3D = amovie.has3D;
        mvc.hasImax = amovie.hasImax;
        [self pushViewController:mvc animation:CommonSwitchAnimationBounce];

    } else {
        
        MovieDetailViewController *mvc = [[MovieDetailViewController alloc] initCinemaListForMovie:amovie.movieId];
        
        mvc.isFromMovies = YES;
        mvc.has3D = amovie.has3D;
        mvc.hasImax = amovie.hasImax;
        [self pushViewController:mvc animation:CommonSwitchAnimationBounce];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma - mark 网络相关
- (void)callApiDidSucceed:(id)responseData {

    [super callApiDidSucceed:responseData];
    [self.movieList addObjectsFromArray:responseData];

    for (int i = 0; i < self.movieList.count; i++) {
        MovieCellLayout *layOut = [[MovieCellLayout alloc] init];
        layOut.movie = self.movieList[i];
        layOut.isIncoming = YES;
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

#pragma mark 开始请求列表数据
- (void)loadNewData {
    [super loadNewData];
    WeakSelf
            MovieRequest *movieRequest = [[MovieRequest alloc] init];
    [movieRequest requestInCommingMoviesWithCityId:[NSString stringWithFormat:@"%tu", USER_CITY]
            page:1
            success:^(NSArray *_Nullable movieList) {

                [weakSelf callApiDidSucceed:movieList];

            }
            failure:^(NSError *_Nullable err) {
                [weakSelf callApiDidFailed:err];
            }];
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
