//
//  OpenSuccessViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/3/14.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OpenSuccessViewController.h"
//#import "CouponListViewController.h"
#import "CardDetailViewController.h"
#import "KKZTextUtility.h"
#import "VipCardRequest.h"


@interface OpenSuccessViewController ()
{
    UILabel        * titleLabel;
    UIButton       * backButton,*rightBarBtn;

}
@property (nonatomic, strong) UIView  *titleViewOfBar;

@end

@implementation OpenSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hideNavigationBar = YES;
    self.hideBackBtn = YES;
    [self setNavBarUI];
    
    self.couponList = [[NSMutableArray alloc] initWithCapacity:0];
//    cardOpenSuccessLabel2;
//    cardOpenSuccessLabel3;
    if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
        if (self.cardListDetail.product.cardType.intValue == 1 || self.cardListDetail.product.cardType.intValue == 3) {
             self.cardImageView.image = [UIImage imageNamed:@"membercard_xc_1"];
        } else {
             self.cardImageView.image = [UIImage imageNamed:@"membercard_xc_2"];
        }
       
    }
    if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
        self.cardImageView.image = [UIImage imageNamed:@"membercard1"];
    }
    //MARK: 添加约束
    [self addLayoutConstraint];
    
    //MARK: 刷新会员卡详情信息
    [self refreshCardDetailInfo];
    //MARK: 刷新优惠券列表
    [self refreshCouponListInfo];
    
    
    self.cardBuyTicketBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    self.cardBuyTicketBtn.titleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor];
    
}

- (void) refreshCardDetailInfo {
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:[NSString stringWithFormat:@"%@", self.myOrderDetail.orderMain.cardNo] forKey:@"cardNo"];
    
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [requtest requestVipCardDetailParams:params success:^(CardListDetail * _Nullable data) {
        rightBarBtn.hidden = YES;
        DLog(@"会员卡列表：%@", data);
        weakSelf.cardListDetail = data;
        if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
            weakSelf.cardCinemaLogoImageVIew.hidden = YES;
            weakSelf.cardTypeLabel.hidden = YES;
            weakSelf.cardIdTitleLabel.hidden = YES;
            weakSelf.cardIdValueLabel.hidden = YES;
            weakSelf.cardBalanceLabel.hidden = YES;
            weakSelf.cardValidLabel.hidden = YES;
            
            weakSelf.cardNoXClabel.hidden = NO;
            weakSelf.cardTitleXCLabel.hidden = NO;
            weakSelf.cardValidXCLabel.hidden = NO;
            weakSelf.cardBalanXCLabel.hidden = NO;
            
            weakSelf.cardNoXClabel.text = [NSString stringWithFormat:@"%@", weakSelf.cardListDetail.cardNo];
            NSString *cardBalanceValueStr = @"";
            
            if (weakSelf.cardListDetail.product.cardType.intValue == 1 || weakSelf.cardListDetail.product.cardType.intValue == 3) {
                cardBalanceValueStr = [NSString stringWithFormat:@"余额:%.2f元",weakSelf.cardListDetail.cardDetail.balance.floatValue];
                /*
                 *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
                 */
                weakSelf.cardBalanXCLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
            } else {
                weakSelf.cardBalanXCLabel.hidden = YES;
            }
           
            
            
            if (([self.cardListDetail.expireDate containsString:@"天"] || [self.cardListDetail.expireDate containsString:@"月"] ||[self.cardListDetail.expireDate containsString:@"年"])&&(!([self.cardListDetail.expireDate containsString:@"有效期"]))) {
                weakSelf.cardValidXCLabel.text = [NSString stringWithFormat:@"%@有效期", weakSelf.cardListDetail.expireDate];
            } else {
                weakSelf.cardValidXCLabel.text = [NSString stringWithFormat:@"%@", weakSelf.cardListDetail.expireDate];
            }
            
            
        }
        if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
            
#if K_ZHONGDU
            weakSelf.cardCinemaLogoImageVIew.hidden = YES;
#else
            weakSelf.cardCinemaLogoImageVIew.hidden = NO;
#endif
            weakSelf.cardTypeLabel.hidden = NO;
            weakSelf.cardIdTitleLabel.hidden = NO;
            weakSelf.cardIdValueLabel.hidden = NO;
            weakSelf.cardBalanceLabel.hidden = NO;
            weakSelf.cardValidLabel.hidden = NO;
            
            //MARK: 赋值
            weakSelf.cardIdValueLabel.text = [NSString stringWithFormat:@"%@", weakSelf.cardListDetail.cardNo];
            weakSelf.cardTypeLabel.text = [NSString stringWithFormat:@"%@", weakSelf.cardListDetail.useTypeName];
            NSString *cardBalanceValueStr = @"";
            if (weakSelf.cardListDetail.product.cardType.intValue == 1 || weakSelf.cardListDetail.product.cardType.intValue == 3) {
                cardBalanceValueStr = [NSString stringWithFormat:@"余额:%.2f元",weakSelf.cardListDetail.cardDetail.balance.floatValue];
                /*
                 *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
                 */
                weakSelf.cardBalanceLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
            } else {
                weakSelf.cardBalanceLabel.hidden = YES;
            }
            
            if (([self.cardListDetail.expireDate containsString:@"天"] || [self.cardListDetail.expireDate containsString:@"月"] ||[self.cardListDetail.expireDate containsString:@"年"])&&(!([self.cardListDetail.expireDate containsString:@"有效期"]))) {
                weakSelf.cardValidLabel.text = [NSString stringWithFormat:@"%@有效期", weakSelf.cardListDetail.expireDate];
            } else {
                weakSelf.cardValidLabel.text = [NSString stringWithFormat:@"%@", weakSelf.cardListDetail.expireDate];
            }
        }
        
        weakSelf.cardOpenSuccessLabel2.text = [NSString stringWithFormat:@"您已成为%@%@会员", weakSelf.cardListDetail.cinemaName, weakSelf.cardListDetail.useTypeName];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

