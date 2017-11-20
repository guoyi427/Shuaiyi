//
//  约电影的详情页面
//
//  Created by avatar on 14-11-24.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommentFavViewController.h"
#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "FavoriteTask.h"
#import "InitiateAppointmentByMovieController.h"
#import "KotaListForMovieCell.h"
#import "KotaMovieDetailViewController.h"
#import "KotaShare.h"
#import "KotaTask.h"
#import "MJRefresh.h"
#import "MediaTask.h"
#import "Movie.h"
#import "MovieDBTask.h"
#import "MovieTask.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "UIConstants.h"
#import "NoDataViewY.h"

#define kFontSize 14

@interface KotaMovieDetailViewController ()

@end

@implementation KotaMovieDetailViewController

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RenewStatusApplyY" object:nil];
    kotaDetailTableView.delegate = nil;
    kotaDetailTableView.dataSource = nil;

    if (kotaDetailTableView) {
        [kotaDetailTableView removeFromSuperview];
    }

    if (sectionHeader) {
        [sectionHeader removeFromSuperview];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = self.kkzBackBtn.frame;//CGRectMake(0, 0, 60, 38);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 11, 5, 21)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backBtn];

    [self.navBarView setBackgroundColor:[UIColor clearColor]];

    self.kkzTitleLabel.text = self.movie.movieName;

    homeBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       screentWith,
                                                                       232)];
    homeBackgroundView.backgroundColor = [UIColor whiteColor];
    homeBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
    homeBackgroundView.clipsToBounds = YES;
    homeBackgroundView.image = [UIImage imageNamed:@"movie_post_bg"];

    topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, homeBackgroundView.frame.size.width, 88)];
    [topView setImage:[UIImage imageNamed:@"topCover"]];
    [homeBackgroundView addSubview:topView];

    [self.view addSubview:homeBackgroundView];
    [self.view insertSubview:homeBackgroundView atIndex:0];

    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screentWith, 220)];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.alpha = 1;

    headerTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 170)];
    headerTopView.backgroundColor = [UIColor clearColor];
    headerTopView.alpha = 1;
    [headerView addSubview:headerTopView];

    UIImageView *downShadow = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                            70,
                                                                            screentWith,
                                                                            100)];
    downShadow.backgroundColor = [UIColor clearColor]; //110.5
    downShadow.contentMode = UIViewContentModeScaleAspectFill;
    downShadow.clipsToBounds = YES;
    downShadow.image = [UIImage imageNamed:@"down_shadow_img"];
    [headerTopView addSubview:downShadow];

    postImageView = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - 80) * 0.5, 9, 80, 112)];

    postImageView.backgroundColor = [UIColor clearColor];

    postImageView.contentMode = UIViewContentModeScaleAspectFit;

    postImageView.clipsToBounds = YES;

    postImageView.hidden = NO;

    postImageView.image = nil;

    [headerTopView addSubview:postImageView];

    /////
    blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, screentWith, 50)];
    blackView.backgroundColor = [UIColor clearColor];
    blackView.alpha = 1;
    [headerTopView addSubview:blackView];

    //评分星星
    starView = [[RatingView alloc] initWithFrame:CGRectMake(10, 5, 100, 30)];
    [starView setImagesDeselected:@"fav_star_no_yellow_match"
                   partlySelected:@"fav_star_half_yellow"
                     fullSelected:@"fav_star_full_yellow"
                         iconSize:CGSizeMake(20, 20)
                      andDelegate:self];
    starView.userInteractionEnabled = NO;
    [starView displayRating:0];
    [blackView addSubview:starView];

    totleScoreLalel = [[UILabel alloc] initWithFrame:CGRectMake(120, 6.5, 55, 20)];
    totleScoreLalel.font = [UIFont systemFontOfSize:17];
    totleScoreLalel.textAlignment = NSTextAlignmentLeft;
    totleScoreLalel.backgroundColor = [UIColor clearColor];
    totleScoreLalel.textColor = [UIColor r:255 g:213 b:0];
    totleScoreLalel.text = @"10分";
    [blackView addSubview:totleScoreLalel];

    markNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 29, 90, 15)];
    markNumLabel.font = [UIFont systemFontOfSize:kFontSize];
    markNumLabel.textAlignment = NSTextAlignmentLeft;
    markNumLabel.backgroundColor = [UIColor clearColor];
    markNumLabel.textColor = [UIColor whiteColor];
    markNumLabel.text = @"0人参与";
    [blackView addSubview:markNumLabel];

    wantWathLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 29, 90, 15)];
    wantWathLabel.font = [UIFont systemFontOfSize:kFontSize];
    wantWathLabel.textAlignment = NSTextAlignmentLeft;
    wantWathLabel.backgroundColor = [UIColor clearColor];
    wantWathLabel.textColor = [UIColor whiteColor];
    wantWathLabel.text = @"10人成功约会";
    [blackView addSubview:wantWathLabel];

    CGFloat marginXY = (screentWith - 200 - 35 * 3) * 0.3;

    scoreRect = CGRectMake(200 + 35 * 2 + marginXY * 2, 0, 35, 50);
    UIView *scoreView = [[UIView alloc] initWithFrame:scoreRect];
    [blackView addSubview:scoreView];
    scoreView.backgroundColor = [UIColor clearColor];
    scoreImg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 8, 18, 18)];
    scoreImg.image = [UIImage imageNamed:@"no_score"];
    [scoreView addSubview:scoreImg];
    scoreImg.userInteractionEnabled = YES;
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, 35, 15)];
    scoreLabel.font = [UIFont systemFontOfSize:kFontSize];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.text = @"评分";
    [scoreView addSubview:scoreLabel];

    wantLookRect = CGRectMake(200 + 35 + marginXY, 0, 40, 50);
    UIView *wantView = [[UIView alloc] initWithFrame:wantLookRect];
    [blackView addSubview:wantView];
    wantView.backgroundColor = [UIColor clearColor];
    wantLookImg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 8, 18, 18)];
    wantLookImg.image = [UIImage imageNamed:@"no_want"];
    [wantView addSubview:wantLookImg];
    wantLookImg.userInteractionEnabled = YES;
    wantLookLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, 35, 15)];
    wantLookLabel.font = [UIFont systemFontOfSize:kFontSize];
    wantLookLabel.textAlignment = NSTextAlignmentCenter;
    wantLookLabel.backgroundColor = [UIColor clearColor];
    wantLookLabel.textColor = [UIColor whiteColor];
    wantLookLabel.text = @"想看";
    [wantView addSubview:wantLookLabel];

    playTrailerRect = CGRectMake(200, 0, 35, 50);
    playView = [[UIView alloc] initWithFrame:playTrailerRect];
    [blackView addSubview:playView];
    playView.backgroundColor = [UIColor clearColor];
    trailerImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 18, 18)];
    trailerImg.image = [UIImage imageNamed:@"no_movieTrailer"];
    [playView addSubview:trailerImg];
    trailerImg.userInteractionEnabled = YES;
    trailerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, 43, 15)];
    trailerLabel.font = [UIFont systemFontOfSize:kFontSize];
    trailerLabel.textAlignment = NSTextAlignmentCenter;
    trailerLabel.backgroundColor = [UIColor clearColor];
    trailerLabel.textColor = [UIColor whiteColor];
    trailerLabel.text = @"预告片";
    [playView addSubview:trailerLabel];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAcceptStatus:) name:@"RenewStatusApplyY" object:nil];
    kotaInfoList = [[NSMutableArray alloc] initWithCapacity:0];

    isDisapear = NO;

    expandedRow = -1;

    showMoreTicketBtn = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, 304, 40)];
    showMoreTicketBtn.backgroundColor = [UIColor clearColor];

    kotaDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)
                                                       style:UITableViewStyleGrouped];
    kotaDetailTableView.delegate = self;
    kotaDetailTableView.dataSource = self;
    kotaDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    kotaDetailTableView.backgroundView = nil;
    kotaDetailTableView.showsVerticalScrollIndicator = NO;
    kotaDetailTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:kotaDetailTableView];

    kotaDetailTableView.tableHeaderView = headerView;

    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 40)];
    kotaDetailTableView.tableFooterView = showMoreFooterView;

    sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 170, screentWith, 55)];

    sectionHeader.backgroundColor = [UIColor r:245 g:245 b:245];

    [headerView addSubview:sectionHeader];

    kotaList = [NSMutableArray arrayWithCapacity:0];
    self.type = @3;

    currentPage = 0;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [blackView addGestureRecognizer:tap];

    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 + 40, screentWith, 120)];

    noAlertView.alertLabelText = @"加载中，请稍候...";

    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 + 40, screentWith, 120)];
    nodataView.alertLabelText = @"还没有信息哦";

    [self refreshKotaNearUserList];

    NSArray *segementArr = @[ @{ @"text" : @"全部" }, @{ @"text" : @"男生" }, @{ @"text" : @"女生" } ];

    __weak typeof(self) weakSelf = self;

    // 切换

    chooseSegmentView = [[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(kDimensControllerHPadding, 10, screentWith - kDimensControllerHPadding * 2, 35)
                                                                 items:segementArr
                                                          iconPosition:IconPositionRight
                                                                 color:kUIColorOrange
                                                     andSelectionBlock:^(NSUInteger segmentIndex) {

                                                         [weakSelf didSelectSegmentAtIndex:segmentIndex];

                                                     }];

    chooseSegmentView.color = [UIColor whiteColor];
    chooseSegmentView.selectionColor = appDelegate.kkzBlue;
    [chooseSegmentView updateSegmentsFormat];
    [sectionHeader addSubview:chooseSegmentView];

    [self refreshMovieDetail]; //查询电影详情
    [self refreshMovieTrailer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];

    if (appDelegate.isAuthorized) {
        [self refreshFavScore];
        [self refreshFavNum];
        [self refreshSucceedNum];
        [self refreshWantWatch];
    }
}

