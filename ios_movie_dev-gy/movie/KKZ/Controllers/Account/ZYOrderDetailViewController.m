//
//  ZYOrderDetailViewController.m
//  KoMovie
//
//  Created by kokozu on 27/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ZYOrderDetailViewController.h"

@interface ZYOrderDetailViewController ()
{
    UIScrollView *_scrollView;
    UIView *_containsView;
    
    UIImageView *_ticketBackgroundView;
    UILabel *_cinemaNameLabel;
    UILabel *_movieNameLabel;
    UILabel *_timeLabel;
    UILabel *_seatInfoLabel;
    UIImageView *_stateImageView;
    UILabel *_stateLabel;
    
    UILabel *_serialCodeLabel;
    UILabel *_validCodeLabel;
    UIImageView *_qrCodeImageView;
    
    UILabel *_orderCodeLabel;
    UILabel *_priceLabel;
    
    UILabel *_addressTitleLabel;
    UILabel *_addressLabel;
    UILabel *_distanceLabel;
}
@end

@implementation ZYOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kkzTitleLabel.text = @"电影票详情";
    [self prepareScrollView];
    [self prepareTicketView];
    [self prepareCodeView];
    [self preparePriceView];
    [self prepareAddressView];
}

- (BOOL)showTitleBar {
    return true;
}

#pragma mark - Prepare

- (void)prepareScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kAppScreenWidth, screentHeight - 64)];
    _scrollView.backgroundColor = appDelegate.kkzLine;
    [self.view addSubview:_scrollView];
    
    _containsView = [[UIView alloc] init];
    _containsView.backgroundColor = appDelegate.kkzLine;
    [_scrollView addSubview:_containsView];
    [_containsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
    }];
}

- (void)prepareTicketView {
    _ticketBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"OrderDetial_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(200, 30, 30, 30) resizingMode:UIImageResizingModeTile]];
    _ticketBackgroundView.userInteractionEnabled = true;
    [_containsView addSubview:_ticketBackgroundView];
    [_ticketBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(5);
    }];
    
    _cinemaNameLabel = [[UILabel alloc] init];
    _cinemaNameLabel.font = [UIFont systemFontOfSize:15];
    _cinemaNameLabel.textColor = appDelegate.kkzGray;
    _cinemaNameLabel.text = _currentOrder.plan.cinema.cinemaName;
    [_ticketBackgroundView addSubview:_cinemaNameLabel];
    [_cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(15);
    }];
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = appDelegate.kkzLine;
    [_ticketBackgroundView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cinemaNameLabel);
        make.right.equalTo(_ticketBackgroundView);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(_cinemaNameLabel.mas_bottom).offset(15);
    }];
    
    UIButton *intoCinemaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [intoCinemaButton addTarget:self action:@selector(intoCinemaButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_ticketBackgroundView addSubview:intoCinemaButton];
    [intoCinemaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.equalTo(topLine);
    }];
    
    _stateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OrderList_gray"]];
    [_ticketBackgroundView addSubview:_stateImageView];
    [_stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.equalTo(topLine);
    }];
    
    _stateLabel = [[UILabel alloc] init];
    _stateLabel.textColor = [UIColor whiteColor];
    _stateLabel.text = [_currentOrder orderStateDesc];
    _stateLabel.font = [UIFont systemFontOfSize:12];
    [_stateImageView addSubview:_stateLabel];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_stateImageView);
    }];
    
    if (_currentOrder.orderStatus.integerValue == 4 &&
        [_currentOrder.plan.movieTime compare:[NSDate date]] == NSOrderedDescending) {
        //待观影
        _stateImageView.image = [UIImage imageNamed:@"OrderList_red"];
        _stateLabel.text = @"待观影";
    }
    
    _movieNameLabel = [[UILabel alloc] init];
    _movieNameLabel.textColor = [UIColor blackColor];
    _movieNameLabel.text = _currentOrder.plan.movie.movieName;
    _movieNameLabel.font = [UIFont systemFontOfSize:16];
    [_ticketBackgroundView addSubview:_movieNameLabel];
    [_movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cinemaNameLabel);
        make.top.equalTo(topLine.mas_bottom).offset(15);
    }];
    
    UIImageView *bellImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OrderList_notice"]];
    [_ticketBackgroundView addSubview:bellImageView];
    [bellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cinemaNameLabel);
        make.top.equalTo(_movieNameLabel.mas_bottom).offset(5);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.text = [[_currentOrder movieTimeDesc] stringByAppendingString:_currentOrder.plan.movie.movieType];
    _timeLabel.textColor = appDelegate.kkzPink;
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [_ticketBackgroundView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bellImageView.mas_right).offset(10);
        make.centerY.equalTo(bellImageView);
    }];
    
    _seatInfoLabel = [[UILabel alloc] init];
    _seatInfoLabel.text = [_currentOrder readableSeatInfos];
    _seatInfoLabel.textColor = appDelegate.kkzGray;
    _seatInfoLabel.font = [UIFont systemFontOfSize:15];
    _seatInfoLabel.numberOfLines = 2;
    [_ticketBackgroundView addSubview:_seatInfoLabel];
    [_seatInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cinemaNameLabel);
        make.top.equalTo(_timeLabel.mas_bottom).offset(10);
    }];
}

