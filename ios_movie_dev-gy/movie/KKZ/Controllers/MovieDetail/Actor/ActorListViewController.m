//
//  电影详情 - 查看全部演职人员列表页面
//
//  Created by zhang da on 12-8-14.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "Actor.h"
#import "ActorDetailViewController.h"
#import "ActorListViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "KKZUser.h"
#import "MovieDBTask.h"
#import "ShowMoreIndicator.h"
#import "StarCell.h"
#import "TaskQueue.h"

@interface ActorListViewController ()

- (void)loadActorList;

@end

@implementation ActorListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    stars = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.kkzTitleLabel.text = @"演员列表";
    
    fansListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith, screentContentHeight - 44)
                                                 style:UITableViewStylePlain];
    fansListTable.delegate = self;
    fansListTable.dataSource = self;
    fansListTable.backgroundColor = [UIColor whiteColor];
    fansListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:fansListTable];
    
    noFansAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, screentWith - 10 * 2, 60)];
    noFansAlertLabel.font = [UIFont systemFontOfSize:16.0];
    noFansAlertLabel.textColor = [UIColor grayColor];
    noFansAlertLabel.backgroundColor = [UIColor clearColor];
    noFansAlertLabel.textAlignment = NSTextAlignmentCenter;
    noFansAlertLabel.numberOfLines = 0;
    
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -fansListTable.bounds.size.height, screentWith, fansListTable.bounds.size.height)];
    [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];
    [fansListTable addSubview:refreshHeaderView];
    
    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];
    fansListTable.tableFooterView = showMoreFooterView;
    
    currentPage = 1;
    tableLocked = NO;
    
    [self loadActorList];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionActor_list];
}

- (void)dealloc {
    if (fansListTable) {
        [fansListTable removeFromSuperview];
    }
}

#pragma mark utilities
- (void)loadActorList {

    WeakSelf
    MovieRelatedRequest *movieRelatedRequest = [[MovieRelatedRequest alloc] init];
    [movieRelatedRequest requestActorListForMovieWithMovieId:self.movieId.integerValue success:^(NSArray * _Nullable actorList) {
        
        [weakSelf resetRefreshHeader];
        
        showMoreFooterView.isLoading = NO;
        tableLocked = NO;
        taskFinish = YES;
        [appDelegate hideIndicator];
        
        [weakSelf callActorListApiDidSucceed:actorList];
    } failure:^(NSError * _Nullable err) {
        [weakSelf resetRefreshHeader];
        
        showMoreFooterView.isLoading = NO;
        tableLocked = NO;
        taskFinish = YES;
        [appDelegate hideIndicator];
        
        showMoreFooterView.hasNoMore = YES;
        
    }];
}
- (void)callActorListApiDidSucceed:(id)responseObject {
    
    stars = (NSMutableArray *) responseObject;
    //    BOOL hasMore = [[userInfo objectForKey:@"hasMore"] boolValue];
    BOOL hasMore = NO;
    
    if (!hasMore) {
        showMoreFooterView.hasNoMore = YES;
    } else {
        showMoreFooterView.hasNoMore = YES;
    }
    [fansListTable reloadData];
    
}
- (void)showMoreFans {
    currentPage++;
    [self loadActorList];
}



#pragma mark UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         fansListTable.contentInset = UIEdgeInsetsZero;
                     }
                     completion:^(BOOL finished) {
                         [refreshHeaderView setState:EGOOPullRefreshNormal];
                         
                         if (fansListTable.contentOffset.y <= 0) {
                             [fansListTable setContentOffset:CGPointZero animated:YES];
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
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= -5) {
        if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore && refreshHeaderView.state != EGOOPullRefreshLoading) {
            showMoreFooterView.isLoading = YES;
            [self showMoreFans];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (refreshHeaderView.state == EGOOPullRefreshLoading || showMoreFooterView.isLoading) {
        return;
    }
    if (scrollView.contentOffset.y <= -65) {
        [self performSelector:@selector(loadActorList) withObject:nil afterDelay:0.1];
    }
}

#pragma mark - Table View Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"StarCellIdentifier";
    //电影介绍
    StarCell *cell = (StarCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[StarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (stars.count) {
        cell.isMovie = YES;
        Actor *actor = [stars objectAtIndex:indexPath.row];
        cell.titleStr = actor.chineseName;
        cell.starHeadUrl = actor.imageSmall;
        [cell updateLayout];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return stars.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    Actor *actor = (Actor *) [stars objectAtIndex:indexPath.row];
    @try {
        ActorDetailViewController *ctr = [[ActorDetailViewController alloc] init];
        ctr.userId = actor.starId;
        ctr.actorD = actor;
        [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
    }
}

@end
