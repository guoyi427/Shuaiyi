//
//  City.h
//  KKZ
//
//  Created by alfaromeo on 11-10-27.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface City : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSNumber *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *cityPinYin;
@property (nonatomic, copy) NSNumber *cityHot;

@property (nonatomic, copy) NSString *nameFirst; //分类的索引，A，B，C等等

+ (City *)getCityWithId:(int)cityId;
+ (City *)getCityWithName:(NSString *)cityName;

@end
