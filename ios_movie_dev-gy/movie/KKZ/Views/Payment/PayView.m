//
//  支付订单页面支付方式+优惠抵扣+结算信息+购票须知
//
//  Created by alfaromeo on 12-3-9.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "PayView.h"


#import "CommonViewController.h"
#import "DataEngine.h"
#import "ECardViewController.h"
#import "ImprestViewController.h"
#import "JDPayViewController.h"
#import "KKZUtility.h"
#import "KKZUtility.h"
#import "KotaTask.h"
#import "NSString+QueryURL.h"
#import "OrderPayViewController.h"
#import "OrderTask.h"
#import "PayTask.h"
#import "PayTypeCell.h"
#import "PaymentModel.h"
#import "RIButtonItem.h"
#import "RedCouponTask.h"
#import "RoundCornersButton.h"
#import "SpdPayViewController.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "UIConstants.h"
#import "UserDefault.h"
#import "UserManager.h"

#define kMarginX 15
#define kPreferentialHeight 50
//是否显示红包选项
BOOL KShowRedBalance = NO;

@interface PayView ()

/**
 购票总价
 */
@property (nonatomic) CGFloat totalPrice;
@end

@implementation PayView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//计算应支付的金额
- (CGFloat)moneyToPay {

    float moneyToPay = self.orderTotalFee - [self discountMoney];
    if (self.moneyToPayChanged) {
        self.moneyToPayChanged(floor(moneyToPay * 1000) / 1000, selectedMethod);
    }

    return floor(moneyToPay * 1000) / 1000;
}

//计算折扣金额
- (CGFloat)discountMoney {
    CGFloat discount = 0;
    if (self.selectedPromotion == PromotionTypeRedCoupon) {
        discount = self.redCouponAvailable;

    } else if (self.selectedPromotion == PromotionTypeCoupon) {
        discount = self.selectedEcardValue;
    }
    if (discount > self.orderTotalFee) {
        discount = self.orderTotalFee;
    }

    if (self.selectedPromotion == PromotionTypeRedCoupon) {
        redPacketLabel.text = [NSString stringWithFormat:@"-￥%.2f", discount];
        preferentialcardLabel.text = @"-￥0.00";
        newEcardTitleLabel.text = @"未抵用";
    } else if (self.selectedPromotion == PromotionTypeCoupon) {
        preferentialcardLabel.text = [NSString stringWithFormat:@"-￥%.2f", discount];
        newEcardTitleLabel.text = [NSString stringWithFormat:@"抵用%.2f元", discount];
        redPacketLabel.text = @"-￥0.00";
    } else {
        redPacketLabel.text = @"-￥0.00";
        preferentialcardLabel.text = @"-￥0.00";
        newEcardTitleLabel.text = @"未抵用";
    }

    return discount;
}

//调整优惠方式
- (void)setSelectedPromotion:(PromotionType)selectedPromotion {
    if (selectedPromotion != _selectedPromotion) {
        _selectedPromotion = selectedPromotion;

        if (_selectedPromotion != PromotionTypeCoupon) {
            //重置兑换券的金额
            self.selectedEcardValue = 0;
            [_ecardNoList removeAllObjects];
            _ecardListStr = nil;
        }
    }
    //如果启用了新的优惠方式，导致不需要余额支付，则清空支付方式
    if ([self moneyToPay] <= 0) {
        selectedMethod = PayMethodNone;
        [self.payTypeTableViewY reloadData];
    }

    //刷新提示金额
    [self discountMoney];
    self.payMethodLabelY.text = [NSString stringWithFormat:@"￥%.2f", [self moneyToPay]];

    [self showbalancenotice];
}

