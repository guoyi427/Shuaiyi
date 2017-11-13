//
//  电影详情页面 - 选座购票 - 影院列表
//
//  Created by KKZ on 16/2/18.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//
//  TODO 页面重构，精简、拆分代码

#import "ActorCell.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "ImageEngineNew.h"
#import "Movie.h"
#import "Movie.h"
#import "MovieDBTask.h"
#import "MovieDetailHeadView.h"
#import "MovieDetailHeader.h"
#import "MovieDetailViewController.h"
#import "MovieHobbyViewCell.h"
#import "MovieTask.h"
#import "ShareView.h"
#import "TaskQueue.h"
#import "WebViewController.h"

#import "ActorListViewController.h"
#import "SoundtrackViewController.h"
#import "StillsWaterFlowViewController.h"

#import "ClubTypeOneCell.h"
#import "ClubTypeTowCell.h"
#import "MediaTask.h"
#import "MovieIntroCell.h"
#import "MovieMediaStoreCell.h"
#import "MovieSupportCell.h"
#import "MovieTrailer.h"

#import "ClubPostPictureViewController.h"
#import "Gallery.h"
#import "Movie.h"
#import "Movie.h"
#import "MovieHobbyModel.h"
#import "CPMovieComment.h"

#import "ClubViewController.h"

#import "ClubTask.h"
#import "TaskQueue.h"

#import "ClubPost.h"
//#import "KKZUser.h"
#import "MovieHotCommentController.h"

#import "MovieTrailerListViewController.h"

#import "ClubPlate.h"
#import "PostPlateCell.h"

#import "EGORefreshTableHeaderView.h"
#import "PlatePostListController.h"

#import "KKZUtility.h"
#import "KoMovie-Swift.h"
#import "UserScoreMovieViewController.h"

#define marginX 15

#define headHeight 215
#define homeBgHeight 279

#define moreFooterView 60
#define checkMoreBtnFont 14
#define moviePhotoGalleryCellHeight 72

#define actorCellHeight 165
#define movieHobbyViewCellHeight 100
#define supportCellHeight 60
#define PictureMoreFooterView 55

#define MovieSupportCellHeight 147

#define wordHeight1 46
#define wordHeight2 21
#define wordH 30

#define cellHeight1 226
#define cellHeight2 201

#define cellOnlyWordHeight1 126
#define cellOnlyWordHeight2 100

#define wordFont 17

@interface MovieDetailViewController () {
    EGORefreshTableHeaderView *refreshHeaderView;
    
    UIButton *_moreHotCommentButton;
    UILabel *_tableFooterNullLabel;
    UIView *_tableFooterScoreView;
    UIImageView *_tableFooterPostImageView;
    RatingView *_scoreRatingView;
}

/**
 *  电影列表
 */
@property (nonatomic, strong) NSMutableArray *movieTrailerArray;

/**
 *  电影数量
 */
@property (nonatomic, assign) NSInteger movieTrailerTotal;

/**
 *  电影音乐列表
 */
@property (nonatomic, strong) NSMutableArray *movieSongArray;

/**
 *  电影音乐数量
 */
@property (nonatomic, assign) NSInteger movieSongTotal;

/**
 *  剧照列表
 */
@property (nonatomic, strong) NSMutableArray *movieGalleryArray;

/**
 *  电影剧照数量
 */
@property (nonatomic, assign) NSInteger movieGalleryTotal;
/**
 *  影片id
 */
@property (nonatomic, copy) NSNumber *movieId;

@property (nonatomic, assign) BOOL noMore;

@end

@implementation MovieDetailViewController

- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    self = [super init];
    if (self) {
        if (extra1) {
            self.movieId = [extra1 toNumber];
        }
    }
    return self;
}


- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SubscribePostSucceedMovieDetail" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isPostDeleteComplete" object:nil];
}

- (id)initCinemaListForMovie:(NSNumber *)movieId {
    self = [super init];
    if (self) {
        self.movieId = movieId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置背景色
    [self setViewBgColor];

    //添加导航栏
    [self addNavView];
    //添加电影详情的table
    [self addDetailTable];

    //添加购票按钮
    [self addBuyTicketView];

    self.clubPosts = [[NSMutableArray alloc] initWithCapacity:0];
    self.movieGalleryArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.movieSongArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.movieTrailerArray = [[NSMutableArray alloc] initWithCapacity:0];

    //加载数据
    [self loadMovieDetail];
    [self callMovieDetailApiDidSucceed:self.movie];
    [self loadMovieHobby]; //周边
    [self loadMediaLibrary];
    [self loadActorList];

    [self loadMovieSupport]; //喜欢 不喜欢 情况
    currentPage = 1;
    [self loadMovieHotCommentList]; //热门吐槽

    //社区板块
    [self loadMoviePlateList];

    //社区精华帖子
    [self loadMoviePostList];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subscribePostSucceed:) name:@"SubscribePostSucceedMovieDetail" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deletePostComplete:)
                                                 name:@"isPostDeleteComplete"
                                               object:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [KKZAnalytics postActionWithEvent:[[KKZAnalyticsEvent alloc]initWithMovie:self.movie] action:AnalyticsActionFilm_details];
    if ([[UserManager shareInstance] isUserAuthorized]) {
        //  用户评分
        [self loadUserScore];
    } else {
        _tableFooterNullLabel.hidden = false;
        _tableFooterScoreView.hidden = true;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isMoviedetailCanbeclickedPop" object:nil];
}

- (void)deletePostComplete:(NSNotification *) not{
    NSNumber *artId = not.userInfo[@"articleId"];

    ClubPost *post = [ClubPost getClubPostWithArticleId:artId fromArray:self.clubPosts];
    if (post) {
        [self.clubPosts removeObject:post];
    }

    [movieDetailTable reloadData];
}

- (void)subscribePostSucceed:(NSNotification *) not{

    ClubPost *post = not.userInfo[@"SubscribeClubPost"];
    if (post) {
        [self.clubPosts addObject:post];
        [movieDetailTable reloadData];
    }
}

/**
 *  设置背景色
 */
- (void)setViewBgColor {
    [self.view setBackgroundColor:[UIColor whiteColor]];

    homeBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screentWith, homeBgHeight)];
    homeBackgroundView.backgroundColor = [UIColor clearColor];
    homeBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
    homeBackgroundView.clipsToBounds = YES;
    [self.view addSubview:homeBackgroundView];

    homeBgCover = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screentWith, homeBgHeight)];
    [homeBgCover setBackgroundColor:[UIColor r:0 g:0 b:0 alpha:0.5]];

    [homeBackgroundView addSubview:homeBgCover];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = homeBackgroundView.bounds;
    [homeBackgroundView addSubview:effectView];
    

    if (self.movie.thumbPath.length) {
        self.urlStr = self.movie.thumbPath;
    } else {
        self.urlStr = self.movie.pathVerticalS;
    }

    NSString *url = [NSString stringWithFormat:@"%@", self.urlStr];

    UIImage *newImg = [[ImageEngineNew sharedImageEngineNew] getImageFromDiskForURL:[url MD5String] andSize:ImageSizeOrign];
    if (newImg) {
        homeBackgroundView.image = newImg;
        homeBgCover.image = nil;
    } else {
        homeBgCover.image = [UIImage imageNamed:@"movie_post_bg"];
    }
}

/**
 *  添加购票按钮
 */
