//
//  支付完成等待购票结果的动画页面
//
//  Created by on 11-7-28.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"
#import "OrderDetailViewController.h"
#import "OrderPaySucceedController.h"
#import "OrderPayViewController.h"
#import "PayViewController.h"
#import "ShareView.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"
#import "UIViewControllerExtra.h"
#import "UserDefault.h"

#import "Cinema.h"
#import "Coupon.h"
#import "Movie.h"
#import "Ticket.h"

#import "OrderTask.h"
#import "TaskQueue.h"

#import "DataEngine.h"
#import "DateEngine.h"
#import "ImageEngine.h"
#import "UIConstants.h"

#import "PayOrderFailController.h"
#import "RoundCornersButton.h"

#import "OrderRequest.h"

#define kMarginX 25
#define kFont 13
#define ANIMATION_ICON_WIDTH 80
#define ANIMATION_ICON_BARGIN 10

@interface OrderPayViewController ()
- (void)updateLayout;
@end

@implementation OrderPayViewController

#pragma mark - View lifecycle
- (id)initWithOrder:(NSString *)orderNo {
    self = [super init];
    if (self) {
        self.orderNo = orderNo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = appDelegate.kkzBlue;
    [self.navBarView setBackgroundColor:appDelegate.kkzBlue];

    self.kkzTitleLabel.text = @"订单状态";
    self.kkzTitleLabel.textColor = [UIColor whiteColor];

    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
    [holder setBackgroundColor:[UIColor r:245 g:245 b:245]];
    holder.delegate = self;
    holder.alpha = 1;
    holder.showsVerticalScrollIndicator = NO;
    [self.view addSubview:holder];

    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 145)];
    headview.backgroundColor = [UIColor whiteColor];
    headview.userInteractionEnabled = YES;
    [holder addSubview:headview];

    CGFloat positionYH = 20;

    UIView *animationBg = [[UIView alloc] initWithFrame:CGRectMake(
                                                                (screentWith - ANIMATION_ICON_WIDTH) / 2 - ANIMATION_ICON_BARGIN,
                                                                positionYH,
                                                                ANIMATION_ICON_WIDTH + ANIMATION_ICON_BARGIN * 2,
                                                                53)];
    animationBg.clipsToBounds = YES;
    [headview addSubview:animationBg];

    UIImage *imgStatusIcon = [UIImage imageNamed:@"mark_pay_loading"];
    imgStatusIconV = [[UIImageView alloc] initWithFrame:CGRectMake(
                                                                ANIMATION_ICON_BARGIN, 0, ANIMATION_ICON_WIDTH, 53)];
    imgStatusIconV.alpha = 0.5;
    imgStatusIconV.image = imgStatusIcon;
    imgStatusIconV.contentMode = UIViewContentModeScaleAspectFit;
    [animationBg addSubview:imgStatusIconV];

    positionYH += 63;

    orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, positionYH, screentWith, 20)];
    orderStateLabel.text = @"付款确认中,请稍等";
    orderStateLabel.textColor = [UIColor blackColor];
    orderStateLabel.textAlignment = NSTextAlignmentCenter;
    orderStateLabel.font = [UIFont systemFontOfSize:16];
    [headview addSubview:orderStateLabel];

    positionYH += 26;

    UILabel *warningText = [[UILabel alloc] initWithFrame:CGRectMake(0, positionYH + 5, screentWith, 20)];
    warningText.textAlignment = NSTextAlignmentCenter;
    warningText.font = [UIFont systemFontOfSize:14];
    warningText.numberOfLines = 0;
    warningText.textColor = [UIColor grayColor];
    warningText.text = @"如果等待时间过长，请尝试刷新一下哦~";
    [holder addSubview:warningText];

    UIImage *imgTicketBottom = [UIImage imageNamed:@"ticketPageBottom"];
    UIImageView *imgTicketBottomV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headview.frame) - 20, screentWith, 30)];
    imgTicketBottomV.image = imgTicketBottom;
    [holder insertSubview:imgTicketBottomV belowSubview:headview];

    RoundCornersButton *refreshOrderStatus = [[RoundCornersButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(headview.frame) + 20, screentWith - 15 * 2, 45)];
    refreshOrderStatus.cornerNum = kDimensCornerNum;
    refreshOrderStatus.rimColor = [UIColor r:180 g:180 b:180];
    refreshOrderStatus.rimWidth = 0.5;
    refreshOrderStatus.fillColor = [UIColor whiteColor];
    refreshOrderStatus.titleName = @"刷新订单状态";
    refreshOrderStatus.titleColor = [UIColor blackColor];
    refreshOrderStatus.titleFont = [UIFont systemFontOfSize:kTextSizeButtonLarge];
    [refreshOrderStatus addTarget:self action:@selector(refreshOrderStatus) forControlEvents:UIControlEventTouchUpInside];
    [holder addSubview:refreshOrderStatus];

    UIView *introText = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(refreshOrderStatus.frame) + 25, screentWith, 80)];
    [introText setBackgroundColor:[UIColor clearColor]];
    [holder addSubview:introText];

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screentWith - 15 * 2, 20)];
    titleLab.textColor = [UIColor grayColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.text = @"订票小窍门";
    [introText addSubview:titleLab];

    UILabel *introLab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, screentWith - 15 * 2, 40)];
    introLab1.textColor = [UIColor grayColor];
    introLab1.font = [UIFont systemFontOfSize:14];
    introLab1.numberOfLines = 0;
    introLab1.text = @"1.有的影院会安排多天的放映计划，只要有放映计划的影院都可以提前购票；";
    [introText addSubview:introLab1];

    UILabel *introLab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 25 + 40, screentWith - 15 * 2, 40)];
    introLab2.textColor = [UIColor grayColor];
    introLab2.font = [UIFont systemFontOfSize:14];
    introLab2.numberOfLines = 0;
    introLab2.text = @"2.为了避免错过开场，尽量提前半小时到影院换取电影票；";
    [introText addSubview:introLab2];

    UILabel *introLab3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 25 + 40 * 2, screentWith - 15 * 2, 40)];
    introLab3.textColor = [UIColor grayColor];
    introLab3.font = [UIFont systemFontOfSize:14];
    introLab3.numberOfLines = 0;
    introLab3.text = @"3.遇到无法换取电影票或其它问题，可以随时找小抠解决，小抠电话：400-000-9666";
    [introText addSubview:introLab3];

    [self refreshOrderDetail];
    [self cGAffineTransformOfImgStatusIconV];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self setStatusBarLightStyle];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:NO];

    [animationTimer invalidate];
    animationTimer = nil;
}

