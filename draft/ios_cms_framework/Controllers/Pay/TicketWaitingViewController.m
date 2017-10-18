
//
//  TicketWaitingViewController.m
//  CIASMovie
//
//  Created by cias on 2017/1/22.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "TicketWaitingViewController.h"
#import "TicketOutFailedViewController.h"
#import "OrderDetailViewController.h"
#import "Order.h"
#import "OrderRequest.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "DataEngine.h"
#import "OrderListViewController.h"

@interface TicketWaitingViewController ()

@end

@implementation TicketWaitingViewController

- (void)dealloc
{
    [timer invalidate];
    timer = nil;
    [timer1 invalidate];
    timer1 = nil;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = NO;
    self.hideBackBtn = YES;
    self.navigationItem.hidesBackButton = YES;
    self.title = @"出票状态";
    self.view.backgroundColor = [UIColor colorWithHex:[[UIConstants sharedDataEngine] tableviewBackgroundColor]];
    [self setupUI];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
    timer = nil;
    [timer1 invalidate];
    timer1 = nil;

}

- (void)setupUI{
    
    tipImageView = [UIImageView new];
    tipImageView.backgroundColor = [UIColor clearColor];
    tipImageView.image = [UIImage imageNamed:@"ticketing"];
    tipImageView.contentMode = UIViewContentModeScaleAspectFit;
    tipImageView.clipsToBounds = YES;
    [self.view addSubview:tipImageView];

    orderStateLabel = [UILabel new];
    orderStateLabel.textColor = [UIColor colorWithHex:@"#333333"];
    orderStateLabel.text = @"支付已成功！";
    orderStateLabel.textAlignment = NSTextAlignmentCenter;
    orderStateLabel.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:orderStateLabel];
    
    tipLabel = [UILabel new];
    tipLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    tipLabel.text = @"正在为您出票中";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:tipLabel];
    
    countDownLabel = [UILabel new];
    countDownLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    countDownLabel.text = @"出票倒计时(30s)";
    countDownLabel.textAlignment = NSTextAlignmentCenter;
    countDownLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:countDownLabel];
    
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((kCommonScreenWidth-200)/2));
        make.top.equalTo(@((kCommonScreenHeight/2)-167-5));
        make.width.equalTo(@(200));
        make.height.equalTo(@(167));
    }];
    
    [orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(tipImageView.mas_bottom).offset(10);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(30));
        
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(orderStateLabel.mas_bottom).offset(5);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(15));
        
    }];
    [countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(tipLabel.mas_bottom).offset(5);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(15));
        
    }];

    UIButton * refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    refreshBtn.userInteractionEnabled = YES;
    [refreshBtn setFrame:CGRectMake(15, kCommonScreenHeight-50-15, kCommonScreenWidth-30, 50)];
    [refreshBtn setTitle:@"订单列表" forState:UIControlStateNormal];
    refreshBtn.layer.cornerRadius = 2;
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [refreshBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(gotoOrderList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    [refreshBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth));
        make.top.equalTo(self.view.mas_bottom).offset(-50);
    }];
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(refreshBtnClick) userInfo:nil repeats:YES];
    timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerCountDown) userInfo:nil repeats:YES];
    countDownNum = 30;
}

- (void)refreshBtnClick{
    if (countDownNum<=0) {
        [timer invalidate];
        timer = nil;
        [timer1 invalidate];
        timer1 = nil;
        OrderListViewController *ctr = [[OrderListViewController alloc] init];
        NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"0",@"0", nil];
        ctr.btnSelectArr = tmpArr;
        ctr.selectedIndex = 1;
        ctr.isBackFirst = YES;
        [self.navigationController pushViewController:ctr animated:YES];
        return;
    }
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",ciasTenantId,@"tenantId", nil];
    
    [request requestOrderDetailParams:pagrams success:^(id _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        Order *myOrder = data;
//        myOrder.orderMain.status = @5;
        
        if ([myOrder.orderMain.status integerValue] == 6) {
            [timer invalidate];
            timer = nil;
            OrderDetailViewController *ctr = [[OrderDetailViewController alloc] init];
            ctr.orderNo = weakSelf.orderNo;
            ctr.isShowJudgeAlert = YES;
            [self.navigationController pushViewController:ctr animated:YES];
            
        }else if ([myOrder.orderMain.status integerValue] == 4 || [myOrder.orderMain.status integerValue] == 2){
        }else if ([myOrder.orderMain.status integerValue] == 5 || [myOrder.orderMain.status integerValue] == 8){
            [timer invalidate];
            timer = nil;
            TicketOutFailedViewController *ctr = [[TicketOutFailedViewController alloc] init];
            ctr.orderNo = weakSelf.orderNo;
            ctr.myOrder = weakSelf.myOrder;
            
            ctr.planList = self.planList;
            ctr.selectPlanDate = self.selectPlanDate;
            ctr.selectPlanTimeRow = self.selectPlanTimeRow;
            ctr.movieId = self.movieId;
            ctr.cinemaId = self.cinemaId;
            ctr.movieName = self.movieName;
            ctr.cinemaName = self.cinemaName;
            [self.navigationController pushViewController:ctr animated:YES];
        }else{
            
//            TicketOutFailedViewController *ctr = [[TicketOutFailedViewController alloc] init];
//            ctr.orderNo = weakSelf.orderNo;
//            ctr.myOrder = weakSelf.myOrder;
//
//            ctr.planList = self.planList;
//            ctr.selectPlanDate = self.selectPlanDate;
//            ctr.selectPlanTimeRow = self.selectPlanTimeRow;
//            ctr.movieId = self.movieId;
//            ctr.cinemaId = self.cinemaId;
//            ctr.movieName = self.movieName;
//            ctr.cinemaName = self.cinemaName;
//            [self.navigationController pushViewController:ctr animated:YES];
        }

        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];

    }];
}

- (void)gotoOrderList{
    [timer invalidate];
    timer = nil;
    [timer1 invalidate];
    timer1 = nil;
    OrderListViewController *orderVc = [[OrderListViewController alloc] init];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"0",@"0", nil];
    orderVc.btnSelectArr = tmpArr;
    orderVc.selectedIndex = 1;
    orderVc.isBackFirst = YES;
    [self.navigationController pushViewController:orderVc animated:YES];

//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [Constants.appDelegate setHomeSelectedTabAtIndex:3];
}

- (void)timerCountDown{
    if (countDownNum<=0) {
        [timer1 invalidate];
        timer1 = nil;
        return;
    }

    countDownNum--;
    countDownLabel.text = [NSString stringWithFormat:@"出票倒计时(%lds)", countDownNum];

}

@end
