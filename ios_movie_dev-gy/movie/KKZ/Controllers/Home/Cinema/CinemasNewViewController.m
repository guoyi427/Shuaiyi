//
//  首页 - 影院列表
//
//  Created by KKZ on 16/1/26.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemasNewViewController.h"

#import "CinemaSearchViewController.h"
#import "GPSLocationView.h"

#import "UIAlertView+Blocks.h"

#import "Constants.h"
#import "UserDefault.h"

#import "TaskQueue.h"

#import "City.h"
#import "Movie.h"

#import "AlertViewY.h"
#import "NoDataViewY.h"

#import "BannerPlayerView.h"
#import "CinemaCellLayout.h"
#import "CinemaDetail.h"
#import "CinemaHelper.h"
#import "CinemaRequest.h"
#import "CinemaTicketViewController.h"
#import "MJRefresh.h"
#import "NewCinemaCell.h"
#import "KOKOLocationView.h"
#define locationLabelFont 15

#define locationViewWidth ((screentWith - 158) * 0.5 - 10)

#define locationLabelWidth (locationViewWidth - 30)

#define locationLabelY ((locationViewHeight - 20)/2)

#define accountTitleLabelBgWidth (locationViewWidth - 30)

#define locationIconImageViewLeft (10 + accountTitleLabelBgWidth + 5)

/****************定位区域View********************/

// const static CGFloat locationViewWidth = 80.0f;

const static CGFloat locationViewHeight = 44.0f;


/****************影院筛选按钮********************/
const static CGFloat selectDistrictBtnWidth = 40.0f;
const static CGFloat selectDistrictBtnHeight = 44.0f;

@interface CinemasNewViewController ()<KOKOLocationViewDelegate>

/**
 *  定位区域View
 */
@property (nonatomic, strong) KOKOLocationView *locationView;


/**
 *  搜索按钮
 */
@property (nonatomic, strong) UIButton *searchBtn;

/**
 *  筛选城区按钮
 */
@property (nonatomic, strong) UIButton *selectDistrictBtn;

/**
 *  后台返回的所有影院
 */
@property (nonatomic, strong) NSArray *cinemas;

/**
 *  根据条件筛选需要 当前展示 的影院数组
 */
@property (nonatomic, strong) NSArray *allCinemasList;

/**
 *  根据条件筛选需要展示的影院Layout数组
 */
@property (nonatomic, strong) NSMutableArray *allCinemasListLayout;

/**
 *  城区列表
 */
@property (nonatomic, strong) NSArray *districtList;

/**
 *  根据城区分组的影院列表
 */
@property (nonatomic, strong) NSArray *districtCinemaList;
@end

@implementation CinemasNewViewController

- (void)dealloc {
    [appDelegate removeObserver:self forKeyPath:@"changeCity"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstLoad = YES;

    //加载导航栏
    [self loadNavBar];

    //加载广告位
//    [self loadBanners];

    //加载影院列表
    [self loadTable];

    //初始化详细位置视图
    [self loadLocation];

    //初始化数组
    [self initArray];

    //添加事件通知
    [self addNotification];

    //添加列表数据提示信息
    [self addTableNotice];

    // 集成刷新控件
    [self setupRefresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //统计事件：【购票】影院入口-进入影院列表
    StatisEvent(EVENT_BUY_ENTER_CINEMA_LIST_SOURCE_CINEMA);

    //进入页面更新当前选择的城市信息
    [self updateCityName];
    
//    [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionCinema_list];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarLightStyle];

    if (isFirstLoad) {
        isFirstLoad = NO;
    } else {
        // 调用刷新数据的方法
        [self refreshEventList];
    }
}

/**
 *  进入页面更新当前选择的城市信息
 */
- (void)updateCityName {

    City *city = [City getCityWithId:USER_CITY];
    NSString *locationDesc = nil;

    if (city) {
        locationDesc = city.cityName;
    } else {
        locationDesc = @"北京";
    }
    
    
    self.locationView.cityText = locationDesc;


}

#pragma mark 添加UI信息
/**
 *  加载导航栏
 */
- (void)loadNavBar {
    //设置导航栏背景色
//    self.navBarView.backgroundColor = appDelegate.kkzBlue;
//    self.statusView.backgroundColor = appDelegate.kkzBlue;


    //加载导航栏上定位区域
    [self.navBarView addSubview:self.locationView];

    //标题
    self.kkzTitleLabel.text = @"影院";
    self.kkzTitleLabel.textColor = [UIColor whiteColor];

    //影院搜索按钮
    [self.navBarView addSubview:self.searchBtn];

    //影院筛选按钮
    [self.navBarView addSubview:self.selectDistrictBtn];
}


/**
 *  加载广告位
 */
- (void)loadBanners {
    CGFloat heightN = 75 * (screentWith / 320);
    imgPlayer = [[BannerPlayerView alloc]
            initWithFrame:CGRectMake(0, 0, screentWith, heightN)];
    imgPlayer.backgroundColor = [UIColor clearColor];
    imgPlayer.typeId = @"2";
    [imgPlayer updateBannerData];
}

/**
 *  加载影院列表
 */
- (void)loadTable {
    cinemaTable = [[UITableView alloc]
            initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith,
                                     screentHeight - 44 - 49)
                    style:UITableViewStylePlain];
    cinemaTable.delegate = self;
    cinemaTable.dataSource = self;
    cinemaTable.backgroundColor = [UIColor clearColor];
    cinemaTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIView *footView =
            [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 49)];
    cinemaTable.tableFooterView = footView;
    [self.view addSubview:cinemaTable];
}

