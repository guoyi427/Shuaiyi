//
//  MovieProductOrderDetailViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "MovieProductOrderDetailViewController.h"
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "OrderDetailOfMovie.h"
#import <DateEngine_KKZ/DateEngine.h>
#import "OrderProduct.h"
#import "KKZTextUtility.h"

@interface MovieProductOrderDetailViewController ()<UIScrollViewDelegate>
{
    UIView *productListVw,*moreView;
}
@property (nonatomic, strong) UIScrollView *holder;
@property (nonatomic, assign) BOOL isHaveProductInOrder;
@property (nonatomic, assign) BOOL isHaveDiscountInOrder;

@property (nonatomic, strong) UIView *bgView;


@property (nonatomic, strong) UILabel *orderNoLabel;
@property (nonatomic, strong) UIImageView *movieImageView;
@property (nonatomic, strong) UILabel *cinemaNameLabel;
@property (nonatomic, strong) UILabel *totalMoneyLabel;
@property (nonatomic, strong) UIView *line1View;


@property (nonatomic, strong) UILabel *movieNameLabel;
@property (nonatomic, strong) UILabel *movieTypeLabel;
@property (nonatomic, strong) UILabel *movieLanguageLabel;
@property (nonatomic, strong) UILabel *movieEnglishNameLabel;
@property (nonatomic, strong) UILabel *movieHallLabel;
@property (nonatomic, strong) UILabel *movieHallNameLabel;
@property (nonatomic, strong) UILabel *movieTimeLabel;
@property (nonatomic, strong) UILabel *movieTimeValueLabel;
@property (nonatomic, strong) UILabel *movieSeatLabel;
@property (nonatomic, strong) UILabel *movieSeatNameLabel;

@property (nonatomic, strong) UIView *line2View;

@property (nonatomic, strong) UILabel *moviePhoneLabel;
@property (nonatomic, strong) UILabel *moviePhoneValueLabel;
@property (nonatomic, strong) UILabel *movieCodeLabel;
@property (nonatomic, strong) UILabel *movieCodeValueLabel;
@property (nonatomic, strong) UILabel *movieCode2Label;
@property (nonatomic, strong) UILabel *movieCode2ValueLabel;

@property (nonatomic, strong) UIView *line3View;

@property (nonatomic, strong) UILabel *movieOrderTimeLabel,*movieOrderTimeValueLabel;
@property (nonatomic, strong) UILabel *movieOrderStatusLabel,*movieOrderStatusValueLabel;

@property (nonatomic, strong) UIView *line4View;
@property (nonatomic, strong) UIView *discountView;
@property (nonatomic, strong) UILabel *movieDiscountLabel;

@property (nonatomic, strong) UIView *line5View;

@property (nonatomic, strong) UILabel *movieDiscountMethodLabel,*movieDiscountMethodValueLabel;
@property (nonatomic, strong) UILabel *movieDiscountMoneyLabel,*movieDiscountMoneyValueLabel;

@property (nonatomic, strong) UIView  *line6View;
@property (nonatomic, strong) UIView  *productView;
@property (nonatomic, strong) UILabel *movieProductLabel;
@property (nonatomic, strong) UIView  *line7View;
@property (nonatomic, strong) UIImageView *movieProductImageView;
@property (nonatomic, strong) UILabel *movieProductNameLabel;
@property (nonatomic, strong) UILabel *movieProductMoneyLabel;
@property (nonatomic, strong) UILabel *movieProductMoneyValueLabel;
@property (nonatomic, strong) UILabel *movieProductCountLabel;
@property (nonatomic, strong) UILabel *movieProductCountValueLabel;
@property (nonatomic, strong) UILabel *movieProductCodeLabel;
@property (nonatomic, strong) UILabel *movieProductCodeValueLabel;
@property (nonatomic, strong) UIView  *line8View;
@property (nonatomic, strong) UILabel *movieProductTimeLabel;
@property (nonatomic, strong) UILabel *movieProductTimeValueLabel;
@property (nonatomic, strong) UILabel *movieProductStatusLabel;
@property (nonatomic, strong) UILabel *movieProductStatusValueLabel;
@property (nonatomic, strong) UIView  *line9View;


@property (nonatomic, strong) UIView  *line10View;
@property (nonatomic, strong) UIView *payView;
@property (nonatomic, strong) UILabel *moviePayLabel;
@property (nonatomic, strong) UIView  *line11View;

@property (nonatomic, strong) UILabel *moviePayMethodLabel;
@property (nonatomic, strong) UILabel *moviePayMethodValueLabel;
@property (nonatomic, strong) UILabel *moviePayTotalMoneyLabel;
@property (nonatomic, strong) UILabel *moviePayTotalMoneyValueLabel;
@property (nonatomic, strong) UILabel *moviePayDiscountLabel;
@property (nonatomic, strong) UILabel *moviePayDiscountValueLabel;
@property (nonatomic, strong) UILabel *moviePayRealMoneyLabel;
@property (nonatomic, strong) UILabel *moviePayRealMoneyValueLabel;
@property (nonatomic, strong) UILabel *moviePayServiceMoneyLabel;
@property (nonatomic, strong) UIView  *line12View;
@property (nonatomic, strong) UILabel *moviePayTimeLabel;
@property (nonatomic, strong) UILabel *moviePayTimeValueLabel;
@property (nonatomic, strong) UILabel *moviePayStatusLabel;
@property (nonatomic, strong) UILabel *moviePayStatusValueLabel;

@property (nonatomic, strong) UIView  *line13View;


@end

@implementation MovieProductOrderDetailViewController


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"订单详情";
    [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.view addGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    
}

//- (NSString*) uuid {
//    CFUUIDRef puuid = CFUUIDCreate( nil );
//    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
//    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
//    CFRelease(puuid);
//    CFRelease(uuidString);
//    return result;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航条
    [self setUpNavBar];
    //    DLog(@"%@", [self uuid]);
    //MARK: 判断是否有卖品
    if (self.orderDetailOfMovie.orderDetailGoodsList.count > 0) {
        self.isHaveProductInOrder = YES;
    } else {
        self.isHaveProductInOrder = NO;
    }
    //MARK: 判断是否有优惠信息
    if (self.orderDetailOfMovie.discount.discountMoney.floatValue/100 > 0) {
        self.isHaveDiscountInOrder = YES;
    } else {
        self.isHaveDiscountInOrder = NO;
    }
    
    self.holder.delegate = self;
    
    [self.holder addSubview:self.bgView];
    [self.view addSubview:self.holder];
    
    [self.holder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.holder);
        make.width.equalTo(self.holder);
    }];
    
    //MARK: --添加订单号View
    NSString *strOfOrderNo = self.orderDetailOfMovie.orderMain.orderCode;
    NSString *orderNoStr = [NSString stringWithFormat:@"订单号: %@", [self formatOrderNo:strOfOrderNo andSpacePosition:4]];
    CGSize orderNostrSize = [KKZTextUtility measureText:orderNoStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    
    [self.bgView addSubview:self.orderNoLabel];
    self.orderNoLabel.text = orderNoStr;
    [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenHeightRate);
        make.right.equalTo(self.bgView.mas_right).offset(-15*Constants.screenWidthRate);
        make.top.equalTo(self.bgView.mas_top).offset((42 - orderNostrSize.height)*Constants.screenHeightRate/2);
        make.height.equalTo(@(orderNostrSize.height));
    }];
    
    //MARK: --订单缩略图
    [self.bgView addSubview:self.movieImageView];
    [self.movieImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.orderNoLabel.mas_bottom).offset((42 - orderNostrSize.height)*Constants.screenHeightRate/2);
        make.height.equalTo(@(127*Constants.screenHeightRate));
    }];
    UIImage *placeholderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"photo_nopic"] newSize:CGSizeMake(kCommonScreenWidth, 127*Constants.screenHeightRate) bgColor:[UIColor colorWithHex:@"#f2f4f5" a:0.9]];
    [self.movieImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:self.orderDetailOfMovie.orderTicket.thumbnailUrlStand] placeholderImage:placeholderImage];
    //    CGFloat top = 0; // 顶端盖高度
    //    CGFloat bottom = 0; // 底端盖高度
    //    CGFloat left = self.movieImageView.image.size.width/2; // 左端盖宽度
    //    CGFloat right = self.movieImageView.image.size.width/2; // 右端盖宽度
    //    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    //    // 指定为拉伸模式，伸缩后重新赋值
    //    self.movieImageView.image = [self.movieImageView.image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    //MARK: --影院及票价
    NSString *strOfCinemaLabel = self.orderDetailOfMovie.orderTicket.cinemaName;
    CGSize strOfCinemaLabelSize = [KKZTextUtility measureText:strOfCinemaLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
    
    NSString *strOfTotalMoneyLabel = self.orderDetailOfMovie.ticketPriceStr;
    CGSize strOfTotalMoneyLabelSize = [KKZTextUtility measureText:strOfTotalMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    
    CGFloat spaceValue = (61 - 5 -strOfCinemaLabelSize.height - strOfTotalMoneyLabelSize.height)/2;
    
    [self.bgView addSubview:self.cinemaNameLabel];
    self.cinemaNameLabel.text = strOfCinemaLabel;
    [self.cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.movieImageView.mas_bottom).offset(spaceValue*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfCinemaLabelSize.width+5, strOfCinemaLabelSize.height));
    }];
    
    
    [self.bgView addSubview:self.totalMoneyLabel];
    self.totalMoneyLabel.text = strOfTotalMoneyLabel;
    [self.totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.cinemaNameLabel.mas_bottom).offset(5*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfTotalMoneyLabelSize.width+5, strOfTotalMoneyLabelSize.height));
    }];
    
    [self.bgView addSubview:self.line1View];
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.top.equalTo(self.movieImageView.mas_bottom).offset(61*Constants.screenHeightRate);
        make.height.equalTo(@1);
    }];
    
    //MARK: --影片信息  影厅 座位
    [self.bgView addSubview:self.movieNameLabel];
    [self.bgView addSubview:self.movieTypeLabel];
    [self.bgView addSubview:self.movieLanguageLabel];
    [self.bgView addSubview:self.movieEnglishNameLabel];
    [self.bgView addSubview:self.movieHallLabel];
    [self.bgView addSubview:self.movieHallNameLabel];
    [self.bgView addSubview:self.movieTimeLabel];
    [self.bgView addSubview:self.movieTimeValueLabel];
    [self.bgView addSubview:self.movieSeatLabel];
    [self.bgView addSubview:self.movieSeatNameLabel];
    
    NSString *strOfMovieName = self.orderDetailOfMovie.orderTicket.filmName;
    NSString *strOfMovieType = [NSString stringWithFormat:@"%@",self.orderDetailOfMovie.orderTicket.filmType.length>0?self.orderDetailOfMovie.orderTicket.filmType:@""];
    NSString *strOfMovieLanguage = self.orderDetailOfMovie.orderTicket.language;
    NSString *strOfMovieEnglishName = self.orderDetailOfMovie.orderTicket.filmEnglishName;
    NSString *strOfMovieHallName = @"梅赛德斯奔驰听";
    NSString *strOfMovieTimeValue = @"12月12日 ";
    NSString *strOfMovieSeatName = @"18排06座/18排07座";
    
    NSString *strOfHallLabel = @"影厅";
    NSString *strOfMovieTimeLabel = @"时间";
    NSString *strOfMovieSeatLabel = @"座位";
    
    self.movieNameLabel.text = strOfMovieName;
    self.movieTypeLabel.text = strOfMovieType;
    self.movieLanguageLabel.text = strOfMovieLanguage;
    self.movieEnglishNameLabel.text = strOfMovieEnglishName;
    self.movieHallLabel.text = strOfHallLabel;
    self.movieHallNameLabel.text = self.orderDetailOfMovie.orderTicket.screenName;
    self.movieTimeLabel.text = strOfMovieTimeLabel;
    NSDate *planBeginTime = [NSDate dateWithTimeIntervalSince1970:[self.orderDetailOfMovie.orderTicket.planBeginTime longLongValue]/1000];
    self.movieTimeValueLabel.text = [[DateEngine sharedDateEngine] stringFromDate:planBeginTime withFormat:@"MM月dd日 HH:mm"];
    self.movieSeatLabel.text = strOfMovieSeatLabel;
    self.movieSeatNameLabel.text = [self getSeatInfoFormatStr:self.orderDetailOfMovie.orderTicket.seatInfo];
    //    [NSString stringWithFormat:@"%@%@%@", strOfMovieSeatName, @"8排05座/8排04座",@"8排03座"];
    
    
    CGSize strOfMovieNameSize = [KKZTextUtility measureText:strOfMovieName size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
    CGSize strOfMovieTypeSize = [KKZTextUtility measureText:strOfMovieType size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:12*Constants.screenWidthRate]];
    CGSize strOfMovieLanguageSize = [KKZTextUtility measureText:strOfMovieLanguage size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:12*Constants.screenWidthRate]];
    CGSize strOfMovieEnglishNameSize = [KKZTextUtility measureText:strOfMovieEnglishName size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
    CGSize strOfMovieHallNameSize = [KKZTextUtility measureText:strOfMovieHallName size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieTimeValueSize = [KKZTextUtility measureText:strOfMovieTimeValue size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieSeatNameSize = [KKZTextUtility measureText:strOfMovieSeatName size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfHallLabelSize = [KKZTextUtility measureText:strOfHallLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
    CGSize strOfMovieTimeLabelSize = [KKZTextUtility measureText:strOfMovieTimeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
    CGSize strOfMovieSeatLabelSize = [KKZTextUtility measureText:strOfMovieSeatLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
    
    [self.movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1View.mas_bottom).offset(15*Constants.screenHeightRate);
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieNameSize.width+5, strOfMovieNameSize.height));
    }];
    [self.movieTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1View.mas_bottom).offset(15*Constants.screenHeightRate);
        make.right.equalTo(self.bgView.mas_right).offset(-(15+6+strOfMovieLanguageSize.width)*Constants.screenWidthRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieTypeSize.width+2, strOfMovieTypeSize.height));
    }];
    [self.movieLanguageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1View.mas_bottom).offset(15*Constants.screenHeightRate);
        make.right.equalTo(self.bgView.mas_right).offset(-(13*Constants.screenWidthRate));
        make.size.mas_equalTo(CGSizeMake(strOfMovieLanguageSize.width+2, strOfMovieLanguageSize.height));
    }];
    [self.movieEnglishNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.movieNameLabel.mas_bottom).offset(5*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieEnglishNameSize.width+5, strOfMovieEnglishNameSize.height));
    }];
    [self.movieHallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.movieEnglishNameLabel.mas_bottom).offset(10*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfHallLabelSize.width+2, strOfHallLabelSize.height));
    }];
    [self.movieTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0.413*kCommonScreenWidth);
        make.top.equalTo(self.movieEnglishNameLabel.mas_bottom).offset(10*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieTimeLabelSize.width+2, strOfMovieTimeLabelSize.height));
    }];
    [self.movieSeatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0.68*kCommonScreenWidth);
        make.top.equalTo(self.movieEnglishNameLabel.mas_bottom).offset(10*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieSeatLabelSize.width+2, strOfMovieSeatLabelSize.height));
    }];
    [self.movieHallNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.movieHallLabel.mas_bottom).offset(6*Constants.screenHeightRate);
        make.width.equalTo(@(strOfMovieHallNameSize.width+5));
    }];
    [self.movieTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0.413*kCommonScreenWidth);
        make.top.equalTo(self.movieTimeLabel.mas_bottom).offset(6*Constants.screenHeightRate);
        make.width.equalTo(@(strOfMovieTimeValueSize.width+5));
    }];
    [self.movieSeatNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0.68*kCommonScreenWidth);
        make.top.equalTo(self.movieSeatLabel.mas_bottom).offset(6*Constants.screenHeightRate);
        make.width.equalTo(@(strOfMovieSeatNameSize.width+5));
    }];
    [self.bgView addSubview:self.line2View];
    //判断高度谁高
    NSString *strOfHallName = self.orderDetailOfMovie.orderTicket.screenName;
    NSDate *beginTime = [NSDate dateWithTimeIntervalSince1970:[self.orderDetailOfMovie.orderTicket.planBeginTime longLongValue]/1000];
    NSString *strOfTimeValue = [[DateEngine sharedDateEngine] stringFromDate:beginTime withFormat:@"MM月dd日 HH:mm"];
    NSString *strOfSeatValue = [self getSeatInfoFormatStr:self.orderDetailOfMovie.orderTicket.seatInfo];
    
    CGSize strOfHallNameSize = [KKZTextUtility measureText:strOfHallName size:CGSizeMake(strOfMovieHallNameSize.width, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfTimeValueSize = [KKZTextUtility measureText:strOfTimeValue size:CGSizeMake(strOfMovieTimeValueSize.width, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfSeatValueSize = [KKZTextUtility measureText:strOfSeatValue size:CGSizeMake(strOfMovieSeatNameSize.width, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    
    DLog(@"%f %f %f", strOfHallNameSize.height,strOfTimeValueSize.height,strOfSeatValueSize.height);
    
    if ((strOfHallNameSize.height >= strOfTimeValueSize.height)&&(strOfHallNameSize.height >= strOfSeatValueSize.height)) {
        [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
            make.right.equalTo(self.bgView.mas_right).offset(0);
            make.top.equalTo(self.movieHallNameLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.height.equalTo(@(0.5));
        }];
    } else if ((strOfTimeValueSize.height >= strOfHallNameSize.height)&&(strOfTimeValueSize.height >= strOfSeatValueSize.height)) {
        [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
            make.right.equalTo(self.bgView.mas_right).offset(0);
            make.top.equalTo(self.movieTimeValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.height.equalTo(@(0.5));
        }];
    }else if ((strOfSeatValueSize.height >= strOfHallNameSize.height)&&(strOfSeatValueSize.height >= strOfTimeValueSize.height)) {
        [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
            make.right.equalTo(self.bgView.mas_right).offset(0);
            make.top.equalTo(self.movieSeatNameLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.height.equalTo(@(0.5));
        }];
    }
    
    
    
    //MARK: --取票信息
    [self.bgView addSubview:self.moviePhoneLabel];
    [self.bgView addSubview:self.moviePhoneValueLabel];
    [self.bgView addSubview:self.movieCodeLabel];
    [self.bgView addSubview:self.movieCodeValueLabel];
    [self.bgView addSubview:self.movieCode2Label];
    [self.bgView addSubview:self.movieCode2ValueLabel];
    
    NSString *strOfMoviePhoneLabel = @"取票手机号";
    DLog(@"手机号:%@", self.orderDetailOfMovie.orderTicket.mobile);
    NSString *strOfMoviePhoneValueLabel =(self.orderDetailOfMovie.orderTicket.mobile.length != 11)?@"":[self formatPhoneNum:self.orderDetailOfMovie.orderTicket.mobile];
    NSString *strOfMovieCodeLabel = @"票号";
    NSString *strOfMovieCodeValueLabel = @"1234 5678";
    NSString *strOfMovieCode2Label = @"验票码";
    NSString *strOfMovieCode2ValueLabel = @"1234 5678";
    
    self.moviePhoneLabel.text = strOfMoviePhoneLabel;
    self.moviePhoneValueLabel.text = strOfMoviePhoneValueLabel;
    self.movieCodeLabel.text = strOfMovieCodeLabel;
    self.movieCodeValueLabel.text = [self formatOrderNo:self.orderDetailOfMovie.orderTicket.validCode andSpacePosition:4];
    self.movieCode2Label.text = strOfMovieCode2Label;
    if (self.orderDetailOfMovie.orderTicket.validInfoBak) {
        self.movieCode2ValueLabel.text = [self formatOrderNo:self.orderDetailOfMovie.orderTicket.validInfoBak andSpacePosition:4];
    } else {
        self.movieCode2ValueLabel.text = @"一";
    }
    
    

    
    CGSize strOfMoviePhoneLabelSize = [KKZTextUtility measureText:strOfMoviePhoneLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
    CGSize strOfMoviePhoneValueLabelSize = [KKZTextUtility measureText:strOfMoviePhoneValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    
    CGSize strOfMovieCodeLabelSize = [KKZTextUtility measureText:strOfMovieCodeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
    CGSize strOfMovieCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieCodeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    
    CGSize strOfMovieCode2LabelSize = [KKZTextUtility measureText:strOfMovieCode2Label size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
    CGSize strOfMovieCode2ValueLabelSize = [KKZTextUtility measureText:strOfMovieCode2ValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    
    [self.moviePhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.line2View.mas_bottom).offset(15*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePhoneLabelSize.width+1, strOfMoviePhoneLabelSize.height));
    }];
    [self.movieCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0.413*kCommonScreenWidth);
        make.top.equalTo(self.line2View.mas_bottom).offset(15*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCodeLabelSize.width+1, strOfMovieCodeLabelSize.height));
    }];
    [self.movieCode2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0.68*kCommonScreenWidth);
        make.top.equalTo(self.line2View.mas_bottom).offset(15*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCode2LabelSize.width+2, strOfMovieCode2LabelSize.height));
    }];
    
    [self.moviePhoneValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.moviePhoneLabel.mas_bottom).offset(6*Constants.screenHeightRate);
        make.width.equalTo(@(strOfMoviePhoneValueLabelSize.width+5));
    }];
    [self.movieCodeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0.413*kCommonScreenWidth);
        make.top.equalTo(self.movieCodeLabel.mas_bottom).offset(6*Constants.screenHeightRate);
        make.width.equalTo(@(strOfMovieCodeValueLabelSize.width+5));
    }];
    [self.movieCode2ValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(0.68*kCommonScreenWidth);
        make.top.equalTo(self.movieCode2Label.mas_bottom).offset(6*Constants.screenHeightRate);
        make.width.equalTo(@(strOfMovieCode2ValueLabelSize.width+5));
    }];
    
    [self.bgView addSubview:self.line3View];
    
    //判断高度谁高
    NSString *strOfPhoneName = (self.orderDetailOfMovie.orderTicket.mobile.length != 11)?@"":[self formatPhoneNum:self.orderDetailOfMovie.orderTicket.mobile];
    NSString *strOfCodeName= [self formatOrderNo:self.orderDetailOfMovie.orderTicket.validCode andSpacePosition:4];
