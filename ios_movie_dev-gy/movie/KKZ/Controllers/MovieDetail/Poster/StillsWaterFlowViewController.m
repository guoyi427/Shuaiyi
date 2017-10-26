//
//  StillsWaterFlowViewController.m
//  KoMovie
//
//  Created by gree2 on 14/11/20.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//
//  剧照列表页面
//

#import "StillsWaterFlowViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "Gallery.h"
#import "MovieTask.h"
#import "TaskQueue.h"
#import "ImageEngineNew.h"
#import "ImageEngine.h"

@implementation StillsWaterFlowViewController

- (void)viewDidLoad {
    // Call super to load
    [super viewDidLoad];

    self.kkzTitleLabel.text = self.titleStr;

    stillsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY + 5, screentWith, screentContentHeight - 44 - 5) style:UITableViewStylePlain];
    stillsTable.delegate = self;
    stillsTable.backgroundColor = [UIColor clearColor];
    stillsTable.dataSource = self;
    stillsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:stillsTable];

    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                    0.0f - stillsTable.bounds.size.height,
                                                                                    screentWith,
                                                                                    stillsTable.bounds.size.height)];
    [stillsTable addSubview:refreshHeaderView];

    noCinemaAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                   40,
                                                                   screentWith - 10 * 2,
                                                                   40)];
    noCinemaAlertLabel.text = @"没有拿到上映影片的影院, 下拉刷新试试或者换个电影吧";
    noCinemaAlertLabel.font = [UIFont systemFontOfSize:16.0];
    noCinemaAlertLabel.textColor = [UIColor grayColor];
    noCinemaAlertLabel.backgroundColor = [UIColor clearColor];
    noCinemaAlertLabel.textAlignment = NSTextAlignmentCenter;
    noCinemaAlertLabel.numberOfLines = 0;

    tableLocked = NO;

    stillList = [[NSMutableArray alloc] init];

    accountTitleLabel.text = self.titleStr;
    [self refreshStillList];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    KKZAnalyticsEvent *event = [KKZAnalyticsEvent new];
    event.movie_id = self.movieId.stringValue;
    [KKZAnalytics postActionWithEvent:event action:AnalyticsActionStill_list];
}

#pragma mark utilities
- (void)refreshStillList {

    if (self.isCinema) {

        MovieTask *task = [[MovieTask alloc] initCinemaPosterWithCinemaid:self.movieId.unsignedIntegerValue
                                                                mediaType:20
                                                                 finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                     [self movieGalleryFinished:userInfo status:succeeded];
                                                                 }];

        [[TaskQueue sharedTaskQueue] addTaskToQueue:task];

    } else {
        MovieTask *task = [[MovieTask alloc] initMovieGallarysWithMovieId: self.movieId.unsignedIntValue
                                                                 finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                     [self movieGalleryFinished:userInfo status:succeeded];
                                                                 }];

        [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
    }

    tableLocked = YES;
}

#pragma mark handle notifications
- (void)movieGalleryFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    DLog(@"cinema list finished");

    [self resetRefreshHeader];
    tableLocked = NO;

    if (succeeded) {

        [stillList removeAllObjects];

        if (self.isCinema) {
            NSArray *allDistricts = [userInfo objectForKey:@"posters"];
            [stillList addObjectsFromArray:allDistricts];
        } else {
            NSArray *allDistricts = userInfo[@"galleryList"];
            [stillList addObjectsFromArray:allDistricts];
        }
    }
    [stillsTable reloadData];
}

- (void)loadImagesForOnscreenRows {
    NSArray *visiblePaths = [stillsTable indexPathsForVisibleRows];
    if ([visiblePaths count]) {
        for (NSIndexPath *indexPath in visiblePaths) {
            StillsSmallCell *cell = (StillsSmallCell *) [stillsTable cellForRowAtIndexPath:indexPath];
            [cell preparePicImg];
        }
    }
}