- (void)showbalancenotice {
    PayTypeCell *cell = (PayTypeCell *) [self.payTypeTableViewY cellForRowAtIndexPath:self.indexPathY];
    if (selectedMethod == PayMethodVip) {

        if ([self moneyToPay] - [DataEngine sharedDataEngine].vipBalance > 0.0001) {
            cell.isbalanotHid = NO;
        } else {
            cell.isbalanotHid = YES;
        }

    } else {
        cell.isbalanotHid = YES;
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isFirstLoad = YES;

        self.backgroundColor = appDelegate.kkzLine;//[UIColor clearColor];
        // 1 - 10
        selectedMethod = PayMethodNone;
        self.selectedIndex = -1;

        //选择支付方式
//        payMethodViewTip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 40)];
//        payMethodViewTip.backgroundColor = [UIColor r:245 g:245 b:245];
//        [self addSubview:payMethodViewTip];

//        UILabel *tipLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, 5, 145, 35)];
//        tipLabel1.backgroundColor = [UIColor clearColor];
//        tipLabel1.textColor = [UIColor r:153 g:153 b:153];
//        tipLabel1.font = [UIFont systemFontOfSize:14];
//        tipLabel1.hidden = NO;
//        tipLabel1.text = @"选择支付方式：";
//        [payMethodViewTip addSubview:tipLabel1];
        
        UIView *moneyView = [[UIView alloc] init];
        moneyView.backgroundColor = [UIColor whiteColor];
        [self addSubview:moneyView];
        [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(70);
        }];
        
        UILabel *totalMaoneyLbl = [[UILabel alloc] init];
        totalMaoneyLbl.backgroundColor = [UIColor clearColor];
        totalMaoneyLbl.textColor = [UIColor r:153 g:153 b:153];
        totalMaoneyLbl.textAlignment = NSTextAlignmentLeft;
        totalMaoneyLbl.text = @"总价";
        totalMaoneyLbl.font = [UIFont systemFontOfSize:14];
        [moneyView addSubview:totalMaoneyLbl];
        [totalMaoneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.equalTo(moneyView);
        }];
        
        totalMaoneyLabel = [[UILabel alloc] init];
        totalMaoneyLabel.backgroundColor = [UIColor clearColor];
        totalMaoneyLabel.textColor = appDelegate.kkzPink;//[UIColor r:102 g:102 b:102];
        totalMaoneyLabel.textAlignment = NSTextAlignmentRight;
        totalMaoneyLabel.font = [UIFont systemFontOfSize:24];
        totalMaoneyLabel.hidden = NO;
        totalMaoneyLabel.text = @"";
        [moneyView addSubview:totalMaoneyLabel];
        [totalMaoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(moneyView);
        }];
        

        //支付方式列表
        self.payTypeTableViewY = [[UITableView alloc]
                initWithFrame:CGRectMake(0, 90, screentWith, 1)];
        self.payTypeTableViewY.backgroundColor = [UIColor clearColor];
        self.payTypeTableViewY.delegate = self;
        self.payTypeTableViewY.dataSource = self;
        self.payTypeTableViewY.scrollEnabled = NO;
        self.payTypeTableViewY.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.payTypeTableViewY];
        self.payTypeTableViewY = self.payTypeTableViewY;

        /*
        //选择优惠方式
        discountViewTip = [[UIView alloc]
                initWithFrame:CGRectMake(0, CGRectGetMaxY(self.payTypeTableViewY.frame), screentWith, 40)];
        discountViewTip.backgroundColor = [UIColor r:245 g:245 b:245];
        [self addSubview:discountViewTip];

        UILabel *tipLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 145, 35)];
        tipLabel2.backgroundColor = [UIColor clearColor];
        tipLabel2.textColor = [UIColor r:153 g:153 b:153];
        tipLabel2.font = [UIFont systemFontOfSize:14];
        tipLabel2.hidden = NO;
        tipLabel2.text = @"使用优惠/抵扣：";
        [discountViewTip addSubview:tipLabel2];

        self.discountVY = [[UIView alloc] initWithFrame:CGRectMake(0, 40, screentWith, kPreferentialHeight * 2)];
        [self.discountVY setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.discountVY];

        UILabel *newEcardTitleN =
                [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, (kPreferentialHeight - 15) * 0.5, 200, 15)];
        newEcardTitleN.backgroundColor = [UIColor clearColor];
        newEcardTitleN.textColor = [UIColor r:50 g:50 b:50];
        newEcardTitleN.font = [UIFont systemFontOfSize:15];
        newEcardTitleN.text = @"优惠/兑换券";
        [self.discountVY addSubview:newEcardTitleN];

        newEcardTitleBtn =
                [[UIButton alloc] initWithFrame:CGRectMake(kMarginX + 88, (kPreferentialHeight - 24) * 0.5, 37, 24)];
        [newEcardTitleBtn setBackgroundImage:[UIImage imageNamed:@"editBg"] forState:UIControlStateNormal];
        [newEcardTitleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        newEcardTitleBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [newEcardTitleBtn setTitle:@"" forState:UIControlStateNormal];
        [self.discountVY addSubview:newEcardTitleBtn];
        newEcardTitleBtn.hidden = YES;

        newEcardTitleLabel =
                [[UILabel alloc] initWithFrame:CGRectMake(0, (kPreferentialHeight - 15) * 0.5, screentWith - 30, 15)];
        newEcardTitleLabel.backgroundColor = [UIColor clearColor];
        newEcardTitleLabel.textColor = [UIColor lightGrayColor];
        newEcardTitleLabel.font = [UIFont systemFontOfSize:13];
        newEcardTitleLabel.textAlignment = NSTextAlignmentRight;
        newEcardTitleLabel.text = @"未抵用";
        [self.discountVY addSubview:newEcardTitleLabel];

        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(kMarginX, kPreferentialHeight - 1, screentWith, 1)];
        line1.backgroundColor = [UIColor r:229 g:229 b:229];
        [self.discountVY addSubview:line1];

        UIImageView *arrowimage = [[UIImageView alloc]
                initWithFrame:CGRectMake(screentWith - 25, (kPreferentialHeight - 18) * 0.5, 10, 18)];
        arrowimage.image = [UIImage imageNamed:@"arrowRightGray"];
        arrowimage.userInteractionEnabled = YES;
        [self.discountVY addSubview:arrowimage];
        UIButton *couponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        couponBtn.frame = CGRectMake(0, 0, screentWith, kPreferentialHeight);
        couponBtn.backgroundColor = [UIColor clearColor];
        [couponBtn addTarget:self action:@selector(couponBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.discountVY addSubview:couponBtn];
        
        float positionY = 0;
        if (KShowRedBalance == YES) {
            positionY = kPreferentialHeight;
            UILabel *redBalanceLabelN = [[UILabel alloc]
                    initWithFrame:CGRectMake(kMarginX, positionY + (kPreferentialHeight - 15) * 0.5, 200, 15)];
            redBalanceLabelN.backgroundColor = [UIColor clearColor];
            redBalanceLabelN.textColor = [UIColor r:50 g:50 b:50];
            redBalanceLabelN.font = [UIFont systemFontOfSize:15];
            redBalanceLabelN.text = @"红包";
            [self.discountVY addSubview:redBalanceLabelN];

            redBalanceLabelTotal =
                    [[UILabel alloc] initWithFrame:CGRectMake(53, positionY + (kPreferentialHeight - 24) * 0.5, 60, 24)];
            redBalanceLabelTotal.backgroundColor = [UIColor r:231 g:66 b:64];
            redBalanceLabelTotal.textColor = [UIColor whiteColor];
            redBalanceLabelTotal.font = [UIFont systemFontOfSize:14];
            redBalanceLabelTotal.textAlignment = NSTextAlignmentCenter;
            redBalanceLabelTotal.layer.cornerRadius = 3;
            redBalanceLabelTotal.clipsToBounds = YES;
            redBalanceLabelTotal.text = @"0元";
            [self.discountVY addSubview:redBalanceLabelTotal];

            BOOL isiOS7 = ([[UIDevice currentDevice].systemVersion floatValue]) >= 7.0;
            float positionX = isiOS7 ? (screentWith - 66) : (screentWith - 90);

            redBalanceLabel = [[UILabel alloc]
                    initWithFrame:CGRectMake(0, positionY + (kPreferentialHeight - 15) * 0.5, positionX - 6, 15)];
            redBalanceLabel.backgroundColor = [UIColor clearColor];
            redBalanceLabel.textColor = [UIColor lightGrayColor];
            redBalanceLabel.font = [UIFont systemFontOfSize:13];
            redBalanceLabel.textAlignment = NSTextAlignmentRight;
            redBalanceLabel.text = @"";
            [self.discountVY addSubview:redBalanceLabel];

            redswitchCtrl = [[UISwitch alloc]
                    initWithFrame:CGRectMake(positionX, positionY + (kPreferentialHeight - 30) * 0.5, 40, 30)];
            // 修改UISwitch的颜色样式
            // 定义ON状态下的颜色
            redswitchCtrl.onTintColor = appDelegate.kkzBlue;
            [redswitchCtrl sizeToFit];
            [redswitchCtrl addTarget:self action:@selector(useRedHandler:) forControlEvents:UIControlEventValueChanged];
            [self.discountVY addSubview:redswitchCtrl];

            self.redswitchCtrlTemp = redswitchCtrl;

            line3 = [[UIView alloc] initWithFrame:CGRectMake(0, positionY + kPreferentialHeight - 1, screentWith, 1)];
            line3.backgroundColor = [UIColor r:229 g:229 b:229];
            [self.discountVY addSubview:line3];

            positionY += kPreferentialHeight;

        }else{
            positionY = 0;
        }


        //标识是否有活动标签的展示
        self.newUserH = 0;

        //抵扣优惠情况，还需要支付的金额

        moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, positionY + self.newUserH, screentWith, 180)];
        moneyView.backgroundColor = [UIColor r:245 g:245 b:245];

        [self insertSubview:moneyView aboveSubview:self.discountVY];
        self.moneyViewY = moneyView;

        UILabel *billTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, 5, screentWith - kMarginX * 2, 35)];
        billTitleLbl.text = @"结算信息";
        billTitleLbl.backgroundColor = [UIColor clearColor];
        billTitleLbl.textColor = [UIColor r:100 g:100 b:100];
        billTitleLbl.font = [UIFont systemFontOfSize:15];
        [moneyView addSubview:billTitleLbl];

        UIView *billDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, screentWith, 140)];
        [billDetailView setBackgroundColor:[UIColor whiteColor]];
        [moneyView addSubview:billDetailView];

        CGFloat billposition = 10;

        UILabel *totalMaoneyLbl = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, billposition, 75, 23)];
        totalMaoneyLbl.backgroundColor = [UIColor clearColor];
        totalMaoneyLbl.textColor = [UIColor r:153 g:153 b:153];
        totalMaoneyLbl.textAlignment = NSTextAlignmentLeft;
        totalMaoneyLbl.text = @"购票总价";
        totalMaoneyLbl.font = [UIFont systemFontOfSize:14];
        [billDetailView addSubview:totalMaoneyLbl];

        totalMaoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, billposition, screentWith - 90 - 15, 23)];
        totalMaoneyLabel.backgroundColor = [UIColor clearColor];
        totalMaoneyLabel.textColor = [UIColor r:102 g:102 b:102];
        totalMaoneyLabel.textAlignment = NSTextAlignmentRight;
        totalMaoneyLabel.font = [UIFont systemFontOfSize:14];
        totalMaoneyLabel.hidden = NO;
        totalMaoneyLabel.text = @"";
        [billDetailView addSubview:totalMaoneyLabel];

        billposition += 23;

        UILabel *activityLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, billposition, 75, 23)];
        activityLbl.backgroundColor = [UIColor clearColor];
        activityLbl.textColor = [UIColor r:153 g:153 b:153];
        activityLbl.textAlignment = NSTextAlignmentLeft;
        activityLbl.text = @"活动优惠";
        activityLbl.font = [UIFont systemFontOfSize:14];
        [billDetailView addSubview:activityLbl];

        activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, billposition, screentWith - 90 - 15, 23)];
        activityLabel.backgroundColor = [UIColor clearColor];
        activityLabel.textColor = [UIColor r:1 g:159 b:1];
        activityLabel.textAlignment = NSTextAlignmentRight;
        activityLabel.font = [UIFont systemFontOfSize:14];
        activityLabel.hidden = NO;
        activityLabel.text = @"";
        [billDetailView addSubview:activityLabel];

        billposition += 23;

        UILabel *redPacketLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, billposition, 75, 23)];
        redPacketLbl.backgroundColor = [UIColor clearColor];
        redPacketLbl.textColor = [UIColor r:153 g:153 b:153];
        redPacketLbl.textAlignment = NSTextAlignmentLeft;
        redPacketLbl.text = @"红包抵用";
        redPacketLbl.font = [UIFont systemFontOfSize:14];
        [billDetailView addSubview:redPacketLbl];

        redPacketLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, billposition, screentWith - 90 - 15, 23)];
        redPacketLabel.backgroundColor = [UIColor clearColor];
        redPacketLabel.textColor = [UIColor r:1 g:159 b:1];
        redPacketLabel.textAlignment = NSTextAlignmentRight;
        redPacketLabel.font = [UIFont systemFontOfSize:14];
        redPacketLabel.hidden = NO;
        redPacketLabel.text = @"-￥0.00";
        [billDetailView addSubview:redPacketLabel];

        billposition += 23;

        UILabel *preferentialcardLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, billposition, 75, 23)];
        preferentialcardLbl.backgroundColor = [UIColor clearColor];
        preferentialcardLbl.textColor = [UIColor r:153 g:153 b:153];
        preferentialcardLbl.textAlignment = NSTextAlignmentLeft;
        preferentialcardLbl.text = @"卡券抵用";
        preferentialcardLbl.font = [UIFont systemFontOfSize:14];
        [billDetailView addSubview:preferentialcardLbl];

        preferentialcardLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, billposition, screentWith - 90 - 15, 23)];
        preferentialcardLabel.backgroundColor = [UIColor clearColor];
        preferentialcardLabel.textColor = [UIColor r:1 g:159 b:1];
        preferentialcardLabel.textAlignment = NSTextAlignmentRight;
        preferentialcardLabel.font = [UIFont systemFontOfSize:14];
        preferentialcardLabel.hidden = NO;
        preferentialcardLabel.text = @"-￥0.00";
        [billDetailView addSubview:preferentialcardLabel];

        billposition += 24;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, billposition, 88, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = @"实付款";
        label.font = [UIFont systemFontOfSize:15];
        [billDetailView addSubview:label];

        UILabel *payMethodLabel =
                [[UILabel alloc] initWithFrame:CGRectMake(88, billposition, screentWith - 88 - 15, 30)];
        payMethodLabel.backgroundColor = [UIColor clearColor];
        payMethodLabel.textAlignment = NSTextAlignmentRight;
        payMethodLabel.textColor = appDelegate.kkzDarkYellow;
        payMethodLabel.text = [NSString stringWithFormat:@"￥%.2f", self.orderTotalFee];
        payMethodLabel.font = [UIFont systemFontOfSize:20];
        [billDetailView addSubview:payMethodLabel];
        self.payMethodLabelY = payMethodLabel;

        //购票须知

        noticeLabView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyView.frame), screentWith, 20)];
        [self addSubview:noticeLabView];

        UILabel *noticelbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 88, 35)];
        noticelbl.backgroundColor = [UIColor clearColor];
        noticelbl.textColor = [UIColor r:100 g:100 b:100];
        noticelbl.textAlignment = NSTextAlignmentLeft;
        noticelbl.text = @"购票须知";
        noticelbl.font = [UIFont systemFontOfSize:15];
        [noticeLabView addSubview:noticelbl];

        noticeLabY = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, screentWith - 15 * 2, 20)];
        noticeLabY.numberOfLines = 0;
        noticeLabY.text = @"";
        noticeLabY.font = [UIFont systemFontOfSize:14];
        noticeLabY.textColor = [UIColor grayColor];
        [noticeLabY setBackgroundColor:[UIColor clearColor]];
        [self addSubview:noticeLabY];

        self.noticeLab = noticeLabY;

        [noticeLabView addSubview:noticeLabY];
*/
        payMethodList = [[NSMutableArray alloc] init];
        _ecardNoList = [[NSMutableArray alloc] initWithCapacity:0];

        [[UserManager shareInstance] updateBalance:nil failure:nil];

        //        AccountTask *task = [[AccountTask alloc] initQueryBalance:^(BOOL succeeded, NSDictionary *userInfo){
        //        }];
        //        [[TaskQueue sharedTaskQueue] addTaskToQueue:task];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showbalancenotice)
                                                     name:@"ImprestSucceed"
                                                   object:nil];
    }
    return self;
}

