//
//  支付订单页面
//
//  Created by alfaromeo on 12-7-11.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "PayViewController.h"
#import "UserDefault.h"


#import "DateEngine.h"
#import "OrderTask.h"
#import "PayTask.h"
#import "TaskQueue.h"

#import "Cinema.h"
#import "Coupon.h"
#import "Order.h"
#import "Ticket.h"

#import "BestpayNativeModel.h"
#import "BestpaySDK.h"
#import "DataEngine.h"
#import "ECardViewController.h"
#import "NSStringExtra.h"
#import "OrderPayViewController.h"
#import "OrderRequest.h"
#import "UIAlertView+Blocks.h"
#import "UIColorExtra.h"
#import "UIImageVIew+WebURL.h"
#import "UserManager.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

//锁座有效时间
#define kLockSeatLastTime 480
#define kLockSeatWarningTime 60
#define kMarginX 90
#define kMarginCouponX 0

#define kTextSizeMovieName 16 // 电影名称的字体大小
#define kTextSizeTicketInfo 13 // 影票其他信息的字体大小

@interface PayViewController ()

- (void)updateLayout;
- (void)cancelViewController;

@end

@implementation PayViewController

@synthesize orderNo;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxpaySucceedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"yiPaySucceedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (payView)
        [payView removeFromSuperview];
}

