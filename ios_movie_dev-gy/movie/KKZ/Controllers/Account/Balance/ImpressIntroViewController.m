//
//  我的 - 账户余额
//
//  Created by gree2 on 9/12/13.
//  Copyright (c) 2013 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "DataEngine.h"
#import "ImpressIntroViewController.h"
#import "ImprestViewController.h"
#import "RoundCornersButton.h"
#import "TaskQueue.h"
#import "UIConstants.h"
#import "UserManager.h"

static const CGFloat kDividerHeight = 1.f;

@interface ImpressIntroViewController ()

/**
 * 页面的内容。
 */
@property (nonatomic, strong) UIScrollView *content;

/**
 * 账户余额的内容。
 */
@property (nonatomic, strong) UIView *contentBalance;

/**
 * 账户余额的标题。
 */
@property (nonatomic, strong) UILabel *balanceHintLabel;

/**
 * 账户余额。
 */
@property (nonatomic, strong) UILabel *balanceLabel;

/**
 * 立即充值按钮。
 */
@property (nonatomic, strong) RoundCornersButton *rechargeButton;

@end

@implementation ImpressIntroViewController

#pragma mark - Lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"账户余额";

    [self.view addSubview:self.content];

    [self.content addSubview:[self dividerWithTop:15]];
    [self.content addSubview:self.contentBalance];
    [self.contentBalance addSubview:self.balanceHintLabel];
    [self.contentBalance addSubview:self.balanceLabel];
    [self.contentBalance addSubview:self.rechargeButton];
    [self.content addSubview:[self dividerWithTop:15 + kDividerHeight + self.contentBalance.frame.size.height]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self queryAccountBalance];
}

#pragma mark Init views
- (UIScrollView *)content {
    if (!_content) {
        _content = [[UIScrollView alloc]
                initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
        _content.delegate = self;
        _content.backgroundColor = kGrayBackground;
        _content.contentSize = CGSizeMake(screentWith, screentContentHeight - 42);
    }
    return _content;
}

- (UIView *)contentBalance {
    if (!_contentBalance) {
        _contentBalance = [[UIView alloc] initWithFrame:CGRectMake(0, 15 + kDividerHeight, screentWith, 60)];
        _contentBalance.backgroundColor = [UIColor whiteColor];
    }
    return _contentBalance;
}

- (UILabel *)balanceHintLabel {
    if (!_balanceHintLabel) {
        _balanceHintLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 80, 20)];
        _balanceHintLabel.backgroundColor = [UIColor clearColor];
        _balanceHintLabel.text = @"账户余额：";
        _balanceHintLabel.textColor = [UIColor grayColor];
        _balanceHintLabel.font = [UIFont systemFontOfSize:14];
        _balanceHintLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _balanceHintLabel;
}

- (UILabel *)balanceLabel {
    if (!_balanceLabel) {
        _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 20, 150, 20)];
        _balanceLabel.hidden = NO;
        _balanceLabel.text = @"获取中...";
        _balanceLabel.textColor = [UIColor grayColor];
        _balanceLabel.backgroundColor = [UIColor clearColor];
        _balanceLabel.font = [UIFont systemFontOfSize:14];
        _balanceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _balanceLabel;
}

- (RoundCornersButton *)rechargeButton {
    if (!_rechargeButton) {
        _rechargeButton = [[RoundCornersButton alloc] initWithFrame:CGRectMake(screentWith - 115, 15, 100, 30)];
        _rechargeButton.cornerNum = kDimensCornerNum;
        _rechargeButton.titleName = @"立即充值";
        _rechargeButton.titleColor = [UIColor whiteColor];
        _rechargeButton.titleFont = [UIFont systemFontOfSize:kTextSizeButtonLarge];
        _rechargeButton.backgroundColor = appDelegate.kkzBlue;
        _rechargeButton.fillColor = appDelegate.kkzBlue;
        [_rechargeButton addTarget:self
                            action:@selector(navigateToRechargeViewController)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeButton;
}

- (UIView *)dividerWithTop:(CGFloat)top {
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, top, screentWith, kDividerHeight)];
    divider.backgroundColor = kDividerColor;
    return divider;
}

#pragma mark HandleUrlProtocol delegate
- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    self = [super init];
    return self;
}

#pragma mark - Network task
- (void)queryAccountBalance {
    
    [[UserManager shareInstance] updateBalance:^(NSNumber * _Nullable vipAccount) {
        
        [appDelegate hideIndicator];
        self.balanceLabel.text = [NSString stringWithFormat:@"%.2f元", [DataEngine sharedDataEngine].vipBalance];

    } failure:^(NSError * _Nullable err) {
        
        [appDelegate hideIndicator];
        self.balanceLabel.text = @"获取失败";
        
    }];
}

#pragma mark - Handle button tapped methods
- (void)navigateToRechargeViewController {
    ImprestViewController *ctr = [[ImprestViewController alloc] init];
    [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -60.0f && scrollView == self.content) {
        [self queryAccountBalance];
    }
}

@end