//初始化之后的赋值
- (void)setOrderNo:(NSString *)orderNo {
    _orderNo = orderNo;
    [self getCouponsTask];
}

//初始化之后的赋值
- (void)setOrderTotalFee:(CGFloat)orderTotalFee {
    self.payMethodLabelY.text = [NSString stringWithFormat:@"￥%.2f", orderTotalFee];
    _orderTotalFee = orderTotalFee;
}

- (void)doPayTypeTask {
    
    self.totalPrice = [self.myOrder.unitPrice floatValue] * [self.myOrder.count floatValue];
    totalMaoneyLabel.text = [NSString
                             stringWithFormat:@"￥%.2f", [self.myOrder.money floatValue]]; //self.totalPrice];
    activityLabel.text = [NSString stringWithFormat:@"-￥%.2f", [self.myOrder.discountAmount floatValue]];
    
    PaymentModel *wechatModel = [[PaymentModel alloc] init];
    wechatModel.intro = @"wx";
    wechatModel.payMethod = PayMethodWeiXin;
    wechatModel.desc = @"wx";
    [payMethodList addObject:wechatModel];
    
    PaymentModel *alpayModel = [[PaymentModel alloc] init];
    alpayModel.intro = @"ali";
    alpayModel.payMethod = PayMethodAliMoblie;
    alpayModel.desc = @"ali";
    [payMethodList addObject:alpayModel];
    
    self.selectedIndex = 1;
    
    [self updateLayout];
    
    if (self.selectedIndex != -1) {
        NSIndexPath *p = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
        [self tableView:self.payTypeTableViewY didSelectRowAtIndexPath:p];
    }
    /*
    PayTask *task = [[PayTask alloc] initGetPayType:_orderNo
                                           finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                               if (succeeded) {
                                                   [self payTypeFinished:userInfo status:succeeded];
                                               }
                                           }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
     */
}