- (id)initWithOrder:(NSString *)oNo {
    self = [super init];
    if (self) {
        self.orderNo = oNo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    self.isFromYiZhiFu = YES;

    self.kkzTitleLabel.text = @"支付订单";

    backgroundView = [[UIView alloc] init];
    backgroundView.frame = CGRectMake(0, 0, screentWith, screentHeight);
    backgroundView.backgroundColor = [UIColor colorWithRed:(40 / 255.0f) green:(40 / 255.0f) blue:(40 / 255.0f) alpha:1.0f];
    backgroundView.alpha = 0.1;

    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethod:) userInfo:nil repeats:YES];

    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
    [self.view addSubview:holder];
    holder.backgroundColor = [UIColor r:245 g:245 b:245];
    holder.showsVerticalScrollIndicator = NO;

    [self queryUserMobile];
    [self queryOrderDetail];
    [self queryOrderWarning];

    //timeCount = 60*15;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sliderTotop) userInfo:nil repeats:NO];

    CinemaDetail *cinema = self.myOrder.plan.cinema;
    Movie *movie = self.myOrder.plan.movie;

    //支付剩余时间的现实

    UIView *timerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith, 30)];
    [timerView setBackgroundColor:[UIColor r:255 g:248 b:208]];

    UILabel *timerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screentWith * 0.5 + 10, 30)];
    timerTitle.text = @"支付剩余时间";
    timerTitle.textColor = [UIColor r:153 g:153 b:153];
    timerTitle.font = [UIFont systemFontOfSize:13];
    timerTitle.textAlignment = NSTextAlignmentRight;
    [timerTitle setBackgroundColor:[UIColor clearColor]];
    [timerView addSubview:timerTitle];

    timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(screentWith * 0.5 + 20, 0.0, screentWith * 0.5 - 20, 30)];
    timerLabel.font = [UIFont systemFontOfSize:14];
    timerLabel.textColor = [UIColor r:242 g:101 b:34];
    timerLabel.backgroundColor = [UIColor clearColor];
    timerLabel.textAlignment = NSTextAlignmentLeft;
    timerLabel.text = @"";
    [timerView addSubview:timerLabel];

    [self.view addSubview:timerView];

    /*Ticket详情*/
    sliderH = 126;
    Ticket *plan = self.myOrder.plan;

    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, screentWith, 116)];

    infoView.backgroundColor = [UIColor whiteColor];
    [holder addSubview:infoView];

    UIImage *imgTicketBottom = [UIImage imageNamed:@"ticketPageBottom"];
    UIImageView *imgTicketBottomV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 116 - 20 + CGRectGetMaxY(timerLabel.frame), screentWith, 30)];
    imgTicketBottomV.image = imgTicketBottom;
    [holder insertSubview:imgTicketBottomV belowSubview:infoView];

    CGFloat positY = 15;

    movieNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, positY, screentWith - 15 * 2, kTextSizeMovieName)];
    movieNameLabel.backgroundColor = [UIColor clearColor];
    movieNameLabel.textColor = [UIColor blackColor];
    movieNameLabel.font = [UIFont systemFontOfSize:kTextSizeMovieName];
    movieNameLabel.text = [NSString stringWithFormat:@"%@", movie.movieName];
    [infoView addSubview:movieNameLabel];

    positY += 13 + kTextSizeMovieName;

    UILabel *startTime = [[UILabel alloc] initWithFrame:CGRectMake(15, positY, 35, kTextSizeTicketInfo)];
    startTime.backgroundColor = [UIColor clearColor];
    startTime.textAlignment = NSTextAlignmentLeft;
    startTime.textColor = [UIColor lightGrayColor];
    startTime.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    startTime.text = @"场次  ";
    [infoView addSubview:startTime];

    startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, positY, screentWith - 15 * 2, kTextSizeTicketInfo)];
    startTimeLabel.backgroundColor = [UIColor clearColor];
    startTimeLabel.textColor = [UIColor blackColor];
    startTimeLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    startTimeLabel.text = [NSString stringWithFormat:@"%@ %@%@", [self.myOrder movieTimeDesc], plan.language ? plan.language : @"", self.myOrder.plan.screenType ? plan.screenType : @""];
    [infoView addSubview:startTimeLabel];

    positY += 10 + kTextSizeTicketInfo;

    UILabel *cinemaName = [[UILabel alloc] initWithFrame:CGRectMake(15, positY, 35, kTextSizeTicketInfo)];
    cinemaName.backgroundColor = [UIColor clearColor];
    cinemaName.textAlignment = NSTextAlignmentLeft;
    cinemaName.textColor = [UIColor lightGrayColor];
    cinemaName.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    cinemaName.text = @"影院  ";
    [infoView addSubview:cinemaName];

    cinemaNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, positY, screentWith - 25 - cinemaName.frame.size.width, kTextSizeTicketInfo)];
    cinemaNameLabel.backgroundColor = [UIColor clearColor];
    cinemaNameLabel.textColor = [UIColor blackColor];
    cinemaNameLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    cinemaNameLabel.text = [NSString stringWithFormat:@"%@ %@", cinema.cinemaName, plan.hallName];
    [infoView addSubview:cinemaNameLabel];

    positY += 10 + kTextSizeTicketInfo;

    UILabel *seatLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, positY, 80, kTextSizeTicketInfo)];
    seatLabel.backgroundColor = [UIColor clearColor];
    seatLabel.textColor = [UIColor lightGrayColor];
    seatLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    seatLabel.text = @"座位  ";
    [infoView addSubview:seatLabel];

    seatInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, positY, screentWith - 52 - 15, kTextSizeTicketInfo)];
    seatInfoLabel.backgroundColor = [UIColor clearColor];
    seatInfoLabel.textColor = [UIColor blackColor];
    seatInfoLabel.numberOfLines = 0;
    seatInfoLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    seatInfoLabel.text = [NSString stringWithFormat:@"%@", [self.myOrder readableSeatInfos]];
    [infoView addSubview:seatInfoLabel];

    phoneView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(infoView.frame) + 10, screentWith, 88)];
    phoneView.backgroundColor = [UIColor clearColor];
    [holder addSubview:phoneView];

    telephoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 100, 33)];
    telephoneLabel.backgroundColor = [UIColor clearColor];
    telephoneLabel.textColor = [UIColor r:153 g:153 b:153];
    telephoneLabel.font = [UIFont systemFontOfSize:14];
    telephoneLabel.text = [NSString stringWithFormat:@"购票手机号码："];
    [phoneView addSubview:telephoneLabel];

    UIView *telephoneBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 38, screentWith, 50)];
    telephoneBgView.backgroundColor = [UIColor whiteColor];
    [phoneView addSubview:telephoneBgView];

    telephoneField = [[UITextField alloc] initWithFrame:CGRectMake(15, 38, screentWith - 15 * 2, 50)];
    telephoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    telephoneField.backgroundColor = [UIColor clearColor];
    telephoneField.placeholder = @"请输入手机号";
    telephoneField.textColor = [UIColor blackColor];
