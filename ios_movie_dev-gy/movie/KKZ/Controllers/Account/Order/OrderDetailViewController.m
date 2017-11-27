//
//  OrderDetailViewController.m
//  KKZ
//
//  Created by  on 11-7-28.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "Cinema.h"
#import "CinemaLocationViewController.h"
#import "Coupon.h"
#import "Cryptor.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "ImageEngine.h"
#import "ImageEngineNew.h"
#import "Movie.h"
#import "OrderDetailViewController.h"
#import "OrderTask.h"
#import "PassbookTask.h"
#import "PayViewController.h"
#import "ShareView.h"
#import "TaskQueue.h"
#import "TaskQueue.h"
#import "Ticket.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"
#import "UIConstants.h"
#import "UIViewControllerExtra.h"
#import <PassKit/PassKit.h>
#import "OrderRequest.h"
#import "CinemaDetail.h"

#define kMarginX 15
#define kFont 14
#define TitleCellWith 85
#define kUIColorGray [UIColor r:150 g:150 b:150]

@interface OrderDetailViewController () <PKAddPassesViewControllerDelegate>
- (void)updateLayout;
@end

@implementation OrderDetailViewController

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    self = [super init];
    if (self) {
        if (extra1) {
            self.orderNo = extra1;
        }
        self.isGotoOne = YES;
    }
    return self;
}