- (void)doRedCouponTask {
    RedCouponTask *task1 = [[RedCouponTask alloc] initUserRedCouponFee:self.orderTotalFee
                                                            andOrderNo:self.orderNo
                                                              finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                  [self redbalanceFinished:userInfo status:succeeded];
                                                              }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task1];
}

- (void)doRedAccountsTask {
    if (KShowRedBalance == NO) {
        return;
    }
    RedCouponTask *task1 =
            [[RedCouponTask alloc] initUserRedAccountsUserfinished:^(BOOL succeeded, NSDictionary *userInfo) {
                [self redAccountsFinished:userInfo status:succeeded];
            }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task1];
}

#pragma mark - Table View Data Source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"PayTypeCellIdentifier";

    PayTypeCell *cell = (PayTypeCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PayTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(279, 7, 23, 23)];
        cell.accessoryView = imageView;
        cell.isbalanotHid = YES;
    }

    UIImageView *imageView = (UIImageView *) cell.accessoryView;
    PaymentModel *model = [payMethodList objectAtIndex:indexPath.row];
    PayMethod method = model.payMethod;

    if (selectedMethod == method) {
        imageView.image = [UIImage imageNamed:@"select_method_icon"];
    } else {
        imageView.image = [UIImage imageNamed:@"unselect_method_icon"];
    }

    cell.memberSubTitle = model.intro;

    //    if (self.detailTitleArray.count > indexPath.row) {
    //
    //
    //        for (int i = 0; i < self.detailTitleArray.count; i ++ ) {
    //
    //            PaymentModel *model= self.detailTitleArray[i];
    //
    //            if (model.payMethod == method) {
    //                 cell.memberSubTitle = model.intro;
    //            }
    //        }
    //
    //    }
    cell.payTypeNum = method;
    [cell updateLayout];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return payMethodList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPathY = indexPath;
    DLog(@"indexPath.row  =========   %ld", (long) indexPath.row);
    PaymentModel *model = [payMethodList objectAtIndex:indexPath.row];
    PayMethod method = model.payMethod;

    if (selectedMethod == method) {
        // unselect
        selectedMethod = PayMethodNone;
    } else {
        if ([self moneyToPay] <= 0) {
            return;
        }
        selectedMethod = method;
    }

    [self.payTypeTableViewY reloadData];
    USER_HASAlipay_WRITE(YES);
    [self moneyToPay];

    [self showbalancenotice];
}

