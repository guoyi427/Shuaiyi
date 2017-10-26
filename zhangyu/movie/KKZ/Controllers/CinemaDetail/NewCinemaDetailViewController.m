//
//  影院详情页面
//
//  Created by 艾广华 on 15/12/8.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "NewCinemaDetailViewController.h"

#import "Cinema.h"
#import "CinemaDetailCommonModel.h"
#import "CinemaDetailHeaderView.h"
#import "CinemaLocationViewController.h"
#import "Comment.h"
#import "KKZUtility.h"
#import "NewCinemaDetailModel.h"
#import "NewCinemaDetailView.h"
#import "NewCinemaDetailViewController+layout.h"
#import "PublishPostView.h"
#import "RIButtonItem.h"
#import "RatingView.h"
#import "RequestLoadingView.h"
#import "UIAlertView+Blocks.h"
#import "UIColor+Hex.h"
#import "UIColorExtra.h"
#import "UIConstants.h"
#import "UserManager.h"

#import "CinemaDetail.h"
#import "CinemaRequest.h"

/******************顶部背景视图********************/
static const CGFloat homeHeaderViewHeight = 140.0f;

/***************导航条********************/
const static CGFloat leftButtonLeft = 15.0f;

/***************发帖按钮***************/
const static CGFloat sendButtonRight = 10.0f;
const static CGFloat sendButtonBottom = 30.0f;

@interface NewCinemaDetailViewController () <NewCinemaDetailViewDelegate,
                                             CinemaDetailHeaderDelegate,
                                             CinemaDetailCommonModelDelegate>

/**
 *  影院详情列表
 */
@property (nonatomic, strong) NewCinemaDetailView *cinemaListView;

/**
 *  影院详情的表头视图
 */
@property (nonatomic, strong) CinemaDetailHeaderView *cinemaDetailHeaderView;

/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton *backBtn;

/**
 *  顶部背景视图
 */
@property (nonatomic, strong) UIImageView *homeBackgroundView;

/**
 *  影院ID
 */
@property (nonatomic, assign) NSInteger cinemaId;

/**
 *  是否已经收藏过影院
 */
@property (nonatomic, assign) BOOL isCollected;

/**
 *  发帖按钮
 */
@property (nonatomic, strong) UIButton *sendButton;

/**
 分享信息
 */
@property (nonatomic, strong) ShareContent *share;

@end

@implementation NewCinemaDetailViewController
@synthesize cinemaListView = _cinemaListView;

#pragma mark - init Method

- (id)initWithExtraData:(NSString *)extra1
                 extra2:(NSString *)extra2
                 extra3:(NSString *)extra3 {
    self = [super init];
    if (self) {
        if (extra1) {
            self.cinemaId = [extra1 integerValue];
        }
    }
    return self;
}

- (id)initWithCinema:(NSInteger)cinemaId {
    self = [super init];
    if (self) {
        self.cinemaId = cinemaId;
    }
    return self;
}

/**
 *  视图加载过
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    //加载顶部视图
    [self loadTopView];

    //加载表视图
    [self loadTableHeaderView];

    //请求影院收藏详情
    if (appDelegate.isAuthorized) {
        [self refreshFavCinema];
    }

    //加载导航条
    [self loadNarBar];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [KKZAnalytics postActionWithEvent:[[KKZAnalyticsEvent alloc] initWithCinema:self.cinemaDetail] action:AnalyticsActionCinema_details];
}
- (void)loadNarBar {
    //设置视图背景颜色
    [self.view setBackgroundColor:[UIColor r:245 g:245 b:245]];

    [self.navBarView addSubview:self.backBtn];

    //将导航条视图提前
    self.navBarView.backgroundColor = [UIColor clearColor];
}

- (void)loadTopView {

    //添加顶部背景视图
    [self.view addSubview:self.homeBackgroundView];
}

/**
 *  添加表头信息
 */
- (void)loadTableHeaderView {

    //添加影院详情页面
    if (self.cinemaDetail) {
        self.cinemaDetailHeaderView.cinemaName = self.cinemaDetail.cinemaName;
        self.cinemaDetailHeaderView.cinemaTel = self.cinemaDetail.cinemaTel;
        self.cinemaDetailHeaderView.cinemaIntro = self.cinemaDetail.cinemaIntro;
        self.cinemaDetailHeaderView.cinemaAddress = self.cinemaDetail.cinemaAddress;
        self.cinemaDetailHeaderView.point = self.cinemaDetail.point.floatValue;
        [self.cinemaDetailHeaderView updateCinemaDisplay];
    } else {
        [self requestCinemaDetail];
    }
    [self.cinemaListView setTableHeader:self.cinemaDetailHeaderView];
    [self.view addSubview:self.cinemaListView];

    //如果有特色信息就直接传过去,没有就请求
    self.cinemaListView.cinemaSpecialInfo = self.specilaInfoList;

    //开始请求
    [self.cinemaListView beginRequestNet];

    //添加发帖按钮
//    [self.view addSubview:self.sendButton];
}

