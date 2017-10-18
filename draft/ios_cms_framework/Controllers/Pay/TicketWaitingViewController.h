//
//  TicketWaitingViewController.h
//  CIASMovie
//
//  Created by cias on 2017/1/22.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanDate.h"
#import "Plan.h"
#import "Order.h"

@interface TicketWaitingViewController : UIViewController{
    UIImageView *tipImageView;
    UILabel *orderStateLabel, *tipLabel,  *countDownLabel;
    NSTimer *timer;
    NSTimer *timer1;
    NSInteger countDownNum;
    NSInteger refreshCount;
}
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) NSMutableArray *planDateList;
@property (nonatomic, strong) NSMutableArray *planList;
@property (nonatomic, strong) Plan *selectPlan;
@property (nonatomic, strong) PlanDate *selectPlanDate;
@property (nonatomic, assign) NSInteger selectPlanTimeRow;
@property (nonatomic, assign) NSInteger selectDateRow;

@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *movieName;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, copy) NSString *planId;//排期Id是对应接口返回的sessionId
@property (nonatomic, copy) NSString *selectPlanDateString;
@property (nonatomic, strong) Order *myOrder;

@end
