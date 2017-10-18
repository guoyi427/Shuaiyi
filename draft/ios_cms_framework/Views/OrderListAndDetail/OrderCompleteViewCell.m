//
//  OrderCompleteViewCell.m
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderCompleteViewCell.h"
#import <DateEngine_KKZ/DateEngine.h>
#import "KKZTextUtility.h"

@implementation OrderCompleteViewCell

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
        cinemaNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:cinemaNameLabel];
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
            make.right.equalTo(self.mas_right).offset(-10);
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
        totalMoneyLabel.font = [UIFont systemFontOfSize:13];
        totalMoneyLabel.textColor = [UIColor colorWithHex:@"#333333"];
        [self addSubview:totalMoneyLabel];
        [totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(line2View.mas_bottom).offset((42-cinemaNameStrSize.height)/2);
            make.size.mas_equalTo(CGSizeMake(cinemaNameStrSize.width, cinemaNameStrSize.height));
        }];
        
        UIImage *imageOfOrderComplete = [UIImage imageNamed:@"home_more"];
        
        orderStatusLabel = [[UILabel alloc] init];
        orderStatusLabel.font = [UIFont systemFontOfSize:13];
        orderStatusLabel.textColor = [UIColor colorWithHex:@"#333333"];
        orderStatusLabel.text = @"已完成";
        orderStatusLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:orderStatusLabel];
        [orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line2View.mas_bottom).offset((42-cinemaNameStrSize.height)/2);
            make.right.equalTo(self.mas_right).offset(-(5+15+imageOfOrderComplete.size.width));
            make.size.mas_equalTo(CGSizeMake(orderTimeStrSize.width+5, orderTimeStrSize.height));
        }];
        
        UIImageView *imageViewOfOrderComplete = [[UIImageView alloc] init];
        imageViewOfOrderComplete.contentMode = UIViewContentModeScaleAspectFit;
        imageViewOfOrderComplete.image = imageOfOrderComplete;
        [self addSubview:imageViewOfOrderComplete];
        [imageViewOfOrderComplete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(line2View.mas_bottom).offset((42-cinemaNameStrSize.height)/2+(cinemaNameStrSize.height-imageOfOrderComplete.size.height)/2);
            make.size.mas_equalTo(CGSizeMake(imageOfOrderComplete.size.width, imageOfOrderComplete.size.height));
        }];
        
        line3View = [[UIView alloc] init];
        line3View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line3View];
        [line3View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(line2View.mas_bottom).offset(41);
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
        
        line4View = [[UIView alloc] init];
        line4View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line4View];
        [line4View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(footView.mas_bottom).offset(0);
            make.height.equalTo(@1);
        }];
    }
    return self;
}



