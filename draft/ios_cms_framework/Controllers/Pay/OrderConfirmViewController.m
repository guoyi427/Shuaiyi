//
//  PayViewController.m
//  CIASMovie
//
//  Created by cias on 2017/1/6.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderConfirmViewController.h"
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ImageEffects.h"
#import "KKZTextUtility.h"
#import "OrderDetailViewController.h"
#import "TicketWaitingViewController.h"
#import "TicketOutFailedViewController.h"
#import "ProductListView.h"
#import "OrderRequest.h"
#import "Order.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "DataEngine.h"
#import <DateEngine_KKZ/DateEngine.h>
#import "PayMethodViewController.h"
#import "VipCardPayCell.h"
#import "VipCardRequest.h"
#import "VipCard.h"
#import "VipCardListDetail.h"
#import "CouponCell.h"
#import "CinemaListViewController.h"
#import "BindCardViewController.h"
#import "UserDefault.h"
//#import <Category_KKZ/NSDictionaryExtra.h>
#import "ProductRequest.h"
#import "PlanListViewController.h"
#import "OrderConfirmViewController.h"
#import "ActivityRequest.h"
#import "CouponRequest.h"
#import "Activity.h"
#import "Coupon.h"
#import "CouponRequest.h"
#import "ChooseSeatViewController.h"
#import "XingYiPlanListViewController.h"

/*
 1.券  对  卖品 没有任何关系
 2.活动 对  卖品 不互斥，可以使用
 3.券  活动  是互斥，不能同时使用
 4.身份卡 储值卡  是互斥， 身份卡优先
 5.自营卖品和系统方储值卡互斥
 6.系统方卖品 和 任何类型储值卡都不互斥
 */


@interface OrderConfirmViewController ()

@end

@implementation OrderConfirmViewController

- (void)dealloc
{
    [timer invalidate];
    timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.navigationBar.translucent = YES;
    self.hideNavigationBar = YES;
    self.hideBackBtn = YES;
    self.view.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].tableviewBackgroundColor];
    _payMethodList = [[NSMutableArray alloc] initWithCapacity:0];
    _myCardList = [[NSMutableArray alloc] initWithCapacity:0];
    _couponList = [[NSMutableArray alloc] initWithCapacity:0];
    _myProductList = [[NSMutableArray alloc] initWithCapacity:0];
    _selectProductList = [[NSMutableArray alloc] initWithCapacity:0];
    _myDiscountCardList = [[NSMutableArray alloc] initWithCapacity:0];
    _promotionList = [[NSMutableArray alloc] initWithCapacity:0];
    _selectCouponsList = [[NSMutableArray alloc] initWithCapacity:0];
    
    [_payMethodList addObject:@0];
    self.vipCardTitle = @"不可用";
    
    selectedNum = -1;
    payMethodType = -1;
    payMethodNum = -1;
    self.selectedSection = 1;
    self.selectedCouponNum = -1;
    self.selectedPromotionIndex = -1;
    
    self.isHasProduct = NO;
    self.isHasPromotion = NO;
    self.isHasCoupon = NO;
    self.isSameCoupon = NO;
    
    [self requestTicketInfo];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (initFirst) {
        [timer invalidate];
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethod:) userInfo:nil repeats:YES];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
#if K_HENGDIAN
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#else
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#endif

    [timer invalidate];
    timer = nil;
    initFirst = YES;
    
}

- (void)setNavBarUI{
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 69)];
    self.navBar.backgroundColor = [UIColor whiteColor];
    self.navBar.alpha = 0;
    [self.view addSubview:self.navBar];
    UIView *barLine = [[UIView alloc]initWithFrame:CGRectMake(0, 68.5, kCommonScreenWidth, 0.5)];
    barLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [self.navBar addSubview:barLine];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(13.5, 27.5, 28, 28);
    [backButton setImage:[UIImage imageNamed:@"titlebar_back1"]
                forState:UIControlStateNormal];
    //    [backButton setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self
                   action:@selector(backItemClick)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backButton];
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //    self.navigationItem.leftBarButtonItem = backItem;
    
    
    UIView * customTitleView = [[UIView alloc] initWithFrame:CGRectMake(70, 20, kCommonScreenWidth-140, 44)];
    customTitleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:customTitleView];
    //    self.navigationItem.titleView = customTitleView;
    cinemaTitleLabel = [UILabel new];
    cinemaTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    cinemaTitleLabel.textAlignment = NSTextAlignmentCenter;
    cinemaTitleLabel.text = @"支付订单";
    cinemaTitleLabel.font = [UIFont systemFontOfSize:16];
    [customTitleView addSubview:cinemaTitleLabel];
    [cinemaTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(7));
        make.left.equalTo(@(0));
        make.right.equalTo(customTitleView.mas_right).offset(0);
        make.height.equalTo(@(15));
    }];
    
    movieTitleLabel = [UILabel new];
#if K_HENGDIAN
    movieTitleLabel.textColor = [UIColor colorWithHex:@"#fcc80a"];
#else
    movieTitleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor];
#endif
    movieTitleLabel.textAlignment = NSTextAlignmentCenter;
    movieTitleLabel.font = [UIFont systemFontOfSize:13];
    [customTitleView addSubview:movieTitleLabel];
    [movieTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cinemaTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(@(0));
        make.right.equalTo(customTitleView.mas_right).offset(0);
        make.height.equalTo(@(13));
    }];
    
}