#pragma mark utility
- (void)updateLayout {

    CinemaDetail *aCinema = self.myOrder.plan.cinema;

    CGSize noticeText = [aCinema.notice sizeWithFont:[UIFont systemFontOfSize:14]
                                   constrainedToSize:CGSizeMake(screentWith - 15 * 2, CGFLOAT_MAX)];

    self.noticeLab.text = aCinema.notice;

    if (aCinema.notice.length) {
        self.noticeLab.frame = CGRectMake(15, 40, screentWith - 15 * 2, noticeText.height);
        noticeLabView.frame = CGRectMake(0, CGRectGetMaxY(moneyView.frame), screentWith, noticeText.height + 40);
        noticeLabView.hidden = NO;
    } else {
        noticeLabView.hidden = YES;
    }

    self.payMethodListY = [payMethodList copy];

    balanceLabel.text = [NSString stringWithFormat:@"%.2f", [DataEngine sharedDataEngine].vipBalance];
    totalMoneyLabel.text = [NSString stringWithFormat:@"订单金额：%.2f元", [self.myOrder moneyToPay]];

    self.payTypeTableViewY.frame =
            CGRectMake(0, 90, screentWith, 70 * payMethodList.count);
    [self.payTypeTableViewY reloadData];

    discountViewTip.frame = CGRectMake(0, CGRectGetMaxY(self.payTypeTableViewY.frame), screentWith, 40);
    self.discountVY.frame = CGRectMake(0, CGRectGetMaxY(self.payTypeTableViewY.frame) + 40, screentWith,
                                       kPreferentialHeight * (KShowRedBalance ? 2:1) + self.newUserH);

    moneyView.frame = CGRectMake(0, CGRectGetMaxY(self.discountVY.frame), screentWith, 180);

    CGRect f = noticeLabView.frame;
    f.origin.y = CGRectGetMaxY(moneyView.frame);
    noticeLabView.frame = f;

    CGRect payviewF = self.frame;
    payviewF.size.height = CGRectGetMaxY(noticeLabView.frame);
    self.frame = payviewF;

    if (self.delegate && [self.delegate respondsToSelector:@selector(heightDidChange)]) {
        [self.delegate heightDidChange];
    }
}

/*
 点完红包的切换按钮后的处理方法
 */
- (void)useRedHandler:(UISwitch *)sender {
    //启用红包
    if (sender.on) {
        //是否有红包金额可以使用
        if (self.redCouponAvailable <= 0) {
            [appDelegate showAlertViewForTitle:@"" message:@"暂无可使用的红包" cancelButton:@"确定"];
            [sender setOn:NO];
            return;
        }

        //判断现在是否使用兑换券，并先提示，如果用户确认取消兑换券，则可以切换到红包
        if (self.selectedPromotion == PromotionTypeCoupon) {
            RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"否"];
            cancel.action = ^{
                [sender setOn:NO];
                return;
            };

            RIButtonItem *done = [RIButtonItem itemWithLabel:@"是"];
            done.action = ^{
                self.selectedPromotion = PromotionTypeRedCoupon;
            };

            UIAlertView *alert =
                    [[UIAlertView alloc] initWithTitle:@""
                                               message:@"红"
                                                       @"包不允许与优惠券或兑换券同时使用，要取消选用的兑换券吗？"
                                      cancelButtonItem:cancel
                                      otherButtonItems:done, nil];
            [alert show];
        } else {
            self.selectedPromotion = PromotionTypeRedCoupon;
        }
    } else {
        self.selectedPromotion = PromotionTypeNone;
    }
}

/*
 选择使用兑换券后的处理逻辑
 */