- (void)updateLayout{
//    DLog(@"orderListRecordData%@", self.orderListRecordData);
//    DLog(@"orderMovieProductList%@", self.orderMovieProductList);
    
    [self.orderProductList removeAllObjects];
    [self.orderMovieList removeAllObjects];
    NSMutableArray *tmpMovieArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *tmpProductArr = [[NSMutableArray alloc] initWithCapacity:0];
    OrderListOfMovie *orderlistMe = [[OrderListOfMovie alloc] init];
    
    for (int i = 0; i < self.orderMovieProductList.count; i++) {
        orderlistMe = [self.orderMovieProductList objectAtIndex:i];
        if (orderlistMe.goodsType == 1) {
            //电影票的
            [tmpMovieArr addObject:[self.orderMovieProductList objectAtIndex:i]];
//            DLog(@"tmpMovieArr:%@", tmpMovieArr);
        } else if(orderlistMe.goodsType == 3) {
            //卖品的
            [tmpProductArr addObject:[self.orderMovieProductList objectAtIndex:i]];
//            DLog(@"tmpProductArr:%@", tmpProductArr);
        }else if(orderlistMe.goodsType == 4) {
            //开卡的
            [tmpMovieArr addObject:[self.orderMovieProductList objectAtIndex:i]];

        }else if(orderlistMe.goodsType == 5) {
            //充值的
            [tmpMovieArr addObject:[self.orderMovieProductList objectAtIndex:i]];

        }
    }
//    DLog(@"tmpMovieArr:%@", tmpMovieArr);
//    DLog(@"tmpProductArr:%@", tmpProductArr);
    self.orderMovieList = tmpMovieArr;
    self.orderProductList = tmpProductArr;
    
//    DLog(@"orderMovieList:%@", self.orderMovieList);
//    DLog(@"orderProductList:%@", self.orderProductList);

    self.orderListMovieCompleteData = (OrderListOfMovie *)[self.orderMovieList objectAtIndex:0];
    DLog(@"%@",self.orderListMovieCompleteData.receiveMoney);
    DLog(@"%@",self.orderListRecordData.receiveMoney);

    if (self.orderListRecordData.orderType == 3) {
        DLog(@"%@",self.orderListRecordData);
        self.orderNameLabelStr = @"电影票订单";
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethodOfOrderList:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    } else if (self.orderListRecordData.orderType == 5) {
        self.orderNameLabelStr = @"开卡订单";
    }else if (self.orderListRecordData.orderType == 4) {
        self.orderNameLabelStr = @"充值订单";
    }
//    else if () {
//    self.orderNameLabelStr = @"卖品订单";
//    }
    self.cinemaNameLabelStr = self.orderListMovieCompleteData.cinemaName.length>0?self.orderListMovieCompleteData.cinemaName:@"";
    self.movieNameLabelStr = self.orderListMovieCompleteData.goodsName.length>0?self.orderListMovieCompleteData.goodsName:@"";
    self.orderTimeLabelStr = [[DateEngine sharedDateEngine] stringFromDateY:[NSDate dateWithTimeIntervalSince1970:[self.orderListMovieCompleteData.createTime longLongValue]/1000]];
    
    
//    NSDateFormatter *date = [[NSDateFormatter alloc]init];
//    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSDate *endD = self.orderListMovieData.planBeginTime;
//    NSDate *serverD = self.orderListRecordData.serverTime;
//    NSTimeInterval start = [serverD timeIntervalSince1970]*1;
//    NSTimeInterval end = [endD timeIntervalSince1970]*1;
//    NSTimeInterval value = end - start;
//    timeCount = value;

    
    float moneyToPay = self.orderListRecordData.receiveMoney.intValue/100.00;
    self.totalMoneyLabelStr = [NSString stringWithFormat:@"合计：¥%.2f", moneyToPay];
    
    
    orderNameLabel.text = self.orderNameLabelStr;
    cinemaNameLabel.text = self.cinemaNameLabelStr;
    movieNameLabel.text = self.movieNameLabelStr;
    orderTimeLabel.text = self.orderTimeLabelStr;
    totalMoneyLabel.text = self.totalMoneyLabelStr;
    
    
    NSString *orderNameStr = self.orderNameLabelStr;
    CGSize orderNameStrSize = [KKZTextUtility measureText:orderNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
    NSString *cinemaNameStr = self.cinemaNameLabelStr;
    CGSize cinemaNameStrSize = [KKZTextUtility measureText:cinemaNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    NSString *orderTimeStr = self.orderTimeLabelStr;
    CGSize orderTimeStrSize = [KKZTextUtility measureText:orderTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    NSString *movieNameStr = self.movieNameLabelStr;
    CGSize movieNameStrSize = [KKZTextUtility measureText:movieNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    
    NSString *orderStatusStr = self.orderStatusLabelStr.length>0?self.orderStatusLabelStr:@"距离影片开场还剩 15天 12:33:58";
    CGSize orderStatusStrSize = [KKZTextUtility measureText:orderStatusStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    NSString *totalMoneyStr = self.totalMoneyLabelStr;
    CGSize totalMoneyStrSize = [KKZTextUtility measureText:totalMoneyStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    
    if (self.orderProductList.count > 0) {
        //有卖品,添加显示，并更新约束
        NSString *productNameStr = @"";
        for (int i = 0; i < self.orderProductList.count; i++) {
            if (self.orderProductList.count == 1) {
                OrderListOfMovie *orderListProductCompleteData = (OrderListOfMovie *)[self.orderProductList objectAtIndex:0];
                productNameStr = orderListProductCompleteData.goodsName;
            } else {
                OrderListOfMovie *orderListProductCompleteData = (OrderListOfMovie *)[self.orderProductList objectAtIndex:i];
                NSString *str = orderListProductCompleteData.goodsName;
                productNameStr = [productNameStr stringByAppendingString:[NSString stringWithFormat:@",%@", str]];
            }
        }
        if (self.orderProductList.count == 1) {
            self.productNameLabelStr = productNameStr;
        } else if (self.orderProductList.count > 1) {
            NSString *productNameStr2 = [productNameStr substringWithRange:NSMakeRange(1, productNameStr.length - 1)];
            self.productNameLabelStr = productNameStr2;
        }
        
        
        productNameLabel.text = self.productNameLabelStr;
        [line2View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(line1View.mas_bottom).offset(42);
            make.height.equalTo(@1);
        }];
    } else {
        productNameLabel.text = @"";
        [line2View mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top).offset(88);
            make.right.equalTo(self.mas_right).offset(0);
            make.height.equalTo(@1);
        }];
    }
    
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
    
    [orderStatusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(orderStatusStrSize.width+5, orderStatusStrSize.height));
    }];
    [totalMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(totalMoneyStrSize.width+5, totalMoneyStrSize.height));
    }];
    
}