- (void)setupUI{
    moviePosterImage = [UIImageView new];
    moviePosterImage.contentMode = UIViewContentModeScaleAspectFill;
    moviePosterImage.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
    moviePosterImage.clipsToBounds = YES;
    [self.view addSubview:moviePosterImage];
    [self.view sendSubviewToBack:moviePosterImage];
    [moviePosterImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.width.equalTo(self.view);
        make.height.equalTo(@(211));
    }];
    blackPosterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 211)];
    blackPosterView.backgroundColor = [UIColor blackColor];
    blackPosterView.alpha = 0.65;
    [self.view addSubview:blackPosterView];
    
    payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight-50) style:UITableViewStylePlain];
    payTableView.showsVerticalScrollIndicator = NO;
    payTableView.backgroundColor = [UIColor clearColor];//[UIColor colorWithHex:[UIConstants sharedDataEngine].tableviewBackgroundColor];
    payTableView.delegate = self;
    payTableView.dataSource = self;
    payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:payTableView];
    topHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 600)];
    topHeaderView.backgroundColor = [UIColor clearColor];
    [payTableView setTableHeaderView:topHeaderView];
    
    CGFloat positionY = 67;
    
    
    
    NSInteger leftGap = 15;
    if (Constants.isIphone5) {
        leftGap = 12;
    }
    
    movieInfoBg = [UIView new];
    [topHeaderView addSubview:movieInfoBg];
    movieInfoBg.backgroundColor = [UIColor clearColor];
    //    movieInfoBg.layer.cornerRadius = 7;
    [movieInfoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(positionY));
        make.left.equalTo(@(leftGap));
        make.width.equalTo(@(kCommonScreenWidth-leftGap*2));
        make.height.equalTo(@(270));
    }];
    //    UIImageView *hallImageView;
    UIView *upHalfView = [UIView new];
    [movieInfoBg addSubview:upHalfView];
    upHalfView.backgroundColor = [UIColor whiteColor];
    upHalfView.layer.cornerRadius = 7;
    [upHalfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth-leftGap*2));
        make.height.equalTo(@(125));
    }];
    UIView *downHalfView = [UIView new];
    [movieInfoBg addSubview:downHalfView];
    downHalfView.backgroundColor = [UIColor whiteColor];
    downHalfView.layer.cornerRadius = 7;
    [downHalfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(142));
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth-leftGap*2));
        make.height.equalTo(@(122));
    }];
    downHalfView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    downHalfView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    downHalfView.layer.shadowOpacity = 0.4;//阴影透明度，默认0
    downHalfView.layer.shadowRadius = 4;//阴影半径，默认3
    
    UIImageView *ticketbgline = [UIImageView new];
    ticketbgline.backgroundColor = [UIColor clearColor];
    ticketbgline.image = [UIImage imageNamed:@"ticketbg_line"];
    ticketbgline.contentMode = UIViewContentModeScaleAspectFit;
    [movieInfoBg addSubview:ticketbgline];
    ticketbgline.clipsToBounds = YES;
    [ticketbgline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.right.equalTo(movieInfoBg);
        if (kCommonScreenWidth>375) {
            //            make.height.equalTo(@(((kCommonScreenWidth-30)*40)/354+8));
            make.height.equalTo(@(70));
            make.top.equalTo(@(99));
        }else{
            make.top.equalTo(@(113.5));
            make.height.equalTo(@(40));
        }
    }];
    
    UIView *yellowVLine = [UIView new];
    yellowVLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [movieInfoBg addSubview:yellowVLine];
    [yellowVLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(18));
        make.left.equalTo(@(0));
        make.width.equalTo(@(5));
        make.height.equalTo(@(30));
    }];
    NSInteger leftGap1 = 20;
    if (Constants.isIphone5) {
        leftGap1 = 15;
    }
    
    movieNameLabel = [UILabel new];
    movieNameLabel.font = [UIFont systemFontOfSize:18];
    movieNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    movieNameLabel.backgroundColor = [UIColor clearColor];
    movieNameLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:movieNameLabel];
    [movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(@(18));
        make.width.equalTo(@(kCommonScreenWidth-130));
        make.height.equalTo(@(15));
    }];
    movieEngLishLabel = [UILabel new];
    movieEngLishLabel.font = [UIFont systemFontOfSize:10];
    movieEngLishLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    movieEngLishLabel.backgroundColor = [UIColor clearColor];
    movieEngLishLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:movieEngLishLabel];
    [movieEngLishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(movieNameLabel.mas_bottom).offset(6);
        make.height.equalTo(@(12));
        make.width.equalTo(@(kCommonScreenWidth-55));
    }];
    
    screenTypeLabel = [self getFlagLabelWithFont:10 withBgColor:@"#ffcc00" withTextColor:@"#000000"];
    //    screenTypeLabel.hidden = YES;
    [movieInfoBg addSubview:screenTypeLabel];
    languageLael = [self getFlagLabelWithFont:10 withBgColor:@"#333333" withTextColor:@"#FFFFFF"];
    //    languageLael.hidden = YES;
    [movieInfoBg addSubview:languageLael];
    
    CGSize languageSize = [KKZTextUtility measureText:@"英语" font:[UIFont systemFontOfSize:10]];
    languageLael.text = @"英语";
    [languageLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-leftGap));
        make.top.equalTo(@(18));
        make.width.equalTo(@(languageSize.width+8));
        make.height.equalTo(@(15));
    }];
    CGSize screenTypeSize = [KKZTextUtility measureText:@"3D|IMAX" font:[UIFont systemFontOfSize:10]];
    screenTypeLabel.text = @"3D|IMAX";
    [screenTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(languageLael.mas_left).offset(-3);
        make.top.equalTo(@(18));
        make.width.equalTo(@(screenTypeSize.width+8));
        make.height.equalTo(@(15));
    }];
    
    hallLabel = [UILabel new];
    hallLabel.font = [UIFont systemFontOfSize:10];
    hallLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    hallLabel.backgroundColor = [UIColor clearColor];
    hallLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:hallLabel];
    [hallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(movieEngLishLabel.mas_bottom).offset(17);
        make.height.equalTo(@(12));
        make.width.equalTo(@(((kCommonScreenWidth-51)*3)/8-22));
    }];
    hallNameLabel = [UILabel new];
    hallNameLabel.font = [UIFont systemFontOfSize:13];
    hallNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    hallNameLabel.backgroundColor = [UIColor clearColor];
    hallNameLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:hallNameLabel];
    [hallNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(hallLabel.mas_bottom).offset(5);
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3-22));
        make.height.equalTo(@(15));
    }];
    
    timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:timeLabel];
    timeLabel.text = @"时间";
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hallLabel.mas_right).offset(20);
        make.top.equalTo(movieEngLishLabel.mas_bottom).offset(20);
        make.height.equalTo(@(12));
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*2-16));
    }];
    timeDateLabel = [UILabel new];
    timeDateLabel.font = [UIFont systemFontOfSize:13];
    timeDateLabel.textColor = [UIColor colorWithHex:@"#333333"];
    timeDateLabel.backgroundColor = [UIColor clearColor];
    timeDateLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:timeDateLabel];
    [timeDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hallLabel.mas_right).offset(20);
        make.top.equalTo(timeLabel.mas_bottom).offset(5);
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*2));
        make.height.equalTo(@(15));
    }];
    timeHourLabel = [UILabel new];
    timeHourLabel.font = [UIFont systemFontOfSize:13];
    timeHourLabel.textColor = [UIColor colorWithHex:@"#333333"];
    timeHourLabel.backgroundColor = [UIColor clearColor];
    timeHourLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:timeHourLabel];
    [timeHourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hallLabel.mas_right).offset(22);
        make.top.equalTo(timeDateLabel.mas_bottom).offset(3);
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*2-16));
        make.height.equalTo(@(15));
    }];
    
    seatLabel = [UILabel new];
    seatLabel.font = [UIFont systemFontOfSize:10];
    seatLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    seatLabel.backgroundColor = [UIColor clearColor];
    seatLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:seatLabel];
    seatLabel.text = @"座位";
    [seatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(20);
        make.top.equalTo(movieEngLishLabel.mas_bottom).offset(20);
        make.height.equalTo(@(12));
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3-14));
    }];
    selectSeatsLabel = [UILabel new];
    selectSeatsLabel.font = [UIFont systemFontOfSize:13];
    selectSeatsLabel.textColor = [UIColor colorWithHex:@"#333333"];
    selectSeatsLabel.backgroundColor = [UIColor clearColor];
    selectSeatsLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:selectSeatsLabel];
    [selectSeatsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(20);
        make.top.equalTo(seatLabel.mas_bottom).offset(5);
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3+15));
        make.height.equalTo(@(15));
    }];
    if (Constants.isIphone5) {
        hallNameLabel.font = [UIFont systemFontOfSize:12];
        timeDateLabel.font = [UIFont systemFontOfSize:12];
        timeHourLabel.font = [UIFont systemFontOfSize:12];
        selectSeatsLabel.font = [UIFont systemFontOfSize:12];
    }
    
    cinemaNameLabel = [UILabel new];
    cinemaNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    cinemaNameLabel.textAlignment = NSTextAlignmentLeft;
    cinemaNameLabel.font = [UIFont systemFontOfSize:16];
    [movieInfoBg addSubview:cinemaNameLabel];
    
    locationImageView = [UIImageView new];
    locationImageView.backgroundColor = [UIColor clearColor];
    locationImageView.clipsToBounds = YES;
    locationImageView.image = [UIImage imageNamed:@"list_location_icon"];
    locationImageView.contentMode = UIViewContentModeScaleAspectFit;
    [movieInfoBg addSubview:locationImageView];
    
    cinemaAddressLabel = [UILabel new];
    cinemaAddressLabel.backgroundColor = [UIColor clearColor];
    cinemaAddressLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    cinemaAddressLabel.textAlignment = NSTextAlignmentLeft;
    cinemaAddressLabel.font = [UIFont systemFontOfSize:13];
    [movieInfoBg addSubview:cinemaAddressLabel];
    
    distanceLabel = [UILabel new];
    distanceLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.font = [UIFont systemFontOfSize:13];
    [movieInfoBg addSubview:distanceLabel];
    
    [cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap));
        make.top.equalTo(@(162));
        make.width.equalTo(@(kCommonScreenWidth-70));
        make.height.equalTo(@(15));
    }];
    
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap));
        make.top.equalTo(cinemaNameLabel.mas_bottom).offset(5);
        make.width.equalTo(@(12));
        make.height.equalTo(@(14));
    }];
    
    [cinemaAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImageView.mas_right).offset(5);
        make.top.equalTo(cinemaNameLabel.mas_bottom).offset(5);
        make.width.equalTo(@(kCommonScreenWidth-70-100));
        make.height.equalTo(@(15));
    }];
    
    [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(movieInfoBg.mas_right).offset(-leftGap);
        make.top.equalTo(cinemaNameLabel.mas_bottom).offset(5);
        make.width.equalTo(@(80));
        make.height.equalTo(@(15));
        
    }];
    
    UIView *telephoneBg = [UIView new];
    telephoneBg.backgroundColor = [UIColor colorWithHex:@"#f3f3f3"];
    telephoneBg.layer.cornerRadius = 4;
    telephoneBg.layer.borderColor = [UIColor colorWithHex:@"#efefef"].CGColor;
    telephoneBg.layer.borderWidth = 0.5;
    [movieInfoBg addSubview:telephoneBg];
    [telephoneBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap));
        make.top.equalTo(cinemaAddressLabel.mas_bottom).offset(15);
        make.right.equalTo(@(-15));
        make.height.equalTo(@(32));
    }];
    
    telephoneLabel = [UILabel new];
    telephoneLabel.backgroundColor = [UIColor clearColor];
    telephoneLabel.textColor = [UIColor colorWithHex:@"#999999"];
    telephoneLabel.textAlignment = NSTextAlignmentCenter;
    telephoneLabel.font = [UIFont systemFontOfSize:14];
    [telephoneBg addSubview:telephoneLabel];
    [telephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap));
        make.top.equalTo(@(0));
        make.right.equalTo(@(-leftGap1));
        make.height.equalTo(@(32));
    }];
    
    positionY += 270;
    positionY += 8;
    if (self.isHasProduct) {
        productView = [[ProductView alloc] initWithFrame:CGRectMake(0, positionY, kCommonScreenWidth, 178+30)];
        productView.delegate = self;
        productView.isFromConfirm = YES;
        [topHeaderView addSubview:productView];
        positionY += 208;
        positionY += 11;
    }
    
    infoView = [UIView new];
    [topHeaderView addSubview:infoView];
    infoView.backgroundColor = [UIColor whiteColor];
    if (self.isHasProduct) {
        [infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0));
            make.top.equalTo(productView.mas_bottom).offset(11);
            make.width.equalTo(@(kCommonScreenWidth));
            make.height.equalTo(@(47));
        }];
        
    }else{
        infoView.frame = CGRectMake(0, positionY, kCommonScreenWidth, 47);
    }
    positionY += 47;

    UIView *infoViewUpLine = [self getViewBottomLineWithSuperView:infoView withTop:0];
    ticketLabel = [UILabel new];
    ticketLabel.text = @"影票";
    ticketLabel.backgroundColor = [UIColor clearColor];
    ticketLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    ticketLabel.textAlignment = NSTextAlignmentLeft;
    ticketLabel.font = [UIFont systemFontOfSize:13];
    [infoView addSubview:ticketLabel];
    [ticketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20+leftGap));
        make.top.equalTo(@(15));
        make.width.equalTo(@(40));
        make.height.equalTo(@(15));
    }];
    ticketUnitPriceLabel = [UILabel new];
    ticketUnitPriceLabel.backgroundColor = [UIColor clearColor];
    ticketUnitPriceLabel.textColor = [UIColor colorWithHex:@"#333333"];
    ticketUnitPriceLabel.textAlignment = NSTextAlignmentLeft;
    ticketUnitPriceLabel.font = [UIFont systemFontOfSize:13];
    [infoView addSubview:ticketUnitPriceLabel];
    [ticketUnitPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ticketLabel.mas_right).offset((20+leftGap));
        make.top.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth-220));
        make.height.equalTo(@(45));
    }];
    ticketPriceLabel = [UILabel new];
    ticketPriceLabel.backgroundColor = [UIColor clearColor];
    ticketPriceLabel.textColor = [UIColor colorWithHex:@"#333333"];
    ticketPriceLabel.textAlignment = NSTextAlignmentRight;
    ticketPriceLabel.font = [UIFont systemFontOfSize:13];
    [infoView addSubview:ticketPriceLabel];
    [ticketPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-(20+leftGap)));
        make.top.equalTo(@(15));
        make.width.equalTo(@(100));
        make.height.equalTo(@(15));
    }];
    serviceLabel = [UILabel new];
    serviceLabel.text = @"已包含服务费";
    serviceLabel.backgroundColor = [UIColor clearColor];
    serviceLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    serviceLabel.textAlignment = NSTextAlignmentRight;
    serviceLabel.font = [UIFont systemFontOfSize:10];
    [infoView addSubview:serviceLabel];
    [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-(20+leftGap)));
        make.top.equalTo(ticketPriceLabel.mas_bottom);
        make.width.equalTo(@(120));
        make.height.equalTo(@(15));
    }];
    [infoView setBackgroundColor:[UIColor whiteColor]];
    if (self.isHasPromotion) {
        
        eventView = [UIView new];
        [topHeaderView addSubview:eventView];
        [eventView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(topHeaderView);
            make.top.equalTo(infoView.mas_bottom);
            make.height.equalTo(@(45));
        }];
        eventView.backgroundColor = [UIColor whiteColor];
        
        UIView *eventViewUpLine = [self getViewBottomLineWithSuperView:eventView withTop:0];
        
        eventLabel = [UILabel new];
        eventLabel.text = @"优惠";
        eventLabel.backgroundColor = [UIColor clearColor];
        eventLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        eventLabel.textAlignment = NSTextAlignmentLeft;
        eventLabel.font = [UIFont systemFontOfSize:13];
        [eventView addSubview:eventLabel];
        [eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(35));
            make.top.equalTo(@(0));
            make.width.equalTo(@(40));
            make.height.equalTo(@(45));
        }];
        eventTipLabel = [UILabel new];
        eventTipLabel.text = @"";
        eventTipLabel.backgroundColor = [UIColor clearColor];
        eventTipLabel.textColor = [UIColor colorWithHex:@"#333333"];
        eventTipLabel.textAlignment = NSTextAlignmentRight;
        eventTipLabel.font = [UIFont systemFontOfSize:13];
        [eventView addSubview:eventTipLabel];
        [eventTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(eventLabel.mas_right).offset(30);
            make.right.equalTo(@(-35));
            make.top.equalTo(@(0));
            make.height.equalTo(@(45));
        }];
        /*
        eventNumberLabel = [self getFlagLabelWithFont:10 withBgColor:@"#fc9a27" withTextColor:@"#FFFFFF"];
        [eventView addSubview:eventNumberLabel];
        CGSize numberSize = [KKZTextUtility measureText:@"10个可用" font:[UIFont systemFontOfSize:10]];
        eventTipLabel.text = @"";
        eventNumberLabel.text = @"0个可用";
        [eventNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-35));
            make.top.equalTo(@(15));
            make.width.equalTo(@(numberSize.width+8));
            make.height.equalTo(@(14));
        }];
        UIImageView *arrowImageView = [UIImageView new];
        arrowImageView.backgroundColor = [UIColor clearColor];
        arrowImageView.clipsToBounds = YES;
        arrowImageView.userInteractionEnabled = YES;
        arrowImageView.image = [UIImage imageNamed:@"home_more"];
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [eventView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-14));
            make.top.equalTo(@(16));
            make.width.equalTo(@(8));
            make.height.equalTo(@(12));
            
        }];
        UIButton *showPromotionListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        showPromotionListBtn.frame = CGRectMake(kCommonScreenWidth-30, 0, 30, 45);
        [eventView addSubview:showPromotionListBtn];
        [showPromotionListBtn addTarget:self action:@selector(showPromotionList) forControlEvents:UIControlEventTouchUpInside];
        */
        positionY += 45;
        
    }
    //优惠券
    
    couponView = [UIView new];
    [topHeaderView addSubview:couponView];
    couponView.hidden = YES;
    [couponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(topHeaderView);
        if (self.isHasPromotion) {
            make.top.equalTo(eventView.mas_bottom);
        } else {
            make.top.equalTo(infoView.mas_bottom);
        }
        make.height.equalTo(@(45));
    }];
    couponView.backgroundColor = [UIColor whiteColor];
    
    UIView *couponViewUpLine = [self getViewBottomLineWithSuperView:couponView withTop:0];
    UIView *couponViewDownLine = [self getViewBottomLineWithSuperView:couponView withTop:44.5];
    
    couponTipLabel = [UILabel new];
    couponTipLabel.text = @"券码";
    couponTipLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    couponTipLabel.textAlignment = NSTextAlignmentLeft;
    couponTipLabel.font = [UIFont systemFontOfSize:13];
    [couponView addSubview:couponTipLabel];
    [couponTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(15));
        make.left.equalTo(@(35));
        make.width.equalTo(@(60));
        make.height.equalTo(@(16));
    }];
    couponLabel = [UILabel new];
    couponLabel.text =@"";
    couponLabel.textColor = [UIColor colorWithHex:@"#333333"];
    couponLabel.textAlignment = NSTextAlignmentRight;
    couponLabel.font = [UIFont systemFontOfSize:13];
    [couponView addSubview:couponLabel];
    [couponLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(couponTipLabel.mas_right).offset(30);
        make.right.equalTo(@(-35));
        make.top.equalTo(@(0));
        make.height.equalTo(@(45));

    }];
    /*
    couponArrowImageView = [UIImageView new];
    [couponView addSubview:couponArrowImageView];
    [couponArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.top.equalTo(@(21));
        make.width.equalTo(@(10));
        make.height.equalTo(@(6));
    }];
    couponArrowImageView.image = [UIImage imageNamed:@"home_downarrow2"];
    
    //    addCouponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [couponView addSubview:addCouponBtn];
    //    [addCouponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(couponArrowImageView.mas_left).offset(-10);
    //        make.top.equalTo(@(9));
    //        make.width.equalTo(@(50));
    //        make.height.equalTo(@(28));
    //    }];
    //    addCouponBtn.layer.cornerRadius = 3;
    //    addCouponBtn.layer.borderWidth = 0.5;
    //    addCouponBtn.layer.borderColor = [UIColor colorWithHex:@"#b2b2b2"].CGColor;
    //    addCouponBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    //    [addCouponBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    //    [addCouponBtn setTitle:@"绑定" forState:UIControlStateNormal];
    //    [addCouponBtn addTarget:self action:@selector(addCouponBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    showCouponListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [couponView addSubview:showCouponListBtn];
    showCouponListBtn.backgroundColor = [UIColor clearColor];
    [showCouponListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(couponView.mas_right);
        make.top.equalTo(@(0));
        make.width.equalTo(@(30));
        make.bottom.equalTo(couponView.mas_bottom);
    }];
    [showCouponListBtn addTarget:self action:@selector(showCouponListBtnClick) forControlEvents:UIControlEventTouchUpInside];
    */
    
    couponListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 0) style:UITableViewStylePlain];
    couponListTable.showsVerticalScrollIndicator = NO;
    couponListTable.scrollEnabled = NO;
    couponListTable.backgroundColor = [UIColor whiteColor];
    couponListTable.delegate = self;
    couponListTable.dataSource = self;
    couponListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [topHeaderView addSubview:couponListTable];
    couponListTable.hidden = YES;
    
    if (self.isHasCoupon) {
        positionY += 45;
    }
    positionY += 31;
    DLog(@"positionY %f", positionY);
    topHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, positionY);
    [payTableView setTableHeaderView:topHeaderView];
    
    payMethodHeadView = [UIView new];
    [topHeaderView addSubview:payMethodHeadView];
    payMethodHeadView.backgroundColor = [UIColor clearColor];
    [payMethodHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.with.equalTo(topHeaderView);
        make.bottom.equalTo(topHeaderView.mas_bottom);
        make.height.equalTo(@(31));
    }];
    //    payMethodHeadView.frame = CGRectMake(0, positionY, kCommonScreenWidth, 31);
    //    UIView *payMethodHeadViewUpLine = [self getViewBottomLineWithSuperView:payMethodHeadView withTop:0];
    UIView *payMethodHeadViewDownLine = [self getViewBottomLineWithSuperView:payMethodHeadView withTop:30.5];
    
    payMethodTipLabel = [UILabel new];
    payMethodTipLabel.text = @"选择支付方式";
    payMethodTipLabel.backgroundColor = [UIColor clearColor];
    payMethodTipLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    payMethodTipLabel.textAlignment = NSTextAlignmentLeft;
    payMethodTipLabel.font = [UIFont systemFontOfSize:13];
    [payMethodHeadView addSubview:payMethodTipLabel];
    [payMethodTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(20+leftGap));
        make.top.equalTo(@(0));
        make.width.equalTo(@(105));
        make.height.equalTo(@(32));
    }];
    
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmOrderClick) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    [self.view addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
//更新界面数据
- (void)updateLayout{
    self.selectedSection = [self.myOrder.orderMain.payType integerValue]==9?1:0;
    self.vipCardTitle = self.myOrder.orderMain.cardNo;
    
    
    NSInteger leftGap = 15;
    if (Constants.isIphone5) {
        leftGap = 12;
    }
    
    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"movie_nopic"] newSize:moviePosterImage.frame.size bgColor:[UIColor clearColor]];
    [moviePosterImage sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:self.myOrder.orderTicket.thumbnailUrlStand] placeholderImage:placeHolderImage];
    moviePosterImage.image = [moviePosterImage.image blurryImageWithBlurLevel:0.1];
    //    OrderDetailViewController *ctr = [[OrderDetailViewController alloc] init];
    //    [self.navigationController pushViewController:ctr animated:YES];
    movieNameLabel.text = self.myOrder.orderTicket.filmName;
    movieEngLishLabel.text = self.myOrder.orderTicket.filmEnglishName;
    CGSize languageSize = [KKZTextUtility measureText:self.myOrder.orderTicket.language font:[UIFont systemFontOfSize:10]];
    languageLael.text = self.myOrder.orderTicket.language;
    [languageLael mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-leftGap));
        make.top.equalTo(@(18));
        make.width.equalTo(@(languageSize.width+8));
        make.height.equalTo(@(15));
    }];
    
    CGSize screenTypeSize = [KKZTextUtility measureText:self.myOrder.orderTicket.filmType font:[UIFont systemFontOfSize:10]];
    screenTypeLabel.text = self.myOrder.orderTicket.filmType;
    [screenTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(languageLael.mas_left).offset(-3);
        make.top.equalTo(@(18));
        make.width.equalTo(@(screenTypeSize.width+8));
        make.height.equalTo(@(15));
    }];
    hallLabel.text = @"影厅";
    hallNameLabel.text = self.myOrder.orderTicket.screenName;
    NSDate *planBeginTimeDate = [NSDate dateWithTimeIntervalSince1970:[self.myOrder.orderTicket.planBeginTime doubleValue]/1000];
    timeDateLabel.text = [[DateEngine sharedDateEngine] shortDateStringFromDate:planBeginTimeDate];
    timeHourLabel.text = [[DateEngine sharedDateEngine] shortTimeStringFromDate:planBeginTimeDate];
    
    //    timeDateLabel.text = [[DateEngine sharedDateEngine] shortDateStringFromDate:[[DateEngine sharedDateEngine] dateFromString:self.aplan.startTime]];
    //    timeHourLabel.text = [[DateEngine sharedDateEngine] shortTimeStringFromDate:[[DateEngine sharedDateEngine] dateFromString:self.aplan.startTime]];
    //    NSMutableAttributedString *seatInfoAttibutedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", self.myOrder.firstSeatInfo, self.myOrder.secondSeatInfo]];
    //    NSRange redRange1 = NSMakeRange([[seatInfoArray objectAtIndex:0] length], 1);
    //    NSRange redRange = [@"/" rangeOfString:[NSString stringWithFormat:@"%@\n%@", self.myOrder.firstSeatInfo, self.myOrder.secondSeatInfo]];
    //    NSRange redRange = NSMakeRange([[seatInfoAttibutedString string] rangeOfString:@"/"].location, [[seatInfoAttibutedString string] rangeOfString:@"/"].length);
    
    //    NSRange redRange = NSRangeFromString(@"/");
    
    //需要设置的位置
    //    [seatInfoAttibutedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"b2b2b2"] range:redRange];
    //    [selectSeatsLabel setAttributedText:seatInfoAttibutedString];
    NSArray *seatInfoArray = [self.myOrder.orderTicket.seatInfo componentsSeparatedByString:@","];

    if (seatInfoArray.count>2) {
        selectSeatsLabel.numberOfLines = 2;
        [selectSeatsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeLabel.mas_right).offset(20);
            make.top.equalTo(seatLabel.mas_bottom).offset(5);
            make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3+10));
            make.height.equalTo(@(32));
        }];
        
    }else{
        selectSeatsLabel.numberOfLines = 1;
        [selectSeatsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(timeLabel.mas_right).offset(20);
            make.top.equalTo(seatLabel.mas_bottom).offset(5);
            make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3+10));
            make.height.equalTo(@(15));
        }];
        
    }
    NSString *seatInfoString = [NSString stringWithFormat:@"%@", [seatInfoArray componentsJoinedByString:@"/"]];
    if (seatInfoArray.count>2) {
        NSString *firstSeatInfo = [NSString stringWithFormat:@"%@/%@", [seatInfoArray objectAtIndex:0],[seatInfoArray objectAtIndex:1]];
        seatInfoString = [seatInfoString stringByReplacingCharactersInRange:NSMakeRange(firstSeatInfo.length, 1) withString:@"\n"];
    }
    selectSeatsLabel.text = seatInfoString;
    cinemaNameLabel.text = self.myOrder.orderTicket.cinemaName;
    cinemaAddressLabel.text = self.myOrder.orderTicket.cinemaAddress;
    if (self.myOrder.distance.length>0) {
        distanceLabel.text = [NSString stringWithFormat:@"%@KM", self.myOrder.distance];
    }
    
    NSMutableString *telephoneString = [NSMutableString stringWithFormat:@"%@", [DataEngine sharedDataEngine].userName];
    if (telephoneString.length==11) {
        [telephoneString insertString:@" " atIndex:3];
        [telephoneString insertString:@" " atIndex:8];
    }
    if (self.isHasPromotion) {
        eventTipLabel.text = self.myOrder.discount.activityName;
    }
    if (self.isHasCoupon) {
        couponLabel.text = [NSString stringWithFormat:@"已选中%ld张券码", self.selectCouponsList.count];
    }
    telephoneLabel.text = telephoneString;
    ticketUnitPriceLabel.text = [NSString stringWithFormat:@"￥%.2fx%ld", ([self.myOrder.orderTicket.price doubleValue]/100), [seatInfoArray count]];
    ticketPriceLabel.text = [NSString stringWithFormat:@"小计:￥%.2f", ([self.myOrder.orderTicket.price doubleValue]/100)*([seatInfoArray count])];
    [confirmBtn setTitle:[NSString stringWithFormat:@"总计:￥%.2f  确认支付", [self.myOrder.totalPrice doubleValue]/100] forState:UIControlStateNormal];
    
    
    [self getFinalMoneyTay];
