//
//  城市列表页面
//
//  Created by KKZ on 16/1/25.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CityListNewViewController.h"

#import "AlertViewY.h"
#import "City.h"
#import "CityCellHeaderView.h"
#import "Constants.h"
#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "LocationEngine.h"
#import "TaskQueue.h"
#import "UIViewControllerExtra.h"
#import "UserDefault.h"
#import "NoDataViewY.h"
#import "CityRequest.h"

@interface CityListNewViewController ()
/**
 *  城市列表
 */
@property (nonatomic, retain) NSDictionary *cities;
/**
 *  城市索引
 */
@property (nonatomic, retain) NSArray *cityIndexes;
@end

@implementation CityListNewViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AddressUpdateSucceededNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AddressUpdateFailedNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载导航条
    [self loadNavBar];
    //添加事件通知
    [self addNotification];
    //添加列表数据提示信息
    [self addTableNotice];
    //获取到的定位城市信息
    headerSet = [[NSMutableArray alloc] init];
    //当前定位城市
    self.cityNameGPS = USER_GPS_CITY;
    //加载城市列表
    [self loadTable];
    //请求列表信息
    [self refreshNetCityList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //进入城市列表页面，用户未选择城市时，给出的用户提示
    if (!USER_CITY) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"先选择您所在的城市吧"
                              cancelButton:@"好的"];
        appDelegate.cityChange = NO;
    } else {
        appDelegate.cityChange = YES;
    }
}

#pragma mark 添加UI信息
/**
 *  加载导航栏
 */
- (void)loadNavBar {
    self.kkzTitleLabel.text = @"选择城市";

    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = CGRectMake(screentWith - 70, 4, 60, 38);
    locationBtn.backgroundColor = [UIColor clearColor];
    [locationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    locationBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [locationBtn setTitle:@"重新定位" forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationCityClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:locationBtn];
}

/**
 *  loadTable
 */
- (void)loadTable {
    if (!cityTable) {
        cityTable = [[UITableView alloc] initWithFrame:CGRectMake(6, 44 + self.contentPositionY, screentWith - 6 * 2, screentContentHeight - 44)
                                                 style:UITableViewStylePlain];
        cityTable.delegate = self;
        cityTable.dataSource = self;
        cityTable.backgroundColor = [UIColor clearColor];
        cityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:cityTable];

#if __IPHONE_7_0
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            cityTable.sectionIndexBackgroundColor = [UIColor clearColor];
            cityTable.sectionIndexColor = [UIColor lightGrayColor];
            cityTable.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        }
#endif
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6) {
            cityTable.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        }

        refreshHeaderView = [[EGORefreshTableHeaderView alloc]
                initWithFrame:CGRectMake(0, -cityTable.bounds.size.height, screentWith, cityTable.bounds.size.height)];
        [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];
        [refreshHeaderView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [cityTable addSubview:refreshHeaderView];

        [[LocationEngine sharedLocationEngine] start];

        if (USER_GPS_CITY) {
            self.cityNameGPS = USER_GPS_CITY;
        } else {
            self.cityNameGPS = @"定位中...";
        }
    }
}
#pragma mark 重新定位
/**
 *  点击重新定位事件
 */
