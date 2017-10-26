//
//  RedCoupon.m
//  KoMovie
//
//  Created by gree2 on 18/10/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "RedCoupon.h"
#import "MemContainer.h"
#import "DateEngine.h"

@implementation RedCoupon

@dynamic redRemainAmount;
@dynamic redUtimeStart;
@dynamic redUtimeEnd;
@dynamic status;
@dynamic sourceTypeStr;
@dynamic note;


//
//+ (NSString *)primaryKey {
//    return @"redRemainAmount";
//}
//
+ (NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
               
                 }
               retain];
    }
    return map;
}

+ (NSDictionary *)formatMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
//                 @"redUtimeStart": @"yyyy-MM-dd",
//                 @"redUtimeEnd": @"yyyy-MM-dd",
                 } retain];
    }
    return map;
}

- (BOOL)RedCouponIsValid{
   
//    if ([self.redUtimeEnd compare:[NSDate date]] == NSOrderedDescending) {
//        return NO;
//    }else{
//        return YES;
//    }
    return NO;
}

//+ (RedCoupon *)getRedCouponWithId:(unsigned int)rId {
//    return [[MemContainer me] getObject:[RedCoupon class]
//                                 filter:[Predicate predictForKey: @"rId" compare:Equal value:@(rId)], nil];
//}

@end
