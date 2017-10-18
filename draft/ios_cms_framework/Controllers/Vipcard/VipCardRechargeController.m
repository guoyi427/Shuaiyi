//
//  VipCardRechargeController.m
//  CIASMovie
//
//  Created by avatar on 2017/3/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "VipCardRechargeController.h"
#import "KKZTextUtility.h"
#import "RPRingedPages.h"
#import "VipCardRequest.h"
#import "VipCardListDetail.h"
#import "VipCard.h"
#import "VipCardRechargeOrderController.h"
#import "OrderRequest.h"
#import "PayMethodViewController.h"
#import "KKZTextUtility.h"
#import "DataEngine.h"
#import "DCPicScrollView.h"

@interface VipCardRechargeController ()<RPRingedPagesDelegate, RPRingedPagesDataSource,DCPicScrollViewDelegate>
{
    UILabel        *titleLabel;
    UIImageView    *backImageView;
    UICollectionView *vipCardCollectionView;
    UIView           *cardValueHeaderView,*chargeValueView,*cardDiscountView;//*cardView,
    UILabel *cardTitleLabel,*cardValueLabel,*cardTypeLabel,*cardBalanceValueLabel,*cardValidTimeLabel;
    UILabel *youHuiValueLabel;
    UILabel *shiFuValueLabel;
    UIImageView *cardImageView,*cardLogoImageView;
    UITableView *cardValueTableView;
    DCPicScrollView *picView;
}

@property (nonatomic, strong) UIView    *titleViewOfBar;
@property (nonatomic, copy)   NSString  *orderNo;
@property (nonatomic, strong) UIView *noCardListAlertView;

@property (nonatomic, strong) RPRingedPages *pages;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *cardRecargeValueArr;
@property (nonatomic, strong) NSMutableDictionary *cardRecargeValueSelectedDic;
@property (nonatomic, strong) NSMutableArray *myStoreCardList;
@property (nonatomic, strong) VipCard *selectVipCard;



@end

@implementation VipCardRechargeController

- (void)dealloc {

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //MARK: 请求卡列表，请求充值金额
    [self requestStoreVipCardListInRechargeView];
#if K_HENGDIAN
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.navigationController.view addGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
}

