//
//  首页 - 电影列表
//
//  Created by KKZ on 16/1/23.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AdvertiseView.h"

#import "DataEngine.h"
#import "LocationComponent.h"
#import "MovieDetailViewController.h"
#import "MoviePlayerViewController.h"
#import "MoviesNewViewController.h"
#import "PPiFlatSegmentedControl.h"
#import "UserDefault.h"

// task
#import "KotaTask.h"
#import "TaskQueue.h"

// model
#import "Banner.h"
#import "City.h"
#import "HXUserInfo.h"
#import "Movie.h"

//正在上映和即将上映电影列表控制器
//#import "InCommingMovieListVc.h"
//#import "MovieListVc.h"
#import "MoviesBaseViewController.h"

#import "AppRequest.h"
#import "KOKOLocationView.h"

#import "MovieListPosterCollectionViewCell.h"
#import "UIViewController+SFTrainsitionExtension.h"
#import "MJRefresh.h"
#import "KoMovie-Swift.h"

#define KOKOLOCATIONVIEWWIDTH ((screentWith - 158) * 0.5 - 10)
#define KOKOLOCATIONVIEWHEIGHT 44.0f

#define Banner_Height (75 * (screentWith / 320))

@interface MoviesNewViewController () <KOKOLocationViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
{
    UIScrollView *_contentView;
    UICollectionView *_currentMovieCollectionView;
    UICollectionView *_futureMovieCollectionView;
    
    NSMutableArray *_currentMovieList;
    NSMutableArray *_futureMovieList;
}
/**
 *  定位区域View
 */
@property (nonatomic, strong) KOKOLocationView *locationView;

/**
 *  开屏广告
 */
@property (nonatomic, strong) AdvertiseView *advView;

//@property (nonatomic, strong) MovieListVc *movieListVc;
//@property (nonatomic, strong) InCommingMovieListVc *inCommingListViewVc;
@property (nonatomic, strong) UIButton *ticketRemindBtn;

/**
 当前选中的tag 0: 正在热映 1:即将上映
 */
@property (nonatomic) NSInteger currentTag;

@property (nonatomic) BOOL didAppear;
@end

@implementation MoviesNewViewController

- (void)dealloc {
    [appDelegate removeObserver:self forKeyPath:@"changeCity"];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"appBecomeActive"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"imagePlayerViewHeightMovie"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"locationCityChanged"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"showAlertView"
                                                  object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setStatusBarLightStyle];
    
    [[KKZRemoteNotificationCenter sharedInstance] checkNotify];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _currentMovieList = [[NSMutableArray alloc] init];
    _futureMovieList = [[NSMutableArray alloc] init];
    
    //加载导航栏
    [self loadNavBar];

    //加载广告位
    [self loadBanners];
    
    //初始化且注册电影列表视图
    [self setupCollectionView];

    //设置视图显示优先级
    _isShowBanner = NO;

    //添加事件通知
    [self addNotification];

    //是否切换为当前定位城市的用户提示标识
    self.isGpsCity = YES;

    [self loadNewData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //页面进入用户视线时进行一系列的加载数据的判断
    [self loadData];

    if (!self.banner && USER_CITY && !appDelegate.cityChange) {
        //加载开机广告
        [self openAdvertiseQuery];
    }

    //是否需要展示强制更新的信息
    [self showAlertView];
    
    self.didAppear = YES;
    [self checkRemindOrder:NO];
}

