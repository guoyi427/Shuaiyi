//
//  OpenCardDetailController.m
//  CIASMovie
//
//  Created by avatar on 2017/3/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OpenCardDetailController.h"
#import "KKZTextUtility.h"
#import "CinemaCell.h"
#import "Cinema.h"
#import "CardCinema.h"
#import "OpenCardViewController.h"
#import "OpenCardNoticeController.h"
#import "VipCardRequest.h"
//#import <Category_KKZ/NSDictionaryExtra.h>

@interface OpenCardDetailController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel        *titleLabel;
    BOOL           isCanOpenCard;
    UIView         *openCardHeaderView,*line1View,*line2View,*line3View,*line4View,*line5View,*line6View,*line7View,*line8View;
    NSArray *privilegeArr;
    UIView *backView;
    UIView *privilegeListView;
}
@property (nonatomic, strong) UIView  *titleViewOfBar;
@end

@implementation OpenCardDetailController


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.hideNavigationBar = NO;
    self.hideBackBtn = NO;
    [self setNavBarUI];
    
    //MARK: 初始化数据
    
    DLog(@"%lu", self.cardCinemaList.count);
    self.openCardBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    self.openCardBtn.titleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor];
    
    //MARK: 解析数据
    //判断是否有微信
    NSString *cardPrivilege = self.cardTypeDetail.cardPrivilege;
    
    NSData *jsonData = [cardPrivilege dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    privilegeArr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    DLog(@"%@", privilegeArr);
    
    //MARK: 创建headerView
    openCardHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, (69*privilegeArr.count + 60 + 5)*Constants.screenHeightRate)];
    line1View = [[UIView alloc] init];
    line1View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [openCardHeaderView addSubview:line1View];
    [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(openCardHeaderView);
        make.height.equalTo(@1);
    }];
    UILabel *flagLabel = [[UILabel alloc] init];
    [openCardHeaderView addSubview:flagLabel];
    flagLabel.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(openCardHeaderView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(openCardHeaderView.mas_top).offset((30-13)/2*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(4*Constants.screenWidthRate, 13*Constants.screenHeightRate));
    }];
    
    UILabel *cardPrivilegeLabel = [[UILabel alloc] init];
    [openCardHeaderView addSubview:cardPrivilegeLabel];
    cardPrivilegeLabel.text = @"会员特权";
    cardPrivilegeLabel.textColor = [UIColor colorWithHex:@"#333333"];
    cardPrivilegeLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    [cardPrivilegeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flagLabel.mas_right).offset(5*Constants.screenWidthRate);
        make.centerY.equalTo(flagLabel.mas_centerY);
        make.height.equalTo(@(13*Constants.screenHeightRate));
    }];
    
    UIButton *openCardNoticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [openCardHeaderView addSubview:openCardNoticeBtn];
    [openCardNoticeBtn setTitle:@"办卡须知" forState:UIControlStateNormal];
    [openCardNoticeBtn setTitleColor:[UIColor colorWithHex:@"#ff9900"] forState:UIControlStateNormal];
    openCardNoticeBtn.titleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    [openCardNoticeBtn addTarget:self action:@selector(openCardNoticeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [openCardNoticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(flagLabel.mas_centerY);
        make.right.equalTo(openCardHeaderView.mas_right).offset(-15*Constants.screenWidthRate);
        make.height.equalTo(@(30*Constants.screenHeightRate));
    }];
    
    line2View = [[UIView alloc] init];
    [openCardHeaderView addSubview:line2View];
    line2View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(openCardHeaderView);
        make.top.equalTo(line1View.mas_bottom).offset(30*Constants.screenHeightRate);
        make.height.equalTo(@1);
    }];
    
    privilegeListView = [self getPrivilegeViewWithPrivilegeArr:privilegeArr];
    [openCardHeaderView addSubview:privilegeListView];
    [privilegeListView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(openCardHeaderView);
        make.top.equalTo(line2View.mas_bottom);
        make.height.equalTo(@(69*privilegeArr.count*Constants.screenHeightRate));
    }];
        
    backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor colorWithHex:@"#f2f4f5"];
    [openCardHeaderView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(openCardHeaderView);
        make.top.equalTo(privilegeListView.mas_bottom);
        make.height.equalTo(@(4*Constants.screenHeightRate));
    }];
    
    line7View = [[UIView alloc] init];
    line7View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [openCardHeaderView addSubview:line7View];
    [line7View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(openCardHeaderView.mas_left);
        make.top.equalTo(backView.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    UILabel *flagLabel2 = [[UILabel alloc] init];
    [openCardHeaderView addSubview:flagLabel2];
    flagLabel2.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [flagLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(openCardHeaderView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(line7View.mas_bottom).offset((30-13)/2*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(4*Constants.screenWidthRate, 13*Constants.screenHeightRate));
    }];
    
    UILabel *cardCinemaLabel = [[UILabel alloc] init];
    [openCardHeaderView addSubview:cardCinemaLabel];
    cardCinemaLabel.text = @"会员影院";
    cardCinemaLabel.textColor = [UIColor colorWithHex:@"#333333"];
    cardCinemaLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    [cardCinemaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flagLabel2.mas_right).offset(5*Constants.screenWidthRate);
        make.centerY.equalTo(flagLabel2.mas_centerY);
        make.height.equalTo(@(13*Constants.screenHeightRate));
    }];
    
    UILabel *cardTotalCinemaLabel = [[UILabel alloc] init];
    [openCardHeaderView addSubview:cardTotalCinemaLabel];
    cardTotalCinemaLabel.text = [NSString stringWithFormat:@"共%lu家", (unsigned long)_cardCinemaList.count];
    cardTotalCinemaLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    cardTotalCinemaLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    [cardTotalCinemaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(flagLabel2.mas_centerY);
        make.right.equalTo(openCardHeaderView.mas_right).offset(-15*Constants.screenWidthRate);
        make.height.equalTo(@(30*Constants.screenHeightRate));
    }];
    
    line8View = [[UIView alloc] init];
    [openCardHeaderView addSubview:line8View];
    line8View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [line8View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(openCardHeaderView);
        make.top.equalTo(line7View.mas_bottom).offset(30*Constants.screenHeightRate);
        make.height.equalTo(@1);
    }];
    
    
    self.cinemaLimitTableView.tableHeaderView = openCardHeaderView;
    self.cinemaLimitTableView.dataSource = self;
    self.cinemaLimitTableView.delegate = self;
    
    
    if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
        self.cardNoXCLabel.hidden = NO;
        self.cardTitleXCLabe.hidden = NO;
        self.cardBalanXCLabel.hidden = NO;
        self.cardValidXCLabel.hidden = NO;
        self.cardTypeLabel.hidden = YES;
        self.cardCinemaName.hidden = YES;
        self.cardDiscountLabel.hidden = YES;
        self.cardBalanceLabel.hidden = YES;
        self.cardValidTimeLabel.hidden = YES;
        self.cinemaLogoImageView.hidden = YES;
        
        self.cardNoXCLabel.text = [NSString stringWithFormat:@"%@", self.cardTypeDetail.discountDesc];
        self.cardTitleXCLabe.text = [NSString stringWithFormat:@"%@", self.cardTypeDetail.cinemaName];
        
        NSString *cardBalanceValueStr = @"";
        
        if (self.cardTypeDetail.cardType.intValue == 1 || self.cardTypeDetail.cardType.intValue == 3) {
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
            self.cardValidXCLabel.text = [NSString stringWithFormat:@"%@有效期", self.cardTypeDetail.expireDate];
        } else {
            self.cardValidXCLabel.text = [NSString stringWithFormat:@"%@", self.cardTypeDetail.expireDate];
        }
        
    }
    if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
        self.cardTypeLabel.hidden = NO;
        self.cardCinemaName.hidden = NO;
        self.cardDiscountLabel.hidden = NO;
        self.cardBalanceLabel.hidden = NO;
        self.cardValidTimeLabel.hidden = NO;
        