- (void)addBuyTicketView {
    UIButton *buyTicketBtn = [[UIButton alloc] initWithFrame:CGRectMake(150-75, screentHeight - 50, screentWith-150+75, 50)];//CGRectMake(150, screentHeight - 50, screentWith-150, 50)];
    [buyTicketBtn setBackgroundImage:[UIImage imageNamed:@"Pay_paybutton"] forState:UIControlStateNormal];
    if (_isCommingSoon) {
        [buyTicketBtn setTitle:@"等待拍片" forState:UIControlStateNormal];
        buyTicketBtn.enabled = false;
//        buyTicketBtn.frame = CGRectMake(150-75, screentHeight - 50, screentWith-150+75, 50);
    } else {
        [buyTicketBtn setTitle:@"选座购票" forState:UIControlStateNormal];
        buyTicketBtn.enabled = true;
    }
    [buyTicketBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyTicketBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [buyTicketBtn addTarget:self action:@selector(buyTicketBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyTicketBtn];
    
    UIButton *relationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    relationButton.frame = CGRectMake(0, screentHeight - 50, 75, 50);
    [relationButton setTitle:@"想看" forState:UIControlStateNormal];
    [relationButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    relationButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [relationButton setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 20)];
    [relationButton setImage:[UIImage imageNamed:@"MovieDetail_Relation"] forState:UIControlStateNormal];
    [relationButton setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 15, 0)];
    [relationButton addTarget:self action:@selector(relationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:relationButton];
}

- (void)buyTicketBtnClicked {
    //统计事件：【购票】电影入口-点击选座购票
    StatisEvent(EVENT_BUY_ENTER_CHOOSE_CINEMA_SOURCE_MOVIE);

    MovieCinemaListController *ctr = [[MovieCinemaListController alloc] init];
    ctr.movieId = self.movieId;
    ctr.movie = self.movie;
    [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
}

- (void)relationButtonAction:(UIButton *)button {
    button.selected = !button.isSelected;
    MovieRequest *request = [[MovieRequest alloc] init];
    [request addRelationMovieId:[NSString stringWithFormat:@"%@", _movieId] relation:[NSString stringWithFormat:@"%d", button.isSelected] success:^{
        [UIAlertView showAlertView:button.isSelected?@"喜欢成功":@"取消喜欢成功" buttonText:@"确定"];
    } failure:^(NSError * _Nullable err) {
        [appDelegate showAlertViewForRequestInfo:err.userInfo];
    }];
}

- (void)scoreButtonAction {
    
}

/**
 *  添加电影详情的table
 */
- (void)addDetailTable {
    movieDetailTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44 - 50)
                                                    style:UITableViewStyleGrouped];
    movieDetailTable.delegate = self;
    movieDetailTable.dataSource = self;
    movieDetailTable.backgroundColor = [UIColor clearColor];
    movieDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [movieDetailTable registerClass:[MovieDetailCommentCell class] forCellReuseIdentifier:@"hot_comment_cell"];
    [self.view addSubview:movieDetailTable];

    self.movieDetailTableY = movieDetailTable;

    [self addTableHead];
    [self addTableFooter];
    
    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                    0.0f - movieDetailTable.bounds.size.height,
                                                                                    screentWith,
                                                                                    movieDetailTable.bounds.size.height)];
    [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];
    [refreshHeaderView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [movieDetailTable addSubview:refreshHeaderView];
    
    WeakSelf;
    [movieDetailTable addFooterWithCallback:^{
        if (refreshHeaderView.state != EGOOPullRefreshLoading) {
            if (weakSelf.noMore) {
                [weakSelf.movieDetailTableY footerEndRefreshing];
                return;
            }
            if (weakSelf.clubPosts.count % 5 == 0) {
                currentPage = weakSelf.clubPosts.count / 5 + 1;
            } else {
                currentPage = weakSelf.clubPosts.count / 5 + 2;
            }
            [weakSelf loadMovieHotCommentList];
        }
    }];
}

/**
 *  添加tableheadview
 */
- (void)addTableHead {
    movieDetailHeadView = [[MovieDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 245-64)];
    movieDetailTable.tableHeaderView = movieDetailHeadView;
    [movieDetailHeadView wantToWatch:^{
        KKZAnalyticsEvent *event = [KKZAnalyticsEvent new];
        event.movie_id = self.movie.movieId.stringValue;
        event.movie_name = self.movie.movieName;
        [KKZAnalytics postActionWithEvent:event action:AnalyticsActionAttention_film];
    }];
}

- (void)addTableFooter {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 100)];
    footerView.backgroundColor = [UIColor whiteColor];
    movieDetailTable.tableFooterView = footerView;
    
    _tableFooterNullLabel = [[UILabel alloc] init];
    _tableFooterNullLabel.text = @"还没有评分\n快去评分吧 >";
    _tableFooterNullLabel.textColor = appDelegate.kkzGray;
    _tableFooterNullLabel.font = [UIFont systemFontOfSize:15];
    _tableFooterNullLabel.numberOfLines = 0;
    _tableFooterNullLabel.hidden = true;
    _tableFooterNullLabel.userInteractionEnabled = true;
    [footerView addSubview:_tableFooterNullLabel];
    [_tableFooterNullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(footerView);
    }];
    
    UITapGestureRecognizer *tapScoreLabelGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userScoreButtonAction)];
    [_tableFooterNullLabel addGestureRecognizer:tapScoreLabelGR];
    
    _tableFooterScoreView = [[UILabel alloc] init];
    _tableFooterScoreView.backgroundColor = [UIColor whiteColor];
    _tableFooterScoreView.hidden = true;
    [footerView addSubview:_tableFooterScoreView];
    [_tableFooterScoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerView);
    }];
    
    _tableFooterPostImageView = [[UIImageView alloc] init];
    _tableFooterPostImageView.layer.cornerRadius = 5.0;
    _tableFooterPostImageView.layer.masksToBounds = true;
    _tableFooterPostImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_tableFooterPostImageView sd_setImageWithURL:[NSURL URLWithString:self.movie.pathVerticalS]];
    [_tableFooterScoreView addSubview:_tableFooterPostImageView];
    [_tableFooterPostImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(_tableFooterScoreView);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.text = @"评分:";
    scoreLabel.textColor = [UIColor blackColor];
    scoreLabel.font = [UIFont systemFontOfSize:12];
    [_tableFooterScoreView addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tableFooterPostImageView.mas_right).offset(15);
        make.centerY.equalTo(_tableFooterPostImageView);
    }];
    
    _scoreRatingView = [[RatingView alloc] init];
    [_scoreRatingView setImagesDeselected:@"fav_star_no_yellow_match"
                     partlySelected:@"fav_star_half_yellow"
                       fullSelected:@"fav_star_full_yellow"
                           iconSize:CGSizeMake(30, 30)
                        andDelegate:nil];
    _scoreRatingView.userInteractionEnabled = false;
    [_tableFooterScoreView addSubview:_scoreRatingView];
    [_scoreRatingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(scoreLabel.mas_right).offset(5);
        make.centerY.equalTo(_tableFooterPostImageView);
        make.height.mas_equalTo(30);
        make.width.equalTo(footerView).offset(-80);
    }];
}

/**
 *  添加导航栏
 */
