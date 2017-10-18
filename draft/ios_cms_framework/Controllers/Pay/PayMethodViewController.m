//
//  PayMethodViewController.m
//  CIASMovie
//
//  Created by cias on 2017/2/7.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "PayMethodViewController.h"
#import "OrderDetailViewController.h"
#import "TicketWaitingViewController.h"
#import "TicketOutFailedViewController.h"
#import "OrderRequest.h"
#import "PayMethodCell.h"
#import <AlipaySDK/AlipaySDK.h>
#import "NSStringExtra.h"
//#import <Category_KKZ/NSDictionaryExtra.h>
#import "OrderConfirmViewController.h"
#import "WXApi.h"
#import "ChargeSuceessViewController.h"
#import "XingYiPlanListViewController.h"
#import "PlanListViewController.h"
#import "OpenWaitingViewController.h"
#import "OpenSuccessViewController.h"
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "ConstantHeader.h"
#import "Macros.h"
#import "UIConstants.h"

@interface PayMethodViewController ()
{
    NSDate *nowDate;
}
@end

@implementation PayMethodViewController

- (void)dealloc
{
    [timer invalidate];
    timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TaskTypeAliPaySucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayOpencardSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AliPayChargeSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:wxpaySucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:wxpayOpencardSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:wxChargeSucceedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DLog(@"通知被注销");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = YES;
    self.hideBackBtn = YES;
    self.view.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].tableviewBackgroundColor];
    _payMethodList = [[NSMutableArray alloc] initWithCapacity:0];
    //    [_payMethodList addObject:[NSNumber numberWithInt:PayMethodWeChat]];
    if (![_payMethodList containsObject:[NSNumber numberWithInt:PayMethodAlipay]]) {
        [_payMethodList addObject:[NSNumber numberWithInt:PayMethodAlipay]];
    }
    if ([kIsHaveWeixinPay isEqualToString:@"1"]) {
        if (![_payMethodList containsObject:[NSNumber numberWithInt:PayMethodWeChat]]) {
            [_payMethodList addObject:[NSNumber numberWithInt:PayMethodWeChat]];
        }
    }
    
    selectedNum = -1;
    payMethodType = -1;
    payMethodNum = -1;
    [self setupUI];
    [self setNavBarUI];
    if (self.isFromRecharger) {
        nowDate = [NSDate date];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethod:) userInfo:nil repeats:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alipaySucceed:)
                                                 name:TaskTypeAliPaySucceedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alipayOpenCardSucceed:)
                                                 name:AliPayOpencardSucceedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(alipayChargeSucceed:)
                                                 name:AliPayChargeSucceedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wxSucceed:)
                                                 name:wxpaySucceedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wxOpenCardSucceed:)
                                                 name:wxpayOpencardSucceedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wxChargeSucceed:)
                                                 name:wxChargeSucceedNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
#if K_HENGDIAN
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#else
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#endif

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    self.navigationController.navigationBar.translucent = NO;
    [timer invalidate];
    timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNavBarUI{
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 64)];
    self.navBar.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor];
    [self.view addSubview:self.navBar];
    UIView *barLine = [[UIView alloc]initWithFrame:CGRectMake(0, 63, kCommonScreenWidth, 1)];
    barLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [self.navBar addSubview:barLine];

    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(13.5, 27.5, 28, 28);
    [backButton setImage:[UIImage imageNamed:@"titlebar_back1"]
                forState:UIControlStateNormal];
    //    [backButton setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self
                   action:@selector(backItemClick)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backButton];
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //    self.navigationItem.leftBarButtonItem = backItem;
    
    
    UIView * customTitleView = [[UIView alloc] initWithFrame:CGRectMake(70, 20, kCommonScreenWidth-140, 44)];
    customTitleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:customTitleView];
    //    self.navigationItem.titleView = customTitleView;
    cinemaTitleLabel = [UILabel new];
#if K_HENGDIAN
    cinemaTitleLabel.textColor = [UIColor blackColor];
#else
    cinemaTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
