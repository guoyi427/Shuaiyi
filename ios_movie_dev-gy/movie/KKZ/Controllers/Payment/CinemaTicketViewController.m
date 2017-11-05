//
//  排期列表页面
//
//  Created by 艾广华 on 16/4/11.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaDetailCommonModel.h"
#import "CinemaHeaderView.h"
#import "CinemaNoticeView.h"
#import "CinemaPlanCell.h"
#import "CinemaPlanCellLayout.h"
#import "CinemaPlanTableFooterView.h"
#import "CinemaRequest.h"
#import "CinemaTableView.h"
#import "CinemaTicketViewController.h"
#import "DataEngine.h"
#import "ErrorDataView.h"
#import "KKZHorizonTableView.h"
#import "KKZShareView.h"
#import "KKZUtility.h"
#import "Movie.h"
#import "NewCinemaDetailViewController.h"
#import "PlanRequest.h"
#import "RequestLoadingView.h"
#import "ShareContent.h"
#import "TaskQueue.h"
#import "Ticket.h"
#import "UIColor+Hex.h"
#import "NSStringExtra.h"
#import "PlanRequest.h"
#import "ShareContent.h"
#import "ChooseSeatViewController.h"
#import "KoMovie-Swift.h"
#import "CinemaActivityDetailView.h"
#import "CinemaDetail.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>


/****************收藏按钮*************/
static const CGFloat collectionButtonRight = 15.0f;
static const CGFloat collectionButtonLeft = 8.0f;

/****************分享按钮*************/
static const CGFloat shareButtonLeft = 15.0f;
static const CGFloat shareButtonRight = 7.0f;

/****************排期页面*************/
static const CGFloat horizonTableLeft = 15.0f;
static const CGFloat horizonTableHeight = 48.0f;
static const CGFloat sectionHeaderHeight = 49.0f;

/****************请求排期的加载框最大高度*************/
static const CGFloat requestLoadingViewMinHeight = 300.0f;
static const CGFloat errorDataViewMinHeight = 200.0f;

typedef enum : NSUInteger {
    shareButtonTag = 1000,
    collectionButtonTag,
} allButtonTag;

@interface CinemaTicketViewController () <
        UITableViewDataSource, UITableViewDelegate, CinemHeaderDelegate,
        KKZHorizonTableViewDelegate, CinemaTableViewDelegate,
        CinemaPlanTableFooterDelegate, CinemaDetailCommonModelDelegate,BMKLocationServiceDelegate>
{
    BMKLocationService* _locService;
    CLLocationCoordinate2D cc2d;
    CLLocationCoordinate2D cc3d;
}

/**
 *  分享按钮
 */
@property (nonatomic, strong) UIButton *shareButton;

/**
 *  收藏按钮
 */
@property (nonatomic, strong) UIButton *collectionButton;

/**
 *  标题标签
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  表视图
 */
@property (nonatomic, strong) CinemaTableView *listTable;

/**
 *  表视图的头部视图
 */
@property (nonatomic, strong) CinemaHeaderView *cinemaHeaderView;

/**
 *  排期切换视图
 */
@property (nonatomic, strong) KKZHorizonTableView *horizonTableView;

/**
 *  底部视图
 */
@property (nonatomic, strong) CinemaPlanTableFooterView *footerView;

/**
 *  请求的动画视图
 */
@property (nonatomic, strong) RequestLoadingView *requestLoadingView;

/**
 *  无数据显示的视图
 */
@property (nonatomic, strong) ErrorDataView *errorDataView;

/**
 *  默认的底部视图
 */
@property (nonatomic, strong) UIView *defaultFooterView;

/**
 *  分享视图
 */
@property (nonatomic, strong) KKZShareView *shareView;

/**
 *  影院须知
 */
@property (nonatomic, strong) CinemaNoticeView *cinemaNoticeView;

/**
 *  当前的电影信息
 */
@property (nonatomic, strong) Movie *currentMovie;

/**
 *  每个区域的头部视图
 */
@property (nonatomic, strong) UIView *sectionHeaderView;

/**
 *  当前选中的电影信息索引
 */
@property (nonatomic, assign) NSInteger currentMovieIndex;

/**
 *  当前排期字典
 */
@property (nonatomic, strong) NSMutableDictionary *currentPlanDic;

/**
 *  日期简写对应的字符串
 */
@property (nonatomic, strong) NSMutableDictionary *dateShortDic;

/**
 *  数据源数组
 */
@property (nonatomic, strong) NSMutableArray *dataList;

/**
 *  数据源布局数组
 */
@property (nonatomic, strong) NSMutableArray *dataLayoutList;

/**
 *  是否已经收藏过影院
 */
@property (nonatomic, assign) BOOL isCollected;

/**
 *  是否有大于今天的排期
 */
@property (nonatomic, assign) BOOL isLargeToday;

/**
 *  最大垂直偏移量
 */
@property (nonatomic, assign) CGFloat maximumVerticalOffset;

/**
 *  排期的内存缓存数据
 */