- (void)setupCollectionView {
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screentWith, CGRectGetHeight(self.view.frame)-64)];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.contentSize = CGSizeMake(0, 231*2 + Banner_Height);
    [self.view addSubview:_contentView];
    
    WeakSelf
    [_contentView addHeaderWithCallback:^{
        [weakSelf loadNewData];
    }];
    
    //  banner
    [_contentView addSubview:_imgPlayer];
    
    //  影片列表背景
    UIView *_movieListContentView = [[UIView alloc] initWithFrame:CGRectMake(0, Banner_Height, kAppScreenWidth, 231 * 2)];
    _movieListContentView.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_movieListContentView];
    
    UIImage *gotoOrderTipImage = [UIImage imageNamed:@"arrowGray"];
    
    //  热映影片
    UIImageView *yellowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Movie_current_selected"]];
    [_movieListContentView addSubview:yellowView];
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.mas_equalTo(15);
    }];
    UILabel *sectionLabel = [UILabel new];
    sectionLabel.text = @"热映影片";
    sectionLabel.backgroundColor = [UIColor clearColor];
    sectionLabel.textColor = [UIColor colorWithHex:@"333333"];
    sectionLabel.font = [UIFont systemFontOfSize:14];
    [_movieListContentView addSubview:sectionLabel];
    [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yellowView.mas_right).offset(5);
        make.centerY.equalTo(yellowView);
        make.width.equalTo(@(80));
        make.height.equalTo(@(14));
    }];
    
    //    gotoOrderTipImage
    
    UILabel *moreFilmLabel = [[UILabel alloc] init];
    moreFilmLabel.textColor = [UIColor colorWithHex:@"#333333"];
    moreFilmLabel.font = [UIFont systemFontOfSize:13];
    moreFilmLabel.text = @"更多";
    [_movieListContentView addSubview:moreFilmLabel];
    [moreFilmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_movieListContentView).offset(-(5+15+gotoOrderTipImage.size.width));
        make.size.mas_equalTo(CGSizeMake(28, 13));
        make.centerY.equalTo(sectionLabel.mas_centerY);
    }];
    
    UIImageView *moreFilmImageView = [[UIImageView alloc] init];
    moreFilmImageView.image = gotoOrderTipImage;
    [_movieListContentView addSubview:moreFilmImageView];
    [moreFilmImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_movieListContentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(gotoOrderTipImage.size.width, gotoOrderTipImage.size.height));
        make.centerY.equalTo(sectionLabel.mas_centerY);
    }];
    
    UIButton *gotoMovieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoMovieBtn.backgroundColor = [UIColor clearColor];
    [_movieListContentView addSubview:gotoMovieBtn];
    [gotoMovieBtn addTarget:self action:@selector(gotoMovieListBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [gotoMovieBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.mas_equalTo(5);
        make.height.equalTo(@(40));
    }];
    
    UICollectionViewFlowLayout *movieFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [movieFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _currentMovieCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:movieFlowLayout];
    _currentMovieCollectionView.backgroundColor = [UIColor clearColor];
    [_movieListContentView addSubview:_currentMovieCollectionView];
    _currentMovieCollectionView.showsHorizontalScrollIndicator = NO;
    _currentMovieCollectionView.delegate = self;
    _currentMovieCollectionView.dataSource = self;
    [_currentMovieCollectionView registerClass:[MovieListPosterCollectionViewCell class] forCellWithReuseIdentifier:@"MovieListPosterCollectionViewCell"];
    [_currentMovieCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(yellowView.mas_bottom).offset(15);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(158+20));
    }];
    
    //  即将上映
    UIImageView *yellowView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Movie_Future_selected"]];
    [_movieListContentView addSubview:yellowView2];
    [yellowView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(_currentMovieCollectionView.mas_bottom).offset(15);
    }];
    UILabel *sectionLabel2 = [UILabel new];
    sectionLabel2.text = @"即将上映";
    sectionLabel2.backgroundColor = [UIColor clearColor];
    sectionLabel2.textColor = [UIColor colorWithHex:@"333333"];
    sectionLabel2.font = [UIFont systemFontOfSize:14];
    [_movieListContentView addSubview:sectionLabel2];
    [sectionLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yellowView2.mas_right).offset(5);
        make.centerY.equalTo(yellowView2);
        make.width.equalTo(@(80));
        make.height.equalTo(@(14));
    }];
    
    //    gotoOrderTipImage
    
    UILabel *moreFilmLabel2 = [[UILabel alloc] init];
    moreFilmLabel2.textColor = [UIColor colorWithHex:@"#333333"];
    moreFilmLabel2.font = [UIFont systemFontOfSize:13];
    moreFilmLabel2.text = @"更多";
    [_movieListContentView addSubview:moreFilmLabel2];
    [moreFilmLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_movieListContentView).offset(-(5+15+gotoOrderTipImage.size.width));
        make.size.mas_equalTo(CGSizeMake(28, 13));
        make.centerY.equalTo(sectionLabel2.mas_centerY);
    }];
    
    UIImageView *moreFilmImageView2 = [[UIImageView alloc] init];
    moreFilmImageView2.image = gotoOrderTipImage;
    [_movieListContentView addSubview:moreFilmImageView2];
    [moreFilmImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_movieListContentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(gotoOrderTipImage.size.width, gotoOrderTipImage.size.height));
        make.centerY.equalTo(sectionLabel2.mas_centerY);
    }];
    
    UIButton *gotoMovieBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoMovieBtn2.backgroundColor = [UIColor clearColor];
    [_movieListContentView addSubview:gotoMovieBtn2];
    [gotoMovieBtn2 addTarget:self action:@selector(gotoMovieListBtnAction2) forControlEvents:UIControlEventTouchUpInside];
    [gotoMovieBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.centerY.equalTo(yellowView2);
        make.height.equalTo(@(40));
    }];
    
    UICollectionViewFlowLayout *movieFlowLayout2 = [[UICollectionViewFlowLayout alloc] init];
    [movieFlowLayout2 setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    _futureMovieCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:movieFlowLayout2];
    _futureMovieCollectionView.backgroundColor = [UIColor clearColor];
    [_movieListContentView addSubview:_futureMovieCollectionView];
    _futureMovieCollectionView.showsHorizontalScrollIndicator = NO;
    _futureMovieCollectionView.delegate = self;
    _futureMovieCollectionView.dataSource = self;
    [_futureMovieCollectionView registerClass:[MovieListPosterCollectionViewCell class] forCellWithReuseIdentifier:@"FutureCollectionCell"];
    [_futureMovieCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(yellowView2.mas_bottom).offset(15);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(158+20));
    }];
}

