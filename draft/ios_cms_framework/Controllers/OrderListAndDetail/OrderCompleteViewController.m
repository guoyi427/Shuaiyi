//
//  OrderCompleteViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderCompleteViewController.h"
#import "OrderCompleteViewCell.h"
#import "MovieProductOrderDetailViewController.h"
#import "MovieOrderDetailViewController.h"
#import "VipCardOrderDetailViewController.h"
#import "ProductOrderViewController.h"
#import "OrderRequest.h"
#import "OrderListData.h"
#import "OrderListRecord.h"
#import "OrderListOfMovie.h"
#import "OrderDetailOfMovie.h"
#import "UserDefault.h"
#import "OrderDetailViewController.h"
#import "CIASActivityIndicatorView.h"
#import "TicketWaitingViewController.h"
#import "KKZTextUtility.h"

@interface OrderCompleteViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int pageNum;
}
@property (nonatomic, strong) UITableView *tableViewOfComplete;
@property (nonatomic, strong) UIView *noOrderListAlertViewOfComplete;
@property (nonatomic, strong) UIButton *gotoBuyTicketBtnOfComplete;

@property (nonatomic, strong) NSMutableArray *orderCompleteCountList;
@property (nonatomic, strong) NSMutableArray *orderCompleteMovieList;
@property (nonatomic, strong) NSMutableArray *orderCompleteMovieProductList;
@property (nonatomic, strong) OrderListRecord *orderCompleteRecord;


@end

