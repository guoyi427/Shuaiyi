//
//  首页 - 发现 - 约电影
//
//  Created by xuyang on 13-4-10.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AlertViewY.h"
#import "BannerPlayerView.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "FriendHomeViewController.h"
#import "InitiateAppointmentByMovieController.h"
#import "KKZUser.h"
#import "KotaHeadImageView.h"
#import "KotaHelpInfoViewController.h"
#import "KotaListViewController.h"
#import "KotaMovieCell.h"
#import "KotaMovieDetailViewController.h"
#import "KotaMovieListsViewController.h"
#import "KotaNearUserCell.h"
#import "KotaShare.h"
#import "KotaShareMovie.h"
#import "KotaShareUser.h"
#import "LocationEngine.h"
#import "MJRefresh.h"
#import "Movie.h"
#import "Reachability.h"
#import "ShareView.h"
#import "SinaClient.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "UIConstants.h"
#import "UserDefault.h"
#import "applyForViewController.h"
#import "NoDataViewY.h"

#define kUITitleViewHeight 45
#define kUIUserImagesViewHeight 75

#define kKotaHeaderSectionHeight 35

@interface KotaListViewController ()
@end

@implementation KotaListViewController

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"imagePlayerViewHeightKota"];
    [appDelegate removeObserver:self forKeyPath:@"changeCity"];
    if (kotaTable)
        [kotaTable removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    height = 0;

    CGFloat heightN = 75 * (screentWith / 320);
    imgPlayer = [[BannerPlayerView alloc] initWithFrame:CGRectMake(0, 0, screentWith, heightN)];
    imgPlayer.typeId = @"6";

    currentPage = 1;
    tableLocked = NO;
    self.movieId = 0;

    expandedRow = -1;
    lastExpandedRow = -1;

    kotaTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentContentHeight - 44 - 49) style:UITableViewStylePlain];
    kotaTable.dataSource = self;
    kotaTable.delegate = self;
    kotaTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    kotaTable.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:kotaTable];

    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 200)];
    [headerView setBackgroundColor:[UIColor whiteColor]];

    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, height, screentWith, kUITitleViewHeight)];
    [titleView setBackgroundColor:[UIColor whiteColor]];

    // 看电影、交朋友 title
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screentWith, kUITitleViewHeight)];
    lbl.text = @"看电影、交朋友";
    lbl.textColor = [UIColor grayColor];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:kTextSizeTitle];
    [titleView addSubview:lbl];

    // 帮助 button
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - 50, 0, kUITitleViewHeight, kUITitleViewHeight)];
    [btn setImage:[UIImage imageNamed:@"kotahelp"] forState:UIControlStateNormal];

    [titleView addSubview:btn];
    [btn addTarget:self action:@selector(helpBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    [headerView addSubview:titleView];

    // 头像列表上面分割线
    UIView *lineUp = [[UIView alloc] initWithFrame:CGRectMake(0, kUITitleViewHeight - 1, screentWith, 1)];
    [lineUp setBackgroundColor:kUIColorDivider];
    [titleView addSubview:lineUp];

    userImagesView = [[KotaHeadImageView alloc] initWithFrame:CGRectMake(0, kUITitleViewHeight, screentWith, kUIUserImagesViewHeight)];
    [headerView addSubview:userImagesView];

    // 头像列表底下分割线
    UIView *lineDown = [[UIView alloc] initWithFrame:CGRectMake(0, kUIUserImagesViewHeight - 1, screentWith, 1)];
    [lineDown setBackgroundColor:kUIColorDivider];
    [userImagesView addSubview:lineDown];

    kotaTable.tableHeaderView = headerView;

    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 50)];

    kotaTable.tableFooterView = footer;

    kotaMovieList = [[NSMutableArray alloc] initWithCapacity:0];

    kotaUserList = [[NSMutableArray alloc] initWithCapacity:0];

    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 + 60, screentWith, 120)];
    noAlertView.alertLabelText = @"加载中，请稍候...";

    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 + 60, screentWith, 120)];
    nodataView.alertLabelText = @"还没有信息哦";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imgPlayerHeight:) name:@"imagePlayerViewHeightKota" object:nil];

    [imgPlayer updateBannerData];
    [userImagesView updateLayout];

    [self setupRefresh];

    //表尾，显示更多
    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 70)];
    [appDelegate addObserver:self
                  forKeyPath:@"changeCity"
                     options:0
                     context:NULL];

    locationON = ![[LocationEngine sharedLocationEngine] locationExpired];
    if (!locationON && [CLLocationManager locationServicesEnabled]) {
        [[LocationEngine sharedLocationEngine] start];
    }
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh {
    [kotaTable addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [kotaTable headerBeginRefreshing];
    kotaTable.headerPullToRefreshText = @"下拉可以刷新";
    kotaTable.headerReleaseToRefreshText = @"松开马上刷新";
    kotaTable.headerRefreshingText = @"数据加载中...";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing {
    // 1.调用刷新数据的方法
    [self refreshKotaNearUserList];
    [self refreshKotaMovieList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarLightStyle];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setStatusBarLightStyle];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    [kotaTable headerEndRefreshing];
}

// banner 高度
- (void)imgPlayerHeight:(NSNotification *)notification {
    height = [notification.userInfo[NOTIFICATION_KEY_HEIGHT] intValue];

    dispatch_async(dispatch_get_main_queue(), ^{

        CGRect frame1 = titleView.frame;

        CGRect frame2 = userImagesView.frame;

        CGRect frame3 = headerView.frame;

        if (height) {

            frame1.origin.y = height;
            frame2.origin.y = height + 45;

            [headerView addSubview:imgPlayer];

            frame3.size.height = 120 + (screentWith / 320) * 75;

        } else {

            frame1.origin.y = height;
            frame2.origin.y = CGRectGetMaxY(frame1);

            frame3.size.height = 120;
            [imgPlayer removeFromSuperview];
        }

        titleView.frame = frame1;
        userImagesView.frame = frame2;

        headerView.frame = frame3;

        [kotaTable setTableHeaderView:headerView];

    });
}

- (void)helpBtnClicked {
    KotaHelpInfoViewController *helpVc = [[KotaHelpInfoViewController alloc] init];
    [self pushViewController:helpVc animation:CommonSwitchAnimationSwipeR2L];
}

// 刷新kota
- (void)refreshKotaNearUserList {

    currentPage = 1;

    KotaTask *task = [[KotaTask alloc] initKotaNearUserListByCityId:@""
                                                               page:currentPage
                                                           finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                               [self kotaNearUserListFinished:userInfo status:succeeded];
                                                           }];

    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)showMoreKotaNesrUserList {

    currentPage++;

    KotaTask *task = [[KotaTask alloc] initKotaNearUserListByCityId:@""
                                                               page:currentPage
                                                           finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                               [self kotaNearUserListFinished:userInfo status:succeeded];
                                                           }];

    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

