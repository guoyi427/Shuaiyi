//
//  ClubPostPictureViewController.m
//  KoMovie
//
//  Created by KKZ on 16/2/2.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPostPictureViewController.h"
#import "ClubPosterCommentCell.h"
#import "ClubTextView.h"
#import "ImageEngineNew.h"
#import "KKZUtility.h"
#import "PosterOperationView.h"
#import "RelatedMovieView.h"

#import "ClubPostSupportCell.h"
#import "RelateMovieCell.h"

#import "ClubTask.h"
#import "TaskQueue.h"

#import "ClubPostHeadViewVideo.h"

#import "KKZUser.h"

#import "ClubPostComment.h"
#import "ShowMoreIndicator.h"

#import "TaskQueue.h"

#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "RIButtonItem.h"
#import "ShowMoreIndicator.h"
#import "UIAlertView+Blocks.h"
#import "StatisticsTask.h"
#import "Movie.h"
#import "MovieTask.h"

#define ClubPostHeadViewAudioHeight 165
#define ClubPostHeadViewVideoHeight (kCommonScreenWidth * 3 / 4)

#define marginX 15
#define marginY 15

#define rightBtnWith 60
#define rightBtnHeight 44

#define clubCommentCellHeight 99

#define navBackgroundColor appDelegate.kkzBlue
//#define postTextColor [UIColor r:51 g:51 b:51]
//#define postTextColor [UIColor blackColor]
//#define relateMovieViewBgColor [UIColor r:245 g:245 b:245]
//#define postTextFont 14
//#define postPictureWith (screentWith - marginX * 2)

#define supportViewHeight 103
#define relateMovieViewHeight 170

#define publishCommentViewHeight 46

#define clubSectionHeaderHeight 43

#define clubSectionHeaderTitleFont 14
#define clubCellCommentTextFont 14

#define userHeadImgV 30
#define userHeadImgVToNickName 10
#define clubCellCommentTextWidth (screentWith - marginX * 2 - userHeadImgV - userHeadImgVToNickName)

@interface ClubPostPictureViewController () {

    ShowMoreIndicator *showMoreFooterView;

    EGORefreshTableHeaderView *refreshHeaderView;

    PosterOperationView *oprationView;
}

/**
 *  帖子
 */
@property (nonatomic, strong) ClubPost *clubPost;
//评论区
@property (nonatomic, strong) ClubTextView *publishView;

/**
 是否为去登录返回
 */
@property (nonatomic) BOOL isLoginBack;
@end

@implementation ClubPostPictureViewController

- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    self = [super init];
    if (self) {
        if (extra1) {
            self.articleId = [extra1 toNumber];
        }
    }
    return self;
}

- (void)dealloc {
    [self removeForKeyboardNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isPostCollectionComplete" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"CommentPostSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
    //加载导航栏
    [self loadNavBar];
    //添加clubTableView
    [self loadTable];
    //加载评论发表框
    [self loadPublishCommentView];
    //添加键盘监听事件
    [self registerForKeyboardNotifications];

    self.clubPostCommentList = [[NSMutableArray alloc] initWithCapacity:0];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentPostSucceed:)
                                                 name:@"CommentPostSucceed"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(collectionPostSucceed:)
                                                 name:@"isPostCollectionComplete"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shareViewWillShow)
                                                 name:shareViewWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(shareViewWillHiden)
                                                 name:shareViewWillHidenNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachablityChangedWWANYN:)
                                                 name:@"reachablityChangedWWAN"
                                               object:nil];

    //增加进入后台之后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground)
                                                 name:@"AppDidEnterBackground"
                                               object:nil];

    //增加进入前台之后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecomeActive)
                                                 name:@"appBecomeActive"
                                               object:nil];

    coverKeyBoard = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight - (publishCommentViewHeight + 280))];
    [coverKeyBoard setBackgroundColor:[UIColor r:0 g:0 b:0 alpha:0]];
    //    [coverKeyBoard setBackgroundColor:[UIColor redColor]];
    [coverKeyBoard addTarget:self action:@selector(coverKeyBoardClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:coverKeyBoard];
    coverKeyBoard.hidden = YES;

    self.isFav = self.clubPost.isFaverite;

    [self addMessageV];
}

