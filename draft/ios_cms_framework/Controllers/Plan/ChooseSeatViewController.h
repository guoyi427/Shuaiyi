//
//  ChooseSeatViewController.h
//  CIASMovie
//
//  Created by cias on 2016/12/22.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HallView_KKZ/HallView.h>
#import <HallView_KKZ/CPNavigatorView.h>
#import <HallView_KKZ/CPSeatIndexView.h>
#import "Seat.h"
#import "Plan.h"
#import "PlanDate.h"
#import "HasEmptySeatView.h"

@interface ChooseSeatViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, HallViewDelegate>
{
    UICollectionView *planListCollectionView;
    UIScrollView *scrollViewHolder;
    UIView *holder;
    UIImageView *selectseatscreenImageview;
    UILabel *cinemaTitleLabel, *movieTitleLabel;
    UILabel *dateLabel, *detailDateLabel;
    UILabel *hallNameLabel;
    UILabel *screenTypeLabel;
    UIButton *confirmBtn;
    BOOL initFirst;
    int timeCountOfRegister,timeCountOfForget;
}
@property (nonatomic, strong) UIScrollView *scrollHallView;
@property (nonatomic, strong) HallView *hallView;
@property (nonatomic, strong) CPNavigatorView *navigatorView;
@property (nonatomic, strong) CPSeatIndexView *seatIndexView;
@property (nonatomic, strong) NSTimer *timerForNavigator;
@property (nonatomic, strong) UIView *ticketRecommentView;
@property (nonatomic, strong) UIView *ticketView;
@property (nonatomic, assign) NSInteger selectDateRow;
@property (nonatomic, strong) NSMutableDictionary *selectSeatIconDict;

@property (nonatomic, strong) NSTimer *timerOfRegister;
@property (nonatomic, strong) NSTimer *timerOfForget;
@property (nonatomic, strong) HasEmptySeatView *hasEmptySeatView;

/**
 *  缩略图timer Yes:重置开始计时 No:正常倒计时
 *  拖拽、zoom、点击座位时，set YES
 */
@property (nonatomic) BOOL timerFlag;
/**
 *  可选座位数
 */
@property (nonatomic) int canBuyCnt;
/**
 已选中座位，seatId e.g. "0000000000000001-4-03"
 */
@property (nonatomic, strong) NSMutableArray *selectedSeats;
@property (nonatomic, strong) NSMutableArray *printableSelectedSeats;
/**
 *  全部的座位
 */
@property (nonatomic, strong) NSArray *allSeats;
/**
 *  不可选的座位
 */
@property (nonatomic, strong) NSArray *unavailableSeats;
@property (nonatomic) CGFloat miniScale;
@property (nonatomic, strong) NSArray *seatsForHallView;

@property (nonatomic, assign) NSInteger selectPlanTimeRow;
@property (nonatomic, strong) NSMutableArray *planList;
@property (nonatomic, strong) Plan *selectPlan;
@property (nonatomic, strong) PlanDate *selectPlanDate;

@property (nonatomic, copy) NSString *planDateString;
@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *movieName;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, copy) NSString *planId;//排期Id是对应接口返回的sessionId

@end
