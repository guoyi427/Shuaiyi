//
//  Circle.m
//  KKZ
//
//  Created by alfaromeo on 11-10-27.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import "Circle.h"

#import "DataEngine.h"
#import "City.h"

@implementation Circle
@dynamic circleId;
@dynamic cityId;
@dynamic circleName;
@dynamic latitude;
@dynamic longitude;
@dynamic boundries;
@dynamic distance;

@dynamic cinemaListUpdateTime;

- (City *)cityInContext:(NSManagedObjectContext *)context {
    return [[DataEngine sharedDataEngine] getCityWithId:self.cityId inContext:context];
}

- (NSString *)distanceDesc {
    int meter = [self.distance longValue];
    float kiloMeter = meter/1000.0;
    NSString *distanceDesc = @"";
    if (kiloMeter <= 0) {
        
    } else if (kiloMeter <= .5) {
        distanceDesc = @"500米以内";
    } else if (kiloMeter > .5 && kiloMeter <= 1) {
        distanceDesc = @"1公里以内";
    } else if (kiloMeter > 1 && kiloMeter < 200) {
        distanceDesc =  [NSString stringWithFormat:@"%.1f公里", (kiloMeter+.05)];
    }
    return distanceDesc;
}

@end
