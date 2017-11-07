//
//  PayTask.m
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "PayTask.h"
#import "Constants.h"
#import "DateEngine.h"
#import "NSStringExtra.h"
#import "UserDefault.h"
#import "Ticket.h"
#import "Order.h"
#import "CheckCoupon.h"
#import "Coupon.h"
#import "DataEngine.h"
#import "Cryptor.h"
#import "MemContainer.h"
#import "KKZUtility.h"
#import "PaymentModel.h"

@implementation PayTask

@synthesize orderNo;
@synthesize ecardIds;

- (id)initEcshopOrder:(NSString *)order_id
            payMethod:(PayMethod)pay_method
          callbackUrl:(NSString *)callback_url
            notifyUrl:(NSString *)notify_url
             finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.orderNo = order_id;
        payType = pay_method; //支付方式

        self.callbackUrl = callback_url;
        self.notifyUrl = notify_url;

        self.taskType = TaskTypePayEcshopOrder;
        self.finishBlock = block;
    }
    return self;
}

- (id)initPayOrder:(NSString *)oNo
          useMoney:(float)money
            eCards:(NSString *)eIds
      useRedCoupon:(float)redMoney
           payType:(PayMethod)mth
          finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.orderNo = oNo; // orderid
        self.ecardIds = eIds ? eIds : @""; //兑换券
        balance = money; //余额
        self.redMoney = redMoney;
        payType = mth; //支付方式
        self.taskType = TaskTypePayOrder;
        self.finishBlock = block;
    }
    return self;
}

- (id)initFinishSOSOrder:(NSString *)oNo finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.orderNo = oNo;
        self.taskType = TaskTypeSOSOrder;
        self.finishBlock = block;
    }
    return self;
}

- (id)initCheckECard:(NSString *)eIds
            forOrder:(NSString *)oNo
            groupbuy:(NSString *)groupbuyId
            finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.orderNo = oNo;
        self.groupbuyId = groupbuyId;
        self.ecardIds = eIds ? eIds : @"";
        self.taskType = TaskTypeCheckECard;
        self.finishBlock = block;
    }
    return self;
}

- (id)initBindingCouponforUser:(NSString *)couponsId
                       groupId:(NSString *)groupId
                      password:(NSString *)password
                      finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.ecardIds = couponsId;
        self.taskType = TaskTypeBindingECard;
        self.groupId = groupId;
        self.cardPassword = password;
        self.finishBlock = block;
    }
    return self;
}

//查看订单的支持支付方式
- (id)initGetPayType:(NSString *)oNo finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.orderNo = oNo;
        self.taskType = TaskTypeGetPayType;
        self.finishBlock = block;
    }
    return self;
}

- (id)initAddImprestOrder:(float)money
                  payType:(PayMethod)mth
                 finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        fee = money;
        self.payMethod = mth;
        self.taskType = TaskTypeAddImprestOrder;
        self.finishBlock = block;
    }
    return self;
}

- (id)initCouponListforOrder:(NSString *)oNo
                    finished:(FinishDownLoadBlock)block {
    self = [super init];
    if (self) {
        self.orderNo = oNo;
        self.taskType = TaskTypeOrderCoupons;
        self.finishBlock = block;
    }
    return self;
}

