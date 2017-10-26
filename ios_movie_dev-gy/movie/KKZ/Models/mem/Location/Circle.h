//
//  Circle.h
//  KKZ
//
//  Created by alfaromeo on 11-10-27.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface Circle : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * circleId;
@property (nonatomic, retain) NSString * cityId;
@property (nonatomic, retain) NSString * circleName;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * boundries;
@property (nonatomic, retain) NSNumber * distance;

@property (nonatomic, retain) NSDate * cinemaListUpdateTime;

- (City *)cityInContext:(NSManagedObjectContext *)context;
- (NSString *)distanceDesc;

@end