#endif
    cinemaTitleLabel.textAlignment = NSTextAlignmentCenter;
    cinemaTitleLabel.text = @"收银台";
    cinemaTitleLabel.font = [UIFont systemFontOfSize:16];
    [customTitleView addSubview:cinemaTitleLabel];
    [cinemaTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(7));
        make.left.equalTo(@(0));
        make.right.equalTo(customTitleView.mas_right).offset(0);
        make.height.equalTo(@(15));
    }];
    
    movieTitleLabel = [UILabel new];
    movieTitleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor];
    movieTitleLabel.textAlignment = NSTextAlignmentCenter;
    movieTitleLabel.font = [UIFont systemFontOfSize:13];
    [customTitleView addSubview:movieTitleLabel];
    [movieTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cinemaTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(@(0));
        make.right.equalTo(customTitleView.mas_right).offset(0);
        make.height.equalTo(@(13));
    }];
    
}

- (void)setupUI{
    payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kCommonScreenWidth, kCommonScreenHeight-50-64) style:UITableViewStylePlain];
    payTableView.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].tableviewBackgroundColor];
    payTableView.delegate = self;
    payTableView.dataSource = self;
    payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:payTableView];
    //    [payTableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.equalTo(@0);
    //    }];
    
    topHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 148+30)];
    topHeaderView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    [payTableView setTableHeaderView:topHeaderView];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"您需要支付";
    tipLabel.font = [UIFont systemFontOfSize:13];
    [topHeaderView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(30));
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(13));
    }];
    UILabel *moneySLabel = [UILabel new];
    moneySLabel.textColor = [UIColor colorWithHex:@"#ff9900"];
    moneySLabel.textAlignment = NSTextAlignmentRight;
    moneySLabel.text = @"￥";
    moneySLabel.font = [UIFont systemFontOfSize:27];
    [topHeaderView addSubview:moneySLabel];
    [moneySLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(16);
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth/2-30));
        make.height.equalTo(@(30));
    }];
    
    moneyLabel = [UILabel new];
    moneyLabel.textColor = [UIColor colorWithHex:@"#ff9900"];
    moneyLabel.textAlignment = NSTextAlignmentLeft;
    if (self.isFromRecharger) {
        moneyLabel.text = [NSString stringWithFormat:@"%.2f", self.myOrder.totalPrice.floatValue];
    } else if (self.isFromOpenCard) {
        moneyLabel.text = [NSString stringWithFormat:@"%.2f", self.myOrder.totalPrice.floatValue];
    }else {
        moneyLabel.text = self.totalMoney;
    }
    
    moneyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:30];
    [topHeaderView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(15);
        make.left.equalTo(moneySLabel.mas_right).offset(0);
        make.width.equalTo(@(kCommonScreenWidth/2));
        make.height.equalTo(@(30));
    }];
    
    orderNoLabel = [UILabel new];
    orderNoLabel.textColor = [UIColor colorWithHex:@"#333333"];
    orderNoLabel.textAlignment = NSTextAlignmentCenter;
    orderNoLabel.font = [UIFont systemFontOfSize:10];
    if (self.isFromRecharger) {
        orderNoLabel.text = [NSString stringWithFormat:@"充值订单-订单号：%@", self.myOrder.orderMain.orderCode];
    } else if (self.isFromOpenCard) {
        orderNoLabel.text = [NSString stringWithFormat:@"开卡订单-订单号：%@", self.myOrder.orderMain.orderCode];
    } else {
        orderNoLabel.text = [NSString stringWithFormat:@"影票订单-订单号：%@", self.orderNo];
    }
    
    
    [topHeaderView addSubview:orderNoLabel];
    [orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moneyLabel.mas_bottom).offset(30);
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(13));
    }];
    
    
    
    payMethodHeadView = [UIView new];
    [topHeaderView addSubview:payMethodHeadView];
    payMethodHeadView.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].tableviewBackgroundColor];
    payMethodHeadView.frame = CGRectMake(0, 147, kCommonScreenWidth, 31);
    UIView *payMethodHeadViewUpLine = [self getViewBottomLineWithSuperView:payMethodHeadView withTop:0];
    UIView *payMethodHeadViewDownLine = [self getViewBottomLineWithSuperView:payMethodHeadView withTop:30.5];
    
    UILabel *payMethodTipLabel = [UILabel new];
    payMethodTipLabel.text = @"选择支付方式";
    payMethodTipLabel.backgroundColor = [UIColor clearColor];
    payMethodTipLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    payMethodTipLabel.textAlignment = NSTextAlignmentLeft;
    payMethodTipLabel.font = [UIFont systemFontOfSize:13];
    [payMethodHeadView addSubview:payMethodTipLabel];
    [payMethodTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(@(0));
        make.width.equalTo(@(105));
        make.height.equalTo(@(32));
    }];
    
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
    if (self.isFromRecharger) {
        [confirmBtn setTitle:[NSString stringWithFormat:@"总计:¥%@  确认支付", [NSString stringWithFormat:@"%.2f", self.myOrder.totalPrice.floatValue]] forState:UIControlStateNormal];
    } else if (self.isFromOpenCard) {
        [confirmBtn setTitle:[NSString stringWithFormat:@"总计:¥%.2f 确认支付", self.myOrder.totalPrice.floatValue] forState:UIControlStateNormal];
    }else {
        [confirmBtn setTitle:[NSString stringWithFormat:@"总计:%@  确认支付", self.totalMoney] forState:UIControlStateNormal];
    }
    
    
    [confirmBtn addTarget:self action:@selector(confirmOrderClick) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}


