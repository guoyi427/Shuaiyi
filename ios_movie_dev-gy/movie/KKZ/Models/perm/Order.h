//
//  Order.h
//  KKZ
//
//  Created by zhang da on 11-11-6.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import <Mantle/Mantle.h>

@class OrderPayInfo;

#import "Ticket.h"
#import "Promotion.h"


//不要调整顺序, 和服务器的状态是对应的
typedef enum {
    OrderStateNormal = 1,//待支付，已经下完单。
    OrderStateCanceled, //已取消
    
    OrderStatePaid, //已付款和购票成功不一样，可能出票失败
    OrderStateBuySucceeded, //购票成功
    
    OrderStateBuyFailed,   //购票失败。
//        OrderStateFinished,   //已出票
    OrderStateBuyFailed6,   //购票失败 取消。
    OrderStateBuyFailed7,   //购票失败。
    OrderStateBuyFailed8,   //购票失败。
    
    //后两个数据不会返回。在线选座——显示已使用。兑换券——显示已过期。
    OrderStateRefund,  //已退款
    OrderStateTimeout  //已使用。后台10分钟不付款删除订单     支付超时失败
} OrderState;

typedef enum {
    OrderDiscountStateNotCheck = 0,
    OrderDiscountStateNo,
    OrderDiscountStateYes
} OrderDiscountState;

typedef enum {
    OrderReadStateNotCheck = 0,
    OrderReadStateChecked,
    OrderReadStateNo,
    OrderReadStateYes
} OrderReadState;


@interface Order : MTLModel <MTLJSONSerializing>

//shared
@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * orderTime;
@property (nonatomic, copy) NSNumber *activityId;
@property (nonatomic, copy) NSDate * payTime;
@property (nonatomic, copy) NSString * payUrl;

/**
 1 - Normal，2 - 已取消（用户取消），3 - 已付款，4 - 购票成功，5 - 购票失败，6 - 已取消（5删除后变6）
 */
@property (nonatomic, copy) NSNumber * orderStatus;

@property (nonatomic, copy) NSNumber * unitPrice;//单价 !!!!Str
@property (nonatomic, copy) NSNumber * agio;
@property (nonatomic, copy) NSNumber * vipUnitPrice;//vip单价 !!!!vipPrice 未在android中找到对应
@property (nonatomic, copy) NSString * orderMessage;//显示的信息 !!!!orderMsg
@property (nonatomic, copy) NSNumber * money;//订单总价（算优惠后的）
@property (nonatomic, copy) NSNumber * payMethod;//
@property (nonatomic, copy) NSNumber * activityCount;//
@property (nonatomic, copy) NSNumber * redMoney;//
@property (nonatomic, copy) NSNumber * count;//张数
@property (nonatomic, copy) NSString * callbackUrl;
@property (nonatomic, copy) NSNumber * discountAmount;//订单优惠的值

@property (nonatomic, strong) Ticket *plan;

@property (nonatomic, copy) NSString * seatNo;
@property (nonatomic, copy) NSString * seatInfo;//座位位置的数组


@property (nonatomic, strong) Promotion *promotion;


//票号 验证码
@property (nonatomic, copy) NSString * finalTicketNo;
@property (nonatomic, copy) NSString * finalVerifyCode;

@property (nonatomic, copy) NSString * finalTicketNoName; //票号
@property (nonatomic, copy) NSString * finalVerifyCodeName;//验证码

//取票信息
@property (nonatomic, copy) NSString * machineType;
@property (nonatomic, copy) NSString * machineTypeDesc;



- (NSString *)qrCodePath;
- (NSString *)orderStateDesc;
- (NSString *)movieTimeDesc;
- (NSInteger)seatCount;
- (NSString *)readableSeatInfos;
- (CGFloat)moneyToPay;
- (OrderPayInfo *)payInfo;

+ (NSString *)payMethodDesc:(PayMethod)method;



@end
