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
#import "ZYOrderDetailViewController.h"
#import "CinemaTicketViewController.h"

#define kMarginX 25
#define kFont 13
#define ANIMATION_ICON_WIDTH 80
#define ANIMATION_ICON_BARGIN 10

@interface OrderPayViewController ()
{
    NSInteger _angle;
    
    //  UI
    UILabel *_warningLabel;
    UIView *_payingView;
    UIView *_payFailureView;
    UIButton *_bugTicketBtn;
    UIButton *_orderManageBtn;
    UIButton *_refreshOrderStatus;
}
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

    self.kkzTitleLabel.text = @"订单状态";
    

    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screentWith, screentContentHeight - 44)];
    [holder setBackgroundColor:[UIColor r:245 g:245 b:245]];
    holder.delegate = self;
    holder.showsVerticalScrollIndicator = NO;
    [self.view addSubview:holder];

    UIImageView *headview = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"OrderDetial_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(40, 30, 30, 30) resizingMode:UIImageResizingModeTile]];
    headview.userInteractionEnabled = true;
    [holder addSubview:headview];
    [headview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.width.equalTo(holder).offset(-26);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(265);
    }];

//    CGFloat positionYH = 20;

    UIImage *imgStatusIcon = [UIImage imageNamed:@"OrderLoading"];
    imgStatusIconV = [[UIImageView alloc] initWithImage:imgStatusIcon];
    [headview addSubview:imgStatusIconV];
    [imgStatusIconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headview);
        make.top.mas_equalTo(26);
    }];

//    positionYH += 63;

    orderStateLabel = [[UILabel alloc] init];
    orderStateLabel.text = @"付款确认中,请稍后...";
    orderStateLabel.textColor = appDelegate.kkzPink;
    orderStateLabel.textAlignment = NSTextAlignmentCenter;
    orderStateLabel.font = [UIFont systemFontOfSize:18];
    [headview addSubview:orderStateLabel];
    [orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headview);
        make.top.equalTo(imgStatusIconV.mas_bottom).offset(20);
    }];

//    positionYH += 26;

    _warningLabel = [[UILabel alloc] init];
    _warningLabel.textAlignment = NSTextAlignmentCenter;
    _warningLabel.font = [UIFont systemFontOfSize:14];
    _warningLabel.textColor = appDelegate.kkzGray;
    _warningLabel.text = @"如果等待时间过长，请尝试刷新一下哦~";
    [headview addSubview:_warningLabel];
    [_warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headview);
        make.top.equalTo(orderStateLabel.mas_bottom).offset(15);
    }];

    _refreshOrderStatus = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refreshOrderStatus setBackgroundImage:[UIImage imageNamed:@"OrderPay_Button"] forState:UIControlStateNormal];
    [_refreshOrderStatus setTitle:@"刷新订单状态" forState:UIControlStateNormal];
    [_refreshOrderStatus setTitleColor:appDelegate.kkzPink forState:UIControlStateNormal];
    _refreshOrderStatus.titleLabel.font = [UIFont systemFontOfSize:18];
    [_refreshOrderStatus addTarget:self action:@selector(refreshOrderStatus) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:_refreshOrderStatus];
    [_refreshOrderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headview);
        make.bottom.mas_equalTo(-28);
        make.size.mas_equalTo(CGSizeMake(154, 52));
    }];
    
    //  订单失败 按钮     默认隐藏 ，失败后显示
    _bugTicketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bugTicketBtn.hidden = true;
    [_bugTicketBtn setBackgroundImage:[UIImage imageNamed:@"Login_ValidCode@2x"] forState:UIControlStateNormal];
    [_bugTicketBtn setTitle:@"重新购票" forState:UIControlStateNormal];
    [_bugTicketBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _bugTicketBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_bugTicketBtn addTarget:self action:@selector(backToPlanViewController) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:_bugTicketBtn];
    [_bugTicketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.bottom.mas_equalTo(-28);
        make.size.mas_equalTo(CGSizeMake(100, 52));
    }];
    
    _orderManageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _orderManageBtn.hidden = true;
    [_orderManageBtn setBackgroundImage:[UIImage imageNamed:@"OrderPay_Button"] forState:UIControlStateNormal];
    [_orderManageBtn setTitle:@"管理订单" forState:UIControlStateNormal];
    [_orderManageBtn setTitleColor:appDelegate.kkzPink forState:UIControlStateNormal];
    _orderManageBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_orderManageBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:_orderManageBtn];
    [_orderManageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.bottom.mas_equalTo(-28);
        make.size.mas_equalTo(CGSizeMake(100, 52));
    }];

    [self preparePayingView:headview];
    [self preparePayFailureView:headview];
    
    //  客服电话
    UILabel *mobileLabel = [[UILabel alloc] init];
    mobileLabel.text = @"客服电话 400-030-1053";
    mobileLabel.textColor = appDelegate.kkzPink;
    mobileLabel.font = [UIFont systemFontOfSize:14];
    [holder addSubview:mobileLabel];
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(holder);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    UILabel *workTimeLabel = [[UILabel alloc] init];
    workTimeLabel.text = @"工作时间： 早9:00-晚22:00";
    workTimeLabel.textColor = appDelegate.kkzGray;
    workTimeLabel.font = [UIFont systemFontOfSize:12];
    [holder addSubview:workTimeLabel];
    [workTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(holder);
        make.top.equalTo(mobileLabel.mas_bottom).offset(5);
    }];

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