- (void)updateAcceptStatus:(NSNotification *)notification {
}

#pragma mark - Table View Data Source
- (void)configureCell:(KotaListForMovieCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    KotaShare *kota = nil;
    kota = [kotaList objectAtIndex:indexPath.row];

    self.indexPRow = indexPath.row;

    @try {

        cell.kota = kota;
        cell.myAppointment = self.myAppointMent;

        [cell reloadData];

    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";

    KotaListForMovieCell *cell = (KotaListForMovieCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KotaListForMovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kotaList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 198;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)cancelViewController {
    [self popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    isDisapear = YES;
}

- (void)didSelectSegmentAtIndex:(NSInteger)index {
    if (index == 0) {
        self.myAppointMent = NO;
        self.type = @3;
        [self refreshKotaNearUserList];
        kotaDetailTableView.hidden = NO;

    } else if (index == 1) {
        self.myAppointMent = NO;
        self.type = @1;
        [self refreshKotaNearUserList];
        kotaDetailTableView.hidden = NO;
    } else if (index == 2) {
        self.myAppointMent = NO;
        self.type = @0;
        [self refreshKotaNearUserList];
        kotaDetailTableView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)showMoreKotaList {

    currentPage++;

    if (self.myAppointMent) {

        KotaTask *task = [[KotaTask alloc] initKotaMyAppointmentAndPage:currentPage
                                                               finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                   [self kotaListFinished:userInfo status:succeeded];

                                                               }];

        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        }
    } else {

        KotaTask *task = [[KotaTask alloc] initKotaListByMovieId:[self.movieId intValue]
                                                         andType:[NSString stringWithFormat:@"%@", self.type]
                                                            page:currentPage
                                                        finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                            [self kotaListFinished:userInfo status:succeeded];

                                                        }];

        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        }
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGRect frame = homeBackgroundView.frame;

    if (scrollView.contentOffset.y < 0) {
        frame.origin.x = scrollView.contentOffset.y / 2.0;
        frame.size.height = 232 - scrollView.contentOffset.y;
        frame.size.width = screentWith - scrollView.contentOffset.y;
        movieTitleLabel.textColor = [UIColor whiteColor];

        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 11, 5, 21)];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];

        //设置导航栏背景色
        self.navBarView.backgroundColor = [UIColor clearColor];
        self.statusView.backgroundColor = [UIColor clearColor];

    } else if (scrollView.contentOffset.y < 232 - self.contentPositionY - 44) {

        frame.size.height = 232 - scrollView.contentOffset.y;
        movieTitleLabel.textColor = [UIColor whiteColor];

        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 11, 5, 21)];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];

        //设置导航栏背景色
        self.navBarView.backgroundColor = [UIColor clearColor];
        self.statusView.backgroundColor = [UIColor clearColor];
    } else {

        frame.size.height = 0;

        movieTitleLabel.textColor = [UIColor blackColor];

        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
        [backBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];

        //设置导航栏背景色
//        self.navBarView.backgroundColor = appDelegate.kkzBlue;
//        self.statusView.backgroundColor = appDelegate.kkzBlue;
    }

    homeBackgroundView.frame = frame;

    CGRect frame1 = topView.frame;
    frame1.size.width = frame.size.width;
    topView.frame = frame1;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (scrollView.contentOffset.y < -65.0f) {
        [self refreshKotaNearUserList];
    }

    if (scrollView.contentOffset.y + scrollView.frame.size.height

                - scrollView.contentInset.bottom - scrollView.contentSize.height >=
        45) {

        if (!showMoreFooterView.isLoading

            && !showMoreFooterView.hasNoMore) {

            showMoreFooterView.isLoading = YES;

            [self showMoreKotaList];
        }
    }
}

