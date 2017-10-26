//
//  账户充值页面
//
//  Created by alfaromeo on 12-7-11.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//
//  TODO 页面重构：充值页面两种充值方式拆分成两个ViewController


#import "Constants.h"
#import "CouponTask.h"
#import "DataEngine.h"
#import "ImprestViewController.h"
#import "Order.h"
#import "OrderTask.h"
#import "PayTask.h"
#import "PayTypeCell.h"
#import "RoundCornersButton.h"
#import "TaskQueue.h"
#import "UIConstants.h"
#import "UserDefault.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UserManager.h"

#if TARGET_IPHONE_SIMULATOR
#else
#import "UPPayPlugin.h"
#endif

#define kMarginX 20
#define kTag 3711
#define kUIColorOrangeButton [UIColor colorWithRed:255 / 255.0 green:105 / 255.0 blue:0 / 255.0 alpha:1.0]

@interface ImprestViewController ()

@end

@implementation ImprestViewController

@synthesize moneyToImprest;

- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    return [super init];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"会员充值";

    // scrollView
    holder1 = [[UIScrollView alloc]
            initWithFrame:CGRectMake(0, 64, screentWith, screentContentHeight - 44 - 60)];
    holder1.backgroundColor = [UIColor whiteColor];
    holder1.showsVerticalScrollIndicator = NO;
    [self.view addSubview:holder1];


    
    //淡定会员会员卡充值

    CGFloat positionH = 15;

    RoundCornersButton *vipCardPswBg = [[RoundCornersButton alloc]
            initWithFrame:CGRectMake(15, positionH, screentWith - 15 * 2, kDimensInputHeight)];
    vipCardPswBg.cornerNum = kDimensCornerNum;
    vipCardPswBg.rimWidth = 0.5;
    vipCardPswBg.rimColor = [UIColor r:180 g:180 b:180];
    vipCardPswBg.fillColor = [UIColor whiteColor];
    [vipCardPswBg setUserInteractionEnabled:NO];
    [vipCardPswBg setEnabled:NO];
    [holder1 addSubview:vipCardPswBg];

    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(19, positionH, 90, kDimensInputHeight)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = @"会员卡密码：";
    lbl.textColor = [UIColor grayColor];
    lbl.font = [UIFont systemFontOfSize:14];
    lbl.textAlignment = NSTextAlignmentRight;
    [holder1 addSubview:lbl];

    vipCardPsw = [[UITextField alloc] initWithFrame:CGRectMake(110, positionH, 190, kDimensInputHeight)];
    vipCardPsw.font = [UIFont systemFontOfSize:14];
    vipCardPsw.delegate = self;
    vipCardPsw.placeholder = @"请输入密码";
    vipCardPsw.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    vipCardPsw.backgroundColor = [UIColor clearColor];
    vipCardPsw.textColor = [UIColor blackColor];
    vipCardPsw.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    vipCardPsw.clearButtonMode = UITextFieldViewModeWhileEditing;
    [holder1 addSubview:vipCardPsw];

    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];

    [topView setBarStyle:UIBarStyleDefault];

    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:self
                                                                              action:nil];

    UIButton *btnToolBar = [UIButton buttonWithType:UIButtonTypeCustom];

    btnToolBar.frame = CGRectMake(2, 5, 50, 30);

    [btnToolBar addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];

    [btnToolBar setTitle:@"完成" forState:UIControlStateNormal];

    [btnToolBar setTitleColor:appDelegate.kkzBlue forState:UIControlStateNormal];

    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithCustomView:btnToolBar];

    NSArray *buttonsArray = [NSArray arrayWithObjects:btnSpace, doneBtn, nil];

    [topView setItems:buttonsArray];

    [vipCardPsw setInputAccessoryView:topView];

    positionH += kDimensInputHeight;
    positionH += 25;

    RoundCornersButton *vipCardRechargeButton = [[RoundCornersButton alloc]
            initWithFrame:CGRectMake(15, positionH, screentWith - 15 * 2, kDimensButtonHeightLarge)];
    vipCardRechargeButton.backgroundColor = kUIColorOrangeButton;
    vipCardRechargeButton.cornerNum = kDimensCornerNum;
    vipCardRechargeButton.titleFont = [UIFont systemFontOfSize:kTextSizeButtonLarge];
    vipCardRechargeButton.titleName = @"立即充值";
    vipCardRechargeButton.titleColor = [UIColor whiteColor];
    [vipCardRechargeButton addTarget:self action:@selector(addVipCard) forControlEvents:UIControlEventTouchUpInside];
    [holder1 addSubview:vipCardRechargeButton];

    self.isWeiChatPay = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"wxImprestSucceed" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ImprestSucceed" object:nil];
}

