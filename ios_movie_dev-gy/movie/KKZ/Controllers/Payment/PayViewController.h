//
//  支付订单页面
//
//  Created by alfaromeo on 12-7-11.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "Coupon.h"
#import "EcardCell.h"
#import "Movie.h"
#import "PayView.h"
#import "UPPayPlugin.h"

@interface PayViewController : CommonViewController <UITextFieldDelegate, UIGestureRecognizerDelegate, PayViewDelegate, UPPayPluginDelegate, UITextFieldDelegate> {

    UIScrollView *holder;
    UIImageView *postImageView;
    NSString *orderNo;

    PayView *payView;
    UIView *seatBuyView;
    UIView *sosBgview, *phoneView, *phoneViewTap;

    UILabel *movieNameLabel, *timerLabel;
    UITextField *telephoneTextField;
    UILabel *movieTypeLabel;
    UILabel *cinemaNameLabel;
    UILabel *startTimeLabel;
    UILabel *hallLabel;
    UILabel *seatInfoLabel;
    UILabel *ticketPriceLabel;
    UILabel *ticketCountLabel;
    UILabel *totalMoneyLabel;

    NSTimer *timer;
    int timeCount;
    UIButton *backBtn;
    UIButton *seatBtn;
    float sliderH;

//    UITextField *telephoneField;

    UIView *backgroundView;
    UILabel *moneyNeedPayLabel;
}

@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *promotionId;
@property (nonatomic, strong) NSString *groupbuyContent;
@property (nonatomic, strong) NSString *groupbuyId;
@property (nonatomic, strong) NSDate *orderDate;
@property (nonatomic, strong) UILabel *moneyNeedPayLabelY;
@property (nonatomic, strong) UIButton *seatBtnY;

@property (nonatomic, strong) Coupon *myCoupon;
@property (nonatomic, strong) Order *myOrder;

@property (nonatomic, assign) BOOL isGroupbuy;
@property (nonatomic, assign) BOOL isFromCoupon;

@property (nonatomic, assign) BOOL isFromYiZhiFu;

- (id)initWithOrder:(NSString *)oNo;

@end