- (void)beforeActivityMethodOfOrderList:(NSTimer *)time
{
    // 判断方法二:
    NSCalendar *calendar = nil;
    // NSCalendar不提示这个respondsToSelector:方法,但是的确有这个方法
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    } else {
        calendar = [NSCalendar currentCalendar];
    }
    NSDate *endD = [NSDate dateWithTimeIntervalSince1970:[self.orderListMovieCompleteData.planBeginTime longLongValue]/1000];
    unsigned int unitFlags = NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitHour | NSCalendarUnitDay;
    NSDateComponents *d = [calendar components:unitFlags
                                      fromDate:[NSDate date]
                                        toDate:endD
                                       options:0]; //计算时间差
//    DLog(@"%@ - %@", [NSDate date], endD);
//    DLog(@"时间差 秒：%ld", (long)[d second]);
//    DLog(@"时间差 分：%ld", (long)[d minute]);
//    DLog(@"时间差 时：%ld", (long)[d hour]);

    if ([d second] < 0) {
        orderStatusLabel.text = @"已完成";
        [orderStatusLabel setNeedsDisplay];
        [self.timer invalidate];
        self.timer = nil;
        
    }else {
        //倒计时显示
        NSString *countDownStr = @"";

        if ([d day]>0) {
            countDownStr = [NSString stringWithFormat:@"%ld天 %02ld:%02ld:%02ld",(long)[d day],(long)[d hour],(long)[d minute],(long)[d second]];
        }else if ([d day]==0 && [d hour] != 0) {
            countDownStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)[d hour],(long)[d minute],(long)[d second]];
        }else if ([d day]== 0 && [d hour]== 0 && [d minute]!=0) {
            countDownStr = [NSString stringWithFormat:@"%02d:%02ld:%02ld", 00,(long)[d minute],(long)[d second]];
        }else{
            countDownStr = [NSString stringWithFormat:@"%02d:%02d:%02ld",00,00,(long)[d second]];
        }
        orderStatusLabel.text = [NSString stringWithFormat:@"距离影片开场还剩 %@", countDownStr];
        [orderStatusLabel setNeedsDisplay];
    }
}

- (void)dealloc {
    if (self.timer.isValid) {
        self.timer = nil;
    }
}

@end
