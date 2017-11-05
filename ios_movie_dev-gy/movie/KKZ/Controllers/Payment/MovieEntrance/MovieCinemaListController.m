//
//  电影详情页面 - 影院列表
//
//  Created by KKZ on 16/2/18.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaCellLayout.h"
#import "CinemaSearchViewController.h"
#import "KKZUtility.h"
#import "MovieCinemaListController.h"
#import "NewCinemaCell.h"
#import "UserDefault.h"

#import "KKZHorizonTableView.h"
#import "UIConstants.h"

#import "DateEngine.h"
#import "Movie.h"
#import "MovieTask.h"
#import "TaskQueue.h"

#import "AlertViewY.h"
#import "NoDataViewY.h"

#import "CinemaDetail.h"
#import "CinemaHelper.h"
#import "CinemaRequest.h"
#import "PlanRequest.h"
#import "CinemaTicketViewController.h"
#import "ChooseSeatViewController.h"
#import "GPSLocationView.h"

#import <MJRefresh_KKZ/UIScrollView+MJExtension.h>

/****************影院排期列表的高度********************/
const static CGFloat cinemaPlanHeight = 0;//47.0f;

@interface MovieCinemaListController () <
        KKZHorizonTableViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

/**
 *  选择的影院的排期
 */
@property (nonatomic, assign) NSInteger cinemaPlanIndex;

/**
 *  有排期的影院日期
 */
@property (nonatomic, strong) NSArray *cinemaPlans;

/**
 *  每个区域的头部视图
 */
@property (nonatomic, strong) UIView *sectionHeaderView;

/**
 *  影院排期的list
 */
@property (nonatomic, strong) KKZHorizonTableView *horizonTableView;

/**
 *  影院列表table
 */
@property (nonatomic, strong) UITableView *cinemaTableView;

@property (nonatomic, strong) NSArray *cellLayouts;

@property (nonatomic, copy) NSString *planDate;

/**
 *  返回的所有影院的信息
 */
@property (nonatomic, strong) NSArray *cinemas;

/**
 影院列表缓存 key：date value：[CinemaDetail]
 */
@property (nonatomic, strong) NSMutableDictionary *cinemaTem;
/**
 *  根据条件筛选需要 当前展示 的影院数组(例如：限制行政区后)
 */
@property (nonatomic, strong) NSArray *allCinemasList;

/**
 前几个影院的排期信息 key: cinemaId+date value:[Ticket]
 */
@property (nonatomic, strong) NSMutableDictionary *headCinemaPlans;


/**
 *  城区列表
 */
@property (nonatomic, strong) NSArray *districtList;

/**
 *  根据城区分组的影院列表
 */
@property (nonatomic, strong) NSArray *districtCinemaList;



@property (nonatomic, strong) AlertViewY *noAlertView;
@property (nonatomic, strong) NoDataViewY *nodataView;
@property (nonatomic, strong) GPSLocationView *addressView;
@end

@implementation MovieCinemaListController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.kkzBackBtn setImage:[UIImage imageNamed:@"white_back"]
                     forState:UIControlStateNormal];

    //添加导航栏
    [self addNavView];

    //添加排期日期列表
    [self.view addSubview:self.sectionHeaderView];
    
    self.cinemaTem = [NSMutableDictionary dictionaryWithCapacity:1];

    //添加影院列表
    [self addMovieCinemaList];

    //数据加载提示信息
    [self addNotice];

    //查询一个电影所有影院的上映日期
    [self refreshDateListForMovie];
    
    [self loadLocation];
    
    //更新当前详细的位置信息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(refreshCurrentAddress)
     name:@"AddressUpdateSucceededNotification"
     object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarLightStyle];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  数据加载提示信息
 */
- (void)addNotice {
    self.noAlertView = [[AlertViewY alloc]
            initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 121,
                                     screentWith, 120)];
    self.noAlertView.alertLabelText = @"亲"
                                      @"，正在获取影院信息，请稍候~";

    self.nodataView = [[NoDataViewY alloc]
            initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 121,
                                     screentWith, 120)];
    self.nodataView.alertLabelText =
            @"亲，目前这部电影还没有上映影院哦，请再等等吧~";
}