//    NSString *strOfCode2Name = [self formatOrderNo:self.orderDetailOfMovie.orderTicket.validInfoBak andSpacePosition:4];
    NSString *strOfCode2Name = @"一";

    CGSize strOfPhoneNameSize = [KKZTextUtility measureText:strOfPhoneName size:CGSizeMake(strOfMoviePhoneValueLabelSize.width, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfCodeNameSize = [KKZTextUtility measureText:strOfCodeName size:CGSizeMake(strOfMovieCodeValueLabelSize.width, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfCode2NameSize = [KKZTextUtility measureText:strOfCode2Name size:CGSizeMake(strOfMovieCode2ValueLabelSize.width, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    
    DLog(@"%f %f %f", strOfPhoneNameSize.height,strOfCodeNameSize.height,strOfCode2NameSize.height);
    
    if ((strOfPhoneNameSize.height >= strOfCodeNameSize.height)&&(strOfPhoneNameSize.height >= strOfCode2NameSize.height)) {
        [self.line3View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
            make.right.equalTo(self.bgView.mas_right).offset(0);
            make.top.equalTo(self.moviePhoneValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.height.equalTo(@0.5);
        }];
    } else if ((strOfCodeNameSize.height >= strOfPhoneNameSize.height)&&(strOfCodeNameSize.height >= strOfCode2NameSize.height)) {
        [self.line3View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
            make.right.equalTo(self.bgView.mas_right).offset(0);
            make.top.equalTo(self.movieCodeValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.height.equalTo(@(0.5));
        }];
    }else if ((strOfCode2NameSize.height >= strOfPhoneNameSize.height)&&(strOfCode2NameSize.height >= strOfCodeNameSize.height)) {
        [self.line3View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
            make.right.equalTo(self.bgView.mas_right).offset(0);
            make.top.equalTo(self.movieCode2ValueLabel.mas_bottom).offset(5);
            make.height.equalTo(@(0.5));
        }];
    }
    
    
    
    
    //MARK: --下单时间和状态
    
    NSString *strOfMovieOrderTimeLabel = @"下单时间：";
    NSString *strOfMovieOrderStatusLabel = @"状态：";
    NSString *strOfMovieOrderTimeValueLabel = self.orderDetailOfMovie.orderTicket.createTime.longLongValue>0? [[DateEngine sharedDateEngine] stringFromDateY:[NSDate dateWithTimeIntervalSince1970:[self.orderDetailOfMovie.orderTicket.createTime longLongValue]/1000]]:@"一";
    NSString *strOfMovieOrderStatusValueLabel = self.orderDetailOfMovie.ticketStatus.length>0?self.orderDetailOfMovie.ticketStatus:@"一";
    
    CGSize strOfMovieOrderTimeLabelSize = [KKZTextUtility measureText:strOfMovieOrderTimeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieOrderStatusLabelSize = [KKZTextUtility measureText:strOfMovieOrderStatusLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieOrderTimeValueLabelSize = [KKZTextUtility measureText:strOfMovieOrderTimeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieOrderStatusValueLabelSize = [KKZTextUtility measureText:strOfMovieOrderStatusValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    
    [self.bgView addSubview:self.movieOrderTimeLabel];
    [self.bgView addSubview:self.movieOrderTimeValueLabel];
    [self.bgView addSubview:self.movieOrderStatusLabel];
    [self.bgView addSubview:self.movieOrderStatusValueLabel];
    
    self.movieOrderTimeLabel.text = strOfMovieOrderTimeLabel;
    self.movieOrderTimeValueLabel.text = strOfMovieOrderTimeValueLabel;
    self.movieOrderStatusLabel.text = strOfMovieOrderStatusLabel;
    self.movieOrderStatusValueLabel.text = strOfMovieOrderStatusValueLabel;
    
    [self.movieOrderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.line3View.mas_bottom).offset(15*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieOrderTimeLabelSize.width+1, strOfMovieOrderTimeLabelSize.height));
    }];
    [self.movieOrderTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
        make.top.equalTo(self.line3View.mas_bottom).offset(15*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieOrderTimeValueLabelSize.width+1, strOfMovieOrderTimeValueLabelSize.height));
    }];
    [self.movieOrderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.movieOrderTimeLabel.mas_bottom).offset(5*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieOrderStatusLabelSize.width+1, strOfMovieOrderStatusLabelSize.height));
    }];
    [self.movieOrderStatusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
        make.top.equalTo(self.movieOrderTimeValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieOrderStatusValueLabelSize.width+1, strOfMovieOrderStatusValueLabelSize.height));
    }];
    
    [self.bgView addSubview:self.line4View];
    [self.line4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.movieOrderStatusLabel.mas_bottom).offset(15*Constants.screenHeightRate);
        make.height.equalTo(@1);
    }];
    
    //    MARK: 判断是否有优惠信息
    if (self.isHaveDiscountInOrder) {
        //MARK: --订单优惠信息
        NSString *strOfMovieDiscountLabel = @"优惠信息";
        CGSize strOfMovieDiscountLabelSize = [KKZTextUtility measureText:strOfMovieDiscountLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        
        [self.bgView addSubview:self.discountView];
        [self.discountView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgView);
            make.top.equalTo(self.line4View.mas_bottom).offset(0);
            make.height.equalTo(@(30*Constants.screenHeightRate));
        }];
        [self.discountView addSubview:self.movieDiscountLabel];
        self.movieDiscountLabel.text = strOfMovieDiscountLabel;
        [self.movieDiscountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.discountView.mas_left).offset(15*Constants.screenWidthRate);
            make.top.equalTo(self.discountView.mas_top).offset((30 - strOfMovieDiscountLabelSize.height)*Constants.screenHeightRate/2);
            make.size.mas_offset(CGSizeMake(strOfMovieDiscountLabelSize.width+1, strOfMovieDiscountLabelSize.height));
        }];
        [self.bgView addSubview:self.line5View];
        [self.line5View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgView);
            make.top.equalTo(self.discountView.mas_bottom).offset(0);
            make.height.equalTo(@1);
        }];
        
        NSString *strOfMovieDiscountMethodLabel = @"优惠方式：";
        NSString *strOfMovieDiscountMethodValueLabel = self.orderDetailOfMovie.discount.activityName.length>0?self.orderDetailOfMovie.discount.activityName:@"一";
        NSString *strOfMovieDiscountMoneyLabel = @"优惠金额：";
        NSString *strOfMovieDiscountMoneyValueLabel = [NSString stringWithFormat:@"¥%.2f", self.orderDetailOfMovie.discount.discountMoney.floatValue/100];
        //
        CGSize strOfMovieDiscountMethodLabelSize = [KKZTextUtility measureText:strOfMovieDiscountMethodLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieDiscountMethodValueLabelSize = [KKZTextUtility measureText:strOfMovieDiscountMethodValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieDiscountMoneyLabelSize = [KKZTextUtility measureText:strOfMovieDiscountMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieDiscountMoneyValueLabelSize = [KKZTextUtility measureText:strOfMovieDiscountMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        
        [self.bgView addSubview:self.movieDiscountMethodLabel];
        [self.bgView addSubview:self.movieDiscountMethodValueLabel];
        [self.bgView addSubview:self.movieDiscountMoneyLabel];
        [self.bgView addSubview:self.movieDiscountMoneyValueLabel];
        
        self.movieDiscountMethodLabel.text = strOfMovieDiscountMethodLabel;
        self.movieDiscountMethodValueLabel.text = strOfMovieDiscountMethodValueLabel;
        self.movieDiscountMoneyLabel.text = strOfMovieDiscountMoneyLabel;
        self.movieDiscountMoneyValueLabel.text = strOfMovieDiscountMoneyValueLabel;
        //
        [self.movieDiscountMethodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
            make.top.equalTo(self.line5View.mas_bottom).offset(15*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(strOfMovieDiscountMethodLabelSize.width+1, strOfMovieDiscountMethodLabelSize.height));
        }];
        [self.movieDiscountMethodValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
            make.top.equalTo(self.line5View.mas_bottom).offset(15*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(strOfMovieDiscountMethodValueLabelSize.width+1, strOfMovieDiscountMethodValueLabelSize.height));
        }];
        [self.movieDiscountMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
            make.top.equalTo(self.movieDiscountMethodLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(strOfMovieDiscountMoneyLabelSize.width+1, strOfMovieDiscountMoneyLabelSize.height));
        }];
        [self.movieDiscountMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
            make.top.equalTo(self.movieDiscountMethodValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(strOfMovieDiscountMoneyValueLabelSize.width+1, strOfMovieDiscountMoneyValueLabelSize.height));
        }];
        [self.bgView addSubview:self.line6View];
        [self.line6View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgView);
            make.top.equalTo(self.movieDiscountMoneyValueLabel.mas_bottom).offset(15*Constants.screenHeightRate);
            make.height.equalTo(@1);
        }];
        
        //MARK: --判断是否有卖品，如果有，则添加，没有则不添加
        if (self.isHaveProductInOrder) {
            [self.bgView addSubview:self.productView];
            [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.line6View.mas_bottom);
                make.height.equalTo(@(30*Constants.screenHeightRate));
            }];
            NSString *strOfMovieProductLabel = @"卖品信息";
            CGSize strOfMovieProductLabelSize = [KKZTextUtility measureText:strOfMovieProductLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            [self.productView addSubview:self.movieProductLabel];
            self.movieProductLabel.text = strOfMovieProductLabel;
            [self.movieProductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.productView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.productView.mas_top).offset((30*Constants.screenHeightRate - strOfMovieProductLabelSize.height)/2);
                make.size.mas_offset(CGSizeMake(strOfMovieProductLabelSize.width+1, strOfMovieProductLabelSize.height));
            }];
            
            [self.bgView addSubview:self.line7View];
            [self.line7View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.productView.mas_top).offset(30*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            //MARK: 加载更多页面 判断
            if (self.orderDetailOfMovie.orderDetailGoodsList.count == 1) {
                
                NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:0];
                [tmpArr addObject:[self.orderDetailOfMovie.orderDetailGoodsList objectAtIndex:0]];
                
                OrderProduct *orderProduct = [tmpArr objectAtIndex:0];
                NSMutableArray *codeArr = [NSMutableArray arrayWithArray:[orderProduct.goodsCouponsCode componentsSeparatedByString:@"|"]];
                for (int i = 0; i<codeArr.count; i++) {
                    NSString *codeStr = [codeArr objectAtIndex:i];
                    NSString *tmpStr = @"";
                    if (codeStr.length>6) {
                        tmpStr = codeStr;
                    } else {
                        tmpStr = @" ";
                    }
                    [codeArr replaceObjectAtIndex:i withObject:tmpStr];
                }
                for (int  i = 0; i < codeArr.count; i++) {
                    NSString *codeSr = [codeArr objectAtIndex:i];
                    if (codeSr.length>4) {
                        NSString *formatSr = [self formatOrderNo:codeSr andSpacePosition:4];
                        //                    NSString *formatSt = [formatSr substringToIndex:formatSr.length - 1];
                        [codeArr replaceObjectAtIndex:i withObject:formatSr];
                    }
                }
                DLog(@"%@", codeArr);
                NSString *formatCodeStr = [codeArr componentsJoinedByString:@""];
                NSString *codeTmpStr = [codeArr firstObject];
                NSString *strOfMovieProductCodeLabel = @"取货码:";
                NSString *strOfMovieProductCodeValueLabel = [NSString stringWithFormat:@"%@", codeTmpStr.length > 0 ?codeTmpStr:@"一"];
                NSString *strOfMovieProductFormatCodeValueLabel = formatCodeStr.length>0?formatCodeStr:@"一";
                
                CGSize strOfMovieProductCodeLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                CGSize strOfMovieProductCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                CGSize strOfMovieProductFormatCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductFormatCodeValueLabel size:CGSizeMake(strOfMovieProductCodeValueLabelSize.width, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                
                
                productListVw = [self getProductViewWith:tmpArr];
                [self.bgView addSubview:productListVw];
                [productListVw mas_remakeConstraints:^(MASConstraintMaker *make) {
                     make.top.equalTo(self.line7View.mas_bottom);
                     make.left.right.equalTo(self.bgView);
                     make.height.equalTo(@(136*Constants.screenHeightRate+strOfMovieProductFormatCodeValueLabelSize.height - strOfMovieProductCodeLabelSize.height+5));
                 }];
                
                
                
            } else {
                NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:0];
                [tmpArr addObject:[self.orderDetailOfMovie.orderDetailGoodsList objectAtIndex:0]];
                
                OrderProduct *orderProduct = [tmpArr objectAtIndex:0];
                NSMutableArray *codeArr = [NSMutableArray arrayWithArray:[orderProduct.goodsCouponsCode componentsSeparatedByString:@"|"]];
                for (int i = 0; i<codeArr.count; i++) {
                    NSString *codeStr = [codeArr objectAtIndex:i];
                    NSString *tmpStr = @"";
                    if (codeStr.length>6) {
                        tmpStr = codeStr;
                    } else {
                        tmpStr = @" ";
                    }
                    [codeArr replaceObjectAtIndex:i withObject:tmpStr];
                }
                for (int  i = 0; i < codeArr.count; i++) {
                    NSString *codeSr = [codeArr objectAtIndex:i];
                    if (codeSr.length>4) {
                        NSString *formatSr = [self formatOrderNo:codeSr andSpacePosition:4];
                        //                    NSString *formatSt = [formatSr substringToIndex:formatSr.length - 1];
                        [codeArr replaceObjectAtIndex:i withObject:formatSr];
                    }
                    
                }
                DLog(@"%@", codeArr);
                NSString *formatCodeStr = [codeArr componentsJoinedByString:@""];
                DLog(@"%@", formatCodeStr);
                NSString *codeTmpStr = [codeArr firstObject];
                NSString *strOfMovieProductCodeLabel = @"取货码:";
                NSString *strOfMovieProductCodeValueLabel = [NSString stringWithFormat:@"%@", codeTmpStr.length > 0 ?codeTmpStr:@"一"];
                NSString *strOfMovieProductFormatCodeValueLabel = formatCodeStr.length>0?formatCodeStr:@"一";
                
                CGSize strOfMovieProductCodeLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                CGSize strOfMovieProductCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                CGSize strOfMovieProductFormatCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductFormatCodeValueLabel size:CGSizeMake(strOfMovieProductCodeValueLabelSize.width, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                
                
                productListVw = [self getProductViewWith:tmpArr];
                [self.bgView addSubview:productListVw];
                [productListVw mas_remakeConstraints:^(MASConstraintMaker *make) {
                     make.top.equalTo(self.line7View.mas_bottom);
                     make.left.right.equalTo(self.bgView);
                     make.height.equalTo(@(136*Constants.screenHeightRate+strOfMovieProductFormatCodeValueLabelSize.height - strOfMovieProductCodeLabelSize.height+5));
                 }];
                
                moreView = [[UIView alloc] init];
                moreView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
                [self.bgView addSubview:moreView];
                [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.bgView);
                    make.top.equalTo(productListVw.mas_bottom);
                    make.height.equalTo(@(41*Constants.screenHeightRate));
                }];
                
                UITapGestureRecognizer *moreViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreViewBtnClick:)];
                [moreView addGestureRecognizer:moreViewSingleTap];
                
                NSString *tipsLabelStr = @"展开其他100项卖品";
                CGSize tipsLabelStrSize = [KKZTextUtility measureText:tipsLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                UILabel *tipsLabel = [[UILabel alloc] init];
                [moreView addSubview:tipsLabel];
                tipsLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
                tipsLabel.attributedText = [KKZTextUtility getAttributeStr:[NSString stringWithFormat:@"展开其他%lu项卖品", self.orderDetailOfMovie.orderDetailGoodsList.count - 1] withStartRangeStr:@"他" withEndRangeStr:@"项" withFormalColor:[UIColor colorWithHex:@"#333333"] withSpecialColor:[UIColor colorWithHex:@"#ff9900"] withFont:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];

                [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(moreView.mas_left).offset(15*Constants.screenWidthRate);
                    make.top.equalTo(moreView.mas_top).offset(15*Constants.screenHeightRate);
                    make.size.mas_equalTo(CGSizeMake(tipsLabelStrSize.width+5, tipsLabelStrSize.height));
                }];
                UIImage *moreImage = [UIImage imageNamed:@"details_downarrow"];
                UIImageView *moreImageView = [[UIImageView alloc] init];
                [moreView addSubview:moreImageView];
                moreImageView.image = moreImage;
                [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(moreView.mas_top).offset((41 - moreImage.size.height)/2*Constants.screenHeightRate);
                    make.right.equalTo(moreView.mas_right).offset(-15*Constants.screenWidthRate);
                    make.size.mas_equalTo(CGSizeMake(moreImage.size.width*Constants.screenWidthRate, moreImage.size.height*Constants.screenHeightRate));
                }];
                UIView *lineVw2 = [[UIView alloc] init];
                lineVw2.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
                [moreView addSubview:lineVw2];
                [lineVw2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.bgView);
                    make.top.equalTo(moreView.mas_top).offset(41*Constants.screenHeightRate);
                    make.height.equalTo(@1);
                }];
            }
            
            NSString *strOfMovieProductTimeLabel = @"下单时间：";
            NSString *strOfMovieProductStatusLabel = @"状态：";
            
            NSString *strOfMovieProductTimeValueLabel = @"2017-01-17 14:30";
            NSString *strOfMovieProductStatusValueLabel = @"已完成";
            
            
            CGSize strOfMovieProductTimeLabelSize = [KKZTextUtility measureText:strOfMovieProductTimeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMovieProductStatusLabelSize = [KKZTextUtility measureText:strOfMovieProductStatusLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            
            CGSize strOfMovieProductTimeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductTimeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMovieProductStatusValueLabelSize = [KKZTextUtility measureText:strOfMovieProductStatusValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            //MARK: 卖品缩略图
            [self.bgView addSubview:self.movieProductTimeLabel];
            [self.bgView addSubview:self.movieProductTimeValueLabel];
            [self.bgView addSubview:self.movieProductStatusLabel];
            [self.bgView addSubview:self.movieProductStatusValueLabel];
            
            self.movieProductTimeLabel.text = strOfMovieProductTimeLabel;
            self.movieProductTimeValueLabel.text = strOfMovieProductTimeValueLabel;
            self.movieProductStatusLabel.text = strOfMovieProductStatusLabel;
            self.movieProductStatusValueLabel.text = strOfMovieProductStatusValueLabel;
            
            //MARK: 变更下面的约束
            if (self.orderDetailOfMovie.orderDetailGoodsList.count == 1) {
                [self.movieProductTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                    make.top.equalTo(productListVw.mas_bottom).offset(15*Constants.screenHeightRate);
                    make.size.mas_equalTo(CGSizeMake(strOfMovieProductTimeLabelSize.width+5, strOfMovieProductTimeLabelSize.height));
                }];
                [self.movieProductTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(productListVw.mas_bottom).offset(15*Constants.screenHeightRate);
                    make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                    make.size.mas_equalTo(CGSizeMake(strOfMovieProductTimeValueLabelSize.width+1, strOfMovieProductTimeValueLabelSize.height));
                }];
            } else {
                
                [self.movieProductTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                    make.top.equalTo(moreView.mas_bottom).offset(15*Constants.screenHeightRate);
                    make.size.mas_equalTo(CGSizeMake(strOfMovieProductTimeLabelSize.width+5, strOfMovieProductTimeLabelSize.height));
                }];
                [self.movieProductTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(moreView.mas_bottom).offset(15*Constants.screenHeightRate);
                    make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                    make.size.mas_equalTo(CGSizeMake(strOfMovieProductTimeValueLabelSize.width+1, strOfMovieProductTimeValueLabelSize.height));
                }];
            }
            
            [self.movieProductStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.movieProductTimeValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMovieProductStatusLabelSize.width+5, strOfMovieProductStatusLabelSize.height));
            }];
            [self.movieProductStatusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.movieProductTimeValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMovieProductStatusValueLabelSize.width+1, strOfMovieProductStatusValueLabelSize.height));
            }];
            
            
            //MARK: --支付信息
            [self.bgView addSubview:self.line10View];
            [self.line10View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.movieProductStatusValueLabel.mas_bottom).offset(15*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            NSString *strOfMoviePayLabel = @"支付信息";
            NSString *strOfMoviePayMethodLabel = @"支付方式:";
            NSString *strOfMoviePayTotalMoneyLabel = @"总计金额:";
            NSString *strOfMoviePayDiscountLabel = @"优惠金额:";
            NSString *strOfMoviePayRealMoneyLabel = @"实付金额:";
            NSString *strOfMoviePayTimeLabel = @"支付时间:";
            NSString *strOfMoviePayStatusLabel = @"状态:";
            
            NSString *strOfMoviePayMethodValueLabel = self.orderDetailOfMovie.payType.length > 0?self.orderDetailOfMovie.payType:@"一";
            NSString *strOfMoviePayTotalMoneyValueLabel = [NSString stringWithFormat:@"¥%.2f", self.orderDetailOfMovie.orderMain.originalPrice.floatValue/100];
            NSString *strOfMoviePayDiscountValueLabel = [NSString stringWithFormat:@"-¥%.2f",(self.orderDetailOfMovie.orderMain.originalPrice.floatValue - self.orderDetailOfMovie.orderMain.receiveMoney.floatValue)/100];
            NSString *strOfMoviePayRealMoneyValueLabel = [NSString stringWithFormat:@"¥%.2f", self.orderDetailOfMovie.orderMain.receiveMoney.floatValue/100];
            NSString *strOfMoviePayServiceLabel = [NSString stringWithFormat:@"已包含服务费%.2f元", self.orderDetailOfMovie.orderMain.serviceCharge.floatValue/100];
            NSString *strOfMoviePayTimeValueLabel = self.orderDetailOfMovie.payment.payTime.longLongValue/1000>0?[[DateEngine sharedDateEngine] stringFromDateY:[NSDate dateWithTimeIntervalSince1970:[self.orderDetailOfMovie.payment.payTime longLongValue]/1000]]:@"一";
            NSString *strOfMoviePayStatusValueLabel = self.orderDetailOfMovie.payStatus.length>0?self.orderDetailOfMovie.payStatus:@"一";
            
            CGSize strOfMoviePayLabelSize = [KKZTextUtility measureText:strOfMoviePayLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayMethodLabelSize = [KKZTextUtility measureText:strOfMoviePayMethodLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayTotalMoneyLabelSize = [KKZTextUtility measureText:strOfMoviePayTotalMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayDiscountLabelSize = [KKZTextUtility measureText:strOfMoviePayDiscountLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayRealMoneyLabelSize = [KKZTextUtility measureText:strOfMoviePayRealMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayTimeLabelSize = [KKZTextUtility measureText:strOfMoviePayTimeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayStatusLabelSize = [KKZTextUtility measureText:strOfMoviePayStatusLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayMethodValueLabelSize = [KKZTextUtility measureText:strOfMoviePayMethodValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayTotalMoneyValueLabelSize = [KKZTextUtility measureText:strOfMoviePayTotalMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayDiscountValueLabelSize = [KKZTextUtility measureText:strOfMoviePayDiscountValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayRealMoneyValueLabelSize = [KKZTextUtility measureText:strOfMoviePayRealMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayServiceLabelSize = [KKZTextUtility measureText:strOfMoviePayServiceLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            CGSize strOfMoviePayTimeValueLabelSize = [KKZTextUtility measureText:strOfMoviePayTimeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayStatusValueLabelSize = [KKZTextUtility measureText:strOfMoviePayStatusValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            
            [self.bgView addSubview:self.payView];
            [self.payView addSubview:self.moviePayLabel];
            [self.bgView addSubview:self.line11View];
            [self.bgView addSubview:self.moviePayMethodLabel];
            [self.bgView addSubview:self.moviePayMethodValueLabel];
            [self.bgView addSubview:self.moviePayTotalMoneyLabel];
            [self.bgView addSubview:self.moviePayTotalMoneyValueLabel];
            [self.bgView addSubview:self.moviePayDiscountLabel];
            [self.bgView addSubview:self.moviePayDiscountValueLabel];
            [self.bgView addSubview:self.moviePayRealMoneyLabel];
            [self.bgView addSubview:self.moviePayRealMoneyValueLabel];
            [self.bgView addSubview:self.moviePayServiceMoneyLabel];
            [self.bgView addSubview:self.line12View];
            [self.bgView addSubview:self.moviePayTimeLabel];
            [self.bgView addSubview:self.moviePayTimeValueLabel];
            [self.bgView addSubview:self.moviePayStatusLabel];
            [self.bgView addSubview:self.moviePayStatusValueLabel];
            [self.bgView addSubview:self.line13View];
            
            
            self.moviePayLabel.text = strOfMoviePayLabel;
            self.moviePayMethodLabel.text = strOfMoviePayMethodLabel;
            self.moviePayMethodValueLabel.text = strOfMoviePayMethodValueLabel;
            self.moviePayTotalMoneyLabel.text = strOfMoviePayTotalMoneyLabel;
            self.moviePayTotalMoneyValueLabel.text = strOfMoviePayTotalMoneyValueLabel;
            self.moviePayDiscountLabel.text = strOfMoviePayDiscountLabel;
            self.moviePayDiscountValueLabel.text = strOfMoviePayDiscountValueLabel;
            self.moviePayRealMoneyLabel.text = strOfMoviePayRealMoneyLabel;
            self.moviePayRealMoneyValueLabel.text = strOfMoviePayRealMoneyValueLabel;
            self.moviePayServiceMoneyLabel.text = strOfMoviePayServiceLabel;
            self.moviePayTimeLabel.text = strOfMoviePayTimeLabel;
            self.moviePayTimeValueLabel.text = strOfMoviePayTimeValueLabel;
            self.moviePayStatusLabel.text = strOfMoviePayStatusLabel;
            self.moviePayStatusValueLabel.text = strOfMoviePayStatusValueLabel;
            
            [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.line10View.mas_bottom);
                make.height.equalTo(@(30*Constants.screenHeightRate));
            }];
            [self.moviePayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.payView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.payView.mas_top).offset((30*Constants.screenHeightRate-strOfMoviePayLabelSize.height)/2);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayLabelSize.width+1, strOfMoviePayLabelSize.height));
            }];
            [self.line11View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.payView.mas_top).offset(30*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            [self.moviePayMethodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.line11View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayMethodLabelSize.width+1, strOfMoviePayMethodLabelSize.height));
            }];
            [self.moviePayMethodValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.line11View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayMethodValueLabelSize.width+1, strOfMoviePayMethodValueLabelSize.height));
            }];
            [self.moviePayTotalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayMethodLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTotalMoneyLabelSize.width+1, strOfMoviePayTotalMoneyLabelSize.height));
            }];
            [self.moviePayTotalMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moviePayMethodValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTotalMoneyValueLabelSize.width+1, strOfMoviePayTotalMoneyValueLabelSize.height));
            }];
            [self.moviePayDiscountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayTotalMoneyLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayDiscountLabelSize.width+1, strOfMoviePayDiscountLabelSize.height));
            }];
            [self.moviePayDiscountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moviePayTotalMoneyValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayDiscountValueLabelSize.width+1, strOfMoviePayDiscountValueLabelSize.height));
            }];
            [self.moviePayRealMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayDiscountLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayRealMoneyLabelSize.width+1, strOfMoviePayRealMoneyLabelSize.height));
            }];
            [self.moviePayRealMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moviePayDiscountValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayRealMoneyValueLabelSize.width+1, strOfMoviePayRealMoneyValueLabelSize.height));
            }];
            [self.moviePayServiceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-10*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayRealMoneyValueLabel.mas_bottom).offset(6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayServiceLabelSize.width+5, strOfMoviePayServiceLabelSize.height));
            }];
            
            [self.line12View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.right.equalTo(self.bgView);
                make.top.equalTo(self.moviePayServiceMoneyLabel.mas_bottom).offset(15*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            [self.moviePayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.line12View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTimeLabelSize.width+1, strOfMoviePayTimeLabelSize.height));
            }];
            [self.moviePayTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.top.equalTo(self.line12View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTimeValueLabelSize.width+1, strOfMoviePayTimeValueLabelSize.height));
            }];
            [self.moviePayStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayTimeValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayStatusLabelSize.width+5, strOfMoviePayStatusLabelSize.height));
            }];
            [self.moviePayStatusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayTimeValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayStatusValueLabelSize.width+1, strOfMoviePayStatusValueLabelSize.height));
            }];
            [self.line13View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.moviePayStatusValueLabel.mas_bottom).offset(15*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            
        } else {
            //MARK: --无卖品信息，支付信息
            //        [self.bgView addSubview:self.line10View];
            //        [self.line10View mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.left.right.equalTo(self.bgView);
            //            make.top.equalTo(self.line6View.mas_bottom).offset(15);
            //            make.height.equalTo(@1);
            //        }];
            NSString *strOfMoviePayLabel = @"支付信息";
            NSString *strOfMoviePayMethodLabel = @"支付方式:";
            NSString *strOfMoviePayTotalMoneyLabel = @"总计金额:";
            NSString *strOfMoviePayDiscountLabel = @"优惠金额:";
            NSString *strOfMoviePayRealMoneyLabel = @"实付金额:";
            NSString *strOfMoviePayTimeLabel = @"支付时间:";
            NSString *strOfMoviePayStatusLabel = @"状态:";
            
            NSString *strOfMoviePayMethodValueLabel = self.orderDetailOfMovie.payType.length > 0?self.orderDetailOfMovie.payType:@"一";
            NSString *strOfMoviePayTotalMoneyValueLabel = [NSString stringWithFormat:@"¥%.2f", self.orderDetailOfMovie.orderMain.originalPrice.floatValue/100];
            NSString *strOfMoviePayDiscountValueLabel = [NSString stringWithFormat:@"-¥%.2f",(self.orderDetailOfMovie.orderMain.originalPrice.floatValue - self.orderDetailOfMovie.orderMain.receiveMoney.floatValue)/100];
            NSString *strOfMoviePayRealMoneyValueLabel = [NSString stringWithFormat:@"¥%.2f", self.orderDetailOfMovie.orderMain.receiveMoney.floatValue/100];;
            NSString *strOfMoviePayServiceLabel = [NSString stringWithFormat:@"已包含服务费%.2f元", self.orderDetailOfMovie.orderMain.serviceCharge.floatValue/100];
            NSString *strOfMoviePayTimeValueLabel = self.orderDetailOfMovie.payment.payTime.longLongValue/1000>0?[[DateEngine sharedDateEngine] stringFromDateY:[NSDate dateWithTimeIntervalSince1970:[self.orderDetailOfMovie.payment.payTime longLongValue]/1000]]:@"一";
            NSString *strOfMoviePayStatusValueLabel = self.orderDetailOfMovie.payStatus.length>0?self.orderDetailOfMovie.payStatus:@"一";
            
            CGSize strOfMoviePayLabelSize = [KKZTextUtility measureText:strOfMoviePayLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayMethodLabelSize = [KKZTextUtility measureText:strOfMoviePayMethodLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayTotalMoneyLabelSize = [KKZTextUtility measureText:strOfMoviePayTotalMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayDiscountLabelSize = [KKZTextUtility measureText:strOfMoviePayDiscountLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayRealMoneyLabelSize = [KKZTextUtility measureText:strOfMoviePayRealMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayTimeLabelSize = [KKZTextUtility measureText:strOfMoviePayTimeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayStatusLabelSize = [KKZTextUtility measureText:strOfMoviePayStatusLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayMethodValueLabelSize = [KKZTextUtility measureText:strOfMoviePayMethodValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayTotalMoneyValueLabelSize = [KKZTextUtility measureText:strOfMoviePayTotalMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayDiscountValueLabelSize = [KKZTextUtility measureText:strOfMoviePayDiscountValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayRealMoneyValueLabelSize = [KKZTextUtility measureText:strOfMoviePayRealMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayServiceLabelSize = [KKZTextUtility measureText:strOfMoviePayServiceLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            CGSize strOfMoviePayTimeValueLabelSize = [KKZTextUtility measureText:strOfMoviePayTimeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayStatusValueLabelSize = [KKZTextUtility measureText:strOfMoviePayStatusValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            
            [self.bgView addSubview:self.payView];
            [self.payView addSubview:self.moviePayLabel];
            [self.bgView addSubview:self.line11View];
            [self.bgView addSubview:self.moviePayMethodLabel];
            [self.bgView addSubview:self.moviePayMethodValueLabel];
            [self.bgView addSubview:self.moviePayTotalMoneyLabel];
            [self.bgView addSubview:self.moviePayTotalMoneyValueLabel];
            [self.bgView addSubview:self.moviePayDiscountLabel];
            [self.bgView addSubview:self.moviePayDiscountValueLabel];
            [self.bgView addSubview:self.moviePayRealMoneyLabel];
            [self.bgView addSubview:self.moviePayRealMoneyValueLabel];
            [self.bgView addSubview:self.moviePayServiceMoneyLabel];
            [self.bgView addSubview:self.line12View];
            [self.bgView addSubview:self.moviePayTimeLabel];
            [self.bgView addSubview:self.moviePayTimeValueLabel];
            [self.bgView addSubview:self.moviePayStatusLabel];
            [self.bgView addSubview:self.moviePayStatusValueLabel];
            [self.bgView addSubview:self.line13View];
            
            
            self.moviePayLabel.text = strOfMoviePayLabel;
            self.moviePayMethodLabel.text = strOfMoviePayMethodLabel;
            self.moviePayMethodValueLabel.text = strOfMoviePayMethodValueLabel;
            self.moviePayTotalMoneyLabel.text = strOfMoviePayTotalMoneyLabel;
            self.moviePayTotalMoneyValueLabel.text = strOfMoviePayTotalMoneyValueLabel;
            self.moviePayDiscountLabel.text = strOfMoviePayDiscountLabel;
            self.moviePayDiscountValueLabel.text = strOfMoviePayDiscountValueLabel;
            self.moviePayRealMoneyLabel.text = strOfMoviePayRealMoneyLabel;
            self.moviePayRealMoneyValueLabel.text = strOfMoviePayRealMoneyValueLabel;
            self.moviePayServiceMoneyLabel.text = strOfMoviePayServiceLabel;
            self.moviePayTimeLabel.text = strOfMoviePayTimeLabel;
            self.moviePayTimeValueLabel.text = strOfMoviePayTimeValueLabel;
            self.moviePayStatusLabel.text = strOfMoviePayStatusLabel;
            self.moviePayStatusValueLabel.text = strOfMoviePayStatusValueLabel;
            
            [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.line6View.mas_bottom);
                make.height.equalTo(@(30*Constants.screenHeightRate));
            }];
            [self.moviePayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.payView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.payView.mas_top).offset((30*Constants.screenHeightRate-strOfMoviePayLabelSize.height)/2);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayLabelSize.width+1, strOfMoviePayLabelSize.height));
            }];
            [self.line11View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.payView.mas_top).offset(30*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            [self.moviePayMethodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.line11View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayMethodLabelSize.width+1, strOfMoviePayMethodLabelSize.height));
            }];
            [self.moviePayMethodValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.line11View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayMethodValueLabelSize.width+1, strOfMoviePayMethodValueLabelSize.height));
            }];
            [self.moviePayTotalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayMethodLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTotalMoneyLabelSize.width+1, strOfMoviePayTotalMoneyLabelSize.height));
            }];
            [self.moviePayTotalMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moviePayMethodValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTotalMoneyValueLabelSize.width+1, strOfMoviePayTotalMoneyValueLabelSize.height));
            }];
            [self.moviePayDiscountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayTotalMoneyLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayDiscountLabelSize.width+1, strOfMoviePayDiscountLabelSize.height));
            }];
            [self.moviePayDiscountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moviePayTotalMoneyValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayDiscountValueLabelSize.width+1, strOfMoviePayDiscountValueLabelSize.height));
            }];
            [self.moviePayRealMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayDiscountLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayRealMoneyLabelSize.width+1, strOfMoviePayRealMoneyLabelSize.height));
            }];
            [self.moviePayRealMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moviePayDiscountValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayRealMoneyValueLabelSize.width+1, strOfMoviePayRealMoneyValueLabelSize.height));
            }];
            [self.moviePayServiceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-10*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayRealMoneyValueLabel.mas_bottom).offset(6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayServiceLabelSize.width+5, strOfMoviePayServiceLabelSize.height));
            }];
            
            [self.line12View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.right.equalTo(self.bgView);
                make.top.equalTo(self.moviePayServiceMoneyLabel.mas_bottom).offset(15*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            [self.moviePayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.line12View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTimeLabelSize.width+1, strOfMoviePayTimeLabelSize.height));
            }];
            [self.moviePayTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.top.equalTo(self.line12View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTimeValueLabelSize.width+1, strOfMoviePayTimeValueLabelSize.height));
            }];
            [self.moviePayStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayTimeValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayStatusLabelSize.width+1, strOfMoviePayStatusLabelSize.height));
            }];
            [self.moviePayStatusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayTimeValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayStatusValueLabelSize.width+1, strOfMoviePayStatusValueLabelSize.height));
            }];
            [self.line13View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.moviePayStatusValueLabel.mas_bottom).offset(15*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            
        }
    } else {
        //MARK: --订单无优惠信息
        //MARK: --判断是否有卖品，如果有，则添加，没有则不添加
        if (self.isHaveProductInOrder) {
            [self.bgView addSubview:self.productView];
            [self.productView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.line4View.mas_bottom);
                make.height.equalTo(@(30*Constants.screenHeightRate));
            }];
            NSString *strOfMovieProductLabel = @"卖品信息";
            CGSize strOfMovieProductLabelSize = [KKZTextUtility measureText:strOfMovieProductLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            [self.productView addSubview:self.movieProductLabel];
            self.movieProductLabel.text = strOfMovieProductLabel;
            [self.movieProductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.productView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.productView.mas_top).offset((30*Constants.screenHeightRate - strOfMovieProductLabelSize.height)/2);
                make.size.mas_offset(CGSizeMake(strOfMovieProductLabelSize.width+1, strOfMovieProductLabelSize.height));
            }];
            
            [self.bgView addSubview:self.line7View];
            [self.line7View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.productView.mas_top).offset(30*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            //MARK: 加载更多页面 判断
            if (self.orderDetailOfMovie.orderDetailGoodsList.count == 1) {
                
                NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:0];
                [tmpArr addObject:[self.orderDetailOfMovie.orderDetailGoodsList objectAtIndex:0]];
                
                OrderProduct *orderProduct = [tmpArr objectAtIndex:0];
                NSMutableArray *codeArr = [NSMutableArray arrayWithArray:[orderProduct.goodsCouponsCode componentsSeparatedByString:@"|"]];
                for (int i = 0; i<codeArr.count; i++) {
                    NSString *codeStr = [codeArr objectAtIndex:i];
                    NSString *tmpStr = @"";
                    if (codeStr.length>6) {
                        tmpStr = codeStr;
                    } else {
                        tmpStr = @" ";
                    }
                    [codeArr replaceObjectAtIndex:i withObject:tmpStr];
                }
                for (int  i = 0; i < codeArr.count; i++) {
                    NSString *codeSr = [codeArr objectAtIndex:i];
                    if (codeSr.length>4) {
                        NSString *formatSr = [self formatOrderNo:codeSr andSpacePosition:4];
                        //                    NSString *formatSt = [formatSr substringToIndex:formatSr.length - 1];
                        [codeArr replaceObjectAtIndex:i withObject:formatSr];
                    }
                }
                DLog(@"%@", codeArr);
                NSString *formatCodeStr = [codeArr componentsJoinedByString:@""];
                NSString *codeTmpStr = [codeArr firstObject];
                NSString *strOfMovieProductCodeLabel = @"取货码:";
                NSString *strOfMovieProductCodeValueLabel = [NSString stringWithFormat:@"%@", codeTmpStr.length > 0 ?codeTmpStr:@"一"];
                NSString *strOfMovieProductFormatCodeValueLabel = formatCodeStr.length>0?formatCodeStr:@"一";
                
                CGSize strOfMovieProductCodeLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                CGSize strOfMovieProductCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                CGSize strOfMovieProductFormatCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductFormatCodeValueLabel size:CGSizeMake(strOfMovieProductCodeValueLabelSize.width, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                
                
                productListVw = [self getProductViewWith:tmpArr];
                [self.bgView addSubview:productListVw];
                [productListVw mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.line7View.mas_bottom);
                    make.left.right.equalTo(self.bgView);
                    make.height.equalTo(@(136*Constants.screenHeightRate+strOfMovieProductFormatCodeValueLabelSize.height - strOfMovieProductCodeLabelSize.height+5));
                }];
                
                
                
            } else {
                NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:0];
                [tmpArr addObject:[self.orderDetailOfMovie.orderDetailGoodsList objectAtIndex:0]];
                
                OrderProduct *orderProduct = [tmpArr objectAtIndex:0];
                NSMutableArray *codeArr = [NSMutableArray arrayWithArray:[orderProduct.goodsCouponsCode componentsSeparatedByString:@"|"]];
                for (int i = 0; i<codeArr.count; i++) {
                    NSString *codeStr = [codeArr objectAtIndex:i];
                    NSString *tmpStr = @"";
                    if (codeStr.length>6) {
                        tmpStr = codeStr;
                    } else {
                        tmpStr = @" ";
                    }
                    [codeArr replaceObjectAtIndex:i withObject:tmpStr];
                }
                for (int  i = 0; i < codeArr.count; i++) {
                    NSString *codeSr = [codeArr objectAtIndex:i];
                    if (codeSr.length>4) {
                        NSString *formatSr = [self formatOrderNo:codeSr andSpacePosition:4];
                        //                    NSString *formatSt = [formatSr substringToIndex:formatSr.length - 1];
                        [codeArr replaceObjectAtIndex:i withObject:formatSr];
                    }
                    
                }
                DLog(@"%@", codeArr);
                NSString *formatCodeStr = [codeArr componentsJoinedByString:@""];
                DLog(@"%@", formatCodeStr);
                NSString *codeTmpStr = [codeArr firstObject];
                NSString *strOfMovieProductCodeLabel = @"取货码:";
                NSString *strOfMovieProductCodeValueLabel = [NSString stringWithFormat:@"%@", codeTmpStr.length > 0 ?codeTmpStr:@"一"];
                NSString *strOfMovieProductFormatCodeValueLabel = formatCodeStr.length>0?formatCodeStr:@"一";
                
                CGSize strOfMovieProductCodeLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                CGSize strOfMovieProductCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                CGSize strOfMovieProductFormatCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductFormatCodeValueLabel size:CGSizeMake(strOfMovieProductCodeValueLabelSize.width, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                
                
                productListVw = [self getProductViewWith:tmpArr];
                [self.bgView addSubview:productListVw];
                [productListVw mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.line7View.mas_bottom);
                    make.left.right.equalTo(self.bgView);
                    make.height.equalTo(@(136*Constants.screenHeightRate+strOfMovieProductFormatCodeValueLabelSize.height - strOfMovieProductCodeLabelSize.height+5));
                }];
                
                moreView = [[UIView alloc] init];
                moreView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
                [self.bgView addSubview:moreView];
                [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.bgView);
                    make.top.equalTo(productListVw.mas_bottom);
                    make.height.equalTo(@(41*Constants.screenHeightRate));
                }];
                
                UITapGestureRecognizer *moreViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreViewBtnClick:)];
                [moreView addGestureRecognizer:moreViewSingleTap];
                
                NSString *tipsLabelStr = @"展开其他100项卖品";
                CGSize tipsLabelStrSize = [KKZTextUtility measureText:tipsLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                UILabel *tipsLabel = [[UILabel alloc] init];
                [moreView addSubview:tipsLabel];
                tipsLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
//                tipsLabel.attributedText = [self getMoreProductAttributeStr:[NSString stringWithFormat:@"展开其他%lu项卖品", self.orderDetailOfMovie.orderDetailGoodsList.count - 1]];
                tipsLabel.attributedText = [KKZTextUtility getAttributeStr:[NSString stringWithFormat:@"展开其他%lu项卖品", self.orderDetailOfMovie.orderDetailGoodsList.count - 1] withStartRangeStr:@"他" withEndRangeStr:@"项" withFormalColor:[UIColor colorWithHex:@"#333333"] withSpecialColor:[UIColor colorWithHex:@"#ff9900"] withFont:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
                [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(moreView.mas_left).offset(15*Constants.screenWidthRate);
                    make.top.equalTo(moreView.mas_top).offset(15*Constants.screenHeightRate);
                    make.size.mas_equalTo(CGSizeMake(tipsLabelStrSize.width+5, tipsLabelStrSize.height));
                }];
                UIImage *moreImage = [UIImage imageNamed:@"details_downarrow"];
                UIImageView *moreImageView = [[UIImageView alloc] init];
                [moreView addSubview:moreImageView];
                moreImageView.image = moreImage;
                [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(moreView.mas_top).offset((41 - moreImage.size.height)/2*Constants.screenHeightRate);
                    make.right.equalTo(moreView.mas_right).offset(-15*Constants.screenWidthRate);
                    make.size.mas_equalTo(CGSizeMake(moreImage.size.width*Constants.screenWidthRate, moreImage.size.height*Constants.screenHeightRate));
                }];
                UIView *lineVw2 = [[UIView alloc] init];
                lineVw2.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
                [moreView addSubview:lineVw2];
                [lineVw2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(self.bgView);
                    make.top.equalTo(moreView.mas_top).offset(41*Constants.screenHeightRate);
                    make.height.equalTo(@1);
                }];
            }
            
            NSString *strOfMovieProductTimeLabel = @"下单时间：";
            NSString *strOfMovieProductStatusLabel = @"状态：";
            
            NSString *strOfMovieProductTimeValueLabel = @"2017-01-17 14:30";
            NSString *strOfMovieProductStatusValueLabel = @"已完成";
            
            
            CGSize strOfMovieProductTimeLabelSize = [KKZTextUtility measureText:strOfMovieProductTimeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMovieProductStatusLabelSize = [KKZTextUtility measureText:strOfMovieProductStatusLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            
            CGSize strOfMovieProductTimeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductTimeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMovieProductStatusValueLabelSize = [KKZTextUtility measureText:strOfMovieProductStatusValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            //MARK: 卖品缩略图
            [self.bgView addSubview:self.movieProductTimeLabel];
            [self.bgView addSubview:self.movieProductTimeValueLabel];
            [self.bgView addSubview:self.movieProductStatusLabel];
            [self.bgView addSubview:self.movieProductStatusValueLabel];
            
            self.movieProductTimeLabel.text = strOfMovieProductTimeLabel;
            self.movieProductTimeValueLabel.text = strOfMovieProductTimeValueLabel;
            self.movieProductStatusLabel.text = strOfMovieProductStatusLabel;
            self.movieProductStatusValueLabel.text = strOfMovieProductStatusValueLabel;
            
            //MARK: 变更下面的约束
            if (self.orderDetailOfMovie.orderDetailGoodsList.count == 1) {
                [self.movieProductTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                    make.top.equalTo(productListVw.mas_bottom).offset(15*Constants.screenHeightRate);
                    make.size.mas_equalTo(CGSizeMake(strOfMovieProductTimeLabelSize.width+5, strOfMovieProductTimeLabelSize.height));
                }];
                [self.movieProductTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(productListVw.mas_bottom).offset(15*Constants.screenHeightRate);
                    make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                    make.size.mas_equalTo(CGSizeMake(strOfMovieProductTimeValueLabelSize.width+1, strOfMovieProductTimeValueLabelSize.height));
                }];
            } else {
                
                [self.movieProductTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                    make.top.equalTo(moreView.mas_bottom).offset(15*Constants.screenHeightRate);
                    make.size.mas_equalTo(CGSizeMake(strOfMovieProductTimeLabelSize.width+5, strOfMovieProductTimeLabelSize.height));
                }];
                [self.movieProductTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(moreView.mas_bottom).offset(15*Constants.screenHeightRate);
                    make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                    make.size.mas_equalTo(CGSizeMake(strOfMovieProductTimeValueLabelSize.width+1, strOfMovieProductTimeValueLabelSize.height));
                }];
            }
            
            [self.movieProductStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.movieProductTimeValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMovieProductStatusLabelSize.width+5, strOfMovieProductStatusLabelSize.height));
            }];
            [self.movieProductStatusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.movieProductTimeValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMovieProductStatusValueLabelSize.width+1, strOfMovieProductStatusValueLabelSize.height));
            }];
            
            
            //MARK: --支付信息
            [self.bgView addSubview:self.line10View];
            [self.line10View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.movieProductStatusValueLabel.mas_bottom).offset(15*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            NSString *strOfMoviePayLabel = @"支付信息";
            NSString *strOfMoviePayMethodLabel = @"支付方式:";
            NSString *strOfMoviePayTotalMoneyLabel = @"总计金额:";
            NSString *strOfMoviePayDiscountLabel = @"优惠金额:";
            NSString *strOfMoviePayRealMoneyLabel = @"实付金额:";
            NSString *strOfMoviePayTimeLabel = @"支付时间:";
            NSString *strOfMoviePayStatusLabel = @"状态:";
            
            NSString *strOfMoviePayMethodValueLabel = self.orderDetailOfMovie.payType.length > 0?self.orderDetailOfMovie.payType:@"一";
            NSString *strOfMoviePayTotalMoneyValueLabel = [NSString stringWithFormat:@"¥%.2f", self.orderDetailOfMovie.orderMain.originalPrice.floatValue/100];
            NSString *strOfMoviePayDiscountValueLabel = [NSString stringWithFormat:@"-¥%.2f",(self.orderDetailOfMovie.orderMain.originalPrice.floatValue - self.orderDetailOfMovie.orderMain.receiveMoney.floatValue)/100];
            NSString *strOfMoviePayRealMoneyValueLabel = [NSString stringWithFormat:@"¥%.2f", self.orderDetailOfMovie.orderMain.receiveMoney.floatValue/100];;
            NSString *strOfMoviePayServiceLabel = [NSString stringWithFormat:@"已包含服务费%.2f元", self.orderDetailOfMovie.orderMain.serviceCharge.floatValue/100];
            NSString *strOfMoviePayTimeValueLabel = self.orderDetailOfMovie.payment.payTime.longLongValue/1000>0?[[DateEngine sharedDateEngine] stringFromDateY:[NSDate dateWithTimeIntervalSince1970:[self.orderDetailOfMovie.payment.payTime longLongValue]/1000]]:@"一";
            NSString *strOfMoviePayStatusValueLabel = self.orderDetailOfMovie.payStatus.length>0?self.orderDetailOfMovie.payStatus:@"一";
            
            CGSize strOfMoviePayLabelSize = [KKZTextUtility measureText:strOfMoviePayLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayMethodLabelSize = [KKZTextUtility measureText:strOfMoviePayMethodLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayTotalMoneyLabelSize = [KKZTextUtility measureText:strOfMoviePayTotalMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayDiscountLabelSize = [KKZTextUtility measureText:strOfMoviePayDiscountLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayRealMoneyLabelSize = [KKZTextUtility measureText:strOfMoviePayRealMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayTimeLabelSize = [KKZTextUtility measureText:strOfMoviePayTimeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayStatusLabelSize = [KKZTextUtility measureText:strOfMoviePayStatusLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayMethodValueLabelSize = [KKZTextUtility measureText:strOfMoviePayMethodValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayTotalMoneyValueLabelSize = [KKZTextUtility measureText:strOfMoviePayTotalMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayDiscountValueLabelSize = [KKZTextUtility measureText:strOfMoviePayDiscountValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayRealMoneyValueLabelSize = [KKZTextUtility measureText:strOfMoviePayRealMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayServiceLabelSize = [KKZTextUtility measureText:strOfMoviePayServiceLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            CGSize strOfMoviePayTimeValueLabelSize = [KKZTextUtility measureText:strOfMoviePayTimeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayStatusValueLabelSize = [KKZTextUtility measureText:strOfMoviePayStatusValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            
            [self.bgView addSubview:self.payView];
            [self.payView addSubview:self.moviePayLabel];
            [self.bgView addSubview:self.line11View];
            [self.bgView addSubview:self.moviePayMethodLabel];
            [self.bgView addSubview:self.moviePayMethodValueLabel];
            [self.bgView addSubview:self.moviePayTotalMoneyLabel];
            [self.bgView addSubview:self.moviePayTotalMoneyValueLabel];
            [self.bgView addSubview:self.moviePayDiscountLabel];
            [self.bgView addSubview:self.moviePayDiscountValueLabel];
            [self.bgView addSubview:self.moviePayRealMoneyLabel];
            [self.bgView addSubview:self.moviePayRealMoneyValueLabel];
            [self.bgView addSubview:self.moviePayServiceMoneyLabel];
            [self.bgView addSubview:self.line12View];
            [self.bgView addSubview:self.moviePayTimeLabel];
            [self.bgView addSubview:self.moviePayTimeValueLabel];
            [self.bgView addSubview:self.moviePayStatusLabel];
            [self.bgView addSubview:self.moviePayStatusValueLabel];
            [self.bgView addSubview:self.line13View];
            
            
            self.moviePayLabel.text = strOfMoviePayLabel;
            self.moviePayMethodLabel.text = strOfMoviePayMethodLabel;
            self.moviePayMethodValueLabel.text = strOfMoviePayMethodValueLabel;
            self.moviePayTotalMoneyLabel.text = strOfMoviePayTotalMoneyLabel;
            self.moviePayTotalMoneyValueLabel.text = strOfMoviePayTotalMoneyValueLabel;
            self.moviePayDiscountLabel.text = strOfMoviePayDiscountLabel;
            self.moviePayDiscountValueLabel.text = strOfMoviePayDiscountValueLabel;
            self.moviePayRealMoneyLabel.text = strOfMoviePayRealMoneyLabel;
            self.moviePayRealMoneyValueLabel.text = strOfMoviePayRealMoneyValueLabel;
            self.moviePayServiceMoneyLabel.text = strOfMoviePayServiceLabel;
            self.moviePayTimeLabel.text = strOfMoviePayTimeLabel;
            self.moviePayTimeValueLabel.text = strOfMoviePayTimeValueLabel;
            self.moviePayStatusLabel.text = strOfMoviePayStatusLabel;
            self.moviePayStatusValueLabel.text = strOfMoviePayStatusValueLabel;
            
            [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.line10View.mas_bottom);
                make.height.equalTo(@(30*Constants.screenHeightRate));
            }];
            [self.moviePayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.payView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.payView.mas_top).offset((30*Constants.screenHeightRate-strOfMoviePayLabelSize.height)/2);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayLabelSize.width+1, strOfMoviePayLabelSize.height));
            }];
            [self.line11View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.payView.mas_top).offset(30*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            [self.moviePayMethodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.line11View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayMethodLabelSize.width+1, strOfMoviePayMethodLabelSize.height));
            }];
            [self.moviePayMethodValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.line11View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayMethodValueLabelSize.width+1, strOfMoviePayMethodValueLabelSize.height));
            }];
            [self.moviePayTotalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayMethodLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTotalMoneyLabelSize.width+1, strOfMoviePayTotalMoneyLabelSize.height));
            }];
            [self.moviePayTotalMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moviePayMethodValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTotalMoneyValueLabelSize.width+1, strOfMoviePayTotalMoneyValueLabelSize.height));
            }];
            [self.moviePayDiscountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayTotalMoneyLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayDiscountLabelSize.width+1, strOfMoviePayDiscountLabelSize.height));
            }];
            [self.moviePayDiscountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moviePayTotalMoneyValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayDiscountValueLabelSize.width+1, strOfMoviePayDiscountValueLabelSize.height));
            }];
            [self.moviePayRealMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayDiscountLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayRealMoneyLabelSize.width+1, strOfMoviePayRealMoneyLabelSize.height));
            }];
            [self.moviePayRealMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moviePayDiscountValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayRealMoneyValueLabelSize.width+1, strOfMoviePayRealMoneyValueLabelSize.height));
            }];
            [self.moviePayServiceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-10*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayRealMoneyValueLabel.mas_bottom).offset(6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayServiceLabelSize.width+5, strOfMoviePayServiceLabelSize.height));
            }];
            
            [self.line12View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.right.equalTo(self.bgView);
                make.top.equalTo(self.moviePayServiceMoneyLabel.mas_bottom).offset(15*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            [self.moviePayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.line12View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTimeLabelSize.width+1, strOfMoviePayTimeLabelSize.height));
            }];
            [self.moviePayTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.top.equalTo(self.line12View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTimeValueLabelSize.width+1, strOfMoviePayTimeValueLabelSize.height));
            }];
            [self.moviePayStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayTimeValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayStatusLabelSize.width+5, strOfMoviePayStatusLabelSize.height));
            }];
            [self.moviePayStatusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayTimeValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayStatusValueLabelSize.width+1, strOfMoviePayStatusValueLabelSize.height));
            }];
            [self.line13View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.moviePayStatusValueLabel.mas_bottom).offset(15*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            
        } else {
            //MARK: --无卖品信息，支付信息
            //        [self.bgView addSubview:self.line10View];
            //        [self.line10View mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.left.right.equalTo(self.bgView);
            //            make.top.equalTo(self.line6View.mas_bottom).offset(15);
            //            make.height.equalTo(@1);
            //        }];
            NSString *strOfMoviePayLabel = @"支付信息";
            NSString *strOfMoviePayMethodLabel = @"支付方式:";
            NSString *strOfMoviePayTotalMoneyLabel = @"总计金额:";
            NSString *strOfMoviePayDiscountLabel = @"优惠金额:";
            NSString *strOfMoviePayRealMoneyLabel = @"实付金额:";
            NSString *strOfMoviePayTimeLabel = @"支付时间:";
            NSString *strOfMoviePayStatusLabel = @"状态:";
            
            NSString *strOfMoviePayMethodValueLabel = self.orderDetailOfMovie.payType.length > 0?self.orderDetailOfMovie.payType:@"一";
            NSString *strOfMoviePayTotalMoneyValueLabel = [NSString stringWithFormat:@"¥%.2f", self.orderDetailOfMovie.orderMain.originalPrice.floatValue/100];
            NSString *strOfMoviePayDiscountValueLabel = [NSString stringWithFormat:@"-¥%.2f",(self.orderDetailOfMovie.orderMain.originalPrice.floatValue - self.orderDetailOfMovie.orderMain.receiveMoney.floatValue)/100];
            NSString *strOfMoviePayRealMoneyValueLabel = [NSString stringWithFormat:@"¥%.2f", self.orderDetailOfMovie.orderMain.receiveMoney.floatValue/100];;
            NSString *strOfMoviePayServiceLabel = [NSString stringWithFormat:@"已包含服务费%.2f元", self.orderDetailOfMovie.orderMain.serviceCharge.floatValue/100];
            NSString *strOfMoviePayTimeValueLabel = self.orderDetailOfMovie.payment.payTime.longLongValue/1000>0?[[DateEngine sharedDateEngine] stringFromDateY:[NSDate dateWithTimeIntervalSince1970:[self.orderDetailOfMovie.payment.payTime longLongValue]/1000]]:@"一";
            NSString *strOfMoviePayStatusValueLabel = self.orderDetailOfMovie.payStatus.length>0?self.orderDetailOfMovie.payStatus:@"一";
            
            CGSize strOfMoviePayLabelSize = [KKZTextUtility measureText:strOfMoviePayLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayMethodLabelSize = [KKZTextUtility measureText:strOfMoviePayMethodLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayTotalMoneyLabelSize = [KKZTextUtility measureText:strOfMoviePayTotalMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayDiscountLabelSize = [KKZTextUtility measureText:strOfMoviePayDiscountLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayRealMoneyLabelSize = [KKZTextUtility measureText:strOfMoviePayRealMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayTimeLabelSize = [KKZTextUtility measureText:strOfMoviePayTimeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayStatusLabelSize = [KKZTextUtility measureText:strOfMoviePayStatusLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayMethodValueLabelSize = [KKZTextUtility measureText:strOfMoviePayMethodValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayTotalMoneyValueLabelSize = [KKZTextUtility measureText:strOfMoviePayTotalMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayDiscountValueLabelSize = [KKZTextUtility measureText:strOfMoviePayDiscountValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayRealMoneyValueLabelSize = [KKZTextUtility measureText:strOfMoviePayRealMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayServiceLabelSize = [KKZTextUtility measureText:strOfMoviePayServiceLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            CGSize strOfMoviePayTimeValueLabelSize = [KKZTextUtility measureText:strOfMoviePayTimeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            CGSize strOfMoviePayStatusValueLabelSize = [KKZTextUtility measureText:strOfMoviePayStatusValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            
            [self.bgView addSubview:self.payView];
            [self.payView addSubview:self.moviePayLabel];
            [self.bgView addSubview:self.line11View];
            [self.bgView addSubview:self.moviePayMethodLabel];
            [self.bgView addSubview:self.moviePayMethodValueLabel];
            [self.bgView addSubview:self.moviePayTotalMoneyLabel];
            [self.bgView addSubview:self.moviePayTotalMoneyValueLabel];
            [self.bgView addSubview:self.moviePayDiscountLabel];
            [self.bgView addSubview:self.moviePayDiscountValueLabel];
            [self.bgView addSubview:self.moviePayRealMoneyLabel];
            [self.bgView addSubview:self.moviePayRealMoneyValueLabel];
            [self.bgView addSubview:self.moviePayServiceMoneyLabel];
            [self.bgView addSubview:self.line12View];
            [self.bgView addSubview:self.moviePayTimeLabel];
            [self.bgView addSubview:self.moviePayTimeValueLabel];
            [self.bgView addSubview:self.moviePayStatusLabel];
            [self.bgView addSubview:self.moviePayStatusValueLabel];
            [self.bgView addSubview:self.line13View];
            
            
            self.moviePayLabel.text = strOfMoviePayLabel;
            self.moviePayMethodLabel.text = strOfMoviePayMethodLabel;
            self.moviePayMethodValueLabel.text = strOfMoviePayMethodValueLabel;
            self.moviePayTotalMoneyLabel.text = strOfMoviePayTotalMoneyLabel;
            self.moviePayTotalMoneyValueLabel.text = strOfMoviePayTotalMoneyValueLabel;
            self.moviePayDiscountLabel.text = strOfMoviePayDiscountLabel;
            self.moviePayDiscountValueLabel.text = strOfMoviePayDiscountValueLabel;
            self.moviePayRealMoneyLabel.text = strOfMoviePayRealMoneyLabel;
            self.moviePayRealMoneyValueLabel.text = strOfMoviePayRealMoneyValueLabel;
            self.moviePayServiceMoneyLabel.text = strOfMoviePayServiceLabel;
            self.moviePayTimeLabel.text = strOfMoviePayTimeLabel;
            self.moviePayTimeValueLabel.text = strOfMoviePayTimeValueLabel;
            self.moviePayStatusLabel.text = strOfMoviePayStatusLabel;
            self.moviePayStatusValueLabel.text = strOfMoviePayStatusValueLabel;
            
            [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.line4View.mas_bottom);
                make.height.equalTo(@(30*Constants.screenHeightRate));
            }];
            [self.moviePayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.payView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.payView.mas_top).offset((30*Constants.screenHeightRate-strOfMoviePayLabelSize.height)/2);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayLabelSize.width+1, strOfMoviePayLabelSize.height));
            }];
            [self.line11View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.payView.mas_top).offset(30*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            [self.moviePayMethodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.line11View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayMethodLabelSize.width+1, strOfMoviePayMethodLabelSize.height));
            }];
            [self.moviePayMethodValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.line11View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayMethodValueLabelSize.width+1, strOfMoviePayMethodValueLabelSize.height));
            }];
            [self.moviePayTotalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayMethodLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTotalMoneyLabelSize.width+1, strOfMoviePayTotalMoneyLabelSize.height));
            }];
            [self.moviePayTotalMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moviePayMethodValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTotalMoneyValueLabelSize.width+1, strOfMoviePayTotalMoneyValueLabelSize.height));
            }];
            [self.moviePayDiscountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayTotalMoneyLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayDiscountLabelSize.width+1, strOfMoviePayDiscountLabelSize.height));
            }];
            [self.moviePayDiscountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moviePayTotalMoneyValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayDiscountValueLabelSize.width+1, strOfMoviePayDiscountValueLabelSize.height));
            }];
            [self.moviePayRealMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayDiscountLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayRealMoneyLabelSize.width+1, strOfMoviePayRealMoneyLabelSize.height));
            }];
            [self.moviePayRealMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.moviePayDiscountValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayRealMoneyValueLabelSize.width+1, strOfMoviePayRealMoneyValueLabelSize.height));
            }];
            [self.moviePayServiceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-10*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayRealMoneyValueLabel.mas_bottom).offset(6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayServiceLabelSize.width+5, strOfMoviePayServiceLabelSize.height));
            }];
            
            [self.line12View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.right.equalTo(self.bgView);
                make.top.equalTo(self.moviePayServiceMoneyLabel.mas_bottom).offset(15*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            [self.moviePayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.line12View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTimeLabelSize.width+1, strOfMoviePayTimeLabelSize.height));
            }];
            [self.moviePayTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.top.equalTo(self.line12View.mas_bottom).offset(15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayTimeValueLabelSize.width+1, strOfMoviePayTimeValueLabelSize.height));
            }];
            [self.moviePayStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayTimeValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayStatusLabelSize.width+1, strOfMoviePayStatusLabelSize.height));
            }];
            [self.moviePayStatusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
                make.top.equalTo(self.moviePayTimeValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(strOfMoviePayStatusValueLabelSize.width+1, strOfMoviePayStatusValueLabelSize.height));
            }];
            [self.line13View mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.bgView);
                make.top.equalTo(self.moviePayStatusLabel.mas_bottom).offset(15*Constants.screenHeightRate);
                make.height.equalTo(@1);
            }];
            
        }
    }
    
    
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.line13View.mas_bottom).offset(10*Constants.screenHeightRate);
    }];
    [self.holder mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(80*Constants.screenHeightRate).priorityLow();
        make.bottom.mas_greaterThanOrEqualTo(self.view);
    }];
}

