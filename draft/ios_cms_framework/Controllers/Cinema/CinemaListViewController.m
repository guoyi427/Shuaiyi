//
//  CinemaListViewController.m
//  CIASMovie
//
//  Created by hqlgree2 on 26/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import "CinemaListViewController.h"
#import "CinemaCell.h"
#import "CityListViewController.h"
#import "CinemaRequest.h"
#import "Cinema.h"
#import "UserDefault.h"
#import "CardCinema.h"
#import "CardCinemaList.h"
#import "KKZTextUtility.h"

@interface CinemaListViewController ()
{
    BOOL isResignField;

}
@end

@implementation CinemaListViewController

- (void)dealloc
{
    self.selectCinemaBlock = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = NO;
    self.title = @"选影院";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor]]
                                           forBarPosition:UIBarPositionAny
                                               barMetrics:UIBarMetricsDefault];
    selectCityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth/2-50, 44)];
    selectCityView.backgroundColor = [UIColor clearColor];
    UIBarButtonItem *cityItem = [[UIBarButtonItem alloc] initWithCustomView:selectCityView];
    [self.navigationItem  setRightBarButtonItem:cityItem];
    arrowImageView = [UIImageView new];
    arrowImageView.backgroundColor = [UIColor clearColor];
    arrowImageView.clipsToBounds = YES;
    arrowImageView.frame = CGRectMake(kCommonScreenWidth/2-60, 20, 10, 6);
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    arrowImageView.image = [UIImage imageNamed:@"home_location_arrow2"];
    [selectCityView addSubview:arrowImageView];
//    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(selectCityView.mas_right).offset(-15);
//        make.top.equalTo(@(37-20));
//        make.width.equalTo(@(10));
//        make.height.equalTo(@(6));
//    }];
    
    cityNameLabel = [UILabel new];
    cityNameLabel.backgroundColor = [UIColor clearColor];
    
    #if K_HENGDIAN
    cityNameLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    #else
    cityNameLabel.textColor = [UIColor whiteColor];
    #endif
    cityNameLabel.textAlignment = NSTextAlignmentRight;
    cityNameLabel.font = [UIFont systemFontOfSize:14];
    cityNameLabel.frame = CGRectMake(0, 0, kCommonScreenWidth/2-65, 44);
    [selectCityView addSubview:cityNameLabel];
//    [cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        //        make.left.equalTo(segmentedControl.mas_right).offset(15);
//        make.top.equalTo(@(33-20));
//        make.right.equalTo(selectCityView.mas_right).offset(-30);
//        make.width.equalTo(@(kCommonScreenWidth/2-60));
//        make.height.equalTo(@(15));
//    }];
    selectCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectCityBtn.frame = CGRectMake(0, 0, kCommonScreenWidth/2-50, 44);
    [selectCityView addSubview:selectCityBtn];
    selectCityBtn.backgroundColor = [UIColor clearColor];
    [selectCityBtn addTarget:self action:@selector(selectCityBtn) forControlEvents:UIControlEventTouchUpInside];