/**
 *  初始化详细位置视图
 */

- (void)loadLocation {
    self.addressView = [[GPSLocationView alloc]
            initWithFrame:CGRectMake(0, screentHeight - 49 - 33, screentWith, 33)];
    [self.addressView searchCurrentGPSLocation];
    [self.view addSubview:self.addressView];
}

/**
 *  初始化数组
 */
- (void)initArray {
    //根据条件筛选之后需要显示的影院Layout数组
    self.allCinemasListLayout = [[NSMutableArray alloc] initWithCapacity:0];
}

/**
 *  添加事件通知
 */
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
                   name:@"imagePlayerViewHeightCinema"
                 object:nil];
    //更新当前详细的位置信息
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(refreshCurrentAddress)
                   name:@"AddressUpdateSucceededNotification"
                 object:nil];
    //定位失败的通知
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(locationGetFailed:)
                   name:@"AddressUpdateFailedNotification"
                 object:nil];
    //程序进入前台影院列表为空时，重新请求影院列表的接口
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(refreshCinematable)
                   name:@"appBecomeActive"
                 object:nil];
    //注册刷新列表通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshEventList)
                                                 name:KNotificationRefreshCinemaList object:nil];
}

/**
 *  添加列表数据提示信息
 */
- (void)addTableNotice {
    nodataView = [[NoDataViewY alloc]
            initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 100,
                                     screentWith, 120)];
    nodataView.alertLabelText = @"未获取到影院列表";

    noAlertView = [[AlertViewY alloc]
            initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 100,
                                     screentWith, 120)];
    noAlertView.alertLabelText = @"正在查询影院列表，请稍候...";
}
#pragma mark 集成刷新控件
/**
 * 集成刷新控件
 */
- (void)setupRefresh {

    [cinemaTable addHeaderWithTarget:self
                              action:@selector(headerRereshing)
                             dateKey:@"table"];

    [cinemaTable headerBeginRefreshing];

    cinemaTable.headerPullToRefreshText = @"下拉可以刷新";

    cinemaTable.headerReleaseToRefreshText = @"松开马上刷新";

    cinemaTable.headerRefreshingText = @"数据加载中...";
}
#pragma mark 开始进入刷新状态
/**
 * 开始进入刷新状态
 */
- (void)headerRereshing {
    // 调用刷新数据的方法
    [self refreshEventList];
}

#pragma mark 刷新数据的方法

/**
 *  MARK: 刷新列表的方法
 */
