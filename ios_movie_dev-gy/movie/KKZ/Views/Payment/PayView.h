//
//  支付订单页面支付方式+优惠抵扣+结算信息+购票须知
//
//  Created by alfaromeo on 12-3-9.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "Constants.h"
#import "CouponCheckViewController.h"
#import "EcardCell.h"
#import "HorizonTableView.h"
#import "MemContainer.h"
#import "RoundCornersButton.h"
#import "WXApi.h"

typedef enum {
    PromotionTypeNone = 0,
    PromotionTypeRedCoupon = 1,
    PromotionTypeCoupon = 2
} PromotionType;

@protocol PayViewDelegate <NSObject>
- (void)payOrderBtnEnable:(BOOL)isEnable;
@optional
- (void)heightDidChange;
- (void)textFieldShouldBeginEditing;
- (void)textFieldShouldEndEditing;
- (void)payOrderMethod:(PayMethod)selectedMethod
                payUrl:(NSString *)payUrl
                  sign:(NSString *)sign
                  spId:(NSString *)spId
            sysProvide:(NSString *)sysProvide;
@end

@interface PayView : UIView <UITableViewDataSource, UITableViewDelegate, WXApiDelegate> {
    NSMutableArray *ecardList, *payMethodList;

    UILabel *balanceLabel, *useBalanceLabel, *tipLabel, *totalMoneyLabel, *couponMoneyLabel, *totalMaoneyLabel, *activityLabel, *redPacketLabel, *preferentialcardLabel;
    UILabel *noticeLabY;
    UIButton *redBalanceBtn;
    UILabel *redBalanceLabel, *redBalanceLabelTotal, *newEcardTitleLabel;
    UILabel *newUserLabel, *newUserLabelTitle;
    UIButton *newEcardTitleBtn;
    UIImageView *backgroundView;
    RoundCornersButton *payConfirmButton;
    UIButton *tipButton;
    RoundCornersButton *deleteOrderButton;
    RoundCornersButton *newEcardbtn;
    RoundCornersButton *useBalanceBtn;
    CouponCheckViewController *ccv;
    UIView *phoneView, *moneyView;

    UISwitch *redswitchCtrl;
    CGFloat positionYN;
    UIView *payMethodViewTip, *discountViewTip;
    NSMutableArray *ecardRightList, *ecardValidList;
    UIView *line3, *noticeLabView;
}

@property (nonatomic, weak) id<PayViewDelegate> delegate;

/**
 订单
 */
@property (nonatomic, strong) Order *myOrder;


@property (nonatomic, strong) NSString *ecardListStr;
@property (nonatomic, strong) NSMutableArray *ecardNoList;
@property (nonatomic, strong) UISwitch *redswitchCtrlTemp;

@property (nonatomic, assign) CGFloat orderTotalFee; //账单总金额
@property (nonatomic, assign) CGFloat balanceToUse; //账户可用余额
@property (nonatomic, assign) CGFloat redCouponAvailable; //红包金额
@property (nonatomic, assign) CGFloat selectedEcardValue; //电子券抵扣值
@property (nonatomic, assign) PromotionType selectedPromotion; //选择的优惠方式

@property (nonatomic, assign) BOOL hasOrderExpired;

@property (nonatomic, strong) NSString *cellName;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *groupbuyId;
@property (nonatomic, strong) NSString *groupbuyContent;
@property (nonatomic, assign) BOOL isGroupbuy;
@property (nonatomic, weak) UILabel *couponMoneyLabelY;
@property (nonatomic, weak) UILabel *payMethodLabelY;
@property (nonatomic, weak) UIView *moneyViewY;
@property (nonatomic, weak) UIView *phoneViewY;
@property (nonatomic, strong) UIView *discountVY;
@property (nonatomic, strong) UITableView *payTypeTableViewY;
@property (nonatomic, strong) NSMutableArray *payMethodListY;
@property (nonatomic, assign) CGFloat newUserH;
@property (nonatomic, copy) NSString *promotionTitle;
@property (nonatomic, strong) UILabel *noticeLab;
@property (nonatomic, strong) NSMutableArray *payMethodOrer;
@property (nonatomic, strong) NSIndexPath *indexPathY;
@property (nonatomic, strong) NSMutableArray *detailTitleArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) PayMethod selectedMethod;

@property (nonatomic, copy) void (^moneyToPayChanged)(CGFloat moneyToPay, PayMethod paymethod);

- (void)updateLayout;
- (void)payOrder;
- (void)doPayTypeTask;
- (void)doRedCouponTask;
- (void)doRedAccountsTask;

@end