- (void)locationCityClick {
    //开始定位
    [[LocationEngine sharedLocationEngine] start];
    self.cityNameGPS = @"定位中...";
    CityCell *cell = (CityCell *) [cityTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.leftName = self.cityNameGPS;
    //刷新当前的定位城市信息
    NSRange range = NSMakeRange(0, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [cityTable reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 添加事件通知
- (void)addNotification {
    //获取定位城市成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gpsCityGetSucceeded)
                                                 name:AddressUpdateSucceededNotification
                                               object:nil];
    //获取定位城市失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gpsCityGetFailed)
                                                 name:AddressUpdateFailedNotification
                                               object:nil];
}

#pragma mark - handle notifications

/**
 *  定位成功
 */
- (void)gpsCityGetSucceeded {
    self.cityNameGPS = USER_GPS_CITY;

    CityCell *cell = (CityCell *) [cityTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    City *city = [City getCityWithName:self.cityNameGPS];
    cell.leftName = city.cityName;
    cell.leftId = city.cityId.intValue;

    NSRange range = NSMakeRange(0, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [cityTable reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
}
/**
 *  定位失败
 */
- (void)gpsCityGetFailed {
    if (USER_GPS_CITY) {
        self.cityNameGPS = USER_GPS_CITY;
    } else {
        self.cityNameGPS = @"定位失败";
    }
    if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {
        self.cityNameGPS = @"定位失败";
        [UIAlertView showAlertView:@"您还没有开启定位功能" buttonText:@"确定" buttonTapped:nil];
        USER_GPS_CITY_WRITE(nil);
    }

    CityCell *cell = (CityCell *) [cityTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                      inSection:0]];
    cell.leftName = self.cityNameGPS;
    NSRange range = NSMakeRange(0, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [cityTable reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark 添加列表的提示信息
/**
 *  添加列表的提示信息
 */
- (void)addTableNotice {
    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, screentHeight * 0.5 - 120, screentWith, 120)];
    nodataView.alertLabelText = @"获取城市列表失败";
    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, screentHeight * 0.5 - 120, screentWith, 120)];
    noAlertView.alertLabelText = @"正在查询城市列表，请稍候...";
}

#pragma mark UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
            delay:0.0f
            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
            animations:^{
                cityTable.contentInset = UIEdgeInsetsZero;
            }
            completion:^(BOOL finished) {
                [refreshHeaderView setState:EGOOPullRefreshNormal];
                if (cityTable.contentOffset.y <= 0) {
                    [cityTable setContentOffset:CGPointZero animated:YES];
                }
            }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging && scrollView == cityTable) {
        if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {
            [refreshHeaderView setState:EGOOPullRefreshNormal];
        } else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
            [refreshHeaderView setState:EGOOPullRefreshPulling];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (refreshHeaderView.state == EGOOPullRefreshLoading) {
        return;
    }
    if (scrollView.contentOffset.y <= -65.0f) {
        [self refreshNetCityList];
    }
}

#pragma mark 获取列表信息
/**
 *  获取城市列表
 */
- (void)refreshNetCityList {
    if (self.cities == 0) {
        [nodataView removeFromSuperview];
        [cityTable addSubview:noAlertView];
        [noAlertView startAnimation];
    }
    
    CityRequest *request = [[CityRequest alloc]init];
    [request requestCityListSuccess:^(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes) {
        [appDelegate hideIndicator];
        [noAlertView removeFromSuperview];
        self.cities = cities;
        self.cityIndexes = cityIndexes;
        
        if (self.cities == 0) {
            [cityTable addSubview:nodataView];
        } else {
            [nodataView removeFromSuperview];
        }
        
        [cityTable reloadData];
    } failure:^(NSError * _Nullable err) {
        [appDelegate hideIndicator];
        [noAlertView removeFromSuperview];
    }];
}


#pragma mark - CityCell delegate
- (void)handleTouchWithCityId:(int)cityId withCityName:(NSString *)cityName {

    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseCityWithName:withCityId:)]) {
        if (cityId == 0) {
            if ([self.cityNameGPS isEqualToString:@"定位失败"] || [self.cityNameGPS isEqualToString:@"定位中..."]) {
                return;
            }
        }
        [self.delegate chooseCityWithName:cityName
                               withCityId:[NSString stringWithFormat:@"%d", cityId]];
        [self cancelViewController];
        return;
    }

    if (cityId == 0) {
        if ([self.cityNameGPS isEqualToString:@"定位失败"] || [self.cityNameGPS isEqualToString:@"定位中..."]) {
            return;
        }

        City *managedObject = [City getCityWithName:self.cityNameGPS];
        if (managedObject) {
            if ([managedObject.cityId isEqualToNumber:[NSNumber numberWithInt:USER_CITY]]) {
                USER_CITY_WRITE(managedObject.cityId);
            } else {
                USER_CITY_WRITE(managedObject.cityId);
                [self performSelector:@selector(changeCity) withObject:nil afterDelay:.1];
            }
        }
    } else {
        USER_CITY_WRITE([NSNumber numberWithInt:cityId]);
        [self performSelector:@selector(changeCity) withObject:nil afterDelay:.1];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self cancelViewController];
}