- (void)couponBtnClick {

    void (^showCouponList)(void) = ^{
        //启用兑换码
        ccv = [[CouponCheckViewController alloc] initWithSelectedCoupons:self.ecardNoList
                                                            andFirstLoad:self.isFirstLoad];
        self.isFirstLoad = NO;
        ccv.orderNo = self.orderNo;
        ccv.orderTotalFee = self.orderTotalFee;
        ccv.ecardValue = self.selectedEcardValue;

        __weak typeof(self) weakSelf = self;
        ccv.CouponAmountBlock = ^(float num, NSMutableArray *couponNos) {
            DLog(@"MyCustomView---%.2f", num);

            weakSelf.ecardNoList = couponNos;
            weakSelf.ecardListStr = [couponNos componentsJoinedByString:@","];
            weakSelf.selectedEcardValue = num;

            if (num) {
                weakSelf.selectedPromotion = PromotionTypeCoupon;
            } else {
                weakSelf.selectedPromotion = PromotionTypeNone;
            }

            [weakSelf getCouponsTask];
        };

        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ccv animation:CommonSwitchAnimationBounce];
    };

    //判断现在是否使用红包，并先提示，如果用户确认取消红包，则可以切换到兑换券
    if (self.selectedPromotion == PromotionTypeRedCoupon) {
        RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"否"];
        cancel.action = ^{
            return;
        };

        RIButtonItem *done = [RIButtonItem itemWithLabel:@"是"];
        done.action = ^{
            self.redswitchCtrlTemp.on = NO;
            showCouponList();
        };

        UIAlertView *alert = [[UIAlertView alloc]
                   initWithTitle:@""
                         message:@"红包不允许与优惠券或兑换券同时使用，要取消选用的红包吗？"
                cancelButtonItem:cancel
                otherButtonItems:done, nil];
        [alert show];
    } else {
        showCouponList();
    }
}

//点击 支付
- (void)payOrder {
    if (self.hasOrderExpired) {
        [appDelegate showAlertViewForTitle:@"" message:@"此订单已经过期" cancelButton:@"好的"];
        [self.delegate payOrderBtnEnable:YES];
        return;
    }

    //钱不够，并且没有选择支付方式
    if ([self moneyToPay] > 0 && selectedMethod == PayMethodNone) {
        if ([self discountMoney] > 0) {
            [appDelegate showAlertViewForTitle:nil
                                       message:@"请选择补齐差额的支付方式"
                                  cancelButton:@"好的"];
            [self.delegate payOrderBtnEnable:YES];
            return;
        } else {
            [appDelegate showAlertViewForTitle:nil message:@"请选择支付方式" cancelButton:@"好的"];
            [self.delegate payOrderBtnEnable:YES];
            return;
        }
    }

    if (selectedMethod == PayMethodVip) {
        CGFloat balance = [DataEngine sharedDataEngine].vipBalance;
        if (selectedMethod == PayMethodVip && [self moneyToPay] - balance > 0.0001) {
            //在这里跳转充值界面 弹出窗口提示
            [self.delegate payOrderBtnEnable:YES];

            ImprestViewController *ctr = [[ImprestViewController alloc] init];

            CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
            [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
            return;
        }
        _balanceToUse = [self moneyToPay];
    }

    //友盟事件：支付订单
    StatisEvent(EVENT_BUY_PAY_ORDER);
    if (appDelegate.selectedTab == 0) { //电影入口
        StatisEvent(EVENT_BUY_PAY_ORDER_SOURCE_MOVIE);
    } else if (appDelegate.selectedTab == 1) {
        StatisEvent(EVENT_BUY_PAY_ORDER_SOURCE_CINEMA);
    }
    
    KKZAnalyticsEvent *event = [[KKZAnalyticsEvent alloc] initWithOrder:self.myOrder];
    NSString *payMethod = @"";
    switch (selectedMethod) {
        case PayMethodAliMoblie:
            payMethod = @"alipay-only";
            break;
        case PayMethodUnionpay:
            payMethod = @"ebank-only";
            break;
        case PayMethodAliWeb:
            payMethod = @"alipay-only";
            break;
        case PayMethodWeiXin:
            payMethod = @"wechat-only";
            break;
        case PayMethodVip:
            payMethod = @"balance-only ";
            break;
        case PayMethodYiZhiFu:
            payMethod = @"yipay-only";
            break;
        default:
            break;
    }
    event.pay_channel = payMethod;
    event.total_amount = self.totalPrice;
    event.price = self.orderTotalFee;
    [KKZAnalytics postActionWithEvent:event action:AnalyticsActionConfirm_pay];

    PayTask *task =
            [[PayTask alloc] initPayOrder:_orderNo
                                 useMoney:_balanceToUse
                                   eCards:_ecardListStr
                             useRedCoupon:(self.selectedPromotion == PromotionTypeRedCoupon ? [self discountMoney] : 0)
                                  payType:selectedMethod
                                 finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                     [self payOrderFinished:userInfo status:succeeded];
                                 }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        //        [appDelegate showIndicatorWithTitle:@"支付订单"
        //                                   animated:YES
        //                                 fullScreen:NO
        //                               overKeyboard:NO
        //                                andAutoHide:NO];
    }
}

