//
//  Cinema.m
//  KKZ
//
//  Created by alfaromeo on 11-10-3.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import "Cinema.h"
#import "DataEngine.h"
#import "LocationEngine.h"
#import "MemContainer.h"

@implementation Cinema



+ (NSString *)primaryKey {
  return @"cinemaId";
}

+ (NSDictionary *)propertyMapping {
  static NSDictionary *map = nil;
  if (!map) {
    map = [@{
      @"cinemaLogo" : @"appBigPost",
      @"cardType" : @"card_type",
      @"cinemaPhone" : @"cinemaTel",
      @"movieIntro" : @"intro",
      @"movieStyle" : @"movieType",
      @"supportQRCode" : @"ticketType",
      @"fav" : @"collect_status",
      @"cinemaOpentime" : @"openTime",

    } retain];
  }
  return map;
}

- (CLLocationCoordinate2D)cinemaCenter {
  double latitude = [self.latitude doubleValue];
  double longitude = [self.longitude doubleValue];

  if (latitude < -90 || latitude > 90) {
    latitude = 0;
  }
  if (longitude < -180 || longitude > 180) {
    longitude = 0;
  }

  // set pin annotaiton
  CLLocationCoordinate2D theCoordinate;
  theCoordinate.latitude = latitude;
  theCoordinate.longitude = longitude;

  return theCoordinate;
}

- (NSString *)distanceDesc {
  float kiloMeter = [self.distance doubleValue] / 1000.0;
  NSString *distanceDesc = @"";

  if (kiloMeter < 1) {
    distanceDesc =
        [NSString stringWithFormat:@"%.1f米", [self.distance doubleValue]];
  } else {
    distanceDesc = [NSString stringWithFormat:@"%.1fkm", kiloMeter];
  }
  /*
  if (kiloMeter <= 0) {

  } else if (kiloMeter <= .5) {
      distanceDesc = @"500米以内";
  } else if (kiloMeter > .5 && kiloMeter <= 1) {
      distanceDesc = @"1公里以内";
  } else if (kiloMeter > 1 && kiloMeter < 200) {
      distanceDesc =  [NSString stringWithFormat:@"%.1f公里", (kiloMeter+.05)];
  }
   */
  return distanceDesc;
}

//- (BOOL)isWanda {
//    return  [self.cinemaName rangeOfString:@"万达"].length > 0;
//}

- (void)updateLayout {

  double nlatitude = [self.latitude doubleValue];

  double nlongitudee = [self.longitude doubleValue];

  if ([LocationEngine sharedLocationEngine].latitude &&
      [LocationEngine sharedLocationEngine].longitude) {
    double meters = [[LocationEngine sharedLocationEngine]
        metersFormPositonWithLatitude:nlatitude
                            longitude:nlongitudee
               toPositionWithLatitude:[LocationEngine sharedLocationEngine]
                                          .latitude
                            longitude:[LocationEngine sharedLocationEngine]
                                          .longitude];
    self.distance = [[NSNumber alloc] initWithFloat:meters];
  } else {
    self.distance = [[NSNumber alloc] initWithFloat:99999999999];
  }

  if (self.platform > 0 && self.platform < 20000) {
    self.platFormNum = [[NSNumber alloc] initWithInt:PlatFormTicket];
  } else if ((self.platform > 19999 && self.platform < 30000)) {
    self.platFormNum = [[NSNumber alloc] initWithInt:PlatFormCoupon];
  } else if (self.platform > 39999 && self.platform < 50000) {
    self.platFormNum = [[NSNumber alloc] initWithInt:PlatFormWeb];
  } else {
    self.platFormNum = [[NSNumber alloc] initWithInt:PlatFormNone];
  }
//  self.sortId = self.platFormNum;
  //    if ([self isWanda]) {
  //        self.sortId = [NSNumber numberWithInt:4];
  //    }
}

- (NSString *)cinemaType {
  PlatForm abi = (PlatForm)[self.platFormNum intValue];
  switch (abi) {
  case PlatFormNone:
    return @"查看场次";
  case PlatFormCoupon:
    return @"买兑换券";
  case PlatFormTicket:
    return @"在线选座";
  case PlatFormWeb:
    return @"在线选座";

  default:
    return nil;
  }
}

- (NSArray *)cinemaFlags {
  NSMutableArray *flags = [[NSMutableArray alloc] init];
  NSArray *arr = (NSMutableArray *)[self.flag componentsSeparatedByString:@","];
  [flags addObjectsFromArray:arr];
  return flags;
}