//获取储值卡列表
- (void)requestStoreVipCardListInRechargeView{
    [[UIConstants sharedDataEngine] loadingAnimation];
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [requtest requestStoreVipCardListParams:nil success:^(NSDictionary * _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        VipCardListDetail *detail = (VipCardListDetail *)data;
        if (weakSelf.dataSource.count > 0) {
            [weakSelf.dataSource removeAllObjects];
        }
        [weakSelf.dataSource addObjectsFromArray:detail.rows];
        DLog(@"%@", weakSelf.dataSource);
        //MARK: 如果从卡详情进入的话，那么得交换卡列表的元素，把传入的卡号放在0角标下
        if (weakSelf.dataSource.count > 1) {
            //只有一张，不用处理
            for (int i = 0; i<weakSelf.dataSource.count; i++) {
                VipCard *vipcard = (VipCard *)[weakSelf.dataSource objectAtIndex:i];
                if ([vipcard.cardNo isEqualToString:weakSelf.cardNo]) {
                    if (i == 0) {
                        // 选中的就是第一张卡，不用处理
                    } else {
                        //选中的不是第一张卡，与第一张卡交换位置
                        [weakSelf.dataSource exchangeObjectAtIndex:0 withObjectAtIndex:i];
                    }
                    
                }
            }
        }
        DLog(@"%@", weakSelf.dataSource);

        if (weakSelf.dataSource.count>0) {
            if (weakSelf.noCardListAlertView.superview) {
                [weakSelf.noCardListAlertView removeFromSuperview];
            }
            VipCard *vipcard = (VipCard *)[weakSelf.dataSource objectAtIndex:0];
            weakSelf.selectVipCard = vipcard;
            //MARK: 查询充值套餐 并展示
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
            [params setValue:[NSString stringWithFormat:@"%d",vipcard.cinemaId.intValue] forKey:@"cinemaId"];
            [params setValue:vipcard.cardNo forKey:@"cardNo"];
            
            [[UIConstants sharedDataEngine] loadingAnimation];
            VipCardRequest *requtest = [[VipCardRequest alloc] init];
            [requtest requestVipCardRechargeValueParams:params success:^(NSDictionary * _Nullable data) {
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                if (data && [data isKindOfClass:[NSDictionary class]]) {
                    NSArray *tmpArr = [data objectForKey:@"data"];
                    if (weakSelf.cardRecargeValueArr.count > 0) {
                        [weakSelf.cardRecargeValueArr removeAllObjects];
                    }
                    [weakSelf.cardRecargeValueArr addObjectsFromArray:tmpArr];
                    if (weakSelf.cardRecargeValueArr.count > 0) {
                        
                        if (chargeValueView) {
                            [chargeValueView removeFromSuperview];
                            chargeValueView = nil;
                        }
                        if (cardDiscountView) {
                            [cardDiscountView removeFromSuperview];
                            cardDiscountView = nil;
                        }
                        chargeValueView = [[UIView alloc] init];
                        [cardValueHeaderView addSubview:chargeValueView];
                        cardDiscountView = [[UIView alloc] init];
                        [cardValueHeaderView addSubview:cardDiscountView];
                        [weakSelf initChargeView];
                        [weakSelf initDiscountView];
                    }
                }
                
                
            } failure:^(NSError * _Nullable err) {
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                [CIASPublicUtility showAlertViewForTaskInfo:err];
            }];
            
        }else{
            if (weakSelf.noCardListAlertView.superview) {
            }else{
                [weakSelf.view addSubview:weakSelf.noCardListAlertView];
            }
        }
        [weakSelf.pages reloadData];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#f2f4f5"];
    self.hideNavigationBar = NO;
    self.hideBackBtn = YES;
    [self setUpNavBar];
    
    self.cardRecargeValueArr = [[NSMutableArray alloc] initWithCapacity:0];
    self.myStoreCardList     = [[NSMutableArray alloc] initWithCapacity:0];
    self.cardRecargeValueSelectedDic = [[NSMutableDictionary alloc] init];
    
    
    
    //创建顶部视图
    UIImage *backImage = [UIImage imageNamed:@"membercard_mask"];
    backImageView = [[UIImageView alloc] init];
    [self.view addSubview:backImageView];
    backImageView.image = backImage;
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset((kCommonScreenWidth - backImage.size.width*Constants.screenWidthRate)/2);
        make.top.equalTo(self.view.mas_top).offset(11*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(backImage.size.width*Constants.screenWidthRate, backImage.size.height*Constants.screenHeightRate));
    }];
    
    //MARK: 添加卡信息view
//    UIImage *cardImage = [UIImage imageNamed:@"membercard1"];
//    picView = [[DCPicScrollView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, (cardImage.size.height + 30)*Constants.screenHeightRate) WithImageNames:self.dataSource withIsFill:NO];
//    picView.delegate = self;
//    [self.view addSubview:picView];
    [self.view addSubview:self.pages];
    
    UIView *line1View = [[UIView alloc] init];
    [self.view addSubview:line1View];
    line1View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(backImageView.mas_bottom).offset(15*Constants.screenHeightRate);
        make.height.equalTo(@(0.5*Constants.screenHeightRate));
    }];
    //MARK: 添加充值金额选项view
    cardValueTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (260*Constants.screenHeightRate), kCommonScreenWidth, kCommonScreenHeight-(260*Constants.screenHeightRate)) style:UITableViewStylePlain];
    cardValueTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:cardValueTableView];
    cardValueTableView.backgroundColor = [UIColor clearColor];
    
    //MARK: 充值金额，优惠信息 view
    cardValueHeaderView = [[UIView alloc] init];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame= CGRectMake(0, kCommonScreenHeight - 50 - 64, kCommonScreenWidth, 50);
    [submitBtn setBackgroundColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor]];
    [submitBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
    [submitBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    
    //    [self makeDataSource];
    //    [self.pages reloadData];
    
    
    
    UIImage *noOrderAlertImage = [UIImage imageNamed:@"empty"];
    NSString *noOrderAlertStr = @"还没有储值卡哦~";
    CGSize noOrderAlertStrSize = [KKZTextUtility measureText:noOrderAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15]];
    self.noCardListAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight - 64)];
    self.noCardListAlertView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    UIImageView *noOrderAlertImageView = [[UIImageView alloc] init];
    [self.noCardListAlertView addSubview:noOrderAlertImageView];
    noOrderAlertImageView.image = noOrderAlertImage;
    noOrderAlertImageView.contentMode = UIViewContentModeScaleAspectFill;
    [noOrderAlertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noCardListAlertView.mas_left).offset(106*Constants.screenWidthRate);
        make.right.equalTo(self.noCardListAlertView.mas_right).offset(-(106*Constants.screenWidthRate));
        make.top.equalTo(self.noCardListAlertView.mas_top).offset(185*Constants.screenHeightRate);
        make.height.equalTo(@(noOrderAlertImage.size.height));
    }];
    UILabel *noOrderAlertLabel = [[UILabel alloc] init];
    [self.noCardListAlertView addSubview:noOrderAlertLabel];
    noOrderAlertLabel.text = noOrderAlertStr;
    noOrderAlertLabel.font = [UIFont systemFontOfSize:15];
    noOrderAlertLabel.textAlignment = NSTextAlignmentCenter;
    noOrderAlertLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    [noOrderAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.noCardListAlertView.mas_left).offset(0);
        make.right.equalTo(self.noCardListAlertView.mas_right).offset(0);
        make.top.equalTo(noOrderAlertImageView.mas_bottom).offset(15);
        make.height.equalTo(@(noOrderAlertStrSize.height));
    }];
    
}

- (void)getChargeMoneyValuesWith:(NSString *)cardNo andCinemaId:(NSString *)cinemaIdStr {
    //    //MARK: 查询充值套餐 并展示
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:cinemaIdStr forKey:@"cinemaId"];
    [params setValue:cardNo forKey:@"cardNo"];

    [[UIConstants sharedDataEngine] loadingAnimation];
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [requtest requestVipCardRechargeValueParams:params success:^(NSDictionary * _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSArray *tmpArr = [data objectForKey:@"data"];
            if (weakSelf.cardRecargeValueArr.count > 0) {
                [weakSelf.cardRecargeValueArr removeAllObjects];
            }
            [weakSelf.cardRecargeValueArr addObjectsFromArray:tmpArr];
            if (weakSelf.cardRecargeValueArr.count > 0) {
                if (chargeValueView) {
                    [chargeValueView removeFromSuperview];
                    chargeValueView = nil;
                }
                if (cardDiscountView) {
                    [cardDiscountView removeFromSuperview];
                    cardDiscountView = nil;
                }
                chargeValueView = [[UIView alloc] init];
                [cardValueHeaderView addSubview:chargeValueView];
                cardDiscountView = [[UIView alloc] init];
                [cardValueHeaderView addSubview:cardDiscountView];
                [weakSelf initChargeView];
                [weakSelf initDiscountView];
            }
        }


    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
}

