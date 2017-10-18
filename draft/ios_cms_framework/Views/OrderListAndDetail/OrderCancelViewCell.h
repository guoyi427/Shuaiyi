//
//  OrderCancelViewCell.h
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListOfMovie.h"
#import "OrderListRecord.h"

@interface OrderCancelViewCell : UITableViewCell
{
    UILabel *statusLabel, *orderNameLabel, *cinemaNameLabel, *movieNameLabel,*orderTimeLabel,*productNameLabel,*productTimeLabel,*totalMoneyLabel,*timeValidLabel,*orderStatusLabel;
    UIButton *payBtn;
    UIView *line1View,*line2View,*line3View,*line4View;
}

@property (nonatomic,strong) NSString *orderNameLabelStr,*cinemaNameLabelStr,*movieNameLabelStr,*orderTimeLabelStr,*productNameLabelStr,*productTimeLabelStr,*totalMoneyLabelStr,*timeValidLabelStr,*orderStatusLabelStr;

@property (nonatomic,strong) OrderListOfMovie *orderListMovieCancelData;
@property (nonatomic,strong) OrderListOfMovie *orderListProductCancelData;
@property (nonatomic,strong) OrderListRecord *orderListRecordCancelData;

@property (nonatomic, strong)  NSTimer *timerCancel;
@property (nonatomic, strong) NSMutableArray *orderMovieProductCancelList;
@property (nonatomic, strong) NSMutableArray *orderMovieCancelList;
@property (nonatomic, strong) NSMutableArray *orderProductCancelList;

- (void)updateLayout;


@end
