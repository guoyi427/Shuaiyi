//
//  OrderTask.h
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "NetworkTask.h"
#import "Order.h"
#import "Ticket.h"
#import <Foundation/Foundation.h>

@interface OrderTask : NetworkTask {
}

@property(nonatomic, strong) NSString *ticketId;
@property(nonatomic, strong) NSString *mobile;
@property(nonatomic, strong) NSString *activityId;
@property(nonatomic, strong) NSString *seatNo;
@property(nonatomic, strong) NSString *seatInfo;
@property(nonatomic, assign) int couponCount;
@property(nonatomic, assign) int pageNum;

@property(nonatomic, strong) NSString *memo;

@property(nonatomic, strong) NSString *cardType;
@property(nonatomic, strong) NSString *cinemaId;

@property(nonatomic, strong) NSString *orderNo;
@property(nonatomic, strong) NSString *promotionId;
@property(nonatomic, strong) NSString *callBackUrl;
@property(nonatomic, assign) BOOL shareKota;
//@property(nonatomic, strong) NSString *introducer;
@property(nonatomic, assign) PayMethod payMethod;

/**
 * 重新发送订单的短信
 *
 * @param mobile  <#mobile description#>
 * @param orderId <#orderId description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initTicketOrderResend:(NSString *)mobile
                 andOrderId:(NSString *)orderId
                   finished:(FinishDownLoadBlock)block;



/**
 * 查询订单的优惠信息
 *
 * @param oNo     <#oNo description#>
 * @param promoId <#promoId description#>
 * @param block   <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initQueryOrderWarning:(NSString *)oNo
                 andPromoId:(NSString *)promoId
                   finished:(FinishDownLoadBlock)block;


@end