//    [selectCityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        //        make.left.equalTo(segmentedControl.mas_right).offset(15);
//        make.top.equalTo(@(30-20));
//        make.right.equalTo(selectCityView.mas_right);
//        make.width.equalTo(@(kCommonScreenWidth/2-30));
//        make.height.equalTo(@(22));
//    }];
    
    
    _cinemaList = [[NSMutableArray alloc] initWithCapacity:0];
    _searchCinemaList = [[NSMutableArray alloc] initWithCapacity:0];
    
    //    [_cinemaList addObjectsFromArray:[NSArray arrayWithObjects:@"全部",@"2017年1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月", nil]];
    
    cinemaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight-49) style:UITableViewStylePlain];
    cinemaTableView.backgroundColor = [UIColor colorWithHex:@"f2f5f5"];
    cinemaTableView.delegate = self;
    cinemaTableView.dataSource = self;
    cinemaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:cinemaTableView];
    [cinemaTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    __weak __typeof(self) weakSelf = self;
    cinemaTableView.mj_header = [CPRefreshHeader headerWithRefreshingBlock:^{
        if (weakSelf.isOpenCard||weakSelf.isBindingCard) {
            [weakSelf requestCinemaListWithCityId:[USER_BIND_CITY length]?USER_BIND_CITY:([USER_CITY length]?USER_CITY:USER_GPS_CITY)];
        } else {
            [weakSelf requestCinemaListWithCityId:@""];
        }
    }];
    if (self.isOpenCard||self.isBindingCard) {
        [self requestCinemaListWithCityId:[USER_BIND_CITY length]?USER_BIND_CITY:([USER_CITY length]?USER_CITY:USER_GPS_CITY)];
    } else {
        [self requestCinemaListWithCityId:@""];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
#if K_HENGDIAN
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
    if (self.isBindingCard||self.isOpenCard) {
        cityNameLabel.text = [USER_BIND_CITY_NAME length]?USER_BIND_CITY_NAME:([USER_CITY_NAME length]?USER_CITY_NAME:USER_GPS_CITY);
        
    } else {
        cityNameLabel.text = [USER_CITY_NAME length]?USER_CITY_NAME:USER_GPS_CITY;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [cinemaSearchBar resignFirstResponder];
}

- (void)backAction{
    if (self.isBindingCard || self.isOpenCard) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (_cinemaList.count == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if ([USER_CINEMAID length]<=0) {
                [CIASPublicUtility showAlertViewForTitle:@"" message:@"请选择影院" cancelButton:@"知道了"];
                return;
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    
}

- (void)selectCityBtn{
    __weak __typeof(self) weakSelf = self;
    if (self.isBindingCard || self.isOpenCard) {
        CityListViewController *ctr = [[CityListViewController alloc] init];
        ctr.isBindingCardInCity = self.isBindingCard;
        ctr.isOpenCardInCity = self.isOpenCard;
        ctr.selectCityForCardBlock = ^(NSString *cityId,NSString *cityName){
            cityNameLabel.text = cityName;
            [weakSelf requestCinemaListWithCityId:cityId];
        };
        [self.navigationController pushViewController:ctr animated:YES];
    } else {
        CityListViewController *ctr = [[CityListViewController alloc] init];
        ctr.selectCityBlock = ^(NSString *cityId){
            cityNameLabel.text = USER_CITY_NAME;
            [weakSelf.searchCinemaList removeAllObjects];
            [weakSelf requestCinemaListWithCityId:cityId];
        };
        [self.navigationController pushViewController:ctr animated:YES];
    }
    
    
    
}

- (void)requestCinemaListWithCityId:(NSString *) cityId{
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    if (self.isBindingCard || self.isOpenCard) {
        if ([cityId length]>0) {
            [params setObject:cityId forKey:@"cityId"];
        }
    } else {
        if ([USER_CITY length]>0) {
            [params setObject:USER_CITY forKey:@"cityId"];
        }
        NSString *latString = [BAIDU_USER_LATITUDE length] ? BAIDU_USER_LATITUDE : USER_LATITUDE;
        NSString *lonString = [BAIDU_USER_LONGITUDE length] ? BAIDU_USER_LONGITUDE : USER_LONGITUDE;
        if (latString.length > 0) {
            [params setObject:latString forKey:@"lat"];
        }
        if (lonString.length > 0) {
            [params setObject:lonString forKey:@"lon"];
        }
    }
    
    CinemaRequest *request = [[CinemaRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    //MARK: 区分开卡还是选择影院，或者绑卡
    if (self.isOpenCard) {
        [params setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"pageNumber"];
        [params setObject:[NSString stringWithFormat:@"%d", 50] forKey:@"pageSize"];
        [request requestOpenCardCinemaListParams:params success:^(NSDictionary * _Nullable data) {
            [weakSelf endRefreshing];
            CardCinemaList *cardCinemaList = (CardCinemaList *)data;
            if (weakSelf.cinemaList.count > 0) {
                [weakSelf.cinemaList removeAllObjects];
            }
            [weakSelf.cinemaList addObjectsFromArray:cardCinemaList.rows];
            //主线程刷新，防止闪烁
            dispatch_async(dispatch_get_main_queue(), ^{
                [cinemaTableView reloadData];
            });
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            
        } failure:^(NSError * _Nullable err) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            [CIASPublicUtility showAlertViewForTaskInfo:err];
        }];
    } else {
        [request requestCinemaListParams:params success:^(NSArray * _Nullable data) {
            [weakSelf endRefreshing];
            if (weakSelf.cinemaList.count > 0) {
                [weakSelf.cinemaList removeAllObjects];
            }
            [weakSelf.cinemaList addObjectsFromArray:data];
            //主线程刷新，防止闪烁
            dispatch_async(dispatch_get_main_queue(), ^{
                [cinemaTableView reloadData];
            });
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            
        } failure:^(NSError * _Nullable err) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            [CIASPublicUtility showAlertViewForTaskInfo:err];
        }];
    }
    
    
    
}




#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CinemaCell";
    
    Cinema *cinema = nil;
    CardCinema *cinemaCard = nil;
    if (self.isOpenCard) {
        if (self.searchCinemaList.count) {
            cinemaCard = [self.searchCinemaList objectAtIndex:indexPath.row];
        }else{
            cinemaCard = [self.cinemaList objectAtIndex:indexPath.row];
        }
    } else {
        if (self.searchCinemaList.count) {
            cinema = [self.searchCinemaList objectAtIndex:indexPath.row];
        }else{
            cinema = [self.cinemaList objectAtIndex:indexPath.row];
        }
    }
    
    
    
    CinemaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CinemaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (self.isOpenCard) {
        cell.cinemaName = cinemaCard.cinemaName;
        cell.cinemaAddress = cinemaCard.cinemaAddress;
        cell.isnear = 0;
        if ([USER_OPEN_CINEMAID isEqualToString:[NSString stringWithFormat:@"%d",cinemaCard.cinemaId.intValue]]) {
            cell.isSelected = YES;
        }else{
            cell.isSelected = NO;
        }
        cell.distance = @"";
        cell.isFromOpenCard = YES;
        [cell updateLayout];
    } else {
        cell.cinemaName = cinema.cinemaName;
        cell.cinemaAddress = cinema.address;
        cell.isCome = cinema.isCome;
        cell.isnear = cinema.isNear;
        if ([USER_CINEMAID isEqualToString:cinema.cinemaId] || [USER_BINGD_CINEMAID isEqualToString:cinema.cinemaId]) {
            cell.isSelected = YES;
        }else{
            cell.isSelected = NO;
        }
        cell.distance = cinema.distance;
#if kIsHaveTipLabelInCinemaList
//        DLog(@"%@", cinema.serviceFeatures);
        if (cinema.serviceFeatures.count > 0) {
            cell.featureArr = cinema.serviceFeatures;
        }else {
            cell.featureArr = [NSArray array];
        }
#endif
        
        [cell updateLayout];
    }
    
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchCinemaList.count) {
        return _searchCinemaList.count;
        
    }else{
        return _cinemaList.count;
    }
    return 0;
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
    
    CGFloat cellHeight = 0.0;

    Cinema *cinema = nil;
    CardCinema *cinemaCard = nil;
    if (self.isOpenCard) {
        if (self.searchCinemaList.count) {
            cinemaCard = [self.searchCinemaList objectAtIndex:indexPath.row];
        }else{
            cinemaCard = [self.cinemaList objectAtIndex:indexPath.row];
        }
    } else {
        if (self.searchCinemaList.count) {
            cinema = [self.searchCinemaList objectAtIndex:indexPath.row];
        }else{
            cinema = [self.cinemaList objectAtIndex:indexPath.row];
        }
    }
    NSString *cinemaFeatureStr = @"D BOX厅";
    CGSize cinemaFeatureStrSize = [KKZTextUtility measureText:cinemaFeatureStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
    if (self.isOpenCard) {
        cellHeight = 67;
    } else {
#if kIsHaveTipLabelInCinemaList
        if (cinema.serviceFeatures.count>0) {
            cellHeight = 67+cinemaFeatureStrSize.height+10+7+15;
        } else {
            cellHeight = 67;
        }
#else
        cellHeight = 67;
#endif
    }
    
    return cellHeight*Constants.screenHeightRate;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [cinemaSearchBar resignFirstResponder];
    Cinema *cinema = nil;
    CardCinema *cinemaCard = nil;
    if (self.isOpenCard) {
        if (self.searchCinemaList.count) {
            cinemaCard = [self.searchCinemaList objectAtIndex:indexPath.row];
        }else{
            cinemaCard = [self.cinemaList objectAtIndex:indexPath.row];
        }
    } else {
        if (self.searchCinemaList.count) {
            cinema = [self.searchCinemaList objectAtIndex:indexPath.row];
        }else{
            cinema = [self.cinemaList objectAtIndex:indexPath.row];
        }
    }
    
    if (self.isBindingCard) {
        USER_BINGD_CINEMAID_WRITE(cinema.cinemaId);
        self.selectCinemaForCardBlock(cinema.cinemaId,cinema.cinemaName);
    } else if (self.isOpenCard) {
        NSString *cinemaCardId = [NSString stringWithFormat:@"%d",cinemaCard.cinemaId.intValue];
        USER_OPEN_CINEMAID_WRITE(cinemaCardId);
        self.selectCinemaForCardBlock([NSString stringWithFormat:@"%d",cinemaCard.cinemaId.intValue],cinemaCard.cinemaName);
    } else {
        USER_CINEMAID_WRITE(cinema.cinemaId);
        USER_CINEMA_NAME_WRITE(cinema.cinemaName);
        USER_CINEMA_SHORT_NAME_WRITE(cinema.cinemaShortName);
        USER_CINEMA_ADDRESS_WRITE(cinema.address);
        CINEMA_LATITUDE_WRITE(cinema.lat);
        CINEMA_LONGITUDE_WRITE(cinema.lon);
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSNotification *notification = [NSNotification notificationWithName:CinemaChangeSucceededNotification
                                                                     object:self
                                                                   userInfo:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        });
        
        self.selectCinemaBlock(cinema.cinemaId);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!sectionView) {
        sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 43)];
        sectionView.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
        
        cinemaSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 7, kCommonScreenWidth, 28)];
        cinemaSearchBar.delegate = self;
        //    cinemaSearchBar.layer.cornerRadius = 14;
        //    cinemaSearchBar.layer.borderWidth = 0.5;
        //    cinemaSearchBar.layer.borderColor = [UIColor colorWithHex:@"#e0e0e0"].CGColor;
        
        //    cinemaSearchBar.barStyle = UISearchBarStyleMinimal;
        cinemaSearchBar.placeholder = @"搜索您想去的影院";
        cinemaSearchBar.contentMode = UIViewContentModeCenter;
        //    [cinemaSearchBar setTintColor:[UIColor whiteColor]];
        [cinemaSearchBar setBackgroundImage:[UIImage imageNamed:@"searchBarViewBg"]];
        [cinemaSearchBar setBackgroundColor:[UIColor colorWithHex:@"#f2f5f5"]];
        //    cinemaSearchBar.scopeBarBackgroundImage = [UIImage imageNamed:@""];
        [cinemaSearchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchbar"] forState:UIControlStateNormal];
        [sectionView addSubview:cinemaSearchBar];
        
        //    cinemaSearchFiled = [UITextField new];
        //    cinemaSearchFiled.backgroundColor = [UIColor clearColor];
        //    cinemaSearchFiled.placeholder = @"搜索您想去的影院";
        //    [searchBarBackView addSubview:cinemaSearchFiled];
        //    cinemaSearchFiled.delegate = self;
        //    cinemaSearchFiled.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        //    cinemaSearchFiled.font = [UIFont systemFontOfSize:14];
        //    [cinemaSearchFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(@(46));
        //        make.top.equalTo(@(5));
        //        make.width.equalTo(@(kCommonScreenWidth-90));
        //        make.height.equalTo(@(18));
        //    }];
        //    UILabel *sectionLabel = [UILabel new];
        //    sectionLabel.text = @"指点未来影院";
        //    sectionLabel.backgroundColor = [UIColor clearColor];
        //    sectionLabel.textColor = [UIColor colorWithHex:@"000000"];
        //    sectionLabel.font = [UIFont systemFontOfSize:14];
        //    [sectionView addSubview:sectionLabel];
        //    [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(yellowView.mas_right).offset(5);
        //        make.top.equalTo(@(15));
        //        make.width.equalTo(@(150));
        //        make.height.equalTo(@(14));
        //    }];
        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [sectionView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(sectionView);
            make.top.equalTo(sectionView.mas_bottom).offset(-0.5);
            make.height.equalTo(@(0.5));
        }];
        

    }
    if (isResignField) {
        [cinemaSearchBar becomeFirstResponder];
    }

    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 43;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [cinemaSearchBar resignFirstResponder];
}



