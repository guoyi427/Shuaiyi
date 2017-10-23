//
//  CityCell.h
//  CIASMovie
//
//  Created by hqlgree2 on 26/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityCellDelegate <NSObject>

/**
 *  点击按钮对应的城市Id和城市名字
 */
- (void)handleTouchWithCityId:(int)cityId
                 withCityName:(NSString *)cityName;

@end

@interface CityCell : UITableViewCell
{
    UILabel *cityNameLabel;
    UIImageView *selectedImageView;
    
    // kkz
    UILabel *leftLable, *middleLabel, *rightLabel;
    CGRect leftRect, middelRect, rightRect;
}
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign) BOOL isSelected;

//  kkz
@property (nonatomic, assign) id<CityCellDelegate> delegate;

@property (nonatomic, retain) NSString *leftName;
@property (nonatomic, retain) NSString *middleName;
@property (nonatomic, retain) NSString *rightName;

@property (nonatomic, assign) int leftId;
@property (nonatomic, assign) int middleId;
@property (nonatomic, assign) int rightId;

- (void)updateLayout;

@end