- (void)payTypeFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {
        DLog(@"pay type succeeded");
        self.totalPrice = [self.myOrder.unitPrice floatValue] * [self.myOrder.count floatValue];
        totalMaoneyLabel.text = [NSString
                stringWithFormat:@"￥%.2f", self.totalPrice];
        activityLabel.text = [NSString stringWithFormat:@"-￥%.2f", [self.myOrder.discountAmount floatValue]];

        NSMutableArray *payMethodArr = [userInfo objectForKey:@"payModels"];
        for (int i = 0; i < payMethodArr.count; i++) {
            PaymentModel *model = payMethodArr[i];

            switch (model.payMethod) {
                case PayMethodVip: //余额
                    [payMethodList addObject:model];
                    if (model.selected) {
                        self.selectedIndex = payMethodList.count - 1;
                    }
                    break;
                case PayMethodAliMoblie: //支付宝支付
                    [payMethodList addObject:model];
                    if (model.selected) {
                        self.selectedIndex = payMethodList.count - 1;
                    }
                    break;
                case PayMethodUnionpay: //银联支付
                    [payMethodList addObject:model];
                    if (model.selected) {
                        self.selectedIndex = payMethodList.count - 1;
                    }
                    break;
                case PayMethodWeiXin: //微信支付
                    [payMethodList addObject:model];
                    if (model.selected) {
                        self.selectedIndex = payMethodList.count - 1;
                    }
                    break;
                case PayMethodYiZhiFu: //翼支付
                    [payMethodList addObject:model];
                    if (model.selected) {
                        self.selectedIndex = payMethodList.count - 1;
                    }
                    break;
                case PayMethodJingDong: //京东支付
                    [payMethodList addObject:model];
                    if (model.selected) {
                        self.selectedIndex = payMethodList.count - 1;
                    }
                    break;
                case PayMethodPuFa: //浦发银行支付
                    [payMethodList addObject:model];
                    if (model.selected) {
                        self.selectedIndex = payMethodList.count - 1;
                    }
                    break;
                default:
                    break;
            }
        }

        [self updateLayout];

        if (self.selectedIndex != -1) {
            NSIndexPath *p = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
            [self tableView:self.payTypeTableViewY didSelectRowAtIndexPath:p];
        }
    }
}

- (void)redbalanceFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {
        NSDecimalNumber *decNum =
                [[NSDecimalNumber alloc] initWithString:[userInfo kkz_stringForKey:@"availableAmount"]];
        self.redCouponAvailable = decNum.doubleValue;

        if (self.redCouponAvailable <= 0) {
            self.redswitchCtrlTemp.on = NO;
            self.redswitchCtrlTemp.userInteractionEnabled = NO;
            redBalanceLabel.text = @"可抵用0.00元";
        } else {
            redBalanceLabel.text = [NSString stringWithFormat:@"可抵用%.2f元", self.redCouponAvailable];
        }
    }
}

- (void)redAccountsFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {
        NSDecimalNumber *decNum = [[NSDecimalNumber alloc] initWithString:[userInfo kkz_stringForKey:@"redAccounts"]];
        redBalanceLabelTotal.text = [NSString stringWithFormat:@"%.2f元", decNum.doubleValue];
        CGSize s = [redBalanceLabelTotal.text sizeWithFont:[UIFont systemFontOfSize:14]
                                         constrainedToSize:CGSizeMake(CGFLOAT_MAX, 24)];
        CGRect f = redBalanceLabelTotal.frame;
        f.size.width = s.width + 8;
        redBalanceLabelTotal.frame = f;
    }
}

