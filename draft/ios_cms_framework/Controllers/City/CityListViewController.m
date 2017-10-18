//
//  CityListViewController.m
//  CIASMovie
//
//  Created by hqlgree2 on 26/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import "CityListViewController.h"
#import "CityCell.h"
#import "CityRequest.h"
#import "City.h"
#import "UserDefault.h"
#import "LocationEngine.h"
#import "KKZTextUtility.h"

@interface CityListViewController ()

@end

@implementation CityListViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AddressUpdateSucceededNotification object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:AddressUpdateFailedNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
    self.selectCityBlock = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = NO;
    self.hideBackBtn = YES;
    self.title = @"选择城市";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavBarUI];
    //    self.hideNavigationBar = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor]]
                                           forBarPosition:UIBarPositionAny
                                               barMetrics:UIBarMetricsDefault];
    //添加事件通知
    [self addNotification];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 43)];
    searchView.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
    [self.view addSubview:searchView];
    
//    UIView *searchBarBackView = [UIView new];
//    searchBarBackView.backgroundColor = [UIColor colorWithHex:@"ffffff"];
//    [searchView addSubview:searchBarBackView];
//    searchBarBackView.layer.cornerRadius = 14;
//    searchBarBackView.layer.borderWidth = 0.5;
//    searchBarBackView.layer.borderColor = [UIColor colorWithHex:@"#e0e0e0"].CGColor;
//    [searchBarBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(15));
//        make.top.equalTo(@(7));
//        make.width.equalTo(@(kCommonScreenWidth-30));
//        make.height.equalTo(@(28));
//    }];
//    
//    UIImageView * searchImageView = [UIImageView new];
//    searchImageView.backgroundColor = [UIColor clearColor];
//    searchImageView.clipsToBounds = YES;
//    searchImageView.contentMode = UIViewContentModeCenter;
//    searchImageView.image = [UIImage imageNamed:@"search_icon"];
//    [searchBarBackView addSubview:searchImageView];
//    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(15));
//        make.top.equalTo(@(6));
//        make.width.equalTo(@(16));
//        make.height.equalTo(@(16));
//    }];
    
    citySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 7, kCommonScreenWidth, 28)];
    citySearchBar.delegate = self;
    //    cinemaSearchBar.barStyle = UISearchBarStyleMinimal;
    citySearchBar.placeholder = @"输入城市名称或拼音";
//    CGSize palceholderSize = [KKZTextUtility measureText:@"搜索您想去的城市" size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
//    UIOffset offect = {(kCommonScreenWidth-palceholderSize.width)/2, 0};//第一个值是水平偏移量，第二个是竖直方向的偏移量
//    citySearchBar.searchTextPositionAdjustment = offect;

    //    [cinemaSearchBar setTintColor:[UIColor whiteColor]];
    [citySearchBar setBackgroundImage:[UIImage imageNamed:@"searchBarViewBg"]];
    [citySearchBar setBackgroundColor:[UIColor colorWithHex:@"#f2f5f5"]];
    //    cinemaSearchBar.scopeBarBackgroundImage = [UIImage imageNamed:@""];
    [citySearchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchbar"] forState:UIControlStateNormal];
    [searchView addSubview:citySearchBar];

    
//    citySearchFiled = [UITextField new];
//    citySearchFiled.backgroundColor = [UIColor clearColor];
//    citySearchFiled.placeholder = @"搜索您想去的城市";
//    [searchBarBackView addSubview:citySearchFiled];
//    citySearchFiled.delegate = self;
//    citySearchFiled.textColor = [UIColor colorWithHex:@"#b2b2b2"];
//    citySearchFiled.font = [UIFont systemFontOfSize:14];
//    [citySearchFiled mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@(46));
//        make.top.equalTo(@(5));
//        make.width.equalTo(@(kCommonScreenWidth-90));
//        make.height.equalTo(@(18));
//    }];

    cityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 43, kCommonScreenWidth, kCommonScreenHeight-64-43) style:UITableViewStylePlain];
    cityTableView.backgroundColor = [UIColor colorWithHex:@"f2f5f5"];
    cityTableView.delegate = self;
    cityTableView.dataSource = self;
    cityTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:cityTableView];
    
    searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 43, kCommonScreenWidth, kCommonScreenHeight-64-43) style:UITableViewStylePlain];
    searchTableView.hidden = YES;
    searchTableView.backgroundColor = [UIColor colorWithHex:@"f2f5f5"];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:searchTableView];

    