#if K_ZHONGDU
        self.cinemaLogoImageView.hidden = YES;
#else
        self.cinemaLogoImageView.hidden = NO;
#endif
        self.cardImageView.image = [UIImage imageNamed:@"membercard1"];
        //MARK: 赋值
        self.cardCinemaName.text = [NSString stringWithFormat:@"%@", self.cardTypeDetail.cinemaName];
        self.cardTypeLabel.text = [NSString stringWithFormat:@"%@", self.cardTypeDetail.cardTypeName];
        self.cardDiscountLabel.text = [NSString stringWithFormat:@"%@", self.cardTypeDetail.discountDesc];
        NSString *cardBalanceValueStr = @"";
        //    if (self.cardTypeDetail.cardType.intValue == 1 || self.cardTypeDetail.cardType.intValue == 3) {
        //        cardBalanceValueStr = [NSString stringWithFormat:@"充值:%.2f元",self.cardTypeDetail.rechargeMoney.floatValue];
        //    } else {
        cardBalanceValueStr = [NSString stringWithFormat:@"售价:%.2f元",self.cardTypeDetail.saleMoney.floatValue];
        //    }
        /*
         *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
         */
        self.cardBalanceLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
        if (([self.cardTypeDetail.expireDate containsString:@"天"] || [self.cardTypeDetail.expireDate containsString:@"月"] ||[self.cardTypeDetail.expireDate containsString:@"年"])&&(!([self.cardTypeDetail.expireDate containsString:@"有效期"]))) {
            self.cardValidTimeLabel.text = [NSString stringWithFormat:@"%@有效期", self.cardTypeDetail.expireDate];
        } else {
            self.cardValidTimeLabel.text = [NSString stringWithFormat:@"%@", self.cardTypeDetail.expireDate];
        }
    }
    
    
    
    //MARK: 更新约束
    UIImage *backImage = [UIImage imageNamed:@"membercard_mask"];
    self.backImageViewWidth.constant = backImage.size.width*Constants.screenWidthRate;
    self.backImageViewHeight.constant = backImage.size.height*Constants.screenHeightRate;
    UIImage *cardImage = [UIImage imageNamed:@"membercard1"];
    self.cardImageViewWitdh.constant = cardImage.size.width*Constants.screenWidthRate;
    self.cardImageViewHeight.constant = cardImage.size.height*Constants.screenHeightRate;
    self.logoTop.constant = 25*Constants.screenHeightRate;
    self.cinemaNameTop.constant = 32*Constants.screenHeightRate;
    self.cardTypeTop.constant = 30*Constants.screenHeightRate;
    self.cardDiscountTop.constant = 15*Constants.screenHeightRate;
    self.cardBalanceBottom.constant = -25*Constants.screenHeightRate;
    self.backImageTop.constant = 10*Constants.screenHeightRate;
    self.cardImageViewTop.constant = 25*Constants.screenHeightRate;
    self.protocolViewHeight.constant = 48*Constants.screenHeightRate;
    self.protocolBtnHeight.constant = 18*Constants.screenHeightRate;
    self.protocolBtnTop.constant = (48-18)/2*Constants.screenHeightRate;
    self.cinemaLogoLeft.constant = 35*Constants.screenWidthRate;
    self.cardTypeRight.constant = -24*Constants.screenWidthRate;
    self.protocolSelectBtn.selected = YES;
    isCanOpenCard = YES;
    
    self.cardBalanXCLeft.constant = -15*Constants.screenWidthRate;
    self.cardNoXCLeft.constant = 20*Constants.screenWidthRate;
    self.cardTitleXCBottom.constant = 6*Constants.screenHeightRate;
    self.cardNoXCBottom.constant = -15*Constants.screenHeightRate;

    
    
    self.cardTypeLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
    self.cardCinemaName.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    self.cardDiscountLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
    self.cardValidTimeLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
    
    
    self.cardNoXCLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
    self.cardTitleXCLabe.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
    self.cardValidXCLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
}