- (void)kotaListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {

    [appDelegate hideIndicator];

    [noAlertView removeFromSuperview];

    showMoreFooterView.isLoading = NO;

    if (currentPage == 1) {

        [kotaList removeAllObjects];
    }
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态

    [kotaDetailTableView footerEndRefreshing];

    if (succeeded) {

        BOOL hasMore = [[userInfo objectForKey:@"hasMore"] boolValue];
        NSArray *arr = [userInfo objectForKey:@"kotaList"];

        if (hasMore)

        {
            showMoreFooterView.hasNoMore = NO;
            kotaDetailTableView.footerHidden = NO;

        } else {
            showMoreFooterView.hasNoMore = YES;
            kotaDetailTableView.footerHidden = YES;
        }

        self.view.backgroundColor = [UIColor whiteColor];

        [kotaList addObjectsFromArray:arr];

        [kotaDetailTableView reloadData];

    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];

        self.view.backgroundColor = [UIColor whiteColor];

        currentPage--;
    }

    if (kotaList.count == 0) {
        [kotaDetailTableView addSubview:nodataView];
        showMoreFooterView.hidden = YES;
    } else {
        [nodataView removeFromSuperview];
        showMoreFooterView.hidden = NO;
    }
}

//刷新kota
- (void)refreshKotaNearUserList {

    currentPage = 1;

    [nodataView removeFromSuperview];
    if (kotaList.count == 0) {
        [kotaDetailTableView addSubview:noAlertView];
    }

    KotaTask *task = [[KotaTask alloc] initKotaListByMovieId:[self.movieId intValue]
                                                     andType:[NSString stringWithFormat:@"%@", self.type]
                                                        page:currentPage
                                                    finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                        [self kotaListFinished:userInfo status:succeeded];

                                                    }];

    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

