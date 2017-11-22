//
//  MovieAndCinemaViewController.m
//  KoMovie
//
//  Created by kokozu on 25/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieAndCinemaViewController.h"

//  View
#import "KOKOLocationView.h"
#import "ZYMovieListCell.h"
#import "ZYCinemaCell.h"
#import "MJRefresh.h"
#import "AlertViewY.h"
#import "NoDataViewY.h"

//  Request
#import "CinemaRequest.h"

//  ViewController
#import "MovieDetailViewController.h"
#import "CinemaTicketViewController.h"
#import "CityListNewViewController.h"
#import "CinemaSearchViewController.h"

//  Model
#import "CinemaHelper.h"

static CGFloat segmentedControlWidth = 150.0f;
static CGFloat topBarHeight = 35.0f;

static NSString *CurrentMovieCellIdentifier = @"current-movie-cell";
static NSString *FutureMovieCellIdentifier = @"future-movie-cell";
static NSString *CinemaCellIdentifier = @"Cinema-cell";

#define KOKOLOCATIONVIEWWIDTH ((screentWith - 158) * 0.5 - 10)
#define KOKOLOCATIONVIEWHEIGHT 44.0f

@interface MovieAndCinemaViewController () <KOKOLocationViewDelegate, CityListViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, VerticalCinemaPickerViewDelegate>
{
    //  UI
    KOKOLocationView *_locationView;
    UISegmentedControl *_segmentedControl;
    UIButton *_selectDistrictBtn;
    //遮层
    UIControl *ctrHolder;
    //遮层
    UIControl *ctrHolderWhite;
    //区域选择view
    VerticalCinemaPickerView *districtView;
    AlertViewY *_noAlertView;
    NoDataViewY *_nodataView;
    
    UIView *_topBarView;
    UIButton *_currentMovieButton;
    UIButton *_futureMovieButton;
    
    UITableView *_currentMovieTableView;
    UITableView *_futureMovieTableView;
    UITableView *_cinemaTableView;
    
    //  Data
    NSMutableArray *_currentMovieList;
    NSMutableArray *_futureMovieList;
    NSMutableArray *_cinemaList;
    NSMutableArray *_networkCinemaList;
    NSMutableArray *_districtList;
    NSMutableArray *_districtCinemaList;
}
@end

@implementation MovieAndCinemaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    
    [self prepareNavibar];
    [self prepareTopBar];
    [self prepareCurrentMovieView];
    [self prepareFutureMovieView];
    [self prepareCinemaView];
    [self prepareNotice];
    
    [self loadCurrentMovieData];
    [self loadFutureMovieData];
    [self loadCinemaData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithHomeNotification:) name:@"updateHomeNotifi" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLocationViewLayout];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Prepare

- (void)prepareData {
    _currentMovieList = [[NSMutableArray alloc] init];
    _futureMovieList = [[NSMutableArray alloc] init];
    _cinemaList = [[NSMutableArray alloc] init];
}

- (BOOL)showNavBar {
    return YES;
}

- (BOOL)showTitleBar {
    return NO;
}

- (BOOL)showBackButton {
    return NO;
}