//    telephoneField.enabled = NO;

    telephoneField.delegate = self;
    telephoneField.keyboardType = UIKeyboardTypeNumberPad;
    telephoneField.font = [UIFont systemFontOfSize:13];
    
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];
    
    [topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btnToolBar = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnToolBar.frame = CGRectMake(2, 5, 50, 30);
    
    [btnToolBar addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    
    [btnToolBar setTitle:@"完成" forState:UIControlStateNormal];
    
    [btnToolBar setTitleColor:appDelegate.kkzBlue forState:UIControlStateNormal];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithCustomView:btnToolBar];
    
    NSArray *buttonsArray = [NSArray arrayWithObjects:btnSpace, doneBtn, nil];
    
    [topView setItems:buttonsArray];
    
    [telephoneField setInputAccessoryView:topView];

    [phoneView addSubview:telephoneField];

    UIImage *img = [UIImage imageNamed:@"editPhoneNum"];
    UIImageView *editMobileV = [[UIImageView alloc] initWithFrame:CGRectMake(screentWith - 16 - 15 * 2, (50 - 17) * 0.5, 16, 17)];
    editMobileV.image = img;
    editMobileV.userInteractionEnabled = NO;
    [telephoneField addSubview:editMobileV];
    
    //支付方式列表
    payView = [[PayView alloc] init];
    payView.frame = CGRectMake(0, CGRectGetMaxY(phoneView.frame), screentWith, 500);
    payView.delegate = self;
    payView.orderNo = self.orderNo;
    payView.hasOrderExpired = NO;
    payView.myOrder = self.myOrder;
    payView.orderTotalFee = [self.myOrder moneyToPay];
    [payView doRedCouponTask];
    [payView doRedAccountsTask];
    [payView doPayTypeTask];

    [holder addSubview:payView];

    __weak typeof(self) weakSelf = self;

    payView.moneyToPayChanged = ^(CGFloat moneytopay, PayMethod paymethod) {

        weakSelf.moneyNeedPayLabelY.text = [NSString stringWithFormat:@"￥%.2f", moneytopay];

        if (moneytopay <= 0) {

            [weakSelf.seatBtnY setTitle:@"确认支付" forState:UIControlStateNormal];
            [weakSelf.seatBtnY setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            weakSelf.seatBtnY.backgroundColor = [UIColor r:255 g:105 b:0];
            weakSelf.seatBtnY.titleLabel.font = [UIFont systemFontOfSize:16];
            weakSelf.seatBtnY.titleLabel.textColor = [UIColor whiteColor];

        } else if (moneytopay > 0) {

            CGFloat balance = [DataEngine sharedDataEngine].vipBalance;

            if (paymethod == PayMethodVip && moneytopay - balance > 0.0001) {

                [weakSelf.seatBtnY setTitle:@"充值购票" forState:UIControlStateNormal];
                [weakSelf.seatBtnY setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                weakSelf.seatBtnY.backgroundColor = [UIColor r:255 g:105 b:0];
                weakSelf.seatBtnY.titleLabel.font = [UIFont systemFontOfSize:16];
                weakSelf.seatBtnY.titleLabel.textColor = [UIColor whiteColor];

            } else if (paymethod == PayMethodNone) {

                [weakSelf.seatBtnY setTitle:@"确认支付" forState:UIControlStateNormal];
                [weakSelf.seatBtnY setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                weakSelf.seatBtnY.backgroundColor = [UIColor r:208 g:208 b:208];
                weakSelf.seatBtnY.titleLabel.font = [UIFont systemFontOfSize:16];
                weakSelf.seatBtnY.titleLabel.textColor = [UIColor whiteColor];

            } else {

                [weakSelf.seatBtnY setTitle:@"确认支付" forState:UIControlStateNormal];
                [weakSelf.seatBtnY setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                weakSelf.seatBtnY.backgroundColor = [UIColor r:255 g:105 b:0];
                weakSelf.seatBtnY.titleLabel.font = [UIFont systemFontOfSize:16];
                weakSelf.seatBtnY.titleLabel.textColor = [UIColor whiteColor];
            }
        }

    };

    CGFloat bottomY = 0;
    if (runningOniOS7) {
        bottomY = 0;
    } else {
        bottomY = 20;
    }
    UIView *payBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, screentHeight - 50 - bottomY, screentWith, 50)];
    [payBtnView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:payBtnView];

    UILabel *moneyNeedPayLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screentWith - 155 - 90, 50)];
    moneyNeedPayLbl.backgroundColor = [UIColor clearColor];
    moneyNeedPayLbl.textColor = [UIColor blackColor];
    moneyNeedPayLbl.textAlignment = NSTextAlignmentRight;
    moneyNeedPayLbl.text = @"实付款：";
    moneyNeedPayLbl.font = [UIFont systemFontOfSize:15];
    [payBtnView addSubview:moneyNeedPayLbl];

    moneyNeedPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(screentWith - 155 - 90, 0, 90, 50)];
    moneyNeedPayLabel.backgroundColor = [UIColor clearColor];
    moneyNeedPayLabel.textAlignment = NSTextAlignmentLeft;
    moneyNeedPayLabel.textColor = appDelegate.kkzDarkYellow;
    moneyNeedPayLabel.text = @"";
    moneyNeedPayLabel.font = [UIFont systemFontOfSize:20];

    [payBtnView addSubview:moneyNeedPayLabel];

    self.moneyNeedPayLabelY = moneyNeedPayLabel;

    seatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seatBtn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - 155, 0, 155, 50)];
    [seatBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [seatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    seatBtn.backgroundColor = [UIColor r:208 g:208 b:208];
    seatBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    seatBtn.titleLabel.textColor = [UIColor whiteColor];
    [seatBtn addTarget:self action:@selector(payOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [payBtnView addSubview:seatBtn];

    self.seatBtnY = seatBtn;

    if (appDelegate.isAuthorized) {

        [[UserManager shareInstance] updateBalance:nil failure:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(weiXinSucceed:)
                                                 name:@"wxpaySucceedNotification"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yiPaySucceed:)
                                                 name:@"yiPaySucceedNotification"
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pufaPaySucceed:)
                                                 name:@"pufaPaySucceedNotification"
                                               object:nil];
    [KKZAnalytics postActionWithEvent:[[KKZAnalyticsEvent alloc] initWithOrder:self.myOrder] action:AnalyticsActionPay_order];
}

#pragma mark - Override from CommonViewController
- (void)cancelViewController {
    seatBtn.userInteractionEnabled = NO;
    backBtn.userInteractionEnabled = NO;

    [self deleteOrder];
}

- (void)sliderTotop {
    [holder setContentOffset:CGPointMake(0, sliderH) animated:YES];
}

- (void)beforeActivityMethod:(NSTimer *)time {

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *expireDate2;
    if (self.isFromCoupon) {
        expireDate2 = [NSDate dateWithTimeIntervalSinceNow:15 * 60];
    } else {
        expireDate2 = [[[DateEngine sharedDateEngine] dateFromString:self.myOrder.orderTime] dateByAddingTimeInterval:15 * 60];
    }

    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;

    NSDateComponents *d = [calendar components:unitFlags
                                      fromDate:[NSDate date]
                                        toDate:expireDate2
                                       options:0]; //计算时间差

    if ([d second] < 0) {
        timerLabel.font = [UIFont systemFontOfSize:16];
        timerLabel.text = @"支付过期";

        [timerLabel setNeedsDisplay];

        [timer invalidate];
        timer = nil;
        payView.hasOrderExpired = YES;
        payView.userInteractionEnabled = NO;
    } else {
        //倒计时显示
        timerLabel.font = [UIFont boldSystemFontOfSize:16];
        if ([d minute] < 10 && [d second] >= 10) {
            timerLabel.text = [NSString stringWithFormat:@"0%d:%d", (int) [d minute], (int) [d second]];

        } else if ([d second] < 10 && [d minute] >= 10) {
            timerLabel.text = [NSString stringWithFormat:@"%d:0%d", (int) [d minute], (int) [d second]];

        } else if ([d second] < 10 && [d minute] < 10) {
            timerLabel.text = [NSString stringWithFormat:@"0%d:0%d", (int) [d minute], (int) [d second]];

        } else {
            timerLabel.text = [NSString stringWithFormat:@"%d:%d", (int) [d minute], (int) [d second]];
        }
        if ([d second] >= 0 && [d minute] >= 15) {
            timerLabel.text = @"15:00";
        }
        [timerLabel setNeedsDisplay];
    }
}

- (void)updateLayout {
    CinemaDetail *cinema = self.myOrder.plan.cinema;
    Ticket *ticket = self.myOrder.plan;
    Movie *movie = ticket.movie;
    /*Ticket详情*/
    if (movie.thumbPath.length) {
        [postImageView loadImageWithURL:movie.thumbPath andSize:ImageSizeSmall];
    } else {
        [postImageView loadImageWithURL:movie.pathVerticalS andSize:ImageSizeSmall];
    }

    movieNameLabel.text = [NSString stringWithFormat:@"电影：%@", self.myOrder.plan.movie.movieName ? self.myOrder.plan.movie.movieName : @""];

    if ([cinema.cinemaName isEqualToString:@"(null)"]) {
        cinemaNameLabel.text = @"无";
    } else {
        cinemaNameLabel.text = [NSString stringWithFormat:@"影院：%@", cinema.cinemaName ? cinema.cinemaName : @"无"];
    }

    NSString *movieTimeDescStr = [self.myOrder movieTimeDesc];
    if ([[self.myOrder movieTimeDesc] isEqualToString:@"(null)"]) {
        movieTimeDescStr = @"";
    }

    startTimeLabel.text = [NSString stringWithFormat:@"场次  %@ %@%@", movieTimeDescStr, ticket.language ? ticket.language : @"", self.myOrder.plan.screenType ? self.myOrder.plan.screenType : @""];
    [holder addSubview:startTimeLabel];

    NSString *seatInfo = [self.myOrder readableSeatInfos];
    CGSize size = [seatInfo sizeWithFont:[UIFont systemFontOfSize:kTextSizeTicketInfo] constrainedToSize:CGSizeMake(160, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail];
    CGFloat yH = seatInfoLabel.frame.origin.y;
    seatInfoLabel.frame = CGRectMake(kMarginX + 60, yH, 160, size.height);

    seatInfoLabel.text = [NSString stringWithFormat:@"%@", [self.myOrder readableSeatInfos]];
    ticketCountLabel.text = [NSString stringWithFormat:@"数量：%ld张", (long) [self.myOrder seatCount]];
    telephoneLabel.text = [NSString stringWithFormat:@"手机号：%@", self.myOrder.mobile];
}

#pragma mark gestureRecognizer view delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

#pragma mark utility
- (void)payOrderClick {

    if (telephoneField.text.length < 11 || ![[telephoneField.text substringToIndex:1] isEqualToString:@"1"]) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"请输入正确的手机号码"
                              cancelButton:@"好的"];
        return;
    } else {
        BOOKING_PHONE_WRITE(telephoneField.text);
    }

    backBtn.userInteractionEnabled = NO;
    seatBtn.userInteractionEnabled = NO;

    [self.view.window addSubview:backgroundView];

    //统计事件：支付订单
    StatisEvent(EVENT_BUY_PAY_ORDER);
    if (appDelegate.selectedTab == 0) { //电影入口
        StatisEvent(EVENT_BUY_PAY_ORDER_SOURCE_MOVIE);
    } else if (appDelegate.selectedTab == 1) { //影院入口
        StatisEvent(EVENT_BUY_PAY_ORDER_SOURCE_CINEMA);
    }

    [payView payOrder];
}

- (void)payOrderBtnEnable:(BOOL)isEnable {
    backBtn.userInteractionEnabled = isEnable;
    seatBtn.userInteractionEnabled = isEnable;
    [backgroundView removeFromSuperview];
}

- (void)queryOrderDetail {

    OrderRequest *request = [OrderRequest new];
    [request requestOrderDetail:self.orderNo
            success:^(Order *_Nullable order) {
                [appDelegate hideIndicator];

                Order *orderY = order;
                if (orderY.promotion.promotionTitle.length > 0) {
                    payView.promotionTitle = orderY.promotion.promotionTitle;
                }

            }
            failure:^(NSError *_Nullable err) {
                [appDelegate hideIndicator];
                [appDelegate showAlertViewForTitle:nil message:err.userInfo[KKZRequestErrorMessageKey] cancelButton:@"确定"];

            }];
}

- (void)queryOrderWarning {

    OrderTask *task = [[OrderTask alloc] initQueryOrderWarning:self.orderNo
                                                    andPromoId:self.promotionId
                                                      finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                          [self queryWarningFinished:userInfo status:succeeded];
                                                      }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)queryUserMobile {

    OrderRequest *request = [OrderRequest new];

    [request requestOrderMobile:^(NSString *_Nullable mobile) {
        DLog(@"BOOKING_PHONE ====  %@", BOOKING_PHONE);
        if (mobile.length) {
            telephoneField.text = [NSString stringWithFormat:@"%@", mobile]; //BOOKING_PHONE
        } else if (BOOKING_PHONE) {
            telephoneField.text = BOOKING_PHONE;
        } else if (BINDING_PHONE) {
            telephoneField.text = BINDING_PHONE;
        }
    }
            failure:^(NSError *_Nullable err){

            }];
}

- (void)queryWarningFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {

    if (succeeded) {

        NSString *message = userInfo[@"message"];

        [appDelegate showAlertViewForTitle:@"" message:message cancelButton:@"OK"];
    }
}

- (void)deleteOrder {

    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    cancel.action = ^{
        backBtn.userInteractionEnabled = YES;
        seatBtn.userInteractionEnabled = YES;
    };
    RIButtonItem *resign = [RIButtonItem itemWithLabel:@"确认"];
    resign.action = ^{

        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteOrderY" object:nil];

        [appDelegate showIndicatorWithTitle:@"正在取消订单..."
                                   animated:YES
                                 fullScreen:NO
                               overKeyboard:NO
                                andAutoHide:NO];

        OrderRequest *request = [OrderRequest new];
        [request deleteOrder:self.orderNo
                success:^{

                    [self resetDisplay];

                }
                failure:^(NSError *_Nullable err) {
                    [self resetDisplay];
                    [appDelegate showAlertViewForTitle:nil message:err.userInfo[KKZRequestErrorMessageKey] cancelButton:@"确定"];

                }];

    };
    UIAlertView *alertAt = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"返回将立即取消订单，您确认要取消订单吗"
                                             cancelButtonItem:cancel
                                             otherButtonItems:resign, nil];
    [alertAt show];
}