#pragma mark - Prepare

- (void)preparePayingView:(UIView *)headview {
    _payingView = [[UIView alloc] init];
    [_payingView setBackgroundColor:[UIColor clearColor]];
    [holder addSubview:_payingView];
    [_payingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(headview.mas_bottom).offset(30);
        make.height.mas_equalTo(200);
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screentWith - 60, 20)];
    titleLab.textColor = [UIColor grayColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.text = @"订票小窍门";
    [_payingView addSubview:titleLab];
    
    UILabel *introLab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, screentWith - 60, 40)];
    introLab1.textColor = [UIColor grayColor];
    introLab1.font = [UIFont systemFontOfSize:14];
    introLab1.numberOfLines = 0;
    introLab1.text = @"1.有的影院会安排多天的放映计划，只要有放映计划的影院都可以提前购票；";
    [_payingView addSubview:introLab1];
    
    UILabel *introLab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 25 + 40, screentWith - 60, 40)];
    introLab2.textColor = [UIColor grayColor];
    introLab2.font = [UIFont systemFontOfSize:14];
    introLab2.numberOfLines = 0;
    introLab2.text = @"2.为了避免错过开场，尽量提前半小时到影院换取电影票；";
    [_payingView addSubview:introLab2];
}

- (void)preparePayFailureView:(UIView *)headview {
    _payFailureView = [[UIView alloc] init];
    _payFailureView.hidden = true;
    [_payFailureView setBackgroundColor:[UIColor clearColor]];
    [holder addSubview:_payFailureView];
    [_payFailureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(headview.mas_bottom).offset(30);
        make.height.mas_equalTo(200);
    }];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screentWith, 20)];
    titleLab.textColor = [UIColor grayColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.text = @"为什么会出现购票失败？";
    [_payFailureView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
    }];
    
    UILabel *introLab1 = [[UILabel alloc] init];
    introLab1.textColor = [UIColor grayColor];
    introLab1.font = [UIFont systemFontOfSize:14];
    introLab1.numberOfLines = 0;
    introLab1.text = @"1.可能因为您预订的座位与影院系统处理失败;";
    [_payFailureView addSubview:introLab1];
    [introLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab);
        make.right.lessThanOrEqualTo(_payFailureView).offset(-15);
        make.top.equalTo(titleLab.mas_bottom).offset(2);
    }];
    
    UILabel *introLab2 = [[UILabel alloc] init];
    introLab2.textColor = [UIColor grayColor];
    introLab2.font = [UIFont systemFontOfSize:14];
    introLab2.numberOfLines = 0;
    introLab2.text = @"2.您购买的座位未能在有效时间完成支付或支付方未能及时返回支付状态导致订单被自动取消;";
    [_payFailureView addSubview:introLab2];
    [introLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab);
        make.right.lessThanOrEqualTo(_payFailureView).offset(-15);
        make.top.equalTo(introLab1.mas_bottom).offset(2);
    }];
    
    UILabel *introLab3 = [[UILabel alloc] init];
    introLab3.textColor = [UIColor grayColor];
    introLab3.font = [UIFont systemFontOfSize:14];
    introLab3.numberOfLines = 0;
    introLab3.text = @"3.尽可能地提前购票或错过购票高峰时间购票";
    [_payFailureView addSubview:introLab3];
    [introLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLab);
        make.right.lessThanOrEqualTo(_payFailureView).offset(-15);
        make.top.equalTo(introLab2.mas_bottom).offset(2);
    }];
}