- (void)prepareNavibar {
    _locationView = [[KOKOLocationView alloc] initWithFrame:CGRectMake(0, 20, KOKOLOCATIONVIEWWIDTH, KOKOLOCATIONVIEWHEIGHT)];
    _locationView.delegate = self;

    [self.navBarView addSubview:_locationView];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(kAppScreenWidth - 44, 20, 44, 44);
    [searchButton setImage:[UIImage imageNamed:@"searchIcon"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:searchButton];
    
    //右边筛选按钮
    /*
    _selectDistrictBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectDistrictBtn.backgroundColor = [UIColor clearColor];
    _selectDistrictBtn.hidden = true;
    _selectDistrictBtn.frame = CGRectMake(screentWith - 44 - 5 - 44, 20, 44, 44);
    _selectDistrictBtn.contentEdgeInsets = UIEdgeInsetsMake(13, 10, 13, 12);
    
    [_selectDistrictBtn addTarget:self
                          action:@selector(showDistrictView)
                forControlEvents:UIControlEventTouchUpInside];
    [_selectDistrictBtn setImage:[UIImage imageNamed:@"search_cinemaDistrict_btn"]
                       forState:UIControlStateNormal];
    [self.navBarView addSubview:_selectDistrictBtn];
    */
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"电影", @"影院"]];
    _segmentedControl.frame = CGRectMake((kAppScreenWidth - segmentedControlWidth)/2.0,30, segmentedControlWidth, 44-20);
    _segmentedControl.tintColor = [UIColor grayColor];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl setTitleTextAttributes:@{
                                                NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                NSForegroundColorAttributeName: [UIColor whiteColor]
                                                } forState:UIControlStateNormal];
    [_segmentedControl setTitleTextAttributes:@{
                                                NSFontAttributeName: [UIFont systemFontOfSize:15],
                                                NSForegroundColorAttributeName: appDelegate.kkzBlack
                                                } forState:UIControlStateSelected];
    
    [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.navBarView addSubview:_segmentedControl];
}

- (void)prepareTopBar {
    
    _topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kAppScreenWidth, topBarHeight)];
    _topBarView.backgroundColor = appDelegate.kkzBlack;
    [self.view addSubview:_topBarView];
    
    _currentMovieButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _currentMovieButton.frame = CGRectMake(0, 0, kAppScreenWidth/2.0, topBarHeight);
    _currentMovieButton.backgroundColor = appDelegate.kkzBlack;
    [_currentMovieButton setTitle:@"正在热映" forState:UIControlStateNormal];
    [_currentMovieButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_currentMovieButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _currentMovieButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_currentMovieButton  setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_currentMovieButton setImage:[UIImage imageNamed:@"Movie_current_normal"] forState:UIControlStateNormal];
    [_currentMovieButton setImage:[UIImage imageNamed:@"Movie_current_selected"] forState:UIControlStateSelected];
    [_currentMovieButton addTarget:self action:@selector(currentMovieButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _currentMovieButton.selected = true;
    [_topBarView addSubview:_currentMovieButton];
    
    _futureMovieButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _futureMovieButton.frame = CGRectMake(kAppScreenWidth/2.0, 0, kAppScreenWidth/2.0, topBarHeight);
    _futureMovieButton.backgroundColor = appDelegate.kkzBlack;
    [_futureMovieButton setTitle:@"即将热映" forState:UIControlStateNormal];
    [_futureMovieButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_futureMovieButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _futureMovieButton.titleLabel.font = _currentMovieButton.titleLabel.font;
    [_futureMovieButton setTitleEdgeInsets:_currentMovieButton.titleEdgeInsets];
    [_futureMovieButton setImage:[UIImage imageNamed:@"Movie_Future_normal"] forState:UIControlStateNormal];
    [_futureMovieButton setImage:[UIImage imageNamed:@"Movie_Future_selected"] forState:UIControlStateSelected];
    [_futureMovieButton addTarget:self action:@selector(futureMovieButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topBarView addSubview:_futureMovieButton];
}

- (void)prepareCurrentMovieView {
    _currentMovieTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight + 64, kAppScreenWidth, screentHeight -  topBarHeight - 64 - 49) style:UITableViewStylePlain];
    _currentMovieTableView.backgroundColor = [UIColor whiteColor];
    _currentMovieTableView.delegate = self;
    _currentMovieTableView.dataSource = self;
    [_currentMovieTableView registerClass:[ZYMovieListCell class] forCellReuseIdentifier:CurrentMovieCellIdentifier];
    _currentMovieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_currentMovieTableView];
    
    __weak typeof(self) weakSelf = self;
    [_currentMovieTableView addHeaderWithCallback:^{
        [weakSelf loadCurrentMovieData];
    }];
}

