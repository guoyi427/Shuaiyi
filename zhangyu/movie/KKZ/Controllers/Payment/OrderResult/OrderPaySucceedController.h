//
//  购票成功页面
//
//  Created by KKZ on 15/9/9.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <PassKit/PassKit.h>

#import "CommonViewController.h"
#import "Cryptor.h"
#import "Order.h"
#import "PassbookTask.h"

@class Banner;
@class EGORefreshTableHeaderView;

@interface OrderPaySucceedController : CommonViewController <UIScrollViewDelegate, MFMailComposeViewControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, PKAddPassesViewControllerDelegate> {
    UIScrollView *holder;

    UIImageView *codeImageView;
    UITextView *orderMessageView;
    UIImageView *orderCodeBg;

    UILabel *movieName, *movieTime, *seatInfo, *orderNoLabel;
    UILabel *screenType;
    UILabel *ticketCount;
    UITextView *orderCodeLabel;
    UIButton *callCS;

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
    UIView *sosBgview, *sendMessageBtn;

    UIImageView *orderTipImage;

    UILabel *orderTipLabel;

    UIImageView *holderBgView;
    CGRect oldframe;

    EGORefreshTableHeaderView *refreshHeaderView;

    UILabel *mobileLabel;
    UILabel *orderStateLabel, *orderSuccessPayLabel;
    UIView *qrView;
    UIView *messageView;
    UIView *orderView;
    UIView *downView;
    UIImageView *img;

    UIImageView *adView;

    UILabel *ticketNoValue, *verificationCodeValue;

    Banner *managedObject;
}

@property (nonatomic, strong) Order *myOrder;
@property (nonatomic, assign) BOOL isVip;
@property (nonatomic, assign) BOOL isGotoOne;

@property (nonatomic, strong) NSString *cinemaId;
@property (nonatomic, assign) BOOL isGroupbuy;
@property (nonatomic, strong) NSString *groupbuyContent;
@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, strong) NSArray *banners;

@property (nonatomic, strong) UILabel *warningText; //取票地点信息
@property (nonatomic, strong) UILabel *ticketNo; //票号
@property (nonatomic, strong) UILabel *verificationCode; //验证码

- (id)initWithOrder:(NSString *)orderNo;

@end
