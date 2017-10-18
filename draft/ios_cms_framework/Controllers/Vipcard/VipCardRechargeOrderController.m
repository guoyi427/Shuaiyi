//
//  VipCardRechargeOrderController.m
//  CIASMovie
//
//  Created by avatar on 2017/3/5.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "VipCardRechargeOrderController.h"
#import "DataEngine.h"
#import "VipCardRequest.h"
#import "OrderRequest.h"
#import "DataEngine.h"
#import "PayMethodViewController.h"
#import "KKZTextUtility.h"

@interface VipCardRechargeOrderController ()
{
    
}
@end

@implementation VipCardRechargeOrderController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [timer invalidate];
    timer = nil;
    if (initFirst) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethodInOpenOrder:) userInfo:nil repeats:YES];
    }else{
        [self requestOrderPayInfo];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timer invalidate];
    timer = nil;
    initFirst = YES;
    
}

//下单后根据订单号请求订单信息
- (void)requestOrderPayInfo {
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode", ciasTenantId,@"tenantId",nil];
    [request requestGetOrderInfoParams:pagrams success:^(id _Nullable data) {
        //        [SVProgressHUD dismiss];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        weakSelf.cardOrder = (Order *)data;
        weakSelf.cardSaleMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f", weakSelf.cardOrder.totalPrice.floatValue];
        weakSelf.cardStoreMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f", weakSelf.cardTypeDetail.rechargeMoney.floatValue];
        weakSelf.cardDiscountMoneyLabel.text = [NSString stringWithFormat:@"-¥%.2f",(weakSelf.cardOrder.orderMain.originalPrice.floatValue>=weakSelf.cardOrder.orderMain.receiveMoney.floatValue)/100? ((weakSelf.cardOrder.orderMain.originalPrice.floatValue - weakSelf.cardOrder.orderMain.receiveMoney.floatValue)/100):((weakSelf.cardOrder.orderMain.receiveMoney.floatValue - weakSelf.cardOrder.orderMain.originalPrice.floatValue)/100)];
        [weakSelf.cardPayBtn setTitle:[NSString stringWithFormat:@"总计:¥%.2f 确认支付", weakSelf.cardOrder.orderMain.receiveMoney.floatValue/100] forState:UIControlStateNormal];
        //MARK: 跳转开卡订单确认页面
        [timer invalidate];
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethodInOpenOrder:) userInfo:nil repeats:YES];
        
    } failure:^(NSError * _Nullable err) {
        [timer invalidate];
        timer = nil;
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hideNavigationBar = NO;
    self.hideBackBtn = NO;
    [self setNavBarUI];

    initFirst = NO;
    self.cardPayBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    self.cardPayBtn.titleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor];
    
    if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
        self.cardType.hidden = YES;
        self.cardId.hidden = YES;
        self.cardBalance.hidden = YES;
        self.cardTime.hidden = YES;
        self.cardTitleLabel.hidden = YES;
        self.cardCinemaLogoImageView.hidden = YES;
        
        self.cardTitleXCLabel.hidden = NO;
        self.cardNoValueXCLabel.hidden = NO;
        self.cardBalanXCLabel.hidden = NO;
        self.cardValidXCLabe.hidden = NO;
        
        
        self.cardTitleXCLabel.text = self.cardTypeDetail.cinemaName.length > 0 ? [NSString stringWithFormat:@"%@", self.cardTypeDetail.cinemaName]:@"";
        self.cardNoValueXCLabel.text = self.cardTypeDetail.discountDesc.length > 0 ? [NSString stringWithFormat:@"%@", self.cardTypeDetail.discountDesc]:@"";
        NSString *cardBalanceValueStr = @"";
        if (self.cardTypeDetail.cardType.intValue == 1  || self.cardTypeDetail.cardType.intValue == 3) {
            self.cardImageView.image = [UIImage imageNamed:@"membercard_xc_1"];
        } else {
            self.cardImageView.image = [UIImage imageNamed:@"membercard_xc_2"];
        }
        cardBalanceValueStr = [NSString stringWithFormat:@"售价:%.2f元",self.cardTypeDetail.saleMoney.floatValue];
        /*
         *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
         */
        self.cardBalanXCLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
        
        if (([self.cardTypeDetail.expireDate containsString:@"天"] || [self.cardTypeDetail.expireDate containsString:@"月"] ||[self.cardTypeDetail.expireDate containsString:@"年"])&&(!([self.cardTypeDetail.expireDate containsString:@"有效期"]))) {
            self.cardValidXCLabe.text = [NSString stringWithFormat:@"%@有效期", self.cardTypeDetail.expireDate];
        } else {
            self.cardValidXCLabe.text = [NSString stringWithFormat:@"%@", self.cardTypeDetail.expireDate];
        }
        
    }
    if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
        self.cardType.hidden = NO;
        self.cardId.hidden = NO;
        self.cardBalance.hidden = NO;
        self.cardTime.hidden = NO;
        self.cardTitleLabel.hidden = NO;
        
