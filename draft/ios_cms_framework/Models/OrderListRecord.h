//
//  OrderListRecord.h
//  CIASMovie
//
//  Created by avatar on 2017/1/22.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "OrderTicket.h"

@interface OrderListRecord : MTLModel<MTLJSONSerializing>


@property (nonatomic, copy) NSDate   *date; //
@property (nonatomic, copy) NSString *pkOrderMain; //
@property (nonatomic, copy) NSString *orderCode; //
@property (nonatomic, assign) long    orderType; //
@property (nonatomic, copy) NSString *goodsCount; //
@property (nonatomic, copy) NSString *userId; //
@property (nonatomic, copy) NSString *userAccount; //
@property (nonatomic, copy) NSString *originalPrice; //
@property (nonatomic, copy) NSString *discountMoney; //
@property (nonatomic, copy) NSString *serviceCharge; //
@property (nonatomic, copy) NSString *receiveMoney; //
@property (nonatomic, copy) NSString *channel; //
@property (nonatomic, strong) NSNumber *status; //
@property (nonatomic, copy) NSString *countryCode; //
@property (nonatomic, copy) NSString *countryName; //
@property (nonatomic, copy) NSString *districtCode; //
@property (nonatomic, copy) NSString *districtName; //
@property (nonatomic, copy) NSString *tenantId; //
@property (nonatomic, strong)NSNumber *createTime; //
@property (nonatomic, strong)NSNumber *updateTime; //
@property (nonatomic, strong)NSNumber *serverTime; //

@property (nonatomic, copy) NSString *remark; //
//@property (nonatomic, copy) NSString *isReceipt; //
//@property (nonatomic, copy) NSString *fkActivity; //
//@property (nonatomic, copy) NSString *isSnapshot; //
//@property (nonatomic, copy) NSString *isEs; //
//@property (nonatomic, copy) NSString *fkTenant; //
//@property (nonatomic, copy) NSString *level; //
@property (nonatomic, copy) NSString *validTime; //

@property (nonatomic, copy) NSDictionary *orderUser; //
@property (nonatomic, strong) NSArray *orderDetailList; //

@property (nonatomic, strong) OrderTicket *orderTicket; //应该是个model
//@property (nonatomic, strong) NSArray *orderDiscountList; //应该是个model
//@property (nonatomic, copy) NSString *orderDispatch; //
//@property (nonatomic, copy) NSString *orderInvoice; //
//@property (nonatomic, strong) NSArray *orderStatusRecordList; //
//@property (nonatomic, copy) NSString *paymentList; //
@property (nonatomic, strong) NSNumber *payType; //9是在线支付，8是会员卡支付
@property (nonatomic, copy) NSString *cardNo; //会员卡号



@end
