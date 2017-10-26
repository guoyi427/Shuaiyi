//
//  LocationEngine.h
//  phonebook
//
//  Created by zhang da on 10-10-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

extern NSString * const LocationUpdateSucceededNotification;
extern NSString * const LocationUpdateFailedNotification;

extern NSString * const LocationChangedNotification;

extern NSString * const AddressUpdateSucceededNotification;
extern NSString * const AddressUpdateFailedNotification; 

typedef enum {
	LocationEngineUpdating,
	LocationEngineTimeout,
	LocationEngineError,
	LocationEngineSuccess,
	LocationEngineEnd
} LocationEngineStates;


@interface LocationEngine : NSObject < CLLocationManagerDelegate> {
	LocationEngineStates currentSta;
    CLLocationManager *locationManager;
    NSMutableArray *locationMeasurements;
    
    CLLocation *bestLocation;
    double latitude, longitude;
}

@property (nonatomic ) LocationEngineStates currentSta;
@property (nonatomic, retain) NSMutableArray *locationMeasurements;
@property (nonatomic, retain) CLLocation *bestLocation;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate2D;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) int num;


+ (LocationEngine *)sharedLocationEngine;

- (void)start;
- (void)reset;
- (void)stop;
- (BOOL)locationExpired;

- (void)getLocationDescFor:(CLLocation *)location;
- (double)metersFormPositonWithLatitude:(double)latitude1 longitude:(double)longitude1
                 toPositionWithLatitude:(double)latitude2 longitude:(double)longitude2;


@end

