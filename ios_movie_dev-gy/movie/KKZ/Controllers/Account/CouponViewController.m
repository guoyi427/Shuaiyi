//
//  CouponViewController.m
//  KoMovie
//
//  Created by kokozu on 27/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CouponViewController.h"

//  View
#import "CouponCell.h"
#import "CouponRedeemCell.h"

//  Request
#import "MovieRequest.h"

@interface CouponViewController () <UITableViewDelegate, UITableViewDataSource>
{
    //  UI
    UITableView *_tableView;
    
    //  Data
    NSMutableArray *_modelList;
}
@end

static NSString *CouponCellId = @"couponcell";
static NSString *RedeemCellId = @"redeemcell";

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _modelList = [[NSMutableArray alloc] init];
    
    if (_type == CouponType_coupon) {
        self.kkzTitleLabel.text = @"优惠券";
    } else if (_type == CouponType_Redeem) {
        self.kkzTitleLabel.text = @"兑换码";
    } else {
        self.kkzTitleLabel.text = @"储蓄卡";
    }
    
    [self prepareTableView];
    
    [self loadCouponList];
    
}

- (void)prepareTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kAppScreenWidth, CGRectGetHeight(self.view.frame) - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[CouponCell class] forCellReuseIdentifier:CouponCellId];
    [_tableView registerClass:[CouponRedeemCell class] forCellReuseIdentifier:RedeemCellId];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        [weakSelf loadCouponList];
    }];
}

- (BOOL)showBackButton {
    return true;
}

- (BOOL)showTitleBar {
    return true;
}

- (void)loadCouponList {
    MovieRequest *request = [[MovieRequest alloc] init];
    [request queryCouponListWithGroupId:_type success:^(NSArray * _Nullable couponList) {
        [_tableView headerEndRefreshing];
        [_modelList removeAllObjects];
        [_modelList addObjectsFromArray:couponList];
        [_tableView reloadData];
    } failure:^(NSError * _Nullable err) {
        [_tableView headerEndRefreshing];
    }];
}

#pragma mark - UITableView - Delegate & Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tempCell = nil;
    if (_type == CouponType_coupon) {
        CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:CouponCellId];
        if (_modelList.count > indexPath.row) {
            NSDictionary *dic = _modelList[indexPath.row];
            [cell updateName:dic[@"info"][@"name"] time:dic[@"expireDate"] price:dic[@"info"][@"price"] canBuy:dic[@"remainCount"]];
        }
        tempCell = cell;
    } else if (_type == CouponType_Redeem) {
        CouponRedeemCell *cell = [tableView dequeueReusableCellWithIdentifier:RedeemCellId];
        if (_modelList.count > indexPath.row) {
            NSDictionary *dic = _modelList[indexPath.row];
            [cell updateWithDic:dic];
        }
        tempCell = cell;
    } else {
        CouponRedeemCell *cell = [tableView dequeueReusableCellWithIdentifier:RedeemCellId];
        if (_modelList.count > indexPath.row) {
            NSDictionary *dic = _modelList[indexPath.row];
            [cell updateCardWithDic:dic];
        }
        tempCell = cell;
    }
    
    return tempCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
