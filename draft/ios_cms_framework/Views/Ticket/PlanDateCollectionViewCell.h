//
//  PlanDateCollectionViewCell.h
//  CIASMovie
//
//  Created by cias on 2016/12/16.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanDateCollectionViewCell : UICollectionViewCell

{
    UIView *selectBg;
    UILabel *dateLabel, *detailDateLabel;
    
}
@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, strong) NSNumber *planNum;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger selectIndexRow;

- (void)updateLayout;



@end