- (void)addNavView {
    [self.navBarView setBackgroundColor:[UIColor clearColor]];

    self.kkzTitleLabel.text = self.movie.movieName;
    self.kkzTitleLabel.hidden = YES;

    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    backBtn.frame = CGRectMake(0, 3, 60, 38);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)]; //11 * 20
    [backBtn setImage:[UIImage imageNamed:@"movieComment_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backBtn];

    /*
    //右边分享按钮
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(screentWith - 60, 0, 60, 40);
    [rightBtn setImage:[UIImage imageNamed:@"cinema_Ticket_share"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 25, 10, 15)];
    [rightBtn addTarget:self action:@selector(shareMovieMassage) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:rightBtn];

    if (!THIRD_LOGIN) {
        rightBtn.hidden = YES;
    } else {
        rightBtn.hidden = NO;
    }
     */
}

/**
 *  分享影片信息
 */
- (void)shareMovieMassage {

    ShareView *poplistview = [[ShareView alloc] initWithFrame:CGRectMake(0, screentHeight - 200, screentWith, 200)];
    poplistview.userShareInfo = @"movieInfo";
    NSString *shareUrl = nil;
    if ([DataEngine sharedDataEngine].userId && [[DataEngine sharedDataEngine].userId length]) {
        shareUrl = [NSString stringWithFormat:@"%@&type=%@&userId=%@&targetId=%@", kAppShareHTML5Url, @"3", [DataEngine sharedDataEngine].userId, self.movieId.stringValue];
    } else {
        shareUrl = [NSString stringWithFormat:@"%@&type=%@&targetId=%@", kAppShareHTML5Url, @"3", self.movieId.stringValue];
    }

    NSString *date = [[DateEngine sharedDateEngine] stringFromDateYYYYMMDD:self.movie.publishTime];
    NSString *content = [NSString stringWithFormat:@"分享电影《%@》%.1f分 %@上映，查看详情:%@。更多精彩，尽在【抠电影客户端】。", self.movie.movieName, [self.movie.score floatValue], date, shareUrl];
    NSString *contentWeChat = [NSString stringWithFormat:@"分享电影《%@》%.1f分 %@上映。", self.movie.movieName, [self.movie.score floatValue], date];
    NSString *contentQQSpace = [NSString stringWithFormat:@"分享电影《%@》%.1f分 %@上映。", self.movie.movieName, [self.movie.score floatValue], date];
    NSString *str;

    if (self.movie.thumbPath.length) {
        str = self.movie.thumbPath;
    } else {
        str = self.movie.pathVerticalS;
    }

    [movieDetailHeadView.postImageView loadImageWithURL:str
                                                andSize:ImageSizeSmall
                                               finished:^{
                                                   //评分信息，影片海报，我的文字或者语音评论信息等以及抠电影的下载信息
                                                   [poplistview updateWithcontent:content
                                                                    contentWeChat:contentWeChat
                                                                   contentQQSpace:contentQQSpace
                                                                            title:@"一起来观影" //"抠电影"
                                                                        imagePath:self.postImage.image
                                                                         imageURL:str
                                                                              url:shareUrl
                                                                         soundUrl:nil
                                                                         delegate:appDelegate
                                                                        mediaType:SSPublishContentMediaTypeNews
                                                                   statisticsType:StatisticsTypeMovie
                                                                        shareInfo:[NSString stringWithFormat:@"%ld", (long) self.movie.movieId]
                                                                        sharedUid:[DataEngine sharedDataEngine].userId];

                                                   [poplistview show];

                                               }];
}

//返回
- (void)cancelViewController {
    [self popViewControllerAnimated:YES];
}

#pragma mark - UIButton - Action

- (void)userScoreButtonAction {
    if (![[UserManager shareInstance] isUserAuthorized]) {
        [[UserManager shareInstance] gotoLoginControllerFrom:self];
        return;
    }
    
    if (self.movie) {
        UserScoreMovieViewController *vc = [[UserScoreMovieViewController alloc] init];
        vc.model = self.movie;
        [self.navigationController pushViewController:vc animated:true];
    }
}

#pragma mark - 加载影片详情数据
- (void)loadMovieDetail {

    WeakSelf
            MovieRequest *movieRequest = [[MovieRequest alloc] init];
    [movieRequest requestMovieDetailWithMovieId:self.movieId.integerValue
            success:^(id movieDetail) {

                [weakSelf callMovieDetailApiDidSucceed:movieDetail];

            }
            failure:^(NSError *_Nullable err) {
                [weakSelf callMovieDetailApiDidFailed:err];
            }];
}

- (void)callMovieDetailApiDidSucceed:(id)responseData {
    self.movie = responseData;

    //设置背景图片
//    if (self.movie.thumbPath.length) {
//        self.urlStr = self.movie.thumbPath;
//    } else {
        self.urlStr = self.movie.pathVerticalS;
//    }

//    NSString *url = [NSString stringWithFormat:@"movieDetail%@", self.urlStr];
//
//    UIImage *newImg = [[ImageEngineNew sharedImageEngineNew] getImageFromDiskForURL:[url MD5String] andSize:ImageSizeOrign];

    [homeBackgroundView sd_setImageWithURL:[NSURL URLWithString:self.urlStr]];
    if (self.urlStr) {
        homeBgCover.image = nil;
    }
//    if (newImg) {
////        homeBackgroundView.image = newImg;
//        homeBgCover.image = nil;
//    } else {
//        NSThread *myThread = [[NSThread alloc] initWithTarget:self
//                                                     selector:@selector(newImage)
//                                                       object:nil];
//        [myThread start];
//    }

    //设置头部信息
    self.movie.hasImax = self.hasImax;
    self.movie.has3D = self.has3D;
    movieDetailHeadView.movie = self.movie;
    [movieDetailHeadView upLoadData];
    self.kkzTitleLabel.text = self.movie.movieName;
    [movieDetailTable reloadData];
}

- (void)callMovieDetailApiDidFailed:(id)responseData {
}

#pragma mark - 电影周边数据 衍生品
- (void)loadMovieHobby {

    WeakSelf
            MovieRelatedRequest *hobbyRequest = [[MovieRelatedRequest alloc] init];
    [hobbyRequest requestHobbiesForMovieWithMovieId:self.movieId.integerValue
            success:^(NSArray *_Nullable hobbyList) {
                weakSelf.movieHobbies = hobbyList;
                [movieDetailTable reloadData];
            }
            failure:^(NSError *_Nullable err){

            }];
}

/**
 *  加载媒体库
 */
- (void)loadMediaLibrary {

    WeakSelf
            MovieRequest *movieRequest = [[MovieRequest alloc] init];
    [movieRequest requestMovieMediaLibraryWithMovieId:self.movieId.integerValue
            success:^(id _Nullable responseObject) {
                [weakSelf callMovieMediaLibraryApiDidSucceed:responseObject];
            }
            failure:^(NSError *_Nullable err){

            }];
}

- (void)callMovieMediaLibraryApiDidSucceed:(id)responseObject {
    [appDelegate hideIndicator];

    DLog(@"movie gallery finished - %@", self);
    self.movieGalleryArray = [Gallery mj_objectArrayWithKeyValuesArray:responseObject[@"gallery"][@"gallery"]];
    self.movieGalleryTotal = [responseObject[@"gallery"][@"total"] integerValue];

    Trailer *song = [MTLJSONAdapter modelOfClass:[Trailer class] fromJSONDictionary:responseObject[@"song"][@"trailer"] error:nil];
    if (song) {
        self.movieSongArray = [NSMutableArray arrayWithObject:song];
    }
    self.movieSongTotal = [responseObject[@"song"][@"total"] integerValue];
    //
    Trailer *trailer = [MTLJSONAdapter modelOfClass:[Trailer class] fromJSONDictionary:responseObject[@"trailer"][@"trailer"] error:nil];
    if (trailer) {
        self.movieTrailerArray = [NSMutableArray arrayWithObject:trailer];
    }
    self.movieTrailerTotal = [responseObject[@"trailer"][@"total"] integerValue];

    [movieDetailTable reloadData];
}

- (void)loadActorList {

    WeakSelf
            MovieRelatedRequest *movieRelatedRequest = [[MovieRelatedRequest alloc] init];
    [movieRelatedRequest requestActorListForMovieWithMovieId:self.movieId.integerValue
            success:^(NSArray *_Nullable actorList) {
                [weakSelf callActorListApiDidSucceed:actorList];
            }
            failure:^(NSError *_Nullable err){

            }];
}

- (void)callActorListApiDidSucceed:(id)responseObject {

    stars = responseObject;
    [movieDetailTable reloadData];
}

#pragma mark - Table View Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.movie.movieIntro.length) {
        static NSString *CellIdentifier = @"MovieIntroCellIdentifier";
        //电影介绍
        MovieIntroCell *cell = (MovieIntroCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MovieIntroCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.isExpand = self.section1Expand;
        cell.movieIntro = self.movie.movieIntro;
        [cell updateLayout];
        return cell;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 1 && self.postPlateM.count) {

        } else {
            static NSString *CellIdentifier = @"StarCellIdentifier";
            //明星
            ActorCell *cell = (ActorCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[ActorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.movieId = self.movieId;
            cell.stars = stars;
            [cell updateLayout];
            return cell;
        }
        //    } else if (indexPath.section == 2 && hobbyUrl.length > 0) {
    } else if (indexPath.section == 2 && self.movieHobbies.count > 0) {
        static NSString *CellIdentifier = @"MovieHobbyViewCellIdentifier";
        //周边
        MovieHobbyViewCell *cell = (MovieHobbyViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MovieHobbyViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        MovieHobbyModel *hobbyModel = self.movieHobbies[indexPath.row];
        cell.hobbyModel = hobbyModel;
        return cell;
    } else if (indexPath.section == 3 && [self mediaCount]) {
        static NSString *CellIdentifier = @"MovieStillsCellIdentifier";
        //电影剧照、原生音乐
        MovieMediaStoreCell *cell = (MovieMediaStoreCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MovieMediaStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.movie = self.movie;
        cell.movieTrailerArray = self.movieTrailerArray; //预告片数组
        cell.movieTrailerTotal = self.movieTrailerTotal; //预告片总数
        cell.movieSongArray = self.movieSongArray; //歌曲数组
        cell.movieSongTotal = self.movieSongTotal; //歌曲总数
        cell.movieGalleryArray = self.movieGalleryArray; //剧照数组
        cell.movieGalleryTotal = self.movieGalleryTotal; //剧照总数

        [cell reloadTableData];
        return cell;
    } else if (indexPath.section == 4) {
        static NSString *CellIdentifier = @"MovieSupportCellIdentifier";
        //电影评价
        MovieSupportCell *cell = (MovieSupportCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MovieSupportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        cell.likeNum = self.likeNum;
        cell.unlikeNum = self.unlikeNum;
        cell.relation = self.relation;
        cell.movieId = self.movieId;

        __weak typeof(self) weakSelf = self;
        cell.supportFinished = ^(BOOL finished, NSDictionary *dict) {

            weakSelf.likeNum = dict[@"likeNum"];
            weakSelf.unlikeNum = dict[@"unlikeNum"];
            weakSelf.relation = [dict[@"relation"] integerValue];

            [weakSelf.movieDetailTableY reloadData];
        };

        [cell upLoadData];

        return cell;
    } else if (indexPath.section == 5) {

        //热门吐槽
        static NSString *commentCellID = @"hot_comment_cell";
        CPMovieComment *commentModel;
        if (self.clubPosts && self.clubPosts.count > indexPath.row) {
             commentModel = [self.clubPosts objectAtIndex:indexPath.row];
        }
        MovieDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
        if (cell == nil) {
            cell = [[MovieDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellID];
        }
        [cell updateWithModel:commentModel];
        return cell;
    }

    else if (indexPath.section == 6) {

        if (self.postPlateM.count && indexPath.row == 0) {
            ClubPlate *clubPlate = [self.postPlateM objectAtIndex:indexPath.row];

            static NSString *PostPlateCellID = @"postPlateCell";
            PostPlateCell *cell = [tableView dequeueReusableCellWithIdentifier:PostPlateCellID];
            if (cell == nil) {
                cell = [[PostPlateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PostPlateCellID];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }

            cell.imagePath = clubPlate.icon;
            cell.title = clubPlate.plateName;
            cell.postNum = clubPlate.articleNum;
            cell.commentNum = clubPlate.commentNum;
            [cell upLoadData];
            return cell;
        } else {

            ClubPost *clubPost = nil;
            if (self.postPlateM.count) {
                clubPost = [self.clubBestPosts objectAtIndex:indexPath.row - 1];

            } else {
                clubPost = [self.clubBestPosts objectAtIndex:indexPath.row];
            }

            if (clubPost.type.integerValue == 2 || clubPost.type.integerValue == 3 || (clubPost.type.integerValue == 4 && clubPost.filesImage.count == 1) || (clubPost.type.integerValue == 1 && clubPost.filesImage.count == 1)) {
                static NSString *cellStyleOneID6 = @"clubstyleonecell6";
                ClubTypeOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStyleOneID6];
                if (cell == nil) {
                    cell = [[ClubTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyleOneID6];
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                }

                [self configureStyleOneCell:cell atIndexPath:indexPath];
                return cell;
            } else if ((clubPost.type.integerValue == 1 && (clubPost.filesImage.count == 0 || clubPost.filesImage.count > 1)) || clubPost.type.integerValue == 4) {
                static NSString *cellStyleTwoID6 = @"clubstyletowcell6";
                ClubTypeTowCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStyleTwoID6];
                if (cell == nil) {
                    cell = [[ClubTypeTowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyleTwoID6];
                    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                }
                [self configureStyleTwoCell:cell atIndexPath:indexPath];
                return cell;
            }
        }

    }

    else {

        return nil;
    }
}

#pragma mark table view date source delegate

- (void)configureStyleOneCell:(ClubTypeOneCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    ClubPost *clubPost;
    if (indexPath.section == 5) {
//        clubPost = [self.clubPosts objectAtIndex:indexPath.row];
    } else {

        if (self.postPlateM.count) {
            clubPost = [self.clubBestPosts objectAtIndex:indexPath.row - 1];
        } else

            clubPost = [self.clubBestPosts objectAtIndex:indexPath.row];
    }

    cell.post = clubPost;

    cell.supportNum = clubPost.upNum;
    cell.commentNum = clubPost.replyNum;
    cell.relationship = clubPost.author.rel;
    cell.postDate = clubPost.publishTime;
    cell.postWord = clubPost.title;
    //    if (clubPost.filesImage.count) {
    if (clubPost.type.integerValue == 2) {
        cell.postImgPath = clubPost.author.head;
    } else
        cell.postImgPath = clubPost.filesImage[0];
    //    }
    //    1图文 2 语音 3 视频 4.订阅号内容  图文是第二种cell

    if (clubPost.type.integerValue == 2) {
        cell.postType = 2; //音频
    } else if (clubPost.type.integerValue == 3) {
        cell.postType = 1; //视频
    } else if (clubPost.type.integerValue == 1 || clubPost.type.integerValue == 4) {
        cell.postType = 3; //图文
    }

    [cell upLoadData];
}

- (void)configureStyleTwoCell:(ClubTypeTowCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ClubPost *clubPost;
    if (indexPath.section == 5) {
//        clubPost = [self.clubPosts objectAtIndex:indexPath.row];
    } else {
        if (self.postPlateM.count) {
            clubPost = [self.clubBestPosts objectAtIndex:indexPath.row - 1];

        } else
            clubPost = [self.clubBestPosts objectAtIndex:indexPath.row];
    }

    cell.post = clubPost;
    cell.supportNum = clubPost.upNum;
    cell.commentNum = clubPost.replyNum;
    cell.postDate = clubPost.publishTime;
    cell.postWord = clubPost.title;
    cell.postImgPaths = clubPost.filesImage;
    [cell upLoadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if (section == 2 && hobbyUrl.length > 0) {
    if (section == 2) {
        return self.movieHobbies.count;
    } else if (section == 0 && self.movie.movieIntro.length) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 3 && [self mediaCount]) {
        return 1;
    } else if (section == 4) {
        return 0;
    } else if (section == 5) {
        return self.clubPosts.count;
    } else if (section == 6) {
        return self.clubBestPosts.count + self.postPlateM.count;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.movie.movieIntro.length > 0) {

        if (introCellHeight > 0) {
            return introCellHeight;
        }

        float positionY = 12.0;

        CGSize introSizeMin = [self.movie.movieIntro sizeWithFont:[UIFont systemFontOfSize:15]
                                                constrainedToSize:CGSizeMake(screentWith - 15 * 2, 15 * 5)
                                                    lineBreakMode:NSLineBreakByTruncatingTail];
        positionY += introSizeMin.height;

        return positionY + 35;

    } else if (indexPath.section == 1 && stars.count) {
        return actorCellHeight;
    } else if (indexPath.section == 2 && self.movieHobbies.count > 0) {
        return movieHobbyViewCellHeight;
    } else if (indexPath.section == 3 && [self mediaCount]) {
        return moviePhotoGalleryCellHeight;
    } else if (indexPath.section == 4) {
        return MovieSupportCellHeight;
    } else if (indexPath.section == 5) {
        //  热门评论 高度
        if (self.clubPosts && self.clubPosts.count > indexPath.row) {
            CPMovieComment *commentModel = [self.clubPosts objectAtIndex:indexPath.row];
            CGFloat commentHeight = [commentModel.content boundingRectWithSize:CGSizeMake(kAppScreenWidth - 30, CGFLOAT_MAX)
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:@{
                                                                                 NSFontAttributeName : [UIFont systemFontOfSize:14]
                                                                                 }
                                                                       context:nil].size.height;
            return commentHeight + 65 + 15;
        } else {
            return 0.01;
        }
    } else if (indexPath.section == 6) {

        if (indexPath.row == 0 && self.postPlateM.count) {
            return 117;
        } else {
            ClubPost *clubPost = nil;
            if (self.postPlateM.count) {
                clubPost = [self.clubBestPosts objectAtIndex:indexPath.row - 1];

            } else {
                clubPost = [self.clubBestPosts objectAtIndex:indexPath.row];
            }

            if (clubPost.type.integerValue == 2 || clubPost.type.integerValue == 3 || (clubPost.type.integerValue == 4 && clubPost.filesImage.count == 1) || (clubPost.type.integerValue == 1 && clubPost.filesImage.count == 1)) {
                return 165;
            } else if ((clubPost.type.integerValue == 1 && (clubPost.filesImage.count == 0 || clubPost.filesImage.count > 1)) || clubPost.type.integerValue == 4) {

                CGSize s = [clubPost.title sizeWithFont:[UIFont systemFontOfSize:wordFont] constrainedToSize:CGSizeMake(screentWith - marginX * 2, CGFLOAT_MAX)];

                if (clubPost.filesImage.count) { //上下结构 只有文字的情况
                    if (s.height >= wordH) {
                        return cellHeight1;
                    } else {
                        return cellHeight2;
                    }

                } else {
                    if (s.height >= wordH) {
                        return cellOnlyWordHeight1;
                    } else {
                        return cellOnlyWordHeight2;
                    }
                }
            }
        }

    } else {
        return 1;
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    MovieDetailHeader *header = [[MovieDetailHeader alloc] init];
    header.sectionNum = section;
    header.BtnHidden = YES;
    header.isBtmlineHidden = NO;
    if (section == 0 && self.movie.movieIntro.length > 0) {
    } else if (section == 1 && stars.count) {
//        header.isBtmlineHidden = YES;
//        header.image = [UIImage imageNamed:@"movie_actor_logo"];
//        header.titleStr = [NSString stringWithFormat:@"%lu位演职人员", (unsigned long) stars.count];
//        header.BtnHidden = NO;
//        [header updateLayout];
//        return header;
    } else if (section == 3 && [self mediaCount]) {
        header.isBtmlineHidden = YES;
        header.image = [UIImage imageNamed:@"movie_still_logo"];
        header.titleStr = @"媒体库";
        header.BtnHidden = NO;
        [header updateLayout];
        return header;
    } else if (section == 5 && self.clubPosts.count) {
        header.titleStr = @"热门评论";
//        subTitleLbl1 = [[UILabel alloc] initWithFrame:CGRectMake(67, 15, screentWith - 85, 15)];
//        subTitleLbl1.textColor = [UIColor lightGrayColor];
//        subTitleLbl1.font = [UIFont systemFontOfSize:15];
//        subTitleLbl1.text = [NSString stringWithFormat:@"（%ld）", (long) self.total];
//        [header addSubview:subTitleLbl1];
        header.BtnHidden = NO;
        [header updateLayout];
        return header;
    } else if (section == 6 && (self.clubBestPosts.count || self.postPlateM.count)) {
        header.titleStr = @"社区精华";

        //        subTitleLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(67, 15, screentWith - 85, 15)];
        //        subTitleLbl2.textColor = [UIColor lightGrayColor];
        //        subTitleLbl2.font = [UIFont systemFontOfSize:15];
        //        [header addSubview:subTitleLbl2];
        //        subTitleLbl2.text = [NSString stringWithFormat:@"（%ld）", (long) self.total];

        header.BtnHidden = NO;
        [header updateLayout];
        return header;
    } else {
        UIView *heaer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
        return heaer;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1 && stars.count) {
//        return 45;
    } else if (section == 3 && [self mediaCount]) {
        return 45;
    } else if (section == 5 && self.clubPosts.count) {
        return 45;
    } else if (section == 6 && (self.clubBestPosts.count || self.postPlateM.count)) {
        return 45;
    }

    return 0.001f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section == 2 && hobbyPicUrl.length > 0) {
        return 10;
    } else if (section == 0 && self.movie.movieIntro.length > 0) {
        return 10;
    } else if (section == 1 && stars.count) {
//        return moreFooterView;
    } else if (section == 3 && [self mediaCount]) {
        return PictureMoreFooterView;
    } else if (section == 4) {
        return 10;
    } else if (section == 5 && self.clubPosts.count) {
        return 0.01;//10 + 45;
    } else if (section == 6 && self.clubBestPosts.count) {
        return 10 + 45;
    }
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 10)];
    [footV setBackgroundColor:[UIColor r:245 g:245 b:245]];

    if (section == 2 && hobbyPicUrl.length > 0) {
        return footV;
    } else if (section == 0 && self.movie.movieIntro.length > 0) {
        return footV;
    } else if (section == 1 && stars.count) {
//        UIView *footVMore = [self addFooterViewWith:section andFooterHeight:moreFooterView];
//        return footVMore;
    } else if (section == 3 && [self mediaCount]) {
        UIView *footVMore = [self addFooterViewWith:section andFooterHeight:PictureMoreFooterView];
        return footVMore;
    } else if (section == 4) {
        return footV;
    } else if (section == 5 && self.clubPosts.count) {
//        CGFloat footVMore5Height = 55;
        UIView *footVMore = [UIView new];//[self addFooterViewWith:section andFooterHeight:footVMore5Height];
        return footVMore;

    } else if (section == 6 && self.clubBestPosts.count) {
        CGFloat footVMore5Height = 55;
        UIView *footVMore = [self addFooterViewWith:section andFooterHeight:footVMore5Height];
        return footVMore;
    } else {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.001)];
        footer.backgroundColor = [UIColor clearColor];
        return footer;
    }
    return nil;
}

//footer
- (UIView *)addFooterViewWith:(NSInteger)section andFooterHeight:(CGFloat)height {
    CGFloat footerHeight = height;

    UIView *footVMore = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, footerHeight)];
    [footVMore setBackgroundColor:[UIColor whiteColor]];
    UIView *footV1 = [[UIView alloc] initWithFrame:CGRectMake(0, footerHeight - 10, screentWith, 10)];
    [footV1 setBackgroundColor:[UIColor r:245 g:245 b:245]];
    [footVMore addSubview:footV1];

    if (section == 1) {
//        [self addCheckMoreBtnWithSection:1 andHeight:footerHeight andPareentView:footVMore andCount:stars.count];
    } else if (section == 3) {

        CGFloat videoBtnWidth = 0;
        CGFloat audioBtnWidth = 0;
        CGFloat pictureBtnWidth = screentWith - videoBtnWidth - audioBtnWidth;
        CGFloat btnHeight = 45;

        if (self.movieTrailerTotal > 0) {
            videoBtnWidth = 133;
        } else {
            videoBtnWidth = 0;
        }
        if (self.movieSongTotal > 0) {
            audioBtnWidth = 97;
        } else {
            audioBtnWidth = 0;
        }
        if (self.movieGalleryTotal > 0) {
            pictureBtnWidth = screentWith - videoBtnWidth - audioBtnWidth;
        } else {
            pictureBtnWidth = 0;
        }

        [self addCheckMediaBtnWithTitle:@"视频" andParentView:footVMore andBtnWidth:videoBtnWidth andBtnHeigt:btnHeight andOrginX:marginX andIndex:1];

        [self addCheckMediaBtnWithTitle:@"音乐" andParentView:footVMore andBtnWidth:audioBtnWidth andBtnHeigt:btnHeight andOrginX:marginX + videoBtnWidth andIndex:2];

        [self addCheckMediaBtnWithTitle:@"剧照" andParentView:footVMore andBtnWidth:pictureBtnWidth andBtnHeigt:btnHeight andOrginX:marginX + videoBtnWidth + audioBtnWidth andIndex:3];

    } else if (section == 5) {

//        [self addCheckMoreBtnWithSection:5 andHeight:footerHeight andPareentView:footVMore andCount:0];

    } else if (section == 6) {
        [self addCheckMoreBtnWithSection:6 andHeight:footerHeight andPareentView:footVMore andCount:0];
    }

    return footVMore;
}

/**
 *  添加查看更多的按钮
 */
- (void)addCheckMoreBtnWithSection:(NSInteger)section andHeight:(CGFloat)footerHeight andPareentView:(UIView *)parentView andCount:(NSInteger)count {

    UIButton *checkMore = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screentWith, footerHeight - 10)];
    [checkMore setTitleColor:appDelegate.kkzBlue forState:UIControlStateNormal];
    checkMore.titleLabel.font = [UIFont systemFontOfSize:checkMoreBtnFont];
    checkMore.tag = 3333;
    [parentView addSubview:checkMore];
    [checkMore addTarget:self action:@selector(MovieDetailShowMore:) forControlEvents:UIControlEventTouchUpInside];

    checkMore.tag = section + 500;

    if (section == 1) {
        [checkMore setTitle:[NSString stringWithFormat:@"查看全部%ld位演职人员", (long) count] forState:UIControlStateNormal];
    } else if (section == 5) {

        [checkMore setTitle:[NSString stringWithFormat:@"查看更多评论"] forState:UIControlStateNormal];
        [checkMore addTarget:self action:@selector(checkMoreMovieHotComments) forControlEvents:UIControlEventTouchUpInside];
        _moreHotCommentButton = checkMore;

    } else if (section == 6) {
        [checkMore setTitle:[NSString stringWithFormat:@"查看更多"] forState:UIControlStateNormal];
        [checkMore addTarget:self action:@selector(checkMorePostComments) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  查看更多热门吐槽
 */
- (void)checkMoreMovieHotComments {
    
}

/**
 *  查看更多社区精华
 */
- (void)checkMorePostComments {
}

/**
 *  添加查询不同媒体的按钮
 */
- (void)addCheckMediaBtnWithTitle:(NSString *)title andParentView:(UIView *)parentView andBtnWidth:(CGFloat)btnWidth andBtnHeigt:(CGFloat)btnHeight andOrginX:(CGFloat)orginX andIndex:(NSInteger)index {
    UIButton *videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(orginX, 0, btnWidth, btnHeight)];
    [parentView addSubview:videoBtn];
    [videoBtn addTarget:self action:@selector(mediaBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *videoLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    videoLbl.text = title;
    videoLbl.textColor = [UIColor grayColor];
    videoLbl.textAlignment = NSTextAlignmentLeft;
    videoLbl.font = [UIFont systemFontOfSize:14];
    [videoBtn addSubview:videoLbl];

    UILabel *videoLblNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btnWidth - 8 - 11 - 15, btnHeight)];
    videoLblNum.textColor = [UIColor grayColor];
    videoLblNum.textAlignment = NSTextAlignmentRight;
    videoLblNum.font = [UIFont systemFontOfSize:14];
    [videoBtn addSubview:videoLblNum];

    UIImageView *arrowV = [[UIImageView alloc] initWithFrame:CGRectMake(btnWidth - 7 - 11 - 10, (btnHeight - 13) * 0.5, 6.5, 13)];

    [arrowV setImage:[UIImage imageNamed:@"arrowGray"]];
    [videoBtn addSubview:arrowV];
    arrowV.userInteractionEnabled = NO;

    if (index == 1) {
        videoLblNum.text = [NSString stringWithFormat:@"%ld", (long) self.movieTrailerTotal];
        if (self.movieTrailerTotal) {
            videoLblNum.hidden = NO;
            videoLbl.hidden = NO;
        } else {
            videoLblNum.hidden = YES;
            videoLbl.hidden = YES;
        }
    } else if (index == 2) {
        videoLblNum.text = [NSString stringWithFormat:@"%ld", (long) self.movieSongTotal];

        if (self.movieSongTotal) {
            videoLblNum.hidden = NO;
            videoLbl.hidden = NO;
        } else {
            videoLblNum.hidden = YES;
            videoLbl.hidden = YES;
        }
    } else if (index == 3) {
        videoLblNum.text = [NSString stringWithFormat:@"%ld", (long) self.movieGalleryTotal];

        if (self.movieGalleryTotal) {
            videoLblNum.hidden = NO;
            videoLbl.hidden = NO;
        } else {
            videoLblNum.hidden = YES;
            videoLbl.hidden = YES;
        }
    }

    UIView *videoLine = [[UIView alloc] initWithFrame:CGRectMake(btnWidth - 11, 0, 0.5, btnHeight)];
    [videoLine setBackgroundColor:[UIColor r:211 g:211 b:211]];
    [videoBtn addSubview:videoLine];
    videoBtn.tag = index + 600;
}

//查看所有视频、音频、图片
- (void)mediaBtnClicked:(UIButton *)btn {
    switch (btn.tag - 600) {
        case 1:
            DLog(@"进入视频列表");

            {
                MovieTrailerListViewController *ctr = [[MovieTrailerListViewController alloc] init];
                ctr.movie = self.movie;
                [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
                break;
            }
        case 2: {
            DLog(@"进入音频列表");
            SoundtrackViewController *swf = [[SoundtrackViewController alloc] init];
            swf.movie = self.movie;
            [self pushViewController:swf animation:CommonSwitchAnimationBounce];
            break;
        }
        case 3: {
            DLog(@"进入剧照列表");
            StillsWaterFlowViewController *swf = [[StillsWaterFlowViewController alloc] init];
            swf.movieId = self.movieId;
            swf.titleStr = self.movie.movieName;
            swf.mediaType = 10;
            [self pushViewController:swf animation:CommonSwitchAnimationBounce];
            break;
        }
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        WebViewController *ctr = [[WebViewController alloc] initWithTitle:hobbyTitle];
        MovieHobbyModel *hobbyModel = self.movieHobbies[indexPath.row];
        [ctr loadURL:hobbyModel.url];
        [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
    } else if (indexPath.section == 0) {
        if (self.movie.movieIntro.length != 0 && ![self.movie.movieIntro isEqualToString:@"(null)"]) {
            self.section1Expand = !self.section1Expand;
            MovieIntroCell *cell = (MovieIntroCell *) [movieDetailTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            introCellHeight = [cell heightWithCellState:self.section1Expand];
            [movieDetailTable reloadData];
        }
    } else if (indexPath.section == 5) {
        return;
    } else if (indexPath.section == 6) {

        if (indexPath.row == 0 && self.postPlateM.count) {
            ClubPlate *postPlate = [self.postPlateM objectAtIndex:indexPath.row];
            PlatePostListController *ctr = [[PlatePostListController alloc] init];
            ctr.ctrTitle = postPlate.plateName;
            ctr.plateId = postPlate.plateId;
            ctr.movieId = self.movieId;

            [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
        } else {
            ClubPost *clubPost = nil;
            if (self.postPlateM.count) {
                clubPost = [self.clubBestPosts objectAtIndex:indexPath.row - 1];
            } else {
                clubPost = [self.clubBestPosts objectAtIndex:indexPath.row];
            }

            if (clubPost.url && clubPost.url.length) {

                WebViewController *ctr = [[WebViewController alloc] initWithTitle:@""];

                [ctr loadURL:clubPost.url];

                [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];

            } else {

                ClubPostPictureViewController *postDetail = [[ClubPostPictureViewController alloc] init];
                postDetail.articleId = clubPost.articleId;

                postDetail.postType = clubPost.type.integerValue;

                [self pushViewController:postDetail animation:CommonSwitchAnimationSwipeR2L];
            }
        }
    }
}

//点击footer区域查看更多
- (void)MovieDetailShowMore:(UIButton *)btn {

    switch (btn.tag - 500) {
        case 1: {
            ActorListViewController *alv = [[ActorListViewController alloc] init];
            alv.movieId = self.movieId;
            [self pushViewController:alv animation:CommonSwitchAnimationBounce];
            break;
        }
        case 5: {
            //  更多热门吐槽
//            MovieHotCommentController *ctr = [[MovieHotCommentController alloc] init];
//            ctr.movieId = self.movieId;
//            ctr.userGroup = @"1,2,3,0";
//            ctr.ctrTitle = @"热门吐槽";
//            [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
            [KKZAnalytics postActionWithEvent:[[KKZAnalyticsEvent alloc] initWithMovie:self.movie] action:AnalyticsActionComment_list];
            break;
        }
        case 6: {
            MovieHotCommentController *ctr = [[MovieHotCommentController alloc] init];
            ctr.movieId = self.movieId;
            ctr.userGroup = @"4,5";
            ctr.ctrTitle = @"社区精华";
            [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
        }

        default:
            break;
    }
}

//刷新预告片
- (void)refreshMovieTrailer {

    MediaTask *task = [[MediaTask alloc] initMedia:self.movie.movieId.intValue
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

/**
 *  热门吐槽
 */

- (void)loadMovieHotCommentList {
//    currentPage = 1;
    NSInteger rows = 5;
    _moreHotCommentButton.enabled = false;
    NSInteger page = currentPage;
    
    WeakSelf;
    ClubRequest *clubRequest = [[ClubRequest alloc] init];
    [clubRequest requestMovieHotCommentWithMovieId:self.movieId.integerValue
            currentPage:currentPage
            rowsNum:rows
            userGroup:@"1,2,3,0"
            success:^(NSArray *_Nullable hotComments, NSInteger total, BOOL hasMore) {
                if (page == 1) {
                    [self.clubPosts removeAllObjects];
                }
                [weakSelf callMovieHotCommentApiDidSucceed:hotComments total:total hasMore:hasMore];
                _moreHotCommentButton.enabled = true;
                [movieDetailTable footerEndRefreshing];
            }
            failure:^(NSError *_Nullable err){
                _moreHotCommentButton.enabled = true;
                [movieDetailTable footerEndRefreshing];
            }];
    //
}

- (void)callMovieHotCommentApiDidSucceed:(NSArray *)posts total:(NSInteger)total hasMore:(BOOL)hasMore {
    self.total = total;
    self.hasMore = hasMore;
//    self.clubPosts = [NSMutableArray arrayWithArray:posts];
    [self.clubPosts addObjectsFromArray:posts];
    
    if (self.clubPosts.count>0) {
        [movieDetailTable reloadData];
    }
    
    if (!posts || posts.count == 0){
        movieDetailTable.footerReleaseToRefreshText = @"没有更多";
        movieDetailTable.footerPullToRefreshText = @"没有更多";
        movieDetailTable.footerRefreshingText = @"没有更多";
        _noMore = true;
    } else {
        movieDetailTable.footerReleaseToRefreshText = @"上拉加载更多";
        movieDetailTable.footerPullToRefreshText = @"上拉加载更多";
        movieDetailTable.footerRefreshingText = @"加载中...";
        _noMore = false;
    }
}

- (NSInteger)mediaCount {
    NSInteger count = 0;
    if (self.movieTrailerTotal > 0) {
        count = self.movieTrailerTotal;
    }
    if (self.movieSongTotal > 0) {
        count += self.movieSongTotal;
    }
    if (self.movieGalleryTotal > 0) {
        count += self.movieGalleryTotal;
    }
    return count;
}

/**
 *  查询某电影的 喜欢和不喜欢人数
 */
- (void)loadMovieSupport {

    WeakSelf
            MovieRequest *movieSupportRequest = [[MovieRequest alloc] init];
    [movieSupportRequest requestMovieSupportWithMovieId:self.movieId.integerValue
            success:^(id _Nullable responseObject) {
                [weakSelf callMovieSupportApiDidSucceed:responseObject];
            }
            failure:^(NSError *_Nullable err){
                    //         [appDelegate showAlertViewForTaskInfo:userInfo];
            }];
}

- (void)callMovieSupportApiDidSucceed:(id)responseData {
    self.likeNum = responseData[@"likeCount"];
    self.unlikeNum = responseData[@"dislikeCount"];
    self.relation = [responseData[@"relation"] integerValue];
    [movieDetailTable reloadData];
}

/**
 *  电影主题评论
 */
- (void)loadMoviePlateList {
    currentPage = 1;
    NSInteger rows = 5;

    ClubRequest *moviePlateRequest = [[ClubRequest alloc] init];
    [moviePlateRequest requestMoviePlateListWithMovieId:self.movieId.integerValue
            currentPage:currentPage
            rowsNum:rows
            success:^(id _Nullable postPlates) {
                [self callMoviePlateApiDidSucceed:postPlates];
            }
            failure:^(NSError *_Nullable err) {
                [self callMoviePlateApiDidFailed:err];
            }];
}

- (void)callMoviePlateApiDidSucceed:(id)responseData {
    self.postPlateM = responseData;
    [movieDetailTable reloadData];
}
- (void)callMoviePlateApiDidFailed:(id)responseData {
    // [appDelegate showAlertViewForTaskInfo:userInfo];
}

/**
 *  社区精华的帖子
 */

- (void)loadMoviePostList {
    
#warning 移除社区精华
    //TODO: 移除代码
    return;
    
    currentPage = 1;
    NSInteger rows = 3;

    WeakSelf;
    ClubRequest *clubRequest = [[ClubRequest alloc] init];
    [clubRequest requestMovieHotCommentWithMovieId:self.movieId.integerValue
            currentPage:currentPage
            rowsNum:rows
            userGroup:@"4,5"
            success:^(id _Nullable hotComments, NSInteger total, BOOL hasMore) {
                [weakSelf callMoviePostApiDidSucceed:hotComments total:total hasMore:hasMore];
            }
            failure:^(NSError *_Nullable err){

            }];
}

- (void)loadUserScore {
    MovieRequest *req = [[MovieRequest alloc] init];
    [req requestScoreWithMovieId:self.movieId success:^(NSDictionary * _Nullable response) {
        if (response) {
            //
            _tableFooterNullLabel.hidden = true;
            _tableFooterScoreView.hidden = false;
            [_scoreRatingView displayRating:[response[@"movie"][@"score"] floatValue]/2.0];
            [_tableFooterPostImageView sd_setImageWithURL:[NSURL URLWithString:response[@"movie"][@"pathVerticalS"]]];
        } else {
            //
            _tableFooterNullLabel.hidden = false;
            _tableFooterScoreView.hidden = true;
        }
    } failure:^(NSError * _Nullable err) {
        
    }];
}

- (void)callMoviePostApiDidSucceed:(id)responseData total:(NSInteger)total hasMore:(BOOL)hasMore {
    self.clubBestPosts = responseData;

    if (self.clubBestPosts.count) {
        [movieDetailTable reloadData];
    }
}
- (void)callMoviePostApiDidFailed:(id)responseData {
}

- (void)moviePostListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {

    if (succeeded) {
        if ([userInfo[@"hasMore"] integerValue]) {
            self.hasMore = YES;
        } else {
            self.hasMore = NO;
        }
        self.clubBestPosts = userInfo[@"postsM"];

        if (self.clubBestPosts.count) {
            [movieDetailTable reloadData];
        }

    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

#pragma mark override from CommonViewController

- (BOOL)showNavBar {

    return TRUE;
}

- (BOOL)showBackButton {

    return NO;
}

- (BOOL)showTitleBar {

    return YES;
}

- (BOOL)isNavMainColor {
    return NO;
}

- (UIImage *)blureImage:(UIImage *)originImage withInputRadius:(CGFloat)inputRadius {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:originImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@(inputRadius) forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];

    CGSize finalSize = CGSizeMake(107, 107 / screentWith * headHeight + 20);

    CGFloat width = finalSize.width;
    CGFloat height = finalSize.height;

    CGImageRef outImage = [context createCGImage:result fromRect:CGRectMake(0, 0, width, height)];
    UIImage *blurImage = [UIImage imageWithCGImage:outImage];
    return blurImage;
}

- (void)newImage {

    //设置背景图片
//    if (self.movie.thumbPath.length) {
//        self.urlStr = self.movie.thumbPath;
//    } else {
        self.urlStr = self.movie.pathVerticalS;
//    }

    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlStr]];

    UIImage *img = [UIImage imageWithData:data];

    CGSize finalSize = CGSizeMake(107, 107 / screentWith * headHeight + 20);

    CGFloat width = finalSize.width;
    CGFloat height = finalSize.height;

    UIImage *newImg = [KKZUtility croppedImage:img withFrame:CGRectMake((img.size.width - width) * 0.5, (img.size.height - height) * 0.5, width, height)];

    UIImage *blureImg = [self blureImage:newImg withInputRadius:3.0f];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *newImgLast = [KKZUtility resibleImage:blureImg toSize:homeBackgroundView.frame.size];
        
        UIImage *newnewImgLast = [KKZUtility croppedImage:newImgLast withFrame:CGRectMake(0, 20, 107, 107 / screentWith * headHeight + 20)];
        
        homeBackgroundView.image = newnewImgLast;
        
        NSString *url = [NSString stringWithFormat:@"movieDetail%@", self.urlStr];
        
        [[ImageEngineNew sharedImageEngineNew] saveImage:newnewImgLast forURL:[url MD5String] andSize:ImageSizeOrign sync:NO fromCache:YES];
        
        homeBgCover.image = nil;
    });

}

//拖动（释放手指）停止的时候执行
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (refreshHeaderView.state == EGOOPullRefreshLoading) {
        return;
    }

    if (scrollView.contentOffset.y <= -65.0f) {

        [self performSelector:@selector(refreshDetail) withObject:nil afterDelay:0.2];
    }
}

#pragma mark-- scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGRect frame = homeBackgroundView.frame;
    float postBgh = homeBgHeight;

    if (scrollView.contentOffset.y < 0) {
        frame.origin.x = scrollView.contentOffset.y / 2.0;
        frame.origin.y = 0;
        frame.size.height = postBgh - scrollView.contentOffset.y;
        frame.size.width = screentWith - scrollView.contentOffset.y;
    } else {
        frame.origin.x = 0;
        frame.origin.y = 0 - scrollView.contentOffset.y;
        frame.size.width = screentWith;
        frame.size.height = postBgh;
    }

    homeBackgroundView.frame = frame;
    if (scrollView.contentOffset.y >= headHeight) {
        [homeBgCover setBackgroundColor:[UIColor whiteColor]];
        //设置导航栏背景色
//        self.navBarView.backgroundColor = appDelegate.kkzBlue;
//        self.statusView.backgroundColor = appDelegate.kkzBlue;

        self.kkzTitleLabel.hidden = NO;
    } else {
        [self.view setBackgroundColor:[UIColor clearColor]];

        [homeBgCover setBackgroundColor:[UIColor r:0 g:0 b:0 alpha:0.4]];

        //设置导航栏背景色
        self.navBarView.backgroundColor = [UIColor clearColor];
        self.statusView.backgroundColor = [UIColor clearColor];

        self.kkzTitleLabel.hidden = YES;
    }

    homeBackgroundView.frame = frame;
    frame = homeBgCover.frame;
    frame.size = homeBackgroundView.frame.size;
    homeBgCover.frame = frame;

    //在拖动
    if (scrollView.isDragging) {
        if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
            [refreshHeaderView setState:EGOOPullRefreshNormal];
        } else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
            [refreshHeaderView setState:EGOOPullRefreshPulling];
        }
    } else {
    }
}

- (void)refreshDetail {
    //加载数据
    [self loadMovieDetail]; //详情
//    [self loadMovieHobby]; //周边
//    [self loadMediaLibrary]; //媒体库
    [self loadActorList]; //演员列表

    //热门吐槽
    currentPage = 1;
    [self loadMovieHotCommentList];

    //社区版块儿
    [self loadMoviePlateList];

    //社区精华
    [self loadMoviePostList];

    //喜欢 不喜欢 情况
    [self loadMovieSupport];
}

@end