- (void)refreshEventList {

    if (self.allCinemasList.count == 0) {
        [cinemaTable addSubview:noAlertView];
        [nodataView removeFromSuperview];
    }
    if (USER_CITY) {

        CinemaRequest *request = [[CinemaRequest alloc] init];
        [request requestCinemaList:[NSNumber numberWithInt:USER_CITY].stringValue
                success:^(NSArray *_Nullable cinemas, NSArray *_Nullable favedCinemas,
                          NSArray *_Nullable favorCinemas) {

                    [cinemaTable headerEndRefreshing];

                    [self handleCinemas:cinemas
                            ticketCinemas:favedCinemas
                             favorCinemas:favorCinemas];

                }
                failure:^(NSError *_Nullable err) {
                    DLog(@"请求影院列表 失败 %@", err);
                    [cinemaTable headerEndRefreshing];

                    if (noAlertView.superview) {
                        [noAlertView removeFromSuperview];
                    }
                    isRefresh = NO;
                    NSString *messsage =
                            [err.userInfo objectForKey:KKZRequestErrorMessageKey];
                    if (messsage.length > 0) {
                        [UIAlertView showAlertView:messsage buttonText:@"确定"];
                    }else{
                        [UIAlertView showAlertView:KNET_FAULT_MSG buttonText:@"确定"];
                    }
                    if (self.allCinemasListLayout.count == 0) {

                        [cinemaTable addSubview:nodataView];

                    } else {
                        [nodataView removeFromSuperview];
                    }
                    [cinemaTable reloadData];
                }];

    } else {

        [appDelegate showAlertViewForTitle:@""
                                   message:@"亲, 先选择你所在的城市吧"
                              cancelButton:@"好的"];
    }
}

/**
 *  MARK: 处理影院列表
 *
 *  @param cinemas       影院列表
 *  @param ticketCinemas 买过票的影院列表
 *  @param favorCinemas  收藏的影院列表
 */
- (void)handleCinemas:(NSArray *)cinemas
        ticketCinemas:(NSArray *)ticketCinemas
         favorCinemas:(NSArray *)favorCinemas {
    NSArray *sorted = [CinemaHelper cinemaListFrom:cinemas
                                     ticketCinemas:ticketCinemas
                                      favorCinemas:favorCinemas];

    //按城区分组
    [CinemaHelper groupDistrict:sorted
                         finish:^(NSArray *districts, NSArray *districtsCinemas) {
                             self.districtCinemaList = districtsCinemas;
                             self.districtList = districts;
                         }];

    if (noAlertView.superview) {
        [noAlertView removeFromSuperview];
    }
    isRefresh = NO;

    self.allCinemasList = sorted;
    self.cinemas = [NSMutableArray arrayWithArray:self.allCinemasList];

    [self.allCinemasListLayout removeAllObjects];

    //生成layout
    for (int i = 0; i < self.allCinemasList.count; i++) {
        CinemaCellLayout *cinemaLayout = [[CinemaCellLayout alloc] init];
        cinemaLayout.cinema = self.allCinemasList[i];
        [self.allCinemasListLayout addObject:cinemaLayout];
    }

    if (self.allCinemasListLayout.count == 0) {

        [cinemaTable addSubview:nodataView];

    } else {
        [nodataView removeFromSuperview];
    }

    [cinemaTable reloadData];
}

#pragma mark handle notifications
/**
 *  是否显示广告位
 */
- (void)imgPlayerHeight:(NSNotification *)notification {

    float height = [notification.userInfo[NOTIFICATION_KEY_HEIGHT] intValue];

    if (height > 0) {
//        cinemaTable.tableHeaderView = imgPlayer;
    } else {
        [cinemaTable setTableHeaderView:nil];
    }
}
/**
 *  刷新当前位置
 */
- (void)refreshCurrentAddress {
    self.addressView.currentAddress = USER_CURRENT_ADDRESS;
}
/**
 *  刷新当前位置失败
 */
- (void)locationGetFailed:(NSNotification *)notification {
    self.addressView.currentAddress = @"定位失败";
}
/**
 *  程序从后台返回 影院列表为空的时候重新请求列表接口
 */
- (void)refreshCinematable {

    //进入页面更新当前选择的城市信息
    [self updateCityName];

    if (self.allCinemasListLayout.count == 0) {
        [self refreshEventList];
    }
}

#pragma mark 更换城市