#pragma mark 添加事件通知
- (void)addNotification {

    //添加城市的观察者
    [appDelegate addObserver:self
                  forKeyPath:@"changeCity"
                     options:0
                     context:NULL];

    //广告位是否显示通知
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(imgPlayerHeight:)
                   name:@"imagePlayerViewHeightMovie"
                 object:nil];

    //根据定位城市更新列表数据
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(locationCityChanged:)
                   name:@"locationCityChanged"
                 object:nil];

    //从后台返回如果影片列表中没有数据就重新请求网络
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(refreashMovietable)
                   name:@"appBecomeActive"
                 object:nil];

    //取消广告位是否需要重新弹出更新框
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAlertView)
                                                 name:@"showAlertView"
                                               object:nil];
}

#pragma mark handle notifications
- (void)newsBannerFinished:(NSArray *)banners status:(BOOL)succeeded {
    
    if (succeeded) {
        if (banners.count == 0) {
            return;
        }
        self.banner = banners.firstObject;
        if (self.banner.imagePath.length) {
            
            //图片的url
            NSString *imageURL = self.banner.imagePath;
            if (imageURL.length) {
                [SDWebImageManager.sharedManager
                 downloadImageWithURL:[NSURL URLWithString:imageURL]
                 options:SDWebImageProgressiveDownload
                 progress:nil
                 completed:^(UIImage *image, NSError *error,
                             SDImageCacheType cacheType, BOOL finished,
                             NSURL *imageURL) {
                     if (image) {
                         if (self.advView) {
                             [self.advView setAdvertiseImage:image];
                         } else {
                             __weak typeof(self) weakself = self;
                             self.advView = [[AdvertiseView alloc]
                                             initWithFrame:CGRectMake(0, 0, screentWith,
                                                                      screentHeight)];
                             self.advView.banner = self.banner;
                             [self.advView setAdvertiseImage:image];
                             self.advView.appdelegateAlertDismiss =
                             ^(BOOL dismiss) {
                                 if (dismiss) {
                                     weakself.needAlert = YES;
                                 }
                             };
                             UIWindow *keywindow =
                             [[UIApplication sharedApplication] keyWindow];
                             [keywindow addSubview:self.advView];
                         }
                         
                         if ([[[UIDevice currentDevice] systemVersion]
                              floatValue] <= 8.0) {
                             if (appDelegate.appdelegateAlert.visible) {
                                 NSInteger index = appDelegate.appdelegateAlert
                                 .cancelButtonIndex;
                                 [appDelegate.appdelegateAlert
                                  dismissWithClickedButtonIndex:index
                                  animated:NO];
                                 self.needAlert = YES;
                             } else if (appDelegate.locationAlert.visible) {
                                 
                                 if (appDelegate.appdelegateAlert) {
                                     NSInteger index = appDelegate.appdelegateAlert
                                     .cancelButtonIndex;
                                     [appDelegate.appdelegateAlert
                                      dismissWithClickedButtonIndex:index
                                      animated:NO];
                                     self.needAlert = YES;
                                 }
                             }
                         }
                     }
                 }];
            }
        }
    }
}

