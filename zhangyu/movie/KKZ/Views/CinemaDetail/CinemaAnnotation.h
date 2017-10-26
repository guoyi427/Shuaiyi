//
//  影院地图页面显示影院信息的提示窗
//
//  Created by  nina on 11-7-23.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "Cinema.h"

@interface CinemaAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *cinemaId;
@property (nonatomic, strong) NSString *cinemaName;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