- (void)backToRootViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//MARK: 立即充值
- (void)submitAction:(UIButton *)button {
    //MARK: 直接调会员卡充值接口，不用跳转下一个页面
    if ([[self.cardRecargeValueSelectedDic kkz_stringForKey:@"rechargeMoney"] intValue]== 0) {
        [[CIASAlertCancleView new] show:@"提示" message:@"请选择充值套餐" cancleTitle:@"知道了" callback:^(BOOL confirm) {
        }];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:[NSString stringWithFormat:@"%d",self.selectVipCard.cinemaId.intValue] forKey:@"cinemaId"];
    [params setValue:self.selectVipCard.cardNo forKey:@"cardNo"];
    [params setValue:@"4" forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%d",[[self.cardRecargeValueSelectedDic kkz_stringForKey:@"id"] intValue]] forKey:@"rechargeId"];
    [params setValue:[DataEngine sharedDataEngine].userName forKey:@"memberMobile"];

//
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [requtest requestVipCardRechargeOrderParams:params success:^(NSDictionary * _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSString *statusStr = [NSString stringWithFormat:@"%@",[data kkz_stringForKey:@"status"]];
            if ([statusStr isEqualToString:@"0"]) {
                //获取订单号
                weakSelf.orderNo = [NSString stringWithFormat:@"%@",[data kkz_stringForKey:@"data"]];
                NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:weakSelf.orderNo,@"orderCode",ciasTenantId,@"tenantId", @"9",@"payType", nil];
                [weakSelf requestOrderPay:pagrams withPayType:9];
            }
        }
        
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
    //    VipCardRechargeOrderController *vipCardRechargeOrderVC = [[VipCardRechargeOrderController alloc] init];
    //    vipCardRechargeOrderVC.cardRecargeValueSelectedDic = self.cardRecargeValueSelectedDic;
    //    vipCardRechargeOrderVC.vipcard = self.selectVipCard;
    //    [self.navigationController pushViewController:vipCardRechargeOrderVC animated:YES];
}



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
        }
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
        
    }];
    
}

- (void)getData {
    NSArray *valueArr = @[@"100", @"200", @"300", @"400", @"500", @"600", @"1000"];
    NSArray *saleValueArr = @[@"98", @"192", @"286", @"380", @"476", @"560", @"960"];
    for (int i = 0; i < valueArr.count; i++) {
        
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] init];
        [dataDic setObject:[valueArr objectAtIndex:i] forKey:@"value"];
        [dataDic setObject:[saleValueArr objectAtIndex:i] forKey:@"saleValue"];
        [self.cardRecargeValueArr addObject:dataDic];
    }
}

