//
//  District.m
//  KKZ
//
//  Created by alfaromeo on 11-10-27.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import "District.h"
#import "City.h"
#import "DataEngine.h"

@implementation District
@dynamic districtId;
@dynamic cityId;
@dynamic districtName;

- (City *)cityInContext:(NSManagedObjectContext *)context {
    return [[DataEngine sharedDataEngine] getCityWithId:self.cityId
                                              inContext:context];
}

@end
