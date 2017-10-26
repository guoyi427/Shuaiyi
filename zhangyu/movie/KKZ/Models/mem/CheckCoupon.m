//
//  Coupon.m
//  KKZ
//
//  Created by alfaromeo on 12-2-3.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "CheckCoupon.h"
#import "DateEngine.h"
#import "MemContainer.h"

@implementation CheckCoupon


@dynamic type;
@dynamic cardName;
@dynamic cardPrice;
@dynamic vipPrice;
@dynamic note;
@dynamic source;
@dynamic desc;
@dynamic maskName;
@dynamic validCinemas;
@dynamic description;
@dynamic couponId;
@dynamic expireDate;
@dynamic cardCount;
@dynamic remainCount;
@dynamic disable;
@dynamic validDate;
@dynamic selected;

+ (NSString *)primaryKey {
    return @"couponId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"cardName": @"name",
                 @"cardPrice": @"price",
                 @"source": @"card_source",
                 @"desc": @"description",
                 @"note": @"validTime",
                 @"validDate": @"card_date_end",

                 } retain];
    }
    return map;
}

+ (NSDictionary *)formatMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"validDate": @"yyyy-MM-dd",

                 } retain];
    }
    return map;
}




#pragma mark coupon related
+ (CheckCoupon *)getCouponWithcouponId:(NSString *)couponId{
        return [[MemContainer me] getObject:[CheckCoupon class]
                                 filter:[Predicate predictForKey: @"couponId" compare:Equal value:couponId], nil];
    

}

- (void)updateDataFromDict:(NSDictionary *)dict {
    
    if ([dict kkz_stringForKey:@"maskName"]) {
        self.maskName = [dict kkz_stringForKey:@"maskName"];
    }
    if ([dict kkz_stringForKey:@"description"]) {
        self.description = [dict kkz_stringForKey:@"description"];
    }
    if ([dict kkz_stringForKey:@"name"]) {
        self.cardName = [dict kkz_stringForKey:@"name"];
    }
    if ([dict objectForKey:@"price"]) {
        self.cardPrice = [dict kkz_intNumberForKey:@"price"];
    }
}

//- (BOOL)isWanda {
//    return (self.type == 10 || self.type == 11);
//}

@end
