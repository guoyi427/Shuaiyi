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

//  ViewController
#import "CouponBindViewController.h"

@interface CouponViewController () <UITableViewDelegate, UITableViewDataSource>
{
    //  UI
    UITableView *_tableView;
    UIButton *_doneButton;
    UILabel *_nullLabel;
    
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
        self.kkzTitleLabel.text = @"章鱼券";
    } else if (_type == CouponType_Redeem) {
        self.kkzTitleLabel.text = @"章鱼码";
    } else {
        self.kkzTitleLabel.text = @"章鱼卡";
    }
    
    [self prepareTableView];
    
    [self loadCouponList];
    
//    if (_comefromPay) {
        UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBarButton.frame = CGRectMake(screentWith-44, 0, 44, 44);
        [rightBarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBarButton setTitle:@"绑定" forState:UIControlStateNormal];
        rightBarButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightBarButton addTarget:self action:@selector(commonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navBarView addSubview:rightBarButton];
//    }
    
    if (_comefromPay) {
        [self prepareDoneButton];
    }
    
    _nullLabel = [[UILabel alloc] init];
    NSString *text = nil;
    switch (_type) {
        case CouponType_coupon:
            text = @"章鱼券";
            break;
        case CouponType_Redeem:
            text = @"章鱼券";
            break;
        case CouponType_Stored:
            text = @"章鱼卡";
            break;
        default:
            break;
    }
    _nullLabel.text = [NSString stringWithFormat:@"您还未绑定%@，去绑定 >", text];
    _nullLabel.textColor = [UIColor grayColor];
    _nullLabel.font = [UIFont systemFontOfSize:16];
    _nullLabel.hidden = true;
    _nullLabel.userInteractionEnabled = true;
    [self.view addSubview:_nullLabel];
    [_nullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    UITapGestureRecognizer *tapNullLabelGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commonBtnClick:)];
    [_nullLabel addGestureRecognizer:tapNullLabelGR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadCouponList) name:@"updateCouponList" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadCouponList];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Prepare

- (void)prepareTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kAppScreenWidth, CGRectGetHeight(self.view.frame) - 64 - 50) style:UITableViewStylePlain];
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

- (void)prepareDoneButton {
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneButton setBackgroundImage:[UIImage imageNamed:@"Pay_paybutton"] forState:UIControlStateNormal];
    [_doneButton setTitle:@"确定使用" forState:UIControlStateNormal];
    [_doneButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_doneButton];
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(45);
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
    
    if (_delegate &&
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

#pragma mark - UIButton - Action

- (void)commonBtnClick:(UIButton *)sender {
    CouponBindViewController *vc = [[CouponBindViewController alloc] init];
    vc.type = _type;
    [self.navigationController pushViewController:vc animated:true];
}

#pragma mark - Network - Request
- (void)loadCouponList {
    MovieRequest *request = [[MovieRequest alloc] init];
    [request queryCouponListWithGroupId:_type success:^(NSArray * _Nullable couponList) {
        [_tableView headerEndRefreshing];
        [_modelList removeAllObjects];
        [_modelList addObjectsFromArray:couponList];
        
        _doneButton.hidden = _modelList.count == 0;
        _nullLabel.hidden = _modelList.count != 0;
        
        //  标记已经选中的券
        if (_selectedList && _selectedList.count) {
            for (int i = 0; i < _modelList.count; i ++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_modelList[i]];
                for (NSDictionary *selectedDic in _selectedList) {
                    if ([selectedDic[@"couponId"] isEqualToString:dic[@"couponId"]]) {
                        [dic setObject:@true forKey:CellSelectedKey];
                        [_modelList replaceObjectAtIndex:i withObject:dic];
                    }
                }
            }
        }
        
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
    if (_modelList.count > indexPath.row && _comefromPay) {
        [appDelegate showIndicatorWithTitle:nil animated:true fullScreen:true overKeyboard:true andAutoHide:false];
        //  更新数据选中状态
        NSMutableDictionary *model = [NSMutableDictionary dictionaryWithDictionary: _modelList[indexPath.row]];
        if ([model[CellSelectedKey] boolValue]) {
            [model setObject:@false forKey:CellSelectedKey];
        } else {
            [model setObject:@true forKey:CellSelectedKey];
        }
        [_modelList replaceObjectAtIndex:indexPath.row withObject:model];
        
        //  找出选中的coupon
        NSMutableArray *selectedList = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in _modelList) {
            if ([dic[CellSelectedKey] boolValue]) {
                [selectedList addObject:dic];
            }
        }
        
        //  拼接已选券id
        NSMutableString *couponString = [[NSMutableString alloc] initWithString:@"["];
        for (NSDictionary *dic in selectedList) {
            if (dic[@"couponId"]) {
                [couponString appendString:[NSString stringWithFormat:@"{couponid: '%@'},", dic[@"couponId"]]];
            }
        }
        couponString = [NSMutableString stringWithString: [couponString substringToIndex:couponString.length-1]];
        [couponString appendString:@"]"];
        if (couponString.length < 2) {
            //  未选中任何券
            couponString = [[NSMutableString alloc] initWithString: @""];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            return;
        }
        //  更新价格状态
        /*
        PayTask *task = [[PayTask alloc] initCheckECard:couponString
                                               forOrder:_orderId
                                               groupbuy:nil
                                               finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                   
                                                   [appDelegate hideIndicator];
                                                   
                                                   if (succeeded) {
                                                       [_modelList replaceObjectAtIndex:indexPath.row withObject:model];
                                                       [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

                                                   } else {
                                                       if ([model[CellSelectedKey] boolValue]) {
                                                           [model setObject:@false forKey:CellSelectedKey];
                                                       } else {
                                                           [model setObject:@true forKey:CellSelectedKey];
                                                       }
                                                       [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                       [appDelegate showAlertViewForTaskInfo:userInfo];
                                                   }
                                               }];
        
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            [appDelegate showIndicatorWithTitle:@"请稍候..."
                                       animated:YES
                                     fullScreen:NO
                                   overKeyboard:NO
                                    andAutoHide:NO];
        }
        */
        MovieRequest *request = [[MovieRequest alloc] init];
        [request checkCoupon:couponString orderId:_orderId groupBuyId:nil success:^(NSDictionary * _Nullable responseDic) {
            [appDelegate hideIndicator];
            if ([responseDic[@"status"] integerValue] == 0) {
                //  success
                [_modelList replaceObjectAtIndex:indexPath.row withObject:model];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                if ([model[CellSelectedKey] boolValue]) {
                    [model setObject:@false forKey:CellSelectedKey];
                } else {
                    [model setObject:@true forKey:CellSelectedKey];
                }
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [appDelegate showAlertViewForRequestInfo:responseDic];
            }
        } failure:^(NSError * _Nullable err) {
            [appDelegate hideIndicator];
            if ([model[CellSelectedKey] boolValue]) {
                [model setObject:@false forKey:CellSelectedKey];
            } else {
                [model setObject:@true forKey:CellSelectedKey];
            }
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [appDelegate showAlertViewForRequestInfo:err.userInfo];
        }];
        
        if (_type == CouponType_Stored) {
//            [self cancelViewController];
        }
    }
}

@end