- (void)prepareFutureMovieView {
    _futureMovieTableView = [[UITableView alloc] initWithFrame:_currentMovieTableView.frame style:UITableViewStylePlain];
    _futureMovieTableView.backgroundColor = _currentMovieTableView.backgroundColor;
    _futureMovieTableView.hidden = true;
    _futureMovieTableView.delegate = self;
    _futureMovieTableView.dataSource = self;
    [_futureMovieTableView registerClass:[ZYMovieListCell class] forCellReuseIdentifier:FutureMovieCellIdentifier];
    _futureMovieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_futureMovieTableView];
    
    __weak typeof(self) weakSelf = self;
    [_futureMovieTableView addHeaderWithCallback:^{
        [weakSelf loadFutureMovieData];
    }];
}

- (void)prepareCinemaView {
    _cinemaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kAppScreenWidth, screentHeight - 64 - 49) style:UITableViewStylePlain];
    _cinemaTableView.backgroundColor = _currentMovieTableView.backgroundColor;
    _cinemaTableView.hidden = true;
    _cinemaTableView.delegate = self;
    _cinemaTableView.dataSource = self;
    [_cinemaTableView registerClass:[ZYCinemaCell class] forCellReuseIdentifier:CinemaCellIdentifier];
    _cinemaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_cinemaTableView];
    
    __weak typeof(self) weakSelf = self;
    [_cinemaTableView addHeaderWithCallback:^{
        [weakSelf loadCinemaData];
    }];
}

/**
 *  数据加载提示信息
 */
- (void)prepareNotice {
    _noAlertView = [[AlertViewY alloc]
                        initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 121,
                                                 screentWith, 120)];
    _noAlertView.alertLabelText = @"亲"
    @"，正在获取影院信息，请稍候~";
    
    _nodataView = [[NoDataViewY alloc]
                       initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 121,
                                                screentWith, 120)];
    _nodataView.alertLabelText =
    @"亲，目前这部电影还没有上映影院哦，请再等等吧~";
}

#pragma mark - Network - Request

- (void)loadCurrentMovieData {
    
    if (_currentMovieList.count == 0) {
        [self.view addSubview:_noAlertView];
        [_noAlertView startAnimation];
    }
    
    MovieRequest *movieRequest = [[MovieRequest alloc] init];
    [movieRequest requestMoviesWithCityId:[NSString stringWithFormat:@"%tu", USER_CITY]
                                     page:1
                                  success:^(NSArray *_Nullable movieList) {
                                      [_currentMovieList removeAllObjects];
                                      [_currentMovieList addObjectsFromArray:movieList];
                                      [_currentMovieTableView reloadData];
                                      [_currentMovieTableView headerEndRefreshing];
                                      [_noAlertView removeFromSuperview];
                                  }
                                  failure:^(NSError *_Nullable err) {
                                      [_currentMovieTableView headerEndRefreshing];
                                      [_noAlertView removeFromSuperview];
                                  }];
}

- (void)loadFutureMovieData {
    if (_futureMovieList.count == 0) {
        [self.view addSubview:_noAlertView];
        [_noAlertView startAnimation];
    }
    MovieRequest *movieRequest = [[MovieRequest alloc] init];
    [movieRequest requestInCommingMoviesWithCityId:[NSString stringWithFormat:@"%tu", USER_CITY]
                                              page:1
                                           success:^(NSArray *_Nullable movieList) {
                                               [_futureMovieList removeAllObjects];
                                               [_futureMovieList addObjectsFromArray:movieList];
                                               [_futureMovieTableView reloadData];
                                               [_futureMovieTableView headerEndRefreshing];
                                               [_noAlertView removeFromSuperview];
                                           }
                                           failure:^(NSError *_Nullable err) {
                                               [_futureMovieTableView headerEndRefreshing];
                                               [_noAlertView removeFromSuperview];
                                           }];
}