#pragma mark utility
//刷新余额
- (void)queryBalance {
    self.kkzBackBtn.userInteractionEnabled = NO;
    [self performSelector:@selector(queryBalanceAfterDelay) withObject:nil afterDelay:1];
}

- (void)queryBalanceAfterDelay {
    [[UserManager shareInstance] updateBalance:^(NSNumber * _Nullable vipAccount) {
        
        self.kkzBackBtn.userInteractionEnabled = YES;
        
        RIButtonItem *done = [RIButtonItem itemWithLabel:@"确定"];
        done.action = ^{
            [self popViewControllerAnimated:NO];
        };
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"充值成功！"
                                               cancelButtonItem:done
                                               otherButtonItems:nil];
        [alert show];
        
    } failure:^(NSError * _Nullable err) {
        
    self.kkzBackBtn.userInteractionEnabled = YES;
        
    }];
    

}



- (void)addVipCard {
    _isImprestCard = YES;
    [vipCardPsw resignFirstResponder];

    NSString *finalPsw =
            [vipCardPsw.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([finalPsw length] <= 0) {
        [appDelegate showAlertViewForTitle:@"" message:@"请填写充值卡密码" cancelButton:@"好的"];
        return;
    }

    self.kkzBackBtn.userInteractionEnabled = NO;

    CouponTask *task = [[CouponTask alloc] initVipCardCheck:finalPsw
                                                   finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                       [self vipCardCheckFinished:userInfo status:succeeded];
                                                   }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        [appDelegate showIndicatorWithTitle:@"正在充值..." animated:YES fullScreen:NO overKeyboard:YES andAutoHide:NO];
    }
}

#pragma mark handle notifications
- (void)vipCardCheckFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {

    if (succeeded) {

        if ([[userInfo objectForKey:@"price"] floatValue] == 0) {
            [appDelegate showAlertViewForTitle:@"" message:@"充值失败" cancelButton:@"知道了"];
            self.kkzBackBtn.userInteractionEnabled = YES;
        }

        PayTask *task = [[PayTask alloc] initAddImprestOrder:[[userInfo objectForKey:@"price"] floatValue]
                                                     payType:PayMethodVip
                                                    finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                        [self addOrderFinished:userInfo status:succeeded];
                                                    }];
        task.ecardIds = [userInfo kkz_stringForKey:@"couponNo"];
        task.accountType = [NSString stringWithFormat:@"%d", 1];
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        }
    } else {
        self.kkzBackBtn.userInteractionEnabled = YES;
        [appDelegate hideIndicator];
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

- (void)payOrderFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];
    if (succeeded) {
        DLog(@"payurl succeeded");
        if (_isImprestCard) {
            [vipCardPsw resignFirstResponder];
            [self queryBalance];

        }

    } else {
        self.kkzBackBtn.userInteractionEnabled = YES;
        DLog(@"payurl failed");
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

- (void)balanceFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    self.kkzBackBtn.userInteractionEnabled = YES;
    if (succeeded) {

        RIButtonItem *done = [RIButtonItem itemWithLabel:@"确定"];
        done.action = ^{
            [self popViewControllerAnimated:NO];
        };
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"充值成功！"
                                               cancelButtonItem:done
                                               otherButtonItems:nil];
        [alert show];
    }
}

//可以充值，
- (void)addOrderFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {

    if (succeeded) {
        NSString *orderId = [userInfo objectForKey:@"orderId"];
        PayTask *task = nil;

        if (_isImprestCard) {
            task = [[PayTask alloc] initPayOrder:orderId
                                        useMoney:0//nil
                                          eCards:vipCardPsw.text
                                    useRedCoupon:0
                                         payType:selectedMethod
                                        finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                            [self payOrderFinished:userInfo status:succeeded];
                                        }];
        }
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        }

    } else {
        self.kkzBackBtn.userInteractionEnabled = YES;
        [appDelegate hideIndicator];
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}


#pragma mark horizon table view datasource


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

- (void)dismissKeyBoard {
    [vipCardPsw resignFirstResponder];
}

#pragma mark override from CommonViewController

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return TRUE;
}

- (BOOL)showTitleBar {
    return TRUE;
}
@end