- (void)addMessageV {
    messageLblBgV = [[UIView alloc] initWithFrame:CGRectMake(30, (screentHeight - 80) * 0.5, screentWith - 30 * 2, 80)];

    [self.view addSubview:messageLblBgV];
    [messageLblBgV setBackgroundColor:[UIColor r:0 g:0 b:0 alpha:0.8]];

    messageLblBgV.hidden = YES;

    UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, messageLblBgV.frame.size.width - 15 * 2, 80)];

    messageLbl.textAlignment = NSTextAlignmentCenter;
    [messageLbl setBackgroundColor:[UIColor clearColor]];
    messageLbl.numberOfLines = 0;
    messageLbl.textColor = [UIColor whiteColor];
    messageLbl.font = [UIFont systemFontOfSize:16];
    messageLbl.text = @"已断开无线网络，使用移动网络将可能产生流量费用";

    [messageLblBgV addSubview:messageLbl];
}

- (void)reachablityChangedWWANYN:(NSNotification *)noti {

    messageLblBgV.hidden = NO;

    [self performSelector:@selector(hidemessageLbl) withObject:nil afterDelay:2.0];
}

- (void)hidemessageLbl {
    messageLblBgV.hidden = YES;
}

- (void)collectionPostSucceed:(NSNotification *) not{
    NSInteger isF = [not.userInfo[@"isFav"] integerValue];
    self.clubPost.isFaverite = isF;
    self.isFav = isF;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //开始进入帖子详情的时间
    [self statisticsRequestWithInfName:@"start_read_sns_post"];

    [self setStatusBarLightStyle];
    if (self.firstAppear) {
        [self loadPostDetail];
        self.firstAppear = NO;
    } else if(self.isLoginBack == NO) {
        [self loadMovieDetail];
        [self loadSupportList];
        [self loadClubPostReplyList];
    }
    
    if (self.isLoginBack == YES) {
        self.isLoginBack = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //即将退出帖子详情的时间
    [self statisticsRequestWithInfName:@"end_read_sns_post"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppDidEnterBackground"
                                                        object:nil];
}

- (void)enterBackground {
    //即将退出帖子详情的时间
    [self statisticsRequestWithInfName:@"end_read_sns_post"];
}

- (void)appBecomeActive {
    //开始进入帖子详情的时间
    [self statisticsRequestWithInfName:@"start_read_sns_post"];
}

- (void)commentPostSucceed:(NSNotification *) not{

    ClubPostComment *clubPostComment = not.object;

    self.clubPost.replyNum = [NSNumber numberWithInteger:self.clubPost.replyNum.integerValue + 1];

    [self.clubPostCommentList insertObject:clubPostComment atIndex:0];

    [clubTableView reloadData];
}

- (void)shareViewWillShow {
    [self removeForKeyboardNotifications];
}

- (void)shareViewWillHiden {
    [self registerForKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (oprationView) {
        [self.view insertSubview:self.navBarView
                    belowSubview:oprationView];
        [self.view insertSubview:self.statusView
                    belowSubview:oprationView];
    }
    if (coverKeyBoard) {
        [self.view insertSubview:self.navBarView
                    belowSubview:coverKeyBoard];
        [self.view insertSubview:self.statusView
                    belowSubview:coverKeyBoard];
    }
     [KKZAnalytics postActionWithEvent:[[KKZAnalyticsEvent alloc] initWithMovie:self.movie] action:AnalyticsActionComment_details];
}

#pragma mark 添加UI信息
/**
 *  添加ScrollView
 */
- (void)loadTable {
    clubTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith, screentHeight - self.contentPositionY - 44)];
    [clubTableView setBackgroundColor:[UIColor whiteColor]];
    clubTableView.autoresizesSubviews = YES;
    clubTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:clubTableView];

    clubTableView.dataSource = self;
    clubTableView.delegate = self;

    [self.kkzBackBtn setImage:[UIImage imageNamed:@"backButtonImg"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"shareWhiteCover"] forState:UIControlStateNormal];
    //    clubTableView的headerView
    if (self.postType == 1) { //图文

    } else if (self.postType == 2) { //语音

    } else if (self.postType == 3) { //视频

    } else if (self.postType == 4) { //订阅号
    }

    //    clubTableView的footerView
    clubFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, publishCommentViewHeight)];
    [clubFooterView setBackgroundColor:[UIColor clearColor]];
    clubTableView.tableFooterView = clubFooterView;

    //clubTableView添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Actiondo:)];
    [clubTableView addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;

    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                    0.0f - clubTableView.bounds.size.height,
                                                                                    screentWith,
                                                                                    clubTableView.bounds.size.height)];
    [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];
    [refreshHeaderView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [clubTableView addSubview:refreshHeaderView];
}

