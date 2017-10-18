//
//  ProductOrderViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "ProductOrderViewController.h"
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKZTextUtility.h"


@interface ProductOrderViewController ()<UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView *holder;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *orderNoLabel;

@property (nonatomic, strong) UIView  *line1View;

@property (nonatomic, strong) UILabel *movieProductCinemaNameLabel;
@property (nonatomic, strong) UIImageView *movieProductImageView;
@property (nonatomic, strong) UILabel *movieProductNameLabel;
@property (nonatomic, strong) UILabel *movieProductMoneyLabel;
@property (nonatomic, strong) UILabel *movieProductMoneyValueLabel;
@property (nonatomic, strong) UILabel *movieProductCountLabel;
@property (nonatomic, strong) UILabel *movieProductCountValueLabel;
@property (nonatomic, strong) UILabel *movieProductCodeLabel;
@property (nonatomic, strong) UILabel *movieProductCodeValueLabel;
@property (nonatomic, strong) UILabel *movieProductCode2Label;
@property (nonatomic, strong) UILabel *movieProductCode2ValueLabel;
@property (nonatomic, strong) UIView  *line2View;
@property (nonatomic, strong) UILabel *movieProductTimeLabel;
@property (nonatomic, strong) UILabel *movieProductTimeValueLabel;
@property (nonatomic, strong) UILabel *movieProductStatusLabel;
@property (nonatomic, strong) UILabel *movieProductStatusValueLabel;
@property (nonatomic, strong) UIView  *line3View;


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