- (void)getReady {
    if (taskType == TaskTypeCheckECard) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];

        [self addParametersWithValue:@"coupon_Check" forKey:@"action"];
        [self addParametersWithValue:orderNo forKey:@"order_id"];
        [self addParametersWithValue:ecardIds forKey:@"coupon_ids"];
        [self addParametersWithValue:self.groupbuyId forKey:@"groupbuy_id"];

        [self setRequestMethod:@"GET"];
    }
    if (taskType == TaskTypeBindingECard) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];

        [self addParametersWithValue:@"coupon_Binding" forKey:@"action"];
        [self addParametersWithValue:self.groupId forKey:@"group_id"];
        [self addParametersWithValue:self.ecardIds forKey:@"coupon_id"];
        if (self.cardPassword.length > 0) {
            [self addParametersWithValue:self.cardPassword forKey:@"password"];
        }
        [self addParametersWithValue:@true forKey:@"to_bind"];

        [self setRequestMethod:@"GET"];
    }
    if (taskType == TaskTypePayOrder) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];

        [self addParametersWithValue:@"order_Confirm" forKey:@"action"];
        [self addParametersWithValue:USER_AlIPAY_TOKEN forKey:@"extern_token"];

        if (payType == PayMethodPuFa) {

            NSString *ip = [NSString
                    stringWithFormat:
                            @"{\"clientIp\":\"%@\",\"clientMac\":\"4C-BB-58-81-FE-A1\"}",
                            @"192.168.18.161"];
            [self addParametersWithValue:ip forKey:@"pay_mark"];
        }
        [self addParametersWithValue:orderNo forKey:@"order_id"];
        [self addParametersWithValue:BOOKING_PHONE forKey:@"mobile"];

        if (payType != PayMethodCode && payType != PayMethodNone) {
            [self addParametersWithValue:[NSString stringWithFormat:@"%d", payType]
                                    forKey:@"pay_method"];
        }
        if ([ecardIds length] > 0) {
            [self addParametersWithValue:ecardIds forKey:@"coupon_ids"];
        }
        if (balance > 0.00) {
            [self addParametersWithValue:[NSString stringWithFormat:@"%.2f", balance]
                                    forKey:@"balance"];
        }

        if (self.redMoney > 0.00) {
            [self addParametersWithValue:[NSString
                                                 stringWithFormat:@"%.2f", self.redMoney]
                                    forKey:@"red_money"];
        }

        [self addParametersWithValue:@"komovie://payBackUrl"
                                forKey:@"callback_url"];
        [self setRequestMethod:@"GET"];
    }
    if (taskType == TaskTypePayEcshopOrder) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
        [self addParametersWithValue:@"pay_Add" forKey:@"action"];
        [self addParametersWithValue:self.callbackUrl forKey:@"callback_url"];
        [self addParametersWithValue:self.notifyUrl forKey:@"notify_url"];
        [self addParametersWithValue:self.orderNo forKey:@"order_id"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", payType]
                                forKey:@"pay_method"];

        [self setRequestMethod:@"GET"];
    }
    if (taskType == TaskTypeGetPayType) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];

        [self addParametersWithValue:@"pay_Query" forKey:@"action"];

        [self addParametersWithValue:orderNo forKey:@"order_id"];

        [self setRequestMethod:@"GET"];
    }
    if (taskType == TaskTypeAddImprestOrder) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];

        [self addParametersWithValue:@"order_Add" forKey:@"action"];
        //        [self addParametersWithValue:[DataEngine sharedDataEngine].userId
        //        forKey:@"mobile"];
        [self addParametersWithValue:self.accountType forKey:@"account_type"];
        [self addParametersWithValue:self.ecardIds forKey:@"coupon_no"];

        [self
                addParametersWithValue:[NSString stringWithFormat:@"%d", self.payMethod]
                                forKey:@"pay_method"];

        [self addParametersWithValue:[NSString stringWithFormat:@"%.02f", fee]
                                forKey:@"money"];

        [self setRequestMethod:@"GET"];
    }
    if (taskType == TaskTypeOrderCoupons) {
        [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];

        [self addParametersWithValue:@"coupon_Query" forKey:@"action"];

        [self addParametersWithValue:orderNo forKey:@"order_id"];

        [self setRequestMethod:@"GET"];
    }
}

