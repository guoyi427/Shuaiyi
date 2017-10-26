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
    self.kkzTitleLabel.text = @"注册";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat Padding = 20.0f;
    UIImageView *bgView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_TextField"]];
    bgView1.userInteractionEnabled = true;
    [self.view addSubview:bgView1];
    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(54);
        make.top.mas_equalTo(64+Padding);
    }];
    
    UIImageView *bgView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_TextField"]];
    bgView2.userInteractionEnabled = true;
    [self.view addSubview:bgView2];
    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(54);
        make.top.equalTo(bgView1.mas_bottom).offset(Padding/2);
    }];
    
    UIImageView *bgView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_TextField"]];
    bgView3.userInteractionEnabled = true;
    [self.view addSubview:bgView3];
    [bgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(54);
        make.top.equalTo(bgView2.mas_bottom).offset(Padding/2);
    }];
    
    
    _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(Padding, Padding + 64, kCommonScreenWidth - Padding * 2, 40)];
    _nickNameTextField.placeholder = @"请输入昵称";
    _nickNameTextField.font = [UIFont systemFontOfSize:14];
    _nickNameTextField.textColor = [UIColor blackColor];
    _nickNameTextField.delegate = self;
    [bgView1 addSubview:_nickNameTextField];
    [_nickNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(44);
        make.centerY.equalTo(bgView1);
    }];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(Padding, CGRectGetMaxY(_nickNameTextField.frame) + Padding, CGRectGetWidth(_nickNameTextField.frame), CGRectGetHeight(_nickNameTextField.frame))];
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.font = _nickNameTextField.font;
    _passwordTextField.textColor = _nickNameTextField.textColor;
    _passwordTextField.delegate = self;
    _passwordTextField.secureTextEntry = true;
    [bgView2 addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(44);
        make.centerY.equalTo(bgView2);
    }];
    
    _checkPasswordTextField = [[UITextField alloc] initWithFrame:CGRectMake(Padding, CGRectGetMaxY(_passwordTextField.frame) + Padding, CGRectGetWidth(_nickNameTextField.frame), CGRectGetHeight(_nickNameTextField.frame))];
    _checkPasswordTextField.font = _nickNameTextField.font;
    _checkPasswordTextField.textColor = _nickNameTextField.textColor;
    _checkPasswordTextField.placeholder = @"确认密码";
    _checkPasswordTextField.delegate = self;
    _checkPasswordTextField.secureTextEntry = true;
    [bgView3 addSubview:_checkPasswordTextField];
    [_checkPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(44);
        make.centerY.equalTo(bgView3);
    }];
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBarBtn setBackgroundImage:[UIImage imageNamed:@"Login_Button"] forState:UIControlStateNormal];
    [rightBarBtn addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBarBtn];
    [rightBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.height.mas_equalTo(54);
        make.top.equalTo(bgView3.mas_bottom).offset(Padding/2);
    }];
}

#pragma mark - UIButton - Action

- (void)rightBarButtonAction {
    if (!_phoneNumber || !_validCode) {
        [UIAlertView showAlertView:@"手机号或验证码不符合规则" buttonText:@"重新填写"];
        return;
    }
    
    if (!_nickNameTextField.text) {
        [UIAlertView showAlertView:@"昵称为空" buttonText:@"重新填写"];
        return;
    }
    
    if (!_passwordTextField.text) {
        [UIAlertView showAlertView:@"密码为空" buttonText:@"重新填写"];
        return;
    }
    
    if (![_passwordTextField.text isEqualToString:_checkPasswordTextField.text]) {
        [UIAlertView showAlertView:@"两次输入的密码不一致" buttonText:@"重新填写"];
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    UserRequest *request = [[UserRequest alloc] init];
    [request registerPhoneNumber:_phoneNumber password:_passwordTextField.text nickName:_nickNameTextField.text validCode:_validCode success:^(UserLogin * _Nullable user) {
        NSLog(@"注册成功");
        [weakSelf dismissViewControllerAnimated:true completion:^{
            NSDictionary *dic = @{@"data":user,@"isFromRegister":@"YES"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"handleLoginViewSuccess" object:nil userInfo:dic];
        }];
    } failure:^(NSError * _Nullable err) {
        [UIAlertView showAlertView:@"注册失败" buttonText:@"确认"];
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

- (BOOL)showBackButton {
    return true;
}

- (BOOL)showTitleBar {
    return true;
}

@end
