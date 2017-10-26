//
//  影院地图页面显示影院信息的提示窗
//
//  Created by  nina on 11-7-23.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaAnnotation.h"

@implementation CinemaAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self.coordinate = coordinate;
    return self;
}

- (NSString *)title {
    return self.cinemaName;
}

- (NSString *)subtitle {
    return @"";
}

@end
