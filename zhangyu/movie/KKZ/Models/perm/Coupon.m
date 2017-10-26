//
//  Coupon.m
//  KKZ
//
//  Created by alfaromeo on 12-2-3.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "Coupon.h"
#import "DateEngine.h"
#import "MemContainer.h"

@implementation Coupon


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
@dynamic expireDays;


+ (NSString *)primaryKey {
    return @"type";
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
+ (Coupon *)getCouponWithType:(int)type{
    return [[MemContainer me] getObject:[Coupon class]
                                 filter:[Predicate predictForKey: @"type" compare:Equal value:@(type)], nil];
    

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
