//
//  想看或看过的电影列表页面
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "AlertViewY.h"
#import "CollectedMovieViewController.h"
#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "Favorite.h"
#import "FavoriteTask.h"
#import "ImageEngine.h"
#import "KKZUser.h"
#import "KotaTask.h"
#import "MJRefresh.h"
#import "MemContainer.h"
#import "MovieDetailViewController.h"
#import "ShareView.h"
#import "ShowMoreIndicator.h"
#import "TaskQueue.h"
#import "UIActionSheet+Blocks.h"
#import "WebViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation CollectedMovieViewController {

    UIView *noCommentHolder;
    NSMutableArray *favoriteAll;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notification_remove_movie" object:nil];
    if (matchListTable) {
        [matchListTable removeFromSuperview];
    }
}

- (id)initWithUser:(NSString *)uId {
    self = [super init];
    if (self) {
        self.userId = uId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self.userId isEqualToString:[DataEngine sharedDataEngine].userId]) {
        if (self.isCollect) {
            self.kkzTitleLabel.text = @"我看过的电影";
        } else {
            self.kkzTitleLabel.text = @"我想看的电影";
        }
    } else {
        if (self.isCollect) {
            self.kkzTitleLabel.text = @"TA看过的电影";
        } else {
            self.kkzTitleLabel.text = @"TA想看的电影";
        }
    }

    tableLocked = NO;

    flipIndex = -1;

    matchListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)
                                                  style:UITableViewStylePlain];
    matchListTable.delegate = self;
    matchListTable.dataSource = self;
    matchListTable.backgroundColor = [UIColor clearColor];
    matchListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    matchListTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:matchListTable];

    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 40)];
    matchListTable.tableFooterView = showMoreFooterView;
    //没有查询到收藏
    noCommentHolder = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 120, screentWith, 110)];

    UIImageView *nodataImg = [[UIImageView alloc] initWithFrame:CGRectMake((noCommentHolder.frame.size.width - 65) * 0.5, 0, 65, 65)];

    nodataImg.image = [UIImage imageNamed:@"failure"];

    [noCommentHolder addSubview:nodataImg];

    nodataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, screentWith, 30)];
    nodataLabel.textColor = [UIColor grayColor];
    nodataLabel.textAlignment = NSTextAlignmentCenter;

    if ([self.userId isEqualToString:[DataEngine sharedDataEngine].userId]) {
        if (self.isCollect) {
            nodataLabel.text = @"亲，你还没有收藏电影~";
        } else {
            nodataLabel.text = @"亲，你还没有想看的电影~";
        }
    } else {
        if (self.isCollect) {
            nodataLabel.text = @"亲，TA还没有收藏的电影~";
        } else {
            nodataLabel.text = @"亲，TA还没有想看的电影~";
        }
    }

    [noCommentHolder addSubview:nodataLabel];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeMovieSuccess:) name:@"Notification_remove_movie" object:nil];

    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 120, screentWith, 120)];
    noAlertView.alertLabelText = @"正在查询影片，请稍候...";

    //集成刷新控件
    [self setupRefresh];
}

- (void)setupRefresh {
    [matchListTable addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [matchListTable headerBeginRefreshing];
    matchListTable.headerPullToRefreshText = @"下拉可以刷新";
    matchListTable.headerReleaseToRefreshText = @"松开马上刷新";
    matchListTable.headerRefreshingText = @"数据加载中...";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)headerRereshing {
    self.refreshHeader = YES;
    [self refreshFavoriteList];
}

- (void)footerRereshing {
    [self showMoreMatch];
}

#pragma mark handle notifications
- (void)removeMovieSuccess:(NSNotification *)notification {
    NSNumber *movieId = [notification object];
    NSMutableArray *removed = [[NSMutableArray alloc] initWithCapacity:0];
    DLog(@"movieId %@....notification....%@", movieId, notification);
    for (Favorite *amovie in favoriteAll) {
        if ([amovie.movieId isEqualToNumber:movieId]) {

        } else {
            [removed addObject:amovie];
        }
    }
    [favoriteAll removeAllObjects];
    [favoriteAll addObjectsFromArray:removed];

    [matchListTable reloadData];

    if (self.delegate && [self.delegate respondsToSelector:@selector(backHostAchievementView:)]) {
        [self.delegate backHostAchievementView:self.isCollect];
    }
}

- (void)favoriteListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    DLog(@"match list finished");
    [self resetRefreshHeader];
    [appDelegate hideIndicator];
    [noAlertView removeFromSuperview];
    showMoreFooterView.isLoading = NO;

    if (currentPage == 1) {
        self.refreshHeader = NO;
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [matchListTable headerEndRefreshing];

    } else {

        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [matchListTable footerEndRefreshing];
    }

    NSMutableArray *arr = [NSMutableArray arrayWithArray:userInfo[@"favoriteAll"]];

    if (succeeded) {

        BOOL hasMore = [[userInfo objectForKey:@"hasMore"] boolValue];
        if (!hasMore) {
            showMoreFooterView.hasNoMore = YES;
        } else {
            showMoreFooterView.hasNoMore = NO;
        }

    } else {
        currentPage--;
    }

    if (currentPage <= 1) {
        favoriteAll = [NSMutableArray arrayWithArray:arr];

    } else {
        [favoriteAll addObjectsFromArray:arr];
    }

    if (favoriteAll.count == 0 && currentPage == 1) { //没数据
        [matchListTable addSubview:noCommentHolder];
        showMoreFooterView.hidden = YES;
    } else {
        [noCommentHolder removeFromSuperview];
        showMoreFooterView.hidden = NO;
    }

    [matchListTable reloadData];
}