#pragma mark 数据加载的判断
/**
 * 页面进入用户视线时进行一系列的加载数据的判断
 */
- (void)loadData {
    //提示用户是否切换到当前的定位城市
    if (self.isGpsCity) {
        self.isGpsCity = NO;
        [LocationComponent queryGPSCityChange];
    }

    //城市发生变化或者数据列表为空时进行强制刷新
    if (self.cityChanged || [self isEmptyData]) { // 刷新列表
        if (self.cityChanged) { // 切换了城市，强制刷新正在上映列表
            self.cityChanged = NO;
        }
        //        [self loadNewData];
    }

    //当前城市显示为空的时候，进入城市列表页面
    if (!USER_CITY) {
        [self changeCity];
    }

    //更新显示的城市信息
    [self updateLocationViewLayout];
}

#pragma mark - 两个视图是否是空视图
- (BOOL)isEmptyData {
    return true;
}

#pragma mark -  重新加载两个控制器的数据
- (void)loadNewData {
    WeakSelf
    MovieRequest *movieRequest = [[MovieRequest alloc] init];
    [movieRequest requestMoviesWithCityId:[NSString stringWithFormat:@"%tu", USER_CITY]
                                     page:1
                                  success:^(NSArray *_Nullable movieList) {
                                      [_currentMovieList removeAllObjects];
                                      [_currentMovieList addObjectsFromArray:movieList];
                                      [_currentMovieCollectionView reloadData];
                                      [_contentView headerEndRefreshing];
                                  }
                                  failure:^(NSError *_Nullable err) {
                                      [_contentView headerEndRefreshing];
                                  }];
    
    [movieRequest requestInCommingMoviesWithCityId:[NSString stringWithFormat:@"%tu", USER_CITY]
                                              page:1
                                           success:^(NSArray *_Nullable movieList) {
                                               [_futureMovieList removeAllObjects];
                                               [_futureMovieList addObjectsFromArray:movieList];
                                               [_futureMovieCollectionView reloadData];
                                               [_contentView headerEndRefreshing];
                                           }
                                           failure:^(NSError *_Nullable err) {
                                               [_contentView headerEndRefreshing];
                                           }];
}

#pragma mark 添加UI信息
/**
 *  加载导航栏
 1. leftItem城市显示
 2. middleItem segment显示
 */
- (void)loadNavBar {
    //设置导航栏背景色
//    self.navBarView.backgroundColor = appDelegate.kkzBlack;
//    self.statusView.backgroundColor = appDelegate.kkzBlack;

    //左边定位城市的展示
    [self.navBarView addSubview:self.locationView];
    self.kkzTitleLabel.text = @"章鱼";
    // 搜索View
//    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.locationView.frame), 5, kAppScreenWidth - CGRectGetMaxX(self.locationView.frame) - 44, CGRectGetHeight(self.navBarView.frame) - 10)];
//    searchView.backgroundColor = [UIColor whiteColor];
//
//    [self.navBarView addSubview:searchView];
}

- (void)showAlertView {
    //是否需要展示强制更新的信息
    if (self.needAlert && appDelegate.locationAlert) {

        if (appDelegate.appdelegateAlert) {
            [appDelegate.appdelegateAlert show];
            appDelegate.appdelegateAlert = nil;
        }

        [appDelegate.locationAlert show];
        appDelegate.locationAlert = nil;

        self.needAlert = NO;

    } else if (self.needAlert && appDelegate.appdelegateAlert) {
        [appDelegate.appdelegateAlert show];
        appDelegate.appdelegateAlert = nil;
        self.needAlert = NO;
    }
}

#pragma mark - 顶部滚动banner 相关
/**
 *  加载广告位
 */
