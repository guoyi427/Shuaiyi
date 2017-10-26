//
//  购票失败页面
//
//  Created by KKZ on 15/9/9.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "PayOrderFailController.h"

@interface PayOrderFailController ()

@end

@implementation PayOrderFailController

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
    self.view.backgroundColor = [UIColor r:151 g:151 b:151];
    self.kkzTitleLabel.text = @"订单状态";

    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];

    [holder setBackgroundColor:[UIColor r:245 g:245 b:245]];

    [self.view addSubview:holder];

    holder.delegate = self;
    holder.alpha = 1;
    holder.showsVerticalScrollIndicator = NO;

    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 210)];
    headview.backgroundColor = [UIColor whiteColor];
    headview.userInteractionEnabled = YES;
    [holder addSubview:headview];

    CGFloat positionYH = 20;

    UIImage *imgStatusIcon = [UIImage imageNamed:@"payFailIcon"];
    UIImageView *imgStatusIconV = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - 53) * 0.5, positionYH, 53, 53)];
    imgStatusIconV.image = imgStatusIcon;
    [headview addSubview:imgStatusIconV];

    positionYH += 55;

    UILabel *orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, positionYH, screentWith, 20)];
    orderStateLabel.text = @"购票失败";
    orderStateLabel.textColor = [UIColor blackColor];
    orderStateLabel.textAlignment = NSTextAlignmentCenter;
    orderStateLabel.font = [UIFont systemFontOfSize:16];
    [headview addSubview:orderStateLabel];

    positionYH += 20;

    UILabel *warningText = [[UILabel alloc] initWithFrame:CGRectMake(0, positionYH + 5, screentWith, 40)];
    warningText.textAlignment = NSTextAlignmentCenter;
    warningText.font = [UIFont systemFontOfSize:13];
    warningText.numberOfLines = 0;
    warningText.textColor = [UIColor grayColor];
    warningText.text = @"如果您已经完成支付，您的款项将会按原支付方式退回\n此过程需要1-5个工作日，请您耐心等候";
    [holder addSubview:warningText];

    positionYH += 50;
    UIView *orderDetail = [[UIView alloc] initWithFrame:CGRectMake(0, positionYH, screentWith, 50)];
    [headview addSubview:orderDetail];

    UIButton *bugTicketBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 120, 40)];
    [bugTicketBtn setImage:[UIImage imageNamed:@"bugAgainBtnIcon"] forState:UIControlStateNormal];
    [bugTicketBtn addTarget:self action:@selector(backtoHomepage) forControlEvents:UIControlEventTouchUpInside];
    [orderDetail addSubview:bugTicketBtn];

    UIButton *orderManageBtn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - 136 - 15, 10, 136, 40)];
    [orderManageBtn setImage:[UIImage imageNamed:@"orderManageBtnImg"] forState:UIControlStateNormal];
    [orderManageBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [orderDetail addSubview:orderManageBtn];

    UIImage *imgTicketBottom = [UIImage imageNamed:@"ticketPageBottom"];
    UIImageView *imgTicketBottomV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headview.frame) - 20, screentWith, 30)];
    imgTicketBottomV.image = imgTicketBottom;
    [holder insertSubview:imgTicketBottomV belowSubview:headview];

    UIView *introText = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headview.frame) + 30, screentWith, 80)];
    [introText setBackgroundColor:[UIColor clearColor]];
    [holder addSubview:introText];

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, screentWith, 20)];
    titleLab.textColor = [UIColor grayColor];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.text = @"为什么会出现购票失败？";
    [introText addSubview:titleLab];

    UILabel *introLab1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, screentWith - 15 * 2, 20)];
    introLab1.textColor = [UIColor grayColor];
    introLab1.font = [UIFont systemFontOfSize:14];
    introLab1.numberOfLines = 0;
    introLab1.text = @"1.可能因为您预订的座位与影院系统处理失败;";
    CGSize s1 = [introLab1.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(screentWith - 15 * 2, MAXFLOAT)];
    introLab1.frame = CGRectMake(15, CGRectGetMaxY(titleLab.frame) + 10, screentWith - 15 * 2, s1.height + 5);
    [introText addSubview:introLab1];

    UILabel *introLab2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 25 + 20, screentWith - 15 * 2, 20)];
    introLab2.textColor = [UIColor grayColor];
    introLab2.font = [UIFont systemFontOfSize:14];
    introLab2.numberOfLines = 0;
    introLab2.text = @"2.您购买的座位未能在有效时间完成支付或支付方未能及时返回支付状态导致订单被自动取消;";
    CGSize s2 = [introLab2.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(screentWith - 15 * 2, MAXFLOAT)];
    introLab2.frame = CGRectMake(15, 5 + CGRectGetMaxY(introLab1.frame), screentWith - 15 * 2, s2.height + 5);
    [introText addSubview:introLab2];

    UILabel *introLab3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 25 + 20 * 2, screentWith - 15 * 2, 20)];
    introLab3.textColor = [UIColor grayColor];
    introLab3.font = [UIFont systemFontOfSize:14];
    introLab3.numberOfLines = 0;
    introLab3.text = @"3.尽可能地提前购票或错过购票高峰时间购票";
    CGSize s3 = [introLab1.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(screentWith - 15 * 2, MAXFLOAT)];
    introLab3.frame = CGRectMake(15, 5 + CGRectGetMaxY(introLab2.frame), screentWith - 15 * 2, s3.height + 5);
    [introText addSubview:introLab3];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self setStatusBarLightStyle];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [KKZAnalytics postActionWithEvent:[[KKZAnalyticsEvent alloc] initWithOrder:self.order] action:AnalyticsActionPay_fail];
}

#pragma mark utilities
- (void)buttonClick {
    OrderDetailViewController *odv = [[OrderDetailViewController alloc] initWithOrder:self.orderNo];
    odv.isGotoOne = NO;
    odv.myOrder = self.order;
    [self pushViewController:odv animation:CommonSwitchAnimationBounce];
}

//点击完成返回首页
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
