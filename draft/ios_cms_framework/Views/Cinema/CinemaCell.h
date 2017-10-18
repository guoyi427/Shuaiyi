//
//  CinemaCell.h
//  CIASMovie
//
//  Created by cias on 2016/12/26.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CinemaCell : UITableViewCell
{
    UILabel     *cinemaNameLabel;
    UILabel     *cinemaAddressLabel;
    UILabel     *distanceLabel;
    UILabel     *nearLabel, *comeLabel;
    UIView      *cinemaFeatureView;
    UIView      *line;
    UIImageView *locationImageView, *selectedImageView;
}
@property (nonatomic, assign) BOOL     isSelected;

@property (nonatomic, strong) UIView   *bgView;
@property (nonatomic, copy) NSString   *cinemaName;
@property (nonatomic, copy) NSString   *cinemaAddress;
@property (nonatomic, copy) NSString   *distance;

@property (nonatomic, strong) NSNumber *isnear;
@property (nonatomic, strong) NSNumber *isCome;

@property (nonatomic, strong) NSArray  *featureArr;
@property (nonatomic, assign) BOOL     isFromOpenCard;


- (void)updateLayout;

@end
