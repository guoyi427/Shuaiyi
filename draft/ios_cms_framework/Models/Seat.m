//
//  Seat.m
//  CIASMovie
//
//  Created by cias on 2016/12/24.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "Seat.h"

@interface Seat()
@property (nonatomic) float distanceToCenter;
@end

@implementation Seat
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"graphRow":@"xcoord",
             @"graphCol":@"ycoord",
             @"hallId":@"screenId",
             @"seatCol":@"columnNum",
             @"seatId":@"seatId",
             @"seatRow":@"rowNum",
             @"seatStateOrigin":@"seatStatus",
             @"seatType":@"seatType",
             };
}



+ (NSValueTransformer *) isLoverLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}


- (void) calculateDistanceToCenterAt:(int) centerRow centerCol:(int)centerCol
{
    self.distanceToCenter = sqrt(pow((self.graphRow.floatValue - centerRow), 2) + pow((self.graphCol.floatValue - centerCol), 2)) ;
}

- (SeatState)seatState
{
    if (self.seatType.integerValue == 1) {
        //情侣座 左
        return  self.seatStateOrigin.intValue == 0 ? SeatStateLoverL : SeatStateLoverLUnavailable;
  
    }else if (self.seatType.integerValue == 2){
        //情侣座 右
        return  self.seatStateOrigin.intValue == 0 ? SeatStateLoverR : SeatStateLoverRUnavailable;
    }
    else{
        return  self.seatStateOrigin.intValue == 0 ? SeatStateAvailable : SeatStateUnavailable;
    }

}

//- (NSNumber *)seatState
//{
//    if (self.seatType.integerValue == 1) {
//        //情侣座
//        if (self.isLoverL == YES) {
//            //情侣座 左
//            _seatState = [NSNumber numberWithInt:self.seatStateOrigin.intValue == SeatStateAvailable ? SeatStateLoverL : SeatStateLoverLUnavailable];
//        }else{
//            _seatState = [NSNumber numberWithInt:self.seatStateOrigin.intValue == SeatStateAvailable ? SeatStateLoverR : SeatStateLoverRUnavailable];
//        }
//    }else{
//        //
//        _seatState = [NSNumber numberWithInt:self.seatStateOrigin.intValue == SeatStateAvailable ? SeatStateAvailable : SeatStateUnavailable];
//    }
//    return _seatState;
//}
/*
+ (NSValueTransformer *)seatRowJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        } else if ([value isKindOfClass:[NSString class]]) {
            return [NSNumber numberWithInteger:[value integerValue]];
        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] || !value) {
#if DEBUG
            NSAssert(value != nil, @"Type error");
#endif
            return [NSNull null];
        } else {
            return value;
        }
    }];
}

+ (NSValueTransformer *)seatColJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        } else if ([value isKindOfClass:[NSString class]]) {
            return [NSNumber numberWithInteger:[value integerValue]];
        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] || !value) {
#if DEBUG
            NSAssert(value != nil, @"Type error");
#endif
            return [NSNull null];
        } else {
            return value;
        }
    }];
}
*/
+ (NSValueTransformer *)graphRowJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        } else if ([value isKindOfClass:[NSString class]]) {
            return [NSNumber numberWithInteger:[value integerValue]];
        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] || !value) {
#if DEBUG
            NSAssert(value != nil, @"Type error");
#endif
            return [NSNull null];
        } else {
            return value;
        }
    }];
}

+ (NSValueTransformer *)graphColJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        } else if ([value isKindOfClass:[NSString class]]) {
            return [NSNumber numberWithInteger:[value integerValue]];
        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] || !value) {
#if DEBUG
            NSAssert(value != nil, @"Type error");
#endif
            return [NSNull null];
        } else {
            return value;
        }
    }];
}



//NSNumber转NSString
+ (NSValueTransformer *)cinemaIdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        } else if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] || !value) {
#if DEBUG
            NSAssert(value != nil, @"Type error");
#endif
            return [NSNull null];
        } else {
            return [value stringValue];
        }
    }];
}

+ (NSValueTransformer *)seatIdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        } else if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] || !value) {
#if DEBUG
            NSAssert(value != nil, @"Type error");
#endif
            return [NSNull null];
        } else {
            return [value stringValue];
        }
    }];
}

+ (NSValueTransformer *)hallIdJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        } else if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]] || !value) {
#if DEBUG
            NSAssert(value != nil, @"Type error");
#endif
            return [NSNull null];
        } else {
            return [value stringValue];
        }
    }];
}



@end
