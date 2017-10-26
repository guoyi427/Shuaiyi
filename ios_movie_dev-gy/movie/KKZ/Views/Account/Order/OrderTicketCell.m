//
//  我的 - 订单管理 列表
//
//  Created by da zhang on 11-9-17.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "OrderTicketCell.h"

#import "RoundCornersButton.h"
#import "UIConstants.h"
#import <QuartzCore/QuartzCore.h>

#define kMarginX 15

#define kUIColorStatusNormal HEX(@"#ff6900") // 待支付订单的颜色
#define kUIColorStatusCancel HEX(@"#b7b7b7") // 已取消订单的颜色
#define kUIColorStatusSuccess HEX(@"#37c400") // 成功订单的颜色
#define kUIColorStatusRefund HEX(@"#b7b7b7") // 退款中订单的颜色

@interface OrderTicketCell ()
{
    UIImageView *_stateImageView;
    UILabel *_stateLabel;
    UILabel *_seatInfoLabel;
    UIImageView *_noticeImageView;
}
@end

@implementation OrderTicketCell

@synthesize movieName, movieTime, cinemaName, orderState;
@synthesize dealPrice, currentState;
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // Initialization code
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        timeTipLabel.text = @"";

        // cell背景
        cellBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 18, 20, 20)];
        [self addSubview:cellBackgroundView];
        cellBackgroundView.hidden = YES;
        cellBackgroundView.image = [UIImage imageNamed:@"appointment_order_logo"];
        
        // 电影名
        movieLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, 20, screentWith - 130, 25)];
        movieLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        movieLabel.textColor = [UIColor r:62 g:62 b:62];
        movieLabel.font = [UIFont systemFontOfSize:15];
        movieLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:movieLabel];

        // 影院名
        cinemaLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, 70, screentWith - 130, 20)];
        cinemaLabel.font = [UIFont systemFontOfSize:14];
        cinemaLabel.textColor = [UIColor r:183 g:183 b:183];
        cinemaLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:cinemaLabel];

        //  粉色铃铛
        _noticeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OrderList_notice"]];
        _noticeImageView.hidden = true;
        [self addSubview:_noticeImageView];
        [_noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kMarginX);
            make.top.mas_equalTo(44);
        }];
        
        // 场次时间
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, 44, screentWith - 130, 20)];
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.textColor = [UIColor r:183 g:183 b:183];
        timeLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeLabel];
        
        UIView *centerLine = [[UIView alloc] initWithFrame:CGRectMake(kMarginX, 63.5, screentWith - kMarginX - 55, 0.5)];
        centerLine.backgroundColor = appDelegate.kkzLine;
        [self addSubview:centerLine];

        // 倒计时 255 105 0
        timeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX - 3, 85, 288, 20)];
        timeTipLabel.font = [UIFont systemFontOfSize:13];
        timeTipLabel.hidden = YES;
        timeTipLabel.textAlignment = NSTextAlignmentLeft;
        timeTipLabel.textColor = [UIColor r:255 g:105 b:0];
        timeTipLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeTipLabel];

        timeCountdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX + 24, 85, 250, 20)];
        timeCountdownLabel.font = [UIFont systemFontOfSize:13];
        timeCountdownLabel.hidden = YES;
        timeCountdownLabel.textAlignment = NSTextAlignmentLeft;
        timeCountdownLabel.textColor = [UIColor r:50 g:50 b:50];
        timeCountdownLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:timeCountdownLabel];
        
        _stateImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_stateImageView];
        [_stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
        }];
        
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont systemFontOfSize:12];
        [_stateImageView addSubview:_stateLabel];
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(_stateImageView);
        }];
        
        _seatInfoLabel = [[UILabel alloc] init];
        _seatInfoLabel.textColor = appDelegate.kkzGray;
        _seatInfoLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_seatInfoLabel];
        [_seatInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kMarginX);
            make.bottom.mas_equalTo(-20);
        }];
        
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = appDelegate.kkzLine;
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.mas_equalTo(0);
            make.height.mas_equalTo(5);
        }];
    }
    return self;
}

- (void)beforeActivityMethod:(NSTimer *)time {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *expireDate2 = [self.orderTime dateByAddingTimeInterval:15 * 60];
    unsigned int unitFlags = NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *d = [calendar components:unitFlags
                                      fromDate:[NSDate date]
                                        toDate:expireDate2
                                       options:0]; //计算时间差

    if ([self.orderStateY isEqual:@1]) {
        if ([d second] < 0) {
            timeCountdownLabel.text = @"";
            timeTipLabel.text = @"支付过期";
            self.orderStateY = @(2);
            [timer invalidate];
            timer = nil;
        } else {
            //倒计时显示
            timeTipLabel.text = @"请在                内完成付款，超时将自动取消订单";
            timeCountdownLabel.text = [NSString stringWithFormat:@"%ld分%ld秒", (long) [d minute], (long) [d second]];
            [timeCountdownLabel setNeedsDisplay];
        }
    }
}