//    if (self.selectedSection==0) {
//        [self checkVipCardDiscount];
//    }
}
//返回按钮
- (void)backItemClick{
    //    [timer invalidate];
    //    timer = nil;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"继续下单"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action){
                                                         }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"返回"
                                                         style:UIAlertActionStyleCancel
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           [self deleteOrder];
                                                       }];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"返回后，订单不再保留" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:sureAction];
    [alertVC addAction:cancelAction];
    
    [self presentViewController:alertVC
                       animated:YES
                     completion:^{
                     }];
    
    
}
//取消订单
- (void)deleteOrder{
    //    [[UIConstants sharedDataEngine] loadingAnimation];
    
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode", ciasTenantId,@"tenantId", nil];
    
    [request requestCancelOrderParams:pagrams success:^(id _Nullable data) {
        //        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    } failure:^(NSError * _Nullable err) {
        
        //        [[UIConstants sharedDataEngine] stopLoadingAnimation];
    }];
    [[UIConstants sharedDataEngine] stopLoadingAnimation];
    if (self.isFromOrder) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        //        if (self.isFromPayView) {
        //            NSArray *viewControllers = self.navigationController.viewControllers;
        //            [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-3] animated:YES];
        //        }else{
        //            NSArray *viewControllers = self.navigationController.viewControllers;
        //            [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-4] animated:YES];
        //        }
        
        for (UIViewController *ctr in self.navigationController.viewControllers)
        {
            if ([ctr isKindOfClass:[ChooseSeatViewController class]])
            {
                [self.navigationController popToViewController:ctr animated:YES];
            }
        }
        
    }
    [weakSelf.navigationController popViewControllerAnimated:YES];
    
}