- (void)backItemClick{
    //    [self.navigationController popViewControllerAnimated:YES];
    if (self.isFromRecharger || self.isFromOpenCard) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续支付"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action){
                                                             }];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确认返回"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *_Nonnull action) {
                                                               [self deleteOrder];
                                                           }];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"返回后，订单不再保留" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:sureAction];
        [alertVC addAction:cancelAction];
        
        [self presentViewController:alertVC
                           animated:YES
                         completion:^{
                         }];
    } else if (self.isFromOrderConfirm) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        OrderConfirmViewController *ctr = [[OrderConfirmViewController alloc] init];
        ctr.orderNo = self.orderNo;
        ctr.isFromOrder = true;
        [self.navigationController pushViewController:ctr animated:YES];
    }
    
}

//取消订单
- (void)deleteOrder{
    [[UIConstants sharedDataEngine] loadingAnimation];
    OrderRequest *request = [[OrderRequest alloc] init];
    //    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.myOrder.orderMain.orderCode, @"orderCode", ciasTenantId,@"tenantId", nil];
    
    [request requestCancelOrderParams:pagrams success:^(id _Nullable data) {
        //        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    } failure:^(NSError * _Nullable err) {
        
        //        [[UIConstants sharedDataEngine] stopLoadingAnimation];
    }];
    [[UIConstants sharedDataEngine] stopLoadingAnimation];
    if (self.isFromOpenCard) {
        if (self.navigationController.viewControllers.count >= 4) {
            UIViewController *targetController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-4];
            [self.navigationController popToViewController:targetController animated:YES];
        }
    } else {
        if (self.navigationController.viewControllers.count >= 3) {
            UIViewController *targetController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
            [self.navigationController popToViewController:targetController animated:YES];
        }
    }
    
    
}

- (void)confirmOrderClick{
    if (selectedNum == 0) {
        selectedMethod = PayMethodAlipay;
    }else if (selectedNum == 1){
        selectedMethod = PayMethodWeChat;
    }
    DLog(@"selectedMethod %@",[NSNumber numberWithBool:selectedMethod]);
    
    if (selectedMethod != PayMethodAlipay && selectedMethod != PayMethodWeChat) {
        [CIASPublicUtility showAlertViewForTitle:@"" message:@"请选择支付方式" cancelButton:@"知道了"];
        return;
    }
    [self requestOrderPay];
    //    [self refreshPayOrderDetail];
}

