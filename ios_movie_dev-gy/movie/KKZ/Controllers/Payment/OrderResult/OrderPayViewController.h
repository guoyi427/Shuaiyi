//
//  支付完成等待购票结果的动画页面
//
//  Created by on 11-7-28.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

#import "CommonViewController.h"
#import "Order.h"

@class EGORefreshTableHeaderView;

@interface OrderPayViewController : CommonViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate> {

    bool isAnimating;

    UIScrollView *holder;
    UIImageView *imgStatusIconV;
    UILabel *orderStateLabel;
    NSTimer *orderDetailTimer;
    NSTimer *animationTimer;
}

@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) Order *order;

- (id)initWithOrder:(NSString *)orderNo;

@end
