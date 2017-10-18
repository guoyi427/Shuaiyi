//
//  OrderNeedsPayViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderNeedsPayViewController.h"
#import "OrderNeedsPayViewCell.h"
#import "OrderRequest.h"
#import "OrderListData.h"
#import "OrderListRecord.h"
#import "OrderListOfMovie.h"
#import "PayViewController.h"
#import "Order.h"
#import "CIASActivityIndicatorView.h"
#import "OrderConfirmViewController.h"
#import "PayMethodViewController.h"
#import "KKZTextUtility.h"

@interface OrderNeedsPayViewController ()<UITableViewDelegate,UITableViewDataSource,OrderNeedsPayViewCellDelegate,UIScrollViewDelegate>
{
    NSMutableArray *tmpMovieArr;
    NSMutableArray *tmpProductArr;
    int pageNum;
}
@property (nonatomic, strong) UITableView *tableViewOfNeedsPay;
@property (nonatomic, strong) UIView *noOrderListAlertViewOfNeedsPay;
@property (nonatomic, strong) UIButton *gotoBuyTicketBtnOfNeedsPay;

@property (nonatomic, strong) NSMutableArray *orderNeedsPayCountList;
@property (nonatomic, strong) NSMutableArray *orderNeedsPayMovieList;
@property (nonatomic, strong) NSMutableArray *orderNeedsPayMovieProductList;
@property (nonatomic, strong) OrderListRecord *orderNeedsPayRecord;
@property (nonatomic, strong) OrderNeedsPayViewCell *cell;
@end

@implementation OrderNeedsPayViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TaskTypeOrderChooseNotification object:nil];
}