- (void)resetDisplay {
    [appDelegate hideIndicator];
    backBtn.userInteractionEnabled = YES;
    seatBtn.userInteractionEnabled = YES;
    [timer invalidate];
    timer = nil;
    [self popViewControllerAnimated:YES];
}

//第三方支付选择，选择
- (void)payOrderMethod:(PayMethod)selectedMethod
                payUrl:(NSString *)payUrl
                  sign:(NSString *)sign
                  spId:(NSString *)spId
            sysProvide:(NSString *)sysProvide {

    if (selectedMethod == PayMethodAliMoblie) {

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {

            RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"确定"];
            cancel.action = ^{

                [self alipayWithUrl:payUrl andSign:sign];
            };

            RIButtonItem *done = [RIButtonItem itemWithLabel:@"取消"];
            done.action = ^{

            };

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                            message:@"如果您的支付宝是旧版可能与IOS9系统不兼容。请将支付宝升级到最新版。（支付宝已是最新版请忽略此提示信息）"
                                                   cancelButtonItem:cancel
                                                   otherButtonItems:done, nil];
            [alert show];

        } else {

            [self alipayWithUrl:payUrl andSign:sign];
        }

    } else if (selectedMethod == PayMethodUnionpay) {
        if (![self unionPayWithSign:sign spId:spId sysProvide:sysProvide]) {
        }
    }
    if (selectedMethod == PayMethodYiZhiFu) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        NSString *orderStr = payUrl;
        BestpayNativeModel *order = [[BestpayNativeModel alloc] init];
        order.orderInfo = orderStr;
        order.launchType = launchTypePay1; // launchTypePay1为支付，launchTypeRecharge1为充值
        order.scheme = @"KoMovie";
        [BestpaySDK payWithOrder:order fromViewController:self];
    }
    

    
}