- (void)initChargeView {
    //    CGFloat chargeViewHeight = 52 * Constants.screenWidthRate;
    chargeValueView.backgroundColor = [UIColor whiteColor];
    UILabel *chargeTitleLabel = [[UILabel alloc] init];
    chargeTitleLabel.text = @"请选择充值金额";
    chargeTitleLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    chargeTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    [chargeValueView addSubview:chargeTitleLabel];
    CGSize chargeTitleStrSize = [KKZTextUtility measureText:chargeTitleLabel.text size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    chargeTitleLabel.frame = CGRectMake((kCommonScreenWidth - chargeTitleStrSize.width - 5) / 2, 20*Constants.screenWidthRate, chargeTitleStrSize.width + 5, chargeTitleStrSize.height);
    
    CGFloat btnWidth = 70 * Constants.screenWidthRate;
    CGFloat btnHeight = 50 * Constants.screenHeightRate;
    CGFloat sep = 10*Constants.screenWidthRate;
    CGFloat origiX = (kCommonScreenWidth - btnWidth * 4 - sep * 3) / 2;
    CGFloat origiY = 52 * Constants.screenHeightRate;
    
    for (int i = 0 ; i < self.cardRecargeValueArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 100;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
        btn.layer.borderColor = [UIColor colorWithHex:@"#e0e0e0"].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        NSMutableDictionary *dic = [self.cardRecargeValueArr objectAtIndex:i];
        
        NSString *btnStr = [NSString stringWithFormat:@"%@元\n售价:%@元", [dic valueForKey:@"rechargeMoney"],  [dic valueForKey:@"saleMoney"]];
        NSMutableAttributedString * normalAttStr = [self getChargeValueStrWithString:btnStr withFormalColor:[UIColor colorWithHex:@"#333333"] withColor:[UIColor colorWithHex:@"#ff9900"]];
        btn.titleLabel.numberOfLines = 2;
        [btn setAttributedTitle:normalAttStr forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(i % 4 * (btnWidth + sep) + origiX, i / 4 * (btnHeight + sep) + origiY, btnWidth, btnHeight);
        [chargeValueView addSubview:btn];
    }
    origiY += ((self.cardRecargeValueArr.count- 1) / 4 + 1)* (btnHeight+ sep) + 10;
    
    UIView *line1View = [[UIView alloc] init];
    line1View.frame = CGRectMake(0, origiY, kCommonScreenWidth, 0.5);
    line1View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [chargeValueView addSubview:line1View];
    chargeValueView.frame = CGRectMake(0, 0,kCommonScreenWidth, origiY);
    
    
}

- (NSMutableAttributedString *)getChargeValueStrWithString:(NSString *)chargeValueStr withFormalColor:(UIColor *)formalColor withColor:(UIColor *)color {
    
    NSMutableAttributedString *vAttrString = [[NSMutableAttributedString alloc] initWithString:chargeValueStr attributes:@{NSForegroundColorAttributeName:formalColor,NSFontAttributeName:[UIFont systemFontOfSize:10*Constants.screenWidthRate]}];
    NSArray *strArray = [chargeValueStr componentsSeparatedByString:@"\n"];
    NSString *origiStr = [strArray objectAtIndex:0];
    //原价颜色
    [vAttrString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,origiStr.length)];
    
    //原价字体大小
    NSRange range = [[strArray objectAtIndex:0] rangeOfString:@"元"];
    [vAttrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18*Constants.screenWidthRate] range:NSMakeRange(0,range.location)];
    return vAttrString;
}
- (void)selectedAction:(UIButton *)button {
    
    for (int i = 0; i < self.cardRecargeValueArr.count; i++) {
        UIButton *btn = (UIButton *)[chargeValueView viewWithTag:i + 100];
        NSMutableDictionary *dic = [self.cardRecargeValueArr objectAtIndex:i];
        NSString *btnStr = [NSString stringWithFormat:@"%@元\n售价:%@元", [dic valueForKey:@"rechargeMoney"],  [dic valueForKey:@"saleMoney"]];
        if (i + 100 != button.tag) {
            btn.backgroundColor = [UIColor whiteColor];
            btn.layer.borderWidth = 0.5;
            NSMutableAttributedString * normalAttStr = [self getChargeValueStrWithString:btnStr withFormalColor:[UIColor colorWithHex:@"#333333"] withColor:[UIColor colorWithHex:@"#ff9900"]];
            [btn setAttributedTitle:normalAttStr forState:UIControlStateNormal];
            
        } else {
            NSMutableAttributedString * selectedAttStr = [self getChargeValueStrWithString:btnStr withFormalColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] withColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor]];
            [btn setAttributedTitle:selectedAttStr forState:UIControlStateNormal];
            button.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
            button.layer.borderWidth = 0;
            self.cardRecargeValueSelectedDic = dic;
            youHuiValueLabel.text = [NSString stringWithFormat:@"-¥%.2f", [[dic valueForKey:@"rechargeMoney"] floatValue]-[[dic valueForKey:@"saleMoney"] floatValue]];
            shiFuValueLabel.text = [NSString stringWithFormat:@"¥%.2f", [[dic valueForKey:@"saleMoney"] floatValue]];
        }
    }
}

- (void)initDiscountView {
    UIView *line1View = [[UIView alloc] init];
    line1View.frame = CGRectMake(0, 0, kCommonScreenWidth, 0.5);
    line1View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [cardDiscountView addSubview:line1View];
    cardDiscountView.backgroundColor = [UIColor whiteColor];
    
    cardDiscountView.frame = CGRectMake(0, CGRectGetMaxY(chargeValueView.frame) + 5,kCommonScreenWidth, 64);
    UILabel *youHuiLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 50, 13)];
    youHuiLabel.text = @"优惠:";
    youHuiLabel.textAlignment = NSTextAlignmentLeft;
    youHuiLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    youHuiLabel.font = [UIFont systemFontOfSize:13];
    [cardDiscountView addSubview:youHuiLabel];
    
    UILabel *shiFuLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(youHuiLabel.frame) + 10, 50, 13)];
    shiFuLabel.text = @"实付:";
    shiFuLabel.textAlignment = NSTextAlignmentLeft;
    shiFuLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    shiFuLabel.font = [UIFont systemFontOfSize:13];
    [cardDiscountView addSubview:shiFuLabel];
    
    youHuiValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCommonScreenWidth - 165, 15, 150, 13)];
    youHuiValueLabel.textAlignment = NSTextAlignmentRight;
    youHuiValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
    youHuiValueLabel.font = [UIFont systemFontOfSize:13];
    [cardDiscountView addSubview:youHuiValueLabel];
    
    shiFuValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kCommonScreenWidth - 165, CGRectGetMaxY(youHuiValueLabel.frame) + 10, 150, 13)];
    shiFuValueLabel.textAlignment = NSTextAlignmentRight;
    shiFuValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
    shiFuValueLabel.font = [UIFont systemFontOfSize:13];
    [cardDiscountView addSubview:shiFuValueLabel];
    
    UIView *line2View = [[UIView alloc] init];
    line2View.frame = CGRectMake(0, 63.5, kCommonScreenWidth, 0.5);
    line2View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [cardDiscountView addSubview:line2View];
    
    cardValueHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, CGRectGetHeight(chargeValueView.frame) + 100);
    cardValueTableView.tableHeaderView = cardValueHeaderView;
}