//    [cityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(@0);
//    }];
//    [cityTableView reloadData];
    self.cityNameGPS = USER_GPS_CITY;
    __weak __typeof(self) weakSelf = self;
    cityTableView.mj_header = [CPRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf requestCityList];
        [weakSelf requestSearchCityList];
    }];
    [self requestCityList];
    [self requestSearchCityList];
    _cityList = [[NSMutableArray alloc] initWithCapacity:0];
    _searchCityList = [[NSMutableArray alloc] initWithCapacity:0];
    
}

- (void)setNavBarUI{
    leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0, 0, 28, 28);
    [leftBarBtn setImage:[UIImage imageNamed:@"titlebar_close"]
                forState:UIControlStateNormal];
    leftBarBtn.backgroundColor = [UIColor clearColor];
    [leftBarBtn addTarget:self
                   action:@selector(leftItemClick)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame = CGRectMake(0, 0, 28, 28);
    [rightBarBtn setImage:[UIImage imageNamed:@"titlebar_refresh"]
                 forState:UIControlStateNormal];
    rightBarBtn.backgroundColor = [UIColor clearColor];
    [rightBarBtn addTarget:self
                    action:@selector(rightItemClick)
          forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
#if K_HENGDIAN
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
}


- (void)requestCityList {
    [[UIConstants sharedDataEngine] loadingAnimation];

    CityRequest *request = [[CityRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [request requestCityListSuccess:^(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes) {
        [weakSelf endRefreshing];

        weakSelf.cities = cities;
        weakSelf.cityIndexes = cityIndexes;
        [cityTableView reloadData];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];

    } failure:^(NSError * _Nullable err) {
        [weakSelf endRefreshing];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];

        [CIASPublicUtility showAlertViewForTaskInfo:err];
        
    }];
    
}

- (void)requestSearchCityList{
    CityRequest *request = [[CityRequest alloc] init];
    [request requestCityListParams:nil success:^(NSArray * _Nullable data) {
        [_cityList removeAllObjects];
        [_cityList addObjectsFromArray:data];
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    } failure:^(NSError * _Nullable err) {
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
    
}


- (void)leftItemClick{
    [citySearchBar resignFirstResponder];
    City *city = [[CityManager shareInstance] getCityWithName:self.cityNameGPS];
    
    if (self.isBindingCardInCity || self.isOpenCardInCity) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if ([USER_CITY length]<=0 && city) {
            USER_CITY_WRITE(city.cityid);
            USER_CITY_NAME_WRITE(city.cityname);
        }
        
        if ([USER_CITY length]<=0) {
            [CIASPublicUtility showAlertViewForTitle:@"" message:@"请选择城市" cancelButton:@"知道了"];
            return;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        if ([USER_CINEMAID length] <= 0) {
            self.selectCityBlock(USER_CITY);
        }
    }
    
}

- (void)rightItemClick{
    [citySearchBar resignFirstResponder];

    //开始定位
    [[LocationEngine sharedLocationEngine] start];
    self.cityNameGPS = @"定位中...";
    CityCell *cell = (CityCell *) [cityTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.cityName = self.cityNameGPS;
    //刷新当前的定位城市信息
    NSRange range = NSMakeRange(0, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [cityTableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
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



/**
 *  定位成功
 */
- (void)gpsCityGetSucceeded {
    self.cityNameGPS = USER_GPS_CITY;
    
    CityCell *cell = (CityCell *) [cityTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    City *city = [[CityManager shareInstance]  getCityWithName:self.cityNameGPS];
    cell.cityName = city.cityname;
    
    NSRange range = NSMakeRange(0, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [cityTableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
}
/**
 *  定位失败
 */
- (void)gpsCityGetFailed {
    if ([USER_GPS_CITY length]) {
        self.cityNameGPS = USER_GPS_CITY;
    } else {
        self.cityNameGPS = @"定位失败";
    }
    if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {
        self.cityNameGPS = @"定位失败";
//        [UIAlertView showAlertView:@"您还没有开启定位功能" buttonText:@"确定" buttonTapped:nil];
        USER_GPS_CITY_WRITE(nil);
    }
    
    CityCell *cell = (CityCell *) [cityTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                      inSection:0]];
    cell.cityName = self.cityNameGPS;
    NSRange range = NSMakeRange(0, 1);
    NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
    [cityTableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationNone];
}



#pragma UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    DLog(@"searchBarShouldBeginEditing");
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    DLog(@"searchBarTextDidBeginEditing");
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    DLog(@"searchBarShouldEndEditing");
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSString *temp = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (temp.length) {
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    CGSize palceholderSize = [KKZTextUtility measureText:searchText.length>0?searchText:@"搜索您想去的城市" size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
//    UIOffset offect = {(kCommonScreenWidth-palceholderSize.width)/2, 0};//第一个值是水平偏移量，第二个是竖直方向的偏移量
//    citySearchBar.searchTextPositionAdjustment = offect;
    [self refreshCinemaSearchList:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)refreshCinemaSearchList:(NSString *)searchTextString{
    [self.searchCityList removeAllObjects];
    //    //筛选影院名中含关键字的影院
    [self.cityList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        City *city = obj;
        if ([city.cityname rangeOfString:searchTextString options:NSCaseInsensitiveSearch].location != NSNotFound || [city.pinyin rangeOfString:searchTextString options:NSCaseInsensitiveSearch].location != NSNotFound) {
//            DLog(@"cityname==%@", city.cityname);
            [self.searchCityList addObject:city];
        }
    }];
    if (self.searchCityList.count) {
        searchTableView.hidden = NO;
        [searchTableView reloadData];
    }else{
        searchTableView.hidden = YES;
    }
    
}



#pragma mark - tableView delegate
- (void)configureCityCell:(CityCell *)cell atIndexPath:(NSIndexPath *)indexPath {
 
    NSInteger realSection;
    if (indexPath.section == 0) {
        City *city = [[CityManager shareInstance]  getCityWithName:self.cityNameGPS];
        if (self.isBindingCardInCity || self.isOpenCardInCity) {
            if ([USER_BIND_CITY length]<=0 && city) {
                cell.isSelected = YES;
                
            }else{
                cell.isSelected = NO;
            }
        } else {
            if ([USER_CITY length]<=0 && city) {
                cell.isSelected = YES;
                
            }else{
                cell.isSelected = NO;
            }
        }
        
        cell.cityName = self.cityNameGPS.length?self.cityNameGPS:@"定位失败";
        [cell updateLayout];
        
        return;
    } else {
        realSection = indexPath.section - 1;
        
        NSString *index = [self.cityIndexes objectAtIndex:realSection];
        NSArray *groupCities = [self.cities kkz_objForKey:index];
        
        City *city = [groupCities objectAtIndex:indexPath.row];
        
        cell.cityName = city.cityname;
        if (self.isBindingCardInCity || self.isOpenCardInCity) {
            if ([USER_BIND_CITY isEqualToString:city.cityid]) {
                cell.isSelected = YES;
            }else{
                cell.isSelected = NO;
            }
        } else {
            if ([USER_CITY isEqualToString:city.cityid]) {
                cell.isSelected = YES;
            }else{
                cell.isSelected = NO;
            }
        }
        

    }
//    realSection = indexPath.section;
    [cell updateLayout];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==cityTableView) {
        
        static NSString *cellID = @"CityCell";
        CityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[CityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        [self configureCityCell:cell atIndexPath:indexPath];
        
        return cell;
    }else{
        
        static NSString *cellID = @"SearchCityCell";
        CityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[CityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        City *city = [self.searchCityList objectAtIndex:indexPath.row];
        cell.cityName = city.cityname;
        [cell updateLayout];

        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView==cityTableView) {
        NSInteger realSection;
        if (section == 0) {
            return 1;
        } else {
            realSection = section - 1;
        }
        //    realSection =section;
        NSString *index = [self.cityIndexes objectAtIndex:realSection];
        NSArray *group = [self.cities objectForKey:index];
        NSInteger groupSize = [group count];
        return groupSize;
    }else{
        return self.searchCityList.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.row < self.cinemaPlanListDict.count) {
    //        Cinema *ciname = self.allCinemas[indexPath.row];
    //        NSArray *plansArr = self.cinemaPlanListDict[ciname.cinemaId];
    //        //仅当影院有排期时
    //        if (plansArr.count) {
    //            return 143;
    //        }
    //        return 79;
    //    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isBindingCardInCity || self.isOpenCardInCity) {
        
    } else {
        USER_CINEMAID_WRITE(nil);
        USER_CINEMA_NAME_WRITE(nil);
        USER_CINEMA_ADDRESS_WRITE(nil);
        CINEMA_LATITUDE_WRITE(nil);
        CINEMA_LONGITUDE_WRITE(nil);
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    if (tableView==cityTableView) {
        if (indexPath.section == 0) {
            City *city = [[CityManager shareInstance]  getCityWithName:self.cityNameGPS];
            
            if (city) {
                if (self.isBindingCardInCity || self.isOpenCardInCity) {
                    USER_BIND_CITY_WRITE(city.cityid);
                    USER_BIND_CITY_NAME_WRITE(city.cityname);

                    self.selectCityForCardBlock(city.cityid,city.cityname);
                } else {
                    USER_CITY_WRITE(city.cityid);
                    USER_CITY_NAME_WRITE(city.cityname);
                }

            }else{
                return;
            }
        }else{
            NSInteger realSection = indexPath.section - 1;
            NSString *index = [self.cityIndexes objectAtIndex:realSection];
            NSArray *groupCities = [self.cities kkz_objForKey:index];
            
            City *city = [groupCities objectAtIndex:indexPath.row];
            if (self.isBindingCardInCity || self.isOpenCardInCity) {
                USER_BIND_CITY_WRITE(city.cityid);
                USER_BIND_CITY_NAME_WRITE(city.cityname);

                self.selectCityForCardBlock(city.cityid,city.cityname);
            } else {
                USER_CITY_WRITE(city.cityid);
                USER_CITY_NAME_WRITE(city.cityname);
            }
            
            
        }
    }else{
        City *city = [self.searchCityList objectAtIndex:indexPath.row];
        if (self.isBindingCardInCity || self.isOpenCardInCity) {
            USER_BIND_CITY_WRITE(city.cityid);
            USER_BIND_CITY_NAME_WRITE(city.cityname);

            self.selectCityForCardBlock(city.cityid,city.cityname);
        } else {
            USER_CITY_WRITE(city.cityid);
            USER_CITY_NAME_WRITE(city.cityname);
        }
       
    }
    if (self.isBindingCardInCity || self.isOpenCardInCity) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSNotification *notification = [NSNotification notificationWithName:CityUpdateSucceededNotification
                                                                     object:self
                                                                   userInfo:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        });
        [self.navigationController popViewControllerAnimated:YES];
        self.selectCityBlock(USER_CITY);
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView==cityTableView) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 24)];
        sectionView.backgroundColor = [UIColor colorWithHex:@"e0e0e0"];
        
        UILabel *sectionLabel = [UILabel new];
        sectionLabel.backgroundColor = [UIColor clearColor];
        sectionLabel.textColor = [UIColor colorWithHex:@"333333"];
        sectionLabel.font = [UIFont systemFontOfSize:10];
        [sectionView addSubview:sectionLabel];
        [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.top.equalTo(@(0));
            make.width.equalTo(@(150));
            make.height.equalTo(@(24));
        }];
        if (section==0) {
            sectionLabel.text = @"GPS定位";
        }else{
            sectionLabel.text = [NSString stringWithFormat:@"%@", [self.cityIndexes objectAtIndex:section-1]];
        }
        //    UIView *line = [UIView new];
        //    line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        //    [sectionView addSubview:line];
        //    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.width.equalTo(sectionView);
        //        make.top.equalTo(sectionView.mas_bottom).offset(-1);
        //        make.height.equalTo(@(1));
        //    }];
        
        return sectionView;

    }else{
        return nil;

    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==cityTableView) {
        return 24;

    }else{
        return 0;

    }
    return 0;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==cityTableView) {
        return self.cityIndexes.count + 1;

    }else{
        return 1;
    }
    return 0;
//    return self.cityIndexes.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [citySearchBar resignFirstResponder];
    
}



/**
 *  结束刷新
 */
- (void)endRefreshing {
    if ([cityTableView.mj_header isRefreshing]) {
        [cityTableView.mj_header endRefreshing];
    }
}



@end
