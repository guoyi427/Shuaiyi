//
//  RegisterPasswordViewController.m
//  CIASMovie
//
//  Created by kokozu on 19/10/2017.
//  Copyright © 2017 cias. All rights reserved.
//

#import "RegisterPasswordViewController.h"

#import "UserRequest.h"

@interface RegisterPasswordViewController () <UITextFieldDelegate>
{
    //  UI
    UITextField *_nickNameTextField;
    UITextField *_passwordTextField;
    UITextField *_checkPasswordTextField;
}
@end

@implementation RegisterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    
    CGFloat Padding = 10.0f;
    _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(Padding, Padding, kCommonScreenWidth - Padding * 2, 40)];
    _nickNameTextField.placeholder = @"请输入昵称";
    _nickNameTextField.font = [UIFont systemFontOfSize:14];
    _nickNameTextField.textColor = [UIColor blackColor];
    _nickNameTextField.delegate = self;
    [self.view addSubview:_nickNameTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(Padding, CGRectGetMaxY(_nickNameTextField.frame) + Padding, CGRectGetWidth(_nickNameTextField.frame), CGRectGetHeight(_nickNameTextField.frame))];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.font = _nickNameTextField.font;
    _passwordTextField.textColor = _nickNameTextField.textColor;
    _passwordTextField.delegate = self;
    _passwordTextField.secureTextEntry = true;
    [self.view addSubview:_passwordTextField];
    
    _checkPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(Padding, CGRectGetMaxY(_passwordTextField.frame) + Padding, CGRectGetWidth(_nickNameTextField.frame), CGRectGetHeight(_nickNameTextField.frame))];
    _checkPasswordTextField.font = _nickNameTextField.font;
    _checkPasswordTextField.textColor = _nickNameTextField.textColor;
    _checkPasswordTextField.placeholder = @"确认密码";
    _checkPasswordTextField.delegate = self;
    _checkPasswordTextField.secureTextEntry = true;
    [self.view addSubview:_checkPasswordTextField];
}

#pragma mark - UIButton - Action

- (void)rightBarButtonAction {
    if (!_phoneNumber || !_validCode) {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"手机号或验证码不符合规则" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
        }];
        return;
    }
    
    if (!_nickNameTextField.text) {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"昵称为空" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
        }];
        return;
    }
    
    if (!_passwordTextField.text) {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"密码为空" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
        }];
        return;
    }
    
    if (![_passwordTextField.text isEqualToString:_checkPasswordTextField.text]) {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"两次输入的密码不一致" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
        }];
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    UserRequest *request = [[UserRequest alloc] init];
    [request registerPhoneNumber:_phoneNumber password:_passwordTextField.text nickName:_nickNameTextField.text validCode:_validCode success:^(UserLogin * _Nullable user) {
        NSLog(@"注册成功");
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    } failure:^(NSError * _Nullable err) {
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

#pragma mark - UITextField - Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _nickNameTextField) {
        [_nickNameTextField resignFirstResponder];
        [_passwordTextField becomeFirstResponder];
    } else if (textField == _passwordTextField) {
        [_passwordTextField resignFirstResponder];
        [_checkPasswordTextField becomeFirstResponder];
    } else {
        [_checkPasswordTextField resignFirstResponder];
        [self rightBarButtonAction];
    }
}
@end