- (UIView *)getPrivilegeViewWithPrivilegeArr:(NSArray *) privilegeArray {
    UIView *privilegeVw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 69*privilegeArray.count*Constants.screenHeightRate)];
    //MARK: 会员特权
    for (int i = 0; i < privilegeArray.count; i++) {
        NSDictionary *privilegeDic = [privilegeArray objectAtIndex:i];
        NSString *snackLabelStr = [privilegeDic kkz_stringForKey:@"tequan_title"];
        NSString *snackDetailLabelStr = [privilegeDic kkz_stringForKey:@"tequan_desc"];
        NSString *snackImageType = [privilegeDic kkz_stringForKey:@"tequan_type"];
        UIImage  *snackImage = nil;
        if (snackImageType.intValue == 1) {
            //生日
            snackImage = [UIImage imageNamed:@"birthday"];
        } else if (snackImageType.intValue == 2) {
            //优惠
            snackImage = [UIImage imageNamed:@"discount"];
        }else if (snackImageType.intValue == 3) {
            //礼包
            snackImage = [UIImage imageNamed:@"gift"];
        }else if (snackImageType.intValue == 4) {
            //服务
            snackImage = [UIImage imageNamed:@"service"];
        }
        UIImageView *snackImageView = [[UIImageView alloc] init];
        [privilegeVw addSubview:snackImageView];
        snackImageView.image = snackImage;
        [snackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(privilegeVw.mas_left).offset(15*Constants.screenWidthRate);
            make.top.equalTo(privilegeVw.mas_top).offset((69*i + 16)*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(snackImage.size.width*Constants.screenWidthRate, snackImage.size.height*Constants.screenHeightRate));
        }];
        
        UILabel *snackLabel = [[UILabel alloc] init];
        [privilegeVw addSubview:snackLabel];
        snackLabel.text = snackLabelStr;
        snackLabel.textColor = [UIColor colorWithHex:@"#333333"];
        snackLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        [snackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(snackImageView.mas_right).offset(15*Constants.screenWidthRate);
            make.top.equalTo(privilegeVw.mas_top).offset((69*i + 15)*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(kCommonScreenWidth - (30 + snackImage.size.width)*Constants.screenWidthRate, 13*Constants.screenHeightRate));
        }];
        
        UILabel *snackDetailLabel = [[UILabel alloc] init];
        [privilegeVw addSubview:snackDetailLabel];
        snackDetailLabel.text = snackDetailLabelStr;
        snackDetailLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        snackDetailLabel.numberOfLines = 0;
        snackDetailLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
        [snackDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(snackImageView.mas_right).offset(15*Constants.screenWidthRate);
            make.top.equalTo(snackLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(kCommonScreenWidth- 2*(30 + snackImage.size.width)*Constants.screenWidthRate, 25*Constants.screenHeightRate));
        }];
        UIView *lineVw = [[UIView alloc] init];
        lineVw.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [privilegeVw addSubview:lineVw];
        [lineVw mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(privilegeVw.mas_left).offset(15*Constants.screenWidthRate);
            make.right.equalTo(privilegeVw.mas_right).offset(0);
            make.top.equalTo(snackImageView.mas_bottom).offset(16*Constants.screenHeightRate);
            make.height.equalTo(@1);
        }];
    }
    
    
    return privilegeVw;
}