- (void)loadCinemaData {
    if (USER_CITY) {
        if (_cinemaList.count == 0) {
            [self.view addSubview:_noAlertView];
            [_noAlertView startAnimation];
        }
        CinemaRequest *request = [[CinemaRequest alloc] init];
        [request requestCinemaList:[NSNumber numberWithInt:USER_CITY].stringValue
                           success:^(NSArray *_Nullable cinemas, NSArray *_Nullable favedCinemas,
                                     NSArray *_Nullable favorCinemas) {
                               [_cinemaTableView headerEndRefreshing];
                               //   排序 按照距离
                               NSArray *sortedCinemas = [cinemas sortedArrayUsingComparator:^NSComparisonResult(CinemaDetail *  _Nonnull obj1, CinemaDetail * _Nonnull obj2) {
                                   NSInteger distance1 = obj1.distanceMetres.integerValue;
                                   NSInteger distance2 = obj2.distanceMetres.integerValue;
                                   return distance1 < distance2 ? NSOrderedAscending : NSOrderedDescending;
                               }];
                               
                               [_cinemaList removeAllObjects];
                               [_cinemaList addObjectsFromArray:sortedCinemas];
                               [_cinemaTableView reloadData];
                               _networkCinemaList = [sortedCinemas mutableCopy];
                               
                               //按城区分组
                               [CinemaHelper groupDistrict:_networkCinemaList finish:^(NSArray *districts, NSArray *districtsCinemas) {
                                    _districtCinemaList = [districtsCinemas mutableCopy];
                                    _districtList = [districts mutableCopy];
                                }];
                               [_noAlertView removeFromSuperview];
                           }
                           failure:^(NSError *_Nullable err) {
                               DLog(@"请求影院列表 失败 %@", err);
                               [_cinemaTableView headerEndRefreshing];
                               
                               NSString *messsage =
                               [err.userInfo objectForKey:KKZRequestErrorMessageKey];
                               if (messsage.length > 0) {
                                   [UIAlertView showAlertView:messsage buttonText:@"确定"];
                               }else{
                                   [UIAlertView showAlertView:KNET_FAULT_MSG buttonText:@"确定"];
                               }
                               [_noAlertView removeFromSuperview];
                           }];
        
    } else {
        
        [appDelegate showAlertViewForTitle:@""
                                   message:@"亲, 先选择你所在的城市吧"
                              cancelButton:@"好的"];
    }
}

#pragma mark - UIButton - Action

- (void)segmentedControlAction:(UISegmentedControl *)segmented {
    if (segmented.selectedSegmentIndex == 0) {
        //  电影
        _currentMovieTableView.hidden = !_currentMovieButton.isSelected;
        _futureMovieTableView.hidden = !_futureMovieButton.isSelected;
        _cinemaTableView.hidden = true;
        _selectDistrictBtn.hidden = true;
    } else {
        //  影院
        _currentMovieTableView.hidden = true;
        _futureMovieTableView.hidden = true;
        _cinemaTableView.hidden = false;
        _selectDistrictBtn.hidden = false;
    }
    
    _topBarView.hidden = segmented.selectedSegmentIndex == 1;
}

- (void)searchButtonAction:(UIButton *)button {
    CinemaSearchViewController *vc = [[CinemaSearchViewController alloc] init];
    vc.isFromCinema = _segmentedControl.selectedSegmentIndex == 1;
    vc.allCinemasListLayout = [_cinemaList copy];
    [self.navigationController pushViewController:vc animated:true];
}

/// 正在热映按钮
- (void)currentMovieButtonAction:(UIButton *)button {
    button.selected = true;
    _futureMovieButton.selected = !button.isSelected;
    
    _currentMovieTableView.hidden = false;
    _futureMovieTableView.hidden = true;
    _cinemaTableView.hidden = true;
}

/// 即将上映按钮
- (void)futureMovieButtonAction:(UIButton *)button {
    button.selected = true;
    _currentMovieButton.selected = !button.isSelected;
    
    _currentMovieTableView.hidden = true;
    _futureMovieTableView.hidden = false;
    _cinemaTableView.hidden = true;
}

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
    districtView.districtList = _districtList;
    districtView.allCinemasNum = _cinemaList.count;
    NSMutableDictionary *disDic =
    [NSMutableDictionary dictionaryWithCapacity:_districtList.count];
    //生成城区和个数dic
    for (NSInteger i = 0; i < _districtList.count; i++) {
        NSString *disName = _districtList[i];
        NSArray *cinemas = [_districtCinemaList objectAtIndex:i];
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
        _cinemaList = [_networkCinemaList mutableCopy];
    } else {
        //某个城区影院
        _cinemaList = [_districtCinemaList[districtIndex - 1] mutableCopy];
    }
    
    [_cinemaTableView reloadData];
    [self hiddenDistrictView];
}

