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
#import "PayTask.h"

@interface CouponViewController () <UITableViewDelegate, UITableViewDataSource>
{
    //  UI
    UITableView *_tableView;
    UIView *_bindView;
    UITextField *_couponCodeTextField;
    UITextField *_cardPasswordTextField;
    
    //  Data
    NSMutableArray *_modelList;
    NSString *_couponString;
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
    
    if (_comefromPay) {
        UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBarButton.frame = CGRectMake(screentWith-44, 0, 44, 44);
        [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBarButton setTitle:@"绑定" forState:UIControlStateNormal];
        rightBarButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightBarButton addTarget:self action:@selector(commonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navBarView addSubview:rightBarButton];
    }
    
    [self prepareBindView];
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

- (void)prepareBindView {
    if (!_comefromPay) {
        return;
    }
    _bindView = [[UIView alloc] initWithFrame:CGRectMake(50, 150, kAppScreenWidth-100, 160)];
    _bindView.backgroundColor = appDelegate.kkzLine;
    _bindView.layer.cornerRadius = 5.0;
    _bindView.layer.masksToBounds = true;
    _bindView.hidden = true;
    [self.view addSubview:_bindView];
    
    _couponCodeTextField = [[UITextField alloc] init];
    _couponCodeTextField.backgroundColor = [UIColor whiteColor];
    _couponCodeTextField.textColor = appDelegate.kkzTextColor;
    _couponCodeTextField.font = [UIFont systemFontOfSize:14];
    _couponCodeTextField.placeholder = @"请输入券码";
    [_bindView addSubview:_couponCodeTextField];
    [_couponCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(25);
        make.height.mas_equalTo(30);
    }];
    
    if (_type == CouponType_Stored) {
        _cardPasswordTextField = [[UITextField alloc] init];
        _cardPasswordTextField.backgroundColor = _couponCodeTextField.backgroundColor;
        _cardPasswordTextField.textColor = appDelegate.kkzTextColor;
        _cardPasswordTextField.font = [UIFont systemFontOfSize:14];
        _cardPasswordTextField.placeholder = @"请输入券码";
        [_bindView addSubview:_cardPasswordTextField];
        [_cardPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_couponCodeTextField);
            make.right.equalTo(_couponCodeTextField);
            make.top.equalTo(_couponCodeTextField.mas_bottom).offset(10);
            make.height.equalTo(_couponCodeTextField);
        }];
    }
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.backgroundColor = _couponCodeTextField.backgroundColor;
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:appDelegate.kkzTextColor forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [doneButton addTarget:self action:@selector(bindViewButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_bindView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_couponCodeTextField);
        make.bottom.equalTo(_bindView).offset(-20);
        make.height.mas_equalTo(40);
    }];
}

- (void)cancelViewController {
    //  找出选中的coupon
    NSMutableArray *selectedList = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in _modelList) {
        if ([dic[CellSelectedKey] boolValue]) {
            [selectedList addObject:dic];
        }
    }
    
    if (selectedList.count > 0 &&
        _delegate &&
        [_delegate respondsToSelector:@selector(couponViewController:didSelectedCouponList:type:)]) {
        [_delegate couponViewController:self didSelectedCouponList:selectedList type:_type];
    }
    [self popViewControllerAnimated:YES];
}

- (BOOL)showBackButton {
    return true;
}

- (BOOL)showTitleBar {
    return true;
}

#pragma mark - UIButton - Actoin

/// 绑定券按钮
- (void)commonBtnClick:(UIButton *)sender {
    _bindView.hidden = false;
}

- (void)bindViewButtonAction {
    
    if (_couponCodeTextField.text.length == 0) {
        return;
    }
    
    _bindView.hidden = true;
    
    PayTask *task = [[PayTask alloc] initBindingCouponforUser:[_couponCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                                      groupId:[NSString stringWithFormat:@"%lu", _type]
                                                     password:_cardPasswordTextField.text
                                                     finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                         NSLog(@"%@", userInfo);
                                                         if (succeeded) {
                                                             [self loadCouponList];
                                                             [UIAlertView showAlertView:@"绑定完成" buttonText:@"确定"];
                                                         } else {
                                                             [UIAlertView showAlertView:@"绑定失败，请重试" buttonText:@"确定"];
                                                         }
                                                         [appDelegate hideIndicator];
                                                     }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        [appDelegate showIndicatorWithTitle:@"请稍候..." animated:YES fullScreen:NO overKeyboard:NO andAutoHide:NO];
    }
}

#pragma mark - Network - Request
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
            [cell updateWithDic:dic comefromPay:_comefromPay];
        }
        tempCell = cell;
    } else if (_type == CouponType_Redeem) {
        CouponRedeemCell *cell = [tableView dequeueReusableCellWithIdentifier:RedeemCellId];
        if (_modelList.count > indexPath.row) {
            NSDictionary *dic = _modelList[indexPath.row];
            [cell updateWithDic:dic comefromPay:_comefromPay];
        }
        tempCell = cell;
    } else {
        CouponRedeemCell *cell = [tableView dequeueReusableCellWithIdentifier:RedeemCellId];
        if (_modelList.count > indexPath.row) {
            NSDictionary *dic = _modelList[indexPath.row];
            [cell updateCardWithDic:dic comfromPay:_comefromPay];
        }
        tempCell = cell;
    }
    
    return tempCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_modelList.count > indexPath.row) {
        NSMutableDictionary *model = [NSMutableDictionary dictionaryWithDictionary: _modelList[indexPath.row]];
        if ([model[CellSelectedKey] boolValue]) {
            [model setObject:@false forKey:CellSelectedKey];
        } else {
            [model setObject:@true forKey:CellSelectedKey];
        }
        [_modelList replaceObjectAtIndex:indexPath.row withObject:model];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        if (_type == CouponType_Stored) {
            [self cancelViewController];
        }
    }
}

@end