- (id)initWithOrder:(NSString *)orderNo {
    self = [super init];
    if (self) {
        self.orderNo = orderNo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = self.kkzBackBtn.frame;//CGRectMake(0, 3, 60, 38);
    [backBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backBtn];

    //右边分享按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(screentWith - 60, 4, 60, 38);
    [rightBtn setImage:[UIImage imageNamed:@"cinema_Ticket_share"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"cinema_Ticket_share"] forState:UIControlStateHighlighted];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake((38 - 20) / 2, 20, (38 - 20) / 2, 20)];
    [rightBtn addTarget:self action:@selector(shareOrderMsg) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:rightBtn]; // sendMessage

    if (!THIRD_LOGIN) {
        rightBtn.hidden = YES;
    } else {
        rightBtn.hidden = NO;
    }

    self.kkzTitleLabel.text = @"订单管理";

    holder = [[UIScrollView alloc]
            initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];

    [holder setBackgroundColor:[UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0]];

    [self.view addSubview:holder];
    holder.delegate = self;
    holder.alpha = 0;
    holder.showsVerticalScrollIndicator = NO;

    imgVYN = [[UIImageView alloc] initWithFrame:CGRectMake(-1, -1, 1, 1)];
    [self.view addSubview:imgVYN];

    refreshHeaderView = [[EGORefreshTableHeaderView alloc]
            initWithFrame:CGRectMake(0.0f, 0.0f - holder.bounds.size.height, screentWith, holder.bounds.size.height)];
    [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];
    [refreshHeaderView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [holder addSubview:refreshHeaderView];

    CinemaDetail *cinema = self.myOrder.plan.cinema;
    CGFloat positionY = 15;

    orderNoSuccessLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screentWith - 15 * 2, 60)];
    orderNoSuccessLabel.backgroundColor = [UIColor clearColor];
    orderNoSuccessLabel.textColor = [UIColor r:100 g:100 b:100];
    orderNoSuccessLabel.font = [UIFont systemFontOfSize:13];
    orderNoSuccessLabel.numberOfLines = 3;
    orderNoSuccessLabel.hidden = YES;
    orderNoSuccessLabel.textAlignment = NSTextAlignmentCenter;
    [holder addSubview:orderNoSuccessLabel];

    timeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake((screentWith - 63 - 10 - 40) * 0.5, 75, 63, 20)];
    timeTipLabel.font = [UIFont systemFontOfSize:13];
    timeTipLabel.hidden = YES;
    timeTipLabel.textAlignment = NSTextAlignmentLeft;
    timeTipLabel.textColor = [UIColor r:255 g:105 b:0];
    timeTipLabel.backgroundColor = [UIColor clearColor];
    [holder addSubview:timeTipLabel];

    timeCountdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeTipLabel.frame), 75, 40, 20)];
    timeCountdownLabel.font = [UIFont systemFontOfSize:15];
    timeCountdownLabel.hidden = YES;
    timeCountdownLabel.textAlignment = NSTextAlignmentLeft;
    timeCountdownLabel.textColor = appDelegate.kkzBlue;
    timeCountdownLabel.backgroundColor = [UIColor clearColor];
    [holder addSubview:timeCountdownLabel];

    ////////
    orderCodeLabel = [[UITextView alloc] initWithFrame:CGRectMake(20, positionY, screentWith - 20 * 2, kFont)];
    orderCodeLabel.font = [UIFont systemFontOfSize:kFont];
    orderCodeLabel.textColor = appDelegate.kkzTextColor;
    orderCodeLabel.backgroundColor = [UIColor clearColor];
    orderCodeLabel.editable = NO;
    orderCodeLabel.hidden = YES;
    orderCodeLabel.scrollEnabled = YES;

    [holder addSubview:orderCodeLabel];

    codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, positionY, 200, 160)];
    [codeImageView loadImageWithURL:self.myOrder.qrCodePath andSize:ImageSizeMiddle];
    codeImageView.contentMode = UIViewContentModeScaleAspectFit;
    codeImageView.userInteractionEnabled = YES;
    codeImageView.hidden = YES;
    [holder addSubview:codeImageView];

    UITapGestureRecognizer *tap =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(longPressImage)];

    [codeImageView addGestureRecognizer:tap];

    positionY += 160;

    sendMessageBtn = [[UIView alloc] initWithFrame:CGRectMake(0, positionY, screentWith, 50)];
    [sendMessageBtn
            setBackgroundColor:[UIColor colorWithRed:211 / 255.0 green:211 / 255.0 blue:211 / 255.0 alpha:1.0]];
    sendMessageBtn.hidden = YES;
    [holder addSubview:sendMessageBtn];

    RoundCornersButton *btn = [[RoundCornersButton alloc]
            initWithFrame:CGRectMake(screentWith * 0.5 * 0.5, 6, screentWith * 0.5, 38)];
    btn.rimWidth = 0.1;
    btn.rimColor = [UIColor r:180 g:180 b:180];
    btn.cornerNum = 4;
    btn.titleName = @"发送至手机";
    btn.titleColor = kUIColorGray;
    btn.titleFont = [UIFont systemFontOfSize:kTextSizeButtonLarge];
    btn.fillColor = [UIColor whiteColor];

    //            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(72, 5 , 176, 40)];
    //            [btn setImage:[UIImage imageNamed:@"resend"] forState:UIControlStateNormal];
    [sendMessageBtn addSubview:btn];
    [btn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    ////////

    //            UIButton *passBookBtn = [[UIButton alloc] initWithFrame:CGRectMake(marginX * 2 + 100 , 5, 120,
    //            40)];
    //            [passBookBtn setImage:[UIImage imageNamed:@"passbook"] forState:UIControlStateNormal];
    //            [passBookBtn addTarget:self action:@selector(getPassBook:)
    //            forControlEvents:UIControlEventTouchUpInside];
    //            [sendMessageBtn addSubview:passBookBtn];

    noPayView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, screentWith, 50)];
    [noPayView setBackgroundColor:[UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1.0]];
    [holder addSubview:noPayView];
    UIButton *paybtn = [[UIButton alloc] initWithFrame:CGRectMake((screentWith - 176) * 0.5, 10, 176, 30)];
    [paybtn setTitle:@"立即支付" forState:UIControlStateNormal];
    paybtn.titleLabel.textColor = [UIColor whiteColor];
    paybtn.titleLabel.font = [UIFont systemFontOfSize:15];
    paybtn.layer.cornerRadius = 4;
    paybtn.backgroundColor = [UIColor r:255 g:105 b:0];
    [noPayView addSubview:paybtn];
    [paybtn addTarget:self action:@selector(gotoPayView) forControlEvents:UIControlEventTouchUpInside];

    positionY += 170;

    holderBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, positionY, screentWith, 45 * 9 + 7 + 70)];
    holderBgView.userInteractionEnabled = YES;
    [holder addSubview:holderBgView];

    float positionInHolder = 0;

    orderNoLabel = [self setOrderListView:positionInHolder andListTitle:@"订单号" andListValueP:self.orderNo];

    positionInHolder += 46;

    movieNameLabel = [self setOrderListView:positionInHolder andListTitle:@"电影" andListValueP:self.myOrder.plan.movie.movieName];

    positionInHolder += 46;

    cinemaNameLabel = [self setOrderListView:positionInHolder andListTitle:@"影院" andListValueP:cinema.cinemaName];

    positionInHolder += 46;

    startTimeLabel =
            [self setOrderListView:positionInHolder
                        andListTitle:@"场次"
                       andListValueP:[self.myOrder movieTimeDesc]];

    positionInHolder += 46;

    seatInfoLabel =
            [self setOrderListView:positionInHolder
                        andListTitle:@"座位"
                       andListValueP:[self.myOrder readableSeatInfos]];

    positionInHolder += 46;

    totalMoneyLabel =
            [self setOrderListView:positionInHolder
                        andListTitle:@"合计"
                       andListValueP:[NSString stringWithFormat:@"%.2f元", [self.myOrder moneyToPay]]]; // totalMoney

    positionInHolder += 46;

    disccountLabel = [self setOrderListView:positionInHolder andListTitle:@"优惠抵扣" andListValueP:@"0"];

    positionInHolder += 46;

    payLabel = [self setOrderListView:positionInHolder andListTitle:@"支付金额" andListValueP:@"0"];

    positionInHolder += 46;

    if ([self.myOrder mobile].length) {
        mobileLabel.hidden = NO;
        mobileLabel = [self setOrderListView:positionInHolder andListTitle:@"手机" andListValueP:[self.myOrder mobile]];
    } else {
        mobileLabel.hidden = YES;
    }

    positionInHolder += 46;

    callCS = [[RoundCornersButton alloc]
            initWithFrame:CGRectMake(22.5, positionInHolder + 20, screentWith - 45, kDimensButtonHeightLarge)];
    callCS.cornerNum = kDimensCornerNum;
    callCS.rimColor = [UIColor r:180 g:180 b:180];
    callCS.rimWidth = 0.5;
    callCS.fillColor = [UIColor whiteColor];
    callCS.titleName = @"联系客服";
    callCS.titleColor = kUIColorGray;
    callCS.titleFont = [UIFont systemFontOfSize:kTextSizeButtonLarge];
    [callCS addTarget:self action:@selector(callCs) forControlEvents:UIControlEventTouchUpInside];
    [holderBgView addSubview:callCS];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self refreshOrderDetail];
    [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionTicket_order_details];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Override from CommonViewController