#if K_ZHONGDU
        self.cardCinemaLogoImageView.hidden = YES;
#else
        self.cardCinemaLogoImageView.hidden = NO;
#endif
        
        self.cardImageView.image = [UIImage imageNamed:@"membercard1"];
        self.cardTitleLabel.text = self.cardTypeDetail.cinemaName.length > 0 ? [NSString stringWithFormat:@"%@", self.cardTypeDetail.cinemaName]:@"";
        self.cardType.text = self.cardTypeDetail.cardTypeName.length > 0 ? [NSString stringWithFormat:@"%@", self.cardTypeDetail.cardTypeName]:@"";
        self.cardId.text = self.cardTypeDetail.discountDesc.length > 0 ? [NSString stringWithFormat:@"%@", self.cardTypeDetail.discountDesc]:@"";
        NSString *cardBalanceValueStr = @"";
        //    if (self.cardTypeDetail.cardType.intValue == 1  || self.cardTypeDetail.cardType.intValue == 3) {
        //        cardBalanceValueStr = [NSString stringWithFormat:@"充值:%.2f元",self.cardTypeDetail.rechargeMoney.floatValue];
        //    } else {
        cardBalanceValueStr = [NSString stringWithFormat:@"售价:%.2f元",self.cardTypeDetail.saleMoney.floatValue];
        //    }
        /*
         *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
         */
        self.cardBalance.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
        
        if (([self.cardTypeDetail.expireDate containsString:@"天"] || [self.cardTypeDetail.expireDate containsString:@"月"] ||[self.cardTypeDetail.expireDate containsString:@"年"])&&(!([self.cardTypeDetail.expireDate containsString:@"有效期"]))) {
            self.cardTime.text = [NSString stringWithFormat:@"%@有效期", self.cardTypeDetail.expireDate];
        } else {
            self.cardTime.text = [NSString stringWithFormat:@"%@", self.cardTypeDetail.expireDate];
        }
    }
    //MARK: 赋值
    
    self.cardValidDateLabel.text = self.cardTypeDetail.expireDate.length > 0 ? [NSString stringWithFormat:@"%@", self.cardTypeDetail.expireDate]:@"";
    self.cardTypeLabel.text = self.cardTypeDetail.cardTypeName.length > 0 ? [NSString stringWithFormat:@"%@", self.cardTypeDetail.cardTypeName]:@"";
    self.cardDiscountLabel.text = self.cardTypeDetail.discountDesc.length > 0 ? [NSString stringWithFormat:@"%@", self.cardTypeDetail.discountDesc]:@"";
    self.cardPhoneLabel.text = [self formatPhoneNum:[DataEngine sharedDataEngine].userName];
    
    
    //MARK: 添加约束进行适配
    [self setLayoutConstaint];
    
}