/**
 *  加载导航栏
 */
- (void)loadNavBar {
    //设置背景色
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //调整导航栏的背景色
    [self.statusView setBackgroundColor:navBackgroundColor];
    [self.navBarView setBackgroundColor:navBackgroundColor];

    //加载导航栏右边按钮
    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - marginX - rightBtnWith + 14, 0, rightBtnWith + 14, rightBtnHeight)];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    [rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:rightBtn];

    if (!THIRD_LOGIN) {
        rightBtn.hidden = YES;
    } else {
        rightBtn.hidden = NO;
    }
}

/**
 *  分享、删除、举报、收藏帖子
 */
- (void)rightBtnClicked {
    DLog(@"弹出 分享、删除、举报、收藏帖子的菜单");

    oprationView = [[PosterOperationView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
    oprationView.articleId = self.articleId;
    oprationView.clubPost = self.clubPost;
    oprationView.isFav = self.isFav;
    if (appDelegate.isAuthorized) {

        if ([[DataEngine sharedDataEngine].userId isEqualToString:self.clubPost.author.userId.stringValue]) {
            oprationView.isUserSelf = YES;
        } else
            oprationView.isUserSelf = NO;
    } else {
        oprationView.isUserSelf = NO;
    }

    [oprationView uploadData];
    [self.view addSubview:oprationView];
}

/**
 *  添加发表评论区
 */
- (void)loadPublishCommentView {
    self.publishView = [[ClubTextView alloc] initWithFrame:CGRectMake(0, screentHeight - publishCommentViewHeight, screentWith, publishCommentViewHeight)];
    self.publishView.articleId = self.articleId;
    [self.view insertSubview:self.publishView aboveSubview:clubTableView];
    
    __weak __typeof(self)weakSelf = self;
    
    [self.publishView replayCallback:^(NSString *text) {
        [weakSelf requestSendReplay:text];
    }];
}


/**
 请求发送回复

 @param replay 回复
 */
- (void) requestSendReplay:(NSString *)replay
{
    if (!appDelegate.isAuthorized) {
        
        [[DataEngine sharedDataEngine] startLoginFinished:nil];
        
        self.isLoginBack = YES;
        
    } else {
        if ([replay stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0) {
            [appDelegate showAlertViewForTitle:@"" message:@"请输入发表的内容" cancelButton:@"OK"];
            return;
        }
        
        [self.publishView.clubTextView resignFirstResponder];
        self.publishView.sendBtn.enabled = NO;
        
        [appDelegate showIndicatorWithTitle:@"发送中"
                                   animated:YES
                                 fullScreen:NO
                               overKeyboard:YES
                                andAutoHide:NO];
        
        ClubRequest *request = [ClubRequest new];
        [request requestCommentPost:[replay stringByReplacingOccurrencesOfString:@" " withString:@""]
                          articalId:self.articleId
                            success:^(ClubPostComment *_Nullable comment, NSString *message) {
                                
                                [appDelegate hideIndicator];
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"CommentPostSucceed" object:comment];
                                
                                self.publishView.clubTextView.text = @"";
                                if (message) {
                                    [KKZUtility showAlertTitle:@""
                                                        detail:message
                                                        cancel:@"OK"
                                                     clickCall:nil
                                                        others:nil];
                                } else
                                    [KKZUtility showAlertTitle:@""
                                                        detail:@"发送成功"
                                                        cancel:@"OK"
                                                     clickCall:nil
                                                        others:nil];
                                self.publishView.sendBtn.enabled = YES;
                            }
                            failure:^(NSError *_Nullable err) {
                                [appDelegate hideIndicator];
                                self.publishView.sendBtn.enabled = YES;
                            }];
    }
}

#pragma mark - Table View delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2 && self.clubPostCommentList.count) {
        return clubSectionHeaderHeight;
    } else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 2 && self.clubPostCommentList.count) {

        if (!clubSectionHeader) {
            clubSectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, clubSectionHeaderHeight)];
            [clubSectionHeader setBackgroundColor:[UIColor whiteColor]];
            UILabel *clubSectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(marginX, 0, screentWith - marginX * 2, clubSectionHeaderHeight)];
            clubSectionTitle.textColor = [UIColor blackColor];
            clubSectionTitle.font = [UIFont systemFontOfSize:clubSectionHeaderTitleFont];
            clubSectionTitle.text = @"最新评论";
            [clubSectionHeader addSubview:clubSectionTitle];

            clubPostCommentNum = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 100, clubSectionHeaderHeight)];
            clubPostCommentNum.font = [UIFont systemFontOfSize:clubSectionHeaderTitleFont];
            clubPostCommentNum.textColor = [UIColor lightGrayColor];
            [clubSectionHeader addSubview:clubPostCommentNum];

            UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, clubSectionHeaderHeight - 0.6, screentWith, 0.6)];
            [bottomLine setBackgroundColor:[UIColor r:216 g:216 b:216]];
            [clubSectionHeader addSubview:bottomLine];
        }
        clubPostCommentNum.text = [NSString stringWithFormat:@"（%@）", self.clubPost.replyNum.stringValue];
        return clubSectionHeader;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {

        return supportViewHeight;

    } else if (indexPath.section == 1 && self.clubPost.movieId && self.movie) {

        return relateMovieViewHeight;

    } else if (indexPath.section == 2 && self.clubPostCommentList.count) {

        ClubPostComment *clubComment = self.clubPostCommentList[indexPath.row];

        CGSize s = [clubComment.content sizeWithFont:[UIFont systemFontOfSize:clubCellCommentTextFont] constrainedToSize:CGSizeMake(clubCellCommentTextWidth, CGFLOAT_MAX)];
        return clubCommentCellHeight + s.height;
    }

    return 0;
}

