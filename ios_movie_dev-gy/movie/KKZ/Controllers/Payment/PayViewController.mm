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
#import "MovieRequest.h"

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

#import "PaySecondViewController.h"
#import "CouponViewController.h"

//锁座有效时间
#define kLockSeatLastTime 480
#define kLockSeatWarningTime 60
#define kMarginX 90
#define kMarginCouponX 0

#define kTextSizeMovieName 16 // 电影名称的字体大小
#define kTextSizeTicketInfo 13 // 影票其他信息的字体大小

@interface PayViewController () <CouponViewControllerDelegate>
{
    //  Data
    NSString *_couponString;
    /// 是否为储蓄卡支付
    BOOL _isCardPay;
    NSArray *_selectedCouponList;
    NSInteger _coupon1Count;
    NSInteger _coupon2Count;
    CouponType _lastCouponType;
    
    //  UI
    UILabel *_couponCountLabel;
    UILabel *_couponCountLabel2;
    UILabel *_couponNullLabel;
    UILabel *_couponNullLabel2;
    UIImageView *_couponArrowView;
    UIImageView *_couponArrowView2;
}
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
    holder.contentSize = CGSizeMake(0, 750);
    
    [self queryUserMobile];
    [self queryOrderDetail];
    [self queryOrderWarning];

    //timeCount = 60*15;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(sliderTotop) userInfo:nil repeats:NO];

    CinemaDetail *cinema = self.myOrder.plan.cinema;
    Movie *movie = self.myOrder.plan.movie;

    //支付剩余时间的现实
    UIView *timerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 44)];

    UILabel *timerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screentWith * 0.5 + 10, 44)];
    timerTitle.text = @"距离完成支付还有";
    timerTitle.textColor = appDelegate.kkzPink;
    timerTitle.font = [UIFont systemFontOfSize:13];
    timerTitle.textAlignment = NSTextAlignmentRight;
    [timerTitle setBackgroundColor:[UIColor clearColor]];
    [timerView addSubview:timerTitle];

    timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(screentWith * 0.5 + 20, 0.0, screentWith * 0.5 - 20, 44)];
    timerLabel.font = [UIFont systemFontOfSize:14];
    timerLabel.textColor = appDelegate.kkzPink;
    timerLabel.backgroundColor = [UIColor clearColor];
    timerLabel.textAlignment = NSTextAlignmentLeft;
    timerLabel.text = @"";
    [timerView addSubview:timerLabel];

    [holder addSubview:timerView];

    /*Ticket详情*/
    sliderH = 126;
    Ticket *plan = self.myOrder.plan;

    UIImageView *infoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 44, screentWith-30, 275)];
    infoView.image = [[UIImage imageNamed:@"Pay_TickBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(200, 30, 30, 30)];
    [holder addSubview:infoView];

//    UIImage *imgTicketBottom = [UIImage imageNamed:@"ticketPageBottom"];
//    UIImageView *imgTicketBottomV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 116 - 20 + CGRectGetMaxY(timerLabel.frame), screentWith, 30)];
//    imgTicketBottomV.image = imgTicketBottom;
//    [holder insertSubview:imgTicketBottomV belowSubview:infoView];

    CGFloat positY = 20;

    movieNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, positY, screentWith - 15 * 2, kTextSizeMovieName)];
    movieNameLabel.backgroundColor = [UIColor clearColor];
    movieNameLabel.textColor = [UIColor blackColor];
    movieNameLabel.font = [UIFont systemFontOfSize:kTextSizeMovieName];
    movieNameLabel.text = [NSString stringWithFormat:@"%@", movie.movieName];
    [infoView addSubview:movieNameLabel];
    
    //  电影类型
    UILabel *screenTypeAndLanguageLabel = [[UILabel alloc] init];
    screenTypeAndLanguageLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    screenTypeAndLanguageLabel.textColor = appDelegate.kkzGray;
    screenTypeAndLanguageLabel.text = [NSString stringWithFormat:@"%@ %@",
                                       self.myOrder.plan.screenType ? plan.screenType : @"",
                                       plan.language ? plan.language : @""];
    [infoView addSubview:screenTypeAndLanguageLabel];
    [screenTypeAndLanguageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(movieNameLabel);
    }];

    positY += 13 + kTextSizeMovieName;

    //  时间
    UILabel *startTime = [[UILabel alloc] init];
    startTime.textAlignment = NSTextAlignmentLeft;
    startTime.textColor = [UIColor lightGrayColor];
    startTime.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    startTime.text = @"时间";
    [infoView addSubview:startTime];
    [startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(67);
    }];

    startTimeLabel = [[UILabel alloc] init];
    startTimeLabel.backgroundColor = [UIColor clearColor];
    startTimeLabel.textColor = [UIColor blackColor];
    startTimeLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    startTimeLabel.numberOfLines = 2;
    startTimeLabel.text = [NSString stringWithFormat:@"%@\n%@",
                           [self.myOrder movieTimeDescWithFormat:@"M月d日"],
                           [self.myOrder movieTimeDescWithFormat:@"HH:mm"]];
    [infoView addSubview:startTimeLabel];
    [startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startTime);
        make.top.equalTo(startTime.mas_bottom).offset(8);
    }];

    positY += 10 + kTextSizeTicketInfo;
    // 影厅
    UILabel *cinemaName = [[UILabel alloc] init];
    cinemaName.backgroundColor = [UIColor clearColor];
    cinemaName.textAlignment = NSTextAlignmentLeft;
    cinemaName.textColor = [UIColor lightGrayColor];
    cinemaName.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    cinemaName.text = @"影厅";
    [infoView addSubview:cinemaName];

    cinemaNameLabel = [[UILabel alloc] init];
    cinemaNameLabel.backgroundColor = [UIColor clearColor];
    cinemaNameLabel.textColor = [UIColor blackColor];
    cinemaNameLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    cinemaNameLabel.text = [NSString stringWithFormat:@"%@", plan.hallName];
    [infoView addSubview:cinemaNameLabel];

    positY += 10 + kTextSizeTicketInfo;
    //  座位
    UILabel *seatLabel = [[UILabel alloc] init];
    seatLabel.backgroundColor = [UIColor clearColor];
    seatLabel.textColor = [UIColor lightGrayColor];
    seatLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    seatLabel.text = @"座位";
    [infoView addSubview:seatLabel];

    seatInfoLabel = [[UILabel alloc] init];
    seatInfoLabel.backgroundColor = [UIColor clearColor];
    seatInfoLabel.textColor = [UIColor blackColor];
    seatInfoLabel.numberOfLines = 2;
    seatInfoLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    seatInfoLabel.text = [NSString stringWithFormat:@"%@", [self.myOrder readableSeatInfosZY]];
    [infoView addSubview:seatInfoLabel];
    [seatInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_lessThanOrEqualTo(120);
        make.top.equalTo(cinemaNameLabel);
    }];
    
    [seatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seatInfoLabel);
        make.centerY.equalTo(cinemaName);
    }];
    
    [cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(seatInfoLabel.mas_left).offset(-30);
        make.top.equalTo(startTimeLabel);
    }];
    
    [cinemaName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cinemaNameLabel);
        make.centerY.equalTo(startTime);
    }];
    
    //  影院名称
    UILabel *cinemaAllNameLabel = [[UILabel alloc] init];
    cinemaAllNameLabel.font = [UIFont systemFontOfSize:kTextSizeMovieName];
    cinemaAllNameLabel.textColor = [UIColor blackColor];
    cinemaAllNameLabel.text = plan.cinema.cinemaName;
    [infoView addSubview:cinemaAllNameLabel];
    [cinemaAllNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(162);
        make.left.mas_equalTo(15);
    }];
    
    //  地址
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    addressLabel.textColor = [UIColor lightGrayColor];
    addressLabel.text = plan.cinema.cinemaAddress;
    [infoView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cinemaAllNameLabel);
        make.right.mas_equalTo(-80);
        make.top.equalTo(cinemaAllNameLabel.mas_bottom).offset(10);
    }];
    
    //  距离
    UILabel *locationLabel = [[UILabel alloc] init];
    locationLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    locationLabel.textColor = [UIColor lightGrayColor];
    if (plan.cinema.distanceMetres.integerValue < 1000) {
        locationLabel.text = [NSString stringWithFormat:@"%ldm", plan.cinema.distanceMetres.integerValue];
    } else {
        locationLabel.text = [NSString stringWithFormat:@"%.1fkm", plan.cinema.distanceMetres.integerValue / 1000.f];
    }
    [infoView addSubview:locationLabel];
    [locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(addressLabel);
    }];
    
    UIImageView *locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OrderDetail_location"]];
    [infoView addSubview:locationIcon];
    [locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(locationLabel);
        make.right.equalTo(locationLabel.mas_left).offset(-5);
    }];
    
    //  手机号
    phoneView = [[UIView alloc] init];
    phoneView.backgroundColor = appDelegate.kkzLine;
    phoneView.layer.cornerRadius = 5;
    phoneView.layer.masksToBounds = true;
    [infoView addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(33);
    }];

    telephoneTextField = [[UITextField alloc] init];
    telephoneTextField.backgroundColor = [UIColor clearColor];
    telephoneTextField.textColor = [UIColor lightGrayColor];
    telephoneTextField.font = [UIFont systemFontOfSize:14];
    telephoneTextField.text = [DataEngine sharedDataEngine].phoneNum;
    [phoneView addSubview:telephoneTextField];
    [telephoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(phoneView);
    }];
    
    //支付方式列表
    payView = [[PayView alloc] init];
    payView.delegate = self;
    payView.orderNo = self.orderNo;
    payView.hasOrderExpired = NO;
    payView.myOrder = self.myOrder;
    payView.orderTotalFee = [self.myOrder moneyToPay];
    [payView doRedCouponTask];
    [payView doRedAccountsTask];
    [payView doPayTypeTask];