/**
 *  MARK: 请求电影详情
 */
- (void)requestCinemaDetail {
    CinemaRequest *request = [[CinemaRequest alloc] init];

    [request
            requestCinemaDetail:[NSDictionary
                                        dictionaryWithObjectsAndKeys:
                                                [NSNumber numberWithInteger:self.cinemaId],
                                                @"cinema_id", nil]
            success:^(CinemaDetail *cinemaDetail, ShareContent *share) {
                self.cinemaDetail = cinemaDetail;
                self.share = share;
                [self loadTableHeaderView];
            }
            failure:^(NSError *_Nullable err) {
                DLog(@"request cinema detail err:%@", err);
            }];
}

/**
 *  请求影院收藏情况
 */
- (void)refreshFavCinema {

    CinemaDetailCommonModel *model = [CinemaDetailCommonModel sharedInstance];
    model.delegate = self;
    [model refreshFavCinemaWithCinemaId:self.cinemaId];
}

/**
 *  收藏影院请求
 */
- (void)doCollectCinema {
    if ([[UserManager shareInstance] isUserAuthorizedWithController:self]) {
        CinemaDetailCommonModel *model = [CinemaDetailCommonModel sharedInstance];
        model.delegate = self;
        [model doCollectCinemaWithCinemaId:self.cinemaId];
    }
}

- (void)cinemaCollectStatusChanged:(BOOL)isCollect {
    self.isCollected = isCollect;
}

#pragma mark - getter Method

- (UIImageView *)homeBackgroundView {
    if (!_homeBackgroundView) {

        //头部背景视图
        _homeBackgroundView =
                [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth,
                                                              homeHeaderViewHeight)];
        _homeBackgroundView.backgroundColor = [UIColor clearColor];
        _homeBackgroundView.clipsToBounds = YES;
        _homeBackgroundView.image = [UIImage imageNamed:@"cinema_post_bg"];

        //阴影图片视图
        UIImageView *topShadow =
                [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth,
                                                              homeHeaderViewHeight)];
        topShadow.clipsToBounds = YES;
        topShadow.backgroundColor = [UIColor clearColor];
        topShadow.autoresizingMask =
                UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        topShadow.image = [UIImage imageNamed:@"up_shadow_img"];
        [_homeBackgroundView addSubview:topShadow];
    }
    return _homeBackgroundView;
}

