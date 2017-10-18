//
//  OrderDetailOfMovie.h
//  CIASMovie
//
//  Created by avatar on 2017/1/22.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "OrderMain.h"
#import "OrderTicket.h"
#import "OrderPayment.h"
#import "OrderProduct.h"
#import "OrderDiscount.h"

@interface OrderDetailOfMovie : MTLModel<MTLJSONSerializing>
//ticketPriceStr
@property (nonatomic, copy)    NSString * ticketPriceStr; //
@property (nonatomic, strong)   NSArray * goodsPriceStrList;
@property (nonatomic, strong)   NSArray * orderDetailGoodsList;
//@property (nonatomic, copy)    NSString * ctx; //
@property (nonatomic, copy)    NSString * receiveMoney;
@property (nonatomic, copy)    NSString * serviceCharge;
@property (nonatomic, copy)    NSString * mobile;
@property (nonatomic, copy)    NSString * discountMoney; //
@property (nonatomic, copy)    NSString * discountTypeName; //
@property (nonatomic, strong) OrderDiscount * discount;

@property (nonatomic, strong) OrderMain * orderMain;
//firstSeatInfo
@property (nonatomic, copy)    NSString * firstSeatInfo; //
@property (nonatomic, copy)    NSString * secondSeatInfo; //
@property (nonatomic, copy)    NSString * filmType; //
@property (nonatomic, strong) OrderTicket * orderTicket;

@property (nonatomic, copy)    NSString * payType; //
@property (nonatomic, copy)    NSString * actualReceiveMoney; //
@property (nonatomic, copy)    NSString * activeDiscountMoney; //

@property (nonatomic, copy)    NSString * ticketStatus; //
@property (nonatomic, copy)    NSString * totalPrice; //
@property (nonatomic, copy)    NSNumber * payTime; //
@property (nonatomic, copy)    NSString * payStatus; //

@property (nonatomic, strong) OrderPayment * payment;


@end
