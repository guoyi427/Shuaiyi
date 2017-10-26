//
//  支付订单 - 使用优惠券/兑换券
//
//  Created by gree2 on 16/10/14.
//  Copyright (c) 2014 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AlertViewY.h"
#import "CheckCoupon.h"
#import "CommonViewController.h"
#import "EcardCell.h"
#import "PPiFlatSegmentedControl.h"
#import "ShowMoreButton.h"
#import "NoDataViewY.h"

@class EGORefreshTableHeaderView;

@interface CouponCheckViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate, ShowMoreButtonDelegate> {
    PPiFlatSegmentedControl *chooseSegmentView;
    UIScrollView *holder;
    NSInteger segmentIndexNum;

    NSMutableArray *ecardValidList, *ecardInvalidList, *selectedEcardList;
    UITableView *ecardTableView;

    UIView *couponView;
    UITextField *couponTextField;
    UIButton *useBtn;

    UILabel *disccountLabel, *disccountTipLabel;
    UIButton *useCouponBtn;
    //    float unitCouponFee;

    EGORefreshTableHeaderView *refreshHeaderView;
    ShowMoreButton *showMoreBtn;

    NSInteger currentPage;
    NSInteger selectedNum;
    BOOL tableLocked;
    BOOL isSupportOrder;
    UILabel *noRedAlertLabel;
    UIView *textFieldBg;
    UIView *textRe;
    CheckCoupon *couponY;

    NoDataViewY *nodataView;
    AlertViewY *noAlertView;
}

@property (nonatomic, copy) void (^CouponAmountBlock)(float couponFee, NSMutableArray *couponNos);

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) CheckCoupon *bindingCoupon;
@property (nonatomic, assign) float disccountNum;
@property (nonatomic, assign) float redCouponBalance;
@property (nonatomic, assign) float balanceToUse;
@property (nonatomic, assign) CGFloat ecardValue;
@property (nonatomic, assign) CGFloat orderTotalFee;
@property (nonatomic, assign) BOOL isRequesting;
@property (nonatomic, copy) NSString *bindingCardNo;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL isFromRefresh;
@property (nonatomic, strong) NSMutableArray *isSelectedIndexArr;

- (id)initWithSelectedCoupons:(NSArray *)coupons andFirstLoad:(NSInteger)isFirstLoad;

@end