/**
 *  结束刷新
 */
- (void)endRefreshing {
    if ([cinemaTableView.mj_header isRefreshing]) {
        [cinemaTableView.mj_header endRefreshing];
    }
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
    [self refreshCinemaSearchList:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
}

- (void)refreshCinemaSearchList:(NSString *)searchTextString{
    [self.searchCinemaList removeAllObjects];
    //筛选影院名中含关键字的影院
    [self.cinemaList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CardCinema *cinemaCard = nil;
        Cinema *cinema = nil;
        if (self.isOpenCard) {
            cinemaCard = obj;
            if ([cinemaCard.cinemaName rangeOfString:searchTextString options:NSCaseInsensitiveSearch].location != NSNotFound) {
                DLog(@"cinemaName==%@", cinemaCard.cinemaName);
                [self.searchCinemaList addObject:cinemaCard];
            }
        } else {
            cinema = obj;
            if ([cinema.cinemaName rangeOfString:searchTextString options:NSCaseInsensitiveSearch].location != NSNotFound) {
                DLog(@"cinemaName==%@", cinema.cinemaName);
                [self.searchCinemaList addObject:cinema];
            }
        }
        
        
    }];
    
    DLog(@"filtered == %ld", self.searchCinemaList.count);
    isResignField = YES;

    [cinemaTableView reloadData];
    
}

@end
