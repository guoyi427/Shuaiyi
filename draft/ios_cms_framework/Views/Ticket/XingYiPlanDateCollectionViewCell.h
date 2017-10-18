//
//  XingYiPlanDateCollectionViewCell.h
//  CIASMovie
//
//  Created by cias on 2017/3/25.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XingYiPlanDateCollectionViewCell : UICollectionViewCell
{
    UIView *selectLine;
    UILabel *dateLabel;
}

@property (nonatomic, copy) NSString *dateString;
@property (nonatomic, strong) NSNumber *planNum;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger selectIndexRow;

- (void)updateLayout;



@end