- (void)cancelViewController {
    if (self.isGotoOne) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderListY" object:nil];
        [self popViewControllerAnimated:YES];
    } else {
        [self popToViewControllerAnimated:NO];
        [appDelegate setSelectedPage:2 tabBar:YES];
    }
}

#pragma mark utilities
- (void)gotoPayView {
    PayViewController *ctr = [[PayViewController alloc] initWithOrder:self.myOrder.orderId];
    ctr.myOrder = self.myOrder;
    [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
}

- (void)refreshOrderDetail {

    OrderRequest *request = [OrderRequest new];
    [request requestOrderDetail:self.orderNo
            success:^(Order *_Nullable order) {

                [appDelegate hideIndicator];

                self.myOrder = order;
                [self updateLayout];

                [UIView animateWithDuration:.3
                                 animations:^{
                                     holder.alpha = 1;
                                 }];
                if ([self.myOrder.orderStatus intValue] == OrderStatePaid) {
                    self.myOrder.orderStatus = @(3);
                    orderCodeLabel.text = @"您已成功支付，请耐心等待后台处理您的订单,稍后刷新查看~";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderStates" object:nil];
                } else if ([self.myOrder.orderStatus intValue] == OrderStateBuyFailed) {
                    orderCodeLabel.text = @"对"
                                          @"不起，订单处理失败，可能是由于影院本地网络问题。您的款项将退回余额账户，烦请再次下"
                                          @"单试试~";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderStates" object:nil];
                } else if ([self.myOrder.orderStatus intValue] == OrderStateCanceled) {
                    orderCodeLabel.text = @"已成功取消订单";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderStates" object:nil];
                } else if ([self.myOrder.orderStatus intValue] == OrderStateRefund) {
                    orderCodeLabel.text = @"已退款";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderStates" object:nil];
                } else if ([self.myOrder.orderStatus intValue] == OrderStateTimeout) {
                    orderCodeLabel.text = @"支付超时，订单失败";
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOrderStates" object:nil];
                }

            }
            failure:^(NSError *_Nullable err) {
                [appDelegate showAlertViewForTitle:nil message:err.userInfo[KKZRequestErrorMessageKey] cancelButton:@"确定"];
            }];
}

- (void)callCs {
    [UIAlertView showAlertView:@"拨打章鱼电影免费客服热线吗？"
                    cancelText:@"取消"
                  cancelTapped:nil
                        okText:@"呼叫"
                      okTapped:^{

                          [appDelegate makePhoneCallWithTel:kHotLine];
                      }];

    //    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    //    cancel.action = ^{
    //
    //    };
    //    RIButtonItem *call = [RIButtonItem itemWithLabel:@"呼叫"];
    //    call.action = ^{
    //        [appDelegate makePhoneCallWithTel:kHotLine];
    //    };
    //
    //    UIAlertView *alertAt = [[UIAlertView alloc] initWithTitle:@""
    //                                                      message:@"拨打抠电影免费客服热线吗?"
    //                                             cancelButtonItem:cancel
    //                                             otherButtonItems:call, nil];
    //    [alertAt show];
}

- (void)beforeActivityMethod:(NSTimer *)time {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *expireDate2 =
            [[[DateEngine sharedDateEngine] dateFromString:self.myOrder.orderTime] dateByAddingTimeInterval:15 * 60];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |
                             NSCalendarUnitMinute | NSCalendarUnitSecond;

    NSDateComponents *d =
            [calendar components:unitFlags
                        fromDate:[NSDate date]
                          toDate:expireDate2
                         options:0]; //计算时间差

    if ([d second] < 0) {
        timeCountdownLabel.text = @"";
        timeTipLabel.text = @"支付过期";
        [timeCountdownLabel setNeedsDisplay];
        self.myOrder.orderStatus = @(2);
        [self updateLayout];
        [timer invalidate];
        timer = nil;
    } else {
        //倒计时显示
        timeTipLabel.text = @"剩余时间:";
        if ([d minute] < 10 && [d second] >= 10) {
            timeCountdownLabel.text = [NSString stringWithFormat:@"0%ld:%ld", (long) [d minute], (long) [d second]];

        } else if ([d second] < 10 && [d minute] >= 10) {
            timeCountdownLabel.text = [NSString stringWithFormat:@"%ld:0%ld", (long) [d minute], (long) [d second]];

        } else if ([d minute] < 10 && [d second] < 10) {
            timeCountdownLabel.text = [NSString stringWithFormat:@"0%ld:0%ld", (long) [d minute], (long) [d second]];

        } else {
            timeCountdownLabel.text = [NSString stringWithFormat:@"%ld:%ld", (long) [d minute], (long) [d second]];
        }
        [timeCountdownLabel setNeedsDisplay];
    }
}

- (void)updateLayout {

    CinemaDetail *cinema = self.myOrder.plan.cinema;

    orderNoSuccessLabel.hidden = NO;
    noPayView.hidden = YES;

    orderCodeLabel.hidden = YES;
    codeImageView.hidden = YES;
    sendMessageBtn.hidden = YES;
    holderBgView.frame = CGRectMake(0, 150, screentWith, 45 * 7 + 7 + 200);
    timeCountdownLabel.hidden = YES;
    timeTipLabel.hidden = YES;
    disccountLabel.superview.hidden = NO;
    payLabel.superview.hidden = NO;

    NSDate *lateDate = [NSDate date];
    NSDate *expireDate2 =
            [[[DateEngine sharedDateEngine] dateFromString:self.myOrder.orderTime] dateByAddingTimeInterval:15 * 60];
    NSComparisonResult result = [lateDate compare:expireDate2];

    if (self.myOrder.orderStatus.intValue == 1 && result == NSOrderedAscending) {
        [timer invalidate];
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(beforeActivityMethod:)
                                               userInfo:nil
                                                repeats:YES];
        timeTipLabel.hidden = NO;
        timeCountdownLabel.hidden = NO;
        noPayView.hidden = NO;

        orderNoSuccessLabel.text = @"请您尽快完成付款，超时订单将自动关闭并释放您锁定的座位，如果您已完成支付，请耐心等待付款结果。";
    } else if (self.myOrder.orderStatus.intValue == 1 && result != NSOrderedAscending) {
        orderNoSuccessLabel.text = @"订单已取消";
        holderBgView.frame = CGRectMake(0, 80, screentWith, 45 * 7 + 7);
    } else if (self.myOrder.orderStatus.intValue == 2) {
        orderNoSuccessLabel.text = @"订单已取消";
        holderBgView.frame = CGRectMake(0, 80, screentWith, 45 * 7 + 7);

    } else if (self.myOrder.orderStatus.intValue == 3) {
        orderNoSuccessLabel.text = @"您已经支付成功，请耐心等待后台处理您的订单，请您稍后下拉刷新查看结果";
        holderBgView.frame = CGRectMake(0, 80, screentWith, 45 * 7 + 7);
    } else if (self.myOrder.orderStatus.intValue == 4) {
        orderNoSuccessLabel.text = @"";
        orderNoSuccessLabel.hidden = YES;
        noPayView.hidden = YES;
        orderCodeLabel.hidden = NO;
        codeImageView.hidden = NO;
        sendMessageBtn.hidden = NO;

        CGFloat positionX = 20;
        CGFloat codeLabelWidth = screentWith - 20 - 20;
        [holder setContentSize:CGSizeMake(screentWith, screentHeight + 200)];

        if (cinema.ticketType) {

            codeImageView.frame = CGRectMake(15, 12.5, 100, 100);
            NSString *url = self.myOrder.qrCodePath;
            [codeImageView loadImageWithURL:url andSize:ImageSizeMiddle];
            codeImageView.hidden = NO;
            positionX = 126;

            codeLabelWidth = screentWith - 126 - 20;

        } else {
            codeImageView.hidden = YES;
            positionX = 20;

            codeLabelWidth = screentWith - 20 - 20;
        }
        orderCodeLabel.text =
                [NSString stringWithFormat:@"%@", self.myOrder.orderMessage]; // orderMsg   language  mobile

        CGSize codeSize = [self.myOrder.orderMessage sizeWithFont:[UIFont systemFontOfSize:kFont]
                                                constrainedToSize:CGSizeMake(codeLabelWidth, MAXFLOAT)
                                                    lineBreakMode:NSLineBreakByTruncatingTail];
        CGRect messageframe = orderCodeLabel.frame;
        messageframe.origin.y = 10;
        messageframe.origin.x = positionX;
        messageframe.size.width = screentWith - positionX;
        messageframe.size.height = codeSize.height + 12.5;
        orderCodeLabel.frame = messageframe;

        CGRect sendMessageFrame = sendMessageBtn.frame;
        sendMessageFrame.origin.y = CGRectGetMaxY(codeImageView.frame) + 12.5 > CGRectGetMaxY(orderCodeLabel.frame)
                                            ? CGRectGetMaxY(codeImageView.frame) + 12.5
                                            : CGRectGetMaxY(orderCodeLabel.frame);
        sendMessageBtn.frame = sendMessageFrame;

        CGRect holderBgViewFrame = holderBgView.frame;
        holderBgViewFrame.origin.y = CGRectGetMaxY(sendMessageBtn.frame);
        holderBgView.frame = holderBgViewFrame;

    } else if (self.myOrder.orderStatus.intValue == 5) {
        orderNoSuccessLabel.text = @"对不起，订单处理失败，可能是由于影院本地网络问题。您的款项将退回余额账户，烦请再次下单试试~";
        holderBgView.frame = CGRectMake(0, 80, screentWith, 45 * 7 + 7);
    }

    else if (self.myOrder.orderStatus.intValue == 9) {
        orderNoSuccessLabel.text = @"感谢您的使用，可能是由于影院本地网络问题，出票失败。您的款项将退回余额账户，烦请再次下单试试~";
        holderBgView.frame = CGRectMake(0, 80, screentWith, 45 * 7 + 7);

    } else if (self.myOrder.orderStatus.intValue == 10) {
        orderNoSuccessLabel.text = @"支付超时，订单失败";
        holderBgView.frame = CGRectMake(0, 80, screentWith, 45 * 7 + 7);
    }

    int Y = 0;
    if (([self.myOrder moneyToPay] - self.myOrder.agio.floatValue) <= 0) {
        disccountLabel.superview.hidden = YES;
        Y += 46;

        if (self.myOrder.agio.floatValue <= 0) {
            Y += 46;
            payLabel.superview.hidden = YES;

            CGRect phoneVFrame = mobileLabel.superview.frame;
            phoneVFrame.origin.y = 8 * 46 - Y;
            mobileLabel.superview.frame = phoneVFrame;
        } else {
            CGRect payViewFrame = payLabel.superview.frame;
            payViewFrame.origin.y = 7 * 46 - Y;
            payLabel.superview.frame = payViewFrame;

            CGRect phoneVFrame = mobileLabel.superview.frame;
            phoneVFrame.origin.y = 8 * 46 - Y;
            mobileLabel.superview.frame = phoneVFrame;
        }
    } else {
        if (self.myOrder.agio.floatValue <= 0) {
            Y += 46;
            payLabel.superview.hidden = YES;

            CGRect phoneVFrame = mobileLabel.superview.frame;
            phoneVFrame.origin.y = 8 * 46 - Y;
            mobileLabel.superview.frame = phoneVFrame;
        }
    }
    CGRect callCSframe = callCS.frame;
    callCSframe.origin.y = 9 * 46 - Y + 20;
    callCS.frame = callCSframe;

    CGRect f = holderBgView.frame;
    f.size.height = CGRectGetMaxY(callCS.frame);
    holderBgView.frame = f;

    movieNameLabel.text = [NSString stringWithFormat:@"%@", self.myOrder.plan.movie.movieName ? self.myOrder.plan.movie.movieName : @""];

    cinemaNameLabel.text =
            [NSString stringWithFormat:@"%@", self.myOrder.plan.cinema.cinemaName ? self.myOrder.plan.cinema.cinemaName : @"无"];

    startTimeLabel.text =
            [NSString stringWithFormat:@"%@", [self.myOrder movieTimeDesc] ? [self.myOrder movieTimeDesc] : @""];

    seatInfoLabel.text = [NSString
            stringWithFormat:@"%@", [self.myOrder readableSeatInfos] ? [self.myOrder readableSeatInfos] : @""];

    totalMoneyLabel.text = [NSString stringWithFormat:@"%.2f元", [self.myOrder moneyToPay]];

    disccountLabel.text =
            [NSString stringWithFormat:@"-%.2f元", [self.myOrder moneyToPay] - [self.myOrder.agio floatValue]];

    payLabel.text = [NSString stringWithFormat:@"%.2f元", [self.myOrder.agio floatValue]];

    if (self.myOrder.mobile) {
        mobileLabel.hidden = NO;
        mobileLabel.text = [NSString stringWithFormat:@"%@", self.myOrder.mobile];
    } else {
        mobileLabel.hidden = YES;
    }

    float height = CGRectGetMinY(holderBgView.frame) + 50 + 9 * 46 - Y + 40;

    [holder setContentSize:CGSizeMake(screentWith, height > screentContentHeight ? height : screentContentHeight)];
}