#pragma mark - Animation

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
    _angle ++;

    CGAffineTransform trans = CGAffineTransformRotate(imgStatusIconV.transform, M_PI * _angle);//CGAffineTransformMakeTranslation(ANIMATION_ICON_WIDTH + ANIMATION_ICON_BARGIN, 0);
    [UIView animateWithDuration:2.0
            animations:^{
                imgStatusIconV.transform = trans;
            }
            completion:^(BOOL finished) {
                imgStatusIconV.transform = CGAffineTransformIdentity;
                isAnimating = NO;
            }];
}

#pragma mark - UIButton - Action

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
    WeakSelf
    OrderRequest *request = [OrderRequest new];
    [request requestOrderDetail:self.orderNo
            success:^(Order *_Nullable order) {
                
                weakSelf.order = order;
                if (weakSelf.order.orderStatus.intValue == 1 || self.order.orderStatus.intValue == 3) { //需要再次轮询
                    orderStateLabel.text = @"支付成功，待出票";
                }
                else {
                    [orderDetailTimer invalidate];
                    orderDetailTimer = nil;
                    [weakSelf updateLayout];
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

- (void)buttonClick {
    [self popToViewControllerAnimated:true];
    [appDelegate setSelectedPage:2 tabBar:true];
}

//点击完成返回首页
- (void)backtoHomepage {
    [self popToViewControllerAnimated:YES];
    [appDelegate setSelectedPage:0 tabBar:YES];
}

- (void)backToPlanViewController {
    for (int i = 0; i < self.navigationController.viewControllers.count; i ++) {
        UIViewController *vc = self.navigationController.viewControllers[i];
        if ([vc isKindOfClass:[CinemaTicketViewController class]]) {
            [self.navigationController popToViewController:vc animated:true];
            break;
        }
    }
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
        
        ZYOrderDetailViewController *vc = [[ZYOrderDetailViewController alloc] init];
        vc.currentOrder = self.order;
        vc.comefromPay = true;
        [self.navigationController pushViewController:vc animated:true];

//    } else if (self.order.orderStatus.intValue == 5 || self.order.orderStatus.intValue == 9 || self.order.orderStatus.intValue == 10) {
        
    } else if (self.order.orderStatus.intValue != 1 && self.order.orderStatus.intValue != 3) {
        
        //购票失败
//        PayOrderFailController *dd = [[PayOrderFailController alloc] initWithOrder:self.orderNo];
//        dd.order = self.order;
//        [self pushViewController:dd animation:CommonSwitchAnimationSwipeR2L];
        [orderDetailTimer invalidate];
        orderDetailTimer = nil;
        [animationTimer invalidate];
        animationTimer = nil;
        
        _payFailureView.hidden = false;
        _payingView.hidden = true;
        orderStateLabel.text = @"购票失败";
        _warningLabel.text = @"如果您已经完成支付，您的款项将会按原支付方式退回\n此过程需要1-5个工作日，请您耐心等候";
        _bugTicketBtn.hidden = false;
        _orderManageBtn.hidden = false;
        imgStatusIconV.image = [UIImage imageNamed:@"OrderPay_Failure"];
        _refreshOrderStatus.hidden = true;
    }
}

- (void)refreshOrderDetail {
    WeakSelf
    OrderRequest *request = [OrderRequest new];
    [request requestOrderDetail:self.orderNo
            success:^(Order *_Nullable order) {
                [appDelegate hideIndicator];
                weakSelf.order = order;
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