//MARK: 手机号344格式
- (NSString *)formatPhoneNum:(NSString *)phoneNumStr {
    NSString *str1 = [phoneNumStr substringWithRange:NSMakeRange(0, 3)];
    NSString *str2 = [phoneNumStr substringWithRange:NSMakeRange(3, 4)];
    NSString *str3 = [phoneNumStr substringWithRange:NSMakeRange(7, 4)];
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@", str1, str2, str3];
    return str;
}

- (void) setLayoutConstaint {
    UIImage *cardImage = [UIImage imageNamed:@"membercard1"];
    self.cardImageViewWitdh.constant = cardImage.size.width*Constants.screenWidthRate;
    self.cardImageViewHeight.constant = cardImage.size.height*Constants.screenHeightRate;
    
    UIImage *cardBackImage = [UIImage imageNamed:@"membercard_mask"];
    self.cardBackImageViewWitdh.constant = cardBackImage.size.width*Constants.screenWidthRate;
    self.cardBackImageViewHeight.constant = cardBackImage.size.height*Constants.screenHeightRate;
    
    if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
        self.cardNoXCLeft.constant = 20*Constants.screenWidthRate;//20
        self.cardTitleXCBottom.constant = -6*Constants.screenHeightRate;//6
        self.cardBalanXCRight.constant = -15*Constants.screenWidthRate;//-15
        self.cardNoXCBottom.constant = -15*Constants.screenHeightRate;//6

    }
    if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
        self.cardLogoLeft.constant = 35*Constants.screenWidthRate;
        self.cardTypeTop.constant = 30*Constants.screenHeightRate;
        self.cardTypeRight.constant = -24*Constants.screenWidthRate;
        self.cardTimeBottom.constant = -20*Constants.screenHeightRate;//-20
        self.cardTimeRight.constant = -25*Constants.screenWidthRate;
        self.cardTypeLabelLeft.constant = 15*Constants.screenWidthRate;
        self.cardTypeLabelRight.constant = 15*Constants.screenWidthRate;
    }
    
    self.cardViewHeight.constant = 251*Constants.screenHeightRate;
    self.spaceHeigh.constant = 209*Constants.screenHeightRate;
    self.spaceHeight1.constant = 7*Constants.screenHeightRate;
    self.spaceHeight2.constant = 7*Constants.screenHeightRate;
    self.spaceHeight3.constant = 7*Constants.screenHeightRate;
    self.spaceHeight4.constant = 15*Constants.screenHeightRate;
    self.spaceHeigth5.constant = 15*Constants.screenWidthRate;
    self.spaceHeight6.constant = 15*Constants.screenHeightRate;
    self.spaceHeight7.constant = 7*Constants.screenHeightRate;
    self.spaceHeight8.constant = 7*Constants.screenHeightRate;
    
    self.cardType.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
    self.cardTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    self.cardDiscountLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
    self.cardTime.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
    self.cardTypeTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    self.cardTypeLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    
    self.cardDiscountTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    self.cardDiscountLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    
    self.cardValidTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    self.cardValidDateLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    
    self.cardPhoneTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    self.cardPhoneLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    
    self.cardSaleTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    self.cardSaleMoneyLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    
    self.cardStoreTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    self.cardStoreMoneyLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    
    self.cardDiscountTitleLabel2.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    self.cardDiscountMoneyLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    
    
    self.cardTitleXCLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
    self.cardNoValueXCLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
    self.cardValidXCLabe.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];

}


//MARK: 跳转收银台
//MARK: 把订单改为支付中状态接口
- (void)requestOrderPay:(NSDictionary *)pagrams withPayType:(NSInteger)payType{
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [request requestPayOrderParams:pagrams success:^(NSDictionary *_Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
        if (payType == 9) {
            //查询订单详情
            [[UIConstants sharedDataEngine] loadingAnimation];
            OrderRequest *request = [[OrderRequest alloc] init];
            NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",ciasTenantId,@"tenantId", nil];
            
            [request requestOrderDetailParams:pagrams success:^(id _Nullable data) {
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                Order *myOrder = data;
                PayMethodViewController *ctr = [[PayMethodViewController alloc] init];
                ctr.isFromOpenCard = YES;
                ctr.cardTypeDetail = self.cardTypeDetail;
                ctr.myOrder = myOrder;
                [weakSelf.navigationController pushViewController:ctr animated:YES];
                //主线程刷新，防止闪烁
                dispatch_async(dispatch_get_main_queue(), ^{
                });
            } failure:^(NSError * _Nullable err) {
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                [CIASPublicUtility showAlertViewForTaskInfo:err];
                
            }];
            
            
        }
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
        
    }];
    
}

