//
//  OrderDetailViewController.h
//  KKZ
//
//  Created by  on 11-7-28.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "Coupon.h"
#import "NSObject+Delegate.h"
#import "Order.h"
#import "RoundCornersButton.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <UIKit/UIKit.h>

@class EGORefreshTableHeaderView;

@interface OrderDetailViewController
        : CommonViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate,
                                MFMessageComposeViewControllerDelegate, UIGestureRecognizerDelegate,
                                UIScrollViewDelegate, HandleUrlProtocol> {

    UIScrollView *holder;

    UIImageView *codeImageView;
    UITextView *orderMessageView;
    UIImageView *orderCodeBg;

    UILabel *movieName, *movieTime, *seatInfo, *orderNoLabel;
    UILabel *screenType;
    UILabel *blessingWord, *cinemaName;
    UILabel *ticketCount;
    UITextView *orderCodeLabel;
    RoundCornersButton *callCS;

    UILabel *movieNameLabel;
    UILabel *movieTypeLabel;
    UILabel *cinemaNameLabel;
    UILabel *startTimeLabel;
    UILabel *hallLabel;
    UILabel *seatInfoLabel;
    UILabel *ticketPriceLabel;
    UILabel *ticketCountLabel;
    UILabel *totalMoneyLabel;
    UITextView *orderMessage;
    UIButton *saveBtn;
    UIView *sosBgview;

    UIImageView *orderTipImage;
    UILabel *orderTipLabel;

    UIImageView *holderBgView, *headview;
    CGRect oldframe;

    EGORefreshTableHeaderView *refreshHeaderView;

    UIView *orderSuccessView;
    UILabel *mobileLabel;
    UILabel *orderNoSuccessLabel;
    UIView *noPayView, *sendMessageBtn;
    NSTimer *timer;
    UILabel *timeTipLabel, *timeCountdownLabel;

    UIView *disccountView;
    UILabel *disccountLabel;

    UIView *payView;
    UILabel *payLabel;

    UIView *phoneV;

    UIImageView *imgVYN;
    UIImage *imgYN;
}

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) Order *myOrder;
@property (nonatomic, strong) Coupon *myCoupon;
@property (nonatomic, assign) BOOL isVip;
@property (nonatomic, assign) BOOL isGotoOne;

@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, assign) BOOL isGroupbuy;
@property (nonatomic, copy) NSString *groupbuyContent;

- (id)initWithOrder:(NSString *)orderNo;

@end