- (NSInteger)numberOfItemsInRingedPages:(RPRingedPages *)pages {
    return self.dataSource.count;
}

- (void)didSelectedCurrentPageInPages:(RPRingedPages *)pages {
    DLog(@"pages selected, the current index is %zd", pages.currentIndex);
}
- (void)pages:(RPRingedPages *)pages didScrollToIndex:(NSInteger)index {
    VipCard *vipcard = (VipCard *)[self.dataSource objectAtIndex:index];
    DLog(@"pages scrolled to index: %zd\n %zd %@", index, pages.carousel.currentIndex,vipcard.cardNo);

    self.selectVipCard = vipcard;
    //MARK: 查询充值套餐 并展示
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:[NSString stringWithFormat:@"%d",vipcard.cinemaId.intValue] forKey:@"cinemaId"];
    [params setValue:vipcard.cardNo forKey:@"cardNo"];
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [requtest requestVipCardRechargeValueParams:params success:^(NSDictionary * _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            NSArray *tmpArr = [data objectForKey:@"data"];
            if (weakSelf.cardRecargeValueArr.count > 0) {
                [weakSelf.cardRecargeValueArr removeAllObjects];
            }
            [weakSelf.cardRecargeValueArr addObjectsFromArray:tmpArr];
            if (weakSelf.cardRecargeValueArr.count > 0) {
                if (chargeValueView) {
                    [chargeValueView removeFromSuperview];
                    chargeValueView = nil;
                }
                if (cardDiscountView) {
                    [cardDiscountView removeFromSuperview];
                    cardDiscountView = nil;
                }
                chargeValueView = [[UIView alloc] init];
                [cardValueHeaderView addSubview:chargeValueView];
                cardDiscountView = [[UIView alloc] init];
                [cardValueHeaderView addSubview:cardDiscountView];
                [weakSelf initChargeView];
                [weakSelf initDiscountView];
            }
        }
        
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
}

- (UIView *)ringedPages:(RPRingedPages *)pages viewForItemAtIndex:(NSInteger)index {
    UIView *cardView = (UIView *)[pages dequeueReusablePage];
    VipCard *vipcard = (VipCard *)[self.dataSource objectAtIndex:index];

    if (![cardView isKindOfClass:[UIView class]]) {

        cardView = [UIView new];
        if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
            UIImage *cardImage = nil;
            if (vipcard.useType.intValue == 1 || vipcard.useType.intValue == 3) {
                cardImage = [UIImage imageNamed:@"membercard_xc_1"];
            } else {
                cardImage = [UIImage imageNamed:@"membercard_xc_2"];
            }
            cardImageView = [[UIImageView alloc] init];
            [cardView addSubview:cardImageView];
            [cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cardView);
            }];
            cardImageView.image = cardImage;
            
            //卡图片上的logo
            UIImage *cardLogoImage = [UIImage imageNamed:@"cinema_logo"];
            cardLogoImageView = [[UIImageView alloc] init];
            [cardImageView addSubview:cardLogoImageView];
            [cardLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(25*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardLogoImage.size.width*Constants.screenWidthRate, cardLogoImage.size.height*Constants.screenHeightRate));
            }];
            cardLogoImageView.image = cardLogoImage;
            cardLogoImageView.hidden = YES;
            
            NSString *cardTypeStr = @"储值卡";
            CGSize cardTypeStrSize = [KKZTextUtility measureText:cardTypeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardTypeLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardTypeLabel];
            cardTypeLabel.text = cardTypeStr;
            cardTypeLabel.textColor = [UIColor colorWithHex:@"#333333"];
            cardTypeLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
            [cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-19*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(30*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTypeStrSize.width+5, cardTypeStrSize.height));
            }];
            cardTypeLabel.hidden = YES;
            //
            NSString *cardValueStr = @"6227123123123123123";
            CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardValueLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardValueLabel];
            cardValueLabel.text = cardValueStr;
            cardValueLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValueLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
            [cardValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(20*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageView.mas_bottom).offset(-15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValueStrSize.width+10, cardValueStrSize.height));
            }];
            cardValueLabel.hidden = NO;
            
            //卡图片上的卡号
            NSString *cardTitleStr = @"卡号";
            CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            cardTitleLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardTitleLabel];
            cardTitleLabel.text = cardTitleStr;
            cardTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
            [cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(20*Constants.screenWidthRate);
                make.bottom.equalTo(cardValueLabel.mas_top).offset(-6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
            }];
            cardTitleLabel.hidden = NO;
            
            NSString *cardValidTimeStr = @"2016-12-11至2016-12-12";
            CGSize cardValidTimeStrSize = [KKZTextUtility measureText:cardValidTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            cardValidTimeLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardValidTimeLabel];
            //MARK: 如果没有有效期则隐藏
            cardValidTimeLabel.hidden = NO;
            cardValidTimeLabel.text = cardValidTimeStr;
            cardValidTimeLabel.textAlignment = NSTextAlignmentRight;
            cardValidTimeLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValidTimeLabel.font = [UIFont systemFontOfSize:10];
            [cardValidTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-15*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageView.mas_bottom).offset(-15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValidTimeStrSize.width+5, cardValidTimeStrSize.height));
            }];
            
            NSString *cardBalanceValueStr = @"余额：10050.00元";
            CGSize cardBalanceValueStrSize = [KKZTextUtility measureText:cardBalanceValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            cardBalanceValueLabel = [[UILabel alloc] init];
            cardBalanceValueLabel.textAlignment = NSTextAlignmentRight;
            [cardImageView addSubview:cardBalanceValueLabel];
            //MARK: 如果没有余额则隐藏
            /*
             *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
             */
            cardBalanceValueLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
            [cardBalanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-15*Constants.screenWidthRate);
                make.bottom.equalTo(cardValidTimeLabel.mas_top).offset(-6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardBalanceValueStrSize.width+5, cardBalanceValueStrSize.height));
            }];
            cardBalanceValueLabel.hidden = NO;
            
            
        }
        if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
            UIImage *cardImage = [UIImage imageNamed:@"membercard1"];
            cardImageView = [[UIImageView alloc] init];
            [cardView addSubview:cardImageView];
            [cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cardView);
            }];
            cardImageView.image = cardImage;
            
            //卡图片上的logo
            UIImage *cardLogoImage = [UIImage imageNamed:@"cinema_logo"];
            cardLogoImageView = [[UIImageView alloc] init];
            [cardImageView addSubview:cardLogoImageView];
            [cardLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(25*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardLogoImage.size.width*Constants.screenWidthRate, cardLogoImage.size.height*Constants.screenHeightRate));
            }];
            cardLogoImageView.image = cardLogoImage;
            
