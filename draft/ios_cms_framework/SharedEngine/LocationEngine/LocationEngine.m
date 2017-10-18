//
//  LocationEngine.m
//  phonebook
//
//  Created by zhang da on 10-10-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LocationEngine.h"
#import "UserDefault.h"

#define LOC_FAILED_ALERT [[NSUserDefaults standardUserDefaults] valueForKey:@"loc_failed"]
#define LOC_FAILED_ALERT_WRITE(updateTime) [[NSUserDefaults standardUserDefaults] setValue:updateTime forKey:@"loc_failed"]

#define kDesiredAccuracy 500 //:meter
#define KLocationAge 60 //:s
#define kTimeout 20 //:s
#define kMaxFailedNum 5 //:s


NSString * const LocationUpdateSucceededNotification = @"LocationUpdateSucceededNotification";
NSString * const LocationUpdateFailedNotification = @"LocationUpdateFailedNotification";

NSString * const LocationChangedNotification = @"LocationChangedNotification";

NSString * const AddressUpdateSucceededNotification = @"AddressUpdateSucceededNotification";
NSString * const AddressUpdateFailedNotification = @"AddressUpdateFailedNotification";

@interface LocationEngine ()


- (void)stop:(NSMutableArray *)infoArr;

@end


@implementation LocationEngine

@synthesize currentSta;
@synthesize locationMeasurements, bestLocation;
@synthesize latitude, longitude;

static LocationEngine * _sharedLocationEngine = nil;

+ (LocationEngine *)sharedLocationEngine {
	@synchronized(self) {
        if ( _sharedLocationEngine == nil ) {
            _sharedLocationEngine = [[LocationEngine alloc] init];
        }
        return _sharedLocationEngine;
    }
}

- (id)init {
	self = [super init];
    if (self) {
        self.clAuthorizationStatusNumber = -1;
        locationMeasurements = [[NSMutableArray alloc] init];
        locationManager = [[CLLocationManager alloc] init];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
//            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }
        
        locationManager.delegate = self;
        _locService = [[BMKLocationService alloc]init];
        geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
        geoCodeSearch.delegate = self;
        self.num = 0;
    }
	return self;
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:
            self.clAuthorizationStatusNumber = 0;

            if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [locationManager requestWhenInUseAuthorization];
            }
            break;
            
        case kCLAuthorizationStatusRestricted:
            
            self.clAuthorizationStatusNumber = 1;
            
        case kCLAuthorizationStatusDenied:
            
            self.clAuthorizationStatusNumber = 2;
        case kCLAuthorizationStatusAuthorizedAlways:
            
            self.clAuthorizationStatusNumber = 3;
            
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            
            self.clAuthorizationStatusNumber = 4;
            DLog(@"clAuthorizationStatusNumber == %d",self.clAuthorizationStatusNumber);

        default:
            break;
//            
//            NSNotification *n = [NSNotification notificationWithName:@"CLAuthorizationStatus"
//                                                              object:@(self.clAuthorizationStatusNumber)
//                                                            userInfo:nil];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [[NSNotificationCenter defaultCenter] postNotification:n];
//            });

    }
    
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
    _locService.delegate = self;
    [_locService startUserLocationService];
    NSMutableArray *infoArr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:LocationEngineTimeout],@"", nil];
	[self performSelector:@selector(stop:) withObject:infoArr afterDelay:kTimeout];
    
}

- (void)reset {
    NSMutableArray *infoArr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:LocationEngineTimeout],@"", nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(stop:)
                                               object:infoArr];
	self.currentSta = LocationEngineEnd;
	[locationMeasurements removeAllObjects];
    locationManager.delegate = nil;
	[locationManager stopUpdatingLocation];
    _locService.delegate = nil;
    [_locService stopUserLocationService];

}

- (void)stop {
    NSMutableArray *infoArr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:LocationEngineTimeout],@"", nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(stop:)
                                               object:infoArr];
	[locationManager stopUpdatingLocation];
}

