//
//  OrderNeedsPayViewCell.m
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderNeedsPayViewCell.h"
#import <DateEngine_KKZ/DateEngine.h>
#import "KKZTextUtility.h"

@implementation OrderNeedsPayViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        NSString *orderNameStr = @"电影票订单";
        CGSize orderNameStrSize = [KKZTextUtility measureText:orderNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
        NSString *cinemaNameStr = @"未来影城通州北苑旗舰店";
        CGSize cinemaNameStrSize = [KKZTextUtility measureText:cinemaNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
        NSString *orderTimeStr = @"2017-01-15 15:15";
        CGSize orderTimeStrSize = [KKZTextUtility measureText:orderTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
        NSString *movieNameStr = @"神奇动物在哪里";
        CGSize movieNameStrSize = [KKZTextUtility measureText:movieNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
        statusLabel = [[UILabel alloc] init];
        statusLabel.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
        [self addSubview:statusLabel];
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset((88-cinemaNameStrSize.height*2-6-orderNameStrSize.height)/3+2);
            make.size.mas_equalTo(CGSizeMake(4, 13));
        }];
        orderNameLabel = [[UILabel alloc] init];
        orderNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        orderNameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:orderNameLabel];
        [orderNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusLabel.mas_right).offset(5);
            make.top.equalTo(self.mas_top).offset((88-cinemaNameStrSize.height*2-6-orderNameStrSize.height)/3);
            make.size.mas_equalTo(CGSizeMake(orderNameStrSize.width+5, orderNameStrSize.height));
        }];
        
        cinemaNameLabel = [[UILabel alloc] init];
        cinemaNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        cinemaNameLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:cinemaNameLabel];
        cinemaNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(orderNameLabel.mas_bottom).offset((88-cinemaNameStrSize.height*2-6-orderNameStrSize.height)/3);
            make.size.mas_equalTo(CGSizeMake(kCommonScreenWidth - orderTimeStrSize.width - 25, cinemaNameStrSize.height));
        }];
        
        orderTimeLabel = [[UILabel alloc] init];
        orderTimeLabel.textColor = [UIColor colorWithHex:@"#333333"];
        orderTimeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:orderTimeLabel];
        [orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(orderNameLabel.mas_bottom).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(orderTimeStrSize.width+5, orderTimeStrSize.height));
        }];
        
        movieNameLabel = [[UILabel alloc] init];
        movieNameLabel.font = [UIFont systemFontOfSize:13];
        movieNameLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        [self addSubview:movieNameLabel];
        [movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(cinemaNameLabel.mas_bottom).offset(6);
            make.size.mas_equalTo(CGSizeMake(movieNameStrSize.width+5, movieNameStrSize.height));
        }];
        line1View = [[UIView alloc] init];
        line1View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line1View];
        [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(88);
            make.right.equalTo(self.mas_right).offset(0);
            make.height.equalTo(@1);
        }];
        
        productNameLabel = [[UILabel alloc] init];
        productNameLabel.font = [UIFont systemFontOfSize:13];
        productNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        [self addSubview:productNameLabel];
        productNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(line1View.mas_bottom).offset((42-cinemaNameStrSize.height)/2);
            make.size.mas_equalTo(CGSizeMake(kCommonScreenWidth - 15, cinemaNameStrSize.height));
        }];
        
        productTimeLabel = [[UILabel alloc] init];
        productTimeLabel.font = [UIFont systemFontOfSize:13];
        productTimeLabel.textColor = [UIColor colorWithHex:@"#333333"];
        [self addSubview:productTimeLabel];
        [productTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1View.mas_bottom).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(orderTimeStrSize.width+5, orderTimeStrSize.height));
        }];
        line2View = [[UIView alloc] init];
        line2View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line2View];
        [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(line1View.mas_bottom).offset(42);
            make.height.equalTo(@1);
        }];
        
        totalMoneyLabel = [[UILabel alloc] init];
        totalMoneyLabel.textColor = [UIColor colorWithHex:@"#333333"];
        totalMoneyLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:totalMoneyLabel];
        [totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(line2View.mas_bottom).offset((60-6-cinemaNameStrSize.height*2)/2);
            make.size.mas_equalTo(CGSizeMake(cinemaNameStrSize.width, cinemaNameStrSize.height));
        }];
        
        timeValidLabel = [[UILabel alloc] init];
        timeValidLabel.textColor = [UIColor colorWithHex:@"#333333"];
        timeValidLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:timeValidLabel];
        [timeValidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(totalMoneyLabel.mas_bottom).offset(6);
            make.size.mas_equalTo(CGSizeMake(cinemaNameStrSize.width+5, cinemaNameStrSize.height));
        }];
        
        payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [payBtn setTitle:@"支付" forState:UIControlStateNormal];
        payBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [payBtn addTarget:self action:@selector(payBtnClickForPay:) forControlEvents:UIControlEventTouchUpInside];
        payBtn.layer.cornerRadius = 3.5;
        payBtn.clipsToBounds = YES;
        [payBtn setBackgroundColor:[UIColor colorWithHex:@"#f2f4f5"]];
        [payBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
        payBtn.userInteractionEnabled = NO;
       
        [self addSubview:payBtn];
        [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line2View.mas_bottom).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(50, 30));
        }];
        line3View = [[UIView alloc] init];
        line3View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line3View];
        [line3View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(line2View.mas_bottom).offset(59);
            make.height.equalTo(@1);
        }];
        
        UIView *footView = [[UIView alloc] init];
        footView.backgroundColor = [UIColor colorWithHex:@"#f2f4f5"];
        [self addSubview:footView];
        [footView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(line3View.mas_bottom);
            make.height.equalTo(@(5));
        }];
        
        UIView *line4View = [[UIView alloc] init];
        line4View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line4View];
        [line4View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(footView.mas_bottom).offset(0);
            make.height.equalTo(@1);
        }];
        // NSCalendar不提示这个respondsToSelector:方法,但是的确有这个方法
        if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
            self.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        } else {
            self.calendar = [NSCalendar currentCalendar];
        }
        
    }
    return self;
}

