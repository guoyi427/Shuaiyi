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

//  Request
#import "MovieRequest.h"

@interface UserCenterMovieViewController () <UITableViewDelegate, UITableViewDataSource>
{
    
    //  UI
    UITableView *_tableView;
    
    //  Data
    NSMutableArray *_modelList;
    
}
@end

static NSString *UserCenterMovieCellIdentifier = @"userMovieCell";

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
    return 135;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCenterMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCenterMovieCellIdentifier];
    if (_modelList.count > indexPath.row) {
        NSDictionary *model = _modelList[indexPath.row];
        [cell updateModel:model isScore:_type == UserCenterMovieType_Score];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