+ (Cinema *)getCinemaWithId:(NSUInteger)cinemaId {
  return [[MemContainer me] getObject:[Cinema class]
                               filter:[Predicate predictForKey:@"cinemaId"
                                                       compare:Equal
                                                         value:@(cinemaId)],
                                      nil];
}

+ (NSArray *)getCinemaNearWithSourceArray:(NSArray *)arr {
  NSMutableArray *cinemas = [[NSMutableArray alloc] init];
  for (Cinema *cinema in arr) {
    if ([cinema.distance floatValue] <= 3000.0) {
      [cinemas addObject:cinema];
    }
  }

  NSArray *sortDescriptors = [[NSArray alloc]
      initWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"sortId"
                                                    ascending:NO],
                      [NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                    ascending:YES],
                      [NSSortDescriptor sortDescriptorWithKey:@"cinemaId"
                                                    ascending:YES],
                      nil];

  [cinemas sortUsingDescriptors:sortDescriptors];
  [sortDescriptors release];
  return [cinemas autorelease];
}

+ (NSArray *)getCinemaWithDistrictName:(NSString *)districtName
                           sourceArray:(NSArray *)arr {
  NSMutableArray *cinemas = [[NSMutableArray alloc] init];
  for (Cinema *cinema in arr) {
    if ([cinema.districtName isEqualToString:districtName]) {
      [cinemas addObject:cinema];
    }
  }

  NSArray *sortDescriptors = [[NSArray alloc]
      initWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"sortId"
                                                    ascending:NO],
                      [NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                    ascending:YES],
                      [NSSortDescriptor sortDescriptorWithKey:@"cinemaId"
                                                    ascending:YES],
                      nil];

  [cinemas sortUsingDescriptors:sortDescriptors];
  [sortDescriptors release];

  return [cinemas autorelease];
}
//

+ (NSArray *)getMovieCinemaNearWithSourceArray:(NSArray *)arr {

  NSMutableArray *otherArray = [[NSMutableArray alloc] init];

  for (Cinema *cinema in arr) {
    if ([cinema.distance floatValue] <= 3000.0) {
      [otherArray addObject:cinema];
    }
  }

  NSArray *sortDescriptors = [[NSArray alloc]
      initWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                    ascending:YES],
                      [NSSortDescriptor sortDescriptorWithKey:@"platFormNum"
                                                    ascending:NO],
                      //                                [[NSSortDescriptor
                      //                                alloc]
                      //                                initWithKey:@"cinemaId"
                      //                                ascending:YES],
                      nil];

  [otherArray sortUsingDescriptors:sortDescriptors];
  [sortDescriptors release];
  return [otherArray autorelease];
}

+ (NSArray *)getMovieCinemaWithDistrictName:(NSString *)districtName
                                sourceArray:(NSArray *)arr {
  NSMutableArray *otherArray = [[NSMutableArray alloc] init];

  for (Cinema *cinema in arr) {
    if ([cinema.districtName isEqualToString:districtName]) {
      [otherArray addObject:cinema];
    }
  }

  NSArray *sortDescriptors = [[NSArray alloc]
      initWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"platFormNum"
                                                    ascending:NO],
                      [NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                    ascending:YES],
                      //                                [[NSSortDescriptor
                      //                                alloc]
                      //                                initWithKey:@"cinemaId"
                      //                                ascending:YES],
                      nil];

  [otherArray sortUsingDescriptors:sortDescriptors];
  [sortDescriptors release];

  return [otherArray autorelease];
}

+ (NSArray *)getCinemaWithSourceArray:(NSArray *)arr {
  NSMutableArray *otherArray = [[NSMutableArray alloc] initWithCapacity:0];
  [otherArray addObjectsFromArray:arr];
  NSArray *sortDescriptors = [[NSArray alloc]
      initWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"platFormNum"
                                                    ascending:NO],
                      [NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                    ascending:YES],
                      nil];
  [otherArray sortUsingDescriptors:sortDescriptors];
  [sortDescriptors release];
  return [otherArray autorelease];
}

+ (NSArray *)getMovieCinemaAllWithSourceArray:(NSArray *)arr {
  NSMutableArray *otherArray = [[NSMutableArray alloc] initWithCapacity:0];

  [otherArray addObjectsFromArray:arr];
  NSArray *sortDescriptors = [[NSArray alloc]
      initWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"platFormNum"
                                                    ascending:NO],
                      [NSSortDescriptor sortDescriptorWithKey:@"distance"
                                                    ascending:YES],
                      nil];
  [otherArray sortUsingDescriptors:sortDescriptors];
  [sortDescriptors release];
  return [otherArray autorelease];
}

@end
