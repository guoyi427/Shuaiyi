//
//  OrderNeedsPayViewCell.h
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListOfMovie.h"
#import "OrderListRecord.h"

@protocol OrderNeedsPayViewCellDelegate <NSObject>

- (void)handleCellOnPayBtn:(NSInteger) cellIndex;

@end

@interface OrderNeedsPayViewCell : UITableViewCell
{
    UILabel *statusLabel, *orderNameLabel, *cinemaNameLabel, *movieNameLabel,*orderTimeLabel,*productNameLabel,*productTimeLabel,*totalMoneyLabel,*timeValidLabel;
    UIButton *payBtn;
    double timeCount;
    UIView *line1View,*line2View,*line3View;

}

@property (nonatomic,strong) NSString *orderNameLabelStr,*cinemaNameLabelStr,*movieNameLabelStr,*orderTimeLabelStr,*productNameLabelStr,*productTimeLabelStr,*totalMoneyLabelStr,*timeValidLabelStr;

@property (nonatomic,strong) OrderListOfMovie *orderListMovieNeedsPayData;
@property (nonatomic,strong) OrderListOfMovie *orderListProductNeedsPayData;
@property (nonatomic,strong) OrderListRecord *orderListRecordNeedsPayData;
@property (nonatomic, weak) id <OrderNeedsPayViewCellDelegate> delegate;
@property (nonatomic, assign) NSInteger cellIndexPath;
@property (nonatomic, strong)  NSCalendar *calendar;
@property (nonatomic, strong)  NSTimer *timerNeedsPay;
@property (nonatomic, strong) NSMutableArray *orderMovieProductNeedsPayList;
@property (nonatomic, strong) NSMutableArray *orderMovieNeedsPayList;
@property (nonatomic, strong) NSMutableArray *orderProductNeedsPayList;

- (void)updateLayout;

@end
