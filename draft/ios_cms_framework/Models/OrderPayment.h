//
//  OrderPayment.h
//  CIASMovie
//
//  Created by avatar on 2017/3/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OrderPayment : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSNumber *createTime;//
@property (nonatomic, copy)NSString *fkOrderCode;
@property (nonatomic, copy)NSString *fkServiceOrderCode;
@property (nonatomic, copy)NSString *message;
@property (nonatomic, copy)NSString *orderOperator;
@property (nonatomic, copy)NSString *money;//
@property (nonatomic, copy)NSString *payAccount;
@property (nonatomic, copy)NSNumber *payMethod;//
@property (nonatomic, copy)NSString *payOrderCode;
@property (nonatomic, copy)NSNumber *payTime;//
@property (nonatomic, copy)NSString *paymentCode;
@property (nonatomic, copy)NSString *pkPayment;
@property (nonatomic, copy)NSNumber *status;//
@property (nonatomic, copy)NSString *tradeNo;
@property (nonatomic, copy)NSNumber *type;//
@end
