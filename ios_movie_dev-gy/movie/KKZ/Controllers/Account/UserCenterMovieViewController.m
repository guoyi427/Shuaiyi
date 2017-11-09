//
//  UserCenterMovieViewController.m
//  KoMovie
//
//  Created by kokozu on 26/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserCenterMovieViewController.h"

//  View
#import "UserCenterMovieCell.h"
#import "MJRefresh.h"
#import "ZYMovieListCell.h"

//  Request
#import "MovieRequest.h"

#import "KKZUtility.h"

@interface UserCenterMovieViewController () <UITableViewDelegate, UITableViewDataSource>
{
    
    //  UI
    UITableView *_tableView;
    
    //  Data
    NSMutableArray *_modelList;
    
}
@end

static NSString *UserCenterMovieCellIdentifier = @"userMovieCell";
static NSString *UserCenterMovieCell2Identifier = @"userMovieCell2";

@implementation UserCenterMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _modelList = [[NSMutableArray alloc] init];
    self.kkzTitleLabel.text = _type == UserCenterMovieType_WantSee ? @"想看列表" : @"评分列表";
    
    [self prepareTableView];
    
    [self loadMovieList];
}

- (void)prepareTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kAppScreenWidth, CGRectGetHeight(self.view.frame) - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UserCenterMovieCell class] forCellReuseIdentifier:UserCenterMovieCellIdentifier];
    [_tableView registerClass:[ZYMovieListCell class] forCellReuseIdentifier:UserCenterMovieCell2Identifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        [weakSelf loadMovieList];
    }];
}

- (BOOL)showBackButton {
    return true;
}

- (BOOL)showTitleBar {
    return true;
}

#pragma mark - Network Request

- (void)loadMovieList {
    MovieRequest *request = [[MovieRequest alloc] init];
    if (_type == UserCenterMovieType_Score) {
        [request requestScoreList:^(NSArray * _Nullable movieList) {
            [_tableView headerEndRefreshing];
            [_modelList removeAllObjects];
            [_modelList addObjectsFromArray:movieList];
            [_tableView reloadData];
        } failure:^(NSError * _Nullable err) {
            [_tableView headerEndRefreshing];
        }];
    } else {
        [request requestWantList:^(NSArray * _Nullable movieList) {
            [_tableView headerEndRefreshing];
            [_modelList removeAllObjects];
            [_modelList addObjectsFromArray:movieList];
            [_tableView reloadData];
        } failure:^(NSError * _Nullable err) {
            [_tableView headerEndRefreshing];
        }];
    }
}


#pragma mark - UITableView - Delegate & Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _type == UserCenterMovieType_Score ? 135 : 173;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *r_cell = nil;
    if (_type == UserCenterMovieType_Score) {
        UserCenterMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCenterMovieCellIdentifier];
        if (_modelList.count > indexPath.row) {
            NSDictionary *model = _modelList[indexPath.row];
            [cell updateModel:model isScore:true];
        }
        r_cell = cell;
    } else {
        ZYMovieListCell *f_cell = (ZYMovieListCell *)[tableView dequeueReusableCellWithIdentifier:UserCenterMovieCell2Identifier];
        if (_modelList.count > indexPath.row) {
            Movie *model = [[Movie alloc] init];
            NSDictionary *dic = _modelList[indexPath.row][@"movie"];
            model.publishTime = [[DateEngine sharedDateEngine] dateFromString:dic[@"publishTime"] withFormat:@"yyyy-MM-dd"];
            model.pathVerticalS = dic[@"pathVerticalS"];
            model.movieName = dic[@"movieName"];
            model.movieDirector = dic[@"director"];
            model.actor = dic[@"actor"];
            model.movieType = dic[@"movieType"];
            [f_cell update:model type:ZYMovieListCellType_Future];
        }
        r_cell = f_cell;
    }
    
    return r_cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
