//
//  MoviesBaseViewController.h
//  KoMovie
//
//  Created by renzc on 16/9/1.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"


#import "MovieListCell.h"
#import "MovieCellLayout.h"
#import "Movie.h"
#import "MovieDetailViewController.h"
#import "MoviePlayerViewController.h"

@interface MoviesBaseViewController
    : CommonViewController <UITableViewDelegate, UITableViewDataSource,StartShowMovieTrailerDelegate,MoviePlayerViewControllerDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *tableHeaderView;

@property(nonatomic, strong) NoDataViewY *noDataView;
@property(nonatomic, strong) AlertViewY *noAlertView;

@property(nonatomic, strong) NSMutableArray *movieList;
@property(nonatomic, strong) NSMutableArray *movieLayoutList;

@property(nonatomic, strong) MovieListCell *movieCell;
@property (nonatomic, copy) void (^refreshBlock)();
/**
 *  预告片的ctr
 */
@property(nonatomic, strong) MoviePlayerViewController *movieVC;

- (void) setRefreshCallback:(void(^)())a_block;

- (void)refreshMovieList;
- (void)configureMovieCell:(MovieListCell *)cell
               atIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section;
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)loadNewData;
- (void)appBecomeActiveReloadData;

-(void)callApiDidSucceed:(id)responseData;
-(void)callApiDidFailed:(id)responseData;

@end
