//
//  MovieListPosterCollectionViewCell.h
//  CIASMovie
//
//  Created by cias on 2016/12/16.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Plan.h"

@interface PlanTimeCollectionViewCell : UICollectionViewCell
{
    UIView *selectBg;
    UILabel *dateLabel, *overTimeLabel, *priceLabel;
    UIImageView *huiImageView;
    
}
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger selectIndexRow;
@property (nonatomic, strong) Plan *selectPlan;

- (void)updateLayout;

@end