#pragma mark - Table View Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1 && self.clubPost.movieId && self.movie) {
        return 1;
    } else if (section == 2 && self.clubPostCommentList.count) {
        return self.clubPostCommentList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) { //帖子点赞区域
        static NSString *ClubPostSupportCellID = @"ClubPostSupportCell";
        ClubPostSupportCell *cell = [clubTableView dequeueReusableCellWithIdentifier:ClubPostSupportCellID];
        if (cell == nil) {
            cell = [[ClubPostSupportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ClubPostSupportCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor clearColor]];
        }
        //        [self configureStyleClubPostSupportCell:cell atIndexPath:indexPath];
        [cell setBackgroundColor:[UIColor clearColor]];

        cell.clubSupportUsers = self.supportList;
        cell.articleId = self.articleId.integerValue;
        cell.postModel = self.clubPost;
        [cell reloadData];
        return cell;
    }

    else if (indexPath.section == 1 && self.clubPost.movieId && self.movie) { //帖子相关电影
        DLog(@"self.movie ========== %@", self.movie);
        static NSString *RelateMovieCellID = @"RelateMovieCell";
        RelateMovieCell *cell = [clubTableView dequeueReusableCellWithIdentifier:RelateMovieCellID];
        if (cell == nil) {
            cell = [[RelateMovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RelateMovieCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        [self configureStyleRelateMovieCell:cell atIndexPath:indexPath];
        return cell;
    }

    else if (indexPath.section == 2 && self.clubPostCommentList.count) { //帖子回复区域
        static NSString *ClubPosterCommentCellID = @"ClubPosterCommentCell";
        ClubPosterCommentCell *cell = [clubTableView dequeueReusableCellWithIdentifier:ClubPosterCommentCellID];
        if (cell == nil) {
            cell = [[ClubPosterCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ClubPosterCommentCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [self configureStyleCell:cell atIndexPath:indexPath];
        return cell;
    }

    return nil;
}

- (void)configureStyleRelateMovieCell:(RelateMovieCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    cell.movieId = [self.clubPost.movieId integerValue];
    cell.movie = self.movie;
    [cell upLoadData];
}

- (void)configureStyleCell:(ClubPosterCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    ClubPostComment *clubComment = self.clubPostCommentList[indexPath.row];
    cell.commont = clubComment;
    [cell upLoadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - KeyboardNotifications
- (void)removeForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShown:(NSNotification *)notification {

    coverKeyBoard.hidden = NO;
    NSDictionary *info = [notification userInfo];
    CGRect endFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue
                     animations:^{
                         [UIView setAnimationBeginsFromCurrentState:YES];
                         [UIView setAnimationCurve:[curve intValue]];
                         CGRect f = self.publishView.frame;
                         f.origin.y = screentHeight - publishCommentViewHeight - endFrame.size.height;
                         self.publishView.frame = f;
                         clubTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, endFrame.size.height, 0.0f);
                     }];
}

- (void)coverKeyBoardClicked:(UIButton *)btn {
    coverKeyBoard.hidden = YES;
    [self dismissKeyBoard];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue
                     animations:^{
                         [UIView setAnimationBeginsFromCurrentState:YES];
                         [UIView setAnimationCurve:[curve intValue]];
                         CGRect f = self.publishView.frame;
                         f.origin.y = screentHeight - publishCommentViewHeight;
                         self.publishView.frame = f;
                         clubTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                     }];
    coverKeyBoard.hidden = YES;
}

#pragma mark - gestureRecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if ([touch.view isKindOfClass:[UIButton class]]) {

        return NO;
    }

    return YES;
}

/**
 *  点击键盘取消按钮
 */
- (void)dismissKeyBoard {
    [self.publishView.clubTextView resignFirstResponder];
}

/**
 *  响应点击事件的方法
 */
- (void)Actiondo:(UIGestureRecognizer *)gesture {
    coverKeyBoard.hidden = YES;
    [self dismissKeyBoard];
}

#pragma mark-- ClubPostHeadViewTextDelegate
- (void)addTableViewHeaderWithClubPostHeadViewHeight:(CGFloat)height {
    [appDelegate hideIndicator];
    CGRect f = clubHeaderView.frame;
    f.size.height = height;
    clubHeaderView.frame = f;
    clubTableView.tableHeaderView = clubHeaderView;
    [clubTableView reloadData];
}

#pragma mark-- ClubPostHeadViewSubscriberDelegate
- (void)addTableViewHeader {
    clubTableView.tableHeaderView = clubHeaderViewSubscriber;
}

#pragma mark override from CommonViewController

- (BOOL)showNavBar {

    return TRUE;
}

- (BOOL)showBackButton {

    return YES;
}

- (BOOL)showTitleBar {

    return TRUE;
}

/**
 *  请求帖子详情
 */

- (void)loadPostDetail {

    [appDelegate showIndicatorWithTitle:@"加载中"
                               animated:YES
                             fullScreen:NO
                           overKeyboard:NO
                            andAutoHide:NO];
    WeakSelf;
    ClubRequest *articleRequeset = [[ClubRequest alloc] init];
    [articleRequeset requestClubPostDetailWithArticleId:self.articleId success:^(ClubPost * _Nullable post) {
        [weakSelf callClubPostDetailApiDidSucceed:post];
    } failure:^(NSError * _Nullable err) {
        NSString *msg = err.userInfo[KKZRequestErrorMessageKey];
        if (err.code == KKZ_REQUEST_STATUS_NETWORK_ERROR) {
            msg = KNET_FAULT_MSG;
        }
         [UIAlertView showAlertView:msg buttonText:@"确定" buttonTapped:^{
             [self popViewControllerAnimated:YES];
         }];
    }];
}

- (void)callClubPostDetailApiDidSucceed:(ClubPost *)post {

    [appDelegate hideIndicator];
    self.clubPost = post;
    self.clubPostContent = self.clubPost.content;

    self.isFav = self.clubPost.isFaverite;
    self.postType = self.clubPost.type.integerValue;

    if (self.postType == 1) {
        clubHeaderView = [[ClubPostHeadViewText alloc] initWithFrame:CGRectMake(0, 0, screentWith, 1)];
        clubHeaderView.delegate = self;
        [self setStatusBarLightStyle];
        clubHeaderView.clubPost = self.clubPost;
        [clubHeaderView uploadData];
    } else if (self.postType == 2) { //音频
        NSString *audioPlayUrl = @"";
        if (self.clubPost.filesAudio.count > 0) {
            audioPlayUrl = self.clubPost.filesAudio[0];
        }
        clubHeaderViewAudio = [[ClubPostHeadViewAudio alloc] initWithFrame:CGRectMake(0, 0, screentWith, ClubPostHeadViewAudioHeight) withAudioUrl:audioPlayUrl];
        clubHeaderViewAudio.clubPost = self.clubPost;
        clubHeaderViewAudio.backgroundColor = [UIColor lightGrayColor];
        clubHeaderViewAudio.videoPostInfoView.delegate = self;
        [clubHeaderViewAudio uploadData];
        clubTableView.frame = CGRectMake(0, 0, screentWith, screentHeight);
        [self.navBarView setBackgroundColor:[UIColor clearColor]];
        [self.statusView setBackgroundColor:self.navBarView.backgroundColor];
        [appDelegate hideIndicator];
    } else if (self.postType == 3) { //视频
        NSString *videoPlayUrl = @"";
        if (self.clubPost.filesVideo.count > 0) {
            videoPlayUrl = self.clubPost.filesVideo[0];
        }
        clubHeaderViewVideo = [[ClubPostHeadViewVideo alloc] initWithFrame:CGRectMake(0, 0, screentWith, ClubPostHeadViewVideoHeight) withVideoUrl:videoPlayUrl];
        clubHeaderViewVideo.clubPost = self.clubPost;
        clubHeaderViewVideo.videoPostInfoView.delegate = self;
        if (self.clubPost.filesImage.count > 0) {
            clubHeaderViewVideo.videoCoverPath = self.clubPost.filesImage[0];
        }
        [clubHeaderViewVideo uploadData];
        clubTableView.frame = CGRectMake(0, self.contentPositionY, screentWith, screentHeight - self.contentPositionY);
        clubHeaderViewVideo.tablePointY = clubTableView.frame.origin.y;
        [self.navBarView setBackgroundColor:[UIColor clearColor]];
        [self.statusView setBackgroundColor:[UIColor blackColor]];

        [self.kkzBackBtn setImage:[UIImage imageNamed:@"arrowGrayCover"] forState:UIControlStateNormal];
        [self.kkzBackBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 10, 4, 20)];

        [rightBtn setImage:[UIImage imageNamed:@"shareGrayCover"] forState:UIControlStateNormal];
        [appDelegate hideIndicator];
    } else if (self.postType == 4) { //订阅号
        clubHeaderViewSubscriber = [[ClubPostHeadViewSubscriber alloc] initWithFrame:CGRectMake(0, 0, screentWith, 90)];
        clubHeaderViewSubscriber.delegate = self;
        //        clubHeaderViewSubscriber.backgroundColor = [UIColor redColor];
        clubTableView.tableHeaderView = clubHeaderViewSubscriber;
        [self setStatusBarLightStyle];
        clubHeaderViewSubscriber.clubPost = self.clubPost;
        clubHeaderViewSubscriber.content = self.clubPostContent;
        [clubHeaderViewSubscriber uploadData];

        [appDelegate hideIndicator];
    }

    [clubTableView reloadData];

    [self loadMovieDetail];
    [self loadSupportList];
    [self loadClubPostReplyList];
}

/**
 *  请求最近点赞列表
 */
- (void)loadSupportList {
    WeakSelf;
    ClubRequest *supportListRequeset = [[ClubRequest alloc] init];

    [supportListRequeset requestSupportListWithArticleId:[self.clubPost.articleId integerValue]
            success:^(NSArray *_Nullable userList) {
                [weakSelf callSupportListApiDidSucceed:userList];
            }
            failure:^(NSError *_Nullable err) {
                [weakSelf callSupportListApiDidFailed:err];
            }];
}

- (void)callSupportListApiDidSucceed:(id)responseData {
    self.supportList = responseData;
    [clubTableView reloadData];
}
- (void)callSupportListApiDidFailed:(id)responseData {
    // [appDelegate showAlertViewForTaskInfo:userInfo];
}

/**
 *  请求帖子回复列表
 */
- (void)loadClubPostReplyList {
    currentPage = 1;

    WeakSelf;
    ClubRequest *postReplyRequeset = [[ClubRequest alloc] init];
    [postReplyRequeset requestPostReplyListWithArticleId:self.articleId
            currentPage:currentPage
            success:^(NSArray *_Nullable clubPostComments, BOOL hasMore) {
                [weakSelf callClubPostReplyListApiDidSucceed:clubPostComments hasMore:hasMore];
            }
            failure:^(NSError *_Nullable err) {
                [weakSelf callClubPostReplyListApiDidFailed:err];
            }];
}

- (void)callClubPostReplyListApiDidSucceed:(NSArray *)responseData hasMore:(BOOL)hasMore {
    showMoreFooterView.isLoading = NO;

    self.hasMore = hasMore;

    NSMutableArray *res = [[NSMutableArray alloc] initWithArray:responseData];

    if (currentPage <= 1) {

        self.clubPostCommentList = [[NSMutableArray alloc] initWithArray:res];

    } else {

        if (res.count > 0) {

            [self.clubPostCommentList addObjectsFromArray:res];
        }
    }

    [clubTableView reloadData];
}
- (void)callClubPostReplyListApiDidFailed:(id)responseData {
    //    [appDelegate showAlertViewForTaskInfo:userInfo];
}

- (void)morePostReplyList {
    currentPage += 1;

    WeakSelf;
    ClubRequest *postReplyRequeset = [[ClubRequest alloc] init];
    [postReplyRequeset requestPostReplyListWithArticleId:self.articleId
            currentPage:currentPage
            success:^(NSArray *_Nullable clubPostComments, BOOL hasMore) {
                [weakSelf callClubPostReplyListApiDidSucceed:clubPostComments hasMore:hasMore];
            }
            failure:^(NSError *_Nullable err) {
                [weakSelf callClubPostReplyListApiDidFailed:err];
            }];
}

/**
 *  是否对该贴点赞过
 */
- (void)hasUpPost {
    ClubTask *task = [[ClubTask alloc] initHasedUpWithArticleId:self.articleId.integerValue
                                                       Finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                           [self hasUpPostFinish:userInfo andSucced:succeeded];
                                                       }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)hasUpPostFinish:(NSDictionary *)userInfo andSucced:(BOOL)succeed {
    if (succeed) {
        //        [appDelegate showAlertViewForTitle:@"" message:@"已删除该贴" cancelButton:@"OK"];
        self.hasUp = YES;
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

#pragma scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.postType == 2) {
        if (clubTableView.contentOffset.y >= ClubPostHeadViewAudioHeight - 44) {
            //调整导航栏的背景色
            [self.statusView setBackgroundColor:navBackgroundColor];
            [self.navBarView setBackgroundColor:navBackgroundColor];
            [self.kkzBackBtn setImage:[UIImage imageNamed:@"backButtonImg"] forState:UIControlStateNormal];

        } else {
            [self.navBarView setBackgroundColor:[UIColor clearColor]];
            [self.statusView setBackgroundColor:self.navBarView.backgroundColor];
        }
    } else if (self.postType == 3) {

        if (clubTableView.contentOffset.y >= ClubPostHeadViewVideoHeight - 44) {
            [self.statusView setBackgroundColor:navBackgroundColor];
            [self.navBarView setBackgroundColor:navBackgroundColor];
            [self.kkzBackBtn setImage:[UIImage imageNamed:@"backButtonImg"] forState:UIControlStateNormal];
            [self.kkzBackBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
            [rightBtn setImage:[UIImage imageNamed:@"shareWhiteCover"] forState:UIControlStateNormal];
        } else {
            [self.kkzBackBtn setImage:[UIImage imageNamed:@"arrowGrayCover"] forState:UIControlStateNormal];
            [self.kkzBackBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 10, 4, 20)];
            [self.navBarView setBackgroundColor:[UIColor clearColor]];
            [self.statusView setBackgroundColor:[UIColor blackColor]];
            [rightBtn setImage:[UIImage imageNamed:@"shareGrayCover"] forState:UIControlStateNormal];
        }
    }

    //在拖动

    if (scrollView.isDragging) {

        if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {

            [refreshHeaderView setState:EGOOPullRefreshNormal];

        } else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {

            [refreshHeaderView setState:EGOOPullRefreshPulling];
        }

    } else {
    }

    //进入下方区域+45像素

    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45) {

        if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore && refreshHeaderView.state != EGOOPullRefreshLoading) {
        }
    }

    //设置订阅号滚动条滚动的距离
    if (self.clubPost.type.integerValue == 4) {
        [clubHeaderViewSubscriber scrollViewDidScroll:scrollView.contentOffset.y];
    }
}