/**
 *  添加影院列表
 */
- (void)addMovieCinemaList {
    self.cinemaTableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                        style:UITableViewStylePlain];
    self.cinemaTableView.delegate = self;
    self.cinemaTableView.dataSource = self;
    self.cinemaTableView.showsVerticalScrollIndicator = NO;
    self.cinemaTableView.backgroundColor = [UIColor clearColor];
    self.cinemaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.cinemaTableView];
    
    [self.cinemaTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.horizonTableView.mas_bottom);
    }];

}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    __weak __typeof(self) weakSelf = self;
    //下拉刷新
    [self.cinemaTableView addHeaderWithCallback:^{
        [weakSelf requestMovieCinemas];
    }];
    
    [self.cinemaTableView addHeaderWithTarget:self
                                       action:@selector(requestMovieCinemas)
                                      dateKey:@"table"];
    self.cinemaTableView.headerPullToRefreshText = @"下拉可以刷新";
    self.cinemaTableView.headerReleaseToRefreshText = @"松开马上刷新";
    self.cinemaTableView.headerRefreshingText = @"数据加载中...";

}


/**
 请求电影影院列表
 */
- (void) requestMovieCinemas
{
    
    if (self.planDate) {
        [self requestCinemaList:self.planDate];
    }else{
        [self refreshDateListForMovie];
    }
}

/**
 *  添加导航栏
 */
- (void)addNavView {
    //设置导航栏背景色
//    self.navBarView.backgroundColor = appDelegate.kkzBlue;
//    self.statusView.backgroundColor = appDelegate.kkzBlue;

    //标题
    self.kkzTitleLabel.text = self.movie.movieName;
    self.kkzTitleLabel.textColor = [UIColor whiteColor];
    CGRect r = self.kkzTitleLabel.frame;
    r.origin.x = 44 * 2;
    r.size.width = screentWith - 44 * 2 * 2;
    self.kkzTitleLabel.frame = r;

    //右边搜索按钮
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.backgroundColor = [UIColor clearColor];

    searchBtn.frame = CGRectMake(screentWith - 44 * 2 - 5, 0, 44, 44);
    searchBtn.contentEdgeInsets = UIEdgeInsetsMake(13, 12, 13, 10);

    [searchBtn addTarget:self
                  action:@selector(searchBtnClick)
        forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setImage:[UIImage imageNamed:@"search_cinema_img"]
               forState:UIControlStateNormal];
    [self.navBarView addSubview:searchBtn];

    //右边筛选按钮
    selectDistrictBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectDistrictBtn.backgroundColor = [UIColor clearColor];

    selectDistrictBtn.frame = CGRectMake(screentWith - 44 - 5, 0, 44, 44);
    selectDistrictBtn.contentEdgeInsets = UIEdgeInsetsMake(13, 10, 13, 12);

    [selectDistrictBtn addTarget:self
                          action:@selector(showDistrictView)
                forControlEvents:UIControlEventTouchUpInside];
    [selectDistrictBtn setImage:[UIImage imageNamed:@"search_cinemaDistrict_btn"]
                       forState:UIControlStateNormal];
    [self.navBarView addSubview:selectDistrictBtn];
}

/**
 MARK:点击搜索按钮
 */
- (void)searchBtnClick {
    CinemaSearchViewController *searchCtr =
            [[CinemaSearchViewController alloc] init];
    searchCtr.isFromCinema = NO;
    searchCtr.allCinemasListLayout = self.cellLayouts;
    [self pushViewController:searchCtr animation:CommonSwitchAnimationSwipeR2L];
}

#pragma mark - 位置视图
/**
 *  初始化详细位置视图
 */

