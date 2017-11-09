//
//  CouponBindViewController.m
//  KoMovie
//
//  Created by kokozu on 09/11/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CouponBindViewController.h"

#import "PayTask.h"

@interface CouponBindViewController ()
{
    UIView *_bindView;
    UITextField *_couponCodeTextField;
    UITextField *_cardPasswordTextField;
}
@end

@implementation CouponBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch (_type) {
        case CouponType_Stored:
            self.kkzTitleLabel.text = @"绑定储蓄卡";
            break;
        case CouponType_coupon:
            self.kkzTitleLabel.text = @"绑定优惠券";
            break;
        case CouponType_Redeem:
            self.kkzTitleLabel.text = @"绑定兑换码";
            break;
        default:
            break;
    }
    
    [self prepareBindView];
}

- (BOOL)showNavBar {
    return true;
}

- (BOOL)showTitleBar {
    return true;
}

- (BOOL)showBackButton {
    return true;
}

#pragma mark - Prepare

- (void)prepareBindView {
    //    if (!_comefromPay) {
    //        return;
    //    }
    _bindView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kAppScreenWidth, CGRectGetHeight(self.view.frame) - 64)];
    _bindView.backgroundColor = appDelegate.kkzLine;
    _bindView.hidden = true;
    [self.view addSubview:_bindView];
    
    UITapGestureRecognizer *tapBindViewGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBindViewGRAction)];
    [_bindView addGestureRecognizer:tapBindViewGR];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kAppScreenWidth, _type == CouponType_Stored ? 60 * 2 + 40 : 60 + 40)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [_bindView addSubview:whiteView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    switch (_type) {
        case CouponType_Stored:
            titleLabel.text = @"储蓄卡";
            break;
        case CouponType_coupon:
            titleLabel.text = @"优惠券";
            break;
        case CouponType_Redeem:
            titleLabel.text = @"兑换码";
            break;
        default:
            break;
    }
    titleLabel.textColor = appDelegate.kkzGray;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(30);
    }];
    
    _couponCodeTextField = [[UITextField alloc] init];
    _couponCodeTextField.backgroundColor = [UIColor whiteColor];
    _couponCodeTextField.textColor = appDelegate.kkzTextColor;
    _couponCodeTextField.font = [UIFont systemFontOfSize:10];
    _couponCodeTextField.placeholder = @"请输入券码";
    [whiteView addSubview:_couponCodeTextField];
    [_couponCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(20);
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(titleLabel);
    }];
    
    if (_type == CouponType_Stored) {
        UILabel *passwordTitleLabel = [[UILabel alloc] init];
        passwordTitleLabel.font = titleLabel.font;
        passwordTitleLabel.textColor = titleLabel.textColor;
        passwordTitleLabel.text = @"密码";
        [whiteView addSubview:passwordTitleLabel];
        [passwordTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.equalTo(_couponCodeTextField.mas_bottom).offset(60);
        }];
        
        _cardPasswordTextField = [[UITextField alloc] init];
        _cardPasswordTextField.backgroundColor = _couponCodeTextField.backgroundColor;
        _cardPasswordTextField.textColor = appDelegate.kkzTextColor;
        _cardPasswordTextField.font = [UIFont systemFontOfSize:14];
        _cardPasswordTextField.placeholder = @"请输入密码";
        [whiteView addSubview:_cardPasswordTextField];
        [_cardPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passwordTitleLabel.mas_right).offset(20);
            make.right.equalTo(_couponCodeTextField);
            make.centerY.equalTo(passwordTitleLabel);
        }];
    }
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.backgroundColor = _couponCodeTextField.backgroundColor;
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:appDelegate.kkzTextColor forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [doneButton setBackgroundImage:[UIImage imageNamed:@"Login_Button"] forState:UIControlStateNormal];
    doneButton.enabled = false;
    [doneButton addTarget:self action:@selector(bindViewButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_couponCodeTextField);
        make.bottom.equalTo(whiteView).offset(-20);
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - UIButton - Action

- (void)bindViewButtonAction {
    
    if (_couponCodeTextField.text.length == 0) {
        return;
    }
    
    _bindView.hidden = true;
    
    PayTask *task = [[PayTask alloc] initBindingCouponforUser:[_couponCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                                      groupId:[NSString stringWithFormat:@"%lu", _type]
                                                     password:_cardPasswordTextField.text
                                                     finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                         NSLog(@"%@", userInfo);
                                                         if (succeeded) {
                                                             [UIAlertView showAlertView:@"绑定完成" buttonText:@"确定"];
                                                         } else {
                                                             [UIAlertView showAlertView:@"绑定失败，请重试" buttonText:@"确定"];
                                                         }
                                                         [appDelegate hideIndicator];
                                                     }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        [appDelegate showIndicatorWithTitle:@"请稍候..." animated:YES fullScreen:NO overKeyboard:NO andAutoHide:NO];
    }
}

- (void)tapBindViewGRAction {
    [_couponCodeTextField resignFirstResponder];
    [_cardPasswordTextField resignFirstResponder];
}

@end