- (void)getFinalMoneyTay{
    //    float moneyToPay;//最终需要支付价格
    //    float discountMoney;//储值会员卡折扣价格
    //    float productMoney;//卖品价格
    //    float promotionMoney;//活动价格
    //    float couponMoney;//兑换券价格
    
    self.moneyToPay = [self.myOrder.totalPrice floatValue];//([self.myOrder.totalPriceTicket floatValue]+([self.myOrder.totalPriceGoods floatValue])) - (self.promotionMoney+self.couponMoney+self.discountMoney);
    if (self.moneyToPay<=0) {
        self.moneyToPay = 0;
    }
    [confirmBtn setTitle:[NSString stringWithFormat:@"总计:￥%.2f  确认支付", self.moneyToPay] forState:UIControlStateNormal];
    
}

//点击下面支付按钮
- (void)confirmOrderClick{
    
    
//    if (self.selectedSection<0) {
//        [CIASPublicUtility showAlertViewForTitle:@"" message:@"请选择支付方式" cancelButton:@"知道了"];
//        return;
//    }
    [self doPayOrder];
    //如果没有卖品就不调用saleCoupons
    //    if (self.selectProductIds.length<=0) {
    //        [self doPayOrder];
    //        return;
    //    }
    
    /*此接口不用了
     //如果有卖品就调用saleCoupons，把卖品信息传给订单
     [[UIConstants sharedDataEngine] loadingAnimation];
     OrderRequest *request = [[OrderRequest alloc] init];
     __weak __typeof(self) weakSelf = self;
     
     NSDictionary *pagramsGoods = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode", USER_CINEMAID,@"cinemaId",  self.selectProductIds,@"couponStr", nil];
     [request requestOrderGoodsCouponsParams:pagramsGoods success:^(NSDictionary *_Nullable data) {
     [[UIConstants sharedDataEngine] stopLoadingAnimation];
     [weakSelf doPayOrder];
     
     } failure:^(NSError * _Nullable err) {
     [[UIConstants sharedDataEngine] stopLoadingAnimation];
     [CIASPublicUtility showAlertViewForTaskInfo:err];
     }];
     */
}

//根据选择的sectionHeader调用不同的支付方式，会员卡/在线支付
- (void)doPayOrder{
    self.selectedSection = [self.myOrder.orderMain.payType integerValue]==9?1:0;

    //如果所有的折扣价，已经抵扣了订单价格，不需要
    if (self.selectedSection==1) {
        NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",ciasTenantId,@"tenantId", @"9",@"payType",  USER_CINEMAID,@"cinemaId",  self.selectProductIds.length <= 0? @"":self.selectProductIds,@"couponStr",self.selectCouponsString.length>0?self.selectCouponsString:@"",@"coupons", nil];
        
        [self requestOrderPay:pagrams withPayType:9];
    }else if (self.selectedSection==0){
//        if (selectedNum<0 || self.selectVipCardNo.length<=0) {
//            if (self.myCardList.count) {
//                [CIASPublicUtility showAlertViewForTitle:@"" message:@"请选择支付方式" cancelButton:@"知道了"];
//            } else {
//                [CIASPublicUtility showAlertViewForTitle:@"" message:@"请选择支付方式" cancelButton:@"知道了"];
//            }
//            return;
//        }
        [self getVipCardBalance];

    }
}

- (void)vipCardPayOrder{
    if (self.moneyToPay > [self.selectVipCardBalance floatValue]) {
        [CIASPublicUtility showAlertViewForTitle:@"" message:@"会员卡余额不足，请选择其他支付方式或者充值后再购买！" cancelButton:@"知道了"];
        return;
    }

    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",ciasTenantId,@"tenantId", @"10",@"payType", self.selectVipCardNo,@"cardNo", USER_CINEMAID,@"cinemaId",   self.selectProductIds.length <= 0? @"":self.selectProductIds,@"couponStr",self.selectCouponsString.length>0?self.selectCouponsString:@"",@"coupons", nil];
    
    [self requestOrderPay:pagrams withPayType:10];
}

//选择储值卡支付
- (void)payOrderWithVipCard:(NSString *)codeStr{
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    VipCardRequest *request = [[VipCardRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",self.myOrder.orderMain.cardNo,@"cardNo", codeStr, @"code", nil];
    
    [request requestPayOrderWithVipCardParams:pagrams success:^(NSDictionary *_Nullable data) {
        if (_codeViewForOrderConfirm) {
            [UIView animateWithDuration:.2 animations:^{
                //取消遮盖状态栏
                [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
                //隐藏背景视图，等待下次调用
                if (self.blurEffectView.superview) {
                    [self.blurEffectView removeFromSuperview];
                }
                self.blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
                //移除loginview
                if (_codeViewForOrderConfirm) {
                    [_codeViewForOrderConfirm removeFromSuperview];
                    _codeViewForOrderConfirm = nil;
                    
                }
            } completion:^(BOOL finished) {
                
            }];
//            VipCard_Store_WRITE(self.selectVipCardNo);
        }
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        confirmBtn.userInteractionEnabled = NO;
        [weakSelf refreshPayOrderDetail];
        
    } failure:^(NSError * _Nullable err) {
        for (UITextField *tf in _codeViewForOrderConfirm.pzxView.textFieldArray) {
            tf.layer.borderColor = [UIColor redColor].CGColor;
        }
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        //        OrderConfirmViewController *ctr = [[OrderConfirmViewController alloc] init];
        //        ctr.isFromPayView = YES;
        //        ctr.orderNo = self.orderNo;
        //        [self.navigationController pushViewController:ctr animated:YES];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
    
}

//储值卡余额
- (void)getVipCardBalance{
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.myOrder.orderMain.cardNo,@"cardNo",
                             nil];
    
    OrderRequest *requtest = [[OrderRequest alloc] init];
    [requtest requestOrderVipCardBalanceParams:pagrams success:^(NSDictionary * _Nullable data){
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
        self.selectVipCardBalance = [data kkz_stringForKey:@"data"];
        [self vipCardPayOrder];
    } failure:^(NSError * _Nullable err) {
        
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];

    }];
}

//支付完成后调用订单详情接口，跳转不同界面
- (void)refreshPayOrderDetail{
    //    [SVProgressHUD show];
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",ciasTenantId,@"tenantId", nil];
    
    [request requestOrderDetailParams:pagrams success:^(id _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [timer invalidate];
        timer = nil;
        Order *order = (Order *)data;
        //        weakSelf.myOrder = data;
        //        DLog(@"myOrder=%@",weakSelf.myOrder);
        //        DLog(@"myOrder=%ld",weakSelf.myOrder.status.integerValue);
        
        /*
         1：影票锁座下单
         2：第一次去支付
         4：支付成功
         5：支付成功，出票失败
         6：出票成功
         8：订单已经取消
         
         2：第一次去支付
         4：支付成功
         跳转到，支付成功，出票中界面
         6：出票成功
         跳转到出票成功界面
         5：支付成功，出票失败
         8：订单已经取消
         跳转到出票失败界面
         
         */
        //            order.orderMain.status = @5;//调页面用
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([order.orderMain.status integerValue] == 6) {
                DLog(@"OrderDetailViewController");
                
                OrderDetailViewController *ctr = [[OrderDetailViewController alloc] init];
                ctr.orderNo = weakSelf.orderNo;
                [weakSelf.navigationController pushViewController:ctr animated:YES];
                DLog(@"OrderDetailViewController");
                
            }else if ([order.orderMain.status integerValue] == 4 || [order.orderMain.status integerValue] == 2){
                DLog(@"TicketWaitingViewController");
                
                TicketWaitingViewController *ctr = [[TicketWaitingViewController alloc] init];
                ctr.orderNo = weakSelf.orderNo;
                ctr.myOrder = order;
                ctr.selectPlanDateString = self.selectPlanDateString;
                ctr.planId = self.planId;
                ctr.movieId = self.movieId;
                ctr.cinemaId = self.cinemaId;
                ctr.movieName = self.movieName;
                ctr.cinemaName = self.cinemaName;
                
                ctr.planList = self.planList;
                ctr.selectPlanDate = self.selectPlanDate;
                ctr.selectPlanTimeRow = self.selectPlanTimeRow;
                [weakSelf.navigationController pushViewController:ctr animated:YES];
                DLog(@"TicketWaitingViewController");
                
            }else if ([order.orderMain.status integerValue] == 5 || [order.orderMain.status integerValue] == 8){
                DLog(@"TicketOutFailedViewController");
                
                TicketOutFailedViewController *ctr = [[TicketOutFailedViewController alloc] init];
                ctr.orderNo = weakSelf.orderNo;
                ctr.myOrder = order;
                
                ctr.selectPlanDateString = self.selectPlanDateString;
                ctr.planId = self.planId;
                ctr.movieId = self.movieId;
                ctr.cinemaId = self.cinemaId;
                ctr.movieName = self.movieName;
                ctr.cinemaName = self.cinemaName;
                
                ctr.planList = self.planList;
                ctr.selectPlanDate = self.selectPlanDate;
                ctr.selectPlanTimeRow = self.selectPlanTimeRow;
                [weakSelf.navigationController pushViewController:ctr animated:YES];
                DLog(@"TicketOutFailedViewController");
                
            }else{
                
                TicketOutFailedViewController *ctr = [[TicketOutFailedViewController alloc] init];
                DLog(@"TicketOutFailedViewController");
                
                ctr.orderNo = weakSelf.orderNo;
                ctr.myOrder = order;
                
                ctr.selectPlanDateString = self.selectPlanDateString;
                ctr.planId = self.planId;
                ctr.movieId = self.movieId;
                ctr.cinemaId = self.cinemaId;
                ctr.movieName = self.movieName;
                ctr.cinemaName = self.cinemaName;
                
                ctr.planList = self.planList;
                ctr.selectPlanDate = self.selectPlanDate;
                ctr.selectPlanTimeRow = self.selectPlanTimeRow;
                
                [weakSelf.navigationController pushViewController:ctr animated:YES];
                DLog(@"TicketOutFailedViewController");
                
            }
            
            
        });
        
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
}

//把订单改为支付中状态接口
- (void)requestOrderPay:(NSDictionary *)pagrams withPayType:(NSInteger)payType{
    if (payType==9) {
        PayMethodViewController *ctr = [[PayMethodViewController alloc] init];
        ctr.orderNo = self.orderNo;
        ctr.isFromOrderConfirm = YES;
        ctr.isFromOrder = self.isFromOrder;
        ctr.totalMoney = self.myOrder.totalPrice;
        ctr.createTime = self.myOrder.orderTicket.createTime;
        //            ctr.myOrder = self.myOrder;
        ctr.selectPlanDateString = self.selectPlanDateString;
        ctr.planId = self.planId;
        ctr.movieId = self.movieId;
        ctr.cinemaId = self.cinemaId;
        ctr.movieName = self.movieName;
        ctr.cinemaName = self.cinemaName;
        
        ctr.planList = self.planList;
        ctr.selectPlanDate = self.selectPlanDate;
        ctr.selectPlanTimeRow = self.selectPlanTimeRow;
        [self.navigationController pushViewController:ctr animated:YES];
        
    }else if (payType==10){
        //MARK: 先加入验证码，验证成功后，执行支付方法
        //加载虚化浮层,这个浮层可以共用
        [UIView animateWithDuration:.2 animations:^{
            [[UIApplication sharedApplication].keyWindow addSubview:self.blurEffectView];
            self.blurEffectView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
        } completion:^(BOOL finished) {
            //加载登录view
            //用于遮盖状态栏
            [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelAlert];
            [[UIApplication sharedApplication].keyWindow addSubview:self.codeViewForOrderConfirm];
            
        }];
        
    }
    /*
     [[UIConstants sharedDataEngine] loadingAnimation];
     
     OrderRequest *request = [[OrderRequest alloc] init];
     __weak __typeof(self) weakSelf = self;
     
     [request requestPayOrderParams:pagrams success:^(NSDictionary *_Nullable data) {
     [[UIConstants sharedDataEngine] stopLoadingAnimation];
     if (payType==9) {
     PayMethodViewController *ctr = [[PayMethodViewController alloc] init];
     ctr.orderNo = self.orderNo;
     ctr.isFromOrderConfirm = YES;
     ctr.totalMoney = [NSString stringWithFormat:@"%.2f", [self.myOrder.receiveMoney doubleValue]/100];
     ctr.createTime = self.myOrder.orderTicket.createTime;
     //            ctr.myOrder = self.myOrder;
     ctr.selectPlanDateString = self.selectPlanDateString;
     ctr.planId = self.planId;
     ctr.movieId = self.movieId;
     ctr.cinemaId = self.cinemaId;
     ctr.movieName = self.movieName;
     ctr.cinemaName = self.cinemaName;
     
     ctr.planList = self.planList;
     ctr.selectPlanDate = self.selectPlanDate;
     ctr.selectPlanTimeRow = self.selectPlanTimeRow;
     [weakSelf.navigationController pushViewController:ctr animated:YES];
     
     }else if (payType==8){
     //MARK: 先加入验证码，验证成功后，执行支付方法
     //加载虚化浮层,这个浮层可以共用
     [UIView animateWithDuration:.2 animations:^{
     [[UIApplication sharedApplication].keyWindow addSubview:self.blurEffectView];
     self.blurEffectView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
     } completion:^(BOOL finished) {
     //加载登录view
     //用于遮盖状态栏
     [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelAlert];
     [[UIApplication sharedApplication].keyWindow addSubview:self.codeViewForOrderConfirm];
     
     }];
     
     }
     
     } failure:^(NSError * _Nullable err) {
     [[UIConstants sharedDataEngine] stopLoadingAnimation];
     [CIASPublicUtility showAlertViewForTaskInfo:err];
     
     }];
     */
}

//下单后根据订单号请求订单信息
- (void)requestTicketInfo {
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode", ciasTenantId,@"tenantId",nil];
    
    [request requestGetOrderInfoParams:pagrams success:^(id _Nullable data) {
        weakSelf.myOrder = data;
        if (self.myOrder.discount) {
            if (self.myOrder.discount.activityId.length>0 && [self.myOrder.discount.type isEqualToString:@"1"]) {
                self.isHasPromotion = YES;
                self.selectActivityId = self.myOrder.discount.activityId;
                self.selectActivityType = self.myOrder.discount.activityType;
                self.promotionMoney = [self.myOrder.activeDiscountMoney floatValue];
                self.productMoney = [self.myOrder.totalPriceGoods floatValue];
            }
        }
  
        NSDate *planBeginTimeDate = [NSDate dateWithTimeIntervalSince1970:[self.myOrder.orderTicket.planBeginTime doubleValue]/1000];
        weakSelf.selectPlanDateString = [[DateEngine sharedDateEngine] stringFromDateYYYYMMDD:planBeginTimeDate];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethod:) userInfo:nil repeats:YES];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];

        [self requestProductList];
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
        [timer invalidate];
        timer = nil;
        [weakSelf deleteOrder];
    }];
    //    [self requestDiscountVipCardList];
}
//MARK: 绑定优惠券
- (void)addCouponBtnClick {
    
}