- (void)loadLocation {
    self.addressView = [[GPSLocationView alloc]
                        initWithFrame:CGRectMake(0, screentHeight - 33, screentWith, 33)];
    [self.addressView searchCurrentGPSLocation];
    [self.view addSubview:self.addressView];
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

#pragma mark -

/**
 MARK:点击区域检索
 */
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
    districtView.allCinemasNum = self.cinemas.count;
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

/**
 MARK: 城区回调

 @param districtIndex index
 */
- (void)selectDistrictName:(NSInteger)districtIndex {
    if (districtIndex == 0) {
        //全部影院
        self.allCinemasList = self.cinemas;
    } else {
        //某个城区影院
        self.allCinemasList = self.districtCinemaList[districtIndex - 1];
    }

    NSMutableArray *muArr =
            [NSMutableArray arrayWithCapacity:self.allCinemasList.count];
    for (int i = 0; i < self.allCinemasList.count; i++) {
        CinemaCellLayout *cinemaLayout = [[CinemaCellLayout alloc] init];
        cinemaLayout.cinema = self.allCinemasList[i];
        [muArr addObject:cinemaLayout];
    }
    self.cellLayouts = [muArr copy];

    [self.cinemaTableView setContentOffset:CGPointZero];
    [self.cinemaTableView reloadData];
    [self hiddenDistrictView];
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

#pragma mark - View Delegate

- (BOOL)horizonTableViewNeedToEnlargeTheTitleLabelOnClickLabel {
    return NO;
}

- (BOOL)horizonTableViewNeedToShowBottomViewOnClickLabel {
    return YES;
}

- (void)horizonTableView:(UICollectionView *)tableView
     didSelectRowAtIndex:(NSInteger)index {
    if (self.cinemaPlans.count <= 0) {
        return;
    }
    self.cinemaPlanIndex = index;
    NSString *planDate = [self.cinemaPlans objectAtIndex:self.cinemaPlanIndex];
    self.planDate = planDate;
    
    // 如果能在temp中拿到列表就直接刷新数据，否则，去请求数据
    NSArray *cinemaList = [self.cinemaTem objectForKey:planDate];
    if (cinemaList.count > 0) {
        self.cinemas = cinemaList;
        [self reloadTable:cinemaList];
    }else{
        [self requestCinemaList:planDate];
    }
    
}


/**
 刷新table数据

 @param cinemas 影院列表
 */
- (void) reloadTable:(NSArray *)cinemas
{
    self.allCinemasList = self.cinemas;
    
    NSMutableArray *muLayout =
    [NSMutableArray arrayWithCapacity:self.cinemas.count];
    for (NSInteger i = 0; i < self.cinemas.count; i++) {
        CinemaCellLayout *layout = [[CinemaCellLayout alloc] init];
        layout.cinema = self.cinemas[i];
        [muLayout addObject:layout];
    }
    self.cellLayouts = [muLayout copy];
    
    [self.cinemaTableView reloadData];
    
    [self.noAlertView removeFromSuperview];
    [self.nodataView removeFromSuperview];

}


/**
 *  MARK: 查询一个电影所有影院的上映日期
 */
- (void)refreshDateListForMovie {
    [self.nodataView removeFromSuperview];
    if (self.cinemaPlans.count == 0) {
        [self.cinemaTableView addSubview:self.noAlertView];
        [self.noAlertView startAnimation];
    } else {
        return;
    }

    CinemaRequest *request = [[CinemaRequest alloc] init];

    [request requestDate:self.movieId
                  cityID:[NSNumber numberWithInteger:USER_CITY]
                 success:^(NSArray *_Nullable dates) {
                     
                     [self.cinemaTableView headerEndRefreshing];

                     self.cinemaPlans = dates;
                     self.planDate = dates.firstObject;
                     NSMutableArray *mdates = [[NSMutableArray alloc] initWithCapacity:0];

                     //后台返回的日期需要处理格式之后显示
                     for (NSString *dateStr in self.cinemaPlans) {
                         NSDate *date =
                            [[DateEngine sharedDateEngine] dateFromStringY:dateStr];
                         NSString *dateStrLast = [[DateEngine sharedDateEngine]
                                                  relativeDayMMDDStringFromDateY:date];
                         [mdates addObject:dateStrLast];
                     }

                     [self.noAlertView removeFromSuperview];

                     self.horizonTableView.dataSource = mdates;

                     if (self.cinemaPlans.count <= 0) {
                         [self.cinemaTableView addSubview:self.nodataView];
                     }

      }
      failure:^(NSError *_Nullable err) {
          DLog(@"err:%@", err);
          [self.noAlertView removeFromSuperview];
          [self.cinemaTableView addSubview:self.nodataView];
          [self.cinemaTableView headerEndRefreshing];
      }];
}

/**
 MARK: 请求影院列表

 @param date 日期
 */
- (void)requestCinemaList:(NSString *)date {
    //列表为空时才显示loading动画
    if (self.cinemas.count == 0 && self.noAlertView.superview == nil) {
        [self.nodataView removeFromSuperview];
        [self.cinemaTableView addSubview:self.noAlertView];
        [self.noAlertView startAnimation];
    }
    
    CinemaRequest *request = [[CinemaRequest alloc] init];

    [request requestCinemaList:[NSNumber numberWithInt:USER_CITY]
            movieID:self.movieId
            beginDate:date
            endDate:date
            success:^(NSArray *_Nullable cinemas, NSArray *_Nullable favedCinemas,
                      NSArray *_Nullable favorCinemas) {

                [self.cinemaTableView headerEndRefreshing];

                NSArray *cinemaList = [CinemaHelper cinemaListFrom:cinemas
                                                     ticketCinemas:favedCinemas
                                                      favorCinemas:favorCinemas];
                
                [self.cinemaTem setValue:cinemaList forKey:date];
                self.cinemas = cinemaList;
                
                if ([date isEqualToString:self.planDate]) {
                    // // 当选中日期与date一致时才刷新
                    [self reloadTable:self.cinemas];
                }
                // 请求影院排期
                [self requestCinemaPlans:[self cinemasShowPlan:self.cinemas] date:date];

                //按城区分组
                [CinemaHelper
                        groupDistrict:self.cinemas
                               finish:^(NSArray *districts, NSArray *districtsCinemas) {
                                   self.districtCinemaList = districtsCinemas;
                                   self.districtList = districts;
                               }];

            }
            failure:^(NSError *_Nullable err) {
                DLog(@"fail err: %@", err);
                [self.cinemaTableView headerEndRefreshing];
                if (self.noAlertView.superview) {
                    [self.noAlertView removeFromSuperview];
                }
                [self.cinemaTableView addSubview:self.nodataView];
                self.cinemas = nil;
                self.cellLayouts = nil;
                [self.cinemaTableView reloadData];
            }];
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
                         finish:^(NSArray *districts, NSArray *districtsCinemas){

                         }];

    NSMutableArray *layouts = [NSMutableArray arrayWithCapacity:sorted.count];
    for (int i = 0; i < sorted.count; i++) {
        CinemaCellLayout *cinemaLayout = [[CinemaCellLayout alloc] init];
        cinemaLayout.cinema = sorted[i];
        [layouts addObject:cinemaLayout];
    }
    [self.cinemaTableView reloadData];
    [self.cinemaTableView setContentOffset:CGPointZero];
    
    
}

/**
 获取需要显示排期的影院
 有收藏或去过影院，最多返回三个
 没有，返回列表前三个

 @param allCinemas 全部影院
 @return 需要排期的影院
 */
- (NSArray<CinemaDetail *> *) cinemasShowPlan:(NSArray<CinemaDetail *> *)allCinemas
{
    if (allCinemas.count == 0) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isCollected = YES"];
    NSArray *result = [allCinemas filteredArrayUsingPredicate:predicate];
    if (result.count == 0) {
        switch (allCinemas.count) {
            case 1:
                result = @[allCinemas[0]];
                break;
            case 2:
                result = @[allCinemas[0],allCinemas[1]];
                break;
                
            default:
                result = @[allCinemas[0],allCinemas[1],allCinemas[2]];
                break;
        }
    }else if (result.count > 3) {
        result = @[result[0], result[1], result[2]];
    }
    
    return result;
}

/**
 请求影院排期

 @param cinemas 影院列表
 */
- (void) requestCinemaPlans:(NSArray<CinemaDetail *> *)cinemas date:(NSString *)date
{
    if (cinemas == nil || cinemas.count == 0) {
        return;
    }
    PlanRequest *request = [PlanRequest new];
    NSArray *cinemaIds = [cinemas valueForKeyPath:@"@unionOfObjects.cinemaId"];
    [request requestPlanList:self.movieId
                   inCineams:cinemaIds
                   beginDate:date
                     endDate:date
                     success:^(NSArray * _Nullable plans) {
        
        [self handleCinames:cinemas plans:plans date:date];
        
    } failure:^(NSError * _Nullable err) {
        DLog(@"requestCinemaPlans %@",err);
    }];
}

/**
 处理影院列表的排期信息
 将排期列表按影院分组

 @param cinemas 影院列表
 @param plans 排期信息
 @param date 排期日期
 */
- (void) handleCinames:(NSArray<CinemaDetail *> *)cinemas plans:(NSArray <Ticket *> *) plans date:(NSString *)date
{
    
    if (cinemas.count == 0 || plans.count == 0) {
        self.headCinemaPlans = nil;
        [self.cinemaTableView reloadData];
        return;
    }
    
    if (self.headCinemaPlans == nil) {
        self.headCinemaPlans = [NSMutableDictionary dictionaryWithCapacity:cinemas.count];
    }
    
    // 按影院筛选
    for (NSInteger i = 0 ; i < cinemas.count; i++) {
        CinemaDetail *cinema = cinemas[i];
        NSNumber *cinemaId = cinema.cinemaId;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cinema.cinemaId == %@", cinemaId];
        NSArray *result = [plans filteredArrayUsingPredicate:predicate];
        
        // 过滤停止售票的排期
        NSMutableArray *availablePlans = [NSMutableArray arrayWithCapacity:0];
        [result enumerateObjectsUsingBlock:^(Ticket  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 停止售票时间根据当前时间+影院停止售票时间
            NSDate *dateExpir = [[NSDate date]dateByAddingTimeInterval:cinema.closeTicketTime.floatValue * 60];
            NSComparisonResult resl = [obj.movieTime compare:dateExpir];
            if (resl == NSOrderedDescending) {
                [availablePlans addObject:obj];
            }
        }];
        
        [self.headCinemaPlans setValue:[availablePlans copy] forKey:[NSString stringWithFormat:@"%@+%@",cinemaId.stringValue, date]];
    }
    
    if ([date isEqualToString:self.planDate]) {
        // 当选中日期与date一致时才刷新
        [self.cinemaTableView reloadData];
    }
    
    
}



#pragma mark - tableView delegate

- (void)configureCell:(NewCinemaCell *)cell
          atIndexPath:(NSIndexPath *)indexPath {
    CinemaCellLayout *managedObject = nil;
    managedObject = [self.cellLayouts objectAtIndex:indexPath.row];
    @try {
        cell.cinemaCellLayout = managedObject;
        [cell updateCinemaCell];
    } @catch (NSException *exception) {
        LERR(exception);
    } @finally {
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
    
    NSArray *planList = [self planForIndexPath:indexPath];
    // 如果有排期信息
    if (planList.count > 0) {
         __weak __typeof(self) weakSelf = self;
        [cell showMovieTimeList:planList select:^(Ticket *plan) {
            [weakSelf toChooseSeatVCWithPlan:plan andPlans:planList];
        }];
    }else {
        [cell hideMovieTimeList];
    }

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

    return self.cellLayouts.count;
}

/**
 获取table cell的排期

 @param indexPath indexPath
 @return 排期
 */
- (NSArray *) planForIndexPath:(NSIndexPath *)indexPath
{
    if (self.headCinemaPlans.count == 0) {
        return nil;
    }
    
    CinemaCellLayout *cinemaLay =  [self.cellLayouts objectAtIndex:indexPath.row];
    NSString *cinemaId =  cinemaLay.cinema.cinemaId.stringValue;
    NSString *key = [NSString stringWithFormat:@"%@+%@", cinemaId, self.planDate];
    NSArray *planList = [self.headCinemaPlans objectForKey:key];

    return planList;
}

- (CGFloat)tableView:(UITableView *)tableView
        heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CinemaCellLayout *cinemaLayout =
            [self.cellLayouts objectAtIndex:indexPath.row];
    
    BOOL hasPlan = NO;
    NSArray *planList = [self planForIndexPath:indexPath];
    hasPlan = planList.count != 0;
    
    return hasPlan ? K_CINEMACELL_HEIGHT_PLAN : cinemaLayout.height ;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.cellLayouts.count) {
        return 1;
    } else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView
        didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    //统计事件：【购票】电影入口-选择影城
    StatisEvent(EVENT_BUY_TICKET_SOURCE_MOVIE);

    CinemaCellLayout *cinemaLayout =
            [self.cellLayouts objectAtIndex:indexPath.row];
    CinemaDetail *cinema = cinemaLayout.cinema;

    CommonViewController *parentCtr =
            [KKZUtility getRootNavagationLastTopController];
    CinemaTicketViewController *ticket =
            [[CinemaTicketViewController alloc] init];
    ticket.cinemaName = cinema.cinemaName;
    ticket.cinemaAddress = cinema.cinemaAddress;
    ticket.cinemaId = cinema.cinemaId;
    ticket.movieId = self.movieId;
    ticket.initialSelectedDate = [NSString stringWithFormat:@"%@", self.planDate];
    ticket.cinemaCloseTicketTime = cinema.closeTicketTime.stringValue;
    ticket.cinemaDetail = cinema;
    [parentCtr pushViewController:ticket animation:CommonSwitchAnimationBounce];
}