//我的约会
- (void)refreshKotaMyAppointmentList {

    currentPage = 1;

    KotaTask *task = [[KotaTask alloc] initKotaMyAppointmentAndPage:currentPage
                                                           finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                               [self kotaListFinished:userInfo status:succeeded];

                                                           }];

    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)ratingChanged:(CGFloat)newRating {
}

- (void)refreshMovieDetail {

    MovieRequest *request = [MovieRequest new];
    [request requestMovieDetailWithMovieId:self.movieId.integerValue
            success:^(id _Nullable movieDetail) {
                self.movie = movieDetail;
                [starView displayRating:[self.movie.score floatValue] / 2.0];

                if (self.movie.appBigPost.length > 0 && ![self.movie.appBigPost isEqualToString:@"(null)"]) {

                    [homeBackgroundView loadImageWithURL:self.movie.appBigPost andSize:ImageSizeMiddle imgNameDefault:@"movie_post_bg"];

                    postImageViewBg.hidden = YES;

                    postImageView.hidden = YES;

                } else {

                    if (self.movie.thumbPath.length) {
                        [postImageView loadImageWithURL:self.movie.thumbPath andSize:ImageSizeSmall imgNameDefault:@"post_black_shadow"];
                    } else {

                        [postImageView loadImageWithURL:self.movie.pathVerticalS andSize:ImageSizeSmall imgNameDefault:@"post_black_shadow"];
                    }

                    postImageViewBg.hidden = NO;

                    postImageView.hidden = NO;
                }

                totleScoreLalel.text = [NSString stringWithFormat:@"%.1f分", [self.movie.score floatValue]];
                movieTitleLabel.text = self.movie.movieName;
            }
            failure:^(NSError *_Nullable err){

            }];
}

