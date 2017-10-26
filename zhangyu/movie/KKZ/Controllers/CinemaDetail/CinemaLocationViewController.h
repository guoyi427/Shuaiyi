//
//  CinemaLocationViewController.h
//  KKZ
//
//  Created by alfaromeo on 12-3-23.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "CommonViewController.h"

@class CinemaDetail;

@interface CinemaLocationViewController
    : CommonViewController <MKMapViewDelegate>
/**
 *  选参
 */
@property(nonatomic, strong) CinemaDetail *cinemaDetail;

- (id)initWithCinema:(NSString *)cinemaId;

@end