//拖动（释放手指）停止的时候执行

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (refreshHeaderView.state == EGOOPullRefreshLoading) {

        return;
    }

    //上拉刷新

    //    if (scrollView.contentOffset.y <= -65.0f && self.hasMore) {

    if (scrollView.contentOffset.y <= -65.0f) {

        if (!showMoreFooterView.hasNoMore) {

            //            [self performSelector:@selector(loadClubPostReplyList) withObject:nil afterDelay:0.2];
        }
    }

    //下拉刷新

    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45 && self.hasMore) {

        if (!showMoreFooterView.isLoading && refreshHeaderView.state != EGOOPullRefreshLoading) {

            [self morePostReplyList];
        }
    }
}

- (void)addTableViewHeaderWithVideoPostInfoViewHeight:(CGFloat)height {

    if (self.postType == 2) {
        clubHeaderViewAudio.videoPostInfoView.frame = CGRectMake(0, ClubPostHeadViewAudioHeight, screentWith, height);

        clubHeaderViewAudio.frame = CGRectMake(0, 0, screentWith, height + ClubPostHeadViewAudioHeight);

        clubTableView.tableHeaderView = clubHeaderViewAudio;
        [clubTableView reloadData];
    } else if (self.postType == 3) {
        clubHeaderViewVideo.videoPostInfoView.frame = CGRectMake(0, ClubPostHeadViewVideoHeight, screentWith, height);

        clubHeaderViewVideo.frame = CGRectMake(0, 0, screentWith, height + ClubPostHeadViewVideoHeight);

        clubTableView.tableHeaderView = clubHeaderViewVideo;
        [clubTableView reloadData];
    }
}

- (void)statisticsRequestWithInfName:(NSString *)infName {
    DLog(@"infName ===== %@", infName);
    StatisticsTask *task = [[StatisticsTask alloc] initStatisticsClubByInf:infName
                                                             withArticleId:[NSString stringWithFormat:@"%ld", (long) self.articleId]
                                                                  finished:^(BOOL succeeded, NSDictionary *userInfo){

                                                                  }];

    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)loadMovieDetail {

    WeakSelf
            MovieRequest *movieRequest = [[MovieRequest alloc] init];
    [movieRequest requestMovieDetailWithMovieId:[self.clubPost.movieId integerValue]
            success:^(id movieDetail) {

                [weakSelf callMovieDetailApiDidSucceed:movieDetail];

            }
            failure:^(NSError *_Nullable err) {
                [weakSelf callMovieDetailApiDidFailed:err];
            }];
}

- (void)callMovieDetailApiDidSucceed:(id)responseData {
    self.movie = responseData;
    [clubTableView reloadData];
}
- (void)callMovieDetailApiDidFailed:(id)responseData {
}

@end