- (void)showCouponListBtnClick {
    
    self.showCouponList = !self.showCouponList;
    
    if (self.showCouponList) {
        [self requestMyCouponList:NO];
    }else{
        couponArrowImageView.image = [UIImage imageNamed:@"home_downarrow2"];
        
        NSInteger h = topHeaderView.frame.size.height;
        
        [topHeaderView setFrame:CGRectMake(0, 0, kCommonScreenWidth, h-70.5*self.couponList.count)];
        [payTableView setTableHeaderView:topHeaderView];
        couponListTable.hidden = YES;
        [couponListTable mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(topHeaderView);
            make.top.equalTo(couponView.mas_bottom);
            make.height.equalTo(@(self.couponList.count*70.5));
        }];
        [payTableView reloadData];
    }
    
}

//MARK: 绑定会员卡
- (void)bindStoreVipCard {
    CinemaListViewController *ctr = [[CinemaListViewController alloc] init];
    ctr.isBindingCard = YES;
    ctr.selectCinemaForCardBlock = ^(NSString *cinemaId, NSString *cinemaName) {
        DLog(@"%@_%@", cinemaId,cinemaName);
        BindCardViewController *bindCard = [[BindCardViewController alloc] init];
        bindCard.cinemaName = cinemaName;
        bindCard.cinemaId = cinemaId;
        [self.navigationController pushViewController:bindCard animated:YES];
    };
    [self.navigationController pushViewController:ctr animated:YES];
}

//获取储值卡列表
- (void)requestStoreVipCardList{
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:USER_CINEMAID,@"cinemaId", nil];
    
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    [requtest requestStoreVipCardListParams:pagrams success:^(NSDictionary * _Nullable data) {
        
        VipCardListDetail *detail = (VipCardListDetail *)data;
        if (self.myCardList.count > 0) {
            self.storeVipCardType = NO;
            [self.myCardList removeAllObjects];
        }
        
        [self.myCardList addObjectsFromArray:detail.rows];
        if (self.myCardList.count>0) {
            self.vipCardTitle = @"支持使用";
            
            //            for (int i=0; i<self.myCardList.count; i++) {
            //                VipCard *card = [self.myCardList objectAtIndex:i];
            //                if ([card.cardNo isEqualToString:VipCard_Store]) {
            //                    self.selectVipCardNo = VipCard_Store;
            //                    selectedNum = i;
            //                    break;
            //                }
            //            }
        }else{
            self.vipCardTitle = @"不可用";
        }
        
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
        [payTableView reloadData];
    } failure:^(NSError * _Nullable err) {
        
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
//        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
}

//获取折扣卡列表
- (void)requestDiscountVipCardList{
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:USER_CINEMAID,@"cinemaId", nil];
    
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    [requtest requestDiscountVipCardListParams:pagrams success:^(NSDictionary * _Nullable data) {
        
        VipCardListDetail *detail = (VipCardListDetail *)data;
        if (self.myDiscountCardList.count > 0) {
            [self.myDiscountCardList removeAllObjects];
        }
        [self.myDiscountCardList addObjectsFromArray:detail.rows];
        if (self.myDiscountCardList.count>0) {
            VipCard *card = [self.myDiscountCardList objectAtIndex:0];
            eventTipLabel.text = [NSString stringWithFormat:@"%@  %@", card.useTypeName, card.cardNoView];
            eventNumberLabel.text = [NSString stringWithFormat:@"%ld个可用", self.myDiscountCardList.count];
        }else{
            eventTipLabel.text = @"";
            eventNumberLabel.text = @"0个可用";
        }
        
        [payTableView reloadData];
    } failure:^(NSError * _Nullable err) {
        eventTipLabel.text = @"";
        eventNumberLabel.text = @"0个可用";
    }];
}


//卖品列表数据接口
- (void)requestProductList{
    self.isHasProduct = NO;
    
    ProductRequest *requtest = [[ProductRequest alloc] init];
    [requtest requestProductListParams:nil success:^(NSDictionary * _Nullable data) {
        ProductListDetail *detail = (ProductListDetail *)data;
        self.productType = [detail.goodsType isEqualToString:@"2"]?YES:NO;
        if (self.myProductList.count > 0) {
            [self.myProductList removeAllObjects];
            [self.selectProductList removeAllObjects];
        }
        
        [self.myProductList addObjectsFromArray:detail.list];
        if (self.myProductList.count>0 && self.myOrder.couponsCountMap) {
            if (self.myOrder.couponsCountMap.count>0) {
                NSArray *keys = [self.myOrder.couponsCountMap allKeys];
                NSArray *values = [self.myOrder.couponsCountMap allValues];
                NSMutableString *productString = [[NSMutableString alloc] initWithCapacity:0];

                for (int i=0; i<keys.count; i++) {
                    NSString *key = [keys objectAtIndex:i];
                    NSString *value = [values objectAtIndex:i];
                    NSString *oneS = [NSString stringWithFormat:@"%@#%@", key, value];

                    for (int j=0; j<self.myProductList.count; j++) {
                        Product *product = [self.myProductList objectAtIndex:j];
                        if ([product.productId isEqualToString:key]) {
                            NSString *dd = [NSString stringWithFormat:@"%d#%@", j, value];
                            [self.selectProductList addObject:dd];
                            
                        }
                        
                    }
                    [productString appendString:oneS];
                    if (i==keys.count-1) {
                        
                    }else{
                        [productString appendString:@","];
                    }
                }
                self.selectProductIds = productString;
                self.productMoney = [self.myOrder.totalPriceGoods floatValue];
                
                self.isHasProduct = YES;
            }

        }
   
        [self setupUI];
        [self setNavBarUI];
        [self updateLayout];
        if (self.isHasProduct) {
            NSInteger h = 67+270+8+47+31;//topHeaderView.frame.size.height;
            //        NSInteger h = topHeaderView.frame.size.height;
            
            h = self.isHasPromotion?h+45:h;
            NSInteger y = productView.frame.origin.y;
            
            [topHeaderView setFrame:CGRectMake(0, 0, kCommonScreenWidth, h+33+11+145*self.selectProductList.count+30)];
            [payTableView setTableHeaderView:topHeaderView];
            [productView setFrame:CGRectMake(0, y, kCommonScreenWidth, 33+145*self.selectProductList.count+30)];
            
            productView.productList = self.myProductList;
            productView.selectProductList = self.selectProductList;
            
            [productView updateLayout];
            
            [payTableView reloadData];
        }

//        [self requestActivityList];
        [self requestMyCouponList:NO];
//        [self requestStoreVipCardList];
        
    } failure:^(NSError * _Nullable err) {
        
        [self setupUI];
        [self setNavBarUI];
        [self updateLayout];
        
//        [self requestActivityList];
        [self requestMyCouponList:NO];
//        [self requestStoreVipCardList];
        
    }];
    
}
//获取优惠活动列表
- (void)requestActivityList{
    if (initFirstPromotion) {
        [[UIConstants sharedDataEngine] loadingAnimation];
    }
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",self.myOrder.orderTicket.cinemaId,@"cinemaId", nil];
    
    ActivityRequest *requtest = [[ActivityRequest alloc] init];
    [requtest requestActivityListParams:pagrams success:^(NSArray * _Nullable data) {
        [self.promotionList removeAllObjects];
        [self.promotionList addObjectsFromArray:data];
        if (initFirstPromotion) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
        }
        
        if (self.promotionList.count>0) {
            eventNumberLabel.text = [NSString stringWithFormat:@"%ld个可用", self.promotionList.count];
            
            for (int i=0; i<self.promotionList.count; i++) {
                Activity *activity = [self.promotionList objectAtIndex:i];
                if ([self.selectActivityId isEqualToString:activity.activityId]) {
                    self.selectedPromotionIndex = i;
                    self.promotionType = [activity.platform integerValue] == 1?YES:NO;
                    self.selectActivityType = activity.activityType;
                }else{
                    
                }
            }
        }else{
            eventTipLabel.text = @"";
            eventNumberLabel.text = @"0个可用";
        }
        if (initFirstPromotion) {
            if (self.promotionList.count<=0) {
                return;
            }
            
            [self.promotionListView show];
            [_promotionListView.promotionList removeAllObjects];
            [_promotionListView.promotionList addObjectsFromArray:self.promotionList];
            _promotionListView.selectedNum = self.selectedPromotionIndex;
            _promotionListView.orderNo = self.orderNo;
            _promotionListView.selectProductIds = self.selectProductIds;
            _promotionListView.selectCouponsList = self.selectCouponsList;
            [_promotionListView updateLayout];
        }
        
        initFirstPromotion = YES;
        
        
    } failure:^(NSError * _Nullable err) {
        
        if (initFirstPromotion) {
//            [CIASPublicUtility showAlertViewForTaskInfo:err];
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
        }
        
        initFirstPromotion = YES;
    }];
}

