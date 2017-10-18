//
//  MovieCinemaChildViewController.m
//  CIASMovie
//
//  Created by cias on 2017/2/6.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "MovieCinemaChildViewController.h"
#import "CinemaRequest.h"
#import "Cinema.h"
#import "PlanListViewController.h"
#import "MovieRequest.h"
#import "Movie.h"
#import "UIViewController+SFTrainsitionExtension.h"
#import "UserDefault.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ProductRequest.h"
#import "ProductListDetail.h"
#import "XingYiPlanListViewController.h"

@interface MovieCinemaChildViewController ()
{
    BOOL isResignField;
}
@end

@implementation MovieCinemaChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.hideNavigationBar = YES;
    _cinemaList = [[NSMutableArray alloc] initWithCapacity:0];//影院列表
    _cinemaMovieList = [[NSMutableArray alloc] initWithCapacity:0];//某个影院支持的电影列表
    _searchCinemaList = [[NSMutableArray alloc] initWithCapacity:0];//搜索筛选出来的影院列表
    self.selectCinemaRow = 0;//初始化选中的影院
    [self setCinemaUI];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestProductList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [cinemaSearchBar resignFirstResponder];
    
}

- (void)textFieldResignFirstResponder{
    [cinemaSearchBar resignFirstResponder];
}

- (void)setCinemaUI{
    
    cinemaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kCommonScreenWidth, kCommonScreenHeight-64-49) style:UITableViewStylePlain];
    cinemaTableView.delegate = self;
    cinemaTableView.dataSource = self;
    cinemaTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:cinemaTableView];
    cinemaTableView.showsVerticalScrollIndicator = NO;
    [cinemaTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    __weak __typeof(self) weakSelf = self;
    cinemaTableView.mj_header = [CPRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.selectCinemaRow = 0;//初始化选中的影院
        [weakSelf.cinemaMovieList removeAllObjects];
        [weakSelf requestCinemaList];
    }];
    cinemaTableView.mj_footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf endLoadMore];
    }];
    
}


- (void)requestCinemaMovieList:(NSString *)cinemaId {
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    MovieRequest *request = [[MovieRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *paramDict = @{@"cinemaId":cinemaId};
    [request requestCinemaMovieListParams:paramDict success:^(NSArray * _Nullable movies) {
        [weakSelf.cinemaMovieList removeAllObjects];

        if (movies.count) {
            
            [weakSelf.cinemaMovieList addObjectsFromArray:movies];
            
        }
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        //主线程刷新，防止闪烁
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cinemaTableView reloadData];
        });

    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];

    }];
    
}