// 刷新kota
- (void)refreshKotaMovieList {

    if ([kotaMovieList count] == 0 && !noAlertView.superview && [kotaUserList count] == 0) {
        if (!nodataView.superview)
            [kotaTable addSubview:noAlertView];
    }
    currentPage = 1;

    KotaTask *task = [[KotaTask alloc] initKotaFilmListByCityId:@""
                                                           page:currentPage
                                                       pageSize:5
                                                       finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                           [self kotaMovieListFinished:userInfo status:succeeded];
                                                       }];

    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        if (refreshHeaderView.state != EGOOPullRefreshLoading) {
            [refreshHeaderView setState:EGOOPullRefreshLoading];

            tableLocked = YES;
        }
    }
}

#pragma mark handle notifications
- (void)kotaNearUserListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [kotaTable headerEndRefreshing];

    if (succeeded) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(reloadKotaNearUserList:)

                     withObject:userInfo

                     afterDelay:0.0f];
    } else {
        showMoreFooterView.hidden = YES;
        if (noAlertView.superview) {
            [noAlertView removeFromSuperview];
        }

        [appDelegate showAlertViewForTaskInfo:userInfo];
        [kotaTable reloadData];
    }
}

- (void)reloadKotaNearUserList:(NSDictionary *)userInfo {
    showMoreFooterView.hidden = YES;
    if (noAlertView.superview) {
        [noAlertView removeFromSuperview];
    }
    if (currentPage == 1) {
        [kotaUserList removeAllObjects];
    }

    NSArray *arr = [userInfo objectForKey:@"kotaNearUsers"];

    [kotaUserList addObjectsFromArray:arr];
    [kotaTable reloadData];
}