#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CardCinemaCell";
    CardCinema *managerment = [self.cardCinemaList objectAtIndex:indexPath.row];
    CinemaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CinemaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.cinemaName = managerment.cinemaName;
    cell.cinemaAddress = managerment.cinemaAddress;
    cell.distance = @"";
    [cell updateLayout];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cardCinemaList.count;//
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66*Constants.screenHeightRate;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self
                   action:@selector(backItemClick)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backButton];

    [self.view addSubview:self.titleViewOfBar];
    titleLabel.text = [NSString stringWithFormat:@"%@", self.cardTypeDetail.cinemaName];
    */
    self.title = self.cardTypeDetail.cinemaName;
}

/**
 *  MARK: 返回按钮
 */
- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
//    if (self.navigationController.viewControllers.count >= 4) {
//        UIViewController *targetController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-4];
//        [self.navigationController popToViewController:targetController animated:YES];
//    }
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



- (void)openCardNoticeBtnClick {
    OpenCardNoticeController *openNoticeVc = [[OpenCardNoticeController alloc] init];
    openNoticeVc.titleShowStr = @"办卡须知";
    openNoticeVc.contentShowStr = self.cardTypeDetail.cardNotice;
    openNoticeVc.isFromCoupon = NO;
    [self.navigationController pushViewController:openNoticeVc animated:YES];
//    [[CIASAlertCancleView new] show:@"温馨提示" message:self.cardTypeDetail.cardNotice cancleTitle:@"好的" callback:^(BOOL confirm) {
//    }];
}


- (IBAction)protocolSelectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        isCanOpenCard = YES;
    } else {
        isCanOpenCard = NO;
    }
}

- (IBAction)protocolDetailBtnClick:(UIButton *)sender {
    //先请求到开卡协议数据，再跳转
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:[NSString stringWithFormat:@"%d", self.cardTypeDetail.cardId.intValue] forKey:@"cardProductId"];
    
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [requtest requestOpenCardProtocolParams:params
                                    success:^(NSDictionary * _Nullable data) {
                                        [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                        NSDictionary *protocolDic = [data kkz_objForKey:@"data"];
                                        NSString *protocolStr = [protocolDic kkz_stringForKey:@"protocol"];
                                        if (protocolStr.length > 0) {
                                            OpenCardNoticeController *openNoticeVc = [[OpenCardNoticeController alloc] init];
                                            openNoticeVc.titleShowStr = @"会员卡协议";
                                            openNoticeVc.contentShowStr = protocolStr;
                                            openNoticeVc.isFromCoupon = NO;
                                            [weakSelf.navigationController pushViewController:openNoticeVc animated:YES];
                                        }
//                                        DLog(@"%@", protocolDic);
                                        
                                    } failure:^(NSError * _Nullable err) {
                                        [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
                                    }];
//    [[CIASAlertCancleView new] show:@"温馨提示" message:@"这是会员卡协议，请仔细阅读" cancleTitle:@"好的" callback:^(BOOL confirm) {
//        
//    }];
}

- (IBAction)openCardBtnClick:(UIButton *)sender {
    if (isCanOpenCard) {
//        [[CIASAlertCancleView new] show:@"温馨提示" message:@"可开卡" cancleTitle:@"好的" callback:^(BOOL confirm) {
//        }];
        //跳转开卡页面
        OpenCardViewController *openVc = [[OpenCardViewController alloc] init];
        openVc.cinemaName = self.cinemaName;
        openVc.cinemaId = self.cinemaId;
        openVc.cardTypeDetail = self.cardTypeDetail;
        [self.navigationController pushViewController:openVc animated:YES];
    } else {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"同意会员卡协议，即可开卡" cancleTitle:@"好的" callback:^(BOOL confirm) {
            
        }];
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