//刷新评分，收藏
- (void)refreshFavScore {

    MovieDBTask *task = [[MovieDBTask alloc] initQueryFavForMovie:[self.movieId intValue]
                                                         finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                             if (succeeded) {
                                                                 scoreLabel.textColor = [UIColor r:255 g:105 b:0];
                                                                 scoreImg.image = [UIImage imageNamed:@"light_score"];
                                                             } else {
                                                                 scoreLabel.textColor = [UIColor whiteColor];
                                                                 scoreImg.image = [UIImage imageNamed:@"no_score"];
                                                             }

                                                         }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

//刷新评分数量
- (void)refreshFavNum {
}

//成功约会
- (void)refreshSucceedNum {

    FavoriteTask *task = [[FavoriteTask alloc] initQuerySucceedNumWithMovieId:[self.movieId intValue]
                                                                     finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                                         if (succeeded) {
                                                                             markNumLabel.text = [NSString stringWithFormat:@"%d人参与", [userInfo[@"numActive"] intValue]];
                                                                             wantWathLabel.text = [NSString stringWithFormat:@"%d人成功约会", [userInfo[@"num"] intValue]];
                                                                         }

                                                                     }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)refreshMovieTrailer {

    MediaTask *task = [[MediaTask alloc] initMedia:[self.movieId intValue]
                                         mediaType:MediaTypeMovieTrailer
                                          finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                              [self movieTrailerFinished:userInfo status:succeeded];
                                          }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)movieTrailerFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {
        self.movieTrailer = (MovieTrailer *) [userInfo objectForKey:@"movieTrailer"];
        if (self.movieTrailer.trailerPath.length > 0) {

        } else {
        }
    }
}

- (void)doWantSeeMovie {

    FavoriteTask *task = [[FavoriteTask alloc] initClickWantWatchWithMovieId:[self.movieId intValue]
                                                                    finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                                        //        effictiveClick = YES;

                                                                        if (succeeded) {

                                                                            [appDelegate hideIndicator];

                                                                            wantLookLabel.textColor = [UIColor r:255 g:105 b:0];

                                                                            wantLookImg.image = [UIImage imageNamed:@"light_wanted"];

                                                                            RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"完成"];

                                                                            cancel.action = ^{

                                                                            };

                                                                            RIButtonItem *done = [RIButtonItem itemWithLabel:@"发起约电影"];

                                                                            done.action = ^{

                                                                                InitiateAppointmentByMovieController *ctr = [[InitiateAppointmentByMovieController alloc] init];

                                                                                ctr.wantSee = YES;

                                                                                ctr.movie = self.movie;

                                                                                [self pushViewController:ctr animation:CommonSwitchAnimationBounce];

                                                                                DLog(@"现在马上发起约电影");

                                                                            };

                                                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil

                                                                                                                            message:@"操作成功，是否发起约电影？"

                                                                                                                   cancelButtonItem:cancel

                                                                                                                   otherButtonItems:done, nil];

                                                                            [alert show];
                                                                        }

                                                                    }];

    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {

    CGPoint point = [gesture locationInView:blackView];

    [self touchAtPoint:point];
}

- (void)touchAtPoint:(CGPoint)point {

    if (CGRectContainsPoint(scoreRect, point)) {
        if (!appDelegate.isAuthorized) {
            [[DataEngine sharedDataEngine] startLoginFinished:^(BOOL succeeded) {
                [self doCollectMovie];
            }
                                               withController:self];
        } else {
            [self doCollectMovie];
        }
    }

    if (CGRectContainsPoint(wantLookRect, point)) {
        if (!appDelegate.isAuthorized) {
            [[DataEngine sharedDataEngine] startLoginFinished:^(BOOL succeeded) {
                [self doWantSeeMovie];
            }
                                               withController:self];
        } else {
            [self doWantSeeMovie];
        }
    }

    if (CGRectContainsPoint(playTrailerRect, point)) {

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

        if (self.movieTrailer.trailerPath.length != 0 && ![self.movieTrailer.trailerPath isEqualToString:@"(null)"]) {
            [self startShowMovieTrailer:self.movieTrailer.trailerPath];
        } else {
            [self showMovieTrailerError];
        }
    }
}