@implementation OrderCompleteViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TaskTypeOrderChooseNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    pageNum = 1;
    #if K_HUACHEN || K_HENGDIAN
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [self requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [self requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            [self requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@"4,5"];
        }
    #else
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [self requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [self requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            
        }else if ([[_orderSelectedArr objectAtIndex:3] intValue] == 1) {
            [self requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@"4,5"];
        }
    #endif
    
}

- (void) requestOrderCompleteListWithPage:(int) page withPageSize:(int)pageSize withOrderListType:(NSString *)orderListType {
    OrderRequest *orderRequest = [[OrderRequest alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:[NSString stringWithFormat:@"%d", page] forKey:@"currentpage"];
    [params setValue:[NSString stringWithFormat:@"%d", pageSize] forKey:@"maxresults"];
    [params setValue:orderListType forKey:@"orderTypeList"];
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    [orderRequest requestOrderCompleteParams:params success:^(NSDictionary *_Nullable data) {
        if (page==1) {
            [weakSelf endRefreshing];
            if (weakSelf.orderCompleteCountList.count > 0) {
                [weakSelf.orderCompleteCountList removeAllObjects];
            }
        }else{
            [weakSelf endLoadMore];
        }
       
        //        DLog(@"%@", data);
        OrderListData *orderlistDt = (OrderListData *)data;
        [weakSelf.orderCompleteCountList addObjectsFromArray:orderlistDt.records];
        if (weakSelf.orderCompleteCountList.count > 0) {
            if (weakSelf.noOrderListAlertViewOfComplete.superview) {
                [weakSelf.noOrderListAlertViewOfComplete removeFromSuperview];
            }
            weakSelf.gotoBuyTicketBtnOfComplete.hidden = YES;
            _tableViewOfComplete.mj_footer.state = MJRefreshStateIdle;
            if (page==1) {
                [_tableViewOfComplete setContentOffset:CGPointZero];
            }
            
        }else{
            //没有更多
            [_tableViewOfComplete.mj_footer endRefreshingWithNoMoreData];
            if (weakSelf.noOrderListAlertViewOfComplete.superview) {
            }else{
                [weakSelf.tableViewOfComplete addSubview:weakSelf.noOrderListAlertViewOfComplete];
            }
            weakSelf.gotoBuyTicketBtnOfComplete.hidden = NO;
        }
        
        [weakSelf.tableViewOfComplete reloadData];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        if (page == 1) {
            [weakSelf endRefreshing];
        } else {
            [weakSelf endLoadMore];
        }
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

//MARK: 选择订单类型成功
- (void)orderChooseSuccessInCompleteView:(NSNotification *)notification {
    NSDictionary *dic = [notification userInfo];
    self.orderSelectedArr = [dic objectForKey:@"btnSelectArr"];
    pageNum = 1;
    #if K_HUACHEN || K_HENGDIAN
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [self requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [self requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            [self requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@"4,5"];
        }
    #else
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [self requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [self requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            
        }else if ([[_orderSelectedArr objectAtIndex:3] intValue] == 1) {
            [self requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@"4,5"];
        }
    #endif
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderChooseSuccessInCompleteView:) name:TaskTypeOrderChooseNotification object:nil];
    
    
    
    self.tableViewOfComplete = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight-64-35) style:UITableViewStylePlain];
    self.tableViewOfComplete.showsVerticalScrollIndicator = NO;
    //    self.tableViewOfComplete.contentInset = UIEdgeInsetsMake(104, 0, 49, 0);
    //    self.tableViewOfComplete.scrollIndicatorInsets = self.tableViewOfComplete.contentInset;
    self.tableViewOfComplete.backgroundColor = [UIColor whiteColor];
    self.tableViewOfComplete.delegate = self;
    self.tableViewOfComplete.dataSource = self;
    self.tableViewOfComplete.decelerationRate = 0.1;
    self.tableViewOfComplete.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableViewOfComplete];
    __weak __typeof(self) weakSelf = self;
    self.tableViewOfComplete.mj_header = [CPRefreshHeader headerWithRefreshingBlock:^{
        //刷新页面
        pageNum = 1;
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [weakSelf requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [weakSelf requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            
        }else if ([[_orderSelectedArr objectAtIndex:3] intValue] == 1) {
            [weakSelf requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@"4,5"];
        }
    }];
    self.tableViewOfComplete.mj_footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        if ([_tableViewOfComplete.mj_header isRefreshing]) {
            [_tableViewOfComplete.mj_footer endRefreshing];
            return;
        }
        //刷新页面
        pageNum++;
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [weakSelf requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [weakSelf requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            
        }else if ([[_orderSelectedArr objectAtIndex:3] intValue] == 1) {
            [weakSelf requestOrderCompleteListWithPage:pageNum withPageSize:50 withOrderListType:@"4,5"];
        }
    }];
    //    106/375.0 = 0.283  185/667.0 = 0.277
    UIImage *noOrderAlertImage = [UIImage imageNamed:@"empty"];
    NSString *noOrderAlertStr = @"还没有已完成订单";
    CGSize noOrderAlertStrSize = [KKZTextUtility measureText:noOrderAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15]];
    self.noOrderListAlertViewOfComplete = [[UIView alloc] initWithFrame:CGRectMake(0.283*kCommonScreenWidth, 0.277*kCommonScreenHeight, noOrderAlertImage.size.width, noOrderAlertStrSize.height+noOrderAlertImage.size.height+15)];
    UIImageView *noOrderAlertImageView = [[UIImageView alloc] init];
    [self.noOrderListAlertViewOfComplete addSubview:noOrderAlertImageView];
    noOrderAlertImageView.image = noOrderAlertImage;
    noOrderAlertImageView.contentMode = UIViewContentModeScaleAspectFill;
    [noOrderAlertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.noOrderListAlertViewOfComplete);
        make.height.equalTo(@(noOrderAlertImage.size.height));
    }];
    UILabel *noOrderAlertLabel = [[UILabel alloc] init];
    [self.noOrderListAlertViewOfComplete addSubview:noOrderAlertLabel];
    noOrderAlertLabel.text = noOrderAlertStr;
    noOrderAlertLabel.font = [UIFont systemFontOfSize:15];
    noOrderAlertLabel.textAlignment = NSTextAlignmentCenter;
    noOrderAlertLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    [noOrderAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.noOrderListAlertViewOfComplete);
        make.top.equalTo(noOrderAlertImageView.mas_bottom).offset(15);
        make.height.equalTo(@(noOrderAlertStrSize.height));
    }];
    
    self.gotoBuyTicketBtnOfComplete = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gotoBuyTicketBtnOfComplete setTitle:@"马上购票" forState:UIControlStateNormal];
    self.gotoBuyTicketBtnOfComplete.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    [self.gotoBuyTicketBtnOfComplete setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
    self.gotoBuyTicketBtnOfComplete.titleLabel.font = [UIFont systemFontOfSize:16];
    self.gotoBuyTicketBtnOfComplete.hidden = YES;
    [self.view addSubview:self.gotoBuyTicketBtnOfComplete];
    self.gotoBuyTicketBtnOfComplete.frame = CGRectMake(15, kCommonScreenHeight-64-35-65, kCommonScreenWidth - 30, 50);
    //    [self.gotoBuyTicketBtnOfNeedsPay mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.view.mas_left).offset(15);
    //        make.right.equalTo(self.view.mas_right).offset(-15);
    //        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
    //        make.height.equalTo(@50);
    //    }];
    [self.gotoBuyTicketBtnOfComplete addTarget:self action:@selector(gotoBuyTicketBtnClickForComplete:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  结束刷新
 */
- (void)endRefreshing {
    if ([self.tableViewOfComplete.mj_header isRefreshing]) {
        [self.tableViewOfComplete.mj_header endRefreshing];
    }
}
/**
 *  结束加载更多
 */
- (void)endLoadMore {
    
    if ([self.tableViewOfComplete.mj_footer isRefreshing]) {
        [self.tableViewOfComplete.mj_footer endRefreshing];
    }
    
}

- (void)gotoBuyTicketBtnClickForComplete:(id)sender {
    
    
    #if kIsHuaChenTmpTabbarStyle
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:0];
    #endif
    
    #if kIsSingleCinemaTabbarStyle
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:0];
    #endif
    
    #if kIsXinchengTmpTabbarStyle
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:0];
    #endif
    
    if ([kIsXinchengTabbarStyle isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:2];
    }
    if ([kIsCMSStandardTabbarStyle isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:1];
    }
    
}

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"OrderCompleteViewCell";
    OrderCompleteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[OrderCompleteViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (self.orderCompleteMovieProductList.count > 0) {
        [self.orderCompleteMovieProductList removeAllObjects];
    }
    
    self.orderCompleteRecord = (OrderListRecord *)[self.orderCompleteCountList objectAtIndex:indexPath.row];
    if (self.orderCompleteRecord.orderDetailList.count > 0) {
        [self.orderCompleteMovieProductList addObjectsFromArray:self.orderCompleteRecord.orderDetailList];
        cell.orderMovieProductList = self.orderCompleteMovieProductList;
    }
    
    cell.orderListRecordData = self.orderCompleteRecord;
    [cell updateLayout];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.orderCompleteCountList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.orderCompleteRecord = (OrderListRecord *)[self.orderCompleteCountList objectAtIndex:indexPath.row];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:0];
    if (self.orderCompleteRecord.orderDetailList.count > 0) {
        [tmpArr addObjectsFromArray:self.orderCompleteRecord.orderDetailList];
    }
    OrderListOfMovie *orderlistMe = [[OrderListOfMovie alloc] init];
    NSMutableArray *tmpMovieArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tmpProductArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < tmpArr.count; i++) {
        orderlistMe = [tmpArr objectAtIndex:i];
        if (orderlistMe.goodsType == 1) {
            //电影票的
            [tmpMovieArr1 addObject:[tmpArr objectAtIndex:i]];
        } else if(orderlistMe.goodsType == 3) {
            //卖品的
            [tmpProductArr1 addObject:[tmpArr objectAtIndex:i]];
        }
    }
    DLog(@"卖品数量:%ld", tmpProductArr1.count);
    if (tmpProductArr1.count > 0) {
        return 174+5;
    } else {
        return 132+5;//132+5
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.orderCompleteRecord = (OrderListRecord *)[self.orderCompleteCountList objectAtIndex:indexPath.row];
    
    OrderRequest *orderRequest = [[OrderRequest alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:self.orderCompleteRecord.orderCode forKey:@"orderCode"];
    [params setValue:self.orderCompleteRecord.tenantId forKey:@"tenantId"];
    
    if (self.orderCompleteRecord.orderType == 3) {
        //影票的
        //请求详情数据，成功后跳转，否则报错，不跳转
        
        [[UIConstants sharedDataEngine] loadingAnimation];
        __weak __typeof(self) weakSelf = self;
        [orderRequest requestOrderDetailFromListParams:params success:^(NSDictionary *_Nullable data) {
            OrderDetailOfMovie *order = (OrderDetailOfMovie *)data;
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            
            NSComparisonResult result; //是否过期
            NSDate *planBeginTime = [NSDate dateWithTimeIntervalSince1970:[order.orderTicket.planBeginTime longLongValue]/1000];
            
            result= [planBeginTime compare:[NSDate date]];
            if (result == NSOrderedDescending) {
                OrderDetailViewController *mpVC = [[OrderDetailViewController alloc] init];
                mpVC.orderNo = order.orderTicket.fkOrderCode;
                [weakSelf.navigationController pushViewController:mpVC animated:YES];
            }else{
                MovieProductOrderDetailViewController *mpVC = [[MovieProductOrderDetailViewController alloc] init];
                mpVC.orderDetailOfMovie = (OrderDetailOfMovie *)data;
                [weakSelf.navigationController pushViewController:mpVC animated:YES];
            }
            
            DLog(@"detailData:%@", data);
            
        } failure:^(NSError * _Nullable err) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            NSDictionary *userInfo = [err userInfo];
            NSDictionary *errInfo = [userInfo kkz_objForKey:@"kkz.error.response"];
            NSString *errStr = [errInfo kkz_stringForKey:@"error"];
            if (errStr.length == 0) {
                errStr = @"请尝试刷新";
            }
            NSDate *updateTime = USER_EXPIRE_ALERT;
            if (!updateTime || [updateTime timeIntervalSinceNow] < -2) {
                [[CIASAlertCancleView new] show:@"温馨提示" message:errStr cancleTitle:@"知道了" callback:^(BOOL confirm) {
                }];
                USER_EXPIRE_ALERT_WRITE([NSDate date]);
            }
            
        }];
    } else if (self.orderCompleteRecord.orderType == 4 || self.orderCompleteRecord.orderType == 5) {
        //开卡充值的
        //请求详情数据，成功后跳转，否则报错，不跳转
        
        [[UIConstants sharedDataEngine] loadingAnimation];
        __weak __typeof(self) weakSelf = self;
        [orderRequest requestCardOrderDetailFromListParams:params success:^(NSDictionary *_Nullable data) {
            OrderDetailOfMovie *order = (OrderDetailOfMovie *)data;
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            
            //开卡充值订单详情
            VipCardOrderDetailViewController *mpVC = [[VipCardOrderDetailViewController alloc] init];
            mpVC.orderDetailOfMovie = (OrderDetailOfMovie *)data;
            
            [weakSelf.navigationController pushViewController:mpVC animated:YES];
            DLog(@"detailData:%@", data);
            
        } failure:^(NSError * _Nullable err) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            NSDictionary *userInfo = [err userInfo];
            NSDictionary *errInfo = [userInfo kkz_objForKey:@"kkz.error.response"];
            NSString *errStr = [errInfo kkz_stringForKey:@"error"];
            if (errStr.length == 0) {
                errStr = @"请尝试刷新";
            }
            NSDate *updateTime = USER_EXPIRE_ALERT;
            if (!updateTime || [updateTime timeIntervalSinceNow] < -2) {
                [[CIASAlertCancleView new] show:@"温馨提示" message:errStr cancleTitle:@"知道了" callback:^(BOOL confirm) {
                }];
                USER_EXPIRE_ALERT_WRITE([NSDate date]);
            }
            
        }];
        
    }
    //    if (indexPath.row == 0) {
    
    
    //    } else if (indexPath.row == 1) {
    //        MovieOrderDetailViewController *mVC = [[MovieOrderDetailViewController alloc] init];
    //        [self.navigationController pushViewController:mVC animated:YES];
    //
    //    } else if (indexPath.row == 2) {
    //        ProductOrderViewController *pVC = [[ProductOrderViewController alloc] init];
    //        [self.navigationController pushViewController:pVC animated:YES];
    //    }else if (indexPath.row == 3) {
    //        VipCardOrderDetailViewController *vipVC = [[VipCardOrderDetailViewController alloc] init];
    //        [self.navigationController pushViewController:vipVC animated:YES];
    //    }
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSMutableArray *)orderCompleteMovieList {
    if (!_orderCompleteMovieList) {
        _orderCompleteMovieList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _orderCompleteMovieList;
}
- (NSMutableArray *)orderCompleteCountList {
    if (!_orderCompleteCountList) {
        _orderCompleteCountList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _orderCompleteCountList;
}
- (NSMutableArray *)orderCompleteMovieProductList {
    if (!_orderCompleteMovieProductList) {
        _orderCompleteMovieProductList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _orderCompleteMovieProductList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
