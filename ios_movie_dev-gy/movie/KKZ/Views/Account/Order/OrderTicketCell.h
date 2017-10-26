//
//  我的 - 订单管理 列表
//
//  Created by da zhang on 11-9-17.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "Order.h"
#import "Ticket.h"

@class RoundCornersButton;

typedef enum {
    OrderTicketCellStateDefault = 0,
    OrderTicketCellStateExpand,
} OrderTicketCellState;

@protocol OrderTicketCellDelegate <NSObject>
@optional
- (void)handleTouchOnPayAtRow:(int)row;
- (void)handleTouchOnDeleteAtRow:(int)row;
- (void)handleTouchOnRebateAtRow:(int)row;
- (void)handleTouchAtRow:(int)row;

@end

@interface OrderTicketCell : UITableViewCell {

    NSString *movieName, *movieTime, *cinemaName, *orderState;
    int dealPrice;
    OrderState currentState;

    UIImageView *cellBackgroundView;
    UILabel *timeCountdownLabel;
    UILabel *cinemaLabel, *movieLabel, *timeLabel, *timeTipLabel, *movieTypeL, *movieCountryL;
    NSTimer *timer;
}

@property (nonatomic, weak) id<OrderTicketCellDelegate> delegate;

@property (nonatomic, strong) NSString *movieName;
@property (nonatomic, strong) NSString *movieTime;
@property (nonatomic, strong) NSDate *orderTime;
@property (nonatomic, strong) NSString *movieType;
@property (nonatomic, strong) NSString *movieCountry;
@property (nonatomic, strong) NSString *cinemaName;
@property (nonatomic, strong) NSString *orderState;
@property (nonatomic, strong) NSString *introducer;

@property (nonatomic, strong) NSNumber *orderStateY;

@property (nonatomic, assign) int dealPrice;
@property (nonatomic, assign) NSInteger rowNumInTable;
@property (nonatomic, assign) OrderState currentState;

@property (nonatomic, assign) OrderTicketCellState currentCellState;


@property (nonatomic, strong) Order *order;
@property (nonatomic, strong) Ticket *ticket;

- (void)updateLayout;
+ (float)heightWithCellState:(OrderTicketCellState)state;

@end