//MARK: 支付接口
- (void)requestOrderPay {
    //    [SVProgressHUD show];
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [[NSDictionary alloc] init];
    NSString *payMethodStr = [NSString stringWithFormat:@"%d",selectedMethod];
    if (self.isFromRecharger || self.isFromOpenCard) {
        pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.myOrder.orderMain.orderCode,@"orderCode",payMethodStr,@"payType", nil];
    } else {
        pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",payMethodStr,@"payType", nil];
    }
    
    
    [request requestGoPayOrderParams:pagrams success:^(NSDictionary *_Nullable data) {
        
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        NSDictionary *userInfo = [data kkz_objForKey:@"data"];
        if (selectedMethod == PayMethodAlipay && userInfo) {
            
            NSString *payUrl = [userInfo kkz_objForKey:@"payUrl"];
            NSString *sign = [userInfo kkz_objForKey:@"sign"];
            NSString *oNo = [userInfo kkz_objForKey:@"payOrderNo"];
            NSString *spId = [userInfo kkz_objForKey:@"spId"];
            NSString *sysProvide = [userInfo kkz_objForKey:@"sysProvide"];
            
            [weakSelf payOrderMethod:selectedMethod
                              payUrl:payUrl
                                sign:sign
                                spId:spId
                          sysProvide:sysProvide];
            
            if ([oNo isEqualToString:self.orderNo]) {
                
                
            }
        } else if (selectedMethod == PayMethodWeChat && userInfo) {
            if ([WXApi isWXAppInstalled]) {
                if (self.isFromRecharger) {
                    Constants.payOrderType = PayOrderTypeChargeCard;
                } else if (self.isFromOpenCard) {
                    Constants.payOrderType = PayOrderTypeOpenCard;
                } else {
                    Constants.payOrderType = PayOrderTypeAlipay;
                }
                
                //判断是否有微信
                NSString *payUrl = [userInfo kkz_stringForKey:@"payUrl"];
                //                payUrl = @"{\"appid\":\"wx74c15f9950ca03b1\",\"noncestr\":\"mxTPYCgRe8b0D5E4\",\"package\":\"Sign=WXPay\",\"partnerid\":\"1234062502\",\"prepayid\":\"wx20150707175714d99ffd6b730074558070\",\"sign\":\"4F862E59C3DB8C65EB6857B4FC26F7ED\",\"timestamp\":\"1436263035\"}";
                //               {"appid":"wx74c15f9950ca03b1","package":"Sign=WXPay","partnerid":"1234062502","sign":"5B338F948B89B1A2408E2515AA2FEB0A","timestamp":"1436527285"
                
                NSData *jsonData = [payUrl dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                
                NSMutableString *stamp  = [dic objectForKey:@"timestamp"];
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                
                req.openID              = [dic objectForKey:@"appid"];
                
                req.partnerId           = [dic objectForKey:@"partnerid"];
                
                req.prepayId            = [dic objectForKey:@"prepayid"];
                
                req.nonceStr            = [dic objectForKey:@"noncestr"];
                
                req.timeStamp           = stamp.intValue;
                
                req.package             = [dic objectForKey:@"package"];
                
                req.sign                = [dic objectForKey:@"sign"];
                
                DLog(@"req.openID = %@  req.partnerId = %@  req.prepayId = %@  req.nonceStr = %@  req.timeStamp = %d  req.package = %@  req.sign = %@  ",req.openID, req.partnerId,req.prepayId,req.nonceStr,(unsigned int)req.timeStamp,req.package,req.sign);
                [WXApi sendReq:req];
            } else {
                [[CIASAlertCancleView new] show:@"温馨提示" message:@"请安装最新版本微信后再试" cancleTitle:@"好的" callback:^(BOOL confirm) {
                }];
            }
        }
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
    
}

- (void)payOrderMethod:(PayMethod)selectedMethodTemp
                payUrl:(NSString *)payUrl
                  sign:(NSString *)sign
                  spId:(NSString *)spId
            sysProvide:(NSString *)sysProvide{
    
    if (selectedMethodTemp == PayMethodAlipay) {
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString * rawSign = [sign Base642String:enc];
        
        [self alipayWithUrl:payUrl andSign:rawSign];
        
    } else if (selectedMethodTemp == PayMethodWeChat) {
        
        
    } else if (selectedMethodTemp == PayMethodUnionpay) {
    }
}

- (void)alipayWithUrl:(NSString *)payUrl andSign:(NSString *)paySign {
    //获取安全支付单例并调用安全支付接口
    
    if (self.isFromRecharger) {
        Constants.payOrderType = PayOrderTypeChargeCard;
    } else if (self.isFromOpenCard) {
        Constants.payOrderType = PayOrderTypeOpenCard;
    } else {
        Constants.payOrderType = PayOrderTypeAlipay;
    }
    [[AlipaySDK defaultService] payOrder:paySign fromScheme:kAlipayScheme callback:^(NSDictionary *resultDic) {
        DLog(@"AlipaySDK reslut = %@",resultDic);
        int stateStaus =[[resultDic objectForKey:@"resultStatus"] intValue];
        NSString *resultMsg = @"";
        
        if (stateStaus==9000) {
            [timer invalidate];
            timer = nil;
            confirmBtn.userInteractionEnabled = NO;
//            resultMsg = @"支付成功啦";
            //支付宝支付成功后回调后台订单详情接口，查看订单状态，跳转不同的界面
            [self refreshPayOrderDetail];
        }else if (stateStaus==6001){
            resultMsg = [resultDic objectForKey:@"memo"];
            
        }else{
            resultMsg = [resultDic objectForKey:@"memo"];
            
        }
        if (resultMsg.length>0) {
            [CIASPublicUtility showAlertViewForTitle:@"" message:resultMsg cancelButton:@"知道了"];
        }
    }];
}

- (void)refreshPayOrderDetail{
    //    [SVProgressHUD show];
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",ciasTenantId,@"tenantId", nil];
    
    [request requestOrderDetailParams:pagrams success:^(id _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [timer invalidate];
        timer = nil;
        
        weakSelf.myOrder = data;
        DLog(@"myOrder=%@",weakSelf.myOrder);
        DLog(@"myOrder=%ld",weakSelf.myOrder.orderMain.status.integerValue);
        
        /*
         1：影票锁座下单
         2：第一次去支付
         4：支付成功
         5：支付成功，出票失败
         6：出票成功
         8：订单已经取消
         
         2：第一次去支付
         4：支付成功
         跳转到，支付成功，出票中界面
         6：出票成功
         跳转到出票成功界面
         5：支付成功，出票失败
         8：订单已经取消
         跳转到出票失败界面
         
         */
        //        weakSelf.myOrder.orderMain.status = @4;
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakSelf.myOrder.orderMain.status integerValue] == 6) {
                DLog(@"OrderDetailViewController");
                
                OrderDetailViewController *ctr = [[OrderDetailViewController alloc] init];
                ctr.orderNo = weakSelf.orderNo;
                ctr.isShowJudgeAlert = YES;
                [weakSelf.navigationController pushViewController:ctr animated:YES];
                DLog(@"OrderDetailViewController");
                
            }else if ([weakSelf.myOrder.orderMain.status integerValue] == 4 || [weakSelf.myOrder.orderMain.status integerValue] == 2){
                DLog(@"TicketWaitingViewController");
                
                TicketWaitingViewController *ctr = [[TicketWaitingViewController alloc] init];
                ctr.orderNo = weakSelf.orderNo;
                ctr.myOrder = weakSelf.myOrder;
                ctr.planList = self.planList;
                ctr.selectPlanDate = self.selectPlanDate;
                ctr.selectPlanTimeRow = self.selectPlanTimeRow;
                ctr.movieId = self.movieId;
                ctr.cinemaId = self.cinemaId;
                ctr.movieName = self.movieName;
                ctr.cinemaName = self.cinemaName;
                [weakSelf.navigationController pushViewController:ctr animated:YES];
                DLog(@"TicketWaitingViewController");
                
            }else if ([weakSelf.myOrder.orderMain.status integerValue] == 5 || [weakSelf.myOrder.orderMain.status integerValue] == 8){
                DLog(@"TicketOutFailedViewController");
                
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
                [weakSelf.navigationController pushViewController:ctr animated:YES];
                DLog(@"TicketOutFailedViewController");
                
            }else{
                
                TicketWaitingViewController *ctr = [[TicketWaitingViewController alloc] init];
                ctr.orderNo = weakSelf.orderNo;
                ctr.myOrder = weakSelf.myOrder;
                ctr.planList = self.planList;
                ctr.selectPlanDate = self.selectPlanDate;
                ctr.selectPlanTimeRow = self.selectPlanTimeRow;
                ctr.movieId = self.movieId;
                ctr.cinemaId = self.cinemaId;
                ctr.movieName = self.movieName;
                ctr.cinemaName = self.cinemaName;
                [weakSelf.navigationController pushViewController:ctr animated:YES];
                DLog(@"TicketWaitingViewController");
                
            }
            
            
        });
        
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
}