- (void)stop:(NSMutableArray *)infoArr {
    
	self.currentSta = (LocationEngineStates)[[infoArr objectAtIndex:0] intValue];
    NSError *error = nil;
    if ([infoArr objectAtIndex:1]) {
        error = (NSError *)[infoArr objectAtIndex:1];
    }
    
	if ( currentSta == LocationEngineTimeout && bestLocation )
		self.currentSta = LocationEngineSuccess;
	
	if (self.currentSta == LocationEngineTimeout && !bestLocation) {
		NSNotification *n = [NSNotification notificationWithName:LocationUpdateFailedNotification
                                                          object:nil
                                                        userInfo:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotification:n];
        });
	} else if ( currentSta == LocationEngineSuccess ) {
		NSNotification *n = [NSNotification notificationWithName:LocationUpdateSucceededNotification
                                                          object:nil
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                  bestLocation.timestamp, @"updateTime",
                                                                  bestLocation, @"location", nil]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotification:n];
        });

	} else if ( currentSta == LocationEngineError ){
        NSNotification *n = [NSNotification notificationWithName:LocationUpdateFailedNotification
                                                          object:nil
                                                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:error,@"error",nil]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotification:n];
        });
    }
    NSMutableArray *infoArr1 = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:LocationEngineTimeout],@"", nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(stop:)
                                               object:infoArr1];
    
	[locationManager stopUpdatingLocation];
	[locationMeasurements removeAllObjects];
    locationManager.delegate = nil;
}

- (BOOL)locationExpired {
    if (!bestLocation
        || [bestLocation.timestamp timeIntervalSinceNow] < -3600
        || self.latitude == 0
        || self.longitude == 0) {
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
                 toPositionWithLatitude:(double)latitude2 longitude:(double)longitude2 {
    return sqrtf( powf( (latitude1 - latitude2) * 111000, 2)
                 + powf( (longitude1- longitude2) * 111000 * cosf(longitude1), 2) );
}



#pragma mark locationManager delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.bestLocation = [locations firstObject];
    if (bestLocation == nil || bestLocation.horizontalAccuracy >= self.bestLocation.horizontalAccuracy) {
        self.coordinate2D = self.bestLocation.coordinate;
        [manager stopUpdatingHeading];
        [self getLocationDescFor:self.bestLocation];
        if (self.bestLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            NSMutableArray *infoArr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:LocationEngineSuccess],@"", nil];
            [self stop:infoArr];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop:) object:nil];
        }
        NSString *bestlatitude = [NSString stringWithFormat:@"%f",self.bestLocation.coordinate.latitude];
        NSString *bestlongitude = [NSString stringWithFormat:@"%f",self.bestLocation.coordinate.longitude];
            self.isHasLocation = YES;

        USER_LATITUDE_WRITE(bestlatitude);
        USER_LONGITUDE_WRITE(bestlongitude);
    
    }
    if (!USER_GPS_CITY) {
    [self getLocationDescFor:self.bestLocation];
    }else{
        NSNotification *notification = [NSNotification notificationWithName:AddressUpdateSucceededNotification
                                                                     object:self
                                                                   userInfo:nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
        });

    }

}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DLog(@"locationManager didFailWithError == %@",[error description]);
    NSMutableArray *infoArr = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:LocationEngineError],error, nil];
    [self stop:infoArr];
    
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
    NSNotification * notification = [NSNotification notificationWithName:AddressUpdateFailedNotification
                                                                  object:nil
                                                                userInfo:@{@"error": error}];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    });

    
    if (!updateTime || [updateTime timeIntervalSinceNow] < -3600) {
        LOC_FAILED_ALERT_WRITE([NSDate date]);
        
        NSInteger errorCode = [error code];
        
        NSString *errorDesc = nil;
        if (error && ( errorCode == kCLErrorDenied || errorCode == kCLErrorRegionMonitoringDenied ) ) {
            self.isHasLocation = NO;
            USER_GPS_CITY_WRITE(nil);
            USER_LATITUDE_WRITE(nil);
            USER_LONGITUDE_WRITE(nil);
            errorDesc = @"你还没有开启定位功能";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:errorDesc
                                                               delegate:nil
                                                      cancelButtonTitle:@"好的"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        } else {
            errorDesc = @"暂时无法确定你的位置";
            self.isHasLocation = YES;

        }
      
    }
    
    if (![CLLocationManager locationServicesEnabled]) {
        USER_GPS_CITY_WRITE(nil);
    }
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSString *baidulatitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    NSString *baidulongitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    DLog(@"baidu  baidulatitude == %@ baidulongitude == %@", baidulatitude,baidulongitude);
    BAIDU_USER_LATITUDE_WRITE(baidulatitude);
    BAIDU_USER_LONGITUDE_WRITE(baidulongitude);
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_locService stopUserLocationService];
//    [geoCodeSearch reverseGeoCode:userLocation];

}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    DLog(@"searcher==%@   result==%@  error==%d", searcher, result, error);
}