#pragma mark match cell delegate
- (void)matchCell:(CollectedMovieCell *)cell touchedAtIndex:(NSInteger)index {

    if ([self.userId isEqualToString:[DataEngine sharedDataEngine].userId]) {

        if (flipIndex != index && flipIndex != index) {
            if (flipIndex >= 0) {
                NSInteger unitIndex = flipIndex;
                NSInteger row = flipIndex / 3;

                CollectedMovieCell *cell = (CollectedMovieCell *) [matchListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                if (unitIndex == cell.lindex) {
                    [cell flipLUint];
                } else if (unitIndex == cell.mindex) {
                    [cell flipMUint];
                } else if (unitIndex == cell.rindex) {
                    [cell flipRUint];
                }
            }
            flipIndex = index;
        }
    } else {
        if (self.isCollect) {
            DLog(@"movieDetail");

            Favorite *lObj = nil;

            lObj = favoriteAll[index];

            MovieDetailViewController *mdv = [[MovieDetailViewController alloc] initCinemaListForMovie:lObj.movieId];
            
            [self pushViewController:mdv animation:CommonSwitchAnimationBounce];

            [matchListTable reloadData];
        } else {
            if (flipIndex != index && flipIndex != index) {
                if (flipIndex >= 0) {
                    NSInteger unitIndex = flipIndex;
                    NSInteger row = flipIndex / 3;

                    CollectedMovieCell *cell = (CollectedMovieCell *) [matchListTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
                    if (unitIndex == cell.lindex) {
                        [cell flipLUint];
                    } else if (unitIndex == cell.mindex) {
                        [cell flipMUint];
                    } else if (unitIndex == cell.rindex) {
                        [cell flipRUint];
                    }
                }
                flipIndex = index;
            }
        }
    }
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

                if (matchListTable.contentOffset.y <= 0) {
                    [matchListTable setContentOffset:CGPointZero animated:YES];
                }
            }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45) {
        if (!showMoreFooterView.hasNoMore && self.refreshHeader == NO) {
            [self showMoreMatch];
        }
    }
}

#pragma mark - Table View Data Source
- (void)configureCell:(CollectedMovieCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.isCollect = self.isCollect;
    cell.userId = self.userId;
    cell.lMovieId = 0;
    cell.mMovieId = 0;
    cell.rMovieId = 0;

    Favorite *lObj = nil;
    Favorite *mObj = nil;
    Favorite *rObj = nil;

    NSInteger count = favoriteAll.count;

    if (indexPath.row * 3 < count) {
        lObj = favoriteAll[indexPath.row * 3];
        cell.lFavorite = lObj;
        cell.row = indexPath.row;
        cell.lindex = indexPath.row * 3;
        cell.lMovieId = lObj.movieId;
        cell.lMovieName = lObj.movieName;
        cell.lImgUrl = lObj.movieImg;
    }

    if (indexPath.row * 3 + 1 < count) {
        mObj = favoriteAll[indexPath.row * 3 + 1];
        cell.mFavorite = mObj;
        cell.row = indexPath.row;
        cell.mindex = indexPath.row * 3 + 1;
        cell.mMovieId = mObj.movieId;
        cell.mImgUrl = mObj.movieImg;
        cell.mMovieName = mObj.movieName;
    }

    if (indexPath.row * 3 + 2 < count) {
        rObj = favoriteAll[indexPath.row * 3 + 2];
        cell.rFavorite = rObj;
        cell.row = indexPath.row;
        cell.rindex = indexPath.row * 3 + 2;
        cell.rMovieId = rObj.movieId;
        cell.rImgUrl = rObj.movieImg;
        cell.rMovieName = rObj.movieName;
    }

    [cell updateLayout];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"MyFavCellCellIdentifier";

    CollectedMovieCell *cell = (CollectedMovieCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CollectedMovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [favoriteAll count];

    if (showMoreFooterView.hasNoMore) {
        if (count % 3 == 0) {
            return count / 3;
        } else {
            return count / 3 + 1;
        }
    } else {
        return count / 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 152 * (screentWith / 320);
}

- (void)refreshFavoriteList {
    [noCommentHolder removeFromSuperview];
    if (favoriteAll.count == 0) {
        [matchListTable addSubview:noAlertView];
        [noAlertView startAnimation];
    }

    flipIndex = -1;

    if (appDelegate.isAuthorized) {
        currentPage = 1;

        FavoriteTask *task = [[FavoriteTask alloc]
                initFavoriteListForUser:[DataEngine sharedDataEngine].userId
                              otherWith:self.userId
                              isCollect:self.isCollect
                                   page:currentPage
                               finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                   [self favoriteListFinished:userInfo status:succeeded];
                               }];

        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            if (userRefresh) {
                if (refreshHeaderView.state != EGOOPullRefreshLoading) {
                    [refreshHeaderView setState:EGOOPullRefreshLoading];
                }
            }
            userRefresh = NO;
            tableLocked = (currentPage == 1);
        }
    }
}

- (void)showMoreMatch {
    currentPage++;

    FavoriteTask *task = [[FavoriteTask alloc]
            initFavoriteListForUser:[DataEngine sharedDataEngine].userId
                          otherWith:self.userId
                          isCollect:self.isCollect
                               page:currentPage
                           finished:^(BOOL succeeded, NSDictionary *userInfo) {

                               [self favoriteListFinished:userInfo status:succeeded];
                           }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

@end
