//
//  LocationEngine.h
//  phonebook
//
//  Created by zhang da on 10-10-30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
//#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件




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


@interface LocationEngine : NSObject < CLLocationManagerDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate> {
	LocationEngineStates currentSta;
    CLLocationManager *locationManager;
    NSMutableArray *locationMeasurements;
    BMKLocationService* _locService;
    BMKGeoCodeSearch *geoCodeSearch;
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
@property (nonatomic, assign) int clAuthorizationStatusNumber;
@property (nonatomic, assign) BOOL isHasLocation;


+ (LocationEngine *)sharedLocationEngine;

- (void)start;
- (void)reset;
- (void)stop;
- (BOOL)locationExpired;

- (void)getLocationDescFor:(CLLocation *)location;
- (double)metersFormPositonWithLatitude:(double)latitude1 longitude:(double)longitude1
                 toPositionWithLatitude:(double)latitude2 longitude:(double)longitude2;


@end