#if K_ZHONGDU
            cardLogoImageView.hidden = YES;
#else
            cardLogoImageView.hidden = NO;
#endif
            NSString *cardTypeStr = @"储值卡";
            CGSize cardTypeStrSize = [KKZTextUtility measureText:cardTypeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardTypeLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardTypeLabel];
            cardTypeLabel.text = cardTypeStr;
            cardTypeLabel.textColor = [UIColor colorWithHex:@"#333333"];
            cardTypeLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
            [cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-19*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(30*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTypeStrSize.width+5, cardTypeStrSize.height));
            }];
            cardTypeLabel.hidden = NO;
            //
            //卡图片上的卡号
            NSString *cardTitleStr = @"卡号";
            CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            cardTitleLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardTitleLabel];
            cardTitleLabel.text = cardTitleStr;
            cardTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
            [cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardLogoImageView.mas_bottom).offset(32*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
            }];
            cardTitleLabel.hidden = NO;
            
            NSString *cardValueStr = @"6227123123123123123";
            CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            cardValueLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardValueLabel];
            cardValueLabel.text = cardValueStr;
            cardValueLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValueLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
            [cardValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardTitleLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake((cardImage.size.width - 35)*Constants.screenWidthRate, cardValueStrSize.height));
            }];
            cardValueLabel.hidden = NO;
            
            NSString *cardBalanceValueStr = @"余额：10050.00元";
            CGSize cardBalanceValueStrSize = [KKZTextUtility measureText:cardBalanceValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            cardBalanceValueLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardBalanceValueLabel];
            //MARK: 如果没有余额则隐藏
            /*
             *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
             */
            cardBalanceValueLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
            [cardBalanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardValueLabel.mas_bottom).offset(28*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardBalanceValueStrSize.width+5, cardBalanceValueStrSize.height));
            }];
            cardBalanceValueLabel.hidden = NO;
            
            NSString *cardValidTimeStr = @"2016-12-11至2016-12-12";
            CGSize cardValidTimeStrSize = [KKZTextUtility measureText:cardValidTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            cardValidTimeLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardValidTimeLabel];
            //MARK: 如果没有有效期则隐藏
            cardValidTimeLabel.hidden = NO;
            cardValidTimeLabel.text = cardValidTimeStr;
            cardValidTimeLabel.textAlignment = NSTextAlignmentRight;
            cardValidTimeLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValidTimeLabel.font = [UIFont systemFontOfSize:10];
            [cardValidTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-25*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageView.mas_bottom).offset(-23*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValidTimeStrSize.width+5, cardValidTimeStrSize.height));
            }];
        }
        
        
    } else {
        if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
            UIImage *cardImage = nil;
            if (vipcard.useType.intValue == 1 || vipcard.useType.intValue == 3) {
                cardImage = [UIImage imageNamed:@"membercard_xc_1"];
            } else {
                cardImage = [UIImage imageNamed:@"membercard_xc_2"];
            }
            cardImageView = [[UIImageView alloc] init];
            [cardView addSubview:cardImageView];
            [cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cardView);
            }];
            cardImageView.image = cardImage;
            
            //卡图片上的logo
            UIImage *cardLogoImage = [UIImage imageNamed:@"cinema_logo"];
            cardLogoImageView = [[UIImageView alloc] init];
            [cardImageView addSubview:cardLogoImageView];
            [cardLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(25*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardLogoImage.size.width*Constants.screenWidthRate, cardLogoImage.size.height*Constants.screenHeightRate));
            }];
            cardLogoImageView.image = cardLogoImage;
            cardLogoImageView.hidden = YES;
            
            NSString *cardTypeStr = @"储值卡";
            CGSize cardTypeStrSize = [KKZTextUtility measureText:cardTypeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardTypeLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardTypeLabel];
            cardTypeLabel.text = cardTypeStr;
            cardTypeLabel.textColor = [UIColor colorWithHex:@"#333333"];
            cardTypeLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
            [cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-19*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(30*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTypeStrSize.width+5, cardTypeStrSize.height));
            }];
            cardTypeLabel.hidden = YES;
            //
            NSString *cardValueStr = @"6227123123123123123";
            CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardValueLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardValueLabel];
            cardValueLabel.text = cardValueStr;
            cardValueLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValueLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
            [cardValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(20*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageView.mas_bottom).offset(-15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValueStrSize.width+10, cardValueStrSize.height));
            }];
            cardValueLabel.hidden = NO;
            
            //卡图片上的卡号
            NSString *cardTitleStr = @"卡号";
            CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            cardTitleLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardTitleLabel];
            cardTitleLabel.text = cardTitleStr;
            cardTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
            [cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(20*Constants.screenWidthRate);
                make.bottom.equalTo(cardValueLabel.mas_top).offset(-6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
            }];
            cardTitleLabel.hidden = NO;
            
            NSString *cardValidTimeStr = @"2016-12-11至2016-12-12";
            CGSize cardValidTimeStrSize = [KKZTextUtility measureText:cardValidTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            cardValidTimeLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardValidTimeLabel];
            //MARK: 如果没有有效期则隐藏
            cardValidTimeLabel.hidden = NO;
            cardValidTimeLabel.text = cardValidTimeStr;
            cardValidTimeLabel.textAlignment = NSTextAlignmentRight;
            cardValidTimeLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValidTimeLabel.font = [UIFont systemFontOfSize:10];
            [cardValidTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-15*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageView.mas_bottom).offset(-15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValidTimeStrSize.width+5, cardValidTimeStrSize.height));
            }];
            
            NSString *cardBalanceValueStr = @"余额：10050.00元";
            CGSize cardBalanceValueStrSize = [KKZTextUtility measureText:cardBalanceValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            cardBalanceValueLabel = [[UILabel alloc] init];
            cardBalanceValueLabel.textAlignment = NSTextAlignmentRight;
            [cardImageView addSubview:cardBalanceValueLabel];
            //MARK: 如果没有余额则隐藏
            /*
             *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
             */
            cardBalanceValueLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
            [cardBalanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-15*Constants.screenWidthRate);
                make.bottom.equalTo(cardValidTimeLabel.mas_top).offset(-6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardBalanceValueStrSize.width+5, cardBalanceValueStrSize.height));
            }];
            cardBalanceValueLabel.hidden = NO;
            
            
        }
        if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
            UIImage *cardImage = [UIImage imageNamed:@"membercard1"];
            cardImageView = [[UIImageView alloc] init];
            [cardView addSubview:cardImageView];
            [cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cardView);
            }];
            cardImageView.image = cardImage;
            
            //卡图片上的logo
            UIImage *cardLogoImage = [UIImage imageNamed:@"cinema_logo"];
            cardLogoImageView = [[UIImageView alloc] init];
            [cardImageView addSubview:cardLogoImageView];
            [cardLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(25*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardLogoImage.size.width*Constants.screenWidthRate, cardLogoImage.size.height*Constants.screenHeightRate));
            }];
            cardLogoImageView.image = cardLogoImage;
            