//MARK: 选择订单类型成功
- (void)orderChooseSuccessInNeedsPay:(NSNotification *)notification {
    NSDictionary *dic = [notification userInfo];
    self.orderSelectedArr = [dic objectForKey:@"btnSelectArr"];
    pageNum = 1;
    #if K_HUACHEN || K_HENGDIAN
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [self requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [self requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            [self requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@"4,5"];
        }
    #else
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [self requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [self requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            
        }else if ([[_orderSelectedArr objectAtIndex:3] intValue] == 1) {
            [self requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@"4,5"];
        }
    #endif
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    pageNum = 1;
    #if K_HUACHEN || K_HENGDIAN
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [self requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [self requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            [self requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@"4,5"];
        }
    #else
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [self requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [self requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            
        }else if ([[_orderSelectedArr objectAtIndex:3] intValue] == 1) {
            [self requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@"4,5"];
        }
    #endif
    
}

- (void) requestOrderNeedspayListWithPage:(int) page withPageSize:(int)pageSize withOrderListType:(NSString *)orderListType {
    
    OrderRequest *orderRequest = [[OrderRequest alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:[NSString stringWithFormat:@"%d", page] forKey:@"currentpage"];
    [params setValue:[NSString stringWithFormat:@"%d", pageSize] forKey:@"maxresults"];
    [params setValue:orderListType forKey:@"orderTypeList"];
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    [orderRequest requestOrderUnpayParams:params success:^(NSDictionary *_Nullable data) {
        if (page==1) {
            [weakSelf endRefreshing];
            if (weakSelf.orderNeedsPayCountList.count > 0) {
                [weakSelf.orderNeedsPayCountList removeAllObjects];
            }
        }else{
            [weakSelf endLoadMore];
        }
        OrderListData *orderlistDt = (OrderListData *)data;
        [weakSelf.orderNeedsPayCountList addObjectsFromArray:orderlistDt.records];
        for (int i = 0; i < weakSelf.orderNeedsPayCountList.count; i++) {
            self.orderNeedsPayRecord = (OrderListRecord *)[self.orderNeedsPayCountList objectAtIndex:i];
            if (self.orderNeedsPayRecord.orderDetailList.count > 0) {
                [self.orderNeedsPayMovieProductList addObjectsFromArray:self.orderNeedsPayRecord.orderDetailList];
            }
            OrderListOfMovie *orderlistMe = [[OrderListOfMovie alloc] init];
            NSMutableArray *tmpMovieArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray *tmpProductArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i = 0; i < self.orderNeedsPayMovieProductList.count; i++) {
                orderlistMe = [self.orderNeedsPayMovieProductList objectAtIndex:i];
                if (orderlistMe.goodsType == 1) {
                    //电影票的
                    [tmpMovieArray addObject:[self.orderNeedsPayMovieProductList objectAtIndex:i]];
                } else if(orderlistMe.goodsType == 3) {
                    //卖品的
                    [tmpProductArray addObject:[self.orderNeedsPayMovieProductList objectAtIndex:i]];
                }else if(orderlistMe.goodsType == 4) {
                    //开卡的
                    [tmpMovieArray addObject:[self.orderNeedsPayMovieProductList objectAtIndex:i]];
                }else if(orderlistMe.goodsType == 5) {
                    //充值的
                    [tmpMovieArray addObject:[self.orderNeedsPayMovieProductList objectAtIndex:i]];
                }
            }
            [tmpMovieArr addObjectsFromArray:tmpMovieArray];
            [tmpProductArray addObjectsFromArray:tmpProductArray];
        }
        
        if (weakSelf.orderNeedsPayCountList.count>0) {
            if (weakSelf.noOrderListAlertViewOfNeedsPay.superview) {
                [weakSelf.noOrderListAlertViewOfNeedsPay removeFromSuperview];
            }
            weakSelf.gotoBuyTicketBtnOfNeedsPay.hidden = YES;
            _tableViewOfNeedsPay.mj_footer.state = MJRefreshStateIdle;
            if (page==1) {
                [_tableViewOfNeedsPay setContentOffset:CGPointZero];
            }
            
        }else{
            //没有更多
            [_tableViewOfNeedsPay.mj_footer endRefreshingWithNoMoreData];
            if (weakSelf.noOrderListAlertViewOfNeedsPay.superview) {
            }else{
                [weakSelf.tableViewOfNeedsPay addSubview:weakSelf.noOrderListAlertViewOfNeedsPay];
            }
            weakSelf.gotoBuyTicketBtnOfNeedsPay.hidden = NO;
        }
        //        DLog(@"orderNeedsPayCountList%@", self.orderNeedsPayCountList);
        //        DLog(@"orderNeedsPayCountList.count%lu", (unsigned long)self.orderNeedsPayCountList.count);
        
        //        [orderlistDt.records enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //            DLog(@"%@",obj);
        //            OrderListRecord *orderlistRd = obj;
        //            DLog(@"receiveMoney%@", orderlistRd.receiveMoney);
        //        }];
        
        [weakSelf.tableViewOfNeedsPay reloadData];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    tmpMovieArr = [[NSMutableArray alloc] initWithCapacity:0];
    tmpProductArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderChooseSuccessInNeedsPay:) name:TaskTypeOrderChooseNotification object:nil];
    
    self.tableViewOfNeedsPay = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight-64-35) style:UITableViewStylePlain];
    self.tableViewOfNeedsPay.showsVerticalScrollIndicator = NO;
//    self.tableViewOfNeedsPay.contentInset = UIEdgeInsetsMake(104, 0, 49, 0);
//    self.tableViewOfNeedsPay.scrollIndicatorInsets = self.tableViewOfNeedsPay.contentInset;
    self.tableViewOfNeedsPay.backgroundColor = [UIColor whiteColor];
    self.tableViewOfNeedsPay.delegate = self;
    self.tableViewOfNeedsPay.decelerationRate = 0.0;
    self.tableViewOfNeedsPay.dataSource = self;
    self.tableViewOfNeedsPay.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableViewOfNeedsPay];
    __weak __typeof(self) weakSelf = self;
    self.tableViewOfNeedsPay.mj_header = [CPRefreshHeader headerWithRefreshingBlock:^{
        //刷新页面
        pageNum = 1;
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [weakSelf requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [weakSelf requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            
        }else if ([[_orderSelectedArr objectAtIndex:3] intValue] == 1) {
            [weakSelf requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@"4,5"];
        }
    }];
    self.tableViewOfNeedsPay.mj_footer = [CPRefreshFooter footerWithRefreshingBlock:^{
        if ([_tableViewOfNeedsPay.mj_header isRefreshing]) {
            [_tableViewOfNeedsPay.mj_footer endRefreshing];
            return;
        }
        //刷新页面
        pageNum++;
        if ([[_orderSelectedArr objectAtIndex:0] intValue] == 1 ) {
            [weakSelf requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@""];
        } else if ([[_orderSelectedArr objectAtIndex:1] intValue] == 1) {
            [weakSelf requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@"3"];
        }else if ([[_orderSelectedArr objectAtIndex:2] intValue] == 1) {
            
        }else if ([[_orderSelectedArr objectAtIndex:3] intValue] == 1) {
            [weakSelf requestOrderNeedspayListWithPage:pageNum withPageSize:10 withOrderListType:@"4,5"];
        }
    }];
    //    106/375.0 = 0.283  185/667.0 = 0.277
    UIImage *noOrderAlertImage = [UIImage imageNamed:@"empty"];
    NSString *noOrderAlertStr = @"还没有待付款订单";
    CGSize noOrderAlertStrSize = [KKZTextUtility measureText:noOrderAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15]];
    self.noOrderListAlertViewOfNeedsPay = [[UIView alloc] initWithFrame:CGRectMake(0.283*kCommonScreenWidth, 0.277*kCommonScreenHeight, noOrderAlertImage.size.width, noOrderAlertStrSize.height+noOrderAlertImage.size.height+15)];
    UIImageView *noOrderAlertImageView = [[UIImageView alloc] init];
    [self.noOrderListAlertViewOfNeedsPay addSubview:noOrderAlertImageView];
    noOrderAlertImageView.image = noOrderAlertImage;
    noOrderAlertImageView.contentMode = UIViewContentModeScaleAspectFill;
    [noOrderAlertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.noOrderListAlertViewOfNeedsPay);
        make.height.equalTo(@(noOrderAlertImage.size.height));
    }];
    UILabel *noOrderAlertLabel = [[UILabel alloc] init];
    [self.noOrderListAlertViewOfNeedsPay addSubview:noOrderAlertLabel];
    noOrderAlertLabel.text = noOrderAlertStr;
    noOrderAlertLabel.font = [UIFont systemFontOfSize:15];
    noOrderAlertLabel.textAlignment = NSTextAlignmentCenter;
    noOrderAlertLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    [noOrderAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.noOrderListAlertViewOfNeedsPay);
        make.top.equalTo(noOrderAlertImageView.mas_bottom).offset(15);
        make.height.equalTo(@(noOrderAlertStrSize.height));
    }];
    self.gotoBuyTicketBtnOfNeedsPay = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gotoBuyTicketBtnOfNeedsPay setTitle:@"马上购票" forState:UIControlStateNormal];
    self.gotoBuyTicketBtnOfNeedsPay.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    [self.gotoBuyTicketBtnOfNeedsPay setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
    self.gotoBuyTicketBtnOfNeedsPay.titleLabel.font = [UIFont systemFontOfSize:16];
    self.gotoBuyTicketBtnOfNeedsPay.hidden = YES;
    [self.view addSubview:self.gotoBuyTicketBtnOfNeedsPay];
    self.gotoBuyTicketBtnOfNeedsPay.frame = CGRectMake(15, kCommonScreenHeight-64-35-65, kCommonScreenWidth - 30, 50);
//    [self.gotoBuyTicketBtnOfNeedsPay mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(15);
//        make.right.equalTo(self.view.mas_right).offset(-15);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-15);
//        make.height.equalTo(@50);
//    }];
    [self.gotoBuyTicketBtnOfNeedsPay addTarget:self action:@selector(gotoBuyTicketBtnClickForNeedsPay:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  结束刷新
 */
- (void)endRefreshing {
    if ([self.tableViewOfNeedsPay.mj_header isRefreshing]) {
        [self.tableViewOfNeedsPay.mj_header endRefreshing];
    }
}
/**
 *  结束加载更多
 */
- (void)endLoadMore {
    
    if ([self.tableViewOfNeedsPay.mj_footer isRefreshing]) {
        [self.tableViewOfNeedsPay.mj_footer endRefreshing];
    }
    
}

- (void)gotoBuyTicketBtnClickForNeedsPay:(id)sender {
    
    
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
    static NSString *cellID = @"OrderNeedsPayViewCell";
//    Cinema *managerment = [self.cinemaList objectAtIndex:indexPath.row];
    _cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (_cell == nil) {
        _cell = [[OrderNeedsPayViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    if (self.orderNeedsPayMovieProductList.count > 0) {
        [self.orderNeedsPayMovieProductList removeAllObjects];
    }
    
    self.orderNeedsPayRecord = (OrderListRecord *)[self.orderNeedsPayCountList objectAtIndex:indexPath.row];
    if (self.orderNeedsPayRecord.orderDetailList.count > 0) {
        [self.orderNeedsPayMovieProductList addObjectsFromArray:self.orderNeedsPayRecord.orderDetailList];
        _cell.orderMovieProductNeedsPayList = self.orderNeedsPayMovieProductList;
    }
    _cell.delegate = self;
    _cell.orderListRecordNeedsPayData = self.orderNeedsPayRecord;
    _cell.cellIndexPath = indexPath.row;
    
//    if(self.tableViewOfNeedsPay.dragging == NO && self.tableViewOfNeedsPay.decelerating == NO)
//    {
        //table停止不再滚动的时候加载数据
    [_cell updateLayout];
//    }
    return _cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    DLog(@"%lu", self.orderNeedsPayCountList.count);
    return self.orderNeedsPayCountList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.orderNeedsPayRecord = (OrderListRecord *)[self.orderNeedsPayCountList objectAtIndex:indexPath.row];
    if (self.orderNeedsPayRecord.orderDetailList.count > 0) {
        [self.orderNeedsPayMovieProductList addObjectsFromArray:self.orderNeedsPayRecord.orderDetailList];
    }
    OrderListOfMovie *orderlistMe = [[OrderListOfMovie alloc] init];
    NSMutableArray *tmpMovieArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tmpProductArr1 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < self.orderNeedsPayMovieProductList.count; i++) {
        orderlistMe = [self.orderNeedsPayMovieProductList objectAtIndex:i];
        if (orderlistMe.goodsType == 1) {
            //电影票的
            [tmpMovieArr1 addObject:[self.orderNeedsPayMovieProductList objectAtIndex:i]];
        } else if(orderlistMe.goodsType == 3) {
            //卖品的
            [tmpProductArr1 addObject:[self.orderNeedsPayMovieProductList objectAtIndex:i]];
        }
    }
    if (tmpProductArr1.count > 0) {
        return 191+5;
    } else {
        return 149+5;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//// 滚动停止的时候再去获取image的信息来显示在UITableViewCell上
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    if(!decelerate){
//        [self loadDataForCell];
//    }
//}
//
//-(void)scrollViewWillBeginDecelerating: (UIScrollView *)scrollView
//
//{
//    
////    DLog(@"%.2f", scrollView.contentOffset.y);
//    DLog(@"%lu %lu",(unsigned long)tmpMovieArr.count,(unsigned long)tmpProductArr.count);
//    if (scrollView.contentOffset.y <= 0 || (scrollView.contentOffset.y > (149*tmpMovieArr.count + 191*tmpProductArr.count))) {
//    } else {
//        [scrollView setContentOffset:scrollView.contentOffset animated:NO];
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    [self loadDataForCell];
//}
//
//
//- (void)loadDataForCell {
////    [_cell updateLayout];
//}

- (void)handleCellOnPayBtn:(NSInteger)cellIndex {
    self.orderNeedsPayRecord = (OrderListRecord *)[self.orderNeedsPayCountList objectAtIndex:cellIndex];
    //    if (indexPath.row == 0) {
    //请求详情数据，成功后跳转，否则报错，不跳转
    if (self.orderNeedsPayRecord.orderType == 3) {
        //影票
        if ([self.orderNeedsPayRecord.status integerValue] == 1) {
            PayViewController *ctr = [[PayViewController alloc] init];
            ctr.orderNo = self.orderNeedsPayRecord.orderCode;
            ctr.isFromOrder = YES;
            [self.navigationController pushViewController:ctr animated:YES];
        } else if([self.orderNeedsPayRecord.status integerValue] == 2){
            OrderConfirmViewController *ctr = [[OrderConfirmViewController alloc] init];
            ctr.orderNo = self.orderNeedsPayRecord.orderCode;
            ctr.isFromOrder = YES;
            [self.navigationController pushViewController:ctr animated:YES];
        }
    } else if(self.orderNeedsPayRecord.orderType == 4)  {
        //充值
        //查询订单详情
        [[UIConstants sharedDataEngine] loadingAnimation];
        OrderRequest *request = [[OrderRequest alloc] init];
        NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNeedsPayRecord.orderCode, @"orderCode",ciasTenantId,@"tenantId", nil];
        __weak __typeof(self) weakSelf = self;
        [request requestOrderDetailParams:pagrams success:^(id _Nullable data) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            Order *myOrder = data;
            //        myOrder.orderMain.status = @5;
            PayMethodViewController *ctr = [[PayMethodViewController alloc] init];
            ctr.isFromRecharger = YES;
            ctr.myOrder = myOrder;
            [weakSelf.navigationController pushViewController:ctr animated:YES];
            //主线程刷新，防止闪烁
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        } failure:^(NSError * _Nullable err) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            [CIASPublicUtility showAlertViewForTaskInfo:err];
            
        }];
    } else if(self.orderNeedsPayRecord.orderType == 5)  {
        //开卡
        
    }
    
    /*
    [[UIConstants sharedDataEngine] loadingAnimation];
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:weakSelf.orderNeedsPayRecord.orderCode forKey:@"orderCode"];
    [params setValue:weakSelf.orderNeedsPayRecord.tenantId forKey:@"tenantId"];
    
    [request requestGetOrderInfoParams:params success:^(id _Nullable data) {
        
        PayViewController *ctr = [[PayViewController alloc] init];
        Order *order = (Order *)data;
        ctr.orderNo = order.orderTicket.fkOrderCode;
        [weakSelf.navigationController pushViewController:ctr animated:YES];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
     */
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSMutableArray *)orderNeedsPayMovieList {
    if (!_orderNeedsPayMovieList) {
        _orderNeedsPayMovieList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _orderNeedsPayMovieList;
}
- (NSMutableArray *)orderNeedsPayCountList {
    if (!_orderNeedsPayCountList) {
        _orderNeedsPayCountList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _orderNeedsPayCountList;
}
- (NSMutableArray *)orderNeedsPayMovieProductList {
    if (!_orderNeedsPayMovieProductList) {
        _orderNeedsPayMovieProductList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _orderNeedsPayMovieProductList;
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