//使用活动获取活动价格
- (void)requestUseActivity{
    
    if (self.promotionList.count>0) {
        if (self.selectedPromotionIndex==-1) {
            self.selectActivityId = @"0";
            self.selectActivityType = @"";
            eventTipLabel.text = @"";
            self.promotionType = YES;//没有选择活动随便了
            
        }else{
            Activity *activity = [self.promotionList objectAtIndex:self.selectedPromotionIndex];
            self.selectActivityId = activity.activityId;
            eventTipLabel.text = activity.activityName;
            self.selectActivityType = activity.activityType;
            self.promotionType = [activity.platform integerValue] == 1?YES:NO;
        }
        
        NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",self.selectActivityId,@"activityId", self.selectActivityType, @"activityType", self.selectProductIds.length?self.selectProductIds:@"", @"goods", nil];
        [[UIConstants sharedDataEngine] loadingAnimation];
        
        ActivityRequest *requtest = [[ActivityRequest alloc] init];
        [requtest requestUseActivityParams:pagrams success:^(NSDictionary * _Nullable data) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            
            NSDictionary *dict = [data kkz_objForKey:@"data"];
            self.promotionMoney = [[dict kkz_stringForKey:@"discountMoney"] floatValue];
            self.activityDiscountPrice = [dict kkz_stringForKey:@"discountMoney"];
            //        self.moneyToPay = [self.myOrder.totalPrice floatValue]-[discountMoney floatValue];
            [self getFinalMoneyTay];
            
        } failure:^(NSError * _Nullable err) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            
//            [CIASPublicUtility showAlertViewForTaskInfo:err];
        }];
        
    }
}

//获取优惠券列表
- (void)requestMyCouponList:(BOOL)isFirst{
    couponView.hidden = YES;
    self.isHasCoupon = NO;

    couponListTable.hidden = YES;
    if (!isFirst) {
        [[UIConstants sharedDataEngine] loadingAnimation];
    }
    //    couponArrowImageView.hidden = YES;
//    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"filter", nil];

    CouponRequest *requtest = [[CouponRequest alloc] init];
    [requtest requestMyCouponListParams:nil success:^(NSArray * _Nullable data) {
        [self.couponList removeAllObjects];
        [self.couponList addObjectsFromArray:data];
        if (!isFirst) {
            couponArrowImageView.image = [UIImage imageNamed:@"home_uparrow2"];
        }
        
        if (self.couponList.count>0 && [self.myOrder.discount.activityType isEqualToString:@"2"]) {
            self.isHasCoupon = YES;
            _selectCouponModelList = [NSMutableArray arrayWithCapacity:0];
            [self.selectCouponsList addObjectsFromArray:[self.myOrder.discount.activityId componentsSeparatedByString:@","]];
            self.selectCouponsString = self.myOrder.discount.activityId;
        }
        if (!isFirst) {
            
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            if (self.isHasCoupon) {
                couponLabel.text = [NSString stringWithFormat:@"已选中%ld张券码", (unsigned long)self.selectCouponsList.count];
                if (self.selectCouponsList.count > 0) {
                    for (int i = 0; i < self.selectCouponsList.count; i++) {
                        NSString *couponString = [self.selectCouponsList objectAtIndex:i];
//                        DLog(@"couponString%@",couponString);
                        for (int j = 0; j < self.couponList.count; j++) {
                            Coupon *coupon = [self.couponList objectAtIndex:j];
//                            DLog(@"couponString11111%@",coupon.couponNums);
                            if ([coupon.couponNums isEqualToString:couponString]) {
                                [_selectCouponModelList addObject:coupon];
                            }
                        }
                    }
                }
//                DLog(@"self.selectCouponModelList%@", self.selectCouponModelList);

                NSInteger h = topHeaderView.frame.size.height;
                
                [topHeaderView setFrame:CGRectMake(0, 0, kCommonScreenWidth, h+70.5*self.selectCouponModelList.count+45)];
                [payTableView setTableHeaderView:topHeaderView];
                couponView.hidden = NO;
                couponListTable.hidden = NO;
                [couponListTable mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.width.equalTo(topHeaderView);
                    make.top.equalTo(couponView.mas_bottom);
                    make.height.equalTo(@(self.selectCouponModelList.count*70.5));
                }];
                
                [couponListTable reloadData];
                [payTableView reloadData];
            }
      
            
        }
    } failure:^(NSError * _Nullable err) {
        //        couponArrowImageView.image = [UIImage imageNamed:@"home_downarrow2"];
        //        couponArrowImageView.hidden = NO;
        if (!isFirst) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
//            [CIASPublicUtility showAlertViewForTaskInfo:err];
            
        }
    }];
}

//订单10分钟倒计时
- (void)beforeActivityMethod:(NSTimer *)time {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *expireDate2;
    
    //    expireDate2 = [NSDate dateWithTimeIntervalSinceNow:15 * 60];
    NSDate *makeOrderTimeDate = [NSDate dateWithTimeIntervalSince1970:[self.myOrder.orderTicket.createTime doubleValue]/1000];
    expireDate2 = [makeOrderTimeDate dateByAddingTimeInterval:10 * 60];
    //    DLog(@"makeOrderTimeDate ==%@expireDate2 ==%@", makeOrderTimeDate, expireDate2);
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *d = [calendar components:unitFlags
                                      fromDate:[NSDate date]
                                        toDate:expireDate2
                                       options:0]; //计算时间差
    
    if ([d second] < 0) {
        movieTitleLabel.text = @"支付过期";
        
        [movieTitleLabel setNeedsDisplay];
        
        [timer invalidate];
        timer = nil;
        hasOrderExpired = YES;
        confirmBtn.userInteractionEnabled = NO;
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action){
                                                                 if (self.isFromOrder) {
                                                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                                                 }else{
                                                                     for (UIViewController *ctr in self.navigationController.viewControllers)
                                                                     {
                                                                         if ([ctr isKindOfClass:[XingYiPlanListViewController class]])
                                                                         {
                                                                             Constants.isShowBackBtn = YES;
                                                                             [self.navigationController popToViewController:ctr animated:YES];
                                                                         }
                                                                     }
                                                                     
                                                                     //                                                                     NSArray *viewControllers = self.navigationController.childViewControllers;
                                                                     //
                                                                     //                                                                     [self.navigationController popToViewController:[viewControllers objectAtIndex:viewControllers.count-3] animated:YES];
                                                                     //
                                                                 }
                                                             }];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的订单已过期，请重新购买" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        
        [self presentViewController:alertVC
                           animated:YES
                         completion:^{
                         }];
        
    } else {
        movieTitleLabel.text = @"距离完成支付还剩10：00";
        confirmBtn.userInteractionEnabled = YES;
        
        //倒计时显示
        //        timerLabel.font = [UIFont boldSystemFontOfSize:16];
        if ([d minute] < 10 && [d second] >= 10) {
            movieTitleLabel.text = [NSString stringWithFormat:@"距离完成支付还剩0%d:%d", (int) [d minute], (int) [d second]];
            
        } else if ([d second] < 10 && [d minute] >= 10) {
            movieTitleLabel.text = [NSString stringWithFormat:@"距离完成支付还剩%d:0%d", (int) [d minute], (int) [d second]];
            
        } else if ([d second] < 10 && [d minute] < 10) {
            movieTitleLabel.text = [NSString stringWithFormat:@"距离完成支付还剩0%d:0%d", (int) [d minute], (int) [d second]];
            
        } else {
            movieTitleLabel.text = [NSString stringWithFormat:@"距离完成支付还剩%d:%d", (int) [d minute], (int) [d second]];
        }
        if ([d second] >= 0 && [d minute] >= 15) {
            movieTitleLabel.text = @"距离完成支付还剩15：00";
        }
        //        DLog(@"movieTitleLabel.text == %@",movieTitleLabel.text);
        [movieTitleLabel setNeedsDisplay];
    }
}

//储值卡折扣价格
- (void)checkVipCardDiscount{
//    VipCard *aCard = [self.myCardList objectAtIndex:selectedNum];
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode", self.myOrder.orderMain.cardNo,@"cardNo",  nil];
    
    OrderRequest *requtest = [[OrderRequest alloc] init];
    [requtest requestOrderVipCardDiscountParams:pagrams success:^(NSDictionary * _Nullable data){
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
//        self.lastVipCardTitle = self.vipCardTitle;
//        self.lastSelectVipCardNo = self.selectVipCardNo;
//        lastSelectedNum = selectedNum;
        
        NSDictionary *dict = [data kkz_objForKey:@"data"];
        NSString *discountMoney = [dict kkz_stringForKey:@"discountMoney"];
        self.selectVipCardBalance = [dict kkz_stringForKey:@"balance"];
//        self.discountMoney = [discountMoney floatValue];
//        [self getFinalMoneyTay];
//        [payTableView reloadData];
    } failure:^(NSError * _Nullable err) {
//        self.vipCardTitle = self.lastVipCardTitle ;
//        self.selectVipCardNo = self.lastSelectVipCardNo;
//        selectedNum = lastSelectedNum;
        
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
//        [CIASPublicUtility showAlertViewForTaskInfo:err];
//        [payTableView reloadData];
        
    }];
}

//取消卡券使用
- (void)deleteEcard{
    
}

