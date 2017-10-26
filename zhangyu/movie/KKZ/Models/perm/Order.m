//
//  Order.m
//  KKZ
//
//  Created by zhang da on 11-11-6.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import "Order.h"
#import "Ticket.h"
#import "Cinema.h"
#import "Movie.h"
#import "Coupon.h"

#import "Constants.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "Cryptor.h"
#import "MemContainer.h"
#import "MTLValueTransformerHelper.h"

@implementation Order

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: [NSDictionary mtl_identityPropertyMapWithModel:[self class]]];
    [dic setValuesForKeysWithDictionary:@{
                                          @"orderMessage": @"orderMsg",
                                          @"vipUnitPrice": @"vipPrice",
                                          }];

    return dic;
}


+ (NSValueTransformer *) planJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Ticket class]];
}

+ (NSValueTransformer *) promotionJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Promotion class]];
}

+ (NSValueTransformer *) payTimeJSONTransformer
{
    return KKZ_StringToDateTransformer(@"yyyy-MM-dd HH:mm:ss");
}

+ (NSValueTransformer *) unitPriceJSONTransformer
{
    return KKZ_StringToNumberTransformer();
}

+ (NSValueTransformer *) vipUnitPriceJSONTransformer
{
    return KKZ_StringToNumberTransformer();
}

+ (NSValueTransformer *) agioJSONTransformer
{
    return KKZ_StringToNumberTransformer();
}

+ (NSValueTransformer *) moneyJSONTransformer
{
    return KKZ_StringToNumberTransformer();
}

//-----

+ (NSString *)primaryKey {
    return @"orderId";
}



- (NSString *)qrCodePath {
    return [NSString stringWithFormat:@"%@?order_id=%@", kKSSPQRServer, self.orderId];
}

- (NSInteger)seatCount {
    if ([self.seatInfo length]) {
        return [[self.seatInfo componentsSeparatedByString:@","] count];
    } else 
        return 1;
}

- (NSString *)readableSeatInfos {
    if ([self.seatInfo length]) {
        NSArray *seats = [self.seatInfo componentsSeparatedByString:@","];
        NSMutableString *seatDesc = [[NSMutableString alloc] init];
        for (NSString *seatStr in seats) {
            NSArray *seatInfo = [seatStr componentsSeparatedByString:@"_"];
            if ([seatInfo count] == 3) {
                [seatDesc appendString:[seatInfo objectAtIndex:1]];
                [seatDesc appendString:@"排"];
                [seatDesc appendString:[seatInfo objectAtIndex:2]];
                [seatDesc appendString:@"座"];
                [seatDesc appendString:@" "];
            } else if ([seatInfo count] == 2) {
                [seatDesc appendString:[seatInfo objectAtIndex:0]];
                [seatDesc appendString:@"排"];
                [seatDesc appendString:[seatInfo objectAtIndex:1]];
                [seatDesc appendString:@"座"];
                [seatDesc appendString:@" "];
            }
        }
        return seatDesc;
    } 
    return nil;
}

- (NSString *)orderStateDesc {
    OrderState state = (OrderState)[self.orderStatus intValue];
    switch (state) {
        case OrderStateNormal: return @"等待付款";
        case OrderStateCanceled: return @"已取消";
        case OrderStatePaid: return @"正在购票";
        case OrderStateBuySucceeded: return @"购票成功";
        case OrderStateBuyFailed: return @"购票失败";
//        case OrderStateFinished: return @"已出票";
        case OrderStateRefund:return @"已退款";
        case OrderStateTimeout: return @"过期";
            
        default: break;
    }
    return nil;
}

- (NSString *)movieTimeDesc {
    return [[DateEngine sharedDateEngine] stringFromDate:self.plan.movieTime withFormat:@"yyyy年M月d日 HH:mm"];
}

- (CGFloat)moneyToPay {

        CGFloat totalMoney = [self.money doubleValue];
       // float fee = [self.blessingWords length]? 1: 0;
        
        return totalMoney ;//+ fee;

}

- (OrderPayInfo *)payInfo {
    return nil;
}

+ (NSString *)payMethodDesc:(PayMethod)method {
    switch (method) {
//        case PayMethodBalance: return @"余额";
        case PayMethodCode: return @"兑换码";
        case PayMethodAliMoblie: return @"支付宝";
//        case PayMethodCMPocket: return @"手机钱包";
        case PayMethodUnionpay: return @"银联";
        case PayMethodWeiXin: return @"微信客户端支付";
            
        default: return nil;
    }
}





@end
