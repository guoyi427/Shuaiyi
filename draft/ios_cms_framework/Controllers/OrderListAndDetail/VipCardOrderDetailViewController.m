//
//  VipCardOrderDetailViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "VipCardOrderDetailViewController.h"
#import "OrderDetailOfMovie.h"
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "DataEngine.h"
#import <DateEngine_KKZ/DateEngine.h>
#import "KKZTextUtility.h"

@interface VipCardOrderDetailViewController ()<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL isHaveDiscountInOrder;

@property (nonatomic, strong) UIScrollView *holder;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *orderNoLabel;

@property (nonatomic, strong) UIView  *line1View;
@property (nonatomic, strong) UIImageView *movieCardImageView;
@property (nonatomic, strong) UILabel *movieCardCinemaNameLabel;
@property (nonatomic, strong) UILabel *movieCardNoLabel;
@property (nonatomic, strong) UILabel *movieCardNoValueLabel;
@property (nonatomic, strong) UILabel *movieCardMoneyLabel;
@property (nonatomic, strong) UILabel *movieCardMoneyValueLabel;
@property (nonatomic, strong) UILabel *movieCardPhoneLabel;
@property (nonatomic, strong) UILabel *movieCardPhoneValueLabel;
@property (nonatomic, strong) UIView  *line2View;
@property (nonatomic, strong) UILabel *movieCardTimeLabel;
@property (nonatomic, strong) UILabel *movieCardTimeValueLabel;
@property (nonatomic, strong) UILabel *movieCardStatusLabel;
@property (nonatomic, strong) UILabel *movieCardStatusValueLabel;
@property (nonatomic, strong) UIView  *line3View;

@property (nonatomic, strong) UIView *line4View;
@property (nonatomic, strong) UIView *discountView;
@property (nonatomic, strong) UILabel *movieDiscountLabel;

@property (nonatomic, strong) UIView *line5View;

@property (nonatomic, strong) UILabel *movieDiscountMethodLabel,*movieDiscountMethodValueLabel;
@property (nonatomic, strong) UILabel *movieDiscountActivityLabel,*movieDiscountActivityValueLabel;
@property (nonatomic, strong) UILabel *movieDiscountMoneyLabel,*movieDiscountMoneyValueLabel;

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

@implementation VipCardOrderDetailViewController



- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"订单详情";
    [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.view addGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航条
    [self setUpNavBar];
    
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
    
    //MARK: 判断是否有优惠信息
    if (self.orderDetailOfMovie.discount.discountMoney.floatValue/100 > 0) {
        self.isHaveDiscountInOrder = YES;
    } else {
        self.isHaveDiscountInOrder = NO;
    }

    
    //MARK: --添加订单号View
    NSString *strOfOrderNo = self.orderDetailOfMovie.orderMain.orderCode;
    NSString *orderNoStr = [NSString stringWithFormat:@"订单号: %@", [self formatOrderNo:strOfOrderNo andSpacePosition:4]];
    CGSize orderNostrSize = [KKZTextUtility measureText:orderNoStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    
    [self.bgView addSubview:self.orderNoLabel];
    self.orderNoLabel.text = orderNoStr;
    [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.right.equalTo(self.bgView.mas_right).offset(-15*Constants.screenWidthRate);
        make.top.equalTo(self.bgView.mas_top).offset((42*Constants.screenHeightRate - orderNostrSize.height)/2);
        make.height.equalTo(@(orderNostrSize.height));
    }];
    [self.bgView addSubview:self.line1View];
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView.mas_top).offset(42*Constants.screenHeightRate);
        make.height.equalTo(@1);
    }];
    
    NSString *strOfMovieCardNoLabel = @"卡号:";
    NSString *strOfMovieCardMoneyLabel = @"金额:";
    NSString *strOfMovieCardPhoneLabel = @"手机号:";
    NSString *strOfMovieCardTimeLabel = @"下单时间：";
    NSString *strOfMovieCardStatusLabel = @"状态：";
    
    NSString *strOfMovieCardCinemaNameLabel = self.orderDetailOfMovie.orderMain.cinemaName;
    NSString *strOfMovieCardMoneyValueLabel = [NSString stringWithFormat:@"¥%.2f", self.orderDetailOfMovie.orderMain.originalPrice.floatValue/100];
    NSString *strOfMovieCardNoValueLabel = self.orderDetailOfMovie.orderMain.cardNo.length>0?[NSString stringWithFormat:@"%@", [self formatOrderNo:self.orderDetailOfMovie.orderMain.cardNo andSpacePosition:4]]:@"一";
    NSString *mobileStr = [NSString stringWithFormat:@"%@", self.orderDetailOfMovie.mobile];
    NSString *strOfMovieCardPhoneValueLabel = (mobileStr.length > 0)?mobileStr:@"一";
    NSString *strOfMovieCardTimeValueLabel = self.orderDetailOfMovie.orderMain.createTime.longLongValue>0? [[DateEngine sharedDateEngine] stringFromDateY:[NSDate dateWithTimeIntervalSince1970:[self.orderDetailOfMovie.orderMain.createTime longLongValue]/1000]]:@"一";;
    NSString *strOfMovieCardStatusValueLabel = self.orderDetailOfMovie.ticketStatus.length>0?self.orderDetailOfMovie.ticketStatus:@"一";
    
    
    
    CGSize strOfMovieCardMoneyLabelSize = [KKZTextUtility measureText:strOfMovieCardMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieCardNoLabelSize = [KKZTextUtility measureText:strOfMovieCardNoLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieCardPhoneLabelSize = [KKZTextUtility measureText:strOfMovieCardPhoneLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieCardTimeLabelSize = [KKZTextUtility measureText:strOfMovieCardTimeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieCardStatusLabelSize = [KKZTextUtility measureText:strOfMovieCardStatusLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieCardCinemaNameLabelSize = [KKZTextUtility measureText:strOfMovieCardCinemaNameLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
    CGSize strOfMovieCardMoneyValueLabelSize = [KKZTextUtility measureText:strOfMovieCardMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieCardNoValueLabelSize = [KKZTextUtility measureText:strOfMovieCardNoValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieCardPhoneValueLabelSize = [KKZTextUtility measureText:strOfMovieCardPhoneValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieCardTimeValueLabelSize = [KKZTextUtility measureText:strOfMovieCardTimeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    CGSize strOfMovieCardStatusValueLabelSize = [KKZTextUtility measureText:strOfMovieCardStatusValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    //MARK: --vipCard缩略图
    [self.bgView addSubview:self.movieCardImageView];
    UIImageView *movieCardImageView2 = [[UIImageView alloc] init];
    movieCardImageView2.contentMode = UIViewContentModeScaleAspectFit;
    [self.movieCardImageView addSubview:movieCardImageView2];
    [movieCardImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieCardImageView.mas_left).offset(15*Constants.screenWidthRate);
        make.right.equalTo(self.movieCardImageView.mas_right).offset(-15*Constants.screenWidthRate);
        make.top.equalTo(self.movieCardImageView.mas_top).offset(15*Constants.screenHeightRate);
        make.bottom.equalTo(self.movieCardImageView.mas_bottom).offset(-15*Constants.screenWidthRate);
    }];
//    UIImage *placeholderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"photo_nopic"] newSize:CGSizeMake(105*Constants.screenWidthRate, 105*Constants.screenHeightRate) bgColor:[UIColor colorWithHex:@"#f2f4f5" a:0.9]];
//    [self.movieCardImageView sd_setImageWithURL:[NSURL URLWithString:self.orderDetailOfMovie.orderTicket.thumbnailUrl] placeholderImage:placeholderImage];
//     futurecinema_xc

    movieCardImageView2.image = [UIImage imageNamed:@"futurecinema"];
    
    
    [self.movieCardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.line1View.mas_bottom).offset(15*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(105*Constants.screenWidthRate, 105*Constants.screenHeightRate));
    }];
    
    [self.bgView addSubview:self.movieCardCinemaNameLabel];
    [self.bgView addSubview:self.movieCardNoLabel];
    [self.bgView addSubview:self.movieCardMoneyLabel];
    [self.bgView addSubview:self.movieCardPhoneLabel];
    [self.bgView addSubview:self.movieCardNoValueLabel];
    [self.bgView addSubview:self.movieCardMoneyValueLabel];
    [self.bgView addSubview:self.movieCardPhoneValueLabel];
    [self.bgView addSubview:self.line2View];
    [self.bgView addSubview:self.movieCardTimeLabel];
    [self.bgView addSubview:self.movieCardTimeValueLabel];
    [self.bgView addSubview:self.movieCardStatusLabel];
    [self.bgView addSubview:self.movieCardStatusValueLabel];
    
    self.movieCardCinemaNameLabel.text = strOfMovieCardCinemaNameLabel;
    self.movieCardNoLabel.text = strOfMovieCardNoLabel;
    self.movieCardMoneyLabel.text = strOfMovieCardMoneyLabel;
    self.movieCardPhoneLabel.text = strOfMovieCardPhoneLabel;
    self.movieCardMoneyValueLabel.text = strOfMovieCardMoneyValueLabel;
    self.movieCardPhoneValueLabel.text = strOfMovieCardPhoneValueLabel;
    self.movieCardNoValueLabel.text = strOfMovieCardNoValueLabel;
    self.movieCardTimeLabel.text = strOfMovieCardTimeLabel;
    self.movieCardTimeValueLabel.text = strOfMovieCardTimeValueLabel;
    self.movieCardStatusLabel.text = strOfMovieCardStatusLabel;
    self.movieCardStatusValueLabel.text = strOfMovieCardStatusValueLabel;
    
    [self.movieCardCinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieCardImageView.mas_right).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.line1View.mas_bottom).offset(15*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCardCinemaNameLabelSize.width+5, strOfMovieCardCinemaNameLabelSize.height));
    }];
    [self.movieCardNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieCardImageView.mas_right).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.movieCardCinemaNameLabel.mas_bottom).offset(105*Constants.screenHeightRate-strOfMovieCardNoLabelSize.height-strOfMovieCardMoneyLabelSize.height-strOfMovieCardCinemaNameLabelSize.height-strOfMovieCardPhoneLabelSize.height - 12*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCardNoLabelSize.width+5, strOfMovieCardNoLabelSize.height));
    }];
    
    [self.movieCardNoValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieCardNoLabel.mas_right).offset(3*Constants.screenWidthRate);
        make.top.equalTo(self.movieCardCinemaNameLabel.mas_bottom).offset(105*Constants.screenHeightRate-strOfMovieCardNoLabelSize.height-strOfMovieCardMoneyLabelSize.height-strOfMovieCardCinemaNameLabelSize.height-strOfMovieCardPhoneLabelSize.height - 12*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCardNoValueLabelSize.width+1, strOfMovieCardNoValueLabelSize.height));
    }];
    
    [self.movieCardMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieCardImageView.mas_right).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.movieCardNoLabel.mas_bottom).offset(6*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCardMoneyLabelSize.width+1, strOfMovieCardMoneyLabelSize.height));
    }];
    [self.movieCardMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieCardMoneyLabel.mas_right).offset(3*Constants.screenWidthRate);
        make.top.equalTo(self.movieCardNoValueLabel.mas_bottom).offset(6*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCardMoneyValueLabelSize.width+1, strOfMovieCardMoneyValueLabelSize.height));
    }];
    
    [self.movieCardPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieCardImageView.mas_right).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.movieCardMoneyLabel.mas_bottom).offset(6*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCardPhoneLabelSize.width+1, strOfMovieCardPhoneLabelSize.height));
    }];
    [self.movieCardPhoneValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieCardPhoneLabel.mas_right).offset(3*Constants.screenWidthRate);
        make.top.equalTo(self.movieCardMoneyValueLabel.mas_bottom).offset(6*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCardPhoneValueLabelSize.width+1, strOfMovieCardPhoneValueLabelSize.height));
    }];
    
    [self.bgView addSubview:self.line2View];
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.movieCardImageView.mas_bottom).offset(15*Constants.screenHeightRate);
        make.height.equalTo(@1);
    }];
    
    [self.movieCardTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.line2View.mas_bottom).offset(15*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCardTimeLabelSize.width+5, strOfMovieCardTimeLabelSize.height));
    }];
    [self.movieCardTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2View.mas_bottom).offset(15*Constants.screenHeightRate);
        make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCardTimeValueLabelSize.width+1, strOfMovieCardTimeValueLabelSize.height));
    }];
    [self.movieCardStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.movieCardTimeValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCardStatusLabelSize.width+5, strOfMovieCardStatusLabelSize.height));
    }];
    [self.movieCardStatusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.movieCardTimeValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
        make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
        make.size.mas_equalTo(CGSizeMake(strOfMovieCardStatusValueLabelSize.width+1, strOfMovieCardStatusValueLabelSize.height));
    }];
    
    [self.bgView addSubview:self.line4View];
    [self.line4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.movieCardStatusLabel.mas_bottom).offset(15*Constants.screenHeightRate);
        make.height.equalTo(@1);
    }];
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
            make.top.equalTo(self.discountView.mas_top).offset((30*Constants.screenHeightRate - strOfMovieDiscountLabelSize.height)/2);
            make.size.mas_offset(CGSizeMake(strOfMovieDiscountLabelSize.width+1, strOfMovieDiscountLabelSize.height));
        }];
        [self.bgView addSubview:self.line5View];
        [self.line5View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgView);
            make.top.equalTo(self.discountView.mas_bottom).offset(0);
            make.height.equalTo(@1);
        }];
        
        NSString *strOfMovieDiscountMethodLabel = @"优惠方式：";
        NSString *strOfMovieDiscountMethodValueLabel = @"一";
        NSString *strOfMovieDiscountActivityLabel = @"优惠活动：";
        NSString *strOfMovieDiscountActivityValueLabel = @"一";
        NSString *strOfMovieDiscountMoneyLabel = @"优惠金额：";
        NSString *strOfMovieDiscountMoneyValueLabel = [NSString stringWithFormat:@"¥%.2f",self.orderDetailOfMovie.orderMain.originalPrice.floatValue>=self.orderDetailOfMovie.orderMain.receiveMoney.floatValue?(self.orderDetailOfMovie.orderMain.originalPrice.floatValue - self.orderDetailOfMovie.orderMain.receiveMoney.floatValue)/100:(self.orderDetailOfMovie.orderMain.receiveMoney.floatValue - self.orderDetailOfMovie.orderMain.originalPrice.floatValue)/100];
        //
        CGSize strOfMovieDiscountMethodLabelSize = [KKZTextUtility measureText:strOfMovieDiscountMethodLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieDiscountMethodValueLabelSize = [KKZTextUtility measureText:strOfMovieDiscountMethodValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieDiscountActivityLabelSize = [KKZTextUtility measureText:strOfMovieDiscountActivityLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieDiscountActivityValueLabelSize = [KKZTextUtility measureText:strOfMovieDiscountActivityValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieDiscountMoneyLabelSize = [KKZTextUtility measureText:strOfMovieDiscountMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        CGSize strOfMovieDiscountMoneyValueLabelSize = [KKZTextUtility measureText:strOfMovieDiscountMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        
        [self.bgView addSubview:self.movieDiscountMethodLabel];
        [self.bgView addSubview:self.movieDiscountMethodValueLabel];
        [self.bgView addSubview:self.movieDiscountActivityLabel];
        [self.bgView addSubview:self.movieDiscountActivityValueLabel];
        [self.bgView addSubview:self.movieDiscountMoneyLabel];
        [self.bgView addSubview:self.movieDiscountMoneyValueLabel];
        
        self.movieDiscountMethodLabel.text = strOfMovieDiscountMethodLabel;
        self.movieDiscountMethodValueLabel.text = strOfMovieDiscountMethodValueLabel;
        self.movieDiscountActivityLabel.text = strOfMovieDiscountActivityLabel;
        self.movieDiscountActivityValueLabel.text = strOfMovieDiscountActivityValueLabel;
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
        [self.movieDiscountActivityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
            make.top.equalTo(self.movieDiscountMethodValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(strOfMovieDiscountActivityLabelSize.width+1, strOfMovieDiscountActivityLabelSize.height));
        }];
        [self.movieDiscountActivityValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
            make.top.equalTo(self.movieDiscountMethodValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(strOfMovieDiscountActivityValueLabelSize.width+1, strOfMovieDiscountActivityValueLabelSize.height));
        }];
        [self.movieDiscountMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
            make.top.equalTo(self.movieDiscountActivityValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(strOfMovieDiscountMoneyLabelSize.width+1, strOfMovieDiscountMoneyLabelSize.height));
        }];
        [self.movieDiscountMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
            make.top.equalTo(self.movieDiscountActivityValueLabel.mas_bottom).offset(5*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(strOfMovieDiscountMoneyValueLabelSize.width+1, strOfMovieDiscountMoneyValueLabelSize.height));
        }];
        
        [self.bgView addSubview:self.line10View];
        [self.line10View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgView);
            make.top.equalTo(self.movieDiscountMoneyValueLabel.mas_bottom).offset(15*Constants.screenHeightRate);
            make.height.equalTo(@1);
        }];
    } else {
        
    }
    
    
    //MARK: --支付信息
    NSString *strOfMoviePayLabel = @"支付信息";
    NSString *strOfMoviePayMethodLabel = @"支付方式:";
    NSString *strOfMoviePayTotalMoneyLabel = @"总计金额:";
    NSString *strOfMoviePayDiscountLabel = @"优惠金额:";
    NSString *strOfMoviePayRealMoneyLabel = @"实付金额:";
    NSString *strOfMoviePayTimeLabel = @"支付时间:";
    NSString *strOfMoviePayStatusLabel = @"状态:";
    
    NSString *strOfMoviePayMethodValueLabel = self.orderDetailOfMovie.payType.length>0?self.orderDetailOfMovie.payType:@"一";
    NSString *strOfMoviePayTotalMoneyValueLabel = self.orderDetailOfMovie.orderMain.originalPrice.length>0?[NSString stringWithFormat:@"¥%.2f",self.orderDetailOfMovie.orderMain.originalPrice.floatValue/100]:@"一";
    NSString *strOfMoviePayDiscountValueLabel = [NSString stringWithFormat:@"-¥%.2f",self.orderDetailOfMovie.orderMain.originalPrice.floatValue>=self.orderDetailOfMovie.orderMain.receiveMoney.floatValue?(self.orderDetailOfMovie.orderMain.originalPrice.floatValue - self.orderDetailOfMovie.orderMain.receiveMoney.floatValue)/100:(self.orderDetailOfMovie.orderMain.receiveMoney.floatValue - self.orderDetailOfMovie.orderMain.originalPrice.floatValue)/100];
    NSString *strOfMoviePayRealMoneyValueLabel = self.orderDetailOfMovie.orderMain.receiveMoney.length>0?[NSString stringWithFormat:@"¥%.2f",self.orderDetailOfMovie.orderMain.receiveMoney.floatValue/100]:@"一";
    NSString *strOfMoviePayServiceLabel = [NSString stringWithFormat:@"已包含服务费 %@元", self.orderDetailOfMovie.serviceCharge];//@"已包含服务费 3元";
    NSString *strOfMoviePayTimeValueLabel = self.orderDetailOfMovie.payment.payTime.longLongValue/1000>0?[[DateEngine sharedDateEngine] stringFromDateY:[NSDate dateWithTimeIntervalSince1970:[self.orderDetailOfMovie.payment.payTime longLongValue]/1000]]:@"一";
    NSString *strOfMoviePayStatusValueLabel = self.orderDetailOfMovie.payStatus.length>0?self.orderDetailOfMovie.payStatus:@"一";;
    
    
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
//    [self.bgView addSubview:self.moviePayServiceMoneyLabel];
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
//    self.moviePayServiceMoneyLabel.text = strOfMoviePayServiceLabel;
    self.moviePayTimeLabel.text = strOfMoviePayTimeLabel;
    self.moviePayTimeValueLabel.text = strOfMoviePayTimeValueLabel;
    self.moviePayStatusLabel.text = strOfMoviePayStatusLabel;
    self.moviePayStatusValueLabel.text = strOfMoviePayStatusValueLabel;
    
    
    if (self.isHaveDiscountInOrder) {
        [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgView);
            make.top.equalTo(self.line10View.mas_bottom);
            make.height.equalTo(@(30*Constants.screenHeightRate));
        }];
    } else {
        [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.bgView);
            make.top.equalTo(self.line4View.mas_bottom);
            make.height.equalTo(@(30*Constants.screenHeightRate));
        }];
    }
    
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
        make.top.equalTo(self.moviePayTotalMoneyValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayDiscountLabelSize.width+1, strOfMoviePayDiscountLabelSize.height));
    }];
    [self.moviePayDiscountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moviePayTotalMoneyValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
        make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayDiscountValueLabelSize.width+1, strOfMoviePayDiscountValueLabelSize.height));
    }];
    [self.moviePayRealMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.top.equalTo(self.moviePayDiscountValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayRealMoneyLabelSize.width+1, strOfMoviePayRealMoneyLabelSize.height));
    }];
    [self.moviePayRealMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moviePayDiscountValueLabel.mas_bottom).offset(10*Constants.screenHeightRate);
        make.right.equalTo(self.bgView.mas_right).offset(-14*Constants.screenWidthRate);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayRealMoneyValueLabelSize.width+1, strOfMoviePayRealMoneyValueLabelSize.height));
    }];
    
    [self.line12View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.moviePayRealMoneyValueLabel.mas_bottom).offset(15*Constants.screenHeightRate);
        make.height.equalTo(@1);
    }];