//MARK: 点击展开更多卖品页面
- (void)moreViewBtnClick:(id)sender {
    if (moreView) {
        [moreView removeFromSuperview];
        moreView = nil;
    }
    if (productListVw) {
        [productListVw removeFromSuperview];
        productListVw = nil;
    }
    productListVw = [self getProductViewWith:self.orderDetailOfMovie.orderDetailGoodsList];
    [self.bgView addSubview:productListVw];
    
    //MARK: 计算总高度
    float goodsHeight = 0.0;
    for (int i = 0; i < self.orderDetailOfMovie.orderDetailGoodsList.count; i++) {
        OrderProduct *orderProduct = [self.orderDetailOfMovie.orderDetailGoodsList objectAtIndex:i];
        
        NSMutableArray *codeArr = [NSMutableArray arrayWithArray:[orderProduct.goodsCouponsCode componentsSeparatedByString:@"|"]];
        for (int i = 0; i<codeArr.count; i++) {
            NSString *codeStr = [codeArr objectAtIndex:i];
            NSString *tmpStr = @"";
            if (codeStr.length>6) {
                tmpStr = codeStr;
            } else {
                tmpStr = @" ";
            }
            [codeArr replaceObjectAtIndex:i withObject:tmpStr];
        }
        for (int  i = 0; i < codeArr.count; i++) {
            NSString *codeSr = [codeArr objectAtIndex:i];
            if (codeSr.length>4) {
                NSString *formatSr = [self formatOrderNo:codeSr andSpacePosition:4];
                //                    NSString *formatSt = [formatSr substringToIndex:formatSr.length - 1];
                [codeArr replaceObjectAtIndex:i withObject:formatSr];
            }
            
        }
        DLog(@"%@", codeArr);
        NSString *formatCodeStr = [codeArr componentsJoinedByString:@""];
        NSString *codeTmpStr = [codeArr firstObject];
        NSString *strOfMovieProductCodeLabel = @"取货码:";
        NSString *strOfMovieProductCodeValueLabel = [NSString stringWithFormat:@"%@", codeTmpStr.length > 0 ?codeTmpStr:@"一"];
        NSString *strOfMovieProductFormatCodeValueLabel = formatCodeStr.length>0?formatCodeStr:@"一";
        
        
        CGSize strOfMovieProductCodeLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieProductCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieProductFormatCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductFormatCodeValueLabel size:CGSizeMake(strOfMovieProductCodeValueLabelSize.width, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        if (codeArr.count > 1) {
            goodsHeight += strOfMovieProductFormatCodeValueLabelSize.height - strOfMovieProductCodeLabelSize.height;
        }
        
    }
        
    

    [productListVw mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line7View.mas_bottom);
        make.left.right.equalTo(self.bgView);
        make.height.equalTo(@(136*self.orderDetailOfMovie.orderDetailGoodsList.count*Constants.screenHeightRate+goodsHeight+5));
    }];
    NSString *strOfMovieProductTimeLabel = @"下单时间：";
    NSString *strOfMovieProductTimeValueLabel = @"2017-01-17 14:30";
    CGSize strOfMovieProductTimeLabelSize = [KKZTextUtility measureText:strOfMovieProductTimeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieProductTimeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductTimeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    
    [self.movieProductTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(productListVw.mas_bottom).offset(15*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductTimeLabelSize.width+5, strOfMovieProductTimeLabelSize.height));
    }];
    [self.movieProductTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productListVw.mas_bottom).offset(15*Constants.screenHeightRate);
        make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductTimeValueLabelSize.width+1, strOfMovieProductTimeValueLabelSize.height));
    }];
}