#pragma mark UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
            delay:0.0f
            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
            animations:^{

                stillsTable.contentInset = UIEdgeInsetsZero;

            }
            completion:^(BOOL finished) {
                [refreshHeaderView setState:EGOOPullRefreshNormal];

                if (stillsTable.contentOffset.y <= 0) {

                    [stillsTable setContentOffset:CGPointZero animated:YES];
                }

            }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging) {
        if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
            [refreshHeaderView setState:EGOOPullRefreshNormal];
        } else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
            [refreshHeaderView setState:EGOOPullRefreshPulling];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }

    if (refreshHeaderView.state == EGOOPullRefreshLoading) {
        return;
    }
    if (scrollView.contentOffset.y <= -65.0f) {
        [self refreshStillList];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenRows];
}

#pragma mark - Table View Data Source
- (void)configureCell:(StillsSmallCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = [stillList count];

    Gallery *app1 = nil, *app2 = nil, *app3, *app4 = nil;
    cell.stillIndex1 = -1;
    cell.imagePath1 = nil;

    cell.stillIndex2 = -1;
    cell.imagePath2 = nil;

    cell.stillIndex3 = -1;
    cell.imagePath3 = nil;

    cell.stillIndex4 = -1;
    cell.imagePath4 = nil;

    int rowNum = 4;

    if (self.isCinema) {

        cell.isMovie = NO;
        if (indexPath.row * rowNum < count) {
            cell.stillIndex1 = indexPath.row * rowNum;
            cell.imagePath1 = stillList[indexPath.row * rowNum];
        }
        if (indexPath.row * rowNum + 1 < count) {
            cell.stillIndex2 = indexPath.row * rowNum + 1;
            cell.imagePath2 = stillList[indexPath.row * rowNum + 1];
        }
        if (rowNum > 2 && indexPath.row * rowNum + 2 < count) {
            cell.stillIndex3 = indexPath.row * rowNum + 2;
            cell.imagePath3 = stillList[indexPath.row * rowNum + 2];
        }
        if (rowNum > 3 && indexPath.row * rowNum + 3 < count) {
            cell.stillIndex4 = indexPath.row * rowNum + 3;
            cell.imagePath4 = stillList[indexPath.row * rowNum + 3];
        }
    } else {

        cell.isMovie = YES;
        if (indexPath.row * rowNum < count) {
            app1 = [stillList objectAtIndex:indexPath.row * rowNum];
            cell.stillIndex1 = indexPath.row * rowNum;
            cell.imagePath1 = app1.imageSmall;
        }
        if (indexPath.row * rowNum + 1 < count) {
            app2 = [stillList objectAtIndex:indexPath.row * rowNum + 1];
            cell.stillIndex2 = indexPath.row * rowNum + 1;
            cell.imagePath2 = app2.imageSmall;
        }
        if (rowNum > 2 && indexPath.row * rowNum + 2 < count) {
            app3 = [stillList objectAtIndex:indexPath.row * rowNum + 2];
            cell.stillIndex3 = indexPath.row * rowNum + 2;
            cell.imagePath3 = app3.imageSmall;
        }
        if (rowNum > 3 && indexPath.row * rowNum + 3 < count) {
            app4 = [stillList objectAtIndex:indexPath.row * rowNum + 3];
            cell.stillIndex4 = indexPath.row * rowNum + 3;
            cell.imagePath4 = app4.imageSmall;
        }
    }

    @try {
        cell.stills = stillList;

        [cell updateImagePath];

        if (stillsTable.dragging == NO && stillsTable.decelerating == NO) {
            [cell preparePicImg];
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

    StillsSmallCell *cell = (StillsSmallCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[StillsSmallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger count = [stillList count];

    return count / 4 + (count % 4 > 0 ? 1 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat marginY = (screentWith - 320) * 0.25;
    return 73.5 + 5 + marginY;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    [[ImageEngineNew sharedImageEngineNew] releaseImageCache];

    [[ImageEngine sharedImageEngine] releaseImageCache];
}

#pragma mark override from CommonViewController

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