- (void)prepareCodeView {
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = appDelegate.kkzLine;
    grayView.layer.cornerRadius = 5.0;
    grayView.layer.masksToBounds = true;
    [_containsView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_scrollView);
        make.top.mas_equalTo(180);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(100);
    }];
    
    _serialCodeLabel = [[UILabel alloc] init];
    _serialCodeLabel.textColor = appDelegate.kkzGray;
    _serialCodeLabel.font = [UIFont systemFontOfSize:15];
    _serialCodeLabel.text = [NSString stringWithFormat:@"票号: %@", _currentOrder.finalTicketNo];
    [grayView addSubview:_serialCodeLabel];
    
    _validCodeLabel = [[UILabel alloc] init];
    _validCodeLabel.textColor = appDelegate.kkzGray;
    _validCodeLabel.font = _serialCodeLabel.font;
    _validCodeLabel.text = [NSString stringWithFormat:@"验证码: %@", _currentOrder.finalVerifyCode];
    [grayView addSubview:_validCodeLabel];
    
    [_serialCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(grayView);
        make.top.mas_equalTo(20);
    }];
    
    [_validCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(grayView);
        make.bottom.mas_equalTo(-20);
    }];
    /*
    if (_currentOrder.qrCodePath.length > 0) {
        _qrCodeImageView = [[UIImageView alloc] init];
        [_qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:_currentOrder.qrCodePath]];
        _qrCodeImageView.layer.borderColor = [UIColor grayColor].CGColor;
        _qrCodeImageView.layer.borderWidth = 0.5;
        _qrCodeImageView.layer.masksToBounds = true;
        _qrCodeImageView.layer.cornerRadius = 4.0;
        [_ticketBackgroundView addSubview:_qrCodeImageView];
        [_qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_scrollView);
            make.top.equalTo(grayView.mas_bottom).offset(20);
            make.size.mas_equalTo(CGSizeMake(150, 150));
        }];
        
        [_ticketBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_qrCodeImageView.mas_bottom).offset(20);
        }];
    } else {*/
        [_ticketBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(grayView.mas_bottom).offset(20);
        }];
//    }
}

- (void)preparePriceView {
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [_containsView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_ticketBackgroundView.mas_bottom).offset(5);
        make.height.mas_equalTo(80);
    }];
    
    _orderCodeLabel = [[UILabel alloc] init];
    _orderCodeLabel.textColor = [UIColor blackColor];
    _orderCodeLabel.font = [UIFont systemFontOfSize:14];
    _orderCodeLabel.text = [NSString stringWithFormat:@"章鱼订单号：%@", _currentOrder.orderId];
    [whiteView addSubview:_orderCodeLabel];
    [_orderCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(-20);
        make.top.mas_equalTo(20);
    }];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.text = [NSString stringWithFormat:@"总 价：￥%.2f(%ld张)",
                        _currentOrder.unitPrice.floatValue * _currentOrder.count.integerValue, _currentOrder.count.integerValue];
    _priceLabel.textColor = _orderCodeLabel.textColor;
    _priceLabel.font = _orderCodeLabel.font;
    [whiteView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderCodeLabel);
        make.right.mas_lessThanOrEqualTo(-20);
        make.bottom.mas_equalTo(-20);
    }];
}