/*
 * 不停轮询并触发动画，每0.1s轮询一次
 */
- (void)cGAffineTransformOfImgStatusIconV {
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(checkAndFireAnimation:)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)dealloc {
    [orderDetailTimer invalidate];
    orderDetailTimer = nil;
}

- (void)checkAndFireAnimation:(NSTimer *)timer {
    if (isAnimating) {
        return;
    } else {
        isAnimating = YES;
    }

    CGAffineTransform trans = CGAffineTransformMakeTranslation(ANIMATION_ICON_WIDTH + ANIMATION_ICON_BARGIN, 0);
    [UIView animateWithDuration:2.0
            animations:^{
                imgStatusIconV.alpha = 1.0;
                imgStatusIconV.transform = trans;
            }
            completion:^(BOOL finished) {
                imgStatusIconV.alpha = 0.5f;
                imgStatusIconV.transform = CGAffineTransformIdentity;
                isAnimating = NO;
            }];
}

#pragma mark utilities

//1 - 未支付
//2 - 已取消
//3 - 已付款，出票中
//4 - 出票成功
//5 - 购票失败
//6 - 失败后取消
//7 - 过期
//8 - 欠款
//9 - 已退款
//10 - 支付超时
//如果支付宝付款成功但是没有回调抠电影服务器时订单状态是1，所以1、3都是中间状态，需要再次轮询
//1、3除外的都是订单的最终状态，只有4时订单才出票成功
- (void)refreshOrderStatus {

    OrderRequest *request = [OrderRequest new];
    [request requestOrderDetail:self.orderNo
            success:^(Order *_Nullable order) {
                
                self.order = order;
                if (self.order.orderStatus.intValue == 1 || self.order.orderStatus.intValue == 3) { //需要再次轮询
                    orderStateLabel.text = @"支付成功，待出票";
                }
                else {
                    [orderDetailTimer invalidate];
                    orderDetailTimer = nil;
                    [self updateLayout];
                }
                
                
//                if (self.order.orderStatus.intValue == 4 || self.order.orderStatus.intValue == 5 || self.order.orderStatus.intValue == 9 || self.order.orderStatus.intValue == 10) {
//                    [orderDetailTimer invalidate];
//                    orderDetailTimer = nil;
//                    [self updateLayout];
//                    
//                } else if (self.order.orderStatus.intValue == 3) {
//                    orderStateLabel.text = @"支付成功，待出票";
//                }
            }
            failure:^(NSError *_Nullable err){

            }];
}

- (void)updateLayout {
    if (self.order.orderStatus.intValue == 4) {
        //购票成功
        //统计事件：订单出票成功
        StatisEvent(EVENT_BUY_TICKET_SUCCESS);
        if (appDelegate.selectedTab == 0) {
            StatisEvent(EVENT_BUY_TICKET_SUCCESS_SOURCE_MOVIE);
        } else if (appDelegate.selectedTab == 1) {
            StatisEvent(EVENT_BUY_TICKET_SUCCESS_SOURCE_CINEMA);
        }

        [orderDetailTimer invalidate];
        orderDetailTimer = nil;

        OrderPaySucceedController *dd = [[OrderPaySucceedController alloc] initWithOrder:self.orderNo];
        dd.myOrder = self.order;
        NSLog(@"self.navigationController ======  %@", self.navigationController);
        [self.navigationController pushViewController:dd animated:YES];

//    } else if (self.order.orderStatus.intValue == 5 || self.order.orderStatus.intValue == 9 || self.order.orderStatus.intValue == 10) {
        
    } else if (self.order.orderStatus.intValue != 1 && self.order.orderStatus.intValue != 3) {
        
        //购票失败
        PayOrderFailController *dd = [[PayOrderFailController alloc] initWithOrder:self.orderNo];
        dd.order = self.order;
        [self pushViewController:dd animation:CommonSwitchAnimationSwipeR2L];
    }
}

- (void)refreshOrderDetail {

    OrderRequest *request = [OrderRequest new];
    [request requestOrderDetail:self.orderNo
            success:^(Order *_Nullable order) {
                [appDelegate hideIndicator];
                self.order = order;
                [orderDetailTimer invalidate];
                orderDetailTimer = nil;
                orderDetailTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(startTimerRoRefreshOrderStatus:) userInfo:nil repeats:YES];
            }
            failure:^(NSError *_Nullable err) {
                [appDelegate hideIndicator];
                [appDelegate showAlertViewForTitle:nil message:err.userInfo[KKZRequestErrorMessageKey] cancelButton:@"确定"];

            }];
}

- (void)startTimerRoRefreshOrderStatus:(NSTimer *)timer {

    [self refreshOrderStatus];
}

- (void)backtoHomepage {
    [self popToViewControllerAnimated:YES];
    [appDelegate setSelectedPage:0 tabBar:YES];
}

#pragma mark override from CommonViewController
- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return TRUE;
}

@end