@property (nonatomic, strong) NSMutableDictionary *cachePlanDic;

/**
 *  取消的网络请求
 */
@property (nonatomic, strong) NSMutableDictionary *cancelTasks;

/**
 *  影院特色
 */
@property (nonatomic, strong) NSArray *features;

@property (nonatomic, strong) ShareContent *share;

/**
 排期优惠信息 [Bool] yes：有优惠 no：没有优惠
 */
@property (nonatomic, strong) NSArray *planHasPromotionArr;

/**
 优惠信息列表
 */
@property (nonatomic, strong) NSArray<Promotion *> *promotionList;

@end

@implementation CinemaTicketViewController

- (id)initWithExtraData:(NSString *)extra1
                 extra2:(NSString *)extra2
                 extra3:(NSString *)extra3 {

    self = [super init];
    if (self) {
        if (extra1) {
            self.cinemaId = [extra1 toNumber];
        }
        if (extra2) {
            self.movieId = [extra2 toNumber];
        }
        if (extra3) {
            self.initialSelectedDate = extra3;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载导航条
    [self loadNavBar];

    //加载表视图
    [self loadTableView];

    //请求影院标签
    [self loadCinemaLabelList];

    //请求电影列表
    [self loadCinemaMovieList];

    //请求电影详情
    [self requestCinemaDetail];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
}

/**
 *  下拉刷新方法
 */
- (void)beginRquestData {

    [self requestCinemaDetail];

    //请求影院标签
    [self loadCinemaLabelList];

    if (self.movieId) {
        //请求电影列表
        [self.cachePlanDic
         removeObjectForKey:[self.movieId stringValue]];
    }

    [self loadCinemaMovieList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //请求收藏请求
    [self loadCollectRequest];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view insertSubview:_shareView aboveSubview:self.navBarView];
}

- (void)loadNavBar {
//    [self.navBarView addSubview:self.collectionButton];
    [self.navBarView addSubview:self.shareButton];
    self.titleLabel.text = self.cinemaName;
    [self.navBarView addSubview:self.titleLabel];
}

- (void)loadTableView {
    [self.view addSubview:self.listTable];
    self.listTable.tableFooterView = self.requestLoadingView;
    [self.requestLoadingView startAnimation];
    self.listTable.tableHeaderView = self.cinemaHeaderView;
}

#pragma mark - request

/**
 *  MARK: 请求电影详情
 */
- (void)requestCinemaDetail {
    CinemaRequest *request = [[CinemaRequest alloc] init];

    [request requestCinemaDetail:[NSDictionary
                                         dictionaryWithObjectsAndKeys:
                                                 self.cinemaId,
                                                 @"cinema_id", nil]
            success:^(CinemaDetail *cinemaDetail, ShareContent *share) {
                self.cinemaDetail = cinemaDetail;
                self.share = share;
                [self updateDisplay];
            }
            failure:^(NSError *_Nullable err) {
                DLog(@"request cinema detail err:%@", err);
            }];
}

- (void)loadCinemaMovieList {

    MovieRequest *request = [MovieRequest new];
    [request requestMovieListIn:self.cinemaId
            success:^(NSArray *_Nullable movieList) {

                if (movieList.count > 0) {
                    [self movieListRquestFinished:movieList];
                } else {
                    [self movieListRquestFailed];
                }

            }
            failure:^(NSError *_Nullable err) {
                [self movieListRquestFailed];
            }];
}

/**
 *  MARK: 请求影院特色信息
 */
- (void)loadCinemaLabelList {
    CinemaRequest *request = [[CinemaRequest alloc] init];

    [request
            requestCinemaFeatureParams:[NSDictionary
                                               dictionaryWithObjectsAndKeys:
                                                       self.cinemaId,
                                                       @"cinema_id", nil]
            success:^(NSArray *_Nullable features) {
                self.features = features;

                if (features.count > 0) {
                    NSArray *tags = [features valueForKeyPath:@"@unionOfObjects.tag"];
                    //设置tag
                    self.cinemaHeaderView.specilaInfoList = tags;
                }
            }
            failure:^(NSError *_Nullable err){

            }];
}

/**
 MARK: 请求影院排期
 */
- (void)loadCinemaPlanList:(NSNumber *)movieID {
    
    //判断内存排期里是否有请求过的数据
    NSMutableArray *planArray = [self.cachePlanDic valueForKey:[movieID stringValue]];
    if (planArray) {
        [self.listTable setTableViewHeaderState:tableHeaderNormalState];
        [self planDataProcessing:planArray];
        return;
    }

    //请求排期请求
    [self refreshDataBeforeCinemaPlanRequest];

    PlanRequest *request = [PlanRequest new];
    [request requestPlanList:movieID
            inCineam:self.cinemaId
            success:^(NSArray *_Nullable plans) {

                [self.listTable setTableViewHeaderState:tableHeaderNormalState];

                if (plans.count) {
                    Ticket *ticket = plans[0];
                    [self.cachePlanDic setValue:plans
                                         forKey:[ticket.movieId stringValue]];
                }
                [self planDataProcessing:plans];
            }
            failure:^(NSError *_Nullable err) {
                [self.listTable setTableViewHeaderState:tableHeaderNormalState];

                [self movieListRquestFailed];
            }];
}


/**
 请求电影活动列表

 @param movieId 电影ID
 */
- (void) requestPromotionList:(NSNumber *)movieId
{
    CinemaRequest *request = [CinemaRequest new];
    [request requestPromotionList:[NSNumber numberWithInteger:USER_CITY] cinemaId:self.cinemaId movieID:movieId success:^(NSArray * _Nullable promotionList) {
        
        self.promotionList = promotionList;
        if ([movieId isEqualToNumber:self.movieId]) {
            // 确定当前电影与请求结果的电影一致
            [self.listTable reloadData];
        }
        
        
    } failure:^(NSError * _Nullable err) {
        
    }];
}

- (void)loadCollectRequest {
    CinemaDetailCommonModel *model = [CinemaDetailCommonModel sharedInstance];
    model.delegate = self;
    [model refreshFavCinemaWithCinemaId:self.cinemaId.integerValue];
}

#pragma mark - request Finish
/**
 *  更新显示信息
 */
- (void)updateDisplay {
    self.cinemaHeaderView.cinemaDetail = self.cinemaDetail;

    if (self.share.shareContent &&
        self.share.shareUrl && self.share.sharePicUrl) {
        _shareButton.hidden = NO;
    } else {
        _shareButton.hidden = YES;
    }

    if (!THIRD_LOGIN) {
        self.shareButton.hidden = YES;
    } else {
        self.shareButton.hidden = NO;
    }

    //从网页跳转到App时
    if (!self.cinemaName) {
        self.cinemaName = self.cinemaDetail.cinemaName;
        self.cinemaAddress = self.cinemaDetail.cinemaAddress;
        self.titleLabel.text = self.cinemaDetail.cinemaName;
    }

    //影院须知视图修改
    self.cinemaNoticeView.hidden = YES;
    if (![KKZUtility stringIsEmpty:self.cinemaDetail.closeTicketTimeMsg]) {
        self.cinemaNoticeView.noticeString = self.cinemaDetail.closeTicketTimeMsg;
        [self.cinemaNoticeView updateLayout];
        [self.view addSubview:self.cinemaNoticeView];
        CGRect noticeFrame = self.cinemaNoticeView.frame;
        self.cinemaNoticeView.frame = noticeFrame;
        self.cinemaNoticeView.hidden = NO;
        //影院须知视图动画效果
        [UIView animateWithDuration:0.5f
                         animations:^{
                             CGRect noticeFrame = self.cinemaNoticeView.frame;
                             noticeFrame.origin.y =
                                     kCommonScreenHeight - noticeFrame.size.height;
                             self.cinemaNoticeView.frame = noticeFrame;
                         }];
    }
}

- (void)movieListRquestFinished:(NSArray *)list {
    self.cinemaHeaderView.movieId = self.movieId;
    self.cinemaHeaderView.movieList = list;
}

- (void)movieListRquestFailed {

    //下拉刷新状态置为正常
    [self.listTable setTableViewHeaderState:tableHeaderNormalState];

    //停止加载动画
    [self.requestLoadingView stopAnimation];

    //修改失败视图尺寸
    CGRect frame = self.errorDataView.frame;
    frame.size.height = CGRectGetHeight(self.listTable.frame) -
                        self.listTable.tableFooterView.frame.origin.y;
    if (frame.size.height < errorDataViewMinHeight) {
        frame.size.height = errorDataViewMinHeight;
    }
    self.errorDataView.frame = frame;

    //加载失败视图
    self.listTable.tableFooterView = self.errorDataView;
}

- (void)refreshDataBeforeCinemaPlanRequest {
    [self clearCurrentTableDataSource];
    if (self.listTable.tableFooterView != self.requestLoadingView) {
        self.listTable.tableFooterView = self.requestLoadingView;
        [self.requestLoadingView startAnimation];
    }
    [self changeRequestLoadingViewLayout];
}

- (void)clearCurrentTableDataSource {

    //清空水平切换视图的数据
    self.horizonTableView.dataSource = [[NSMutableArray alloc] init];

    //清空表视图数据
    [self.dataList removeAllObjects];
    [self.listTable reloadData];
}

- (void)changeRequestLoadingViewLayout {
    CGRect frame = self.requestLoadingView.frame;
    CGFloat footerOriginY = self.listTable.tableFooterView.frame.origin.y;
    frame.size.height = CGRectGetHeight(self.listTable.frame) - footerOriginY;
    if (frame.size.height < requestLoadingViewMinHeight) {
        frame.size.height = requestLoadingViewMinHeight;
    }
    self.requestLoadingView.frame = frame;
}

- (void)planDataProcessing:(NSArray *)planArray {

    //移除掉已经存在的排期数据
    [self.currentPlanDic removeAllObjects];
    [self.dateShortDic removeAllObjects];

    //今天的时间
    NSDate *todayDate = [NSDate date];
    NSString *todayString =
            [[DateEngine sharedDateEngine] stringFromDateYYYYMMDD:todayDate];

    //循环排期数组
    self.isLargeToday = FALSE;
    for (int i = 0; i < planArray.count; i++) {
        Ticket *ticket = planArray[i];
        NSDate *planTime = ticket.movieTime;
        NSString *dataString =
                [[DateEngine sharedDateEngine] stringFromDateYYYYMMDD:planTime];
        if ([dataString compare:todayString] == NSOrderedDescending) {
            self.isLargeToday = TRUE;
        }
        if (self.currentPlanDic[dataString]) {
            NSMutableArray *array = self.currentPlanDic[dataString];
            [array addObject:ticket];
        } else {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:ticket];
            self.currentPlanDic[dataString] = array;
            NSString *shortStr = [[DateEngine sharedDateEngine]
                    relativeDayMMDDStringFromDate:planTime];
            self.dateShortDic[dataString] = shortStr;
        }
        
//        [promotionDic setValue:[NSNumber numberWithBool:ticket.has] forKey:dataString]
    }

    //判断如果接口没有返回今天的时间,但是有以后的排期
    if (self.isLargeToday && !self.dateShortDic[todayString]) {
        self.currentPlanDic[todayString] = [[NSMutableArray alloc] init];
        NSString *shortStr =
                [[DateEngine sharedDateEngine] relativeDayMMDDStringFromDate:todayDate];
        self.dateShortDic[todayString] = shortStr;
    }

    //设置排期水平切换视图
    [self setHorizonTableViewDataSource];
}

- (void)setHorizonTableViewDataSource {
    NSSortDescriptor *descriptor =
            [NSSortDescriptor sortDescriptorWithKey:nil
                                          ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray *allKey =
            [[self.currentPlanDic allKeys] sortedArrayUsingDescriptors:descriptors];
    NSMutableArray *promotionArr = [NSMutableArray arrayWithCapacity:self.currentPlanDic.count];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < allKey.count; i++) {
        NSString *str = allKey[i];
        [dataSource addObject:[self.dateShortDic valueForKey:str]];
        // 获取末日排期列表
        NSArray *plans = [self.currentPlanDic objectForKey:str];
        // 获取排期列表是否有活动
        NSArray *allHasPromitions = [plans valueForKeyPath:@"@unionOfObjects.hasPromotion"];
        NSSet *set = [NSSet setWithArray:allHasPromitions];
        // 记录某日排期是否有优惠
        if (set.count == 1 && [set.anyObject boolValue] == YES) {
            [promotionArr addObject:[NSNumber numberWithBool:YES]];
        }else if (set.count == 2){
            [promotionArr addObject:[NSNumber numberWithBool:YES]];
        }else{
            [promotionArr addObject:[NSNumber numberWithBool:NO]];
        }
        
        self.planHasPromotionArr = [promotionArr copy];
    }
    //如果排期全部没有就默认显示今天的时间,代表暂无可售场次
    if (dataSource.count == 0) {
        NSDate *today = [NSDate date];
        NSString *shortStr =
                [[DateEngine sharedDateEngine] relativeDayMMDDStringFromDate:today];
        [dataSource addObject:shortStr];
    }
    if (self.initialSelectedDate) {
        NSInteger index = [allKey indexOfObject:self.initialSelectedDate];
        if (index < dataSource.count) {
            self.horizonTableView.defaultChooseIndex = index;
        } else {
            self.horizonTableView.defaultChooseIndex = 0;
        }
        self.initialSelectedDate = nil;
    } else {
        self.horizonTableView.defaultChooseIndex = 0;
    }
    self.horizonTableView.dataSource = dataSource;
    [self.listTable reloadData];
}

- (void)horizonTableView:(UICollectionView *)tableView
     didSelectRowAtIndex:(NSInteger)index {

    //根据选择的日期索引刷新对应日期下的数据
    [self refreshDataByCurrentDateWithIndex:index];
}

- (void)removeTableFooterView {
    self.footerView.buttonTitle = nil;
    self.listTable.tableFooterView = nil;
}

- (void)refreshDataByCurrentDateWithIndex:(NSInteger)index {
    
    //停止加载动画
    [self.requestLoadingView stopAnimation];
    
    //如果没有排期就显示无场次视图
    if (self.currentPlanDic.count == 0) {
        self.footerView.title = @"暂无可售场次，请切换其他影片";
        self.listTable.tableFooterView = self.footerView;
        return;
    }
    
    //获取到当前选择的分组
    NSString *title = self.horizonTableView.dataSource[index];
    NSString *dateKey = nil;
    for (NSString *key in [self.dateShortDic allKeys]) {
        NSString *value = self.dateShortDic[key];
        if ([title isEqualToString:value]) {
            dateKey = key;
            break;
        }
    }
    
    //如果获取到要显示的分组Key值
    if (dateKey) {
        //获取到当前的系统时间并且转换为今天的时间
        NSDate *today = [NSDate date];
        NSString *shortStr =
        [[DateEngine sharedDateEngine] relativeDayMMDDStringFromDate:today];
        NSComparisonResult result; //是否过期
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        NSDate *lateDate = [[NSDate date]
                            dateByAddingTimeInterval:[self.cinemaCloseTicketTime floatValue] * 60];
        
        //过滤掉过期的排期
        NSMutableArray *list = self.currentPlanDic[dateKey];
        for (int i = 0; i < list.count; i++) {
            Ticket *ticket = list[i];
            result = [ticket.movieTime compare:lateDate];
            ticket.expireDate = YES;
            if (result == NSOrderedDescending) {
                ticket.expireDate = NO;
                [resultArray addObject:ticket];
            }
        }
        
        //如果显示的是今天的排期列表
        if ([shortStr isEqualToString:title]) {
            if (resultArray.count == 0) {
                //明天有排期
                if (self.isLargeToday) {
                    NSString *title = [NSString
                                       stringWithFormat:@"查看%@场次",
                                       self.horizonTableView.dataSource[index + 1]];
                    self.footerView.buttonTitle = title;
                    self.footerView.title = @"暂"
                    @"无可售场次，请选择其他日期或影片";
                    self.listTable.tableFooterView = self.footerView;
                    [self setDataSourceData:resultArray];
                    [self.listTable reloadData];
                    return;
                } else {
                    //明天无排期
                    NSObject *object = [list lastObject];
                    [resultArray addObject:object];
                }
            }
            [self setDataSourceData:resultArray];
        } else {
            [self setDataSourceData:resultArray];
        }
        [self.listTable reloadData];
        
        NSDate *date = [[DateEngine sharedDateEngine] dateFromStringY:dateKey];
        NSString *dateDis = [[DateEngine sharedDateEngine] relativeDateStringFromDate:date];
        KKZAnalyticsEvent *event = [[KKZAnalyticsEvent alloc] init];
        event.movie_id = self.movieId.stringValue;
        event.cinema_name = self.cinemaName;
        event.cinema_id = self.cinemaId.stringValue;
        if ([dateDis isEqualToString:@"今天"]) {
            [KKZAnalytics postActionWithEvent:event action:AnalyticsActionCinema_film_list_today];
        }else if ([dateDis isEqualToString:@"明天"]){
            [KKZAnalytics postActionWithEvent:event action:AnalyticsActionCinema_film_list_tomorrow];
        }else if ([dateDis isEqualToString:@"后天"]){
            [KKZAnalytics postActionWithEvent:event action:AnalyticsActionCinema_film_list_after_tomorrow];
        }
    }
    
    //如果有排期就去除掉无场次视图
    [self removeTableFooterView];
    
   }

- (void)setDataSourceData:(NSMutableArray *)list {

    //数据源布局数组
    _dataLayoutList = [[NSMutableArray alloc] init];

    //遍历数据源进行尺寸计算
    [CinemaPlanCellLayout resetMaxWidthVariable];
    for (int i = 0; i < list.count; i++) {
        Ticket *ticket = list[i];
        CinemaPlanCellLayout *layout = [[CinemaPlanCellLayout alloc] init];
        [layout updateCinemaPlanCellLayout:ticket];
        [_dataLayoutList addObject:layout];
    }
    self.dataList = list;
}

#pragma mark - Table Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier;
    
    if (self.promotionList.count > 0 && indexPath.row < self.promotionList.count) {
        // 优惠
        CellIdentifier = @"StarCellIdentifier_promotion";
    }else {
        CellIdentifier = @"StarCellIdentifier_plan";
    }
    
    //影院排期
    UITableViewCell *cell = [tableView
            dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        if ([CellIdentifier isEqualToString:@"StarCellIdentifier_plan"]) {
            cell = [[CinemaPlanCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:CellIdentifier];
        }else{
            cell = [[CinemaPromotionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    
    // set cell data
    
    if ([CellIdentifier isEqualToString:@"StarCellIdentifier_plan"]) {
        Ticket *model = self.dataList[indexPath.row - self.promotionList.count];
        model.movieLength = _currentMovie.movieLength;
        ((CinemaPlanCell *)cell).model = model;
        ((CinemaPlanCell *)cell).layout = self.dataLayoutList[indexPath.row - self.promotionList.count];
        __weak __typeof(self)weakSelf = self;
        [((CinemaPlanCell *)cell) buyTicketCallback:^(Ticket *plan) {
            [weakSelf toChooseSeatWith:plan];
        }];
    }else{
        Promotion *promotion = self.promotionList[indexPath.row];
        ((CinemaPromotionCell *)cell).title = promotion.promotionTitle;
        ((CinemaPromotionCell *)cell).showBootomLine = (indexPath.row != self.promotionList.count - 1);

    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (self.dataList.count == 0) {
        // 仅当有排期时才显示活动信息
        return 0;
    }
    return self.promotionList.count + self.dataList.count;
}

- (UIView *)tableView:(UITableView *)tableView
        viewForHeaderInSection:(NSInteger)section {
    return self.sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView
        heightForHeaderInSection:(NSInteger)section {
    if (self.horizonTableView.dataSource.count) {
        return sectionHeaderHeight;
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView
        didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.promotionList.count) {
        Promotion *model = self.promotionList[indexPath.row];
        CinemaActivityDetailView *cinemaActivityDetailView = [[CinemaActivityDetailView alloc] initWithFrame:kCommonScreenBounds];
        cinemaActivityDetailView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        cinemaActivityDetailView.model = model;
        [[UIApplication sharedApplication].keyWindow addSubview:cinemaActivityDetailView];
        return;
    }

    //统计事件：选择场次
    if (appDelegate.selectedTab == 0) { //电影入口
        StatisEvent(EVENT_BUY_IN_CINEMA_SOURCE_MOVIE);
    } else if (appDelegate.selectedTab == 1) {
        StatisEvent(EVENT_BUY_IN_CINEMA_SOURCE_CINEMA);
    }

    Ticket *plan = self.dataList[indexPath.row - self.promotionList.count];
    [self toChooseSeatWith:plan];
}


/**
 MARK: 前往选座页

 @param plan 排期
 */
- (void) toChooseSeatWith:(Ticket *)plan
{
    NSString *title = @"购票";
    if (!plan.supportBuy) {
        title = @"即将开放";
    }
    //不过是特惠还是购票只过场都显示过场信息
    if (plan.expireDate) {
        title = @"已过场";
    }
    if ([title isEqualToString:@"购票"]) {
        
        ChooseSeatViewController *chooseSearVC = [ChooseSeatViewController new];
        chooseSearVC.plan = plan;
        chooseSearVC.planArray = self.dataList;
        
        [self pushViewController:chooseSearVC animation:CommonSwitchAnimationBounce];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.promotionList.count) {
        return  40;
    }
    
    return K_CINEMA_PLAN_CELL_HEIGHT;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.listTable cinemaScrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    [self.listTable cinemaScrollViewDidEndDragging:scrollView
                                    willDecelerate:decelerate];
}

#pragma mark - View Delegate

- (void)cinemHeaderHeightChanged:(CGFloat)height {
    self.listTable.tableHeaderView = self.cinemaHeaderView;
    [self changeRequestLoadingViewLayout];
}

- (void)switchMovieDidSelectIndex:(NSInteger)index {
    self.currentMovieIndex = index;
    self.currentMovie = self.cinemaHeaderView.movieList[self.currentMovieIndex];
    self.movieId = self.currentMovie.movieId;
    self.maximumVerticalOffset = self.listTable.contentOffset.y;
    [self loadCinemaPlanList:self.movieId];
    [self.listTable setContentOffset:CGPointMake(0, self.maximumVerticalOffset)
                            animated:NO];
    [self requestPromotionList:self.movieId];
}
/**
 *  MARK: 点击影院信息
 */
- (void)didSelectCinemaTitleHeaderView {
    /*
    NewCinemaDetailViewController *cinema =
            [[NewCinemaDetailViewController alloc] initWithCinema:self.cinemaId.integerValue];
    cinema.cinemaName = self.cinemaName;
    cinema.cinemaDetail = self.cinemaDetail;
    cinema.specilaInfoList = self.features;
    [self pushViewController:cinema animation:CommonSwitchAnimationFlipL];
     */
    if (!_cinemaDetail) {
        return;
    }
    cc2d.latitude = [_cinemaDetail.latitude length] ? [_cinemaDetail.latitude doubleValue] : 0.0;
    cc2d.longitude = [_cinemaDetail.longitude length] ? [_cinemaDetail.longitude doubleValue] : 0.0;
    
    BMKOpenPoiNearbyOption *opt = [[BMKOpenPoiNearbyOption alloc] init];
    opt.appScheme = @"CIASMovie://mapsdk.baidu.com";
    opt.location = cc2d;
    opt.keyword = _cinemaDetail.cinemaName;
    opt.radius = 1000;
    BMKOpenErrorCode code = [BMKOpenPoi openBaiduMapPoiNearbySearch:opt];
    DLog(@"BMKOpenErrorCode %d", code);
    if (code==0 || code==1) {
        
    }else
    {
        [self showSelfMap];
    }
}

- (void)showSelfMap{
    // 直接调用ios自己带的apple map
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    [clGeoCoder geocodeAddressString:[_cinemaDetail.address length]?_cinemaDetail.address:_cinemaDetail.cinemaName
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       DLog(@"placemarks===%@", placemarks);
                       DLog(@"error===%@", error);
                       
                       if ([placemarks count]) {
                           CLPlacemark *placemark = [placemarks objectAtIndex:0];
                           
                           CLLocationCoordinate2D coordinate = placemark.location.coordinate;
                           NSDictionary *address = placemark.addressDictionary;
                           
                           // MKPlacemark是地图上的地标类，CLPlacemark是定位使用的地标类
                           MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:address];
                           
                           MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:place];
                           toLocation.name = _cinemaDetail.cinemaName;
                           [toLocation openInMapsWithLaunchOptions:@{MKLaunchOptionsMapSpanKey:@YES}];
                           
                       }else{
                           [UIAlertView showAlertView:@"位置获取错误" buttonText:@"知道了"];
                       }
                       
                   }];
}


- (void)onClickTomorrowEventButton {
    [self.horizonTableView
                      collectionView:self.horizonTableView.listCollectionView
            didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];
}

- (BOOL)horizonTableViewNeedToEnlargeTheTitleLabelOnClickLabel {
    return NO;
}

- (BOOL)horizonTableViewNeedToShowBottomViewOnClickLabel {
    return YES;
}

- (void)cinemaCollectStatusChanged:(BOOL)isCollect {
    self.isCollected = isCollect;
}

/**
 日期是否显示优惠标签

 @param index 索引
 @return 是否显示优惠标签
 */
- (BOOL) shouldShowOfferIconAtIndex:(NSInteger)index
{
    if (index > self.planHasPromotionArr.count) {
        return NO;
    }
    return [self.planHasPromotionArr[index] boolValue];
}

#pragma mark - setter Method
- (void)setIsCollected:(BOOL)isCollected {
    _isCollected = isCollected;
    if (isCollected) {
        [_collectionButton setImage:[UIImage imageNamed:@"Star_yellow"]
                           forState:UIControlStateNormal];
    } else {
        [_collectionButton setImage:[UIImage imageNamed:@"Star_yellow_no_collect"]
                           forState:UIControlStateNormal];
    }
}

#pragma mark - getter Method
- (UIButton *)collectionButton {
    if (!_collectionButton) {
        _collectionButton = [UIButton buttonWithType:0];
        UIImage *collectImg = [UIImage imageNamed:@"Star_yellow_no_collect"];
        _collectionButton.frame = CGRectMake(
                kCommonScreenWidth - collectImg.size.width - collectionButtonRight -
                        collectionButtonLeft,
                0, collectImg.size.width + collectionButtonRight + collectionButtonLeft,
                CGRectGetHeight(self.navBarView.frame));
        [_collectionButton setImage:collectImg forState:UIControlStateNormal];
        [_collectionButton
                setImageEdgeInsets:UIEdgeInsetsMake(0, collectionButtonLeft, 0,
                                                    collectionButtonRight)];
        _collectionButton.tag = collectionButtonTag;
        [_collectionButton addTarget:self
                              action:@selector(commonBtnClick:)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectionButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:0];
        UIImage *shareImg = [UIImage imageNamed:@"cinema_Ticket_share"];
        CGFloat shareWidth =
                shareImg.size.width + shareButtonLeft + shareButtonRight;
        _shareButton.frame =
                CGRectMake(CGRectGetMinX(_collectionButton.frame) - shareWidth, 0,
                           shareWidth, CGRectGetHeight(self.navBarView.frame));
        [_shareButton setImage:shareImg forState:UIControlStateNormal];
        [_shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, shareButtonLeft, 0,
                                                          shareButtonRight)];
        _shareButton.tag = shareButtonTag;
        [_shareButton addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
        _shareButton.hidden = YES;
    }
    return _shareButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat rightMargin =
                kCommonScreenWidth - CGRectGetMinX(self.shareButton.frame);
        _titleLabel = [[UILabel alloc]
                initWithFrame:CGRectMake(rightMargin, 0,
                                         kCommonScreenWidth - 2 * rightMargin,
                                         CGRectGetHeight(self.navBarView.frame))];
        _titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (CinemaTableView *)listTable {
    if (!_listTable) {
        _listTable = [[CinemaTableView alloc]
                initWithOnlyRefreshFrame:CGRectMake(
                                                 0, CGRectGetMaxY(self.navBarView.frame),
                                                 kCommonScreenWidth,
                                                 kCommonScreenHeight -
                                                         CGRectGetMaxY(self.navBarView.frame))
                                   style:UITableViewStylePlain];
        _listTable.dataSource = self;
        _listTable.delegate = self;
        _listTable.cinemaDelegate = self;
        _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        CGFloat noticeHeight =
        //        CGRectGetHeight(self.cinemaNoticeView.frame);
        _listTable.contentInset = UIEdgeInsetsMake(0, 0, 95.0f, 0);
    }
    return _listTable;
}

- (CinemaHeaderView *)cinemaHeaderView {
    if (!_cinemaHeaderView) {
        _cinemaHeaderView = [[CinemaHeaderView alloc]
                initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 0)];
        _cinemaHeaderView.cinemaName = self.cinemaName;
        _cinemaHeaderView.cinemaAddress = self.cinemaAddress;
        _cinemaHeaderView.delegate = self;
        _cinemaHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _cinemaHeaderView;
}

- (KKZHorizonTableView *)horizonTableView {
    if (!_horizonTableView) {
        _horizonTableView = [[KKZHorizonTableView alloc]
                initWithFrame:CGRectMake(horizonTableLeft, 0,
                                         kCommonScreenWidth - horizonTableLeft * 2,
                                         horizonTableHeight)];
        _horizonTableView.itemSpacing = 20.0f;
        _horizonTableView.labelColor = [UIColor colorWithHex:@"#666666"];
        _horizonTableView.labelFont = [UIFont boldSystemFontOfSize:13.0f];
        _horizonTableView.clickLabelColor = [UIColor colorWithHex:@"#ff6900"];
        _horizonTableView.backgroundColor = [UIColor clearColor];
        _horizonTableView.defaultChooseIndex = 0;
        _horizonTableView.delegate = self;
    }
    return _horizonTableView;
}

- (UIView *)sectionHeaderView {
    if (!_sectionHeaderView) {
        //初始化对象
        _sectionHeaderView =
                [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenHeight,
                                                         sectionHeaderHeight)];
        _sectionHeaderView.backgroundColor = [UIColor whiteColor];
        [_sectionHeaderView addSubview:self.horizonTableView];

        //下分割线
        UIView *lineBottom =
                [[UIView alloc] initWithFrame:CGRectMake(0, sectionHeaderHeight - 0.3f,
                                                         kCommonScreenWidth, 0.3f)];
        lineBottom.backgroundColor = [UIColor colorWithHex:@"#d8d8d8"];
        [_sectionHeaderView addSubview:lineBottom];
    }
    return _sectionHeaderView;
}

- (CinemaPlanTableFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[CinemaPlanTableFooterView alloc]
                initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 0)];
        _footerView.backgroundColor = [UIColor whiteColor];
        _footerView.delegate = self;
    }
    return _footerView;
}

- (RequestLoadingView *)requestLoadingView {
    if (!_requestLoadingView) {
        _requestLoadingView = [[RequestLoadingView alloc]
                initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 100)
                    withTitle:@"正在查询场次列表,请稍候"];
        _requestLoadingView.backgroundColor = [UIColor clearColor];
    }
    return _requestLoadingView;
}