//    [self.moviePayServiceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.bgView.mas_right).offset(-10*Constants.screenWidthRate);
//        make.top.equalTo(self.moviePayRealMoneyValueLabel.mas_bottom).offset(6*Constants.screenHeightRate);
//        make.size.mas_equalTo(CGSizeMake(strOfMoviePayServiceLabelSize.width+5, strOfMoviePayServiceLabelSize.height));
//    }];
//    
//    [self.line12View mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgView.mas_left).offset(15*Constants.screenWidthRate);
//        make.right.equalTo(self.bgView);
//        make.top.equalTo(self.moviePayServiceMoneyLabel.mas_bottom).offset(15*Constants.screenHeightRate);
//        make.height.equalTo(@1);
//    }];
    
    
    
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
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.line13View.mas_bottom).offset(10*Constants.screenHeightRate);
    }];
    [self.holder mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(80*Constants.screenHeightRate).priorityLow();
        make.bottom.mas_greaterThanOrEqualTo(self.view);
    }];
    
    
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

- (UIView *)line1View {
    if (!_line1View) {
        _line1View = [[UIView alloc] init];
        _line1View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line1View;
}

- (UIImageView *)movieCardImageView {
    if (!_movieCardImageView) {
        _movieCardImageView = [[UIImageView alloc] init];
        _movieCardImageView.layer.borderWidth = 1.0f;
        _movieCardImageView.layer.borderColor = [UIColor colorWithHex:@"#e0e0e0"].CGColor;
        _movieCardImageView.layer.cornerRadius = 5.0f;
        _movieCardImageView.contentMode = UIViewContentModeScaleAspectFit;
        _movieCardImageView.clipsToBounds = YES;
    }
    return _movieCardImageView;
}

- (UILabel *)movieCardCinemaNameLabel {
    if (!_movieCardCinemaNameLabel) {
        _movieCardCinemaNameLabel = [[UILabel alloc] init];
        _movieCardCinemaNameLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
        _movieCardCinemaNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    }
    return _movieCardCinemaNameLabel;
}

- (UILabel *)movieCardMoneyLabel {
    if (!_movieCardMoneyLabel) {
        _movieCardMoneyLabel = [[UILabel alloc] init];
        _movieCardMoneyLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieCardMoneyLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    }
    return _movieCardMoneyLabel;
}
- (UILabel *)movieCardMoneyValueLabel {
    if (!_movieCardMoneyValueLabel) {
        _movieCardMoneyValueLabel = [[UILabel alloc] init];
        _movieCardMoneyValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieCardMoneyValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    }
    return _movieCardMoneyValueLabel;
}

- (UILabel *)movieCardNoLabel {
    if (!_movieCardNoLabel) {
        _movieCardNoLabel = [[UILabel alloc] init];
        _movieCardNoLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieCardNoLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    }
    return _movieCardNoLabel;
}
- (UILabel *)movieCardNoValueLabel {
    if (!_movieCardNoValueLabel) {
        _movieCardNoValueLabel = [[UILabel alloc] init];
        _movieCardNoValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieCardNoValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    }
    return _movieCardNoValueLabel;
}


- (UILabel *)movieCardPhoneLabel {
    if (!_movieCardPhoneLabel) {
        _movieCardPhoneLabel = [[UILabel alloc] init];
        _movieCardPhoneLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieCardPhoneLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    }
    return _movieCardPhoneLabel;
}
- (UILabel *)movieCardPhoneValueLabel {
    if (!_movieCardPhoneValueLabel) {
        _movieCardPhoneValueLabel = [[UILabel alloc] init];
        _movieCardPhoneValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieCardPhoneValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    }
    return _movieCardPhoneValueLabel;
}

- (UIView *)line2View {
    if (!_line2View) {
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line2View;
}

- (UILabel *)movieCardTimeLabel {
    if (!_movieCardTimeLabel) {
        _movieCardTimeLabel = [[UILabel alloc] init];
        _movieCardTimeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieCardTimeLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieCardTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieCardTimeLabel;
}

- (UILabel *)movieCardTimeValueLabel {
    if (!_movieCardTimeValueLabel) {
        _movieCardTimeValueLabel = [[UILabel alloc] init];
        _movieCardTimeValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieCardTimeValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieCardTimeValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieCardTimeValueLabel;
}

- (UILabel *)movieCardStatusLabel {
    if (!_movieCardStatusLabel) {
        _movieCardStatusLabel = [[UILabel alloc] init];
        _movieCardStatusLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieCardStatusLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieCardStatusLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieCardStatusLabel;
}

- (UILabel *)movieCardStatusValueLabel {
    if (!_movieCardStatusValueLabel) {
        _movieCardStatusValueLabel = [[UILabel alloc] init];
        _movieCardStatusValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieCardStatusValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieCardStatusValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieCardStatusValueLabel;
}

- (UIView *)line3View {
    if (!_line3View) {
        _line3View = [[UIView alloc] init];
        _line3View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line3View;
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

- (UILabel *)movieDiscountActivityLabel {
    if (!_movieDiscountActivityLabel) {
        _movieDiscountActivityLabel = [[UILabel alloc] init];
        _movieDiscountActivityLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieDiscountActivityLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieDiscountActivityLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieDiscountActivityLabel;
}

- (UILabel *)movieDiscountActivityValueLabel {
    if (!_movieDiscountActivityValueLabel) {
        _movieDiscountActivityValueLabel = [[UILabel alloc] init];
        _movieDiscountActivityValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieDiscountActivityValueLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
        _movieDiscountActivityValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieDiscountActivityValueLabel;
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
    //    self.navigationItem.titleView = self.titleViewOfBar;
    
}

- (void) cancelViewController {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