#pragma mark - KOKOLocationView - Delegate

/**
 *  切换城市的代理方法
 */
- (void)changeCityBtnClicked:(KOKOLocationView *)locationView {
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
    [self loadFutureMovieData];
    [self loadCurrentMovieData];
    [self loadCinemaData];
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
    
    _locationView.cityText = locationDesc;
}

#pragma mark - UITableView - Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _currentMovieTableView) {
        return _currentMovieList.count;
    } else if (tableView == _futureMovieTableView) {
        return _futureMovieList.count;
    } else if (tableView == _cinemaTableView) {
        return _cinemaList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (tableView == _currentMovieTableView) {
        ZYMovieListCell *c_cell = (ZYMovieListCell *)[tableView dequeueReusableCellWithIdentifier:CurrentMovieCellIdentifier];
        if (_currentMovieList.count > indexPath.row) {
            Movie *model = _currentMovieList[indexPath.row];
            [c_cell update:model type:ZYMovieListCellType_Current];
            cell = c_cell;
        }
        
    } else if (tableView == _futureMovieTableView) {
        ZYMovieListCell *f_cell = (ZYMovieListCell *)[tableView dequeueReusableCellWithIdentifier:FutureMovieCellIdentifier];
        if (_futureMovieList.count > indexPath.row) {
            Movie *model = _futureMovieList[indexPath.row];
            [f_cell update:model type:ZYMovieListCellType_Future];
            cell = f_cell;
        }
    } else if (tableView == _cinemaTableView) {
        ZYCinemaCell *c_cell = (ZYCinemaCell *)[tableView dequeueReusableCellWithIdentifier:CinemaCellIdentifier];
        if (_cinemaList.count > indexPath.row) {
            CinemaDetail *model = _cinemaList[indexPath.row];
            [c_cell update:model];
            cell = c_cell;
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _currentMovieTableView) {
        return 137;
    } else if (tableView == _futureMovieTableView) {
        return 173;
    } else if (tableView == _cinemaTableView) {
        return 80.0;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == _currentMovieTableView) {
        if (_currentMovieList.count > indexPath.row) {
            Movie *model = _currentMovieList[indexPath.row];
            MovieDetailViewController *ctr = [[MovieDetailViewController alloc] initCinemaListForMovie:model.movieId];
            [self.navigationController pushViewController:ctr animated:YES];
        }
    } else if (tableView == _futureMovieTableView) {
        if (_futureMovieList.count > indexPath.row) {
            Movie *model = _futureMovieList[indexPath.row];
            MovieDetailViewController *ctr = [[MovieDetailViewController alloc] initCinemaListForMovie:model.movieId];
            [self.navigationController pushViewController:ctr animated:YES];
        }
    } else if (tableView == _cinemaTableView) {
        if (_cinemaList.count > indexPath.row) {
            CinemaDetail *model = _cinemaList[indexPath.row];
            CinemaTicketViewController *ticket = [[CinemaTicketViewController alloc] init];
            ticket.cinemaName = model.cinemaName;
            ticket.cinemaAddress = model.cinemaAddress;
            ticket.cinemaId = model.cinemaId;
            ticket.cinemaCloseTicketTime = model.closeTicketTime.stringValue;
            ticket.cinemaDetail = model;
            [self pushViewController:ticket animation:CommonSwitchAnimationBounce];
        }
    }
}

#pragma mark - NSNotification Center - Action

- (void)updateWithHomeNotification:(NSNotification *)notifi {
    NSInteger index = [notifi.userInfo[@"index"] integerValue];
    _segmentedControl.selectedSegmentIndex = 0;
    [self segmentedControlAction:_segmentedControl];
    if (index == 0) {
        [self currentMovieButtonAction:_currentMovieButton];
    } else {
        [self futureMovieButtonAction:_futureMovieButton];
    }
}
@end