//支付宝
/*- (void)alipayWithUrl:(NSString *)payUrl andSign:(NSString *)paySign {
    //获取安全支付单例并调用安全支付接口
    
    
    [[AlipaySDK defaultService] payOrder:paySign fromScheme:kAlipayScheme callback:^(NSDictionary *resultDic)
     {
         NSLog(@"reslut = %@",resultDic);
         
     }];
    
}*/

- (void)alipayWithUrl:(NSString *)payUrl andSign:(NSString *)paySign {
    //获取安全支付单例并调用安全支付接口
    [[AlipaySDK defaultService] payOrder:paySign
                              fromScheme:kAlipayScheme
                                callback:^(NSDictionary *resultDic) {

                                    [self handleAlipayResult:resultDic];
                                }];
}

- (void)handleAlipayResult:(NSDictionary *)result {
    NSLog(@"reslut = %@", result);

    int stateStaus = [[result objectForKey:@"resultStatus"] intValue];
    NSString *resultMsg = @"";

    if (stateStaus == 9000) {
        [self sendOrderSuccessEvent];

        OrderPayViewController *ctr = [[OrderPayViewController alloc] initWithOrder:self.orderNo];
        ctr.order = self.myOrder;
        [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];

    }
#warning 支付宝支付失败的处理逻辑？
    else if (stateStaus == 6001) {
        [self sendOrderFailedEvent];

        resultMsg = [result objectForKey:@"memo"];
    } else {
        [self sendOrderFailedEvent];

        resultMsg = [result objectForKey:@"memo"];
    }
}