- (void) refreshCouponListInfo {
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:[NSString stringWithFormat:@"%@", self.myOrderDetail.orderMain.orderCode] forKey:@"orderId"];
    
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [requtest requestVipCardCouponParams:params success:^(NSDictionary * _Nullable data) {
        rightBarBtn.hidden = YES;
        DLog(@"券列表：%@", data);
        if (_couponList.count > 0) {
            [_couponList removeAllObjects];
        }
        [_couponList addObjectsFromArray:[data objectForKey:@"data"]];

        //MARK: 赋值
        weakSelf.cardOpenSuccessLabel3.attributedText = [self getCouponAttributeStr:[NSString stringWithFormat:@"并已获得%lu张优惠券,券已绑定到您的账户内", (unsigned long)_couponList.count]];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        NSDictionary *userInfo = [err userInfo];
        NSDictionary *errInfo = [userInfo kkz_objForKey:@"kkz.error.response"];
        NSString *errStr = [errInfo kkz_stringForKey:@"error"];
        if (errStr.length <= 0) {
            //获取网络状态
            if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0) {
                errStr = @"网络异常，请查看网络是否连接";
            } else {
                errStr = @"获取信息失败";
            }
        }
        [[CIASAlertCancleView new] show:@"温馨提示" message:errStr cancleTitle:@"知道了" callback:^(BOOL confirm) {
            if (!confirm) {
                rightBarBtn.hidden = NO;
            }
        }];
    }];
}

- (NSMutableAttributedString *) getCouponAttributeStr:(NSString *)str {
    NSRange startRange = [str rangeOfString:@"得"];
    NSRange endRange = [str rangeOfString:@"优"];
    NSRange validRange = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#b2b2b2"],NSFontAttributeName:[UIFont systemFontOfSize:13*Constants.screenWidthRate]}];
    [vAttrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#ff9900"] range:validRange];
    return vAttrString;
}

- (void) addLayoutConstraint {
    //MARK: 更新约束
    UIImage *backImage = [UIImage imageNamed:@"membercard_mask"];
    self.cardBackImageWitdh.constant = backImage.size.width*Constants.screenWidthRate;
    self.cardBackImageHeight.constant = backImage.size.height*Constants.screenHeightRate;
    UIImage *cardImage = [UIImage imageNamed:@"membercard1"];
    self.cardImageWitdh.constant = cardImage.size.width*Constants.screenWidthRate;
    self.cardImageHeight.constant = cardImage.size.height*Constants.screenHeightRate;
    if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
        self.cardTitleXCBottom.constant = -6*Constants.screenHeightRate;//-6
        self.cardNoXCLeft.constant = 20*Constants.screenWidthRate;//20
        self.cardNoXCBottom.constant = -15*Constants.screenHeightRate;//-15
        self.cardValidXCRight.constant = -15*Constants.screenWidthRate;//-15
        self.cardValidXCBottom.constant = -15*Constants.screenHeightRate;//-15
        self.cardBalanXCBottom.constant = -6*Constants.screenHeightRate;//-6
    }
    if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
        self.cardLogoLeft.constant = 35*Constants.screenWidthRate;
        self.cardLogoTop.constant = 25*Constants.screenHeightRate;
        self.cardIdTitleTop.constant = 32*Constants.screenHeightRate;
        self.cardTypeTop.constant = 30*Constants.screenHeightRate;
        self.cardTypeRight.constant = -24*Constants.screenWidthRate;
        self.cardIdValueTop.constant = 15*Constants.screenHeightRate;
        self.cardTimeBottom.constant = -20*Constants.screenHeightRate;
        self.cardTimeRight.constant = -25*Constants.screenWidthRate;
    }
    

    self.cardBackImageTop.constant = 10*Constants.screenHeightRate;
    self.cardImageTop.constant = 25*Constants.screenHeightRate;
    self.topViewTop.constant = 68;
    self.topViewHeight.constant = 355*Constants.screenHeightRate;
    self.cardSuccessLabelTop.constant = 20*Constants.screenHeightRate;
    self.cardSuccessLabelTop2.constant = 10*Constants.screenHeightRate;
    self.cardSuccessLabelTop3.constant = 5*Constants.screenHeightRate;
    self.bottomViewHeight.constant = 84*Constants.screenHeightRate;
    self.cardDetailBtnTop.constant = 15*Constants.screenHeightRate;
    self.cardDetailBtnHeight.constant = 42*Constants.screenHeightRate;
    self.cardCouponBtnTop.constant = 15*Constants.screenHeightRate;
    
    self.cardDetailBtn2Right.constant = -15*Constants.screenWidthRate;
    self.cardCouponBtn2Right.constant = -15*Constants.screenWidthRate;
    
    if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
        self.cardNoXClabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
        self.cardTitleXCLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
        self.cardValidXCLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
    }
    if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
        self.cardTypeLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
        self.cardIdTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        self.cardIdValueLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
        self.cardValidLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
    }
    
    self.cardOpenSuccessLabel.font = [UIFont systemFontOfSize:24*Constants.screenWidthRate];
    self.cardOpenSuccessLabel2.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    self.cardOpenSuccessLabel3.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    
}