- (void)kotaMovieListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [kotaTable headerEndRefreshing];

    if (succeeded) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];

        [self performSelector:@selector(reloadKotaMovieList:)

                     withObject:userInfo

                     afterDelay:0.0f];

    } else {
        showMoreFooterView.hidden = YES;
        if (noAlertView.superview) {
            [noAlertView removeFromSuperview];
        }

        [appDelegate showAlertViewForTaskInfo:userInfo];
        self.view.backgroundColor = [UIColor whiteColor];
        if (kotaMovieList.count == 0 && kotaUserList.count == 0) {
            [kotaTable addSubview:nodataView];
        } else {
            [nodataView removeFromSuperview];
        }

        [kotaTable reloadData];
    }
}

- (void)reloadKotaMovieList:(NSDictionary *)userInfo {

    showMoreFooterView.hidden = YES;
    if (noAlertView.superview) {
        [noAlertView removeFromSuperview];
    }

    if (currentPage == 1) {
        [kotaMovieList removeAllObjects];
    }
    NSArray *arr = [userInfo objectForKey:@"kotaFilms"];

    [kotaMovieList addObjectsFromArray:arr];
    if (kotaMovieList.count == 0 && kotaUserList.count == 0) {
        [kotaTable addSubview:nodataView];
    } else {
        [nodataView removeFromSuperview];
    }

    [kotaTable reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"changeCity"]) {
        self.cityChanged = YES;
        [imgPlayer updateBannerData];
        [self refreshKotaNearUserList];
        [self refreshKotaMovieList];
        [userImagesView updateLayout];
    }
}

#pragma mark - Table View Data Source
- (void)configureMovieCell:(KotaMovieCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    KotaShareMovie *kotaMovie = nil;
    kotaMovie = [kotaMovieList objectAtIndex:indexPath.row];

    @try {

        cell.manNum = [NSString stringWithFormat:@"%@", kotaMovie.man];
        cell.womanNum = [NSString stringWithFormat:@"%@", kotaMovie.women];
        cell.succeedNum = [NSString stringWithFormat:@"%@", kotaMovie.successCount];
        cell.movieName = kotaMovie.movieName;
        cell.posterPath = kotaMovie.posterPath;
        [cell reloadData];

    }

    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

#pragma mark - Table View Data Source
- (void)configureCell:(KotaNearUserCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    KotaShareUser *kotaNearUser = nil;
    kotaNearUser = [kotaUserList objectAtIndex:indexPath.row];

    @try {

        cell.distance = [NSString stringWithFormat:@"%@", kotaNearUser.distance];
        cell.status = kotaNearUser.status;
        cell.shareId = [NSString stringWithFormat:@"%@", kotaNearUser.shareId];
        cell.cinemaName = kotaNearUser.cinemaName;
        cell.filmName = kotaNearUser.filmName;
        cell.shareHeadimg = kotaNearUser.shareHeadimg;
        cell.shareNickname = kotaNearUser.shareNickname;
        cell.screenDegree = kotaNearUser.screenDegree;
        cell.screenSize = kotaNearUser.screenSize;
        cell.lang = kotaNearUser.lang;

        cell.createTime = [NSString stringWithFormat:@"%@", kotaNearUser.createTime];
        cell.kotaId = kotaNearUser.kotaId;

        [cell reloadData];

    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {

        if (self.rowsNum - 1 == indexPath.row) {

            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

            sectionFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 44)];

            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, 0, screentWith, 44)];
            UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(15, 0, screentWith, 1)];

            [lineTop setBackgroundColor:[UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0]];

            UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(15, 43, screentWith, 1)];

            [lineBottom setBackgroundColor:[UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0]];

            moreBtn.titleLabel.textColor = [UIColor grayColor];
            [moreBtn setBackgroundColor:[UIColor whiteColor]];
            moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [moreBtn setTitle:@"查看更多约电影信息" forState:UIControlStateNormal];
            [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(moreMovies) forControlEvents:UIControlEventTouchUpInside];

            [sectionFooter addSubview:moreBtn];
            [sectionFooter addSubview:lineTop];
            [sectionFooter addSubview:lineBottom];

            cell.accessoryView = sectionFooter;

            return cell;
        } else {
            static NSString *CellIdentifier = @"CellIdentifier";

            KotaMovieCell *cell = (KotaMovieCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {

                cell = [[KotaMovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                UIView *view_bg = [[UIView alloc] initWithFrame:cell.frame];
                view_bg.backgroundColor = [UIColor clearColor];
                cell.selectedBackgroundView = view_bg;
            }

            [self configureMovieCell:cell atIndexPath:indexPath];

            return cell;
        }
    } else {
        static NSString *CellIdentifier = @"CellIde";

        KotaNearUserCell *cell = (KotaNearUserCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[KotaNearUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor clearColor];
            UIView *view_bg = [[UIView alloc] initWithFrame:cell.frame];
            view_bg.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = view_bg;
        }

        [self configureCell:cell atIndexPath:indexPath];

        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    int sectionNum = 0;
    if (kotaMovieList.count) {
        sectionNum += 1;
    }
    if (kotaUserList.count) {
        sectionNum += 1;
    }
    return sectionNum < 1 ? 1 : sectionNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 10, screentWith, kKotaHeaderSectionHeight)];
    [header setBackgroundColor:[UIColor whiteColor]];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kKotaHeaderSectionHeight - 1, screentWith, 1)];
    [line setBackgroundColor:kUIColorDivider];
    [header addSubview:line];

    if (section == 0) {

        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, (kKotaHeaderSectionHeight - 15) * 0.5, 15, 15)];
        imgV.image = [UIImage imageNamed:@"kotaing"];

        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, (kKotaHeaderSectionHeight - 15) * 0.5, 65, 15)];
        lab.text = @"约会进行中";
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont systemFontOfSize:kTextSizeContent];

        [header addSubview:imgV];
        [header addSubview:lab];

        RoundCornersButton *btn = [[RoundCornersButton alloc] initWithFrame:CGRectMake(screentWith - 90, (kKotaHeaderSectionHeight - 24) * 0.5, 75, 24)];
        btn.cornerNum = kDimensCornerNum;
        btn.rimColor = [UIColor redColor];
        btn.rimWidth = 1;
        btn.fillColor = [UIColor whiteColor];
        btn.titleName = @"发起约电影";
        btn.titleFont = [UIFont systemFontOfSize:kTextSizeButton];
        btn.titleColor = [UIColor redColor];
        btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;

        [btn addTarget:self action:@selector(initiateAppointmentByMovie) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:btn];
    } else {

        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, (kKotaHeaderSectionHeight - 15) * 0.5, 11, 14)];
        imgV.image = [UIImage imageNamed:@"locationIcon"];

        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(26, (kKotaHeaderSectionHeight - 15) * 0.5, 65, 15)];
        lab.text = @"离你最近";
        lab.textColor = [UIColor grayColor];
        lab.font = [UIFont systemFontOfSize:kTextSizeContent];

        [header addSubview:imgV];
        [header addSubview:lab];
    }
    return header;
}

