//
//  城市列表的Cell
//
//  Created by xuyang on 13-4-23.
//  Copyright (c) 2013年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@protocol CityCellDelegate <NSObject>

/**
 *  点击按钮对应的城市Id和城市名字
 */
- (void)handleTouchWithCityId:(int)cityId
                 withCityName:(NSString *)cityName;

@end

@interface CityCell : UITableViewCell {

    UILabel *leftLable, *middleLabel, *rightLabel;
    CGRect leftRect, middelRect, rightRect;
}

@property (nonatomic, assign) id<CityCellDelegate> delegate;

@property (nonatomic, retain) NSString *leftName;
@property (nonatomic, retain) NSString *middleName;
@property (nonatomic, retain) NSString *rightName;

@property (nonatomic, assign) int leftId;
@property (nonatomic, assign) int middleId;
@property (nonatomic, assign) int rightId;

- (void)updateLayout;

@end
