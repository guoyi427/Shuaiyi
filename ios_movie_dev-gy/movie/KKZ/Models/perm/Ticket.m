//
//  Ticket.m
//  KKZ
//
//  Created by alfaromeo on 11-10-3.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import "Ticket.h"
#import "DateEngine.h"
#import "MemContainer.h"
#import "MTLValueTransformerHelper.h"

/**
 平台转换
 
 @param NSNumber 平台号
 
 @return 平台
 */
PlatForm KKZPlateform(NSNumber *platform)
{
    if (platform.integerValue > 0 && platform.integerValue < 20000) {
        return PlatFormTicket;
    } else if ((platform.integerValue > 19999 &&
                platform.integerValue < 30000)) {
        return PlatFormCoupon;
    } else if (platform.integerValue > 39999 &&
               platform.integerValue < 50000) {
        return PlatFormWeb;
    } else {
        return PlatFormNone;
    }
}


@implementation Ticket

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: [NSDictionary mtl_identityPropertyMapWithModel:[self class]]];
    [dic setValuesForKeysWithDictionary:@{
                                          @"movieLength": @"time_shaft",
                                          @"dealPrice": @"price",
                                          @"movieTime": @"featureTime",
                                          @"platformOrig":@"platform",
                                          @"vipPrice": @"price"
                                          }];
    
    return dic;
}


+ (NSValueTransformer *) dealPriceJSONTransformer
{
    return KKZ_StringToNumberTransformer();
}


+ (NSValueTransformer *) vipPriceJSONTransformer
{
    return KKZ_StringToNumberTransformer();
}

+ (NSValueTransformer *) standardPriceJSONTransformer
{
    return KKZ_StringToNumberTransformer();
}


+ (NSValueTransformer *) movieTimeJSONTransformer
{
    return KKZ_StringToDateTransformer(@"yyyy-MM-dd HH:mm:ss");
}

+ (NSValueTransformer *) cinemaJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[CinemaDetail class]];
}

+ (NSValueTransformer *) movieJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Movie class]];
}

+ (NSValueTransformer *) hasPromotionJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

- (BOOL) isPromotion
{
    return self.promotionPrice != nil;
}


+ (NSString *)primaryKey {
    return @"planId";
}


- (void)updateDataWithDict:(NSDictionary *)dict {
    
    
}



- (PlatForm) platform
{
    return  KKZPlateform(self.platformOrig);
}

- (BOOL)supportBuy {
    return self.platform == PlatFormTicket;
}

+ (Ticket *)getTicketWithId:(NSInteger)planId {
    return [[MemContainer me] getObject:[Ticket class]
                                 filter:[Predicate predictForKey: @"planId"
                                compare:Equal value:@(planId)], nil];
}



@end