@implementation ProductOrderViewController


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
    
    //MARK: --添加订单号View
    NSString *strOfOrderNo = @"12341234123412341234";
    NSString *orderNoStr = [NSString stringWithFormat:@"订单号: %@", [self formatOrderNo:strOfOrderNo andSpacePosition:4]];
    CGSize orderNostrSize = [KKZTextUtility measureText:orderNoStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    
    [self.bgView addSubview:self.orderNoLabel];
    self.orderNoLabel.text = orderNoStr;
    [self.orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.right.equalTo(self.bgView.mas_right).offset(-15);
        make.top.equalTo(self.bgView.mas_top).offset((42 - orderNostrSize.height)/2);
        make.height.equalTo(@(orderNostrSize.height));
    }];
    [self.bgView addSubview:self.line1View];
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView.mas_top).offset(42);
        make.height.equalTo(@1);
    }];
    
    NSString *strOfMovieProductCinemaNameLabel = @"未来影城通州北苑旗舰店";
    CGSize strOfMovieProductCinemaNameLabelSize = [KKZTextUtility measureText:strOfMovieProductCinemaNameLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
    
    [self.bgView addSubview:self.movieProductCinemaNameLabel];
    self.movieProductCinemaNameLabel.text = strOfMovieProductCinemaNameLabel;
    [self.movieProductCinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.line1View.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductCinemaNameLabelSize.width+1, strOfMovieProductCinemaNameLabelSize.height));
    }];
    
    
    NSString *strOfMovieProductMoneyLabel = @"单价:";
    NSString *strOfMovieProductCountLabel = @"数量:";
    NSString *strOfMovieProductCodeLabel = @"票号:";
    NSString *strOfMovieProductCode2Label = @"取货码:";
    NSString *strOfMovieProductTimeLabel = @"下单时间：";
    NSString *strOfMovieProductStatusLabel = @"状态：";
    
    NSString *strOfMovieProductNameLabel = @"欢乐单人观影小吃套餐";
    NSString *strOfMovieProductMoneyValueLabel = [NSString stringWithFormat:@"¥%@", @"40"];
    NSString *strOfMovieProductCountValueLabel = [NSString stringWithFormat:@"%@", @"2"];
    NSString *strOfMovieProductCodeValueLabel = [NSString stringWithFormat:@"%@", [self formatOrderNo:@"12233344568426686549" andSpacePosition:4]];
    NSString *strOfMovieProductCode2ValueLabel = [NSString stringWithFormat:@"%@", [self formatOrderNo:@"12233344568426686549" andSpacePosition:4]];
    NSString *strOfMovieProductTimeValueLabel = @"2017-01-18 12:30";
    NSString *strOfMovieProductStatusValueLabel = @"已完成";
    
    CGSize strOfMovieProductMoneyLabelSize = [KKZTextUtility measureText:strOfMovieProductMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMovieProductCountLabelSize = [KKZTextUtility measureText:strOfMovieProductCountLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMovieProductCodeLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMovieProductCode2LabelSize = [KKZTextUtility measureText:strOfMovieProductCode2Label size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMovieProductTimeLabelSize = [KKZTextUtility measureText:strOfMovieProductTimeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMovieProductStatusLabelSize = [KKZTextUtility measureText:strOfMovieProductStatusLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMovieProductNameLabelSize = [KKZTextUtility measureText:strOfMovieProductNameLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMovieProductMoneyValueLabelSize = [KKZTextUtility measureText:strOfMovieProductMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMovieProductCountValueLabelSize = [KKZTextUtility measureText:strOfMovieProductCountValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMovieProductCodeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductCodeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMovieProductCode2ValueLabelSize = [KKZTextUtility measureText:strOfMovieProductCode2ValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMovieProductTimeValueLabelSize = [KKZTextUtility measureText:strOfMovieProductTimeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMovieProductStatusValueLabelSize = [KKZTextUtility measureText:strOfMovieProductStatusValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    //MARK: 卖品缩略图
    [self.bgView addSubview:self.movieProductImageView];
    [self.movieProductImageView sd_setImageWithURL:[NSURL URLWithString:@"http://img.komovie.cn/poster/big/14812494497368.jpg"] placeholderImage:nil];
    [self.movieProductImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.movieProductCinemaNameLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(105, 105));
    }];
    
    [self.bgView addSubview:self.movieProductNameLabel];
    [self.bgView addSubview:self.movieProductMoneyLabel];
    [self.bgView addSubview:self.movieProductMoneyValueLabel];
    [self.bgView addSubview:self.movieProductCountLabel];
    [self.bgView addSubview:self.movieProductCountValueLabel];
    [self.bgView addSubview:self.movieProductCodeLabel];
    [self.bgView addSubview:self.movieProductCodeValueLabel];
    [self.bgView addSubview:self.movieProductCode2Label];
    [self.bgView addSubview:self.movieProductCode2ValueLabel];
    [self.bgView addSubview:self.movieProductTimeLabel];
    [self.bgView addSubview:self.movieProductTimeValueLabel];
    [self.bgView addSubview:self.movieProductStatusLabel];
    [self.bgView addSubview:self.movieProductStatusValueLabel];
    
    self.movieProductNameLabel.text = strOfMovieProductNameLabel;
    self.movieProductMoneyLabel.text = strOfMovieProductMoneyLabel;
    self.movieProductMoneyValueLabel.text = strOfMovieProductMoneyValueLabel;
    self.movieProductCountLabel.text = strOfMovieProductCountLabel;
    self.movieProductCountValueLabel.text = strOfMovieProductCountValueLabel;
    self.movieProductCodeLabel.text = strOfMovieProductCodeLabel;
    self.movieProductCodeValueLabel.text = strOfMovieProductCodeValueLabel;
    self.movieProductCode2Label.text = strOfMovieProductCode2Label;
    self.movieProductCode2ValueLabel.text = strOfMovieProductCode2ValueLabel;
    self.movieProductTimeLabel.text = strOfMovieProductTimeLabel;
    self.movieProductTimeValueLabel.text = strOfMovieProductTimeValueLabel;
    self.movieProductStatusLabel.text = strOfMovieProductStatusLabel;
    self.movieProductStatusValueLabel.text = strOfMovieProductStatusValueLabel;
    
    [self.movieProductNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieProductImageView.mas_right).offset(15);
        make.top.equalTo(self.movieProductCinemaNameLabel.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductNameLabelSize.width+1, strOfMovieProductNameLabelSize.height));
    }];
    [self.movieProductMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieProductImageView.mas_right).offset(15);
        make.top.equalTo(self.movieProductNameLabel.mas_bottom).offset(105-strOfMovieProductNameLabelSize.height-strOfMovieProductMoneyLabelSize.height-strOfMovieProductCountLabelSize.height-strOfMovieProductCodeLabelSize.height -strOfMovieProductCode2LabelSize.height- 18);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductMoneyLabelSize.width, strOfMovieProductMoneyLabelSize.height));
    }];
    
    [self.movieProductMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieProductMoneyLabel.mas_right).offset(4);
        make.top.equalTo(self.movieProductNameLabel.mas_bottom).offset(105-strOfMovieProductNameLabelSize.height-strOfMovieProductMoneyLabelSize.height-strOfMovieProductCountLabelSize.height-strOfMovieProductCodeLabelSize.height -strOfMovieProductCode2LabelSize.height- 18);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductMoneyValueLabelSize.width+1, strOfMovieProductMoneyValueLabelSize.height));
    }];
    
    [self.movieProductCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieProductImageView.mas_right).offset(15);
        make.top.equalTo(self.movieProductMoneyLabel.mas_bottom).offset(6);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductCountLabelSize.width, strOfMovieProductCountLabelSize.height));
    }];
    [self.movieProductCountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieProductCountLabel.mas_right).offset(4);
        make.top.equalTo(self.movieProductMoneyValueLabel.mas_bottom).offset(6);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductCountValueLabelSize.width+1, strOfMovieProductCountValueLabelSize.height));
    }];
    
    [self.movieProductCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieProductImageView.mas_right).offset(15);
        make.top.equalTo(self.movieProductCountLabel.mas_bottom).offset(6);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductCodeLabelSize.width+1, strOfMovieProductCodeLabelSize.height));
    }];
    [self.movieProductCodeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieProductCodeLabel.mas_right).offset(3);
        make.top.equalTo(self.movieProductCountValueLabel.mas_bottom).offset(6);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductCodeValueLabelSize.width+2, strOfMovieProductCodeValueLabelSize.height));
    }];
    [self.movieProductCode2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieProductImageView.mas_right).offset(15);
        make.top.equalTo(self.movieProductCodeValueLabel.mas_bottom).offset(6);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductCode2LabelSize.width+2, strOfMovieProductCode2LabelSize.height));
    }];
    [self.movieProductCode2ValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.movieProductCode2Label.mas_right).offset(3);
        make.top.equalTo(self.movieProductCodeValueLabel.mas_bottom).offset(6);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductCode2ValueLabelSize.width+1, strOfMovieProductCode2ValueLabelSize.height));
    }];
    
    [self.bgView addSubview:self.line3View];
    [self.line3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.movieProductImageView.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    
    [self.movieProductTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.line3View.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductTimeLabelSize.width, strOfMovieProductTimeLabelSize.height));
    }];
    [self.movieProductTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line3View.mas_bottom).offset(15);
        make.right.equalTo(self.bgView.mas_right).offset(-14);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductTimeValueLabelSize.width+1, strOfMovieProductTimeValueLabelSize.height));
    }];
    [self.movieProductStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.movieProductTimeValueLabel.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductStatusLabelSize.width+5, strOfMovieProductStatusLabelSize.height));
    }];
    [self.movieProductStatusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.movieProductTimeValueLabel.mas_bottom).offset(5);
        make.right.equalTo(self.bgView.mas_right).offset(-14);
        make.size.mas_equalTo(CGSizeMake(strOfMovieProductStatusValueLabelSize.width+1, strOfMovieProductStatusValueLabelSize.height));
    }];
    
    [self.bgView addSubview:self.line10View];
    [self.line10View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.movieProductStatusValueLabel.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    NSString *strOfMoviePayLabel = @"支付信息";
    NSString *strOfMoviePayMethodLabel = @"支付方式:";
    NSString *strOfMoviePayTotalMoneyLabel = @"总计金额:";
    NSString *strOfMoviePayDiscountLabel = @"优惠金额:";
    NSString *strOfMoviePayRealMoneyLabel = @"实付金额:";
    NSString *strOfMoviePayTimeLabel = @"下单时间:";
    NSString *strOfMoviePayStatusLabel = @"状态:";
    
    NSString *strOfMoviePayMethodValueLabel = @"微信支付";
    NSString *strOfMoviePayTotalMoneyValueLabel = @"¥327.6";
    NSString *strOfMoviePayDiscountValueLabel = @"-¥40";
    NSString *strOfMoviePayRealMoneyValueLabel = @"¥287.6";
    NSString *strOfMoviePayServiceLabel = @"已包含服务费 3元";
    NSString *strOfMoviePayTimeValueLabel = @"2017-01-17 16:05";
    NSString *strOfMoviePayStatusValueLabel = @"已完成";
    
    CGSize strOfMoviePayLabelSize = [KKZTextUtility measureText:strOfMoviePayLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMoviePayMethodLabelSize = [KKZTextUtility measureText:strOfMoviePayMethodLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMoviePayTotalMoneyLabelSize = [KKZTextUtility measureText:strOfMoviePayTotalMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMoviePayDiscountLabelSize = [KKZTextUtility measureText:strOfMoviePayDiscountLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMoviePayRealMoneyLabelSize = [KKZTextUtility measureText:strOfMoviePayRealMoneyLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMoviePayTimeLabelSize = [KKZTextUtility measureText:strOfMoviePayTimeLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMoviePayStatusLabelSize = [KKZTextUtility measureText:strOfMoviePayStatusLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMoviePayMethodValueLabelSize = [KKZTextUtility measureText:strOfMoviePayMethodValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMoviePayTotalMoneyValueLabelSize = [KKZTextUtility measureText:strOfMoviePayTotalMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMoviePayDiscountValueLabelSize = [KKZTextUtility measureText:strOfMoviePayDiscountValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMoviePayRealMoneyValueLabelSize = [KKZTextUtility measureText:strOfMoviePayRealMoneyValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMoviePayServiceLabelSize = [KKZTextUtility measureText:strOfMoviePayServiceLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
    CGSize strOfMoviePayTimeValueLabelSize = [KKZTextUtility measureText:strOfMoviePayTimeValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    CGSize strOfMoviePayStatusValueLabelSize = [KKZTextUtility measureText:strOfMoviePayStatusValueLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    
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
        make.height.equalTo(@30);
    }];
    [self.moviePayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.payView.mas_left).offset(15);
        make.top.equalTo(self.payView.mas_top).offset((30-strOfMoviePayLabelSize.height)/2);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayLabelSize.width+1, strOfMoviePayLabelSize.height));
    }];
    [self.line11View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.payView.mas_top).offset(30);
        make.height.equalTo(@1);
    }];
    [self.moviePayMethodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.line11View.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayMethodLabelSize.width+1, strOfMoviePayMethodLabelSize.height));
    }];
    [self.moviePayMethodValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line11View.mas_bottom).offset(15);
        make.right.equalTo(self.bgView.mas_right).offset(-14);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayMethodValueLabelSize.width+1, strOfMoviePayMethodValueLabelSize.height));
    }];
    [self.moviePayTotalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.moviePayMethodLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayTotalMoneyLabelSize.width+1, strOfMoviePayTotalMoneyLabelSize.height));
    }];
    [self.moviePayTotalMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moviePayMethodValueLabel.mas_bottom).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-14);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayTotalMoneyValueLabelSize.width+1, strOfMoviePayTotalMoneyValueLabelSize.height));
    }];
    [self.moviePayDiscountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.moviePayTotalMoneyValueLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayDiscountLabelSize.width+1, strOfMoviePayDiscountLabelSize.height));
    }];
    [self.moviePayDiscountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moviePayTotalMoneyValueLabel.mas_bottom).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-14);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayDiscountValueLabelSize.width+1, strOfMoviePayDiscountValueLabelSize.height));
    }];
    [self.moviePayRealMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.moviePayDiscountValueLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayRealMoneyLabelSize.width+1, strOfMoviePayRealMoneyLabelSize.height));
    }];
    [self.moviePayRealMoneyValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moviePayDiscountValueLabel.mas_bottom).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-14);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayRealMoneyValueLabelSize.width+1, strOfMoviePayRealMoneyValueLabelSize.height));
    }];
    [self.moviePayServiceMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-10);
        make.top.equalTo(self.moviePayRealMoneyValueLabel.mas_bottom).offset(6);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayServiceLabelSize.width+5, strOfMoviePayServiceLabelSize.height));
    }];
    
    [self.line12View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.moviePayServiceMoneyLabel.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    [self.moviePayTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.line12View.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayTimeLabelSize.width+1, strOfMoviePayTimeLabelSize.height));
    }];
    [self.moviePayTimeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-14);
        make.top.equalTo(self.line12View.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayTimeValueLabelSize.width+1, strOfMoviePayTimeValueLabelSize.height));
    }];
    [self.moviePayStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(15);
        make.top.equalTo(self.moviePayTimeValueLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayStatusLabelSize.width+1, strOfMoviePayStatusLabelSize.height));
    }];
    [self.moviePayStatusValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-14);
        make.top.equalTo(self.moviePayTimeValueLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(strOfMoviePayStatusValueLabelSize.width+1, strOfMoviePayStatusValueLabelSize.height));
    }];
    [self.line13View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.moviePayStatusValueLabel.mas_bottom).offset(15);
        make.height.equalTo(@1);
    }];
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.line13View.mas_bottom).offset(10);
    }];
    [self.holder mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(80).priorityLow();
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
        _orderNoLabel.font = [UIFont systemFontOfSize:13];
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

-(UILabel *)movieProductCinemaNameLabel {
    if (!_movieProductCinemaNameLabel) {
        _movieProductCinemaNameLabel = [[UILabel alloc] init];
        _movieProductCinemaNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieProductCinemaNameLabel.font = [UIFont systemFontOfSize:14];
        _movieProductCinemaNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieProductCinemaNameLabel;
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
        _movieProductNameLabel.font = [UIFont systemFontOfSize:13];
        _movieProductNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    }
    return _movieProductNameLabel;
}

- (UILabel *)movieProductMoneyLabel {
    if (!_movieProductMoneyLabel) {
        _movieProductMoneyLabel = [[UILabel alloc] init];
        _movieProductMoneyLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieProductMoneyLabel.font = [UIFont systemFontOfSize:13];
    }
    return _movieProductMoneyLabel;
}
- (UILabel *)movieProductMoneyValueLabel {
    if (!_movieProductMoneyValueLabel) {
        _movieProductMoneyValueLabel = [[UILabel alloc] init];
        _movieProductMoneyValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieProductMoneyValueLabel.font = [UIFont systemFontOfSize:13];
    }
    return _movieProductMoneyValueLabel;
}

- (UILabel *)movieProductCountLabel {
    if (!_movieProductCountLabel) {
        _movieProductCountLabel = [[UILabel alloc] init];
        _movieProductCountLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieProductCountLabel.font = [UIFont systemFontOfSize:13];
    }
    return _movieProductCountLabel;
}
- (UILabel *)movieProductCountValueLabel {
    if (!_movieProductCountValueLabel) {
        _movieProductCountValueLabel = [[UILabel alloc] init];
        _movieProductCountValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieProductCountValueLabel.font = [UIFont systemFontOfSize:13];
    }
    return _movieProductCountValueLabel;
}


- (UILabel *)movieProductCodeLabel {
    if (!_movieProductCodeLabel) {
        _movieProductCodeLabel = [[UILabel alloc] init];
        _movieProductCodeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieProductCodeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _movieProductCodeLabel;
}
- (UILabel *)movieProductCodeValueLabel {
    if (!_movieProductCodeValueLabel) {
        _movieProductCodeValueLabel = [[UILabel alloc] init];
        _movieProductCodeValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieProductCodeValueLabel.font = [UIFont systemFontOfSize:13];
    }
    return _movieProductCodeValueLabel;
}
- (UILabel *)movieProductCode2Label {
    if (!_movieProductCode2Label) {
        _movieProductCode2Label = [[UILabel alloc] init];
        _movieProductCode2Label.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieProductCode2Label.font = [UIFont systemFontOfSize:13];
    }
    return _movieProductCode2Label;
}
- (UILabel *)movieProductCode2ValueLabel {
    if (!_movieProductCode2ValueLabel) {
        _movieProductCode2ValueLabel = [[UILabel alloc] init];
        _movieProductCode2ValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieProductCode2ValueLabel.font = [UIFont systemFontOfSize:13];
    }
    return _movieProductCode2ValueLabel;
}

- (UIView *)line2View {
    if (!_line2View) {
        _line2View = [[UIView alloc] init];
        _line2View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line2View;
}

- (UILabel *)movieProductTimeLabel {
    if (!_movieProductTimeLabel) {
        _movieProductTimeLabel = [[UILabel alloc] init];
        _movieProductTimeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieProductTimeLabel.font = [UIFont systemFontOfSize:13];
        _movieProductTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieProductTimeLabel;
}

- (UILabel *)movieProductTimeValueLabel {
    if (!_movieProductTimeValueLabel) {
        _movieProductTimeValueLabel = [[UILabel alloc] init];
        _movieProductTimeValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieProductTimeValueLabel.font = [UIFont systemFontOfSize:13];
        _movieProductTimeValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieProductTimeValueLabel;
}

- (UILabel *)movieProductStatusLabel {
    if (!_movieProductStatusLabel) {
        _movieProductStatusLabel = [[UILabel alloc] init];
        _movieProductStatusLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _movieProductStatusLabel.font = [UIFont systemFontOfSize:13];
        _movieProductStatusLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieProductStatusLabel;
}

- (UILabel *)movieProductStatusValueLabel {
    if (!_movieProductStatusValueLabel) {
        _movieProductStatusValueLabel = [[UILabel alloc] init];
        _movieProductStatusValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _movieProductStatusValueLabel.font = [UIFont systemFontOfSize:13];
        _movieProductStatusValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _movieProductStatusValueLabel;
}

- (UIView *)line3View {
    if (!_line3View) {
        _line3View = [[UIView alloc] init];
        _line3View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    }
    return _line3View;
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
        _moviePayLabel.font = [UIFont systemFontOfSize:13];
        _moviePayLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayLabel;
}

- (UILabel *)moviePayMethodLabel {
    if (!_moviePayMethodLabel) {
        _moviePayMethodLabel = [[UILabel alloc] init];
        _moviePayMethodLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayMethodLabel.font = [UIFont systemFontOfSize:13];
        _moviePayMethodLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayMethodLabel;
}

- (UILabel *)moviePayMethodValueLabel {
    if (!_moviePayMethodValueLabel) {
        _moviePayMethodValueLabel = [[UILabel alloc] init];
        _moviePayMethodValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayMethodValueLabel.font = [UIFont systemFontOfSize:13];
        _moviePayMethodValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayMethodValueLabel;
}

- (UILabel *)moviePayTotalMoneyLabel {
    if (!_moviePayTotalMoneyLabel) {
        _moviePayTotalMoneyLabel = [[UILabel alloc] init];
        _moviePayTotalMoneyLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayTotalMoneyLabel.font = [UIFont systemFontOfSize:13];
        _moviePayTotalMoneyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayTotalMoneyLabel;
}

- (UILabel *)moviePayTotalMoneyValueLabel {
    if (!_moviePayTotalMoneyValueLabel) {
        _moviePayTotalMoneyValueLabel = [[UILabel alloc] init];
        _moviePayTotalMoneyValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayTotalMoneyValueLabel.font = [UIFont systemFontOfSize:13];
        _moviePayTotalMoneyValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayTotalMoneyValueLabel;
}

- (UILabel *)moviePayDiscountLabel {
    if (!_moviePayDiscountLabel) {
        _moviePayDiscountLabel = [[UILabel alloc] init];
        _moviePayDiscountLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayDiscountLabel.font = [UIFont systemFontOfSize:13];
        _moviePayDiscountLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayDiscountLabel;
}

- (UILabel *)moviePayDiscountValueLabel {
    if (!_moviePayDiscountValueLabel) {
        _moviePayDiscountValueLabel = [[UILabel alloc] init];
        _moviePayDiscountValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayDiscountValueLabel.font = [UIFont systemFontOfSize:13];
        _moviePayDiscountValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayDiscountValueLabel;
}

- (UILabel *)moviePayRealMoneyLabel {
    if (!_moviePayRealMoneyLabel) {
        _moviePayRealMoneyLabel = [[UILabel alloc] init];
        _moviePayRealMoneyLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayRealMoneyLabel.font = [UIFont systemFontOfSize:13];
        _moviePayRealMoneyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayRealMoneyLabel;
}

- (UILabel *)moviePayRealMoneyValueLabel {
    if (!_moviePayRealMoneyValueLabel) {
        _moviePayRealMoneyValueLabel = [[UILabel alloc] init];
        _moviePayRealMoneyValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayRealMoneyValueLabel.font = [UIFont systemFontOfSize:13];
        _moviePayRealMoneyValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayRealMoneyValueLabel;
}

- (UILabel *)moviePayServiceMoneyLabel {
    if (!_moviePayServiceMoneyLabel) {
        _moviePayServiceMoneyLabel = [[UILabel alloc] init];
        _moviePayServiceMoneyLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayServiceMoneyLabel.font = [UIFont systemFontOfSize:10];
        _moviePayServiceMoneyLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayServiceMoneyLabel;
}

- (UILabel *)moviePayTimeLabel {
    if (!_moviePayTimeLabel) {
        _moviePayTimeLabel = [[UILabel alloc] init];
        _moviePayTimeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayTimeLabel.font = [UIFont systemFontOfSize:13];
        _moviePayTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayTimeLabel;
}

- (UILabel *)moviePayTimeValueLabel {
    if (!_moviePayTimeValueLabel) {
        _moviePayTimeValueLabel = [[UILabel alloc] init];
        _moviePayTimeValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayTimeValueLabel.font = [UIFont systemFontOfSize:13];
        _moviePayTimeValueLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayTimeValueLabel;
}

- (UILabel *)moviePayStatusLabel {
    if (!_moviePayStatusLabel) {
        _moviePayStatusLabel = [[UILabel alloc] init];
        _moviePayStatusLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        _moviePayStatusLabel.font = [UIFont systemFontOfSize:13];
        _moviePayStatusLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _moviePayStatusLabel;
}

- (UILabel *)moviePayStatusValueLabel {
    if (!_moviePayStatusValueLabel) {
        _moviePayStatusValueLabel = [[UILabel alloc] init];
        _moviePayStatusValueLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _moviePayStatusValueLabel.font = [UIFont systemFontOfSize:13];
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