/**
 *  MARK: 刷新信息
 */
- (void) rightItemInOpenSuccessClick {
    if (self.cardListDetail.cardNo.length > 0) {
    } else {
        [self refreshCardDetailInfo];
    }
    if (_couponList.count == 0) {
        [self refreshCouponListInfo];
    }
}

//MARK: 跳转卡详情
- (IBAction)gotoCardDetail:(UIButton *)sender {
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:[NSString stringWithFormat:@"%@", self.myOrderDetail.orderMain.cardNo] forKey:@"cardNo"];
    
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [requtest requestVipCardDetailParams:params success:^(CardListDetail * _Nullable data) {
        rightBarBtn.hidden = YES;
        DLog(@"会员卡详情：%@", data);
        weakSelf.cardListDetail = data;
        
        CardDetailViewController *cardDetailVc = [[CardDetailViewController alloc] init];
        //加入卡详情数据，再跳转
        cardDetailVc.cardListDetail = weakSelf.cardListDetail;
        [weakSelf.navigationController pushViewController:cardDetailVc animated:YES];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
    
    
}

//MARK: 跳转券列表
- (IBAction)gotoCardCouponList:(UIButton *)sender {
    CouponListViewController *couponVc = [[CouponListViewController alloc] init];
    //在券列表中进行请求，这里只跳转，不用传数据过去
    [self.navigationController pushViewController:couponVc animated:YES];
    
}
//MARK: 跳转首页
- (IBAction)gotoBuyTicketInCard:(UIButton *)sender {
    
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
        [Constants.appDelegate setHomeSelectedTabAtIndex:0];
    }
    
}




- (void)setNavBarUI{
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
    [backButton setImage:[UIImage imageNamed:@"titlebar_close"]
                forState:UIControlStateNormal];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self
                   action:@selector(backItemClick)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    NSString *btnStr = @"刷新";
    CGSize btnStrSize = [KKZTextUtility measureText:btnStr size:CGSizeMake(50, 500) font:[UIFont systemFontOfSize:13]];
    rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarBtn setTitle:btnStr forState:UIControlStateNormal];
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    rightBarBtn.hidden = YES;
    [rightBarBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateNormal];
    rightBarBtn.frame = CGRectMake(kCommonScreenWidth-btnStrSize.width-20, 27.5, btnStrSize.width, btnStrSize.height);
    rightBarBtn.backgroundColor = [UIColor clearColor];
    [rightBarBtn addTarget:self
                    action:@selector(rightItemInOpenSuccessClick)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBarBtn];
    
    [self.view addSubview:self.titleViewOfBar];
    titleLabel.text = [NSString stringWithFormat:@"%@", @"开卡成功"];
    
}
//MARK: 初始化导航栏标题
- (UIView *)titleViewOfBar {
    if (!_titleViewOfBar) {
        NSString *titleStr = @"绑定未来影院通州北苑...";
        CGSize titleStrSize = [KKZTextUtility measureText:titleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18]];
        _titleViewOfBar = [[UIView alloc] initWithFrame:CGRectMake(60, 30, kCommonScreenWidth - 60*2, titleStrSize.height)];
        titleLabel = [[UILabel alloc] init];
        [_titleViewOfBar addSubview:titleLabel];
        
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = titleStr;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width)/2);
            make.top.bottom.equalTo(_titleViewOfBar);
            make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
        }];
    }
    return _titleViewOfBar;
}



/**
 *  MARK: 返回按钮->会员卡列表页
 */
- (void)backItemClick {
    
    #if kIsHuaChenTmpTabbarStyle
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:2];
    #endif
    
    #if kIsSingleCinemaTabbarStyle
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:2];
    #endif
    
    #if kIsXinchengTmpTabbarStyle
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:3];
    #endif
    
    if ([kIsXinchengTabbarStyle isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:4];
    }
    if ([kIsCMSStandardTabbarStyle isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:2];
    }
    
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