- (void)initiateAppointmentByMovie {
    InitiateAppointmentByMovieController *Ctr = [[InitiateAppointmentByMovieController alloc] init];
    [self pushViewController:Ctr animation:CommonSwitchAnimationSwipeR2L];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        NSInteger num = kotaMovieList.count >= 5 ? 6 : kotaMovieList.count + 1;
        self.rowsNum = num;
        return num;
    } else {
        return kotaUserList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {

        if (self.rowsNum - 1 == indexPath.row) {
            return 44;
        } else
            return 120;

    } else {
        return 84;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    if (!isConnected) {
#define kLastShowAlertTime @"lastShowAlertTime"
        NSDate *lastShow = [[NSUserDefaults standardUserDefaults] objectForKey:kLastShowAlertTime];
        if (!lastShow || [lastShow timeIntervalSinceNow] < -2) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"网络好像有点问题, 稍后再试吧"
                                                               delegate:nil
                                                      cancelButtonTitle:@"好的"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastShowAlertTime];
        }
        return;
    }

    DLog(@"选择了一个cell,申请约电影");

    if (indexPath.section == 1) {

        KotaShareUser *kotaNearUser = [kotaUserList objectAtIndex:indexPath.row];

        if (![[NetworkUtil me] reachable]) {
            return;
        }

        FriendHomeViewController *ctr = [[FriendHomeViewController alloc] init];
        ctr.userId = [kotaNearUser.shareId intValue];
        [self pushViewController:ctr animation:CommonSwitchAnimationBounce];

    } else if (indexPath.section == 0) {

        KotaShareMovie *kotaMovie = nil;
        kotaMovie = [kotaMovieList objectAtIndex:indexPath.row];

        KotaMovieDetailViewController *movieDetail = [[KotaMovieDetailViewController alloc] init];
        movieDetail.movieId = [NSNumber numberWithInt:kotaMovie.filmId];
        [self pushViewController:movieDetail animation:CommonSwitchAnimationSwipeR2L];
    }
}

- (void)moreMovies {
    KotaMovieListsViewController *ctr = [[KotaMovieListsViewController alloc] init];

    [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
}

#pragma mark override from CommonViewController
- (BOOL)showNavBar {
    return NO;
}

@end
