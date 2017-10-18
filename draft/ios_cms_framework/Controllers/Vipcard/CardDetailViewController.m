//
//  CardDetailViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/3/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CardDetailViewController.h"
#import "KKZTextUtility.h"
#import "CinemaCell.h"
#import "Cinema.h"
#import "CardCinema.h"
#import "VipCardRechargeController.h"

@interface CardDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel        *titleLabel;
    BOOL           isCanOpenCard;
    UIView         *openCardHeaderView,*line1View,*line2View,*line3View,*line4View,*line5View,*line6View,*line7View,*line8View;
    NSMutableArray *cinemaList;
    NSArray *privilegeArr;
    UIView *backView;
    UIButton *rightBarBtn;
    UIView *privilegeListView;
}
@property (nonatomic, strong) UIView  *titleViewOfBar;

@end

@implementation CardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hideNavigationBar = NO;
    self.hideBackBtn = NO;
    [self setNavBarUI];
    
    //MARK: 解析数据
    cinemaList = [[NSMutableArray alloc] initWithArray:self.cardListDetail.product.cinemas];
    //判断是否有特权
    NSString *cardPrivilege = self.cardListDetail.product.cardPrivilege;
    DLog(@"cardPrivilege:%@", cardPrivilege);
    if (cardPrivilege.length > 0) {
        NSData *jsonData = [cardPrivilege dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        privilegeArr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:NSJSONReadingMutableContainers
                                                         error:&err];
    }
    DLog(@"%@", privilegeArr);
//计算tableHeaderView的高度 根据是否有影院特权和影院列表来计算高度

    float headerViewHeight = 0;
    headerViewHeight = privilegeArr.count?(69*privilegeArr.count+30+5):0;
    headerViewHeight = cinemaList.count?(headerViewHeight+30):headerViewHeight;
    headerViewHeight = headerViewHeight*Constants.screenHeightRate;
    DLog(@"%.f", headerViewHeight);

//    headerViewHeight = (69*privilegeArr.count+60+5)*Constants.screenHeightRate;
//初始化tableHeaderView
    openCardHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, headerViewHeight)];
//初始化tableHeaderView 上面第一根线
    if (headerViewHeight>0) {
        //如果tableHeaderView不为0才显示下面的控件
        line1View = [[UIView alloc] init];
        line1View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [openCardHeaderView addSubview:line1View];
        [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(openCardHeaderView);
            make.height.equalTo(@1);
        }];
        //根据特权数组是否有数据来显示第一个view
        if (privilegeArr.count>0) {
            UILabel *flagLabel = [[UILabel alloc] init];
            [openCardHeaderView addSubview:flagLabel];
            flagLabel.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
            [flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(openCardHeaderView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(openCardHeaderView.mas_top).offset((30-13)/2*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(4*Constants.screenWidthRate, 13*Constants.screenHeightRate));
            }];
            
            UILabel *cardPrivilegeLabel = [KKZTextUtility getLabelWithText:@"会员特权" font:[UIFont systemFontOfSize:13*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
            [openCardHeaderView addSubview:cardPrivilegeLabel];
            [cardPrivilegeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(flagLabel.mas_right).offset(5*Constants.screenWidthRate);
                make.centerY.equalTo(flagLabel.mas_centerY);
                make.height.equalTo(@(13*Constants.screenHeightRate));
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
        }
        
        //MARK: 会员影院
        if (cinemaList.count) {
            UILabel *flagLabel2 = [[UILabel alloc] init];
            [openCardHeaderView addSubview:flagLabel2];
            flagLabel2.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
            if (privilegeArr.count>0) {
                [flagLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(openCardHeaderView.mas_left).offset(15*Constants.screenWidthRate);
                    make.top.equalTo(line7View.mas_bottom).offset((30-13)/2*Constants.screenHeightRate);
                    make.size.mas_equalTo(CGSizeMake(4*Constants.screenWidthRate, 13*Constants.screenHeightRate));
                }];
                
            } else {
                [flagLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(openCardHeaderView.mas_left).offset(15*Constants.screenWidthRate);
                    make.top.equalTo(line1View.mas_bottom).offset((30-13)/2*Constants.screenHeightRate);
                    make.size.mas_equalTo(CGSizeMake(4*Constants.screenWidthRate, 13*Constants.screenHeightRate));
                }];
            }
            
            UILabel *cardCinemaLabel = [KKZTextUtility getLabelWithText:@"会员影院" font:[UIFont systemFontOfSize:13*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
            [openCardHeaderView addSubview:cardCinemaLabel];
            
            [cardCinemaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(flagLabel2.mas_right).offset(5*Constants.screenWidthRate);
                make.centerY.equalTo(flagLabel2.mas_centerY);
                make.height.equalTo(@(13*Constants.screenHeightRate));
            }];
            
            UILabel *cardTotalCinemaLabel = [KKZTextUtility getLabelWithText:[NSString stringWithFormat:@"共%lu家", (unsigned long)cinemaList.count] font:[UIFont systemFontOfSize:13*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentLeft];
            [openCardHeaderView addSubview:cardTotalCinemaLabel];
            
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
                make.top.equalTo(openCardHeaderView.mas_bottom);
                make.height.equalTo(@1);
            }];
            
        }
        
    }

    
    
    self.cardDisPlayTableView.tableHeaderView = openCardHeaderView;
    self.cardDisPlayTableView.dataSource = self;
    self.cardDisPlayTableView.delegate = self;
    self.cardDisPlayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.cardDisPlayTableView reloadData];
    self.cardUseBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