//支付完成-订单确认完成
- (void)payOrderFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];
    [self.delegate payOrderBtnEnable:YES];

    if (succeeded) {
        DLog(@"payurl succeeded");
        if (selectedMethod == PayMethodAliMoblie || selectedMethod == PayMethodWeiXin ||
            selectedMethod == PayMethodUnionpay || selectedMethod == PayMethodYiZhiFu ||
            selectedMethod == PayMethodJingDong || selectedMethod == PayMethodPuFa) {
            NSString *payUrl = [userInfo objectForKey:@"payUrl"];
            NSString *sign = [userInfo objectForKey:@"sign"];
            NSString *oNo = [userInfo objectForKey:@"orderNo"];
            NSString *spId = [userInfo objectForKey:@"spId"];
            NSString *sysProvide = [userInfo objectForKey:@"sysProvide"];

            if ([oNo isEqualToString:_orderNo]) {
                //微信支付
                if (selectedMethod == PayMethodWeiXin) {

                    if ([WXApi isWXAppInstalled]) {
                        //判断是否有微信
                        PAY_WEIXIN_TYPE_WRITE(@"payorder");

                        NSData *jsonData = [payUrl dataUsingEncoding:NSUTF8StringEncoding];
                        NSError *err;
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:&err];

                        NSMutableString *stamp = [dic objectForKey:@"timestamp"];

                        //调起微信支付
                        PayReq *req = [[PayReq alloc] init];
                        req.openID = [dic objectForKey:@"appid"];
                        req.partnerId = [dic objectForKey:@"partnerid"];
                        req.prepayId = [dic objectForKey:@"prepayid"];
                        req.nonceStr = [dic objectForKey:@"noncestr"];
                        req.timeStamp = stamp.intValue;
                        req.package = [dic objectForKey:@"package"];
                        req.sign = [dic objectForKey:@"sign"];

                        DLog(@"req.openID = %@  req.partnerId = %@  req.prepayId = %@  req.nonceStr = %@  "
                             @"req.timeStamp = %d  req.package = %@  req.sign = %@  ",
                             req.openID, req.partnerId, req.prepayId, req.nonceStr, (unsigned int) req.timeStamp,
                             req.package, req.sign);
                        [WXApi sendReq:req];
                    } else {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                            message:@"您还没有安装微信客户端"
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                    }

                } else if (selectedMethod == PayMethodJingDong) {

                    NSString *payUrl = [userInfo objectForKey:@"payUrl"];
                    NSString *key = [userInfo objectForKey:@"key"];

                    if (payUrl.length) {
                        JDPayViewController *jdctr = [[JDPayViewController alloc] init];
                        [jdctr loadURL:payUrl];
                        jdctr.orderNo = _orderNo;
                        jdctr.key = key;

                        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
                        [parentCtr pushViewController:jdctr animation:CommonSwitchAnimationSwipeR2L];
                    }

                } else if (selectedMethod == PayMethodPuFa) {
                    NSString *payUrl = [userInfo objectForKey:@"payUrl"];
                    NSMutableDictionary *dic = [payUrl getParams];
                    CommonViewController *controller = [KKZUtility getRootNavagationLastTopController];
                    SpdPayViewController *webView = [[SpdPayViewController alloc] init];
                    webView.requestURL = dic[paramURL];
                    NSString *parameterString = dic[parameter];
                    webView.parameters = parameterString;
                    [controller pushViewController:webView animation:CommonSwitchAnimationBounce];

                } else if (_delegate &&
                           [_delegate respondsToSelector:@selector(payOrderMethod:payUrl:sign:spId:sysProvide:)]) {
                    //调用第三方支付控件
                    [_delegate payOrderMethod:selectedMethod payUrl:payUrl sign:sign spId:spId sysProvide:sysProvide];
                }
            }
        } else {
            //支付成功。（账户余额支付）优惠券 或者 兑换券
            //统计事件：订单支付成功
            StatisEvent(EVENT_BUY_ORDER_SUCCESS);
            if (appDelegate.selectedTab == 0) { //电影入口
                StatisEvent(EVENT_BUY_ORDER_SUCCESS_SOURCE_MOVIE);
            } else if (appDelegate.selectedTab == 1) {
                StatisEvent(EVENT_BUY_ORDER_SUCCESS_SOURCE_CINEMA);
            }

            OrderPayViewController *dd = [[OrderPayViewController alloc] initWithOrder:self.orderNo];
            dd.order = self.myOrder;
            CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
            [parentCtr pushViewController:dd animation:CommonSwitchAnimationSwipeR2L];
        }
    } else {
        //统计事件：订单支付失败
        StatisEvent(EVENT_BUY_ORDER_FAILED);

        DLog(@"payurl failed");
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

- (void)setPromotionTitle:(NSString *)promotionTitle {
    if (promotionTitle.length > 0) {
        self.newUserH = kPreferentialHeight;
        //新用户首单9.9元

        self.discountVY.frame = CGRectMake(0, CGRectGetMaxY(self.payTypeTableViewY.frame) + 40, screentWith,
                                           kPreferentialHeight * (KShowRedBalance ? 2:1)  + self.newUserH);

        CGFloat discountVPositonNow = self.discountVY.frame.size.height - self.newUserH;

        CGSize s = [self.myOrder.promotion.promotionTitleName sizeWithFont:[UIFont systemFontOfSize:15]
                                                         constrainedToSize:CGSizeMake(CGFLOAT_MAX, 15)];

        newUserLabelTitle = [[UILabel alloc]
                initWithFrame:CGRectMake(15, discountVPositonNow + (kPreferentialHeight - 16) * 0.5, s.width + 18, 16)];

        newUserLabelTitle.backgroundColor = [UIColor clearColor];
        newUserLabelTitle.textColor = [UIColor r:1 g:159 b:1];
        newUserLabelTitle.font = [UIFont systemFontOfSize:15];
        newUserLabelTitle.text = [NSString stringWithFormat:@"[%@]", self.myOrder.promotion.promotionTitleName];
        [self.discountVY addSubview:newUserLabelTitle];

        newUserLabel = [[UILabel alloc]
                initWithFrame:CGRectMake(CGRectGetMaxX(newUserLabelTitle.frame) + 3,
                                         discountVPositonNow + (kPreferentialHeight - 16) * 0.5,
                                         screentWith - CGRectGetMaxX(newUserLabelTitle.frame) - 15, 16)];
        newUserLabel.backgroundColor = [UIColor clearColor];
        newUserLabel.textColor = [UIColor r:50 g:50 b:50];
        newUserLabel.font = [UIFont systemFontOfSize:15];
        newUserLabel.text = promotionTitle;
        [self.discountVY addSubview:newUserLabel];

        UIView *line4 = [[UIView alloc]
                initWithFrame:CGRectMake(0, discountVPositonNow + kPreferentialHeight - 1, screentWith, 1)];
        line4.backgroundColor = [UIColor r:229 g:229 b:229];
        [self.discountVY addSubview:line4];

        CGRect f0 = line3.frame;
        f0.origin.x = 15;
        line3.frame = f0;

        //抵扣优惠情况，还需要支付的金额
        moneyView.frame = CGRectMake(0, CGRectGetMaxY(self.discountVY.frame), screentWith, 180);

        CGRect f = noticeLabView.frame;
        f.origin.y = CGRectGetMaxY(moneyView.frame);
        noticeLabView.frame = f;

        CGRect payviewF = self.frame;
        payviewF.size.height = CGRectGetMaxY(noticeLabView.frame);
        self.frame = payviewF;

        if (self.delegate && [self.delegate respondsToSelector:@selector(heightDidChange)]) {

            [self.delegate heightDidChange];
        }
    }
}

//查询兑换券的数量
- (void)getCouponsTask {
    PayTask *task = [[PayTask alloc] initCouponListforOrder:self.orderNo
                                                   finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                       [self couponListFinished:userInfo status:succeeded];
                                                   }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)couponListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {

    [appDelegate hideIndicator];
    [ecardRightList removeAllObjects];

    if (succeeded) {

        ecardRightList = [userInfo objectForKey:@"rightCouponList"];
        if (ecardRightList.count > 0) {

            [newEcardTitleBtn setTitle:[NSString stringWithFormat:@"%lu张", (unsigned long) ecardRightList.count]
                              forState:UIControlStateNormal];
            newEcardTitleBtn.hidden = NO;
        } else {
            [newEcardTitleBtn setTitle:@"0张" forState:UIControlStateNormal];
            newEcardTitleBtn.hidden = NO;
        }

    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

@end