- (int)cacheVaildTime {
    if (taskType == TaskTypeCheckECard) {
        return 2;
    }
    return 0;
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypePayOrder) {
        NSDictionary *dict = (NSDictionary *) result;
        DLog(@"pay by other channel succeded: %@     url=====%@", dict,
             self.requestURL);

        NSDictionary *payInfo = [dict objectForKey:@"payInfo"];

        NSString *payUrl = @"", *sign = @"", *spId = @"", *sysProvide = @"",
                 *key = @"";
        if ([payInfo objectForKey:@"payUrl"]) {
            payUrl = [payInfo objectForKey:@"payUrl"];
        }
        if ([payInfo objectForKey:@"spid"]) {
            spId = [payInfo objectForKey:@"spid"];
        }
        if ([payInfo objectForKey:@"sysprovide"]) {
            sysProvide = [payInfo objectForKey:@"sysprovide"];
        }
        if ([payInfo objectForKey:@"key"]) {
            key = [payInfo objectForKey:@"key"];
        }

        NSString *rawSign = [payInfo objectForKey:@"sign"];
        if (rawSign) {
            if (payType == PayMethodAliMoblie) {
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(
                        kCFStringEncodingGB_18030_2000);
                sign = [rawSign Base642String:enc];
            } else if (payType == PayMethodUnionpay) {
                sign = rawSign;
            }
            DLog(@"%@", sign);
        }

        [self doCallBack:YES
                      info:[NSDictionary
                                   dictionaryWithObjectsAndKeys:orderNo, @"orderNo",
                                                                payUrl, @"payUrl", sign,
                                                                @"sign", spId, @"spId",
                                                                sysProvide, @"sysProvide",
                                                                key, @"key", nil]];
    }
    if (taskType == TaskTypePayEcshopOrder) {
        NSDictionary *dict = (NSDictionary *) result;
        DLog(@"pay by other channel succeded: %@", dict);

        NSDictionary *payInfo = [dict objectForKey:@"payInfo"];

        NSString *payUrl = @"", *sign = @"", *spId = @"", *sysProvide = @"";
        if ([payInfo objectForKey:@"payUrl"]) {
            payUrl = [payInfo objectForKey:@"payUrl"];
        }
        if ([payInfo objectForKey:@"key"]) {
            spId = [payInfo objectForKey:@"key"];
        }
        if ([payInfo objectForKey:@"sysprovide"]) {
            sysProvide = [payInfo objectForKey:@"sysprovide"];
        }

        NSString *rawSign = [payInfo objectForKey:@"sign"];
        if (rawSign) {
            if (payType == PayMethodAliMoblie) {
                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(
                        kCFStringEncodingGB_18030_2000);
                sign = [rawSign Base642String:enc];
            } else if (payType == PayMethodUnionpay) {
                sign = rawSign;
            }
            DLog(@"%@", sign);
        }

        [self
                doCallBack:YES
                      info:[NSDictionary
                                   dictionaryWithObjectsAndKeys:orderNo, @"orderNo", payUrl,
                                                                @"payUrl", sign, @"sign",
                                                                spId, @"spId", sysProvide,
                                                                @"sysProvide", nil]];

        //        }
    }

    if (taskType == TaskTypeSOSOrder) {
        [self doCallBack:YES info:nil];
    }
    if (taskType == TaskTypeCheckECard) {
        NSDictionary *dict = (NSDictionary *) result;
        DLog(@"check ecard succeded: %@", dict);
        [self doCallBack:YES info:dict];
    }
    if (taskType == TaskTypeBindingECard) {
        NSDictionary *dict = (NSDictionary *) result;
        DLog(@"TaskTypeBindingECard succeded: %@", dict);
        NSMutableArray *myCouponList = [[NSMutableArray alloc] initWithCapacity:0];

        NSDictionary *couponDict = [dict kkz_objForKey:@"coupon"];
        if (couponDict) {
            NSDictionary *info = [couponDict kkz_objForKey:@"info"];
            NSNumber *existed = nil;
            CheckCoupon *current =
                    (CheckCoupon *) [[MemContainer me] instanceFromDict:couponDict
                                                                  clazz:[Coupon class]
                                                                  exist:&existed];
            [current updateDataFromDict:info];

            [myCouponList addObject:current];
        }

        [self doCallBack:YES info:@{ @"myCouponList" : myCouponList }];
    }
    if (taskType == TaskTypeGetPayType) {
        NSDictionary *dict = (NSDictionary *) result;
        DLog(@"pay type succeded: %@     url==========%@", dict, self.requestURL);

        NSMutableArray *payMethods = [dict valueForKey:@"payMethods"];
        NSMutableArray *payModels = [[NSMutableArray alloc] init];
        for (int i = 0; i < payMethods.count; i++) {
            NSDictionary *dic = payMethods[i];
            PaymentModel *model = [[PaymentModel alloc] init];
            model.desc = dic[@"desc"];
            model.intro = dic[@"intro"];
            model.payMethod = [dic[@"payMethod"] intValue];
            model.selected = [dic[@"selected"] intValue];
            [payModels addObject:model];
        }

        [self doCallBack:YES info:@{ @"payModels" : payModels }];
    }
    if (taskType == TaskTypeAddImprestOrder) {
        NSDictionary *dict = (NSDictionary *) result;
        DLog(@"imprest apply succeded: %@", dict);
        NSDictionary *order = [dict objectForKey:@"order"];
        [self doCallBack:YES
                      info:@{
                          @"orderId" : [order objectForKey:@"orderId"]
                      }];
    }
    if (taskType == TaskTypeOrderCoupons) {
        NSDictionary *dict = (NSDictionary *) result;
        DLog(@"TaskTypeOrderCoupons ecard succeded: %@", dict);
        NSMutableArray *myCouponList = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *rightCouponList =
                [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *wrongCouponList =
                [[NSMutableArray alloc] initWithCapacity:0];
        if (self.orderNo.length <= 0 || [self.orderNo isEqualToString:@""]) {

            NSArray *coupons = [dict objectForKey:@"coupons"];

            if ([coupons count]) {
                for (NSDictionary *couponDict in coupons) {
                    NSDictionary *info = [couponDict objectForKey:@"info"];
                    NSNumber *existed = nil;
                    CheckCoupon *current = (CheckCoupon *) [[MemContainer me]
                            instanceFromDict:couponDict
                                       clazz:[CheckCoupon class]
                                       exist:&existed];
                    [current updateDataFromDict:info];
                    [myCouponList addObject:current];
                }
            }

        } else {

            NSArray *rightCoupons = [dict objectForKey:@"rightCoupon"];

            if ([rightCoupons count]) {
                for (NSDictionary *couponDict in rightCoupons) {
                    NSDictionary *info = [couponDict objectForKey:@"info"];
                    NSNumber *existed = nil;
                    CheckCoupon *current = (CheckCoupon *) [[MemContainer me]
                            instanceFromDict:couponDict
                                       clazz:[CheckCoupon class]
                                       exist:&existed];
                    [current updateDataFromDict:info];
                    [rightCouponList addObject:current];
                }
            }

            NSArray *wrongCoupons = [dict objectForKey:@"wrongCoupon"];

            if ([wrongCoupons count]) {
                for (NSDictionary *couponDict in wrongCoupons) {
                    NSDictionary *info = [couponDict objectForKey:@"info"];
                    NSNumber *existed = nil;
                    CheckCoupon *current = (CheckCoupon *) [[MemContainer me]
                            instanceFromDict:couponDict
                                       clazz:[CheckCoupon class]
                                       exist:&existed];
                    [current updateDataFromDict:info];
                    [wrongCouponList addObject:current];
                }
            }
        }

        [self doCallBack:YES
                      info:@{
                          @"wrongCouponList" : wrongCouponList,
                          @"rightCouponList" : rightCouponList,
                          @"myCouponList" : myCouponList
                      }];
    }
}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypePayOrder) {
        DLog(@"pay order failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }

    if (taskType == TaskTypePayEcshopOrder) {
        DLog(@"TaskTypePayEcshopOrder   pay order failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }

    if (taskType == TaskTypeCheckECard) {
        DLog(@"check ecard failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    if (taskType == TaskTypeBindingECard) {
        DLog(@"TaskTypeBindingECard failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    if (taskType == TaskTypeGetPayType) {
        DLog(@"pay type failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    if (taskType == TaskTypeAddImprestOrder) {
        DLog(@"imprest apply failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    if (taskType == TaskTypeSOSOrder) {
        DLog(@"TaskTypeSOSOrder failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    if (taskType == TaskTypeOrderCoupons) {
        DLog(@"TaskTypeOrderCoupons failed: %@", [error description]);
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
