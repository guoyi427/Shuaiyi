//
//  Cinema.m
//  CIASMovie
//
//  Created by cias on 2016/12/29.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "Cinema.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

@implementation Cinema
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
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

+ (NSValueTransformer *)cityIdJSONTransformer {
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


- (void)updateLayout{
    
//    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([LocationEngine sharedLocationEngine].BDUserLocation.location.coordinate.latitude,[LocationEngine sharedLocationEngine].BDUserLocation.location.coordinate.longitude));
//    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(nlatitude,nlongitudee));
//    CLLocationDistance meters = BMKMetersBetweenMapPoints(point1,point2);
//    
//    self.distance = [NSNumber numberWithFloat:meters];

}

+(NSArray *)getCinemasByDistanceWithSourceArray:(NSArray*)arr{
    NSMutableArray *otherArray = [[NSMutableArray alloc] initWithCapacity:0];
    [otherArray addObjectsFromArray:arr];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:
                                [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES],
                                nil];
    [otherArray sortUsingDescriptors:sortDescriptors];
    return otherArray;
}


@end