- (void)refreshPayCardOrderDetail{
    //    [SVProgressHUD show];
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.myOrder.orderMain.orderCode,@"orderCode",ciasTenantId,@"tenantId", nil];
    
    [request requestCardOrderDetailFromListParams:pagrams success:^(id _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [timer invalidate];
        timer = nil;
        
        weakSelf.myOrderDetail = data;
        DLog(@"myOrder=%@",weakSelf.myOrderDetail);
        DLog(@"myOrder=%ld",weakSelf.myOrderDetail.orderMain.status.integerValue);
        
        /*
         1：影票锁座下单
         2：第一次去支付
         4：支付成功
         5：支付成功，出票失败
         6：出票成功
         8：订单已经取消
         
         2：第一次去支付
         4：支付成功
         跳转到，支付成功，出票中界面
         6：出票成功
         跳转到出票成功界面
         5：支付成功，出票失败
         8：订单已经取消
         跳转到出票失败界面
         
         */
        //        weakSelf.myOrder.orderMain.status = @4;
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakSelf.myOrderDetail.orderMain.status integerValue] == 6) {
                DLog(@"OpenSuccessViewController");
                
                OpenSuccessViewController *ctr = [[OpenSuccessViewController alloc] init];
                ctr.myOrderDetail = weakSelf.myOrderDetail;
                
                [weakSelf.navigationController pushViewController:ctr animated:YES];
                
            }else if ([weakSelf.myOrderDetail.orderMain.status integerValue] == 4 || [weakSelf.myOrderDetail.orderMain.status integerValue] == 2){
                DLog(@"OpenWaitingViewController");
                
                OpenWaitingViewController *ctr = [[OpenWaitingViewController alloc] init];
                ctr.orderNo = weakSelf.myOrder.orderMain.orderCode;
                [weakSelf.navigationController pushViewController:ctr animated:YES];
                
            }else if ([weakSelf.myOrderDetail.orderMain.status integerValue] == 5 || [weakSelf.myOrderDetail.orderMain.status integerValue] == 8){
                
            }else{
                
            }
            
            
        });
        
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
}


