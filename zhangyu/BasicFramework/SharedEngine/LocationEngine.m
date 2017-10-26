//
//  LocationEngine.m
//  phonebook
//
//  Created by zhang da on 10-10-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "City.h"
#import "DataEngine.h"
#import "LocationEngine.h"
#import "TaskQueue.h"
#import "UserDefault.h"
#import "UserRequest.h"

#define LOC_FAILED_ALERT [[NSUserDefaults standardUserDefaults] valueForKey:@"loc_failed"]
#define LOC_FAILED_ALERT_WRITE(updateTime) [[NSUserDefaults standardUserDefaults] setValue:updateTime forKey:@"loc_failed"]

#define kDesiredAccuracy 500 //:meter
#define KLocationAge 60 //:s
#define kTimeout 20 //:s
#define kMaxFailedNum 5 //:s

NSString *const LocationUpdateSucceededNotification = @"LocationUpdateSucceededNotification";
NSString *const LocationUpdateFailedNotification = @"LocationUpdateFailedNotification";

NSString *const LocationChangedNotification = @"LocationChangedNotification";

NSString *const AddressUpdateSucceededNotification = @"AddressUpdateSucceededNotification";
NSString *const AddressUpdateFailedNotification = @"AddressUpdateFailedNotification";

@interface LocationEngine ()

- (void)stop:(NSNumber *)state error:(NSError *)error;

@end

@implementation LocationEngine

@synthesize currentSta;
@synthesize locationMeasurements, bestLocation;
@synthesize latitude, longitude;

static LocationEngine *_sharedLocationEngine = nil;

+ (LocationEngine *)sharedLocationEngine {
    @synchronized(self) {
        if (_sharedLocationEngine == nil) {
            _sharedLocationEngine = [[LocationEngine alloc] init];
        }
        return _sharedLocationEngine;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        locationMeasurements = [[NSMutableArray alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
            //            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }

        locationManager.delegate = self;

        self.num = 0;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [locationManager requestWhenInUseAuthorization];
            }
            break;
        default:
            break;
    }
}

- (void)dealloc {
    [locationManager release];
    [locationMeasurements release];
    [bestLocation release];
    [super dealloc];
}

- (double)latitude {
    return bestLocation.coordinate.latitude;
}

- (double)longitude {
    return bestLocation.coordinate.longitude;
}

- (void)start {
    self.num = 0;
    self.currentSta = LocationEngineUpdating;
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kDesiredAccuracy;
    [locationManager startUpdatingLocation];

    [self performSelector:@selector(stop:error:)
               withObject:[NSNumber numberWithInt:LocationEngineTimeout]
               afterDelay:kTimeout];
}

- (void)reset {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(stop:error:)
                                               object:[NSNumber numberWithInt:LocationEngineTimeout]];
    self.currentSta = LocationEngineEnd;
    [locationMeasurements removeAllObjects];
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
}

- (void)stop {
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(stop:error:)
                                               object:[NSNumber numberWithInt:LocationEngineTimeout]];
    [locationManager stopUpdatingLocation];
}

- (void)stop:(NSNumber *)state error:(NSError *)error {
    self.currentSta = (LocationEngineStates)[state intValue];

    if (currentSta == LocationEngineTimeout && bestLocation)
        self.currentSta = LocationEngineSuccess;

    if (self.currentSta == LocationEngineTimeout && !bestLocation) {
        NSNotification *n = [NSNotification notificationWithName:LocationUpdateFailedNotification
                                                          object:nil
                                                        userInfo:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotification:n];
        });
    } else if (currentSta == LocationEngineSuccess) {
        NSNotification *n = [NSNotification notificationWithName:LocationUpdateSucceededNotification
                                                          object:nil
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                   bestLocation.timestamp, @"updateTime",
                                                                                   bestLocation, @"location", nil]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotification:n];
        });

    } else if (currentSta == LocationEngineError) {
        NSNotification *n = [NSNotification notificationWithName:LocationUpdateFailedNotification
                                                          object:nil
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error, @"error", nil]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotification:n];
        });
    }

    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(stop:error:)
                                               object:[NSNumber numberWithInt:LocationEngineTimeout]];

    [locationManager stopUpdatingLocation];
    [locationMeasurements removeAllObjects];
    locationManager.delegate = nil;
}

- (BOOL)locationExpired {
    if (!bestLocation || [bestLocation.timestamp timeIntervalSinceNow] < -3600 || self.latitude == 0 || self.longitude == 0) {
        return YES;
    }
    return NO;
}

#pragma mark utility
- (void)changeCityId:(NSString *)cityId {
    //    if ([cityId intValue] != USER_CITY) {
    //
    //    }
}

- (double)metersFormPositonWithLatitude:(double)latitude1 longitude:(double)longitude1
                 toPositionWithLatitude:(double)latitude2
                              longitude:(double)longitude2 {
    return sqrtf(powf((latitude1 - latitude2) * 111000, 2) + powf((longitude1 - longitude2) * 111000 * cosf(longitude1), 2));
}

