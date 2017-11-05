//
//  PaySecondViewController.m
//  KoMovie
//
//  Created by kokozu on 31/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "PaySecondViewController.h"

//  Data
#import "Order.h"

//  View
#import "PayView.h"

@interface PaySecondViewController ()
{
    NSTimer *timer;
    UIScrollView *holder;
    UILabel *timerLabel;
}
@end

@implementation PaySecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethod:) userInfo:nil repeats:YES];
    
    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
    [self.view addSubview:holder];
    holder.backgroundColor = [UIColor r:245 g:245 b:245];
//    holder.showsVerticalScrollIndicator = NO;
//    holder.scrollEnabled = false;
    
    //支付剩余时间的现实
    UIView *timerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 44)];
    
    UILabel *timerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screentWith * 0.5 + 10, 44)];
    timerTitle.text = @"距离完成支付还有";
    timerTitle.textColor = [UIColor r:242 g:101 b:34];
    timerTitle.font = [UIFont systemFontOfSize:13];
    timerTitle.textAlignment = NSTextAlignmentRight;
    [timerTitle setBackgroundColor:[UIColor clearColor]];
    [timerView addSubview:timerTitle];
    
    
    timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(screentWith * 0.5 + 20, 0.0, screentWith * 0.5 - 20, 44)];
    timerLabel.font = [UIFont systemFontOfSize:14];
    timerLabel.textColor = [UIColor r:242 g:101 b:34];
    timerLabel.backgroundColor = [UIColor clearColor];
    timerLabel.textAlignment = NSTextAlignmentLeft;
    timerLabel.text = @"";
    [timerView addSubview:timerLabel];
    
    [holder addSubview:timerView];
    
    //  支付页面
    self.payView.frame = CGRectMake(0, 50, kAppScreenWidth, screentHeight-100);
    [holder addSubview:self.payView];
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [payButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    payButton.backgroundColor = [UIColor r:208 g:208 b:208];//Pay_paybutton@2x
    [payButton setBackgroundImage:[UIImage imageNamed:@"Pay_paybutton"] forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:16];
    payButton.titleLabel.textColor = [UIColor whiteColor];
    [payButton addTarget:self action:@selector(payButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
}

#pragma mark - Timer - Action

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
        self.payView.hasOrderExpired = YES;
        self.payView.userInteractionEnabled = NO;
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

#pragma mark - UIButton - Action

- (void)payButtonAction {
    [self.payView payOrder];
}

@end