- (void)locateCinema {

    CinemaLocationViewController *ctr = [[CinemaLocationViewController alloc] initWithCinema:self.myOrder.plan.cinema.cinemaId.stringValue];
    [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
}

- (void)shareOrderMsg {

    Movie *movieY = self.myOrder.plan.movie;

    ShareView *poplistview = [[ShareView alloc] initWithFrame:CGRectMake(0, screentHeight - 200, screentWith, 200)];
    poplistview.userShareInfo = @"orderDetail";
    //分享订单
    NSString *shareUrl = [NSString stringWithFormat:@"%@&type=%@&targetId=%@&userId=%@", kAppShareHTML5Url, @"10",
                                                    self.myOrder.orderId, [DataEngine sharedDataEngine].userId];

    NSString *content = [NSString
            stringWithFormat:@"我在#抠电影#买了《%@》,%@,%@,%@的电影票。查看详情：%@"
                             @"。更多精彩，尽在【抠电影客户端】。",
                             self.myOrder.plan.movie.movieName, self.myOrder.plan.cinema.cinemaName, self.myOrder.plan.hallName, [self.myOrder movieTimeDesc], shareUrl];
    NSString *contentQQSpace =
            [NSString stringWithFormat:@"我在#抠电影#买了《%@》,%@,%@,%@的电影票。", self.myOrder.plan.movie.movieName,
                                       self.myOrder.plan.cinema.cinemaName, self.myOrder.plan.hallName, [self.myOrder movieTimeDesc]];
    NSString *contentWeChat =
            [NSString stringWithFormat:@"我在#抠电影#买了《%@》,%@,%@,%@的电影票。", self.myOrder.plan.movie.movieName,
                                       self.myOrder.plan.cinema.cinemaName, self.myOrder.plan.hallName, [self.myOrder movieTimeDesc]];

    NSString *str;

    if (movieY.thumbPath.length) {
        str = movieY.thumbPath;
    } else {
        str = movieY.pathVerticalS;
    }

    imgYN = [UIImage imageNamed:@"Icon-120"];
    [imgVYN loadImageWithURL:str
                     andSize:ImageSizeSmall
                    finished:^{

                        //评分信息，影片海报，我的文字或者语音评论信息等以及抠电影的下载信息
                        [poplistview updateWithcontent:content
                                         contentWeChat:contentWeChat
                                        contentQQSpace:contentQQSpace
                                                 title:@"一起来观影" //"抠电影"
                                             imagePath:imgYN
                                              imageURL:str
                                                   url:shareUrl
                                              soundUrl:nil
                                              delegate:appDelegate
                                             mediaType:SSPublishContentMediaTypeNews
                                        statisticsType:StatisticsTypeOrder
                                             shareInfo:[movieY.movieId stringValue]
                                             sharedUid:[DataEngine sharedDataEngine].userId];

                        [poplistview show];
                    }];
}

- (void)sendMessage {

    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"
                                                action:^(){
                                                }];

    RIButtonItem *sms = [RIButtonItem
            itemWithLabel:@"确定"
                   action:^{
                       //                             action=order_Resend
                       //                             接口，参数：mobile（手机号）、order_id（订单号）
                       OrderTask *orderTask = [[OrderTask alloc]
                               initTicketOrderResend:self.myOrder.mobile
                                          andOrderId:self.orderNo
                                            finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                NSString *str = @"";
                                                if (succeeded) {
                                                    str = @"短信已发出，请注意查收";
                                                } else {
                                                    str = @"短信发送失败";
                                                }
                                                [appDelegate showAlertViewForTitle:@"" message:str cancelButton:@"OK"];
                                            }];

                       if ([[TaskQueue sharedTaskQueue] addTaskToQueue:orderTask]) {
                       }

                   }];

    UIAlertView *alertAt = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"确定要重新发送订单信息到手机吗？"
                                             cancelButtonItem:cancel
                                             otherButtonItems:sms, nil];
    [alertAt show];
}