//检查卡券折扣价
- (void)checkEcard{
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode", self.selectCouponsString, @"coupons", nil];
    
    CouponRequest *requtest = [[CouponRequest alloc] init];
    [requtest requestCheckCouponParams:pagrams success:^(NSDictionary * _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
        NSDictionary *dict = [data kkz_objForKey:@"data"];
        NSString *discountMoney = [dict kkz_stringForKey:@"discountMoney"];
        self.couponMoney = [discountMoney floatValue];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
//        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
}



//储值卡cell
#pragma mark - tableView delegate
- (void)configureVipCardCell:(VipCardPayCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 8, 20, 20)];
    cell.accessoryView = imageView;
    VipCard *aCard = [self.myCardList objectAtIndex:indexPath.row];
    
    if (selectedNum == indexPath.row) {
        if ([self.selectVipCardNo isEqualToString:aCard.cardNo]) {
            
        }else{
            self.selectVipCardNo = aCard.cardNo;
            [self checkVipCardDiscount];
        }
        imageView.image = [UIImage imageNamed:@"list_selected_icon"];
        
    }else{
        imageView.image = [UIImage imageNamed:@""];
        
    }
    cell.myCard = aCard;
    [cell updateLayout];
}
//优惠券cell
- (void)configureEcardCell:(CouponCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (self.selectCouponModelList.count <= 0) {
        return;
    }
//    cell.isShow = YES;
    Coupon *acoupon = [self.selectCouponModelList objectAtIndex:indexPath.row];
    cell.myCoupon = acoupon;
    cell.isFromConfirm = YES;
    [cell updateLayout];
    
    cell.isSelect = NO;
//    for (int i=0; i<self.selectCouponsList.count; i++) {
//        NSString *couponNo = [self.selectCouponsList objectAtIndex:i];
//        if ([acoupon.couponNums isEqualToString: couponNo]) {
//            cell.isSelect = YES;
//        }else{
//            
//        }
//    }
//    [cell usedCellEcardNo];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==payTableView) {
        if (indexPath.section == 0) {
            static NSString *CellIdentifier = @"VipCardCellIdentifier";
            
            VipCardPayCell *cell = (VipCardPayCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[VipCardPayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [self configureVipCardCell:cell atIndexPath:indexPath];
            return cell;
        }
        
    }else if (tableView==couponListTable){
        static NSString *CellIdentifier = @"CouponCell";
        
        CouponCell *cell = (CouponCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[CouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [self configureEcardCell:cell atIndexPath:indexPath];
        return cell;
    }
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView==payTableView) {
        PayTypeHeaderView *headerView = [[PayTypeHeaderView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 47)];
        headerView.delegate = self;
        headerView.isSelectHeader = YES;
        headerView.payTypeNum = [self.myOrder.orderMain.payType integerValue]==9?1:0;
        headerView.cardCountList = self.myCardList;
        [headerView isSelected:(self.selectedSection == section)];
        headerView.headTitle = self.myOrder.orderMain.cardNo;
        [headerView updateLayout];
        return headerView;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView==payTableView) {
        return self.payMethodList.count;
        
    }else if (tableView==couponListTable){
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==payTableView) {
        if (section==1) {
            return 0;
        }else if (section == 0 && section == self.selectedSection){
            return self.myCardList.count;
        }
    }else if (tableView==couponListTable){
        return self.selectCouponModelList.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==payTableView) {
        if (indexPath.section==0) {
            return 47;
        }else if (indexPath.section == 1){
            return 0;
        }
        
    }else if (tableView==couponListTable){
        return 70.5;
        
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==payTableView) {
        return 47;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==payTableView) {
        if (indexPath.section==0) {
            self.lastVipCardTitle = self.vipCardTitle;
            self.lastSelectVipCardNo = self.selectVipCardNo;
            lastSelectedNum = selectedNum;
            
            if (selectedNum == indexPath.row) {
                
            }else{
                selectedNum = indexPath.row;//选中
                VipCard *aCard = [self.myCardList objectAtIndex:indexPath.row];
                self.vipCardTitle = aCard.useTypeName;
                self.selectVipCardNo = aCard.cardNo;
                [self checkVipCardDiscount];
                //                [payTableView reloadData];
            }
            
        }
        
    }else if (tableView==couponListTable){
        return;
        //活动和优惠券是互斥的
        if (self.selectActivityId.length>0) {
            [CIASPublicUtility showAlertViewForTitle:@"" message:@"不可与活动同时使用" cancelButton:@"知道了"];
            return;
        }
        CouponCell *cell = (CouponCell *)[couponListTable cellForRowAtIndexPath:indexPath];
        
        Coupon *acoupon = [self.couponList objectAtIndex:indexPath.row];
        //        self.selectCouponsString = acoupon.couponNums;
        
        if (cell.isSelect) {
            //取消使用此券
            [self.selectCouponsList removeObject:acoupon.couponNums];
            if (self.selectCouponsList.count<=0) {
                self.isAddDelet = NO;
                cell.isSelect = NO;
                
                NSString *discountMoney = @"0";
                self.couponMoney = [discountMoney floatValue];
                [couponListTable reloadData];
                couponLabel.text = @"支持使用";
                return;
            }
            [[UIConstants sharedDataEngine] loadingAnimation];
            NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode", [self.selectCouponsList componentsJoinedByString:@","], @"coupons", nil];
            
            CouponRequest *requtest = [[CouponRequest alloc] init];
            [requtest requestCheckCouponParams:pagrams success:^(NSDictionary * _Nullable data) {
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                self.isAddDelet = NO;
                cell.isSelect = NO;
                
                NSDictionary *dict = [data kkz_objForKey:@"data"];
                NSString *discountMoney = [dict kkz_stringForKey:@"discountMoney"];
                self.couponMoney = [discountMoney floatValue];
                [couponListTable reloadData];
                couponLabel.text = [NSString stringWithFormat:@"已选中%ld张券码", self.selectCouponsList.count];
                self.selectCouponsString = [self.selectCouponsList componentsJoinedByString:@","];
                [self getFinalMoneyTay];
            } failure:^(NSError * _Nullable err) {
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
//                [CIASPublicUtility showAlertViewForTaskInfo:err];
                [self.selectCouponsList addObject:acoupon.couponNums];
                //                [couponListTable reloadData];
                couponLabel.text = [NSString stringWithFormat:@"已选中%ld张券码", self.selectCouponsList.count];
                self.selectCouponsString = [self.selectCouponsList componentsJoinedByString:@","];
            }];
            
        } else {
            //一个座位最多只能使用一张优惠券
            if (self.selectCouponsList.count >= [self.myOrder.orderTicket.count integerValue]) {
                [CIASPublicUtility showAlertViewForTitle:@"" message:[NSString stringWithFormat:@"最多可以使用%ld张", [self.myOrder.orderTicket.count integerValue]] cancelButton:@"知道了"];
                return;
                
            }
            
            //使用此券
            [self.selectCouponsList addObject:acoupon.couponNums];
            
            [[UIConstants sharedDataEngine] loadingAnimation];
            NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode", [self.selectCouponsList componentsJoinedByString:@","], @"coupons", nil];
            
            CouponRequest *requtest = [[CouponRequest alloc] init];
            [requtest requestCheckCouponParams:pagrams success:^(NSDictionary * _Nullable data) {
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                self.isAddDelet = YES;
                cell.isSelect = YES;
                
                NSDictionary *dict = [data kkz_objForKey:@"data"];
                NSString *discountMoney = [dict kkz_stringForKey:@"discountMoney"];
                self.couponMoney = [discountMoney floatValue];
                [couponListTable reloadData];
                couponLabel.text = [NSString stringWithFormat:@"已选中%ld张券码", self.selectCouponsList.count];
                self.selectCouponsString = [self.selectCouponsList componentsJoinedByString:@","];
                [self getFinalMoneyTay];
                
            } failure:^(NSError * _Nullable err) {
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
//                [CIASPublicUtility showAlertViewForTaskInfo:err];
                [self.selectCouponsList removeObject:acoupon.couponNums];
                //                [couponListTable reloadData];
                //                couponLabel.text = [NSString stringWithFormat:@"已选中%ld张券码", self.selectCouponsList.count];
                self.selectCouponsString = [self.selectCouponsList componentsJoinedByString:@","];
                
            }];
        }
        
        //        [self checkEcard];
        
    }
    
}


//储值卡列表展示
- (void)showViewListWithIndex:(NSInteger)section{
    
    selectedNum = -1;
    self.selectVipCardNo = nil;
    if (section==0) {
        //活动（不包含身份卡活动）和储值卡互斥关系  自营活动只能和自营储值卡使用  系统方活动可以和任何类型储值卡匹配  （身份卡和储值卡一定互斥）
        if (self.promotionType && !self.storeVipCardType) {
            selectedNum = -1;
            self.selectVipCardNo = @"";
            if (self.selectedSection == section) {
                [self deselectCurrentSection];
            }
            self.vipCardTitle = @"不支持使用";
            
            [payTableView reloadData];
            return;
        }
        
        //第一次互斥，选择卖品 如果自营卖品和系统方会员卡列表互斥，提示不支持使用，并把之前选择的会员卡清空
        if (self.selectProductIds.length >0 && self.productType && !self.storeVipCardType) {
            selectedNum = -1;
            self.selectVipCardNo = @"";
            if (self.selectedSection == section) {
                [self deselectCurrentSection];
            }
            self.vipCardTitle = @"不支持使用";
            
            [payTableView reloadData];
            return;
        }
        //第二次互斥，身份卡活动和储值卡列表互斥，身份卡优先
        if ([self.selectActivityType isEqualToString:@"0"]) {
            [CIASPublicUtility showAlertViewForTitle:@"" message:@"此活动不能与储值卡同时使用" cancelButton:@"知道了"];
            return;
        }
    }
    if (self.selectedSection != section) {
        [self deselectCurrentSection];
        [self selectSection:section];
    } else {
        [self deselectCurrentSection];
    }
    
}

- (void)PromotionListViewDidCell:(NSInteger)selectedIndex withData:(NSDictionary *)promotionDict{
    
    self.selectedPromotionIndex = selectedIndex;
    self.promotionMoney = [[promotionDict kkz_stringForKey:@"discountMoney"] floatValue];
    self.activityDiscountPrice = [promotionDict kkz_stringForKey:@"discountMoney"];
    if (self.promotionList.count) {
        if (self.selectedPromotionIndex==-1) {
            self.selectActivityId = @"";
            eventTipLabel.text = @"";
            if (self.selectCouponModelList.count>0) {
                couponLabel.text = @"支持使用";
            }else{
                couponLabel.text = @"不可用";
            }
            if (self.myCardList) {
                self.vipCardTitle = @"支持使用";
            }else{
                self.vipCardTitle = @"不可用";
            }
        }else
        {
            Activity *activity = [self.promotionList objectAtIndex:self.selectedPromotionIndex];
            self.selectActivityId = activity.activityId;
            self.selectActivityType = activity.activityType;
            couponLabel.text = @"不支持使用";
            
            eventTipLabel.text = activity.activityName;
            if (self.selectActivityType==0) {
                //身份卡和储值卡互斥
                if (self.selectVipCardNo.length>0) {
                    self.selectVipCardNo=@"";
                    selectedNum = -1;
                    self.selectVipCardBalance = @"";
                    self.discountMoney = 0.0f;
                    
                    [payTableView reloadData];
                }
            }
        }
    }
    [self getFinalMoneyTay];
}

//tableview 删除选择 sectionHeader 优惠券  储值卡   在线支付
- (void)deselectCurrentSection {
    
    payMethodType = -1;
    if (self.selectedSection != -1) {
        NSInteger currentSection = self.selectedSection;
        self.selectedSection = -1;
        if (self.myCardList.count>0) {
            if (self.selectProductIds.length>0 && self.productType && !self.storeVipCardType) {
                self.vipCardTitle = @"不支持使用";
            }else{
                self.vipCardTitle = @"支持使用";
            }
        }else{
            self.vipCardTitle = @"不可用";
        }
        
        if (currentSection == 0) {
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            NSInteger rowCount = [payTableView numberOfRowsInSection:0];
            for (NSInteger i = 0; i < rowCount; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            [payTableView beginUpdates];
            
            NSRange range = NSMakeRange(1, 1);
            NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
            
            [payTableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
            
            [payTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationNone];
            [payTableView endUpdates];
        }else if (currentSection == 1){
            
        }else if (currentSection == 2){
            //            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            //            NSInteger rowCount = [payTableView numberOfRowsInSection:2];
            //            for (NSInteger i = 0; i < rowCount; i++) {
            //                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:2]];
            //            }
            //            [payTableView beginUpdates];
            //
            //            NSRange range = NSMakeRange(1, 1);
            //            NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
            //
            //            [payTableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
            //
            //            [payTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationNone];
            //            [payTableView endUpdates];
            
        }
        
        
        [payTableView reloadData];
        
    }
    
}
//tableview 选择 sectionHeader 优惠券  储值卡   在线支付
- (void)selectSection:(NSInteger)section {
    
    if (self.selectedSection != section && section >= 0) {
        self.selectedSection = section;
        payMethodType = section;
        if (section==0) {
            //            [self.myCardList removeAllObjects];
            //            selectedNum = 0;
            [self requestStoreVipCardList];
            
            [payTableView reloadData];
        }else if (section==1){
            
            [payTableView reloadData];
        }
    }
    
}
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *cellID = @"PayTypeCell";
 PayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
 if (cell == nil) {
 cell = [[PayTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
 }
 cell.payTypeNum = [[_payMethodList objectAtIndex:indexPath.row] integerValue];
 UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kCommonScreenWidth-55, 13, 20, 20)];
 cell.accessoryView = imageView;
 
 if (selectedNum == indexPath.row && selected && !isSame) {
 imageView.image = [UIImage imageNamed:@"list_selected_icon"];
 payMethodType = [[_payMethodList objectAtIndex:indexPath.row] integerValue];
 } else if(selectedNum == indexPath.row && !selected){
 imageView.image = [UIImage imageNamed:@"list_selected_icon"];
 payMethodType = [[_payMethodList objectAtIndex:indexPath.row] integerValue];
 }else{
 imageView.image = [UIImage imageNamed:@""];
 payMethodType = -1;
 }
 [cell updateLayout];
 
 
 return cell;
 }
 
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 return _payMethodList.count;
 }
 
 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 return 46;
 }
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
 if (selectedNum == indexPath.row) {
 isSame = !isSame;
 }else{
 isSame = NO;
 }
 
 if (!isSame) {
 selectedNum = indexPath.row;
 DLog(@"selectedNum%ld",(long)selectedNum);
 }else{
 selectedNum = -1;
 DLog(@"selectedNum%ld",(long)selectedNum);
 }
 [payTableView reloadData];
 
 }
 */