- (UIView *)tableView:(UITableView *)tableView
        viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 33)];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView
        heightForFooterInSection:(NSInteger)section {
    return 33;
}

/**
 *  MARK: 前往选座页面
 */
- (void)toChooseSeatVCWithPlan:(Ticket *)plan andPlans:(NSArray *)planList {
    
    ChooseSeatViewController *chooseSeatVC = [ChooseSeatViewController new];
    chooseSeatVC.planArray = planList;
    chooseSeatVC.plan = plan;
    chooseSeatVC.planId = plan.planId;
    [self pushViewController:chooseSeatVC animation:CommonSwitchAnimationSwipeR2L];
}

#pragma mark-- GET

- (KKZHorizonTableView *)horizonTableView {

    if (!_horizonTableView) {
        _horizonTableView = [[KKZHorizonTableView alloc]
                initWithFrame:CGRectMake(15, 0, kCommonScreenWidth - 15 * 2,
                                         cinemaPlanHeight)];
        _horizonTableView.itemSpacing = 23.0f;
        _horizonTableView.labelColor = [UIColor r:76 g:77 b:78];
        _horizonTableView.labelFont = [UIFont boldSystemFontOfSize:13.0f];
        _horizonTableView.clickLabelColor = kUIColorOrange;
        _horizonTableView.backgroundColor = [UIColor clearColor];
        _horizonTableView.defaultChooseIndex = 0;
        _horizonTableView.delegate = self;
    }

    return _horizonTableView;
}

- (UIView *)sectionHeaderView {
    if (!_sectionHeaderView) {

        //初始化对象
        _sectionHeaderView = [[UIView alloc]
                initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith,
                                         cinemaPlanHeight)];
        _sectionHeaderView.backgroundColor = [UIColor whiteColor];
        [_sectionHeaderView addSubview:self.horizonTableView];

        //上分割线
        UIView *lineTop = [[UIView alloc]
                initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 0.3f)];
        lineTop.backgroundColor = kUIColorDivider;
        [_sectionHeaderView addSubview:lineTop];

        //下分割线
        UIView *lineBottom =
                [[UIView alloc] initWithFrame:CGRectMake(0, cinemaPlanHeight - 0.3f,
                                                         kCommonScreenWidth, 0.3f)];
        lineBottom.backgroundColor = kUIColorDivider;
        [_sectionHeaderView addSubview:lineBottom];
    }
    return _sectionHeaderView;
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.addressView.hidden = YES;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)deceleratex
{
    self.addressView.hidden = NO;
}

@end