- (void)doCollectMovie {
    if (!appDelegate.isAuthorized) {
        [[DataEngine sharedDataEngine] startLoginFinished:nil withController:self];
        return;
    }
    CommentFavViewController *cfv = [[CommentFavViewController alloc] init];
    cfv.titleName = @"发表影评";
    cfv.buttonTitle = @"发表影评";
    cfv.targetId = [self.movieId intValue];
    cfv.showStar = YES;
    cfv.isCollect = YES;
    cfv.MovieComment = YES;

    __weak typeof(self) weakSelf = self;

    cfv.collectFinished = ^(BOOL succeed, NSDictionary *dict) {
        if (succeed) {
            scoreLabel.textColor = [UIColor r:255 g:105 b:0];
            scoreImg.image = [UIImage imageNamed:@"light_score"];

            [weakSelf refreshFavNum];
        }
    };

    [self pushViewController:cfv animation:ViewSwitchAnimationBounce];
}

- (void)startShowMovieTrailer:(NSString *)url {

    movieVC = [[MoviePlayerViewController alloc] initNetworkMoviePlayerViewControllerWithURL:[NSURL URLWithString:url] movieTitle:self.movie.movieName];
    movieVC.delegate = self;

    [movieVC playerViewDelegateSetStatusBarHiden:NO];

    UIScreen *scr = [UIScreen mainScreen];
    movieVC.view.frame = CGRectMake(0, 0, screentHeight, scr.bounds.size.width);

    CGAffineTransform landscapeTransform;
    landscapeTransform = CGAffineTransformMakeRotation(90 * M_PI / 180);
    CGFloat landscapeTransformX = 0;
    if (screentHeight == 480) {

        landscapeTransformX = 80;

    } else if (screentHeight == 667) {
        landscapeTransformX = 146;

    } else if (screentHeight == 568) {
        landscapeTransformX = 124;
    } else if (screentHeight == 736) {
        landscapeTransformX = 161;
    }
    landscapeTransform = CGAffineTransformTranslate(landscapeTransform, landscapeTransformX, landscapeTransformX);

    [movieVC.view setTransform:landscapeTransform];
    [appDelegate.window addSubview:movieVC.view];
}

- (void)showMovieTrailerError {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"小编还没有找到预告片，请过段时间再来~" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    [alertView show];
}

- (void)movieFinishedCallback:(NSNotification *)aNotification {
    NSNumber *reason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded: {
            DLog(@"playbackFinished. Reason: Playback Ended");
            vedioPlayer = [aNotification object];

            [vedioPlayer stop];

            [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:vedioPlayer];
            [vedioPlayer.view removeFromSuperview];
            vedioPlayer = nil;
            self.playerViewController = nil;
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];

            break;
        }

        case MPMovieFinishReasonPlaybackError: {
            DLog(@"playbackFinished. Reason: Playback Error");

            vedioPlayer = [aNotification object];

            [vedioPlayer stop];

            [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:vedioPlayer];
            vedioPlayer.view.hidden = YES; //error时候，只能用hidden不能用removeFromSuperview.
            vedioPlayer = nil;
            self.playerViewController = nil;

            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];

            [self performSelector:@selector(showMovieTrailerError) withObject:self afterDelay:.3];
            break;
        }

        case MPMovieFinishReasonUserExited: {
            DLog(@"playbackFinished. Reason: User Exited");

            vedioPlayer = [aNotification object];

            [vedioPlayer stop];

            [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:vedioPlayer];
            vedioPlayer.view.hidden = YES; //有可能是先error，后exited，所以hidden，不removeFromSuperview.

            //            [vedioPlayer.view removeFromSuperview];
            vedioPlayer = nil;
            self.playerViewController = nil;
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];

            break;
        }
        default: {
            break;
        }
    }
}

//刷新想看

- (void)refreshWantWatch {

    FavoriteTask *task = [[FavoriteTask alloc] initQueryWantWatchWithMovieId:[self.movieId intValue]
                                                                    finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                                        if (succeeded) {

                                                                            if ([userInfo[@"tag"] intValue] == 0) {

                                                                                wantLookLabel.textColor = [UIColor whiteColor];

                                                                                wantLookImg.image = [UIImage imageNamed:@"no_want"];

                                                                            } else {

                                                                                wantLookLabel.textColor = [UIColor r:255 g:105 b:0];

                                                                                wantLookImg.image = [UIImage imageNamed:@"light_wanted"];
                                                                            }
                                                                        }

                                                                    }];

    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)movieFinished:(CGFloat)progress {

    [movieVC.view removeFromSuperview];
}

#pragma mark override from CommonViewController

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return TRUE;
}

- (BOOL)isNavMainColor {
    return NO;
}

@end