- (void)saveQRcode {
    if (codeImageView.image) {
        UIImageWriteToSavedPhotosAlbum(codeImageView.image, self,
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [saveBtn removeFromSuperview];
    saveBtn = nil;
    [appDelegate showIndicatorWithTitle:@"保存成功" animated:NO fullScreen:NO overKeyboard:YES andAutoHide:YES];
}

- (void)longPressImage {
    [self showImage:codeImageView];
}

- (void)showImage:(UIImageView *)avatarImageView {
    UIImage *image = avatarImageView.image;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,
                                                                      [UIScreen mainScreen].bounds.size.height)];
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer:tap];

    [UIView animateWithDuration:0.3
            animations:^{
                imageView.frame =
                        CGRectMake(0, ([UIScreen mainScreen].bounds.size.height -
                                       image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width) /
                                              2,
                                   [UIScreen mainScreen].bounds.size.width,
                                   image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width);
                backgroundView.alpha = 1;
            }
            completion:^(BOOL finished){

            }];
}

- (void)hideImage:(UITapGestureRecognizer *)tap {
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView *) [tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3
            animations:^{
                imageView.frame = oldframe;
                backgroundView.alpha = 0;
            }
            completion:^(BOOL finished) {
                [backgroundView removeFromSuperview];
            }];
}

