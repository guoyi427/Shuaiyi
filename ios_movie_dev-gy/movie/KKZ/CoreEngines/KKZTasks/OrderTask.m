//
//  OrderTask.m
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "CacheEngine.h"
#import "CinemaDetail.h"
#import "Constants.h"
#import "Coupon.h"
#import "Cryptor.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "MemContainer.h"
#import "Movie.h"
#import "OrderTask.h"
#import "UserDefault.h"

#define kCountPerPage 10

@implementation OrderTask

- (id)initTicketOrderResend:(NSString *)mobile
                 andOrderId:(NSString *)orderId
                   finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeResendOrder;
        self.mobile = mobile;
        self.orderNo = orderId;
        self.finishBlock = block;
    }
    return self;
}

- (id)initQueryOrderWarning:(NSString *)oNo
                 andPromoId:(NSString *)promoId
                   finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeQueryOrderWarning;
        self.orderNo = oNo;
        self.finishBlock = block;
        self.promotionId = promoId;
    }
    return self;
}

- (int)cacheVaildTime {
    return 0;
}

- (void)getReady { // TaskTypeResendOrder

    if (taskType == TaskTypeResendOrder) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];

        [self addParametersWithValue:@"order_Resend" forKey:@"action"];
        [self addParametersWithValue:self.mobile forKey:@"mobile"];
        [self addParametersWithValue:self.orderNo forKey:@"order_id"];

        [self setRequestMethod:@"GET"];
    }

    if (taskType == TaskTypeQueryOrderWarning) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
        [self addParametersWithValue:@"order_Promotion" forKey:@"action"];
        [self addParametersWithValue:self.orderNo forKey:@"order_id"];
        [self addParametersWithValue:self.promotionId forKey:@"promotion_id"];

        [self setRequestMethod:@"GET"];
    }
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result { // TaskTypeResendOrder
    if (taskType == TaskTypeResendOrder) {

        [self doCallBack:YES
                      info:[NSDictionary dictionaryWithObject:
                                                 @"短信发送成功，请注意查收"
                                                       forKey:@"resendMesgSucceed"]];
    }

    if (taskType == TaskTypeQueryOrderWarning) {
        NSDictionary *dict = (NSDictionary *) result;
        DLog(@"query order detail succeded: %@", dict);
        NSString *message = [dict objectForKey:@"message"];

        if (message.length) {
            [self doCallBack:YES
                          info:[NSDictionary dictionaryWithObject:message
                                                           forKey:@"message"]];
        } else
            [self doCallBack:NO info:nil];
    }
}

- (void)requestFailedWithError:(NSError *)error { // TaskTypeResendOrder
    if (taskType == TaskTypeResendOrder) {
        DLog(@"ResendOrder failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    if (taskType == TaskTypeQueryOrderDetail) {
        DLog(@"query order failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }

    if (taskType == TaskTypeQueryOrderWarning) {
        DLog(@"TaskTypeQueryOrderWarning: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
}

- (void)requestSucceededConnection {
    // if needed do something after connected to net, handle here
}

// upload process
- (void)uploadBytesWritten:(NSInteger)written
         totalBytesWritten:(NSInteger)totalWritten
 totalBytesExpectedToWrite:(NSInteger)totalExpectedToWrite {
    // just for upload task
}

@end