//手动更换城市信息
- (void)changeCity {
    if (![[NetworkUtil me] reachable]) {
        return;
    }

    CityListNewViewController *ctr = [[CityListNewViewController alloc] init];
    ctr.delegate = self;
    [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
}

#pragma mark CityListView controller delegate
- (void)myCityDidChange {
    [cinemaTable setContentOffset:CGPointZero];
    appDelegate.cityId = USER_CITY;
}

//监听城市变化
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {

    if ([keyPath isEqualToString:@"changeCity"]) {
        [self performSelector:@selector(refreshEventList)
                     withObject:nil
                     afterDelay:0.5];
        [imgPlayer updateBannerData];
    }
}

#pragma mark 点击搜索按钮搜索影院
- (void)searchBtnClick {
    CinemaSearchViewController *searchCtr =
            [[CinemaSearchViewController alloc] init];
    searchCtr.allCinemasListLayout = self.allCinemasListLayout;
    searchCtr.isFromCinema = YES;
    [self pushViewController:searchCtr animation:CommonSwitchAnimationSwipeR2L];
}

#pragma mark 点击城区刷选按钮
- (void)showDistrictView {
    //统计事件：影院列表筛选
    StatisEvent(EVENT_CINEMA_FILTER);

    ctrHolder =
            [[UIControl alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY,
                                                        screentWith, screentHeight)];
    [ctrHolder addTarget:self
                      action:@selector(hiddenDistrictView)
            forControlEvents:UIControlEventTouchUpInside];
    ctrHolder.backgroundColor = [UIColor blackColor];
    ctrHolder.alpha = 0.5;

    ctrHolderWhite = [[UIControl alloc]
            initWithFrame:CGRectMake(0, 0, screentWith, 44 + self.contentPositionY)];
    [ctrHolderWhite addTarget:self
                       action:@selector(hiddenDistrictView)
             forControlEvents:UIControlEventTouchUpInside];
    ctrHolderWhite.backgroundColor = [UIColor whiteColor];
    ctrHolderWhite.alpha = 0.1;

    districtView = [[VerticalCinemaPickerView alloc]
            initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith,
                                     337)];
    districtView.districtList = self.districtList;
    NSMutableDictionary *disDic =
            [NSMutableDictionary dictionaryWithCapacity:self.districtList.count];
    //生成城区和个数dic
    for (NSInteger i = 0; i < self.districtList.count; i++) {
        NSString *disName = self.districtList[i];
        NSArray *cinemas = [self.districtCinemaList objectAtIndex:i];
        [disDic setObject:[NSNumber numberWithUnsignedInteger:cinemas.count]
                   forKey:disName];
    }

    districtView.districtDict = [disDic copy];
    districtView.allCinemasNum = self.cinemas.count;
    districtView.delegate = self;

    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:ctrHolder];
    [keywindow addSubview:ctrHolderWhite];
    [keywindow addSubview:districtView];

    [districtView updateLayout];

    districtView.frame =
            CGRectMake(0, 44 + self.contentPositionY, screentWith, 0);
    districtView.cinemaTable.frame = CGRectMake(110, 0, screentWith - 110, 0);

    [UIView animateWithDuration:0.3
            animations:^{

                districtView.frame =
                        CGRectMake(0, 44 + self.contentPositionY, screentWith, 337);
                districtView.cinemaTable.frame =
                        CGRectMake(110, 0, screentWith - 110, 337);

            }
            completion:^(BOOL finished){
            }];
}

- (void)hiddenDistrictView {

    [UIView animateWithDuration:0.5
            animations:^{

                districtView.frame =
                        CGRectMake(0, 44 + self.contentPositionY, screentWith, 337);

            }
            completion:^(BOOL finished) {

                [districtView removeFromSuperview];

                [ctrHolder removeFromSuperview];
                [ctrHolderWhite removeFromSuperview];

            }];
}

#pragma mark VerticalCinemaPickerViewDelegate 根据选择的城市更新影院列表
- (void)selectDistrictName:(NSInteger)districtIndex {

    if (districtIndex == 0) {
        //全部影院
        self.allCinemasList = self.cinemas;
    } else {
        //某个城区影院
        self.allCinemasList = self.districtCinemaList[districtIndex - 1];
    }

    [self.allCinemasListLayout removeAllObjects];

    for (int i = 0; i < self.allCinemasList.count; i++) {
        CinemaCellLayout *cinemaLayout = [[CinemaCellLayout alloc] init];
        cinemaLayout.cinema = self.allCinemasList[i];
        [self.allCinemasListLayout addObject:cinemaLayout];
    }

    [cinemaTable setContentOffset:CGPointZero];
    [cinemaTable reloadData];
    [self hiddenDistrictView];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.addressView.hidden = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    self.addressView.hidden = NO;
}

