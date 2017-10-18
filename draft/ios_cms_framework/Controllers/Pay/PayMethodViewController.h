//
//  PayMethodViewController.h
//  CIASMovie
//
//  Created by cias on 2017/2/7.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "PlanDate.h"
#import "CardTypeDetail.h"
#import "OrderDetailOfMovie.h"

@interface PayMethodViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *payTableView;
    NSInteger selectedNum, payMethodType,payMethodNum;
    UIButton *confirmBtn;
    BOOL selected, isSame;
    NSTimer *timer;
    int timeCount;
    BOOL hasOrderExpired;
    UIView *topHeaderView;
    UIView *payMethodHeadView;
    UILabel *cinemaTitleLabel, *movieTitleLabel;
    UIButton * backButton;
    UILabel *moneyLabel, *orderNoLabel;
    PayMethod selectedMethod;

}
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *totalMoney;

@property (nonatomic, strong) CardTypeDetail *cardTypeDetail;
@property (nonatomic, strong) Order *myOrder;
@property (nonatomic, strong) OrderDetailOfMovie *myOrderDetail;
@property (nonatomic, assign) NSInteger selectPlanTimeRow;
@property (nonatomic, strong) NSMutableArray *planList;
@property (nonatomic, strong) PlanDate *selectPlanDate;
@property (nonatomic, assign) BOOL isFromOrder;
@property (nonatomic, assign) BOOL isFromRecharger;
@property (nonatomic, assign) BOOL isFromOpenCard;

@property (nonatomic, copy) NSString *rechargeMoney;
@property (nonatomic, copy) NSString *rechargeNo;
@property (nonatomic, assign) BOOL isFromOrderConfirm;

@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *movieName;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, copy) NSString *planId;//排期Id是对应接口返回的sessionId
@property (nonatomic, copy) NSString *selectPlanDateString;
@property (nonatomic, strong)NSNumber *createTime;//订单创建时间

@property (nonatomic, strong) NSMutableArray *payMethodList;
@property (nonatomic, strong) UIView *navBar;

@end