- (void)payBtnClickForPay:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleCellOnPayBtn:)]) {
        [self.delegate handleCellOnPayBtn:self.cellIndexPath];
    }
}

- (void)updateLayout{
//    DLog(@"orderListRecordData%@", self.orderListRecordData);
//    DLog(@"orderMovieProductList%@", self.orderMovieProductNeedsPayList);

    [self.orderProductNeedsPayList removeAllObjects];
    [self.orderMovieNeedsPayList removeAllObjects];
    NSMutableArray *tmpMovieArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tmpProductArr = [[NSMutableArray alloc] initWithCapacity:0];
    OrderListOfMovie *orderlistMe = [[OrderListOfMovie alloc] init];
    
    for (int i = 0; i < self.orderMovieProductNeedsPayList.count; i++) {
        orderlistMe = [self.orderMovieProductNeedsPayList objectAtIndex:i];
        if (orderlistMe.goodsType == 1) {
            //电影票的
            [tmpMovieArr addObject:[self.orderMovieProductNeedsPayList objectAtIndex:i]];
            //            DLog(@"tmpMovieArr:%@", tmpMovieArr);
        } else if(orderlistMe.goodsType == 3) {
            //卖品的
            [tmpProductArr addObject:[self.orderMovieProductNeedsPayList objectAtIndex:i]];
            //            DLog(@"tmpProductArr:%@", tmpProductArr);
        }else if(orderlistMe.goodsType == 4) {
            //开卡的
            [tmpMovieArr addObject:[self.orderMovieProductNeedsPayList objectAtIndex:i]];
        }else if(orderlistMe.goodsType == 5) {
            //充值的
            [tmpMovieArr addObject:[self.orderMovieProductNeedsPayList objectAtIndex:i]];
        }
    }
//    DLog(@"tmpMovieArr:%@", tmpMovieArr);
//    DLog(@"tmpProductArr:%@", tmpProductArr);
    self.orderMovieNeedsPayList = tmpMovieArr;
    self.orderProductNeedsPayList = tmpProductArr;
    
//    DLog(@"orderMovieList:%@", self.orderMovieNeedsPayList);
//    DLog(@"orderProductList:%@", self.orderProductNeedsPayList);
    if (self.orderMovieNeedsPayList.count > 0) {
        self.orderListMovieNeedsPayData = (OrderListOfMovie *)[self.orderMovieNeedsPayList objectAtIndex:0];
    }
    if (self.orderProductNeedsPayList.count > 0) {
        self.orderListProductNeedsPayData = (OrderListOfMovie *)[self.orderProductNeedsPayList objectAtIndex:0];
    } else {
        [productNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1View.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [productTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1View.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [line2View mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1View.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [line3View mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1View.mas_bottom).offset(59);
            make.height.equalTo(@1);
        }];
    }
    
    if (self.orderListRecordNeedsPayData.orderType == 3) {
        self.orderNameLabelStr = @"电影票订单";
    } else if (self.orderListRecordNeedsPayData.orderType == 5) {
        self.orderNameLabelStr = @"开卡订单";
    }else if (self.orderListRecordNeedsPayData.orderType == 4) {
        self.orderNameLabelStr = @"充值订单";
    }
    //    else if () {
    //    self.orderNameLabelStr = @"卖品订单";
    //    }
    self.cinemaNameLabelStr = self.orderListMovieNeedsPayData.cinemaName.length>0?self.orderListMovieNeedsPayData.cinemaName:@"";
    self.movieNameLabelStr = self.orderListMovieNeedsPayData.goodsName.length>0?self.orderListMovieNeedsPayData.goodsName:@"";
    self.orderTimeLabelStr = [[DateEngine sharedDateEngine] stringFromDateY:[NSDate dateWithTimeIntervalSince1970:[self.orderListMovieNeedsPayData.createTime longLongValue]/1000]];
    float moneyToPay = self.orderListRecordNeedsPayData.receiveMoney.intValue/100.00;
    self.totalMoneyLabelStr = [NSString stringWithFormat:@"合计：¥%.2f", moneyToPay];
    self.productTimeLabelStr = self.productTimeLabelStr.length>0?self.productTimeLabelStr:@"已取消";
    NSString *productNameTmpStr = @"";
    for (int i = 0; i < self.orderProductNeedsPayList.count; i++) {
        if (self.orderProductNeedsPayList.count == 1) {
            OrderListOfMovie *orderProductNeedsPayData = (OrderListOfMovie *)[self.orderProductNeedsPayList objectAtIndex:0];
            productNameTmpStr = orderProductNeedsPayData.goodsName;
        } else {
            OrderListOfMovie *orderProductNeedsPayData = (OrderListOfMovie *)[self.orderProductNeedsPayList objectAtIndex:i];
            NSString *str = orderProductNeedsPayData.goodsName;
            productNameTmpStr = [productNameTmpStr stringByAppendingString:[NSString stringWithFormat:@",%@", str]];
        }
    }
    if (self.orderProductNeedsPayList.count == 1) {
        self.productNameLabelStr = productNameTmpStr;
    } else if (self.orderProductNeedsPayList.count > 1) {
        NSString *productNameTmpStr2 = [productNameTmpStr substringWithRange:NSMakeRange(1, productNameTmpStr.length - 1)];
        self.productNameLabelStr = productNameTmpStr2;
    }
    
    
    
    self.productTimeLabelStr = [[DateEngine sharedDateEngine] stringFromDateY:[NSDate dateWithTimeIntervalSince1970:[self.orderListProductNeedsPayData.createTime longLongValue]/1000]];
    
    if (!_timerNeedsPay) {
        _timerNeedsPay = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethodOfNeedsPay:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timerNeedsPay forMode:NSRunLoopCommonModes];
    }
    
//    NSDateFormatter *date = [[NSDateFormatter alloc]init];
//    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *endD = [NSDate dateWithTimeIntervalSince1970:[self.orderListRecordNeedsPayData.serverTime longLongValue]/1000];
//    NSDate *serverD = [NSDate dateWithTimeIntervalSince1970:[self.orderListMovieNeedsPayData.createTime longLongValue]/1000];
//    NSTimeInterval start = [serverD timeIntervalSince1970]*1;
//    NSTimeInterval end = [endD timeIntervalSince1970]*1;
//    NSTimeInterval value = self.orderListRecordNeedsPayData.validTime.longLongValue/1000 - end - start;
//    timeCount = value;
    
    
    
    orderNameLabel.text = self.orderNameLabelStr;
    cinemaNameLabel.text = self.cinemaNameLabelStr;
    movieNameLabel.text = self.movieNameLabelStr;
    orderTimeLabel.text = self.orderTimeLabelStr;
    totalMoneyLabel.text = self.totalMoneyLabelStr;
    productNameLabel.text = self.productNameLabelStr;
//    productTimeLabel.text = self.productTimeLabelStr;
    
    
    
//    timeValidLabel.text = [NSString stringWithFormat:@"距离完成支付还剩 %@", self.timeValidLabelStr.length>0?self.timeValidLabelStr:@"09:24"];
    
    
    NSString *orderNameStr = self.orderNameLabelStr.length>0?self.orderNameLabelStr:@"电影票订单";
    CGSize orderNameStrSize = [KKZTextUtility measureText:orderNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
    NSString *cinemaNameStr = self.cinemaNameLabelStr.length>0?self.cinemaNameLabelStr:@"未来影城通州北苑旗舰店";
    CGSize cinemaNameStrSize = [KKZTextUtility measureText:cinemaNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    NSString *orderTimeStr = self.orderTimeLabelStr.length>0?self.orderTimeLabelStr:@"2017-01-15 15:15";
    CGSize orderTimeStrSize = [KKZTextUtility measureText:orderTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    NSString *movieNameStr = self.movieNameLabelStr.length>0?self.movieNameLabelStr:@"神奇动物在哪里";
    CGSize movieNameStrSize = [KKZTextUtility measureText:movieNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    NSString *productNameStr = self.productNameLabelStr.length>0?self.productNameLabelStr:@"春节豪华单人套餐";
    CGSize productNameStrSize = [KKZTextUtility measureText:productNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    NSString *productTimeStr = self.productTimeLabelStr.length>0?self.productTimeLabelStr:@"2017-01-15 15:15";
//    CGSize productTimeStrSize = [KKZTextUtility measureText:productTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    NSString *totalMoneyStr = [NSString stringWithFormat:@"合计：¥%@", self.totalMoneyLabelStr.length>0?self.totalMoneyLabelStr:@"145.90"];
    CGSize totalMoneyStrSize = [KKZTextUtility measureText:totalMoneyStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    NSString *timeValidStr = [NSString stringWithFormat:@"距离完成支付还剩 %@", self.timeValidLabelStr.length>0?self.timeValidLabelStr:@"09:24"];
    CGSize timeValidStrSize = [KKZTextUtility measureText:timeValidStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    
    
    [orderNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(orderNameStrSize.width+5, orderNameStrSize.height));
    }];
    [cinemaNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kCommonScreenWidth - orderTimeStrSize.width - 25, cinemaNameStrSize.height));
    }];
    [orderTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(orderTimeStrSize.width+5, orderTimeStrSize.height));
    }];
    [movieNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(movieNameStrSize.width+5, movieNameStrSize.height));
    }];
    if (self.orderProductNeedsPayList.count > 0) {
        [productNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(productNameStrSize.width+5, productNameStrSize.height));
        }];
