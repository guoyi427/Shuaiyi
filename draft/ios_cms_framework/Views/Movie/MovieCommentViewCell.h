//
//  MovieCommentViewCell.h
//  CIASMovie
//
//  Created by avatar on 2016/12/31.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCommentViewCell : UITableViewCell

{
    UILabel *cinemaNameLabel;
    UILabel *cinemaAddressLabel;
    UILabel *distanceLabel;
    UILabel *flagLabel;
    UIView *line;
    UIImageView *locationImageView, *selectedImageView;
}
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, copy) NSString *cinemaAddress;
@property (nonatomic, strong) NSNumber *isnear;


- (void)updateLayout;

@end
