//
//  CouponBindViewController.m
//  KoMovie
//
//  Created by kokozu on 09/11/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CouponBindViewController.h"

#import "PayTask.h"

@interface CouponBindViewController () <UITextFieldDelegate>
{
    UIView *_bindView;
    UITextField *_couponCodeTextField;
    UITextField *_cardPasswordTextField;
    UILabel *_messageLabel;
    UIButton *_doneButton;
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
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [whiteView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.width.mas_equalTo(60);
    }];
    
    _couponCodeTextField = [[UITextField alloc] init];
    _couponCodeTextField.backgroundColor = [UIColor whiteColor];
    _couponCodeTextField.textColor = appDelegate.kkzTextColor;
    _couponCodeTextField.font = [UIFont systemFontOfSize:14];
    _couponCodeTextField.placeholder = @"请输入券码";
    _couponCodeTextField.delegate = self;
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
            make.top.equalTo(_couponCodeTextField.mas_bottom).offset(40);
        }];
        
        _cardPasswordTextField = [[UITextField alloc] init];
        _cardPasswordTextField.backgroundColor = _couponCodeTextField.backgroundColor;
        _cardPasswordTextField.textColor = appDelegate.kkzTextColor;
        _cardPasswordTextField.font = [UIFont systemFontOfSize:14];
        _cardPasswordTextField.placeholder = @"请输入密码";
        [whiteView addSubview:_cardPasswordTextField];
        [_cardPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_couponCodeTextField);
            make.right.equalTo(_couponCodeTextField);
            make.centerY.equalTo(passwordTitleLabel);
        }];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = appDelegate.kkzLine;
        [whiteView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(whiteView);
            make.top.mas_equalTo(60);
            make.height.mas_equalTo(0.5);
        }];
    }
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = appDelegate.kkzLine;
    [whiteView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(whiteView);
        make.bottom.mas_equalTo(-40);
        make.height.mas_equalTo(0.5);
    }];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textColor = appDelegate.kkzPink;
    _messageLabel.text = @"输入的号码有误";
    _messageLabel.font = [UIFont systemFontOfSize:10];
    _messageLabel.hidden = true;
    [whiteView addSubview:_messageLabel];
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.bottom.mas_equalTo(-10);
    }];
    
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneButton setTitle:@"确认绑定" forState:UIControlStateNormal];
    [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton setBackgroundImage:[UIImage imageNamed:@"Login_Button"] forState:UIControlStateNormal];
    _doneButton.enabled = false;
    [_doneButton addTarget:self action:@selector(bindViewButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_bindView addSubview:_doneButton];
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bindView);
        make.width.equalTo(@150);
        make.top.equalTo(whiteView.mas_bottom).offset(30);
        make.height.mas_equalTo(54);
    }];
}

#pragma mark - UIButton - Action

- (void)bindViewButtonAction {
    
    if (_couponCodeTextField.text.length == 0) {
        return;
    }
    
    PayTask *task = [[PayTask alloc] initBindingCouponforUser:[_couponCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]
                                                      groupId:[NSString stringWithFormat:@"%lu", _type]
                                                     password:_cardPasswordTextField.text
                                                     finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                         NSLog(@"%@", userInfo);
                                                         if (succeeded) {
                                                             [UIAlertView showAlertView:@"绑定完成" buttonText:@"确定"];
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCouponList" object:nil];
                                                         } else {
                                                             [appDelegate showAlertViewForTaskInfo:userInfo];
                                                             _messageLabel.hidden = false;
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

#pragma mark - UITextField - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.text.length > 5) {
        _doneButton.enabled = true;
    } else {
        _doneButton.enabled = false;
    }
    
    _messageLabel.hidden = true;
    return true;
}

@end
