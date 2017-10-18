//
//  Order.h
//  CIASMovie
//
//  Created by cias on 2017/1/10.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "OrderTicket.h"
#import "OrderMain.h"
#import "Activity.h"

@interface Order : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString * filmPriceDesc;
@property (nonatomic, copy)NSString * filmType;
@property (nonatomic, copy)NSString * firstSeatInfo;
@property (nonatomic, copy)NSString * goodsPriceDesc;//
@property (nonatomic, strong)NSArray * goodsPriceStrList;
@property (nonatomic, strong)NSArray * orderDetailGoodsList;
@property (nonatomic, copy)NSString * remainTime;
@property (nonatomic, copy)NSString * secondSeatInfo;
@property (nonatomic, copy)NSString * totalMoney;
@property (nonatomic, copy)NSString * totalPrice;
@property (nonatomic, copy)NSString * receiveMoney;
@property (nonatomic, copy)NSString * serviceCharge;

@property (nonatomic, copy)NSString * totalPriceGoods;//卖品的价格
@property (nonatomic, copy)NSString * totalPriceTicket;//影票的价格
@property (nonatomic, copy)NSString * actualReceiveMoney;
@property (nonatomic, copy)NSString * mobile;

@property (nonatomic, copy)NSString * ticketPriceStr;
@property (nonatomic, copy)NSString * ticketStatus;
@property (nonatomic, copy)NSString * payType;
@property (nonatomic, copy)NSString * payTime;
@property (nonatomic, copy)NSString * payStatus;

@property (nonatomic, strong)OrderTicket * orderTicket;
@property (nonatomic, strong)OrderMain * orderMain;
@property (nonatomic, strong)NSDictionary * couponsCountMap;//卖品
@property (nonatomic, strong)Activity * discount;//type=1是
@property (nonatomic, copy)NSString * activeDiscountMoney;
@property (nonatomic, copy)NSString *distance;//距离

@end