- (void)loadBanners {
    _imgPlayer = [[BannerPlayerView alloc]
            initWithFrame:CGRectMake(0, 0, screentWith, Banner_Height)];
    _imgPlayer.backgroundColor = [UIColor clearColor];
    _imgPlayer.typeId = @"1";
    [_imgPlayer updateBannerData];
}

/**
 *  显示广告位 banner
 */
- (void)imgPlayerHeight:(NSNotification *)notification {
    int height = [notification.userInfo[NOTIFICATION_KEY_HEIGHT] intValue];
    if (height > 0) {
        CGRect frame = _imgPlayer.frame;
        frame.size.height = height;
        _imgPlayer.frame = frame;

        _isShowBanner = YES;
    } else {
        // 移除banner
    }
}

//后台返回如果影片列表为空重新请求影片列表接口
- (void)refreashMovietable {
    //更新显示的城市信息
    [self updateLocationViewLayout];

    [self loadNewData];
    [self checkRemindOrder:NO];
}

#pragma mark - KOKOLocationViewDelegate
- (void)changeCityBtnClicked:(KOKOLocationView *)locationView {
    [self changeCity];
}

#pragma mark 切换城市 切换城市相关

/**
 *  点击状态栏左侧城市进入城市列表
 */
- (void)changeCity {
    if (![[NetworkUtil me] reachable]) {
        return;
    }
    CityListNewViewController *ctr = [[CityListNewViewController alloc] init];
    ctr.delegate = self;
    [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
}

//根据定位城市更新列表数据
- (void)locationCityChanged:(NSNotification *)notification {

    [self updateLocationViewLayout];
    self.cityChanged = YES;
    [self loadNewData];
}

/**
 *  更新目前选中的城市
 */
- (void)updateLocationViewLayout {
    City *city = [City getCityWithId:USER_CITY];

    NSString *locationDesc = nil;
    if (city) {
        locationDesc = city.cityName;
    } else {
        locationDesc = @"北京";
    }

    self.locationView.cityText = locationDesc;
}

#pragma mark -网路请求
/**
 *  开机广告
 */
- (void)openAdvertiseQuery {

    AppRequest *request = [[AppRequest alloc] init];
    [request requestBanners:[NSNumber numberWithInt:USER_CITY]
            targetType:@11
            success:^(NSArray *_Nullable banners) {

                [self newsBannerFinished:banners status:YES];

            }
            failure:^(NSError *_Nullable err) {
                [self newsBannerFinished:nil status:NO];
            }];
}

#pragma mark CityListView controller delegate
- (void)myCityDidChange {

    appDelegate.cityId = USER_CITY;
}

#pragma mark utility'
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"changeCity"]) {
        self.cityChanged = YES;
        [_imgPlayer updateBannerData];
        [self loadNewData];
    }
}

/**
 检查是否有提醒订单

 @param showTicket 是否显示订单
 */
- (void) checkRemindOrder:(BOOL) showTicket
{
    if (self.didAppear == NO) {
        //确保再首次进入首页时只请求一次（避免MovieListVc、InCommingMovieListVc 刷新回调）
        return;
    }
    TicketReminderController *ticketReminderCon = [TicketReminderController shared];
    [ticketReminderCon checkRemindOrderWithShow:showTicket :^(BOOL hasOrder, BOOL newOrder) {
        self.ticketRemindBtn.hidden = !hasOrder;
        [self.ticketRemindBtn setImage:(newOrder && !showTicket) ? [UIImage imageNamed:@"ticket_nav_item_red_doit"] : [UIImage imageNamed:@"ticket_nav_item"]
                              forState:UIControlStateNormal];
    }];
    
}

- (void) ticketRemindClick
{
    [self checkRemindOrder:YES];
}

#pragma mark override from CommonViewController
- (BOOL)showNavBar {
    return YES;
}

- (BOOL)showTitleBar {
    return true;
}

- (BOOL)showBackButton {
    return NO;
}

/**
 *  定位区域View
 */
- (KOKOLocationView *)locationView {
    if (!_locationView) {
        _locationView = [[KOKOLocationView alloc]
                initWithFrame:CGRectMake(0, 0, KOKOLOCATIONVIEWWIDTH,
                                         KOKOLOCATIONVIEWHEIGHT)];
        _locationView.delegate = self;
    }
    return _locationView;
}