//    [holder addSubview:payView];
//    [payView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(holder);
//        make.top.equalTo(infoView.mas_bottom).offset(5);
//        make.height.mas_equalTo(500);
//    }];

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
    
    //  影票
    UIView *ticketPriceView = [[UIView alloc] init];
    ticketPriceView.backgroundColor = [UIColor whiteColor];
    [holder addSubview:ticketPriceView];
    [ticketPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(holder);
        make.height.mas_equalTo(72);
        make.top.equalTo(infoView.mas_bottom).offset(5);
    }];
    
    UILabel *ticketTitleLabel = [[UILabel alloc] init];
    ticketTitleLabel.text = @"影票";
    ticketTitleLabel.font = [UIFont systemFontOfSize:14];
    ticketTitleLabel.textColor = appDelegate.kkzGray;
    [ticketPriceView addSubview:ticketTitleLabel];
    [ticketTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(20);
    }];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = [UIColor blackColor];
    priceLabel.text = [NSString stringWithFormat:@"￥%.2fx%ld",
                       [self.myOrder.unitPrice floatValue], self.myOrder.count.integerValue];
    priceLabel.font = [UIFont systemFontOfSize:16];
    [ticketPriceView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.centerY.equalTo(ticketTitleLabel);
    }];
    
    UILabel *sumPriceLabel = [[UILabel alloc] init];
    sumPriceLabel.textColor = [UIColor blackColor];
    sumPriceLabel.text = [NSString stringWithFormat:@"小计：￥%.2f",
                          [self.myOrder.unitPrice floatValue] * self.myOrder.count.integerValue];
    sumPriceLabel.font = [UIFont systemFontOfSize:16];
    [ticketPriceView addSubview:sumPriceLabel];
    [sumPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(ticketTitleLabel);
    }];
    
    UILabel *priceAlertLabel = [[UILabel alloc] init];
    priceAlertLabel.textColor = appDelegate.kkzGray;
    priceAlertLabel.font = [UIFont systemFontOfSize:10];
    priceAlertLabel.text = @"已包含服务费";
    [ticketPriceView addSubview:priceAlertLabel];
    [priceAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sumPriceLabel);
        make.top.equalTo(sumPriceLabel.mas_bottom).offset(3);
    }];
    
    UIView *priceBottomLine = [[UIView alloc] init];
    priceBottomLine.backgroundColor = appDelegate.kkzLine;
    [ticketPriceView addSubview:priceBottomLine];
    [priceBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(ticketPriceView);
        make.height.mas_equalTo(0.5);
    }];
    
    //  优惠
    UIView *couponView = [[UIView alloc] init];
    couponView.backgroundColor = [UIColor whiteColor];
    [holder addSubview:couponView];
    [couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(holder);
        make.top.equalTo(ticketPriceView.mas_bottom);
        make.height.mas_equalTo(55);
    }];
    
    UILabel *couponTitleLabel = [[UILabel alloc] init];
    couponTitleLabel.text = @"优惠券";
    couponTitleLabel.font = [UIFont systemFontOfSize:14];
    couponTitleLabel.textColor = appDelegate.kkzGray;
    [couponView addSubview:couponTitleLabel];
    [couponTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(couponView);
    }];
    
    _couponNullLabel = [[UILabel alloc] init];
    _couponNullLabel.text = @"不可使用";
    _couponNullLabel.textColor = appDelegate.kkzGray;
    _couponNullLabel.font = [UIFont systemFontOfSize:14];
    _couponNullLabel.hidden = true;
    [couponView addSubview:_couponNullLabel];
    [_couponNullLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(110);
        make.centerY.equalTo(couponView);
    }];
    
    _couponArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowRightGray"]];
    _couponArrowView.hidden = true;
    [couponView addSubview:_couponArrowView];
    [_couponArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(couponView);
    }];
    
    _couponCountLabel = [[UILabel alloc] init];
    _couponCountLabel.textColor = appDelegate.kkzPink;
    _couponCountLabel.font = [UIFont systemFontOfSize:12];
    [couponView addSubview:_couponCountLabel];
    [_couponCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_couponArrowView.mas_left).offset(-10);
        make.centerY.equalTo(couponView);
    }];
    
    UIView *couponBottomLine = [[UIView alloc] init];
    couponBottomLine.backgroundColor = appDelegate.kkzLine;
    [couponView addSubview:couponBottomLine];
    [couponBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(couponView);
        make.height.mas_equalTo(0.5);
    }];
    
    UITapGestureRecognizer *tapCouponView1GR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCouponViewAction)];
    [couponView addGestureRecognizer:tapCouponView1GR];
    
    //  劵码
    UIView *couponView2 = [[UIView alloc] init];
    couponView2.backgroundColor = [UIColor whiteColor];
    [holder addSubview:couponView2];
    [couponView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(holder);
        make.top.equalTo(couponView.mas_bottom);
        make.height.equalTo(couponView);
    }];
    
    UILabel *coupon2TitleLabel = [[UILabel alloc] init];
    coupon2TitleLabel.text = @"兑换码";
    coupon2TitleLabel.font = [UIFont systemFontOfSize:14];
    coupon2TitleLabel.textColor = appDelegate.kkzGray;
    [couponView2 addSubview:coupon2TitleLabel];
    [coupon2TitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(couponView2);
    }];
    
    _couponNullLabel2 = [[UILabel alloc] init];
    _couponNullLabel2.text = @"不可使用";
    _couponNullLabel2.textColor = appDelegate.kkzGray;
    _couponNullLabel2.font = [UIFont systemFontOfSize:14];
    _couponNullLabel2.hidden = true;
    [couponView2 addSubview:_couponNullLabel2];
    [_couponNullLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(110);
        make.centerY.equalTo(couponView2);
    }];
    
    _couponArrowView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowRightGray"]];
    _couponArrowView2.hidden = true;
    [couponView2 addSubview:_couponArrowView2];
    [_couponArrowView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(couponView2);
    }];
    
    _couponCountLabel2 = [[UILabel alloc] init];
    _couponCountLabel2.textColor = appDelegate.kkzPink;
    _couponCountLabel2.font = [UIFont systemFontOfSize:12];
    [couponView2 addSubview:_couponCountLabel2];
    [_couponCountLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_couponArrowView2.mas_left).offset(-10);
        make.centerY.equalTo(couponView2);
    }];
    
    UITapGestureRecognizer *tapCouponView2GR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCouponView2Action)];
    [couponView2 addGestureRecognizer:tapCouponView2GR];
    
    //  储值卡
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = [UIColor whiteColor];
    [holder addSubview:cardView];
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(holder);
        make.top.equalTo(couponView2.mas_bottom).offset(10);
        make.height.equalTo(couponView2);
    }];
    
    UILabel *cardTitleLabel = [[UILabel alloc] init];
    cardTitleLabel.text = @"储值卡";
    cardTitleLabel.font = [UIFont systemFontOfSize:14];
    cardTitleLabel.textColor = appDelegate.kkzGray;
    [cardView addSubview:cardTitleLabel];
    [cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(cardView);
    }];
    
    UIImageView *cardArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowRightGray"]];
    [cardView addSubview:cardArrowView];
    [cardArrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.equalTo(cardView);
    }];
    
    UITapGestureRecognizer *tapCardViewGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCardViewAction)];
    [cardView addGestureRecognizer:tapCardViewGR];
    
    //  客服电话
    UILabel *telphoneLabel = [[UILabel alloc] init];
    telphoneLabel.text = @"客服电话 4006-888-888";
    telphoneLabel.textColor = appDelegate.kkzPink;
    telphoneLabel.font = [UIFont systemFontOfSize:15];
    [holder addSubview:telphoneLabel];
    [telphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(holder);
        make.top.equalTo(cardView.mas_bottom).offset(10);
    }];
    
    //  工作时间
    UILabel *workTimeLabel = [[UILabel alloc] init];
    workTimeLabel.text = @"工作时间：早9:00-晚22:00";
    workTimeLabel.textColor = appDelegate.kkzGray;
    workTimeLabel.font = [UIFont systemFontOfSize:15];
    [holder addSubview:workTimeLabel];
    [workTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(holder);
        make.top.equalTo(telphoneLabel.mas_bottom).offset(3);
    }];
    
    //  底部按钮
    
    CGFloat bottomY = 0;
    if (runningOniOS7) {
        bottomY = 0;
    } else {
        bottomY = 20;
    }
    UIView *payBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, screentHeight - 50 - bottomY, screentWith, 50)];
    [payBtnView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:payBtnView];

    UILabel *moneyNeedPayLbl = [[UILabel alloc] init];
    moneyNeedPayLbl.backgroundColor = [UIColor clearColor];
    moneyNeedPayLbl.textColor = [UIColor blackColor];
    moneyNeedPayLbl.textAlignment = NSTextAlignmentRight;
    moneyNeedPayLbl.text = @"实付款：";
    moneyNeedPayLbl.font = [UIFont systemFontOfSize:15];
    [payBtnView addSubview:moneyNeedPayLbl];
    [moneyNeedPayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(payBtnView);
    }];

    moneyNeedPayLabel = [[UILabel alloc] init];
    moneyNeedPayLabel.backgroundColor = [UIColor clearColor];
    moneyNeedPayLabel.textAlignment = NSTextAlignmentLeft;
    moneyNeedPayLabel.textColor = appDelegate.kkzDarkYellow;
    moneyNeedPayLabel.text = [NSString stringWithFormat:@"￥%.2f", [self.myOrder moneyToPay]];
    moneyNeedPayLabel.font = [UIFont systemFontOfSize:20];
    [payBtnView addSubview:moneyNeedPayLabel];
    [moneyNeedPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyNeedPayLbl.mas_right).offset(-5);
        make.centerY.equalTo(payBtnView);
    }];


    self.moneyNeedPayLabelY = moneyNeedPayLabel;

    seatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seatBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, screentWith-160, 50)];
    [seatBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [seatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    seatBtn.backgroundColor = [UIColor r:208 g:208 b:208];//Pay_paybutton@2x
    [seatBtn setBackgroundImage:[UIImage imageNamed:@"Pay_paybutton"] forState:UIControlStateNormal];
    seatBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    seatBtn.titleLabel.textColor = [UIColor whiteColor];
    [seatBtn addTarget:self action:@selector(payOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [payBtnView addSubview:seatBtn];

    self.seatBtnY = seatBtn;

    if (appDelegate.isAuthorized) {

        [[UserManager shareInstance] updateBalance:nil failure:nil];
    }
    
    [self loadCouponList];
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
    telephoneTextField.text = [NSString stringWithFormat:@"%@", self.myOrder.mobile];
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
    if (telephoneTextField.text.length < 11 || ![[telephoneTextField.text substringToIndex:1] isEqualToString:@"1"]) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"请输入正确的手机号码"
                              cancelButton:@"好的"];
        return;
    } else {
        BOOKING_PHONE_WRITE(telephoneTextField.text);
    }
    
    if (_isCardPay) {
        payView.ecardListStr = _couponString;
        payView.selectedMethod = PayMethodNone;
        [payView payOrder];
    } else {
        PaySecondViewController *vc = [[PaySecondViewController alloc] init];
        vc.payView = payView;
        vc.myOrder = self.myOrder;
        vc.isFromCoupon = self.isFromCoupon;
        [self.navigationController pushViewController:vc animated:true];
    }
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
            [DataEngine sharedDataEngine].phoneNum = [NSString stringWithFormat:@"%@", mobile]; //BOOKING_PHONE
        } else if (BOOKING_PHONE) {
//            telephoneField.text = BOOKING_PHONE;
        } else if (BINDING_PHONE) {
//            telephoneField.text = BINDING_PHONE;
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
        [self alipayWithUrl:payUrl andSign:sign];
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
//    [holder setContentSize:CGSizeMake(screentWith, CGRectGetMaxY(payView.frame) + 90)];
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

#pragma mark - Network - Request

- (void)loadCouponList {
    MovieRequest *request = [[MovieRequest alloc] init];
    [request queryCouponListWithGroupId:4 success:^(NSArray * _Nullable couponList) {
        NSInteger count = couponList.count;
        _couponArrowView.hidden = count == 0;
        _couponNullLabel.hidden = count > 0;
        _couponCountLabel.hidden = count == 0;
        _couponCountLabel.text = [NSString stringWithFormat:@"%ld个可用", count];
        _coupon1Count = count;
    } failure:^(NSError * _Nullable err) {
        
    }];
    
    MovieRequest *request2 = [[MovieRequest alloc] init];
    [request2 queryCouponListWithGroupId:3 success:^(NSArray * _Nullable couponList) {
        NSInteger count = couponList.count;
        _couponArrowView2.hidden = count == 0;
        _couponNullLabel2.hidden = count > 0;
        _couponCountLabel2.hidden = count == 0;
        _couponCountLabel2.text = [NSString stringWithFormat:@"%ld个可用", count];
        _coupon2Count = count;
    } failure:^(NSError * _Nullable err) {
        
    }];
}

- (void)uploadCouponCountView {
    _couponCountLabel.text = [NSString stringWithFormat:@"%ld个可用", _coupon1Count];
    _couponCountLabel2.text = [NSString stringWithFormat:@"%ld个可用", _coupon2Count];
}

- (BOOL)judgeCouponState {
    if (_selectedCouponList && _selectedCouponList.count) {
        [UIAlertView showAlertView:@"优惠券、兑换券、储值卡不能同时使用" buttonText:@"确定"];
        return true;
    }
    return false;
}

#pragma mark - TapGestureRecognizer - Action

/**
 优惠券
 */
- (void)tapCouponViewAction {
//    [self judgeCouponState];
    if (_lastCouponType == CouponType_Redeem || _lastCouponType == CouponType_Stored) {
        [UIAlertView showAlertView:@"优惠券、兑换券、储值卡不能同时使用" cancelText:@"取消" cancelTapped:^{
            return;
        } okText:@"确定" okTapped:^{
            CouponViewController *vc = [[CouponViewController alloc] init];
            vc.type = CouponType_coupon;
            vc.comefromPay = true;
            vc.delegate = self;
            vc.selectedList = _selectedCouponList;
            vc.orderId = self.orderNo;
            [self.navigationController pushViewController:vc animated:true];
            
            [self uploadCouponCountView];
        }];
    } else {
        CouponViewController *vc = [[CouponViewController alloc] init];
        vc.type = CouponType_coupon;
        vc.comefromPay = true;
        vc.delegate = self;
        vc.selectedList = _selectedCouponList;
        vc.orderId = self.orderNo;
        [self.navigationController pushViewController:vc animated:true];
        
        [self uploadCouponCountView];
    }
    
}


/**
 券码
 */
- (void)tapCouponView2Action {
//     [self judgeCouponState];
    if (_lastCouponType == CouponType_coupon || _lastCouponType == CouponType_Stored) {
        [UIAlertView showAlertView:@"优惠券、兑换券、储值卡不能同时使用" cancelText:@"取消" cancelTapped:^{
            return;
        } okText:@"确定" okTapped:^{
            CouponViewController *vc = [[CouponViewController alloc] init];
            vc.type = CouponType_Redeem;
            vc.comefromPay = true;
            vc.delegate = self;
            vc.selectedList = _selectedCouponList;
            vc.orderId = self.orderNo;
            [self.navigationController pushViewController:vc animated:true];
            [self uploadCouponCountView];
        }];
    } else {
        CouponViewController *vc = [[CouponViewController alloc] init];
        vc.type = CouponType_Redeem;
        vc.comefromPay = true;
        vc.delegate = self;
        vc.selectedList = _selectedCouponList;
        vc.orderId = self.orderNo;
        [self.navigationController pushViewController:vc animated:true];
         [self uploadCouponCountView];
    }
}

/**
 储蓄卡
 */
- (void)tapCardViewAction {
//    [self judgeCouponState];
    if (_lastCouponType == CouponType_Redeem || _lastCouponType == CouponType_coupon) {
        [UIAlertView showAlertView:@"优惠券、兑换券、储值卡不能同时使用" cancelText:@"取消" cancelTapped:^{
            return;
        } okText:@"确定" okTapped:^{
            CouponViewController *vc = [[CouponViewController alloc] init];
            vc.type = CouponType_Stored;
            vc.comefromPay = true;
            vc.delegate = self;
            vc.selectedList = _selectedCouponList;
            vc.orderId = self.orderNo;
            [self.navigationController pushViewController:vc animated:true];
            
            [self uploadCouponCountView];
        }];
    } else {
        CouponViewController *vc = [[CouponViewController alloc] init];
        vc.type = CouponType_Stored;
        vc.comefromPay = true;
        vc.delegate = self;
        vc.selectedList = _selectedCouponList;
        vc.orderId = self.orderNo;
        [self.navigationController pushViewController:vc animated:true];
        
        [self uploadCouponCountView];
    }
    
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

#pragma mark - CouponViewController - Delegate

/// 选中券
- (void)couponViewController:(CouponViewController *)viewController didSelectedCouponList:(NSArray *)list type:(CouponType)type {
    NSLog(@"selected coupon list = %@", list);
    if (list.count) {
        _lastCouponType = type;
    }
    
    NSMutableString *couponString = [[NSMutableString alloc] initWithString:@"["];
    for (NSDictionary *dic in list) {
        if (dic[@"couponId"]) {
            [couponString appendString:[NSString stringWithFormat:@"{couponid: %@},", dic[@"couponId"]]];
        }
    }
    couponString = [NSMutableString stringWithString: [couponString substringToIndex:couponString.length-1]];
    [couponString appendString:@"]"];
    
    payView.ecardListStr = couponString;
    _couponString = couponString;
    _selectedCouponList = list;
    
    if (type == CouponType_Stored) {
        _isCardPay = true;
    }
    
    //  更新价格状态
    PayTask *task = [[PayTask alloc] initCheckECard:couponString
                                           forOrder:self.orderNo
                                           groupbuy:nil
                                           finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                               
                                               [appDelegate hideIndicator];
                                               
                                               if (succeeded) {
                                                   [payView setOrderTotalFee:[userInfo[@"agio"] floatValue]];
                                                   moneyNeedPayLabel.text = [NSString stringWithFormat:@"￥%.2f", [userInfo[@"agio"] floatValue]];
                                                   NSArray *couponList = userInfo[@"coupons"];
                                                   if (couponList.count > 0) {
                                                       if (type == CouponType_coupon) {
                                                           _couponCountLabel.text = [NSString stringWithFormat:@"已使用%lu张", couponList.count];
                                                       } else if (type == CouponType_Redeem) {
                                                           _couponCountLabel2.text = [NSString stringWithFormat:@"已使用%lu张", couponList.count];
                                                       }
                                                   }
                                               } else {
                                                   [self uploadCouponCountView];
//                                                   [appDelegate showAlertViewForTaskInfo:userInfo];
                                                   _selectedCouponList = nil;
                                                   payView.ecardListStr = @"";
                                                   _couponString = @"";
                                                   [payView setOrderTotalFee:self.myOrder.money.floatValue];
                                                   moneyNeedPayLabel.text = [NSString stringWithFormat:@"￥%.2f", self.myOrder.money.floatValue];
                                               }
                                               
                                           }];
    
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        [appDelegate showIndicatorWithTitle:@"请稍候..."
                                   animated:YES
                                 fullScreen:NO
                               overKeyboard:NO
                                andAutoHide:NO];
    }
}

@end
