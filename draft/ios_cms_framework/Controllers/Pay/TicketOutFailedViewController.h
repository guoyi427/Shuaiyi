//
//  TicketOutFailedViewController.h
//  CIASMovie
//
//  Created by cias on 2017/1/22.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Plan.h"
#import "Movie.h"
#import "Cinema.h"
#import "PlanDate.h"
#import "Order.h"

@interface TicketOutFailedViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
    UIScrollView *scrollViewHolder;
    UIView *holder;
    UICollectionView *planListCollectionView;
    UIImageView *huiImageView;
    UILabel *promotionLabel;
    UIImageView *arrowImageView;
    UIImageView *timeShadowImageview, *cinemaPosterImageView;
    UIButton *buyTicketBtn;
    UIView *hallNameView;
    UILabel *hallNameLabel;
    UILabel *screenTypeLabel;
}

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) NSMutableArray *planDateList;
@property (nonatomic, strong) NSMutableArray *planList;
@property (nonatomic, strong) Plan *selectPlan;
@property (nonatomic, strong) PlanDate *selectPlanDate;
@property (nonatomic, assign) NSInteger selectPlanTimeRow;
@property (nonatomic, assign) NSInteger selectDateRow;
@property (nonatomic, strong) Order *myOrder;


@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *movieName;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, copy) NSString *planId;//排期Id是对应接口返回的sessionId
@property (nonatomic, copy) NSString *selectPlanDateString;

@end