#pragma mark GPS relate delegate
- (void)getLocationDescFor:(CLLocation *)location {
    if (!location) return;
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    [clGeoCoder reverseGeocodeLocation:location
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         
                         DLog(@"self.num=%d location %@...error...%@",self.num,location, error);
                         
                         NSString * currentCity;
                         if (error) {
                             self.num++;
                             if (self.num<=kMaxFailedNum) {
                                 [self getLocationDescFor:location];
                                 return ;
                             }else{
                                 NSNotification * notification = [NSNotification notificationWithName:AddressUpdateFailedNotification
                                                                                               object:nil
                                                                                             userInfo:nil];
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [[NSNotificationCenter defaultCenter] postNotification:notification];
                                 });
                                 
                             }
                             
                             
                         } else {
                             if ([placemarks count]) {
                                 //                                     MKPlacemark *placemark = [placemarks objectAtIndex:0];
                                 
                                 for (CLPlacemark *placeMark in placemarks)
                                 {
                                     if (placeMark.locality) {
                                         currentCity = placeMark.locality;
                                         
                                         NSDictionary *addressDict = placeMark.addressDictionary;
                                         NSMutableArray *addressArr = addressDict[@"FormattedAddressLines"];
                                         
                                         if (addressArr.firstObject) {
                                             NSString *userCurrentAddress = [addressArr.firstObject substringFromIndex:currentCity.length - 1];
                                             DLog(@"%@",userCurrentAddress);
                                             
                                             
                                             USER_CURRENT_ADDRESS_WRITE(userCurrentAddress);
                                             
                                         }
                                         
                                         
                                         
                                     }else {
                                         currentCity = placeMark.administrativeArea;
                                         //                                             currentCity=[placemark.administrativeArea substringToIndex:[placemark.administrativeArea length]-1];
                                     }
                                     
                                     if ([currentCity isEqualToString:@"北京市市辖区"]) {
                                         currentCity = @"北京";
                                     }else if ([currentCity isEqualToString:@"上海市市辖区"]){
                                         currentCity = @"上海";
                                     }else if ([currentCity isEqualToString:@"重庆市市辖区"]){
                                         currentCity = @"重庆";
                                     }else if ([currentCity isEqualToString:@"天津市市辖区"]){
                                         currentCity = @"天津";
                                     }
                                     USER_GPS_CITY_WRITE(currentCity);
                                     DLog(@"USER_GPS_CITY --%@",USER_GPS_CITY);
                                     
                                     
                                 }
                             }
                             NSNotification *notification = [NSNotification notificationWithName:AddressUpdateSucceededNotification
                                                                                          object:self
                                                                                        userInfo:nil];
                             
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [[NSNotificationCenter defaultCenter] postNotification:notification];
                                 
                             });
                             
                         }
                         
                     }];
    
    
    

}
@end