//银联
- (BOOL)unionPayWithSign:(NSString *)paySign spId:(NSString *)spId sysProvide:(NSString *)sysProvide {
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    return [UPPayPlugin startPay:paySign mode:UPPayMode viewController:self delegate:self];
#endif
}

#pragma mark handle notifications
- (void)weiXinSucceed:(NSNotification *)notification {

    [timer invalidate];
    timer = nil;

    [self sendOrderSuccessEvent];

    OrderPayViewController *ctr = [[OrderPayViewController alloc] initWithOrder:self.orderNo];
    ctr.order = self.myOrder;
    [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
}

- (void)yiPaySucceed:(NSNotification *)notification {
    [timer invalidate];
    timer = nil;

    if (!self.isFromYiZhiFu) {
        return;
    }

    self.isFromYiZhiFu = NO;

    NSDictionary *dic = [[self class] paramsFromString:notification.userInfo[@"yiPayResult"]];

    //    [appDelegate showAlertViewForTitle:@"" message:[NSString stringWithFormat:@"支付结果：支付%@",[dic objectForKey:@"result"]] cancelButton:@"确定"];

    if ([[dic objectForKey:@"result"] isEqualToString:@"成功"]) {
        [self sendOrderSuccessEvent];

        OrderPayViewController *ctr = [[OrderPayViewController alloc] initWithOrder:self.orderNo];
        ctr.order = self.myOrder;
        [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
    }
}

- (void)pufaPaySucceed:(NSNotification *)notification {
    OrderPayViewController *ctr = [[OrderPayViewController alloc] initWithOrder:self.orderNo];
    ctr.order = self.myOrder;
    [self pushViewController:ctr
                     animation:CommonSwitchAnimationSwipeR2L];
}

//unionpay 银联支付回调
#pragma mark uppay delegte
- (void)UPPayPluginResult:(NSString *)result {
    if ([result isEqualToString:@"success"]) {
        [self sendOrderSuccessEvent];

        OrderPayViewController *ctr = [[OrderPayViewController alloc] initWithOrder:self.orderNo];
        ctr.order = self.myOrder;
        [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];

    } else {
        [self sendOrderFailedEvent];
    }
}

//统计事件：订单支付成功
- (void)sendOrderSuccessEvent {
    StatisEvent(EVENT_BUY_ORDER_SUCCESS);
    if (appDelegate.selectedTab == 0) { //电影入口
        StatisEvent(EVENT_BUY_ORDER_SUCCESS_SOURCE_MOVIE);
    } else if (appDelegate.selectedTab == 1) { //影院入口
        StatisEvent(EVENT_BUY_ORDER_SUCCESS_SOURCE_CINEMA);
    }
}

//统计事件：订单支付失败
- (void)sendOrderFailedEvent {
    StatisEvent(EVENT_BUY_ORDER_FAILED);
}

#pragma mark PayView delegate
- (void)heightDidChange {
    [holder setContentSize:CGSizeMake(screentWith, CGRectGetMaxY(payView.frame) + 90)];
}

#pragma mark uitextfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == telephoneField) {

        if ([string isEqualToString:@""]) { //按下return键
            return YES;
        }
        if (telephoneField.text.length >= 11) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"亲，输入字数不能超过11位噢~"
                                                               delegate:nil
                                                      cancelButtonTitle:@"好的"
                                                      otherButtonTitles:nil, nil];
            [alertView show];

            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self sliderTotop];
    return YES;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:phoneViewTap];
    if (!CGRectContainsPoint(phoneView.frame, point)) {
        [telephoneField resignFirstResponder];
        return;
    }
}