#if K_HENGDIAN
    [self.cardUseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.cardUseBtn.titleLabel.textColor = [UIColor whiteColor];
#else
    [self.cardUseBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];

#endif
    [self.cardValidXCLabel setTextColor:[UIColor colorWithHex:@"ffffff"]];
    if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
        self.cardLogoImageView.hidden = YES;
        self.cardTypeLabel.hidden = YES;
        self.cardIdTitleLabel.hidden = YES;
        self.cardIdValueLabel.hidden = YES;
        self.cardBalanceLabel.hidden = YES;
        self.cardTimeLabel.hidden = YES;
        self.cardTitleXCLabel.hidden = YES;
        self.cardValidXCLabel.hidden = YES;
        self.cardBalanceXCLabel.hidden = YES;
        self.cardNoValueXCLabel.hidden = YES;
        
        self.cardTitleXCLabel.hidden = NO;
        self.cardValidXCLabel.hidden = NO;
        self.cardBalanceXCLabel.hidden = NO;
        self.cardNoValueXCLabel.hidden = NO;
        [self.cardTitleXCLabel setTextColor:[UIColor colorWithHex:@"ffffff"]];
        [self.cardValidXCLabel setTextColor:[UIColor colorWithHex:@"ffffff"]];

        self.cardNoValueXCLabel.text = [NSString stringWithFormat:@"%@", self.cardListDetail.cardNo];
        NSString *cardBalanceValueStr = @"";
        if (self.cardListDetail.product.cardType.intValue == 1 || self.cardListDetail.product.cardType.intValue == 3) {
            self.cardBalanceXCLabel.hidden = NO;
            cardBalanceValueStr = [NSString stringWithFormat:@"余额:%.2f元",self.cardListDetail.cardDetail.balance.floatValue];
            /*
             *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
             */
            self.cardBalanceXCLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
            self.cardImageView.image = [UIImage imageNamed:@"membercard_xc_1"];
            
        } else {
            self.cardBalanceXCLabel.hidden = YES;
            
            self.cardImageView.image = [UIImage imageNamed:@"membercard_xc_2"];
            
        }
        if (([self.cardListDetail.expireDate containsString:@"天"] || [self.cardListDetail.expireDate containsString:@"月"] ||[self.cardListDetail.expireDate containsString:@"年"])&&(!([self.cardListDetail.expireDate containsString:@"有效期"]))) {
            self.cardValidXCLabel.text = [NSString stringWithFormat:@"%@有效期", self.cardListDetail.expireDate];
        } else {
            self.cardValidXCLabel.text = [NSString stringWithFormat:@"%@", self.cardListDetail.expireDate];
        }
        
    }
    if( [kIsCMSStandardCardStyle isEqualToString:@"1"]) {
        self.cardTitleXCLabel.hidden = YES;
        self.cardValidXCLabel.hidden = YES;
        self.cardBalanceXCLabel.hidden = YES;
        self.cardNoValueXCLabel.hidden = YES;
        self.cardTitleXCLabel.text = @"";
        self.cardValidXCLabel.text = @"";
        self.cardBalanceXCLabel.text = @"";
        self.cardNoValueXCLabel.text = @"";
#if K_ZHONGDU
        self.cardLogoImageView.hidden = YES;
#endif
        
        self.cardTypeLabel.hidden = NO;
        self.cardIdTitleLabel.hidden = NO;
        self.cardIdValueLabel.hidden = NO;
        self.cardBalanceLabel.hidden = NO;
        self.cardTimeLabel.hidden = NO;
        self.cardTitleXCLabel.hidden = NO;
        self.cardValidXCLabel.hidden = NO;
        self.cardBalanceXCLabel.hidden = NO;
        self.cardNoValueXCLabel.hidden = NO;
        
        self.cardImageView.image = [UIImage imageNamed:@"membercard1"];
        //MARK: 赋值
        self.cardIdValueLabel.text = [NSString stringWithFormat:@"%@", self.cardListDetail.cardNo];
        self.cardTypeLabel.text = [NSString stringWithFormat:@"%@", self.cardListDetail.useTypeName];
        NSString *cardBalanceValueStr = @"";
        if (self.cardListDetail.product.cardType.intValue == 1 || self.cardListDetail.product.cardType.intValue == 3) {
            self.cardBalanceLabel.hidden = NO;
            cardBalanceValueStr = [NSString stringWithFormat:@"余额:%.2f元",self.cardListDetail.cardDetail.balance.floatValue];
            /*
             *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
             */
            self.cardBalanceLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
        } else {
            self.cardBalanceLabel.hidden = YES;
        }
        if (([self.cardListDetail.expireDate containsString:@"天"] || [self.cardListDetail.expireDate containsString:@"月"] ||[self.cardListDetail.expireDate containsString:@"年"])&&(!([self.cardListDetail.expireDate containsString:@"有效期"]))) {
            self.cardTimeLabel.text = [NSString stringWithFormat:@"%@有效期", self.cardListDetail.expireDate];
        } else {
            self.cardTimeLabel.text = [NSString stringWithFormat:@"%@", self.cardListDetail.expireDate];
        }
    }
    
    
    
    
    
    //MARK: 更新约束
    UIImage *backImage = [UIImage imageNamed:@"membercard_mask"];
    self.cardBackImageWitdh.constant = backImage.size.width*Constants.screenWidthRate;
    self.cardBackImageHeight.constant = backImage.size.height*Constants.screenHeightRate;
    UIImage *cardImage = [UIImage imageNamed:@"membercard1"];
    self.cardImageWitdh.constant = cardImage.size.width*Constants.screenWidthRate;
    self.cardImageHeight.constant = cardImage.size.height*Constants.screenHeightRate;
    
    self.cardBackImageTop.constant = 0 + 10*Constants.screenHeightRate;
    self.cardImageTop.constant = 0 + 25*Constants.screenHeightRate;
    self.cardDisplatTableViewTop.constant = 10*Constants.screenHeightRate;

    if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
        self.cardNoXCLeft.constant = 20*Constants.screenWidthRate;
        self.cardNoXCBottom.constant = -15*Constants.screenHeightRate;
        self.cardValidXCRight.constant = -15*Constants.screenWidthRate;
        self.cardBalanceXCBottom.constant = 6*Constants.screenHeightRate;
        self.cardTitleXCBottom.constant = 6*Constants.screenHeightRate;

    }
    if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
        self.cardLogoLeft.constant = 35*Constants.screenWidthRate;
        self.cardLogoTop.constant = 25*Constants.screenHeightRate;
        self.cardIdLabelTop.constant = 32*Constants.screenHeightRate;
        self.cardTypeTop.constant = 30*Constants.screenHeightRate;
        self.cardTypeRight.constant = -24*Constants.screenWidthRate;
        self.cardIdValueTop.constant = 15*Constants.screenHeightRate;
        self.cardTimeBottom.constant = -25*Constants.screenHeightRate;
        self.cardTimeRight.constant = -25*Constants.screenWidthRate;
    }

    

    
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
        
        UILabel *snackLabel = [KKZTextUtility getLabelWithText:snackLabelStr font:[UIFont systemFontOfSize:13*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
        [privilegeVw addSubview:snackLabel];
        [snackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(snackImageView.mas_right).offset(15*Constants.screenWidthRate);
            make.top.equalTo(privilegeVw.mas_top).offset((69*i + 15)*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(kCommonScreenWidth - (30 + snackImage.size.width)*Constants.screenWidthRate, 13*Constants.screenHeightRate));
        }];
        
        UILabel *snackDetailLabel = [KKZTextUtility getLabelWithText:snackDetailLabelStr font:[UIFont systemFontOfSize:10*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentLeft];
        [privilegeVw addSubview:snackDetailLabel];
        snackDetailLabel.numberOfLines = 0;
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
    CardCinema *managerment = [cinemaList objectAtIndex:indexPath.row];
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
    return cinemaList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)setNavBarUI{
    self.title = @"会员卡详情";

    if (self.cardListDetail.product.cardType.intValue == 1 || self.cardListDetail.product.cardType.intValue == 3) {
        NSString *btnStr = @"充值";
        CGSize btnStrSize = [KKZTextUtility measureText:btnStr size:CGSizeMake(50, 500) font:[UIFont systemFontOfSize:15]];
        rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBarBtn setTitle:btnStr forState:UIControlStateNormal];
        rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightBarBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateNormal];
        rightBarBtn.frame = CGRectMake(kCommonScreenWidth-btnStrSize.width-20, 34, btnStrSize.width, btnStrSize.height);
        rightBarBtn.backgroundColor = [UIColor clearColor];
        [rightBarBtn addTarget:self
                        action:@selector(rightItemInCardDetailClick)
              forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarBtn];
        self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    } else {
    }
    
}


/**
 *  MARK: 充值按钮
 */
- (void)rightItemInCardDetailClick {
    VipCardRechargeController *chargeVc = [[VipCardRechargeController alloc] init];
    chargeVc.cardNo = self.cardListDetail.cardNo;
    [self.navigationController pushViewController:chargeVc animated:YES];
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

//MARK: 会员卡使用
- (IBAction)cardUseBtnClick:(UIButton *)sender {
    
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




//MARK: 初始化导航栏标题
- (UIView *)titleViewOfBar {
    if (!_titleViewOfBar) {
        NSString *titleStr = @"绑定未来影院通州北苑...";
        CGSize titleStrSize = [KKZTextUtility measureText:titleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18]];
        _titleViewOfBar = [[UIView alloc] initWithFrame:CGRectMake(60, 30, kCommonScreenWidth - 60*2, titleStrSize.height)];
        titleLabel = [KKZTextUtility getLabelWithText:titleStr font:[UIFont systemFontOfSize:18] textColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarTitleColor] textAlignment:NSTextAlignmentCenter];
        [_titleViewOfBar addSubview:titleLabel];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width)/2);
            make.top.bottom.equalTo(_titleViewOfBar);
            make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
        }];
    }
    return _titleViewOfBar;
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
