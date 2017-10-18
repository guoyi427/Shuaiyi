//
//  OrderMain.h
//  CIASMovie
//
//  Created by cias on 2017/2/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OrderMain : MTLModel<MTLJSONSerializing>

//@property (nonatomic, copy)NSString *channel;
//@property (nonatomic, copy)NSString *countryCode;
//@property (nonatomic, copy)NSString *countryName;
@property (nonatomic, copy)NSString *cinemaName;
@property (nonatomic, copy)NSString *cardNo;
@property (nonatomic, strong)NSNumber *createTime;
//@property (nonatomic, copy)NSString *date;
@property (nonatomic, copy)NSString *discountMoney;
//@property (nonatomic, copy)NSString *districtCode;
//@property (nonatomic, copy)NSString *districtName;
//@property (nonatomic, copy)NSString *fkActivity;
//@property (nonatomic, copy)NSString *fkTenant;
@property (nonatomic, copy)NSString *goodsCount;
//@property (nonatomic, copy)NSString *isEs;
//@property (nonatomic, copy)NSString *isReceipt;
//@property (nonatomic, copy)NSString *isSnapshot;
//@property (nonatomic, copy)NSString *level;
@property (nonatomic, copy)NSString *orderCode;
@property (nonatomic, copy)NSString *orderDetailList;//
@property (nonatomic, copy)NSString *orderDiscountList;//
@property (nonatomic, copy)NSString *orderDispatch;
//@property (nonatomic, copy)NSString *orderInvoice;
@property (nonatomic, copy)NSString *orderStatusRecordList;//
@property (nonatomic, copy)NSString *orderTicket;
@property (nonatomic, strong)NSNumber *orderType;
@property (nonatomic, copy)NSString *orderUser;
@property (nonatomic, copy)NSString *originalPrice;
@property (nonatomic, copy)NSNumber *payType;
@property (nonatomic, copy)NSString *paymentList;
@property (nonatomic, copy)NSString *pkOrderMain;
@property (nonatomic, copy)NSString *receiveMoney;
//@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSNumber *serverTime;
@property (nonatomic, copy)NSString *serviceCharge;
@property (nonatomic, strong)NSNumber *status;
@property (nonatomic, copy)NSString *tenantId;
@property (nonatomic, copy)NSNumber *updateTime;
@property (nonatomic, copy)NSString *userAccount;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *validTime;

@end
