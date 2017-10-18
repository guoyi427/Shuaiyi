//
//  OrderCompleteViewCell.h
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListOfMovie.h"
#import "OrderListRecord.h"

@interface OrderCompleteViewCell : UITableViewCell
{
    UILabel *statusLabel, *orderNameLabel, *cinemaNameLabel, *movieNameLabel,*orderTimeLabel,*productNameLabel,*productTimeLabel,*totalMoneyLabel,*timeValidLabel,*orderStatusLabel;
    UIButton *payBtn;
    double timeCount;
    UIView *line1View,*line2View,*line3View,*line4View;
}

@property (nonatomic,strong) NSString *orderNameLabelStr,*cinemaNameLabelStr,*movieNameLabelStr,*orderTimeLabelStr,*productNameLabelStr,*productTimeLabelStr,*totalMoneyLabelStr,*timeValidLabelStr,*orderStatusLabelStr;

@property (nonatomic,strong) OrderListOfMovie *orderListMovieCompleteData;
@property (nonatomic,strong) OrderListOfMovie *orderListProductCompleteData;
@property (nonatomic,strong) OrderListRecord *orderListRecordData;

@property (nonatomic, strong)  NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *orderMovieProductList;
@property (nonatomic, strong) NSMutableArray *orderMovieList;
@property (nonatomic, strong) NSMutableArray *orderProductList;


- (void)updateLayout;

@end