+ (float)heightWithCellState:(OrderTicketCellState)state {
    return 90;
}

- (void)updateLayout {
    cellBackgroundView.hidden = YES;

    timeCountdownLabel.text = @"";
    timeTipLabel.text = @"";

    timeCountdownLabel.hidden = YES;
    timeTipLabel.hidden = YES;
    
    _noticeImageView.hidden = true;
    timeLabel.frame = CGRectMake(kMarginX, 44, screentWith - 130, 20);
    timeLabel.textColor = [UIColor r:183 g:183 b:183];

    if (self.introducer && [self.introducer isEqualToString:@"kota"]) {

        if ([self.orderStateY isEqual:@1]) {
        } else if ([self.orderStateY isEqual:@4]) {
            cellBackgroundView.hidden = NO;
        } else if ([self.orderStateY isEqual:@5]) {
        } else if ([self.orderStateY isEqual:@2]) {
        } else if ([self.orderStateY isEqual:@3]) {
        }
    }

    movieLabel.text = self.movieName;
    CGRect movieF = movieLabel.frame;
    movieF.size = [self.movieName sizeWithFont:[UIFont systemFontOfSize:15]];
    if (movieF.size.width > screentWith - 140) {
        movieF.size.width = screentWith - 140;
    }
    movieF.size.width = movieF.size.width + 5;
    movieLabel.frame = movieF;

    // 关闭隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    movieF = cellBackgroundView.frame;
    movieF.origin.x = CGRectGetMaxX(movieLabel.frame);
    cellBackgroundView.frame = movieF;
    [CATransaction commit];

    cinemaLabel.text = self.cinemaName;
    timeLabel.text = [NSString stringWithFormat:@"%@", movieTime];

    if ([self.orderStateY isEqual:@1]) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethod:) userInfo:nil repeats:YES];
        timeCountdownLabel.hidden = NO;
        timeTipLabel.hidden = NO;

        
        _stateLabel.text = @"待支付";
        _stateImageView.image = [UIImage imageNamed:@"OrderList_gray"];
    } else if ([self.orderStateY isEqual:@2]) {
        _stateLabel.text = @"已取消";
        _stateImageView.image = [UIImage imageNamed:@"OrderList_gray"];
    } else if ([self.orderStateY isEqual:@3]) {
        _stateLabel.text = @"支付成功";
        _stateImageView.image = [UIImage imageNamed:@"OrderList_gray"];
    } else if ([self.orderStateY isEqual:@4]) {
        //  判断观影时间
        if ([self.order.plan.movieTime compare:[NSDate date]] == NSOrderedDescending) {
            //  时间未到
            _stateLabel.text = @"待观影";
            _stateImageView.image = [UIImage imageNamed:@"OrderList_red"];
            _noticeImageView.hidden = false;
            timeLabel.frame = CGRectMake(kMarginX + 20, 41, screentWith - 130, 20);
            timeLabel.textColor = appDelegate.kkzPink;
        } else {
            _stateLabel.text = @"已完成";
            _stateImageView.image = [UIImage imageNamed:@"OrderList_gray"];
        }
    } else if ([self.orderStateY isEqual:@5]) {
        _stateLabel.text = @"退款中";
        _stateImageView.image = [UIImage imageNamed:@"OrderList_gray"];
    } else if ([self.orderStateY isEqual:@9]) {
        _stateLabel.text = @"已退款";
        _stateImageView.image = [UIImage imageNamed:@"OrderList_gray"];
    } else if ([self.orderStateY isEqual:@10]) {
        _stateLabel.text = @"支付超时";
        _stateImageView.image = [UIImage imageNamed:@"OrderList_gray"];
    }
    
    _seatInfoLabel.text = self.order.plan.hallName;
}

//    OrderStateNormal = 1,//待支付，已经下完单。
//    OrderStateCanceled, //已取消
//    OrderStatePaid, //已付款和购票成功不一样，可能出票失败
//    OrderStateBuySucceeded, //购票成功
//    OrderStateBuyFailed,   //购票失败。
//    //后两个数据不会返回。在线选座——显示已使用。兑换券——显示已过期。
//    OrderStateFinished,   //已出票
//    OrderStateTimeout

@end