//MARK: 创建卖品列表View
- (UIView *)getProductViewWith:(NSArray *)productList {
    
    
    UIView *productListView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 0)];
    //MARK: 卖品缩略图
    float goodHeight = 0.0;
    for (int i = 0; i < productList.count; i++) {
        float goodCodeHeight = 0.0;
        OrderProduct *orderProduct = [productList objectAtIndex:i];
        NSMutableArray *codeArr = [NSMutableArray arrayWithArray:[orderProduct.goodsCouponsCode componentsSeparatedByString:@"|"]];
        for (int i = 0; i<codeArr.count; i++) {
            NSString *codeStr = [codeArr objectAtIndex:i];
            NSString *tmpStr = @"";
            if (codeStr.length>6) {
                tmpStr = codeStr;
            } else {
                tmpStr = @" ";
            }
            [codeArr replaceObjectAtIndex:i withObject:tmpStr];
        }
        for (int  i = 0; i < codeArr.count; i++) {
            NSString *codeSr = [codeArr objectAtIndex:i];
            if (codeSr.length> 4) {
                NSString *formatSr = [self formatOrderNo:codeSr andSpacePosition:4];
                //            NSString *formatSt = [formatSr substringToIndex:formatSr.length - 1];
                [codeArr replaceObjectAtIndex:i withObject:formatSr];
            }
        }
        DLog(@"%@", codeArr);
        NSString *formatCodeStr = [codeArr componentsJoinedByString:@""];
        DLog(@"%@", formatCodeStr);
        NSString *codeTmpStr = [codeArr firstObject];
        NSString *strOfMovieProductMoneyLabel = @"单价:";
        NSString *strOfMovieProductCountLabel = @"数量:";
        NSString *strOfMovieProductCodeLabel = @"取货码:";
        
        NSString *strOfMovieProductNameLabel = orderProduct.goodsName;
        NSString *strOfMovieProductMoneyValueLabel = [NSString stringWithFormat:@"¥%.2f", orderProduct.unitPrice.floatValue/100];
        NSString *strOfMovieProductCountValueLabel = [NSString stringWithFormat:@"%@", orderProduct.count];
        NSString *strOfMovieProductCodeValueLabel = [NSString stringWithFormat:@"%@", codeTmpStr.length > 0 ?codeTmpStr:@"一"];
        NSString *strOfMovieProductFormatCodeValueLabel = formatCodeStr.length>0?formatCodeStr:@"一";
        
        CGSize strOfMovieProductMoneyLabelSize = [KKZTextUtility measureText:strOfMovieProductMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieProductCountLabelSize = [KKZTextUtility measureText:strOfMovieProductCountLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieProductCodeLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        
        CGSize strOfMovieProductNameLabelSize = [KKZTextUtility measureText:strOfMovieProductNameLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieProductMoneyValueLabelSize = [KKZTextUtility measureText:strOfMovieProductMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieProductCountValueLabelSize = [KKZTextUtility measureText:strOfMovieProductCountValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieProductCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieProductFormatCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductFormatCodeValueLabel size:CGSizeMake(strOfMovieProductCodeValueLabelSize.width, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        
        UIImageView *movieImageView = [[UIImageView alloc] init];
        movieImageView.layer.borderWidth = 1.0f;
        movieImageView.layer.borderColor = [UIColor colorWithHex:@"#e0e0e0"].CGColor;
        movieImageView.layer.cornerRadius = 5.0f;
        movieImageView.clipsToBounds = YES;
        [productListView addSubview:movieImageView];
        
        [movieImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:orderProduct.goodsThumbnailUrl] placeholderImage:nil];
//        DLog(@"%@", orderProduct.goodsThumbnailUrl);
        
        [movieImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(productListView.mas_left).offset(15*Constants.screenWidthRate);
            make.top.equalTo(productListView.mas_top).offset((goodHeight+15)*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(105*Constants.screenWidthRate, 105*Constants.screenHeightRate));
        }];
        UILabel *movieNameLabel = [[UILabel alloc] init];
        movieNameLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        movieNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        [productListView addSubview:movieNameLabel];
        
        UILabel *goodsDescribeLabel = [UILabel new];
        goodsDescribeLabel.font = [UIFont systemFontOfSize:11*Constants.screenWidthRate];
        goodsDescribeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        [productListView addSubview:goodsDescribeLabel];
        
        UILabel *movieMoneyLabel = [[UILabel alloc] init];
        movieMoneyLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        movieMoneyLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        [productListView addSubview:movieMoneyLabel];
        
        UILabel *movieMoneyValueLabel = [[UILabel alloc] init];
        movieMoneyValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        movieMoneyValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        [productListView addSubview:movieMoneyValueLabel];
        
        UILabel *movieCountLabel = [[UILabel alloc] init];
        movieCountLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        movieCountLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        [productListView addSubview:movieCountLabel];
        
        UILabel *movieCountValueLabel = [[UILabel alloc] init];
        movieCountValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        movieCountValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        [productListView addSubview:movieCountValueLabel];
        
        UILabel *movieCodeLabel = [[UILabel alloc] init];
        movieCodeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        movieCodeLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        [productListView addSubview:movieCodeLabel];
        
        UILabel *movieCodeValueLabel = [[UILabel alloc] init];
        movieCodeValueLabel.numberOfLines = 0;
        movieCodeValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        movieCodeValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        [productListView addSubview:movieCodeValueLabel];
        
        
        movieNameLabel.text = strOfMovieProductNameLabel;
        movieMoneyLabel.text = strOfMovieProductMoneyLabel;
        movieMoneyValueLabel.text = strOfMovieProductMoneyValueLabel;
        movieCountLabel.text = strOfMovieProductCountLabel;
        movieCountValueLabel.text = strOfMovieProductCountValueLabel;
        movieCodeLabel.text = strOfMovieProductCodeLabel;
        movieCodeValueLabel.text = formatCodeStr;//strOfMovieProductFormatCodeValueLabel;
        goodsDescribeLabel.text = orderProduct.desc;
        
        [movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(movieImageView.mas_right).offset(15*Constants.screenWidthRate);
            make.top.equalTo(productListView.mas_top).offset((goodHeight+15)*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(strOfMovieProductNameLabelSize.width+1, strOfMovieProductNameLabelSize.height));
        }];
        
        [goodsDescribeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(movieImageView.mas_right).offset(15*Constants.screenWidthRate);
            make.top.equalTo(movieNameLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.right.equalTo(productListView.mas_right).offset(-15*Constants.screenWidthRate);
            make.height.equalTo(@(12*Constants.screenHeightRate));
        }];
        
        [movieMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(movieImageView.mas_right).offset(15*Constants.screenWidthRate);
            make.top.equalTo(movieNameLabel.mas_bottom).offset(105*Constants.screenHeightRate-strOfMovieProductNameLabelSize.height-strOfMovieProductMoneyLabelSize.height-strOfMovieProductCountLabelSize.height-strOfMovieProductCodeLabelSize.height - 12*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(strOfMovieProductMoneyLabelSize.width, strOfMovieProductMoneyLabelSize.height));
        }];
        
        [movieMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(movieMoneyLabel.mas_right).offset(4*Constants.screenWidthRate);
            make.centerY.equalTo(movieMoneyLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(strOfMovieProductMoneyValueLabelSize.width+1, strOfMovieProductMoneyValueLabelSize.height));
        }];
        
        [movieCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(movieImageView.mas_right).offset(15*Constants.screenWidthRate);
            make.top.equalTo(movieMoneyLabel.mas_bottom).offset(6*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(strOfMovieProductCountLabelSize.width+1, strOfMovieProductCountLabelSize.height));
        }];
        [movieCountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(movieCountLabel.mas_right).offset(4*Constants.screenWidthRate);
            make.centerY.equalTo(movieCountLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(strOfMovieProductCountValueLabelSize.width+1, strOfMovieProductCountValueLabelSize.height));
        }];
        
        [movieCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(movieImageView.mas_right).offset(15*Constants.screenWidthRate);
            make.top.equalTo(movieCountLabel.mas_bottom).offset(6*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(strOfMovieProductCodeLabelSize.width+1, strOfMovieProductCodeLabelSize.height));
        }];
        if (productList.count == 1) {
            [movieCodeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(movieCodeLabel.mas_right).offset(3*Constants.screenWidthRate);
                make.top.equalTo(movieCodeLabel.mas_top);
                make.size.mas_equalTo(CGSizeMake(strOfMovieProductCodeValueLabelSize.width+5, strOfMovieProductFormatCodeValueLabelSize.height+5));
            }];
            UIView *_lineView = [[UIView alloc] init];
            _lineView.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
            [productListView addSubview:_lineView];
            if (codeArr.count == 1) {
                
                 [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                         make.left.equalTo(productListView.mas_left).offset(15*Constants.screenWidthRate);
                         make.right.equalTo(productListView);
                         make.top.equalTo(movieImageView.mas_bottom).offset(15*Constants.screenHeightRate);
                         make.height.equalTo(@1);
                     }];
            } else {
                [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(productListView.mas_left).offset(15*Constants.screenWidthRate);
                    make.right.equalTo(productListView);
                    make.top.equalTo(movieCodeValueLabel.mas_bottom).offset(15*Constants.screenHeightRate);
                    make.height.equalTo(@1);
                }];
            }
            
            
        } else {
            [movieCodeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(movieCodeLabel.mas_right).offset(3*Constants.screenWidthRate);
                make.top.equalTo(movieCodeLabel.mas_top);
                make.size.mas_equalTo(CGSizeMake(strOfMovieProductCodeValueLabelSize.width+5, strOfMovieProductFormatCodeValueLabelSize.height+5));
            }];
            UIView *_lineView = [[UIView alloc] init];
            _lineView.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
            [productListView addSubview:_lineView];
            if (codeArr.count == 1) {
                
                 [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                     make.left.equalTo(productListView.mas_left).offset(15*Constants.screenWidthRate);
                     make.right.equalTo(productListView);
                     make.top.equalTo(movieImageView.mas_bottom).offset(15*Constants.screenHeightRate);
                     make.height.equalTo(@1);
                 }];
            } else {
                [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(productListView.mas_left).offset(15*Constants.screenWidthRate);
                    make.right.equalTo(productListView);
                    make.top.equalTo(movieCodeValueLabel.mas_bottom).offset(15*Constants.screenHeightRate);
                    make.height.equalTo(@1);
                }];
            }
            
        }
        
        
        if (codeArr.count > 1) {
            goodCodeHeight += strOfMovieProductFormatCodeValueLabelSize.height - strOfMovieProductCodeLabelSize.height;
            
        } else {
            goodCodeHeight = 0.0;
        }
        
        goodHeight += 136+goodCodeHeight;
    }
    return productListView;
}