- (void)taped:(UITapGestureRecognizer *)gesture {
    if ([saveBtn pointInside:[gesture locationInView:saveBtn] withEvent:nil]) {
        return;
    }
    if (saveBtn) {
        [saveBtn removeFromSuperview];
        saveBtn = nil;
    }
}

#pragma mark UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
            delay:0.0f
            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
            animations:^{

                holder.contentInset = UIEdgeInsetsZero;

            }
            completion:^(BOOL finished) {
                [refreshHeaderView setState:EGOOPullRefreshNormal];

                if (holder.contentOffset.y <= 0) {

                    [holder setContentOffset:CGPointZero animated:YES];
                }

            }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.isDragging) {
        if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f &&
            scrollView.contentOffset.y < 0.0f) {
            [refreshHeaderView setState:EGOOPullRefreshNormal];
        } else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {
            [refreshHeaderView setState:EGOOPullRefreshPulling];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (refreshHeaderView.state == EGOOPullRefreshLoading) {
        return;
    }
    if (scrollView.contentOffset.y <= -65.0f) {
        [self performSelector:@selector(refreshOrderDetail) withObject:nil afterDelay:0.1];
    }
}

- (void)cinemaIntroFinished:(NSNotification *)notification {

    if ([notification succeeded]) {

    } else {
        NSDictionary *userInfo = [notification userInfo];
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

#pragma mark action sheet delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [self popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [self popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UILabel *)setOrderListView:(CGFloat)positionInHolder
                 andListTitle:(NSString *)listTitle
                andListValueP:(NSString *)listValue {
    UIView *orderNoView = [[UIView alloc] initWithFrame:CGRectMake(0, positionInHolder, screentWith, 45)];
    [orderNoView setBackgroundColor:[UIColor whiteColor]];
    [holderBgView addSubview:orderNoView];

    UILabel *orderNoLabelT = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TitleCellWith, 45)];
    orderNoLabelT.backgroundColor = [UIColor clearColor];
    orderNoLabelT.textColor = appDelegate.kkzTextColor;
    orderNoLabelT.textAlignment = NSTextAlignmentRight;
    orderNoLabelT.font = [UIFont systemFontOfSize:kFont];
    orderNoLabelT.text = [NSString stringWithFormat:@"%@：", listTitle];
    [orderNoView addSubview:orderNoLabelT];

    UILabel *orderNoLabelV =
            [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(orderNoLabelT.frame), 0, screentWith - 100, 45)];
    orderNoLabelV.backgroundColor = [UIColor clearColor];
    orderNoLabelV.textColor = appDelegate.kkzTextColor;
    orderNoLabelV.font = [UIFont systemFontOfSize:kFont];
    orderNoLabelV.text = [NSString stringWithFormat:@"%@", listValue];
    [orderNoView addSubview:orderNoLabelV];

    if ([listTitle isEqualToString:@"影院"]) {
        orderNoLabelV.frame = CGRectMake(CGRectGetMaxX(orderNoLabelT.frame), 0, screentWith - 170, 45);

        RoundCornersButton *cinemaDetailButton =
                [[RoundCornersButton alloc] initWithFrame:CGRectMake(screentWith - 80, 12, 67, 21)];
        cinemaDetailButton.cornerNum = kDimensCornerNum;
        cinemaDetailButton.fillColor = [UIColor r:0 g:140 b:255];
        cinemaDetailButton.backgroundColor = [UIColor r:0 g:140 b:255];
        cinemaDetailButton.titleName = @"查看地图";
        cinemaDetailButton.titleColor = [UIColor whiteColor];
        cinemaDetailButton.titleFont = [UIFont systemFontOfSize:kTextSizeButton];
        [cinemaDetailButton addTarget:self action:@selector(locateCinema) forControlEvents:UIControlEventTouchUpInside];
        [orderNoView addSubview:cinemaDetailButton];

        //只有选座订单可以定位
        cinemaDetailButton.hidden = NO;
    }

    return orderNoLabelV;
}