- (void)prepareAddressView {
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    [_containsView addSubview:whiteView];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_priceLabel.mas_bottom).offset(30);
        make.height.mas_equalTo(80);
    }];
    
    _addressTitleLabel = [[UILabel alloc] init];
    _addressTitleLabel.font = [UIFont systemFontOfSize:14];
    _addressTitleLabel.textColor = [UIColor blackColor];
    _addressTitleLabel.text = _currentOrder.plan.cinema.cinemaName;
    [whiteView addSubview:_addressTitleLabel];
    [_addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.right.mas_lessThanOrEqualTo(-80);
    }];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.textColor = appDelegate.kkzGray;
    _addressLabel.font = [UIFont systemFontOfSize:10];
    _addressLabel.text = _currentOrder.plan.cinema.cinemaAddress;
    [whiteView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_addressTitleLabel);
        make.top.equalTo(_addressTitleLabel.mas_bottom).offset(10);
        make.right.mas_lessThanOrEqualTo(160);
    }];
    
    UIImageView *locationIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OrderDetail_location"]];
    [whiteView addSubview:locationIconView];
    
    _distanceLabel = [[UILabel alloc] init];
    _distanceLabel.textColor = appDelegate.kkzGray;
    _distanceLabel.font = [UIFont systemFontOfSize:10];
    //影院距离
    NSString *distanceStr;
    CGFloat meters = [_currentOrder.plan.cinema.distanceMetres floatValue];
    float kiloMeters = meters / 1000.0;
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        meters < 0 || meters > 100000000) {
        
    } else {
        if (meters < 1000) {
            distanceStr =
            [NSString stringWithFormat:@"%dm", [_currentOrder.plan.cinema.distanceMetres intValue]];
        } else {
            distanceStr = [NSString stringWithFormat:@"%.1fkm", kiloMeters];
        }
    }
    _distanceLabel.text = distanceStr;
    [whiteView addSubview:_distanceLabel];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(100);
        make.centerY.equalTo(_addressLabel);
    }];
    
    [locationIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_distanceLabel.mas_left).offset(5);
        make.bottom.equalTo(_distanceLabel);
    }];
    
    UIButton *mobileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mobileButton addTarget:self action:@selector(mobileButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [mobileButton setImage:[UIImage imageNamed:@"OrderDetail_mobiel"] forState:UIControlStateNormal];
    [whiteView addSubview:mobileButton];
    [mobileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(whiteView);
        make.width.mas_equalTo(80);
    }];
    
    UILabel *mobileLabel = [[UILabel alloc] init];
    mobileLabel.text = @"客服电话 4006-888-888";
    mobileLabel.textColor = appDelegate.kkzPink;
    mobileLabel.font = [UIFont systemFontOfSize:14];
    [_containsView addSubview:mobileLabel];
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_containsView);
        make.top.equalTo(whiteView.mas_bottom).offset(20);
    }];
    
    UILabel *workTimeLabel = [[UILabel alloc] init];
    workTimeLabel.text = @"工作时间： 早9:00-晚22:00";
    workTimeLabel.textColor = appDelegate.kkzGray;
    workTimeLabel.font = [UIFont systemFontOfSize:12];
    [_containsView addSubview:workTimeLabel];
    [workTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_containsView);
        make.top.equalTo(mobileLabel.mas_bottom).offset(5);
    }];
    
    [_containsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(workTimeLabel).offset(20);
    }];
}

#pragma mark - UIButton - Action

- (void)intoCinemaButtonAction {
    
}

- (void)mobileButtonAction {
    
}

@end