#if K_ZHONGDU
            cardLogoImageView.hidden = YES;
#else
            cardLogoImageView.hidden = NO;
#endif
            NSString *cardTypeStr = @"储值卡";
            CGSize cardTypeStrSize = [KKZTextUtility measureText:cardTypeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardTypeLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardTypeLabel];
            cardTypeLabel.text = cardTypeStr;
            cardTypeLabel.textColor = [UIColor colorWithHex:@"#333333"];
            cardTypeLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
            [cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-19*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(30*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTypeStrSize.width+5, cardTypeStrSize.height));
            }];
            cardTypeLabel.hidden = NO;
            //
            //卡图片上的卡号
            NSString *cardTitleStr = @"卡号";
            CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            cardTitleLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardTitleLabel];
            cardTitleLabel.text = cardTitleStr;
            cardTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
            [cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardLogoImageView.mas_bottom).offset(32*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
            }];
            cardTitleLabel.hidden = NO;
            
            NSString *cardValueStr = @"6227123123123123123";
            CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            cardValueLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardValueLabel];
            cardValueLabel.text = cardValueStr;
            cardValueLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValueLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
            [cardValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardTitleLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake((cardImage.size.width - 35)*Constants.screenWidthRate, cardValueStrSize.height));
            }];
            cardValueLabel.hidden = NO;
            
            NSString *cardBalanceValueStr = @"余额：10050.00元";
            CGSize cardBalanceValueStrSize = [KKZTextUtility measureText:cardBalanceValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            cardBalanceValueLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardBalanceValueLabel];
            //MARK: 如果没有余额则隐藏
            /*
             *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
             */
            cardBalanceValueLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
            [cardBalanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardValueLabel.mas_bottom).offset(28*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardBalanceValueStrSize.width+5, cardBalanceValueStrSize.height));
            }];
            cardBalanceValueLabel.hidden = NO;
            
            NSString *cardValidTimeStr = @"2016-12-11至2016-12-12";
            CGSize cardValidTimeStrSize = [KKZTextUtility measureText:cardValidTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            cardValidTimeLabel = [[UILabel alloc] init];
            [cardImageView addSubview:cardValidTimeLabel];
            //MARK: 如果没有有效期则隐藏
            cardValidTimeLabel.hidden = NO;
            cardValidTimeLabel.text = cardValidTimeStr;
            cardValidTimeLabel.textAlignment = NSTextAlignmentRight;
            cardValidTimeLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValidTimeLabel.font = [UIFont systemFontOfSize:10];
            [cardValidTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-25*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageView.mas_bottom).offset(-23*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValidTimeStrSize.width+5, cardValidTimeStrSize.height));
            }];
        }
    }