- (UIView *)getViewBottomLineWithSuperView:(UIView *)superView withTop:(NSInteger)topIndex{
    UIView *viewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, topIndex, kCommonScreenWidth, 0.5)];
    viewBottomLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [superView addSubview:viewBottomLine];
    return viewBottomLine;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 64) {
        CGFloat alpha = scrollView.contentOffset.y / 64;
        if (alpha>0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            [backButton setImage:[UIImage imageNamed:@"titlebar_back2"]
                        forState:UIControlStateNormal];
            cinemaTitleLabel.textColor = [UIColor colorWithHex:@"#333333"];
            movieTitleLabel.textColor = [UIColor colorWithHex:@"#666666"];
        }else{
            [backButton setImage:[UIImage imageNamed:@"titlebar_back1"]
                        forState:UIControlStateNormal];
            cinemaTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
#if K_HENGDIAN
            movieTitleLabel.textColor = [UIColor colorWithHex:@"#fcc80a"];
#else
            movieTitleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor];
#endif
            
        }
        if (alpha>0.7) {
            self.navBar.alpha = 0.8;
        }else{
            self.navBar.alpha = alpha;
        }
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.navBar.alpha = 0.8;
    }
    
    CGRect frameOfTopImageView = moviePosterImage.frame;
    CGFloat offsetY = scrollView.contentOffset.y + payTableView.contentInset.top;//注意
    if (offsetY>100) {
        frameOfTopImageView.origin.y = -offsetY;
        frameOfTopImageView.size.height = 211;
    }else if (offsetY <= 100 && offsetY > 0){
        frameOfTopImageView.origin.y = -offsetY;
        frameOfTopImageView.size.height = 211;
    }
    if (offsetY < 0){
        frameOfTopImageView.origin.x = offsetY;
        frameOfTopImageView.origin.y = 0;
        frameOfTopImageView.size.width = kCommonScreenWidth - offsetY*2;
        frameOfTopImageView.size.height = 211 - offsetY;
    }
    moviePosterImage.frame = frameOfTopImageView;
    blackPosterView.frame = frameOfTopImageView;
}

- (UILabel *)getFlagLabelWithFont:(float)font withBgColor:(NSString *)color withTextColor:(NSString *)textColor{
    UILabel *_activityTitle = [UILabel new];
    _activityTitle.font = [UIFont systemFontOfSize:font];
    _activityTitle.textAlignment = NSTextAlignmentCenter;
    _activityTitle.textColor = [UIColor colorWithHex:textColor];
    _activityTitle.backgroundColor = [UIColor colorWithHex:color];
    _activityTitle.layer.cornerRadius = 3.5f;
    _activityTitle.layer.masksToBounds = YES;
    return _activityTitle;
}

- (void)showProductList{
    [self.productList show];
    self.productList.productList = self.myProductList;
    [self.productList.selectProductList removeAllObjects];
    [self.productList.selectProductList addObjectsFromArray:self.selectProductList];
    
    [_productList updateLayout];
}


- (ProductListView*)productList {
    if(!_productList) {
        _productList = [[ProductListView alloc] initWithFrame:CGRectMake(0, kCommonScreenHeight-375, kCommonScreenWidth, 325+50)];
        _productList.delegate = self;
    }
    return _productList;
}

- (PromotionListView*)promotionListView {
    if(!_promotionListView) {
        _promotionListView = [[PromotionListView alloc] initWithFrame:CGRectMake(0, kCommonScreenHeight-55-75.5*3-50, kCommonScreenWidth, 55+75.5*3+50)];
        _promotionListView.delegate = self;
    }
    
    return _promotionListView;
}


- (void)showPromotionList{
    
    [self requestActivityList];
    
}
//短信验证码
- (CodeView *)codeViewForOrderConfirm {
    if (!_codeViewForOrderConfirm) {
        _codeViewForOrderConfirm = [[CodeView alloc] initWithFrame:CGRectMake((kCommonScreenWidth - 286)/2, (kCommonScreenHeight - 230 -49)/2, 286, 250) delegate:self andOrderNo:self.orderNo];
    }
    return _codeViewForOrderConfirm;
}

- (UIVisualEffectView *)blurEffectView {
    if (!_blurEffectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenWidth/2, 0, 0);
        _blurEffectView.backgroundColor = [UIColor colorWithHex:@"#000000"];
        _blurEffectView.alpha = 0.75;
    }
    return _blurEffectView;
}

- (void)ProductListViewDicts:(NSArray *)dictArray{
    [self.selectProductList removeAllObjects];
    [self.selectProductList addObjectsFromArray:dictArray];
    
    NSInteger h = 67+270+8+47+31+45;//topHeaderView.frame.size.height;
    h = self.isHasPromotion?h+45:h;
    h = self.showCouponList?h+70.5*self.couponList.count:h;
    NSInteger y = productView.frame.origin.y;
    NSMutableString *productString = [[NSMutableString alloc] initWithCapacity:0];
    
    if (self.selectProductList.count) {
        [topHeaderView setFrame:CGRectMake(0, 0, kCommonScreenWidth, h+33+11+145*self.selectProductList.count+30)];
        [payTableView setTableHeaderView:topHeaderView];
        [productView setFrame:CGRectMake(0, y, kCommonScreenWidth, 33+145*self.selectProductList.count+30)];
        float productPrice = 0.0f;
        for (int i=0; i<self.selectProductList.count; i++) {
            //字典里面存的是 object=112#3(id#number) 对应的key=index
            NSString *string = [self.selectProductList objectAtIndex:i];
            NSArray *arr = [string componentsSeparatedByString:@"#"];
            NSInteger indexNum = [[arr objectAtIndex:0] integerValue];
            
            Product *aproduct = [self.myProductList objectAtIndex:indexNum];
            productPrice = productPrice+[[aproduct.saleChannel kkz_stringForKey:@"salePrice"] floatValue]*[[arr objectAtIndex:1] integerValue];
            NSString *oneS = [NSString stringWithFormat:@"%@#%@", aproduct.productId, [arr objectAtIndex:1]];
            [productString appendString:oneS];
            if (i==self.selectProductList.count-1) {
                
            }else{
                [productString appendString:@","];
            }
            
        }
        
        self.productMoney = productPrice;
    } else {
        [topHeaderView setFrame:CGRectMake(0, 0, kCommonScreenWidth, h+178+11+30)];
        [payTableView setTableHeaderView:topHeaderView];
        [productView setFrame:CGRectMake(0, y, kCommonScreenWidth, 178+30)];
        
    }
    self.selectProductIds = productString;
    [productView.selectProductList removeAllObjects];
    [productView.selectProductList addObjectsFromArray:self.selectProductList];
    [productView updateLayout];
    [payTableView reloadData];
    
    //如果选择了储值卡列表,判断卖品和储值卡的类型是否匹配（自营-自营）（系统方-自营/系统方）
    if (self.selectProductIds.length >0 && self.productType && !self.storeVipCardType && self.selectedSection==0) {
        selectedNum = -1;
        self.selectVipCardNo = @"";
        [self deselectCurrentSection];
        self.vipCardTitle = @"不支持使用";
        
        [payTableView reloadData];
        
    }
    if (self.selectActivityId.length) {
        [self requestUseActivity];
    }
    if (self.selectProductIds.length >0) {
        if (!self.productType && self.selectVipCardNo.length&&selectedNum>-1) {
            //系统方卖品  所有的储值卡都能使用 重新获取折扣价
            [self checkVipCardDiscount];
        }else if (self.productType && self.storeVipCardType && self.selectVipCardNo.length&&selectedNum>-1)
        {//自营卖品，只能使用自营会员卡 重新获取折扣价
            [self checkVipCardDiscount];
        }
    }
    
}

//卖品列表
- (void)delegateShowProductListView{
    
    [self showProductList];
}

- (void)ProductViewDicts:(NSArray *)firstDict{
    [self.selectProductList removeAllObjects];
    [self.selectProductList addObjectsFromArray:firstDict];
    
    float productPrice = 0.0f;
    NSMutableString *productString = [[NSMutableString alloc] initWithCapacity:0];
    for (int i=0; i<self.selectProductList.count; i++) {
        //字典里面存的是 object=112#3(id#number) 对应的key=index
        NSString *string = [self.selectProductList objectAtIndex:i];
        NSArray *arr = [string componentsSeparatedByString:@"#"];
        NSInteger indexNum = [[arr objectAtIndex:0] integerValue];
        
        Product *aproduct = [self.myProductList objectAtIndex:indexNum];
        productPrice = productPrice+[[aproduct.saleChannel kkz_stringForKey:@"salePrice"] floatValue]*[[arr objectAtIndex:1] integerValue];
        NSString *oneS = [NSString stringWithFormat:@"%@#%@", aproduct.productId, [arr objectAtIndex:1]];
        if ([[arr objectAtIndex:1] integerValue] <= 0) {
            
        }else{
            [productString appendString:oneS];
            if (i==self.selectProductList.count-1) {
                
            }else{
                [productString appendString:@","];
            }
        }
        
    }
    self.selectProductIds = productString;
    self.productMoney = productPrice;
    //如果选择了储值卡列表,判断卖品和储值卡的类型是否匹配（自营-自营）（系统方-自营/系统方）
    if (self.selectProductIds.length >0 && self.productType && !self.storeVipCardType && self.selectedSection==0) {
        selectedNum = -1;
        self.selectVipCardNo = @"";
        [self deselectCurrentSection];
        self.vipCardTitle = @"不支持使用";
        
        [payTableView reloadData];
        
    }else{
        if (self.myCardList.count>0) {
            self.vipCardTitle = @"支持使用";
        }else{
            self.vipCardTitle = @"不可用";
        }
    }
    if (self.selectActivityId.length) {
        [self requestUseActivity];
    }
    if (self.selectProductIds.length >0) {
        if (!self.productType && self.selectVipCardNo.length&&selectedNum>-1) {
            //系统方卖品  所有的储值卡都能使用 重新获取折扣价
            [self checkVipCardDiscount];
        }else if (self.productType && self.storeVipCardType && self.selectVipCardNo.length&&selectedNum>-1)
        {//自营卖品，只能使用自营会员卡 重新获取折扣价
            [self checkVipCardDiscount];
        }
    }
    
    
    //    [payTableView reloadData];
    
}


//MARK: codeViewDelegate 方法
- (void)backBtnBeClickWith:(NSString *)codeStr {
    //调用支付接口
    if (_codeViewForOrderConfirm) {
        [self payOrderWithVipCard:codeStr];
    }
    
}

- (void)backBtnClickOfCodeView {
    [UIView animateWithDuration:.2 animations:^{
        //取消遮盖状态栏
        [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
        //隐藏背景视图，等待下次调用
        if (self.blurEffectView.superview) {
            [self.blurEffectView removeFromSuperview];
        }
        self.blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
        //移除loginview
        if (_codeViewForOrderConfirm) {
            [_codeViewForOrderConfirm removeFromSuperview];
            _codeViewForOrderConfirm = nil;
        }
    } completion:^(BOOL finished) {
        
    }];
    
}

@end
