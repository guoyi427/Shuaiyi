//
//  OrderCancelViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderCancelViewController.h"
#import "OrderCancelViewCell.h"
#import "KKZTextUtility.h"
#import "MovieProductOrderDetailViewController.h"
#import "MovieOrderDetailViewController.h"
#import "VipCardOrderDetailViewController.h"
#import "ProductOrderViewController.h"

#import "OrderRequest.h"
#import "OrderListData.h"
#import "OrderListRecord.h"
#import "OrderListOfMovie.h"
#import "OrderDetailOfMovie.h"
#import "CIASActivityIndicatorView.h"
#import "OrderConfirmViewController.h"

@interface OrderCancelViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    int pageNum;
}
@property (nonatomic, strong) UITableView *tableViewOfCancel;
@property (nonatomic, strong) UIView *noOrderListAlertViewOfCancel;
@property (nonatomic, strong) UIButton *gotoBuyTicketBtnOfCancel;

@property (nonatomic, strong) NSMutableArray *orderCancelCountList;
@property (nonatomic, strong) NSMutableArray *orderCancelMovieList;
@property (nonatomic, strong) NSMutableArray *orderCancelMovieProductList;
@property (nonatomic, strong) OrderListRecord *orderCancelRecord;
@end

@implementation OrderCancelViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TaskTypeOrderChooseNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    pageNum = 1;
    #if K_HUACHEN || K_HENGDIAN
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [self requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [self requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            [self requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@"4,5"];
        }
    #else
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [self requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [self requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            
        }else if ([[_orderSelectedArr objectAtIndex:3] intValue] == 1) {
            [self requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@"4,5"];
        }
    #endif
    
    
}

- (void) requestOrderCancelListWithPage:(int) page withPageSize:(int)pageSize withOrderListType:(NSString *)orderListType {
    OrderRequest *orderRequest = [[OrderRequest alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:[NSString stringWithFormat:@"%d", page] forKey:@"currentpage"];
    [params setValue:[NSString stringWithFormat:@"%d", pageSize] forKey:@"maxresults"];
    [params setValue:orderListType forKey:@"orderTypeList"];
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    [orderRequest requestOrderCancelParams:params success:^(NSDictionary *_Nullable data) {
        if (page==1) {
            [weakSelf endRefreshing];
            if (weakSelf.orderCancelCountList.count > 0) {
                [weakSelf.orderCancelCountList removeAllObjects];
            }
        }else{
            [weakSelf endLoadMore];
        }
       
        //        DLog(@"%@",data);
        OrderListData *orderlistCancelDt = (OrderListData *)data;
        [weakSelf.orderCancelCountList addObjectsFromArray:orderlistCancelDt.records];
        if (weakSelf.orderCancelCountList.count > 0) {
            _tableViewOfCancel.mj_footer.state = MJRefreshStateIdle;
            if (page==1) {
                [_tableViewOfCancel setContentOffset:CGPointZero];
            }
            
            if (weakSelf.noOrderListAlertViewOfCancel.superview) {
                [weakSelf.noOrderListAlertViewOfCancel removeFromSuperview];
            }
            weakSelf.gotoBuyTicketBtnOfCancel.hidden = YES;
        }else{
            //没有更多
            [_tableViewOfCancel.mj_footer endRefreshingWithNoMoreData];
            if (weakSelf.noOrderListAlertViewOfCancel.superview) {
            }else{
                [weakSelf.tableViewOfCancel addSubview:weakSelf.noOrderListAlertViewOfCancel];
            }
            weakSelf.gotoBuyTicketBtnOfCancel.hidden = NO;
        }
        //        DLog(@"orderCancelCountList%@", self.orderCancelCountList);
        //        DLog(@"orderCancelCountList.count%lu", (unsigned long)self.orderCancelCountList.count);
        
        //        [orderlistDt.records enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            DLog(@"%@",obj);
        //            OrderListRecord *orderlistRd = obj;
        //            DLog(@"receiveMoney%@", orderlistRd.receiveMoney);
        //        }];
        
        [weakSelf.tableViewOfCancel reloadData];
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

/**
 *  结束刷新
 */
- (void)endRefreshing {
    if ([self.tableViewOfCancel.mj_header isRefreshing]) {
        [self.tableViewOfCancel.mj_header endRefreshing];
    }
}
/**
 *  结束加载更多
 */
- (void)endLoadMore {

    if ([self.tableViewOfCancel.mj_footer isRefreshing]) {
        [self.tableViewOfCancel.mj_footer endRefreshing];
    }

}

//MARK: 选择订单类型成功
- (void)orderChooseSuccessInCancelView:(NSNotification *)notification {
    NSDictionary *dic = [notification userInfo];
    self.orderSelectedArr = [dic objectForKey:@"btnSelectArr"];
    pageNum = 1;
    #if K_HUACHEN || K_HENGDIAN
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [self requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [self requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            [self requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@"4,5"];
        }
    #else
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [self requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [self requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            
        }else if ([[_orderSelectedArr objectAtIndex:3] intValue] == 1) {
            [self requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@"4,5"];
        }
    #endif
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderChooseSuccessInCancelView:) name:TaskTypeOrderChooseNotification object:nil];
    
    self.tableViewOfCancel = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight-64-35) style:UITableViewStylePlain];
    self.tableViewOfCancel.showsVerticalScrollIndicator = NO;
    //    self.tableViewOfCancel.contentInset = UIEdgeInsetsMake(104, 0, 49, 0);
    //    self.tableViewOfCancel.scrollIndicatorInsets = self.tableViewOfCancel.contentInset;
    self.tableViewOfCancel.backgroundColor = [UIColor whiteColor];
    self.tableViewOfCancel.delegate = self;
    self.tableViewOfCancel.dataSource = self;
    self.tableViewOfCancel.decelerationRate = 0.1;

    self.tableViewOfCancel.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableViewOfCancel];
    __weak __typeof(self) weakSelf = self;
    self.tableViewOfCancel.mj_header = [CPRefreshHeader headerWithRefreshingBlock:^{
        //刷新页面
        pageNum = 1;
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [weakSelf requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [weakSelf requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            
        }else if ([[_orderSelectedArr objectAtIndex:3] intValue] == 1) {
            [weakSelf requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@"4,5"];
        }
    }];
    self.tableViewOfCancel.mj_footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        if ([_tableViewOfCancel.mj_header isRefreshing]) {
            [_tableViewOfCancel.mj_footer endRefreshing];
            return;
        }
        //刷新页面
        pageNum++;
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [weakSelf requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [weakSelf requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            
        }else if ([[_orderSelectedArr objectAtIndex:3] intValue] == 1) {
            [weakSelf requestOrderCancelListWithPage:pageNum withPageSize:50 withOrderListType:@"4,5"];
        }
    }];
    //    106/375.0 = 0.283  185/667.0 = 0.277
    UIImage *noOrderAlertImage = [UIImage imageNamed:@"empty"];
    NSString *noOrderAlertStr = @"还没有已取消订单";
    CGSize noOrderAlertStrSize = [KKZTextUtility measureText:noOrderAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15]];
    self.noOrderListAlertViewOfCancel = [[UIView alloc] initWithFrame:CGRectMake(0.283*kCommonScreenWidth, 0.277*kCommonScreenHeight, noOrderAlertImage.size.width, noOrderAlertStrSize.height+noOrderAlertImage.size.height+15)];
    UIImageView *noOrderAlertImageView = [[UIImageView alloc] init];
    [self.noOrderListAlertViewOfCancel addSubview:noOrderAlertImageView];
    noOrderAlertImageView.image = noOrderAlertImage;
    noOrderAlertImageView.contentMode = UIViewContentModeScaleAspectFill;
    [noOrderAlertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.noOrderListAlertViewOfCancel);
        make.height.equalTo(@(noOrderAlertImage.size.height));
    }];
    UILabel *noOrderAlertLabel = [[UILabel alloc] init];
    [self.noOrderListAlertViewOfCancel addSubview:noOrderAlertLabel];
    noOrderAlertLabel.text = noOrderAlertStr;
    noOrderAlertLabel.font = [UIFont systemFontOfSize:15];
    noOrderAlertLabel.textAlignment = NSTextAlignmentCenter;
    noOrderAlertLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    [noOrderAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.noOrderListAlertViewOfCancel);
        make.top.equalTo(noOrderAlertImageView.mas_bottom).offset(15);
        make.height.equalTo(@(noOrderAlertStrSize.height));
    }];
    
    self.gotoBuyTicketBtnOfCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gotoBuyTicketBtnOfCancel setTitle:@"马上购票" forState:UIControlStateNormal];
    self.gotoBuyTicketBtnOfCancel.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    [self.gotoBuyTicketBtnOfCancel setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
    self.gotoBuyTicketBtnOfCancel.titleLabel.font = [UIFont systemFontOfSize:16];
    self.gotoBuyTicketBtnOfCancel.hidden = YES;
    [self.view addSubview:self.gotoBuyTicketBtnOfCancel];
    self.gotoBuyTicketBtnOfCancel.frame = CGRectMake(15, kCommonScreenHeight-64-35-65, kCommonScreenWidth - 30, 50);
    //    [self.gotoBuyTicketBtnOfNeedsPay mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.view.mas_left).offset(15);
    //        make.right.equalTo(self.view.mas_right).offset(-15);
    //        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
    //        make.height.equalTo(@50);
    //    }];
    [self.gotoBuyTicketBtnOfCancel addTarget:self action:@selector(gotoBuyTicketBtnClickForCancel:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)gotoBuyTicketBtnClickForCancel:(id)sender {
    
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
    static NSString *cellID = @"OrderCancelViewCell";
    //    Cinema *managerment = [self.cinemaList objectAtIndex:indexPath.row];
    OrderCancelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[OrderCancelViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (self.orderCancelMovieProductList.count > 0) {
        [self.orderCancelMovieProductList removeAllObjects];
    }
    
    self.orderCancelRecord = (OrderListRecord *)[self.orderCancelCountList objectAtIndex:indexPath.row];
    if (self.orderCancelRecord.orderDetailList.count > 0) {
        [self.orderCancelMovieProductList addObjectsFromArray:self.orderCancelRecord.orderDetailList];
        cell.orderMovieProductCancelList = self.orderCancelMovieProductList;
    }
    
    cell.orderListRecordCancelData = self.orderCancelRecord;
    [cell updateLayout];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.orderCancelCountList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.orderCancelRecord = (OrderListRecord *)[self.orderCancelCountList objectAtIndex:indexPath.row];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:0];
    if (self.orderCancelRecord.orderDetailList.count > 0) {
        [tmpArr addObjectsFromArray:self.orderCancelRecord.orderDetailList];
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
    self.orderCancelRecord = (OrderListRecord *)[self.orderCancelCountList objectAtIndex:indexPath.row];
//    OrderConfirmViewController *ctr = [[OrderConfirmViewController alloc] init];
//    ctr.orderNo = self.orderCancelRecord.orderCode;
//    
//    [self.navigationController pushViewController:ctr animated:YES];
//
//    return;
    
    //    if (indexPath.row == 0) {
    //请求详情数据，成功后跳转，否则报错，不跳转
    OrderRequest *orderRequest = [[OrderRequest alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:self.orderCancelRecord.orderCode forKey:@"orderCode"];
    [params setValue:self.orderCancelRecord.tenantId forKey:@"tenantId"];
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    [orderRequest requestOrderDetailFromListParams:params success:^(NSDictionary *_Nullable data) {
        if (self.orderCancelRecord.orderType == 3) {
            DLog(@"detailData:%@", data);
            MovieProductOrderDetailViewController *mpVC = [[MovieProductOrderDetailViewController alloc] init];
            mpVC.orderDetailOfMovie = (OrderDetailOfMovie *)data;
            [weakSelf.navigationController pushViewController:mpVC animated:YES];
        } else if (self.orderCancelRecord.orderType == 4 || self.orderCancelRecord.orderType == 5) {
            //          开卡充值订单详情
            [[CIASAlertCancleView new] show:@"温馨提示" message:@"充值订单详情正在开发中，敬请期待" cancleTitle:@"知道了" callback:^(BOOL confirm) {
            }];
//            VipCardOrderDetailViewController *mpVC = [[VipCardOrderDetailViewController alloc] init];
//            mpVC.orderDetailOfMovie = (OrderDetailOfMovie *)data;
//            [weakSelf.navigationController pushViewController:mpVC animated:YES];
        }
        
        
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
//    if (indexPath.row == 0) {
//        MovieProductOrderDetailViewController *mpVC = [[MovieProductOrderDetailViewController alloc] init];
//        [self.navigationController pushViewController:mpVC animated:YES];
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


- (NSMutableArray *)orderCancelMovieList {
    if (!_orderCancelMovieList) {
        _orderCancelMovieList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _orderCancelMovieList;
}
- (NSMutableArray *)orderCancelCountList {
    if (!_orderCancelCountList) {
        _orderCancelCountList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _orderCancelCountList;
}
- (NSMutableArray *)orderCancelMovieProductList {
    if (!_orderCancelMovieProductList) {
        _orderCancelMovieProductList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _orderCancelMovieProductList;
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