- (void)getPassBook:(UIButton *)btn {
    PassbookTask *task =
            [[PassbookTask alloc] initPassbookDataWithOrderId:self.orderNo
                                                     finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                         [self checkPassbookInfoFinished:userInfo status:succeeded];

                                                     }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)checkPassbookInfoFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {
        NSString *str = userInfo[@"komoviePkpass"];
        [self openAndAddPassToPassbook:str];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

// pass代码片段，由于和controller关联，不易封装。

- (void)openAndAddPassToPassbook:(NSString *)str {

    NSData *decodeData = [Cryptor decodeBase64WithUTF8String:str];

    NSError *error = nil;
    PKPass *newPass = [[PKPass alloc] initWithData:decodeData error:&error];
    // 3、检查是否有错误，如有弹出对话框。
    if (error != nil) {
        [[[UIAlertView alloc] initWithTitle:@"Passes error"
                                    message:[error localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"知道了"
                          otherButtonTitles:nil] show];
        return;
    }
    //检查PKPassLibrary内是否已经有同样的pass, 有的话, 进行更新, 没有就要进行增加.
    PKPassLibrary *passLibrary = [[PKPassLibrary alloc] init];
    if ([passLibrary containsPass:newPass]) {
        [appDelegate showAlertViewForTitle:@"" message:@"已经添加到passbook了" cancelButton:@"知道了"];
        BOOL replaceResult = [passLibrary replacePassWithPass:newPass];
        DLog(@"replaceResult %d", replaceResult);
    } else {
        PKAddPassesViewController *addController = [[PKAddPassesViewController alloc] initWithPass:newPass];
        addController.delegate = self;
        [self presentViewController:addController animated:YES completion:nil];
    }
}

#pragma mark - Pass controller delegate
- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
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