- (void)requestCinemaList{
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
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
    CinemaRequest *request = [[CinemaRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [request requestCinemaListParams:params success:^(NSArray * _Nullable data) {
        [weakSelf endRefreshing];
        
        [weakSelf.cinemaList removeAllObjects];
        [weakSelf.cinemaList addObjectsFromArray:data];
        if (self.cinemaList.count>0) {
            if (self.selectCinemaRow>=0) {
                Cinema *acinema = [self.cinemaList objectAtIndex:self.selectCinemaRow];
                [self requestCinemaMovieList:acinema.cinemaId];
            }
        }else{
            self.selectCinemaRow = -1;
            [self.cinemaMovieList removeAllObjects];
        }
        [cinemaTableView setContentOffset:CGPointZero];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [cinemaTableView reloadData];

        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
        });

    } failure:^(NSError * _Nullable err) {
        [weakSelf endRefreshing];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
    
}

- (void)requestProductList{
    ProductRequest *requtest = [[ProductRequest alloc] init];
    [requtest requestProductListParams:nil success:^(NSDictionary * _Nullable data) {
//        ProductListDetail *detail = (ProductListDetail *)data;
//        if (self.myProductList.count > 0) {
//            [self.myProductList removeAllObjects];
//        }
//        
//        [self.myProductList addObjectsFromArray:detail.list];
//        
//        [payTableView reloadData];
        
    } failure:^(NSError * _Nullable err) {
        
    }];
    
}



- (void)didSelectedMovieWithMovie:(Movie*)amovie andIndex:(NSInteger)indexpathRow{
    Cinema * cinema = [self.cinemaList objectAtIndex:indexpathRow];
    USER_CINEMAID_WRITE(cinema.cinemaId);
    USER_CINEMA_NAME_WRITE(cinema.cinemaName);
    USER_CINEMA_ADDRESS_WRITE(cinema.address);
    CINEMA_LATITUDE_WRITE(cinema.lat);
    CINEMA_LONGITUDE_WRITE(cinema.lon);
    [[NSUserDefaults standardUserDefaults] synchronize];


    if ([kIsXinchengPlanListStyle isEqualToString:@"1"]) {
        XingYiPlanListViewController *ctr = [[XingYiPlanListViewController alloc] init];
        ctr.movieId = amovie.movieId;
        ctr.cinemaId = cinema.cinemaId;
        Constants.isShowBackBtn = YES;
        [self.navigationController pushViewController:ctr animated:YES];
    }
    if ([kIsCMSStandardPlanListStyle isEqualToString:@"1"]) {
        PlanListViewController *ctr = [[PlanListViewController alloc] init];
        ctr.movieId = amovie.movieId;
        ctr.cinemaId = cinema.cinemaId;
        ctr.cinemaName = USER_CINEMA_NAME;
        [self.navigationController pushViewController:ctr animated:YES];
    }

}



#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CinemaHomeCell";
    Cinema *managerment = nil;
    if (self.searchCinemaList.count) {
        managerment = [self.searchCinemaList objectAtIndex:indexPath.row];
    }else{
        managerment = [self.cinemaList objectAtIndex:indexPath.row];
    }
    CinemaHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CinemaHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    cell.selectCinema = managerment;
    cell.indexRow = self.selectCinemaRow;
    if (indexPath.row == self.selectCinemaRow) {
        cell.isSelect = YES;
        cell.movieList = self.cinemaMovieList;
    }else{
        cell.isSelect = NO;
    }
#if kIsHaveTipLabelInCinemaList
//    DLog(@"购票页影院列表：%@", managerment.serviceFeatures);
    if (managerment.serviceFeatures.count > 0) {
        cell.featureArr = managerment.serviceFeatures;
    }else {
        cell.featureArr = [NSArray array];
    }
#endif
    
    [cell updateLayout];
    
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
#if kIsHaveTipLabelInCinemaList
    Cinema *managerment = nil;
    if (self.searchCinemaList.count) {
        managerment = [self.searchCinemaList objectAtIndex:indexPath.row];
    }else{
        managerment = [self.cinemaList objectAtIndex:indexPath.row];
    }
    NSString *cinemaFeatureStr = @"D BOX厅";
    CGSize cinemaFeatureStrSize = [KKZTextUtility measureText:cinemaFeatureStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
    CGFloat cellHeight = 0.0;
    if (managerment.serviceFeatures.count>0) {
        cellHeight = cinemaFeatureStrSize.height+10+7;
    } else {
        cellHeight = 0.0;
    }
    if (indexPath.row == self.selectCinemaRow) {
        if (managerment.discount.length > 0) {
            return 95+142+cellHeight;
            
        }else{
            return 66+142+cellHeight;
            
        }
    }else{
        if (managerment.discount.length > 0) {
            return 95+cellHeight;
        }else{
            return 66+cellHeight;
        }
    }
#else
    Cinema *managerment = nil;
    if (self.searchCinemaList.count) {
        managerment = [self.searchCinemaList objectAtIndex:indexPath.row];
    }else{
        managerment = [self.cinemaList objectAtIndex:indexPath.row];
    }
    
    CGFloat cellHeight = 0.0;
    
    if (indexPath.row == self.selectCinemaRow) {
        if (managerment.discount.length > 0) {
            return 95+142+cellHeight;
            
        }else{
            return 66+142+cellHeight;
            
        }
    }else{
        if (managerment.discount.length > 0) {
            return 95+cellHeight;
        }else{
            return 66+cellHeight;
        }
    }
#endif
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [cinemaSearchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == self.selectCinemaRow) {
        
    }else{
        self.selectCinemaRow = indexPath.row;
        Cinema *managerment = nil;
        if (self.searchCinemaList.count) {
            managerment = [self.searchCinemaList objectAtIndex:indexPath.row];
        }else{
            managerment = [self.cinemaList objectAtIndex:indexPath.row];
        }
        USER_CINEMAID_WRITE(managerment.cinemaId);
        USER_CINEMA_NAME_WRITE(managerment.cinemaName);
        USER_CINEMA_ADDRESS_WRITE(managerment.address);
        CINEMA_LATITUDE_WRITE(managerment.lat);
        CINEMA_LONGITUDE_WRITE(managerment.lon);

        [self requestCinemaMovieList:managerment.cinemaId];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 43;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!sectionView) {
        sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 43)];
        sectionView.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
        
        //    UIView *searchBarBackView = [UIView new];
        //    searchBarBackView.backgroundColor = [UIColor colorWithHex:@"ffffff"];
        //    [sectionView addSubview:searchBarBackView];
        //    searchBarBackView.layer.cornerRadius = 14;
        //    searchBarBackView.layer.borderWidth = 0.5;
        //    searchBarBackView.layer.borderColor = [UIColor colorWithHex:@"#e0e0e0"].CGColor;
        //    [searchBarBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.equalTo(@(15));
        //        make.top.equalTo(@(7));
        //        make.width.equalTo(@(kCommonScreenWidth-30));
        //        make.height.equalTo(@(28));
        //    }];
        
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
        
        cinemaSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 7, kCommonScreenWidth, 28)];
        cinemaSearchBar.delegate = self;
        //    cinemaSearchBar.barStyle = UISearchBarStyleMinimal;
        cinemaSearchBar.placeholder = @"搜索您想去的影院";
        //    [cinemaSearchBar setTintColor:[UIColor whiteColor]];
        [cinemaSearchBar setBackgroundImage:[UIImage imageNamed:@"searchBarViewBg"]];
        [cinemaSearchBar setBackgroundColor:[UIColor colorWithHex:@"#f2f5f5"]];
        //    cinemaSearchBar.scopeBarBackgroundImage = [UIImage imageNamed:@""];
        [cinemaSearchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchbar"] forState:UIControlStateNormal];
        [sectionView addSubview:cinemaSearchBar];
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



/**
 *  结束刷新
 */
- (void)endRefreshing {
    if ([cinemaTableView.mj_header isRefreshing]) {
        [cinemaTableView.mj_header endRefreshing];
    }
}
/**
 *  结束加载更多
 */
- (void)endLoadMore {
    [cinemaTableView.mj_footer isRefreshing];
    [cinemaTableView.mj_footer endRefreshing];
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
        Cinema *cinema = obj;
        if ([cinema.cinemaName rangeOfString:searchTextString options:NSCaseInsensitiveSearch].location != NSNotFound) {
            DLog(@"cinemaName==%@", cinema.cinemaName);
            [self.searchCinemaList addObject:cinema];
        }
    }];
    
    DLog(@"filtered == %ld", self.searchCinemaList.count);
    isResignField = YES;
    [cinemaTableView reloadData];
    
}


- (void)scrollTop{
    [cinemaTableView setContentOffset:CGPointZero];
}
@end