- (UIButton *) ticketRemindBtn
{
    if (_ticketRemindBtn == nil) {
        _ticketRemindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ticketRemindBtn setImage:[UIImage imageNamed:@"ticket_nav_item"] forState:UIControlStateNormal];
        [_ticketRemindBtn addTarget:self action:@selector(ticketRemindClick) forControlEvents:UIControlEventTouchUpInside];
        _ticketRemindBtn.hidden = YES;
        [self.navBarView addSubview:_ticketRemindBtn];
        [_ticketRemindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(44, 40));
            make.top.equalTo(@0);
        }];
    }
    
    return _ticketRemindBtn;
}

/**
 跳转到热映列表
 */
- (void)gotoMovieListBtnAction {
    [appDelegate setSelectedPage:1 tabBar:true];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHomeNotifi" object:nil userInfo:@{@"index":@0}];
}

/**
 跳转到即将上映列表
 */
- (void)gotoMovieListBtnAction2 {
    [appDelegate setSelectedPage:1 tabBar:true];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateHomeNotifi" object:nil userInfo:@{@"index":@1}];
}

#pragma mark - UICollectionView Delegate & Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    if (collectionView == _currentMovieCollectionView){
        return _currentMovieList.count;
    } else if (collectionView == _futureMovieCollectionView) {
        return _futureMovieList.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//定义此UICollectionView在父类上面的位置
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 15, 0, 0);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 8;
}
//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(105, 158+20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _currentMovieCollectionView) {    //  正在上映 列表
        static NSString *identify = @"MovieListPosterCollectionViewCell";
        MovieListPosterCollectionViewCell *cell = (MovieListPosterCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            NSLog(@"无法创建MovieListPosterCollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.posterImageBackColor = @"ffffff";
        if (_currentMovieList.count > indexPath.row) {
            Movie *movie = [_currentMovieList objectAtIndex:indexPath.row];
            cell.movieName = movie.movieName;
            cell.imageUrl = movie.pathVerticalS;
            cell.point = movie.score;
            cell.availableScreenType = [NSString stringWithFormat:@" %@ %@", movie.hasImax?@"IMAX":@"", movie.has3D?@"3D ":@""];
            cell.isSale = true;
            cell.isPresell = false;
            cell.model = movie;
            [cell updateLayout];
        }
        
        return cell;
    } else if (collectionView == _futureMovieCollectionView) {    //  即将上映    列表
        static NSString *identify = @"FutureCollectionCell";
        MovieListPosterCollectionViewCell *cell = (MovieListPosterCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            NSLog(@"无法创建MovieListPosterCollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.posterImageBackColor = @"ffffff";
        if (_futureMovieList.count > indexPath.row) {
            Movie *movie = [_futureMovieList objectAtIndex:indexPath.row];
            cell.movieName = movie.movieName;
            cell.imageUrl = movie.pathVerticalS;
            cell.point = movie.score;
            cell.availableScreenType = [NSString stringWithFormat:@" %@ %@", movie.hasImax?@"IMAX":@"", movie.has3D?@"3D ":@""];
            cell.isSale = false;
            cell.isPresell = true;//movie.hasPlan;
            cell.model = movie;
            [cell updateLayout];
        }
        return cell;
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _currentMovieCollectionView) {
        Movie *movie = [_currentMovieList objectAtIndex:indexPath.row];
        MovieDetailViewController *ctr = [[MovieDetailViewController alloc] initCinemaListForMovie:movie.movieId];
        ctr.isCommingSoon = false;
        MovieListPosterCollectionViewCell *cell = (MovieListPosterCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        self.sf_targetView = cell.moviePosterImage;
        [self.navigationController pushViewController:ctr animated:YES];
    } else if (collectionView == _futureMovieCollectionView) {
        Movie *movie = [_futureMovieList objectAtIndex:indexPath.row];
        MovieDetailViewController *ctr = [[MovieDetailViewController alloc] initCinemaListForMovie:movie.movieId];
        ctr.isCommingSoon = true;
        MovieListPosterCollectionViewCell *cell = (MovieListPosterCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        self.sf_targetView = cell.moviePosterImage;
        [self.navigationController pushViewController:ctr animated:YES];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

@end
