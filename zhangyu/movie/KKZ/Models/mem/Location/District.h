//
//  District.h
//  KKZ
//
//  Created by alfaromeo on 11-10-27.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class City;

@interface District : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * districtId;
@property (nonatomic, retain) NSString * cityId;
@property (nonatomic, retain) NSString * districtName;

- (City *)cityInContext:(NSManagedObjectContext *)context;

@end