- (ErrorDataView *)errorDataView {
    if (!_errorDataView) {
        _errorDataView = [[ErrorDataView alloc]
                initWithFrame:CGRectMake(0, 0, kCommonScreenWidth,
                                         errorDataViewMinHeight)
                    withTitle:@"影院开小差了，稍后再试"];
        _errorDataView.backgroundColor = [UIColor clearColor];
    }
    return _errorDataView;
}

- (UIView *)defaultFooterView {
    if (!_defaultFooterView) {
        _defaultFooterView =
                [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth,
                                                         errorDataViewMinHeight)];
        _defaultFooterView.backgroundColor = [UIColor redColor];
    }
    return _defaultFooterView;
}

- (KKZShareView *)shareView {
    if (!_shareView) {
        _shareView =
                [[KKZShareView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth,
                                                               kCommonScreenHeight)];
    }
    return _shareView;
}

- (CinemaNoticeView *)cinemaNoticeView {
    if (!_cinemaNoticeView) {
        _cinemaNoticeView = [[CinemaNoticeView alloc]
                initWithFrame:CGRectMake(0, kCommonScreenHeight, kCommonScreenWidth,
                                         0)];
    }
    return _cinemaNoticeView;
}

- (NSMutableDictionary *)currentPlanDic {
    if (!_currentPlanDic) {
        _currentPlanDic = [[NSMutableDictionary alloc] init];
    }
    return _currentPlanDic;
}