#pragma mark - Table View Data Source

- (void)configureCell:(NewCinemaCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {

    CinemaCellLayout *managedObject = nil;

    managedObject = [self.allCinemasListLayout objectAtIndex:indexPath.row];

    @try {

        cell.cinemaCellLayout = managedObject;
        [cell updateCinemaCell];

    }

    @catch (NSException *exception) {

        LERR(exception);

    }

    @finally {
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"CellIdentifier";
    NewCinemaCell *cell = (NewCinemaCell *) [tableView
            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NewCinemaCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellIdentifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor r:234 g:239 b:243];
    }
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.allCinemasListLayout.count;
}

- (CGFloat)tableView:(UITableView *)tableView
        heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CinemaCellLayout *managedObject = nil;
    managedObject = [self.allCinemasListLayout objectAtIndex:indexPath.row];
    return managedObject.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView
        didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (![[NetworkUtil me] reachable]) {
        return;
    }

    //统计事件：【购票】影院入口-进入影院页
    StatisEvent(EVENT_BUY_CHOOSE_CINEMA_SOURCE_CINEMA);

    CinemaDetail *cinema = [self.allCinemasList objectAtIndex:indexPath.row];
    CinemaTicketViewController *ticket =
            [[CinemaTicketViewController alloc] init];
    ticket.cinemaName = cinema.cinemaName;
    ticket.cinemaAddress = cinema.cinemaAddress;
    ticket.cinemaId = cinema.cinemaId;
    ticket.cinemaCloseTicketTime = cinema.closeTicketTime.stringValue;
    ticket.cinemaDetail = cinema;
    [self pushViewController:ticket animation:CommonSwitchAnimationBounce];
}

- (UIView *)tableView:(UITableView *)tableView
        viewForFooterInSection:(NSInteger)section {

    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 40)];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView
        heightForFooterInSection:(NSInteger)section {
    if (self.allCinemasListLayout.count) {
        return 40;
    } else {
        return 0;
    }
}

#pragma mark - KOKOLocationViewDelegate
- (void)changeCityBtnClicked:(KOKOLocationView *)locationView {
    [self changeCity];
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

/**
 *  定位区域View
 */
- (KOKOLocationView *)locationView {
    if (!_locationView) {
        _locationView = [[KOKOLocationView alloc]
                         initWithFrame:CGRectMake(0, 0, (screentWith - 158) * 0.5 - 10,
                                                  44.0f)];
        _locationView.delegate = self;
    }
    return _locationView;
}



/**
 *  影院搜素按钮
 */
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.backgroundColor = [UIColor clearColor];
        _searchBtn.frame =
                CGRectMake(screentWith - selectDistrictBtnWidth * 2 - 5, 0,
                           selectDistrictBtnWidth, selectDistrictBtnHeight);
        _searchBtn.contentEdgeInsets = UIEdgeInsetsMake(13, 12, 13, 10);
        [_searchBtn addTarget:self
                          action:@selector(searchBtnClick)
                forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setImage:[UIImage imageNamed:@"search_cinema_img"]
                    forState:UIControlStateNormal];
    }
    return _searchBtn;
}

/**
 *  影院筛选按钮
 */
- (UIButton *)selectDistrictBtn {
    if (!_selectDistrictBtn) {
        _selectDistrictBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectDistrictBtn.backgroundColor = [UIColor clearColor];
        _selectDistrictBtn.frame =
                CGRectMake(screentWith - selectDistrictBtnWidth - 5, 0,
                           selectDistrictBtnWidth, selectDistrictBtnHeight);
        _selectDistrictBtn.contentEdgeInsets = UIEdgeInsetsMake(13, 10, 13, 12);
        [_selectDistrictBtn addTarget:self
                               action:@selector(showDistrictView)
                     forControlEvents:UIControlEventTouchUpInside];
        [_selectDistrictBtn
                setImage:[UIImage imageNamed:@"search_cinemaDistrict_btn"]
                forState:UIControlStateNormal];
    }
    return _selectDistrictBtn;
}
@end
