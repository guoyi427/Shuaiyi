//
//  CityCell.h
//  CIASMovie
//
//  Created by hqlgree2 on 26/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityCell : UITableViewCell
{
    UILabel *cityNameLabel;
    UIImageView *selectedImageView;
}
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, assign) BOOL isSelected;

- (void)updateLayout;

@end