+ (NSDictionary *)paramsFromString:(NSString *)urlStr {
    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (urlStr == nil || [urlStr isEqualToString:@""] || ![urlStr hasPrefix:@"KoMovie"]) {
        return nil;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    NSString *str = [urlStr stringByReplacingOccurrencesOfString:@"KoMovie" withString:@""];

    if ([str isEqualToString:@""]) {
        return nil;
    }

    NSArray *array = [str componentsSeparatedByString:@"&"];

    //此处针对2.0.0版本及后续版本的数据处理
    if ([array count]) {
        NSDictionary *tmpDic = [[self class] paramsFromKeyValueStr:str];
        [dic setDictionary:tmpDic];
    }

    return dic;
}

+ (NSDictionary *)paramsFromKeyValueStr:(NSString *)str {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    NSArray *array = [str componentsSeparatedByString:@"&"];

    if ([array count]) {
        for (int i = 0; i < [array count]; i++) {
            NSString *pStr = [array objectAtIndex:i];
            NSArray *kvArray = [pStr componentsSeparatedByString:@"="];
            if ([kvArray count] != 2) {
                continue;
            }
            NSString *key = [kvArray objectAtIndex:0];
            key = [key stringByReplacingOccurrencesOfString:@"\b" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            key = [key stringByReplacingOccurrencesOfString:@"\0" withString:@""];
            NSString *value = [kvArray objectAtIndex:1];
            value = [value stringByReplacingOccurrencesOfString:@"\b" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            value = [value stringByReplacingOccurrencesOfString:@"\0" withString:@""];

            [dic setObject:value forKey:key];
        }
    }

    return dic;
}

- (void)dismissKeyBoard {
    [telephoneField resignFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    [telephoneField resignFirstResponder];
}

#pragma mark override from CommonViewController
- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return TRUE;
}

- (BOOL)showTitleBar {
    return TRUE;
}

@end