- (void)beforeActivityMethod:(NSTimer *)time {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *expireDate2;
    //    expireDate2 = [NSDate dateWithTimeIntervalSinceNow:15 * 60];
    if (self.isFromRecharger || self.isFromOpenCard) {
        NSDate *makeOrderTimeDate = [NSDate dateWithTimeIntervalSince1970:[self.myOrder.orderMain.createTime doubleValue]/1000];
        expireDate2 = [makeOrderTimeDate dateByAddingTimeInterval:10 * 60];
    } else {
        NSDate *makeOrderTimeDate = [NSDate dateWithTimeIntervalSince1970:[self.createTime doubleValue]/1000];
        expireDate2 = [makeOrderTimeDate dateByAddingTimeInterval:10 * 60];
    }
    
    //    DLog(@"makeOrderTimeDate ==%@expireDate2 ==%@", makeOrderTimeDate, expireDate2);
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *d = [calendar components:unitFlags
                                      fromDate:[NSDate date]
                                        toDate:expireDate2
                                       options:0]; //计算时间差
    
    if ([d second] < 0) {
        movieTitleLabel.text = @"支付过期";
        
        [movieTitleLabel setNeedsDisplay];
        
        [timer invalidate];
        timer = nil;
        hasOrderExpired = YES;
        confirmBtn.userInteractionEnabled = NO;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action){
                                                                 if (self.isFromRecharger||self.isFromOpenCard) {
                                                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                                                 } else if (self.isFromOrder) {
                                                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                                                     
                                                                 }else{
                                                                     for (UIViewController *ctr in self.navigationController.viewControllers)
                                                                     {
                                                                         if ([ctr isKindOfClass:[XingYiPlanListViewController class]])
                                                                         {
                                                                             Constants.isShowBackBtn = YES;
                                                                             [self.navigationController popToViewController:ctr animated:YES];
                                                                         }
                                                                     }
                                                                     //                                                                     if (self.isFromOrderConfirm) {
                                                                     //                                                                         NSArray *viewControllers = self.navigationController.viewControllers;
                                                                     //
                                                                     //                                                                         [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-6] animated:YES];
                                                                     //                                                                     }else{
                                                                     //                                                                         NSArray *viewControllers = self.navigationController.viewControllers;
                                                                     //
                                                                     //                                                                         [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-4] animated:YES];
                                                                     //                                                                     }
                                                                     
                                                                     
                                                                 }
                                                             }];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的订单已过期，请重新购买" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        
        [self presentViewController:alertVC
                           animated:YES
                         completion:^{
                         }];
        
    } else {
        movieTitleLabel.text = @"距离完成支付还剩10：00";
        confirmBtn.userInteractionEnabled = YES;
        
        //倒计时显示
        //        timerLabel.font = [UIFont boldSystemFontOfSize:16];
        if ([d minute] < 10 && [d second] >= 10) {
            movieTitleLabel.text = [NSString stringWithFormat:@"距离完成支付还剩0%d:%d", (int) [d minute], (int) [d second]];
            
        } else if ([d second] < 10 && [d minute] >= 10) {
            movieTitleLabel.text = [NSString stringWithFormat:@"距离完成支付还剩%d:0%d", (int) [d minute], (int) [d second]];
            
        } else if ([d second] < 10 && [d minute] < 10) {
            movieTitleLabel.text = [NSString stringWithFormat:@"距离完成支付还剩0%d:0%d", (int) [d minute], (int) [d second]];
            
        } else {
            movieTitleLabel.text = [NSString stringWithFormat:@"距离完成支付还剩%d:%d", (int) [d minute], (int) [d second]];
        }
        if ([d second] >= 0 && [d minute] >= 15) {
            movieTitleLabel.text = @"距离完成支付还剩15：00";
        }
        //        DLog(@"movieTitleLabel.text == %@",movieTitleLabel.text);
        [movieTitleLabel setNeedsDisplay];
    }
}