- (NewCinemaDetailView *)cinemaListView {
    if (!_cinemaListView) {
        CGRect listFrame = CGRectMake(0, CGRectGetMaxY(self.navBarView.frame), kCommonScreenWidth,
                                      kCommonScreenHeight - CGRectGetMaxY(self.navBarView.frame));
        _cinemaListView = [[NewCinemaDetailView alloc] initWithFrame:listFrame
                                                        withCinemaId:self.cinemaId];
        _cinemaListView.cinemaName = self.cinemaDetail.cinemaName;
        _cinemaListView.detailDelegate = self;
    }
  return _cinemaListView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        //返回按钮
        UIImage *backImg = [UIImage imageNamed:@"backButtonImg"];
        CGFloat backButtonWidth = 2 * leftButtonLeft + backImg.size.width;
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame =
                CGRectMake(0, 0, backButtonWidth, self.navBarView.frame.size.height);
        [_backBtn setImage:backImg forState:UIControlStateNormal];
        _backBtn.tag = backButtonTag;
        [_backBtn addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (CinemaDetailHeaderView *)cinemaDetailHeaderView {
    if (!_cinemaDetailHeaderView) {
        _cinemaDetailHeaderView = [[CinemaDetailHeaderView alloc]
                initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 300)];
        _cinemaDetailHeaderView.cinemaName = self.cinemaName;
        _cinemaDetailHeaderView.delegate = self;
    }
    return _cinemaDetailHeaderView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        UIImage *sendImg = [UIImage imageNamed:@"subscriberBtnIcon"];
        _sendButton = [UIButton buttonWithType:0];
        CGRect sendFrame =
                CGRectMake(kCommonScreenWidth - sendImg.size.width - sendButtonRight,
                           kCommonScreenHeight - sendImg.size.height - sendButtonBottom,
                           sendImg.size.width, sendImg.size.height);
        _sendButton.frame = sendFrame;
        [_sendButton setBackgroundImage:sendImg forState:UIControlStateNormal];
        _sendButton.tag = sendClubButtonTag;
        [_sendButton addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

#pragma mark - setter Method

- (void)setIsCollected:(BOOL)isCollected {
    _isCollected = isCollected;
    if (!_isCollected) {
        [self.kkzRightBtn setImage:[UIImage imageNamed:@"Star_white"]
                          forState:UIControlStateNormal];
        [self.changeRightBtn setImage:[UIImage imageNamed:@"Star_white"]
                             forState:UIControlStateNormal];
    } else {
        [self.kkzRightBtn setImage:[UIImage imageNamed:@"Star_yellow"]
                          forState:UIControlStateNormal];
        [self.changeRightBtn setImage:[UIImage imageNamed:@"Star_yellow"]
                             forState:UIControlStateNormal];
    }
}

- (void)callCinema {

    //如果影院没有电话
    if (![self.cinemaDetail.cinemaTel length]) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"抱歉，暂时还没有该影院的电话"
                              cancelButton:@"OK"];
        return;
    }
    
    [UIAlertView showAlertView:@"打电话给影院吗?"
                    cancelText:@"取消"
                  cancelTapped:nil
                        okText:@"呼叫"
                      okTapped:^{
                          
                          NSString *telephone = self.cinemaDetail.cinemaTel;
                          [appDelegate makePhoneCallWithTel:telephone];
                      }];
}

/**
 *  根据移动的距离改变导航栏颜色
 *
 *  @param distance 移动的距离
 */
- (void)changeNavigationColorAccordingToTheMovingDistance:(CGFloat)distance {
    CGFloat changeHeight =
            homeHeaderViewHeight - CGRectGetMaxY(self.navBarView.frame) - 1;
    if (distance >= changeHeight) {
        [self setColorfulStatusBar:appDelegate.kkzBlue];
    } else {
        [self setNormalStatusBar:[UIColor clearColor]];
    }
}

#pragma mark - NewCinemaDetailViewDelegate

- (void)listTableDidScroll:(UIScrollView *)listScrollView {
    CGFloat changeFactor = 0;
    //如果滚动条向上移动
    if (listScrollView.contentOffset.y > 0) {

        //移动顶部背景视图
        CGRect homeFrame = self.homeBackgroundView.frame;
        homeFrame.origin.y = -listScrollView.contentOffset.y;
        self.homeBackgroundView.frame = homeFrame;

        //改变的因素
        changeFactor = 0;

    } else {

        //改变的因素
        changeFactor = listScrollView.contentOffset.y;

        //改变顶部背景视图
        CGRect homeFrame = self.homeBackgroundView.frame;
        homeFrame.origin.y = 0;
        homeFrame.origin.x = changeFactor / 2.0f;
        homeFrame.size.width = kCommonScreenWidth - changeFactor;
        homeFrame.size.height = homeHeaderViewHeight - changeFactor;
        self.homeBackgroundView.frame = homeFrame;
    }

    //根据移动的距离改变导航栏颜色
    [self changeNavigationColorAccordingToTheMovingDistance:listScrollView
                                                                    .contentOffset.y];
}

/**
 *  下拉刷新请求
 */
- (void)pullRefreshBeginRequest {

    //更新评论列表
    [self.cinemaListView beginRequestNet];
}

- (void)cinemaDetailHeaderHeightChange {
    [self.cinemaListView setTableHeader:self.cinemaDetailHeaderView];
}

- (void)didSelectCallLocationButton {
    //统计事件：查看影院地图
    StatisEvent(EVENT_CINEMA_MAP);

    //进入到地图页面
    CinemaLocationViewController *clv = [[CinemaLocationViewController alloc]
            initWithCinema:[NSString stringWithFormat:@"%ld", (long) self.cinemaId]];
    [self pushViewController:clv animation:CommonSwitchAnimationBounce];
}

- (void)didSelectCallPhoneButton {
    //统计事件：拨打影城电话
    StatisEvent(EVENT_CINEMA_TELEPHONE);

    //打电话
    [self callCinema];
}

#pragma mark - public method

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case backButtonTag: {
            [self popViewControllerAnimated:YES];
            break;
        }
        case rightButtonTag: {

            //收藏请求
            [self doCollectCinema];

            break;
        }
        case sendClubButtonTag: {
            if ([[UserManager shareInstance] isUserAuthorizedWithController:self]) {
                PublishPostView *publishPostV = [[PublishPostView alloc]
                        initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
                publishPostV.cinemaId =
                        [NSString stringWithFormat:@"%ld", (long) self.cinemaId];
                publishPostV.cinemaName = self.cinemaName;
                UIWindow *keywindow =
                        [[[UIApplication sharedApplication] delegate] window];
                [keywindow addSubview:publishPostV];
            }
            break;
        }
        default:
            break;
    }
}

- (NSString *)changeRightButtonImage {
    if (self.isCollected) {
        return @"Star_yellow";
    }
    return @"Star_white";
}

- (NSString *)changeNavBarTitle {
    return self.cinemaName;
}

- (NSString *)rightButtonImageName {
    return @"Star_white";
}

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return FALSE;
}

- (BOOL)showTitleBar {
    return FALSE;
}

- (BOOL)setRightButton {
    return TRUE;
}

- (BOOL)isNavMainColor {
    return NO;
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end
