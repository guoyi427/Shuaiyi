//
//  OpenWaitingViewController.h
//  CIASMovie
//
//  Created by avatar on 2017/3/16.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailOfMovie.h"

@interface OpenWaitingViewController : UIViewController
{
    NSTimer *timer;
    NSTimer *timer1;
    NSInteger countDownNum;
}
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) OrderDetailOfMovie *orderDetail;


@end