//MARK: 购票成功回调
- (void)alipaySucceed:(NSNotification *)notification {
    [timer invalidate];
    timer = nil;
    confirmBtn.userInteractionEnabled = NO;
    [self refreshPayOrderDetail];
}

- (void)wxSucceed:(NSNotification *)notification {
    [timer invalidate];
    timer = nil;
    confirmBtn.userInteractionEnabled = NO;
    DLog(@"微信支付成功后回调了");
    [self refreshPayOrderDetail];
}

//MARK: 充值成功回调
- (void)alipayChargeSucceed:(NSNotification *)notification {
    [timer invalidate];
    timer = nil;
    confirmBtn.userInteractionEnabled = NO;
    //跳转成功页面
    ChargeSuceessViewController *chargeSuccessVc = [[ChargeSuceessViewController alloc] init];
    [self.navigationController pushViewController:chargeSuccessVc animated:YES];
}

- (void)wxChargeSucceed:(NSNotification *)notification {
    [timer invalidate];
    timer = nil;
    confirmBtn.userInteractionEnabled = NO;
    //跳转成功页面
    ChargeSuceessViewController *chargeSuccessVc = [[ChargeSuceessViewController alloc] init];
    [self.navigationController pushViewController:chargeSuccessVc animated:YES];
}


//
//
//MARK: 开卡成功回调
- (void)alipayOpenCardSucceed:(NSNotification *)notification {
    
    [timer invalidate];
    timer = nil;
    confirmBtn.userInteractionEnabled = NO;
    //查询开卡详情，查状态
    [self refreshPayCardOrderDetail];
}

- (void)wxOpenCardSucceed:(NSNotification *)notification {
    [timer invalidate];
    timer = nil;
    confirmBtn.userInteractionEnabled = NO;
    //查询开卡详情，查状态
    [self refreshPayCardOrderDetail];

}

//
//

#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"PayMethodCell";
    PayMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PayMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.payTypeNum = [[_payMethodList objectAtIndex:indexPath.row] integerValue];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCommonScreenWidth-55, 17, 20, 20)];
    cell.accessoryView = imageView;
    
    if (selectedNum == indexPath.row && selected && !isSame) {
        imageView.image = [UIImage imageNamed:@"list_selected_icon"];
        payMethodType = [[_payMethodList objectAtIndex:indexPath.row] integerValue];
    } else if(selectedNum == indexPath.row && !selected){
        imageView.image = [UIImage imageNamed:@"list_selected_icon"];
        payMethodType = [[_payMethodList objectAtIndex:indexPath.row] integerValue];
    }else{
        imageView.image = [UIImage imageNamed:@""];
        payMethodType = -1;
    }
    [cell updateLayout];
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _payMethodList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectedNum == indexPath.row) {
        isSame = !isSame;
    }else{
        isSame = NO;
    }
    
    if (!isSame) {
        selectedNum = indexPath.row;
        DLog(@"selectedNum%ld",(long)selectedNum);
    }else{
        selectedNum = -1;
        DLog(@"selectedNum%ld",(long)selectedNum);
    }
    
    [payTableView reloadData];
    
}

- (UIView *)getViewBottomLineWithSuperView:(UIView *)superView withTop:(NSInteger)topIndex{
    UIView *viewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, topIndex, kCommonScreenWidth, 0.5)];
    viewBottomLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [superView addSubview:viewBottomLine];
    return viewBottomLine;
}

@end
