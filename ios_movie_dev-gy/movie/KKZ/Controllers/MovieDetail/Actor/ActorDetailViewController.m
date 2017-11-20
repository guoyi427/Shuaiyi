//
//  ActorDetailViewController.m
//  Aimeili
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//
//  演员详情页面
//

#import "Actor.h"
#import "ActorDetailViewController.h"
#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "ImageEngine.h"
#import "KotaTask.h"
#import "Movie.h"
#import "MovieDBTask.h"
#import "MovieDetailViewController.h"
#import "ShowMoreIndicator.h"
#import "TaskQueue.h"

#define kHeadHeight 178

@implementation ActorDetailViewController {
    
    NSMutableArray *movies;
}

- (void)dealloc {
    
    if (matchListTable)
        [matchListTable removeFromSuperview];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    movies = [[NSMutableArray alloc] init];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = self.kkzBackBtn.frame;//CGRectMake(0, 3, 60, 38);
    [backBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backBtn];
    
    //    Actor *actor = [Actor getActorWithId:self.userId];
    
    self.userId = self.actorD.starId;
    self.kkzTitleLabel.text = self.actorD.chineseName;
    
    
    tableLocked = NO;
    
    matchListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith, screentContentHeight - 44)
                                                  style:UITableViewStylePlain];
    matchListTable.delegate = self;
    matchListTable.dataSource = self;
    matchListTable.backgroundColor = [UIColor clearColor];
    matchListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:matchListTable];
    
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                    0.0f - matchListTable.bounds.size.height,
                                                                                    screentWith,
                                                                                    matchListTable.bounds.size.height)];
    [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];
    [refreshHeaderView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [matchListTable addSubview:refreshHeaderView];
    
    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];
    matchListTable.tableFooterView = showMoreFooterView;
    
    //-----------movie header view
    detailView = [[ActorDetailView alloc] initWithFrame:CGRectMake(0, 0, screentWith, kHeadHeight)];
    detailView.actorId = self.userId;
    
    detailView.actorD = self.actorD;
    [detailView updateLayout];
    
    matchListTable.tableHeaderView = detailView;
    
    [self loadUserDetail];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadMatchList];
}

#pragma mark account view delegate
- (void)loadUserDetail {
    
    if (self.userId) {
        KotaRequest *kotaRequeset = [[KotaRequest alloc] init];
        [kotaRequeset requestStarDetailWithStarId:self.userId success:^(id  _Nullable starDetail) {
            [self userInfoFinished:nil status:nil];
        } failure:^(NSError * _Nullable err) {
            
        }];
    }
    
}

- (void)userInfoFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {
        
        NSString *accountStatus = [userInfo kkz_stringForKey:@"accountStatus"];
        
        if ([accountStatus isEqualToString:@"0"]) {
            
            DLog(@"user info succeeded");
            detailView.actorId = self.userId;
            [detailView updateLayout];
        }
        
    } else {
    }
}


- (void)loadMatchList {
    
    currentPage = 1;
    
    WeakSelf
    MovieRelatedRequest *starMoviesRequest = [[MovieRelatedRequest alloc] init];
    [starMoviesRequest requestMovieListForActorWithStarId:self.actorD.starId success:^(NSArray * _Nullable movieList) {
        [appDelegate hideIndicator];
        [weakSelf resetRefreshHeader];
        
        [weakSelf callMatchListApiDidSucceed:movieList];
        
    } failure:^(NSError * _Nullable err) {
        [appDelegate hideIndicator];
        [weakSelf resetRefreshHeader];
        //         [appDelegate showAlertViewForTaskInfo:err];
    }];
    
}


- (void)callMatchListApiDidSucceed:(id)responseData{
    //    BOOL hasMore = [[userInfo objectForKey:@"hasMore"] boolValue];
    BOOL hasMore = NO;
    if (!hasMore) {
        showMoreFooterView.hasNoMore = YES;
    } else {
        showMoreFooterView.hasNoMore = NO;
    }
    
    if (currentPage <= 1) {
        movies = responseData;
        [matchListTable reloadData];
    } else {
        [movies addObjectsFromArray:responseData];
        [matchListTable reloadData];
    }
    
}

- (void)loadMoreMatch {
    currentPage++;
    [self loadMatchList];
}



#pragma mark match cell delegate
- (void)matchCell:(ActorMovieCell *)cell touchedAtIndex:(NSInteger)index {
    if (matchListTable.dragging && !matchListTable.decelerating) {
        return;
    }
    
    Movie *movie = movies[index];
    
    MovieDetailViewController *mdv = [[MovieDetailViewController alloc] initCinemaListForMovie:movie.movieId];
    mdv.has3D = movie.has3D;
    mdv.hasImax = movie.hasImax;
    [self pushViewController:mdv animation:CommonSwitchAnimationBounce];
}

#pragma mark UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         matchListTable.contentInset = UIEdgeInsetsZero;
                         
                     }
                     completion:^(BOOL finished) {
                         [refreshHeaderView setState:EGOOPullRefreshNormal];
                         
                         if (matchListTable.contentOffset.y <= 0) {
                             
                             [matchListTable setContentOffset:CGPointZero animated:YES];
                         }
                         
                     }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45) {
        if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore && refreshHeaderView.state != EGOOPullRefreshLoading) {
            showMoreFooterView.isLoading = YES;
            [self loadMoreMatch];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
    }
    if (scrollView.contentOffset.y <= -65.0f && scrollView == matchListTable) {
        userRefresh = YES;
        [self performSelector:@selector(loadMatchList) withObject:nil afterDelay:0.1];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

#pragma mark - Table View Data Source
- (void)configureCell:(ActorMovieCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Movie *lObj = nil;
    Movie *mObj = nil;
    Movie *rObj = nil;
    
    NSInteger count = movies.count;
    if (indexPath.row * 3 < count) {
        lObj = movies[3 * indexPath.row];
    }
    if (indexPath.row * 3 + 1 < count) {
        mObj = movies[3 * indexPath.row + 1];
    }
    if (indexPath.row * 3 + 2 < count) {
        rObj = movies[3 * indexPath.row + 2];
    }
    
    cell.lMovieId = 0, cell.lMovieName = 0;
    cell.mMovieId = 0, cell.mMovieName = 0;
    cell.rMovieId = 0, cell.rMovieName = 0;
    
    @try {
        cell.row = indexPath.row;
        if (lObj) {
            cell.lMovieId = lObj.movieId.integerValue;
            cell.lMovieName = lObj.movieName;
            cell.lImgUrl = lObj.pathVerticalS;
        }
        
        if (mObj) {
            cell.mMovieId = mObj.movieId.integerValue;
            cell.mMovieName = mObj.movieName;
            cell.mImgUrl = mObj.pathVerticalS;
        }
        
        if (rObj) {
            cell.rMovieId = rObj.movieId.integerValue;
            cell.rMovieName = rObj.movieName;
            cell.rImgUrl = rObj.pathVerticalS;
        }
        
        [cell updateLayout];
    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    ActorMovieCell *cell = (ActorMovieCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ActorMovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = movies.count;
    
    if (count % 3 == 0) {
        return count / 3;
    } else {
        return count / 3 + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 156 * screentWith / 320;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark override from CommonViewController
- (void)cancelViewController {
    
    [detailView disMissIntro];
    [self popViewControllerAnimated:YES];
}

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return TRUE;
}

- (BOOL)showTitleBar {
    return TRUE;
}

@end
