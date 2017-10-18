//
//  PlanTimeCell.h
//  CIASMovie
//
//  Created by cias on 2017/3/25.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Plan.h"
@protocol PlanTimeCellDelegate <NSObject>
- (void)selctCellWithIndex:(NSInteger)selectIndexRow;
@end

@interface PlanTimeCell : UITableViewCell{
    UILabel *dateLabel, *overTimeLabel, *priceLabel, *contrastPriceLabel, *promotionLabel,*promotionCountLabel;
    UILabel *screenTypeLabel, *languageLael, *hallNameLabel;
    UIImageView *huiImageView;
    UIButton *huiButton, *ticketButton, *expiredButton;
    UIImageView *arrowImageView;
    UISegmentedControl *priceSegment;
}

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger selectIndexRow;
@property (nonatomic, strong) Plan *selectPlan;

@property (nonatomic, assign) id <PlanTimeCellDelegate>delegate;


- (void)updateLayout;

@end