- (UIScrollView *)holder {
    if (!_holder) {
        _holder = [[UIScrollView alloc] init];
        _holder.backgroundColor = [UIColor whiteColor];
        [_holder setShowsVerticalScrollIndicator:NO];
        [_holder setShowsHorizontalScrollIndicator:NO];
    }
    return _holder;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)orderNoLabel {
    if (!_orderNoLabel) {
        _orderNoLabel = [[UILabel alloc] init];
        _orderNoLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _orderNoLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _orderNoLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderNoLabel;
}


- (UIImageView *)movieImageView {
    if (!_movieImageView) {
        _movieImageView = [[UIImageView alloc] init];
        _movieImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _movieImageView;
}

- (UILabel *)cinemaNameLabel {
    if (!_cinemaNameLabel) {
        _cinemaNameLabel = [[UILabel alloc] init];
        _cinemaNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _cinemaNameLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
        _cinemaNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _cinemaNameLabel;
}

- (UILabel *)totalMoneyLabel {
    if (!_totalMoneyLabel) {
        _totalMoneyLabel = [[UILabel alloc] init];
        _totalMoneyLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _totalMoneyLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _totalMoneyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _totalMoneyLabel;
}

- (UIView *)line1View {
    if (!_line1View) {
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line1View;
}

- (UILabel *)movieNameLabel {
    if (!_movieNameLabel) {
        _movieNameLabel = [[UILabel alloc] init];
        _movieNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieNameLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
        _movieNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieNameLabel;
}

- (UILabel *)movieEnglishNameLabel {
    if (!_movieEnglishNameLabel) {
        _movieEnglishNameLabel = [[UILabel alloc] init];
        _movieEnglishNameLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieEnglishNameLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
        _movieEnglishNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieEnglishNameLabel;
}

- (UILabel *)movieTypeLabel {
    if (!_movieTypeLabel) {
        _movieTypeLabel = [[UILabel alloc] init];
        _movieTypeLabel.layer.cornerRadius = 3.5;
        _movieTypeLabel.clipsToBounds = YES;
        _movieTypeLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieTypeLabel.backgroundColor = [UIColor colorWithHex:@"ffcc00"];
        _movieTypeLabel.font = [UIFont systemFontOfSize:12*Constants.screenWidthRate];
        _movieTypeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _movieTypeLabel;
}

- (UILabel *)movieLanguageLabel {
    if (!_movieLanguageLabel) {
        _movieLanguageLabel = [[UILabel alloc] init];
        _movieLanguageLabel.layer.cornerRadius = 3.5;
        _movieLanguageLabel.clipsToBounds = YES;
        _movieLanguageLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        _movieLanguageLabel.backgroundColor = [UIColor colorWithHex:@"#333333"];
        _movieLanguageLabel.font = [UIFont systemFontOfSize:12*Constants.screenWidthRate];
        _movieLanguageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _movieLanguageLabel;
}

- (UILabel *)movieHallLabel {
    if (!_movieHallLabel) {
        _movieHallLabel = [[UILabel alloc] init];
        _movieHallLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieHallLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
        _movieHallLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieHallLabel;
}

- (UILabel *)movieHallNameLabel {
    if (!_movieHallNameLabel) {
        _movieHallNameLabel = [[UILabel alloc] init];
        _movieHallNameLabel.numberOfLines = 3;
        _movieHallNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieHallNameLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieHallNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieHallNameLabel;
}

- (UILabel *)movieTimeLabel {
    if (!_movieTimeLabel) {
        _movieTimeLabel = [[UILabel alloc] init];
        _movieTimeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieTimeLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
        _movieTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieTimeLabel;
}

- (UILabel *)movieTimeValueLabel {
    if (!_movieTimeValueLabel) {
        _movieTimeValueLabel = [[UILabel alloc] init];
        _movieTimeValueLabel.numberOfLines = 3;
        _movieTimeValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieTimeValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieTimeValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieTimeValueLabel;
}

- (UILabel *)movieSeatLabel {
    if (!_movieSeatLabel) {
        _movieSeatLabel = [[UILabel alloc] init];
        _movieSeatLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieSeatLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
        _movieSeatLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieSeatLabel;
}

- (UILabel *)movieSeatNameLabel {
    if (!_movieSeatNameLabel) {
        _movieSeatNameLabel = [[UILabel alloc] init];
        _movieSeatNameLabel.numberOfLines = 3;
        _movieSeatNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieSeatNameLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieSeatNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieSeatNameLabel;
}

- (UIView *)line2View {
    if (!_line2View) {
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line2View;
}

- (UILabel *)moviePhoneLabel {
    if (!_moviePhoneLabel) {
        _moviePhoneLabel = [[UILabel alloc] init];
        _moviePhoneLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePhoneLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
        _moviePhoneLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePhoneLabel;
}

- (UILabel *)moviePhoneValueLabel {
    if (!_moviePhoneValueLabel) {
        _moviePhoneValueLabel = [[UILabel alloc] init];
        _moviePhoneValueLabel.numberOfLines = 3;
        _moviePhoneValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePhoneValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePhoneValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePhoneValueLabel;
}

- (UILabel *)movieCodeLabel {
    if (!_movieCodeLabel) {
        _movieCodeLabel = [[UILabel alloc] init];
        _movieCodeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieCodeLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
        _movieCodeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieCodeLabel;
}

- (UILabel *)movieCodeValueLabel {
    if (!_movieCodeValueLabel) {
        _movieCodeValueLabel = [[UILabel alloc] init];
        _movieCodeValueLabel.numberOfLines = 3;
        _movieCodeValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieCodeValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieCodeValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieCodeValueLabel;
}

- (UILabel *)movieCode2Label {
    if (!_movieCode2Label) {
        _movieCode2Label = [[UILabel alloc] init];
        _movieCode2Label.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieCode2Label.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
        _movieCode2Label.textAlignment = NSTextAlignmentLeft;
    }
    return _movieCode2Label;
}

- (UILabel *)movieCode2ValueLabel {
    if (!_movieCode2ValueLabel) {
        _movieCode2ValueLabel = [[UILabel alloc] init];
        _movieCode2ValueLabel.numberOfLines = 3;
        _movieCode2ValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieCode2ValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieCode2ValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieCode2ValueLabel;
}

- (UIView *)line3View {
    if (!_line3View) {
        _line3View = [[UIView alloc] init];
        _line3View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line3View;
}

- (UILabel *)movieOrderTimeLabel {
    if (!_movieOrderTimeLabel) {
        _movieOrderTimeLabel = [[UILabel alloc] init];
        _movieOrderTimeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieOrderTimeLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieOrderTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieOrderTimeLabel;
}

- (UILabel *)movieOrderTimeValueLabel {
    if (!_movieOrderTimeValueLabel) {
        _movieOrderTimeValueLabel = [[UILabel alloc] init];
        _movieOrderTimeValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieOrderTimeValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieOrderTimeValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieOrderTimeValueLabel;
}

- (UILabel *)movieOrderStatusLabel {
    if (!_movieOrderStatusLabel) {
        _movieOrderStatusLabel = [[UILabel alloc] init];
        _movieOrderStatusLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieOrderStatusLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieOrderStatusLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieOrderStatusLabel;
}

- (UILabel *)movieOrderStatusValueLabel {
    if (!_movieOrderStatusValueLabel) {
        _movieOrderStatusValueLabel = [[UILabel alloc] init];
        _movieOrderStatusValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieOrderStatusValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieOrderStatusValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieOrderStatusValueLabel;
}

- (UIView *)line4View {
    if (!_line4View) {
        _line4View = [[UIView alloc] init];
        _line4View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line4View;
}

- (UIView *)discountView {
    if (!_discountView) {
        _discountView = [[UIView alloc] init];
        _discountView.backgroundColor = [UIColor colorWithHex:@"#f2f4f5"];
    }
    return _discountView;
}

- (UILabel *)movieDiscountLabel {
    if (!_movieDiscountLabel) {
        _movieDiscountLabel = [[UILabel alloc] init];
        _movieDiscountLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieDiscountLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieDiscountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieDiscountLabel;
}


- (UIView *)line5View {
    if (!_line5View) {
        _line5View = [[UIView alloc] init];
        _line5View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line5View;
}

- (UILabel *)movieDiscountMethodLabel {
    if (!_movieDiscountMethodLabel) {
        _movieDiscountMethodLabel = [[UILabel alloc] init];
        _movieDiscountMethodLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieDiscountMethodLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieDiscountMethodLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieDiscountMethodLabel;
}

- (UILabel *)movieDiscountMethodValueLabel {
    if (!_movieDiscountMethodValueLabel) {
        _movieDiscountMethodValueLabel = [[UILabel alloc] init];
        _movieDiscountMethodValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieDiscountMethodValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieDiscountMethodValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieDiscountMethodValueLabel;
}

- (UILabel *)movieDiscountMoneyLabel {
    if (!_movieDiscountMoneyLabel) {
        _movieDiscountMoneyLabel = [[UILabel alloc] init];
        _movieDiscountMoneyLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieDiscountMoneyLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieDiscountMoneyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieDiscountMoneyLabel;
}

- (UILabel *)movieDiscountMoneyValueLabel {
    if (!_movieDiscountMoneyValueLabel) {
        _movieDiscountMoneyValueLabel = [[UILabel alloc] init];
        _movieDiscountMoneyValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieDiscountMoneyValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieDiscountMoneyValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieDiscountMoneyValueLabel;
}
- (UIView *)line6View {
    if (!_line6View) {
        _line6View = [[UIView alloc] init];
        _line6View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line6View;
}

- (UIView *)productView {
    if (!_productView) {
        _productView = [[UIView alloc] init];
        _productView.backgroundColor = [UIColor colorWithHex:@"#f2f4f5"];
    }
    return _productView;
}

- (UILabel *)movieProductLabel {
    if (!_movieProductLabel) {
        _movieProductLabel = [[UILabel alloc] init];
        _movieProductLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieProductLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieProductLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieProductLabel;
}

- (UIView *)line7View {
    if (!_line7View) {
        _line7View = [[UIView alloc] init];
        _line7View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line7View;
}

- (UIImageView *)movieProductImageView {
    if (!_movieProductImageView) {
        _movieProductImageView = [[UIImageView alloc] init];
        _movieProductImageView.layer.borderWidth = 1.0f;
        _movieProductImageView.layer.borderColor = [UIColor colorWithHex:@"#e0e0e0"].CGColor;
        _movieProductImageView.layer.cornerRadius = 5.0f;
        _movieProductImageView.clipsToBounds = YES;
    }
    return _movieProductImageView;
}

- (UILabel *)movieProductNameLabel {
    if (!_movieProductNameLabel) {
        _movieProductNameLabel = [[UILabel alloc] init];
        _movieProductNameLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieProductNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    }
    return _movieProductNameLabel;
}

- (UILabel *)movieProductMoneyLabel {
    if (!_movieProductMoneyLabel) {
        _movieProductMoneyLabel = [[UILabel alloc] init];
        _movieProductMoneyLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieProductMoneyLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    }
    return _movieProductMoneyLabel;
}
- (UILabel *)movieProductMoneyValueLabel {
    if (!_movieProductMoneyValueLabel) {
        _movieProductMoneyValueLabel = [[UILabel alloc] init];
        _movieProductMoneyValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieProductMoneyValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    }
    return _movieProductMoneyValueLabel;
}

- (UILabel *)movieProductCountLabel {
    if (!_movieProductCountLabel) {
        _movieProductCountLabel = [[UILabel alloc] init];
        _movieProductCountLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieProductCountLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    }
    return _movieProductCountLabel;
}
- (UILabel *)movieProductCountValueLabel {
    if (!_movieProductCountValueLabel) {
        _movieProductCountValueLabel = [[UILabel alloc] init];
        _movieProductCountValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieProductCountValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    }
    return _movieProductCountValueLabel;
}


- (UILabel *)movieProductCodeLabel {
    if (!_movieProductCodeLabel) {
        _movieProductCodeLabel = [[UILabel alloc] init];
        _movieProductCodeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieProductCodeLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    }
    return _movieProductCodeLabel;
}
- (UILabel *)movieProductCodeValueLabel {
    if (!_movieProductCodeValueLabel) {
        _movieProductCodeValueLabel = [[UILabel alloc] init];
        _movieProductCodeValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieProductCodeValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    }
    return _movieProductCodeValueLabel;
}

- (UIView *)line8View {
    if (!_line8View) {
        _line8View = [[UIView alloc] init];
        _line8View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line8View;
}

- (UILabel *)movieProductTimeLabel {
    if (!_movieProductTimeLabel) {
        _movieProductTimeLabel = [[UILabel alloc] init];
        _movieProductTimeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieProductTimeLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieProductTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieProductTimeLabel;
}

- (UILabel *)movieProductTimeValueLabel {
    if (!_movieProductTimeValueLabel) {
        _movieProductTimeValueLabel = [[UILabel alloc] init];
        _movieProductTimeValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieProductTimeValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieProductTimeValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieProductTimeValueLabel;
}

- (UILabel *)movieProductStatusLabel {
    if (!_movieProductStatusLabel) {
        _movieProductStatusLabel = [[UILabel alloc] init];
        _movieProductStatusLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieProductStatusLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieProductStatusLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieProductStatusLabel;
}

- (UILabel *)movieProductStatusValueLabel {
    if (!_movieProductStatusValueLabel) {
        _movieProductStatusValueLabel = [[UILabel alloc] init];
        _movieProductStatusValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieProductStatusValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieProductStatusValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieProductStatusValueLabel;
}

- (UIView *)line9View {
    if (!_line9View) {
        _line9View = [[UIView alloc] init];
        _line9View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line9View;
}

- (UIView *)line10View {
    if (!_line10View) {
        _line10View = [[UIView alloc] init];
        _line10View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line10View;
}
- (UIView *)line11View {
    if (!_line11View) {
        _line11View = [[UIView alloc] init];
        _line11View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line11View;
}
- (UIView *)line12View {
    if (!_line12View) {
        _line12View = [[UIView alloc] init];
        _line12View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line12View;
}
- (UIView *)line13View {
    if (!_line13View) {
        _line13View = [[UIView alloc] init];
        _line13View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line13View;
}

- (UIView *)payView {
    if (!_payView) {
        _payView = [[UIView alloc] init];
        _payView.backgroundColor = [UIColor colorWithHex:@"#f2f4f5"];
    }
    return _payView;
}

- (UILabel *)moviePayLabel {
    if (!_moviePayLabel) {
        _moviePayLabel = [[UILabel alloc] init];
        _moviePayLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayLabel;
}

- (UILabel *)moviePayMethodLabel {
    if (!_moviePayMethodLabel) {
        _moviePayMethodLabel = [[UILabel alloc] init];
        _moviePayMethodLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayMethodLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayMethodLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayMethodLabel;
}

- (UILabel *)moviePayMethodValueLabel {
    if (!_moviePayMethodValueLabel) {
        _moviePayMethodValueLabel = [[UILabel alloc] init];
        _moviePayMethodValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayMethodValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayMethodValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayMethodValueLabel;
}

- (UILabel *)moviePayTotalMoneyLabel {
    if (!_moviePayTotalMoneyLabel) {
        _moviePayTotalMoneyLabel = [[UILabel alloc] init];
        _moviePayTotalMoneyLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayTotalMoneyLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayTotalMoneyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayTotalMoneyLabel;
}

- (UILabel *)moviePayTotalMoneyValueLabel {
    if (!_moviePayTotalMoneyValueLabel) {
        _moviePayTotalMoneyValueLabel = [[UILabel alloc] init];
        _moviePayTotalMoneyValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayTotalMoneyValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayTotalMoneyValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayTotalMoneyValueLabel;
}

- (UILabel *)moviePayDiscountLabel {
    if (!_moviePayDiscountLabel) {
        _moviePayDiscountLabel = [[UILabel alloc] init];
        _moviePayDiscountLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayDiscountLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayDiscountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayDiscountLabel;
}

- (UILabel *)moviePayDiscountValueLabel {
    if (!_moviePayDiscountValueLabel) {
        _moviePayDiscountValueLabel = [[UILabel alloc] init];
        _moviePayDiscountValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayDiscountValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayDiscountValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayDiscountValueLabel;
}

- (UILabel *)moviePayRealMoneyLabel {
    if (!_moviePayRealMoneyLabel) {
        _moviePayRealMoneyLabel = [[UILabel alloc] init];
        _moviePayRealMoneyLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayRealMoneyLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayRealMoneyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayRealMoneyLabel;
}

- (UILabel *)moviePayRealMoneyValueLabel {
    if (!_moviePayRealMoneyValueLabel) {
        _moviePayRealMoneyValueLabel = [[UILabel alloc] init];
        _moviePayRealMoneyValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayRealMoneyValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayRealMoneyValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayRealMoneyValueLabel;
}

- (UILabel *)moviePayServiceMoneyLabel {
    if (!_moviePayServiceMoneyLabel) {
        _moviePayServiceMoneyLabel = [[UILabel alloc] init];
        _moviePayServiceMoneyLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayServiceMoneyLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
        _moviePayServiceMoneyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayServiceMoneyLabel;
}

- (UILabel *)moviePayTimeLabel {
    if (!_moviePayTimeLabel) {
        _moviePayTimeLabel = [[UILabel alloc] init];
        _moviePayTimeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayTimeLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayTimeLabel;
}

- (UILabel *)moviePayTimeValueLabel {
    if (!_moviePayTimeValueLabel) {
        _moviePayTimeValueLabel = [[UILabel alloc] init];
        _moviePayTimeValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayTimeValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayTimeValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayTimeValueLabel;
}

- (UILabel *)moviePayStatusLabel {
    if (!_moviePayStatusLabel) {
        _moviePayStatusLabel = [[UILabel alloc] init];
        _moviePayStatusLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayStatusLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayStatusLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayStatusLabel;
}

- (UILabel *)moviePayStatusValueLabel {
    if (!_moviePayStatusValueLabel) {
        _moviePayStatusValueLabel = [[UILabel alloc] init];
        _moviePayStatusValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayStatusValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _moviePayStatusValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayStatusValueLabel;
}


/**
 //MARK: 订单号字符串格式化
 @param orderNo 订单号
 @param position 每隔多少位空一格
 @return 返回格式化后的字符串
 */
- (NSString *)formatOrderNo:(NSString *)orderNo andSpacePosition:(int)position {
    NSString *str1 = nil;
    NSString *str2 = nil;
    if (orderNo.length%position == 0) {
        for (int i = 0; i < (orderNo.length/position); i++) {
            NSString *tmpStr = [orderNo substringWithRange:NSMakeRange(i*position, position)];
            str1 = [tmpStr stringByAppendingString:@" "];
            if (str2.length == 0) {
                str2 = str1;
            } else {
                str2 = [str2 stringByAppendingString:str1];
            }
        }
    } else {
        for (int i = 0; i < (orderNo.length/position); i++) {
            NSString *tmpStr = [orderNo substringWithRange:NSMakeRange(i*position, position)];
            str1 = [tmpStr stringByAppendingString:@" "];
            if (str2.length == 0) {
                str2 = str1;
            } else {
                str2 = [str2 stringByAppendingString:str1];
            }
        }
        NSString *tmpStrOfLast = [orderNo substringWithRange:NSMakeRange(orderNo.length - orderNo.length%position, orderNo.length%position)];
        str1 = [tmpStrOfLast stringByAppendingString:@" "];
        str2 = [str2 stringByAppendingString:str1];
    }
    
    return str2;
}

//MARK: 手机号344格式
- (NSString *)formatPhoneNum:(NSString *)phoneNumStr {
    NSString *str1 = [phoneNumStr substringWithRange:NSMakeRange(0, 3)];
    NSString *str2 = [phoneNumStr substringWithRange:NSMakeRange(3, 4)];
    NSString *str3 = [phoneNumStr substringWithRange:NSMakeRange(7, 4)];
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@", str1, str2, str3];
    return str;
}

#pragma mark - 设置导航条
-(void)setUpNavBar
{
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"titlebar_back1"] WithHighlighted:[UIImage imageNamed:@"titlebar_back1"] Target:self action:@selector(cancelViewController)];
    UIImage *leftBarImage = [UIImage imageNamed:@"titlebar_back1"];
    leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0, 0, leftBarImage.size.width, leftBarImage.size.height);
    [leftBarBtn setImage:leftBarImage
                forState:UIControlStateNormal];
    leftBarBtn.backgroundColor = [UIColor clearColor];
    [leftBarBtn addTarget:self
                   action:@selector(cancelViewController)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void) cancelViewController {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark scrollview delegate
// 滑动到顶部时调用该方法
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
}

// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

// scrollView 结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

// scrollView 开始减速（以下两个方法注意与以上两个方法加以区别）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

// scrollview 减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    DLog(@"scrollViewDidEndDecelerating");
}

- (NSString *) getSeatInfoFormatStr:(NSString *)seatInfoStr {
    NSString *seatStr = nil;
    NSString *str1 = nil;
    NSString *str2 = nil;
    NSString *str3 = nil;
    NSString *str4 = nil;
    NSArray *seatArr = [seatInfoStr componentsSeparatedByString:@","];
    if (seatArr.count%2 == 0) {
        //最多4个座位，2个4个
        if (seatArr.count == 2) {
            str1 = [seatArr objectAtIndex:0];
            str2 = [seatArr objectAtIndex:1];
            if (str2.length > 0) {
                seatStr = [NSString stringWithFormat:@"%@/%@", str1, str2];
            } else {
                seatStr = [NSString stringWithFormat:@"%@", str1];
            }
        }
        if (seatArr.count == 4) {
            str1 = [seatArr objectAtIndex:0];
            str2 = [seatArr objectAtIndex:1];
            str3 = [seatArr objectAtIndex:2];
            str4 = [seatArr objectAtIndex:3];
            if (str4.length > 0) {
                seatStr = [NSString stringWithFormat:@"%@/%@\n%@/%@",str1 ,str2, str3, str4];
            } else {
                seatStr = [NSString stringWithFormat:@"%@/%@\n%@ ",str1 ,str2, str3];
            }
        }
    } else {
        //1个，3个
        if (seatArr.count == 1) {
            str1 = [seatArr objectAtIndex:0];
            seatStr = [NSString stringWithFormat:@"%@", str1];
        }
        if (seatArr.count == 3) {
            str1 = [seatArr objectAtIndex:0];
            str2 = [seatArr objectAtIndex:1];
            str3 = [seatArr objectAtIndex:2];
            if (str3.length > 0) {
                seatStr = [NSString stringWithFormat:@"%@/%@\n%@",str1 ,str2, str3];
            } else {
                seatStr = [NSString stringWithFormat:@"%@/%@",str1 ,str2];
            }
        }
    }
    return seatStr;
}

- (NSString *)stringFromDateMMDDHHmm:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    return [dateFormatter stringFromDate:date];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