//        [productTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(productTimeStrSize.width+5, productTimeStrSize.height));
//        }];
    }
   
    [totalMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(totalMoneyStrSize.width+5, totalMoneyStrSize.height));
    }];
    [timeValidLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(timeValidStrSize.width+5, timeValidStrSize.height));
    }];
}


- (void)beforeActivityMethodOfNeedsPay:(NSTimer *)time
{
    NSDate *endD = [NSDate dateWithTimeIntervalSince1970:[self.orderListRecordNeedsPayData.createTime longLongValue]/1000];
    NSDate *expireDate2 = [endD dateByAddingTimeInterval:10 * 60];
    unsigned int unitFlags = NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *d = [self.calendar components:unitFlags
                                      fromDate:[NSDate date]
                                        toDate:expireDate2
                                       options:0]; //计算时间差
    
        if ([d second] < 0) {
            [payBtn setBackgroundColor:[UIColor colorWithHex:@"#f2f4f5"]];
            [payBtn setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
            payBtn.userInteractionEnabled = NO;
            timeValidLabel.text = @"支付过期";
            [_timerNeedsPay invalidate];
            _timerNeedsPay = nil;
            
        } else {
            //倒计时显示
            [payBtn setBackgroundColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor]];
            [payBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
            payBtn.userInteractionEnabled = YES;
            timeValidLabel.text  = [NSString stringWithFormat:@"距离完成支付还剩 %02ld:%02ld", (long) [d minute], (long) [d second]];
            [timeValidLabel setNeedsDisplay];
        }
}

- (void)dealloc {
    if (_timerNeedsPay.isValid) {
        _timerNeedsPay = nil;
    }
}


@end