- (void)changeCity {
    if (self.delegate && [self.delegate respondsToSelector:@selector(myCityDidChange)]) {
        [self.delegate myCityDidChange];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger realSection;
    if (section == 0) {
        return 1;
    } else {
        realSection = section - 1;
    }

    NSString *index = [self.cityIndexes objectAtIndex:realSection];
    NSInteger groupSize = [(NSArray *)[self.cities objectForKey:index] count];
    return groupSize / 3 + (groupSize % 3 > 0 ? 1 : 0);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.cityIndexes count] + 1;
}

- (void)configureCityCell:(CityCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.leftId = 0;
    cell.leftName = nil;
    cell.middleId = 0;
    cell.middleName = nil;
    cell.rightId = 0;
    cell.rightName = nil;

    NSInteger realSection;
    if (indexPath.section == 0) {
        cell.leftId = 0;
        cell.leftName = self.cityNameGPS;
        [cell updateLayout];
        return;
    } else {
        realSection = indexPath.section - 1;
    }

    NSString *index = [self.cityIndexes objectAtIndex:realSection];
    NSArray *groupCities = [self.cities objectForKey:index];

    City *leftCity = nil, *middleCity = nil, *rightCity = nil;
    int rowNum = 3;
    if (indexPath.row * rowNum < [groupCities count]) {
        leftCity = [groupCities objectAtIndex:indexPath.row * rowNum];
        cell.leftId = leftCity.cityId.intValue;
        cell.leftName = leftCity.cityName;
    }
    if (indexPath.row * rowNum + 1 < [groupCities count]) {
        middleCity = [groupCities objectAtIndex:indexPath.row * rowNum + 1];
        cell.middleId = middleCity.cityId.intValue;
        cell.middleName = middleCity.cityName;
    }
    if (rowNum > 2 && indexPath.row * rowNum + 2 < [groupCities count]) {
        rightCity = [groupCities objectAtIndex:indexPath.row * rowNum + 2];
        cell.rightId = rightCity.cityId.intValue;
        cell.rightName = rightCity.cityName;
    }
    [cell updateLayout];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";

    CityCell *cell = (CityCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CityCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }

    [self configureCityCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *indexNames = [[NSMutableArray alloc] init];
    [indexNames addObject:@"#"];
    [indexNames addObjectsFromArray:self.cityIndexes];
    return indexNames;
}

- (CityCellHeaderView *)dequeueHeader {
    @synchronized([CityListNewViewController class]) {
        for (CityCellHeaderView *header in headerSet) {
            if (![header superview]) {
                return header;
            }
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CityCellHeaderView *headerView = [self dequeueHeader];
    if (!headerView) {
        @synchronized([CityListNewViewController class]) {
            if (!headerView) {
                headerView = [[CityCellHeaderView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 35)];
                [headerSet addObject:headerView];
            }
        }
    }

    NSInteger realSection;
    if (section == 0) {
        headerView.title = @"GPS定位城市";
        return headerView;
    } else {
        realSection = section - 1;
    }

    NSString *index = [self.cityIndexes objectAtIndex:realSection];
    if ([index isEqualToString:@"!"]) {
        headerView.title = @"热门城市";
    } else {
        headerView.title = index;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

#pragma mark override from CommonViewController
- (void)cancelViewController {
    if (!USER_CITY) {
        [UIAlertView showAlertView:@"请先选择城市" buttonText:@"确定" buttonTapped:nil];
    } else {
        [super cancelViewController];
    }
}




@end