#pragma mark locationManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.bestLocation = [locations firstObject];
    if (bestLocation == nil || bestLocation.horizontalAccuracy >= self.bestLocation.horizontalAccuracy) {
        self.coordinate2D = self.bestLocation.coordinate;
        [manager stopUpdatingHeading];
        [self getLocationDescFor:self.bestLocation];
        if (self.bestLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            [self stop:[NSNumber numberWithInt:LocationEngineSuccess] error:nil];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop:error:) object:nil];
        }
        NSString *bestlatitude = [NSString stringWithFormat:@"%f", self.bestLocation.coordinate.latitude];
        NSString *bestlongitude = [NSString stringWithFormat:@"%f", self.bestLocation.coordinate.longitude];

        USER_LATITUDE_WRITE(bestlatitude);
        USER_LONGITUDE_WRITE(bestlongitude);

        [self rigistKotaPush];
    }
    if (!USER_GPS_CITY) {
        [self getLocationDescFor:self.bestLocation];
    }
}

- (void)rigistKotaPush {
    
    UserRequest *request = [UserRequest new];
    [request updateUserPosition];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self stop:[NSNumber numberWithInt:LocationEngineError] error:error];

    NSDate *updateTime = LOC_FAILED_ALERT;

    /*
     kCLErrorLocationUnknown  = 0,         // location is currently unknown, but CL will keep trying
     
     kCLErrorNetwork,                      // general, network-related error
     kCLErrorHeadingFailure,               // heading could not be determined
     
     kCLErrorDenied,                       // CL access has been denied (eg, user declined location use)
     kCLErrorRegionMonitoringDenied,       // Location region monitoring has been denied by the user
     
     kCLErrorRegionMonitoringFailure,      // A registered region cannot be monitored
     kCLErrorRegionMonitoringSetupDelayed, // CL could not immediately initialize region monitoring
     kCLErrorRegionMonitoringResponseDelayed, // While events for this fence will be delivered, delivery will not occur immediately
     kCLErrorGeocodeFoundNoResult,         // A geocode request yielded no result
     kCLErrorGeocodeFoundPartialResult,    // A geocode request yielded a partial result
     kCLErrorGeocodeCanceled
     */
    NSNotification *notification = [NSNotification notificationWithName:AddressUpdateFailedNotification
                                                                 object:nil
                                                               userInfo:@{ @"error" : error }];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });

    if (!updateTime || [updateTime timeIntervalSinceNow] < -3600) {
        LOC_FAILED_ALERT_WRITE([NSDate date]);

        NSInteger errorCode = [error code];

        NSString *errorDesc = nil;
        if (error && (errorCode == kCLErrorDenied || errorCode == kCLErrorRegionMonitoringDenied)) {
            errorDesc = @"您还没有开启定位功能";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:errorDesc
                                                               delegate:nil
                                                      cancelButtonTitle:@"好的"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        } else {
            errorDesc = @"暂时无法确定您的位置";
        }
    }

    if (![CLLocationManager locationServicesEnabled]) {
        USER_GPS_CITY_WRITE(nil);
    }
}

#pragma mark GPS relate delegate
- (void)getLocationDescFor:(CLLocation *)location {
    if (!location) return;

    if (runningOniOS5) {
        CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
        [clGeoCoder reverseGeocodeLocation:location
                         completionHandler:^(NSArray *placemarks, NSError *error) {

                             DLog(@"self.num=%d location %@...error...%@", self.num, location, error);

                             NSString *currentCity;
                             if (error) {
                                 self.num++;
                                 if (self.num <= kMaxFailedNum) {
                                     [self getLocationDescFor:location];
                                     return;
                                 } else {
                                     NSNotification *notification = [NSNotification notificationWithName:AddressUpdateFailedNotification
                                                                                                  object:nil
                                                                                                userInfo:nil];
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [[NSNotificationCenter defaultCenter] postNotification:notification];
                                     });
                                 }

                             } else {
                                 if ([placemarks count]) {
                                     //                                     MKPlacemark *placemark = [placemarks objectAtIndex:0];

                                     for (CLPlacemark *placeMark in placemarks) {
                                         if (placeMark.locality) {
                                             currentCity = placeMark.locality;

                                             NSDictionary *addressDict = placeMark.addressDictionary;
                                             NSMutableArray *addressArr = addressDict[@"FormattedAddressLines"];

                                             if (addressArr.firstObject) {
                                                 NSString *userCurrentAddress = [addressArr.firstObject substringFromIndex:currentCity.length - 1];
                                                 DLog(@"%@", userCurrentAddress);

                                                 USER_CURRENT_ADDRESS_WRITE(userCurrentAddress);
                                             }

                                         } else {
                                             currentCity = placeMark.administrativeArea;
                                             //                                             currentCity=[placemark.administrativeArea substringToIndex:[placemark.administrativeArea length]-1];
                                         }

                                         if ([currentCity isEqualToString:@"北京市市辖区"]) {
                                             currentCity = @"北京";
                                         } else if ([currentCity isEqualToString:@"上海市市辖区"]) {
                                             currentCity = @"上海";
                                         } else if ([currentCity isEqualToString:@"重庆市市辖区"]) {
                                             currentCity = @"重庆";
                                         } else if ([currentCity isEqualToString:@"天津市市辖区"]) {
                                             currentCity = @"天津";
                                         }
                                         USER_GPS_CITY_WRITE(currentCity);
                                         DLog(@"USER_GPS_CITY --%@", USER_GPS_CITY);
                                     }
                                 }
                                 NSNotification *notification = [NSNotification notificationWithName:AddressUpdateSucceededNotification
                                                                                              object:self
                                                                                            userInfo:nil];

                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [[NSNotificationCenter defaultCenter] postNotification:notification];

                                 });
                             }

                             [clGeoCoder release];
                         }];
    }
}
@end
