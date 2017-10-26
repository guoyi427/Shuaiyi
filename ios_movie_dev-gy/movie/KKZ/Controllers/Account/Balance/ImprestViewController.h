//
//  账户充值页面
//
//  Created by alfaromeo on 12-7-11.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "HorizonTableView.h"
#import "PPiFlatSegmentedControl.h"
#import "UIAlertView+Blocks.h"
#import "UPPayPlugin.h"

@interface ImprestViewController : CommonViewController <UIGestureRecognizerDelegate, UITextFieldDelegate> {

    UIScrollView *holder1;

    UITableView *payTypeTableView;
    PayMethod selectedMethod;
    float moneyToImprest;


    UITextField *vipCardPsw;
    BOOL isEditing;

    UIImageView *headview;

    NSInteger selectedNum;
    BOOL isSame;
    UIView *moneyNumView;
    BOOL selected;

    NSInteger payMethodType;

    UIButton *btnRemember;
    NSInteger payNumY;
}

@property (nonatomic, assign) float moneyToImprest;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, assign) BOOL isImprestCard;
@property (nonatomic, assign) BOOL isWeiChatPay;

@end