//订单10分钟倒计时
- (void)beforeActivityMethodInOpenOrder:(NSTimer *)time {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *expireDate2;
    
    //    expireDate2 = [NSDate dateWithTimeIntervalSinceNow:15 * 60];
    
    NSDate *makeOrderTimeDate = [NSDate dateWithTimeIntervalSince1970:[self.cardOrder.orderMain.createTime doubleValue]/1000];
    expireDate2 = [makeOrderTimeDate dateByAddingTimeInterval:10 * 60];
    
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
        self.cardPayBtn.userInteractionEnabled = NO;
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action){
                                                                     NSArray *viewControllers = self.navigationController.childViewControllers;
                                                                     
                                                                     [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-3] animated:YES];
                                                                
                                                             }];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"订单支付已超时!\n您本次购买会员卡的订单已自动取消\n请重新购买会员卡" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        
        [self presentViewController:alertVC
                           animated:YES
                         completion:^{
                         }];
        
    } else {
        movieTitleLabel.text = @"距离完成支付还剩10：00";
        self.cardPayBtn.userInteractionEnabled = YES;
        
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

- (void)setNavBarUI{
    /*
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 69)];
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor]]
             forBarPosition:UIBarPositionAny
                 barMetrics:UIBarMetricsDefault];
    [self.view addSubview:bar];
    bar.alpha = 1.0;
    self.navBar = bar;
    UIView *barLine = [[UIView alloc]initWithFrame:CGRectMake(0, 68.5, kCommonScreenWidth, 0.5)];
    barLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [bar addSubview:barLine];
    
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
    */
    UIView * customTitleView = [[UIView alloc] initWithFrame:CGRectMake(70, 20, kCommonScreenWidth-140, 44)];
    customTitleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:customTitleView];
    self.navigationItem.titleView = customTitleView;
    cinemaTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth-140, 20)];
    cinemaTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    cinemaTitleLabel.textAlignment = NSTextAlignmentCenter;
    cinemaTitleLabel.text = @"支付订单";
    cinemaTitleLabel.font = [UIFont systemFontOfSize:16];
    [customTitleView addSubview:cinemaTitleLabel];
//    [cinemaTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(7));
//        make.left.equalTo(@(0));
//        make.right.equalTo(customTitleView.mas_right).offset(0);
//        make.height.equalTo(@(15));
//    }];
    
    movieTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, kCommonScreenWidth-140, 20)];
    movieTitleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor];
    movieTitleLabel.textAlignment = NSTextAlignmentCenter;
    movieTitleLabel.font = [UIFont systemFontOfSize:13];
    [customTitleView addSubview:movieTitleLabel];
//    [movieTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(cinemaTitleLabel.mas_bottom).offset(5);
//        make.left.equalTo(@(0));
//        make.right.equalTo(customTitleView.mas_right).offset(0);
//        make.height.equalTo(@(13));
//    }];
    
}



- (IBAction)cardPayAction:(UIButton *)sender {
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",ciasTenantId,@"tenantId", @"9",@"payType", nil];
    [self requestOrderPay:pagrams withPayType:9];
}





/**
 *  MARK: 返回按钮
 */
- (void)backAction{
//- (void)backItemClick {

    if (timer.isValid) {
        [timer invalidate];
        timer = nil;
    }
    NSArray *viewControllers = self.navigationController.childViewControllers;
    [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-3] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