//    DLog(@"%ld  %@", (long)index ,vipcard.cardNo);
    if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
        
    }
    if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
        cardTypeLabel.text = vipcard.useTypeName;
    }
    
    cardValueLabel.text = vipcard.cardNo;
    NSString *cardBalanceValueStr = @"";
    if (vipcard.useType.intValue == 1 || vipcard.useType.intValue == 3) {
        cardBalanceValueLabel.hidden = NO;
        cardBalanceValueStr = [NSString stringWithFormat:@"余额:%.2f元",vipcard.cardDetail.balance.floatValue];
        /*
         *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
         */
        cardBalanceValueLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
    } else {
        cardBalanceValueLabel.hidden = YES;
    }
    if (([vipcard.expireDate containsString:@"天"] || [vipcard.expireDate containsString:@"月"] ||[vipcard.expireDate containsString:@"年"])&&(!([vipcard.expireDate containsString:@"有效期"]))) {
        cardValidTimeLabel.text = [NSString stringWithFormat:@"%@有效期", vipcard.expireDate];
    } else {
        cardValidTimeLabel.text = [NSString stringWithFormat:@"%@", vipcard.expireDate];
    }
    return cardView;
}


- (void)makeDataSource {
    for (int i=0; i<3; i++) {
        NSString *s = [NSString stringWithFormat:@"%c", i + 'A'];
        [self.dataSource addObject:s];
    }
}

- (RPRingedPages *)pages {
    if (_pages == nil) {
        UIImage *cardImage = [UIImage imageNamed:@"membercard1"];
        CGRect pagesFrame = CGRectZero;
        if (kCommonScreenHeight < 667) {
            pagesFrame = CGRectMake(0, 15*Constants.screenHeightRate, kCommonScreenWidth, (201 + 50)*Constants.screenHeightRate);
        } else {
            pagesFrame = CGRectMake(0, 15*Constants.screenHeightRate, kCommonScreenWidth, (cardImage.size.height + 50)*Constants.screenHeightRate);
        }
        
        RPRingedPages *pages  = [[RPRingedPages alloc] initWithFrame:pagesFrame];
        if (kCommonScreenHeight < 667) {
            pages.carousel.mainPageSize = CGSizeMake(280, 201*Constants.screenHeightRate);
        } else {
            pages.carousel.mainPageSize = CGSizeMake(cardImage.size.width*Constants.screenWidthRate, cardImage.size.height*Constants.screenHeightRate);
        }
        
        pages.carousel.pageScale = 0.8;
        pages.dataSource = self;
        pages.delegate = self;
        
        _pages = pages;
    }
    return _pages;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - 设置导航条
-(void)setUpNavBar
{
    self.title = @"会员卡充值";

    UIImage *leftBarImage = [UIImage imageNamed:@"titlebar_back1"];
    leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0, 0, leftBarImage.size.width*Constants.screenWidthRate, leftBarImage.size.height*Constants.screenHeightRate);
    [leftBarBtn setImage:leftBarImage
                forState:UIControlStateNormal];
    leftBarBtn.backgroundColor = [UIColor clearColor];
    [leftBarBtn addTarget:self
                   action:@selector(cancelViewController)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
//    self.navigationItem.titleView = self.titleViewOfBar;
//    titleLabel.text = @"会员卡充值";
//    titleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarTitleColor];
    
}

//MARK: 初始化导航栏标题
- (UIView *)titleViewOfBar {
    if (!_titleViewOfBar) {
        NSString *titleStr = @"绑定未来影院通州北苑...";
        CGSize titleStrSize = [KKZTextUtility measureText:titleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
        _titleViewOfBar = [[UIView alloc] initWithFrame:CGRectMake(60*Constants.screenWidthRate, 35*Constants.screenHeightRate, kCommonScreenWidth - 60*2*Constants.screenWidthRate, titleStrSize.height)];
        titleLabel = [[UILabel alloc] init];
        [_titleViewOfBar addSubview:titleLabel];
        
        titleLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
        titleLabel.text = titleStr;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2*Constants.screenWidthRate - titleStrSize.width)/2);
            make.top.bottom.equalTo(_titleViewOfBar);
            make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
        }];
    }
    return _titleViewOfBar;
}

- (void) cancelViewController {
//    if (cardView) {
//        [cardView removeFromSuperview];
//        cardView = nil;
//    }
    if (self.pages) {
        [self.pages removeFromSuperview];
        self.pages = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
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