- (NSMutableDictionary *)dateShortDic {
    if (!_dateShortDic) {
        _dateShortDic = [[NSMutableDictionary alloc] init];
    }
    return _dateShortDic;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

- (NSMutableDictionary *)cachePlanDic {
    if (!_cachePlanDic) {
        _cachePlanDic = [[NSMutableDictionary alloc] init];
    }
    return _cachePlanDic;
}

- (NSMutableDictionary *)cancelTasks {
    if (!_cancelTasks) {
        _cancelTasks = [[NSMutableDictionary alloc] init];
    }
    return _cancelTasks;
}

#pragma mark - View pulic Method
- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case shareButtonTag: {
            self.shareView.statisType = StatisticsTypeCinema;
            self.shareView.title = self.share.title;
            self.shareView.content = self.share.shareContent;
            self.shareView.url = self.share.shareUrl;
            self.shareView.imageUrl = self.share.sharePicUrl;
            [self.shareView show];
            [self.view addSubview:self.shareView];
            break;
        }
        case collectionButtonTag: {
            StatisEvent(EVENT_CINEMA_COLLECT);

            CinemaDetailCommonModel *model = [CinemaDetailCommonModel sharedInstance];
            model.delegate = self;
            [model doCollectCinemaWithCinemaId:self.cinemaId.integerValue];
            break;
        }
        default:
            break;
    }
}

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showTitleBar {
    return FALSE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
