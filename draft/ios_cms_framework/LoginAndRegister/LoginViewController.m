//
//  LoginViewController.m
//  CIASMovie
//
//  Created by kokozu on 18/10/2017.
//  Copyright © 2017 cias. All rights reserved.
//

#import "LoginViewController.h"

#import "UserRequest.h"
#import "PasswordFindViewController.h"
#import "RegisterValidCodeViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
{
    //  UI
    UIView *_backgroundView;
    UITextField *_phoneNumberTextField;
    UITextField *_passwordTextField;
    
    UIButton *_registerButton;
    UIButton *_forgetPassword;
    
    UIButton *_loginButton;
    UIButton *_wechatButton;
    UIButton *_qqButton;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"登录";
    _backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backgroundView];
    
    //  返回按钮
    self.hideNavigationBar = false;
    self.hideBackBtn = false;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"titlebar_back1"] style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonAction)];
    
    CGFloat Padding = 10;
    //  手机号
    _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(Padding, 100, kCommonScreenWidth - Padding * 2, 40)];
    _phoneNumberTextField.delegate = self;
    _phoneNumberTextField.placeholder = @"请输入手机号";
    _phoneNumberTextField.font = [UIFont systemFontOfSize:18];
    _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_backgroundView addSubview:_phoneNumberTextField];
    
    //  密码
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(Padding, CGRectGetMaxY(_phoneNumberTextField.frame), CGRectGetWidth(_phoneNumberTextField.frame), CGRectGetHeight(_phoneNumberTextField.frame))];
    _passwordTextField.delegate = self;
    _passwordTextField.placeholder = @"请输入密码";
    _passwordTextField.font = _phoneNumberTextField.font;
    _passwordTextField.secureTextEntry = true;
    [_backgroundView addSubview:_passwordTextField];
    
    //  注册
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake(Padding, CGRectGetMaxY(_passwordTextField.frame) + 20, 100, 30);
    [_registerButton setTitle:@"新用户注册" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_registerButton addTarget:self action:@selector(registerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_registerButton];

    //  忘记密码
    _forgetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetPassword.frame = CGRectMake(kCommonScreenWidth - Padding - 80, CGRectGetMinY(_registerButton.frame), 80, CGRectGetHeight(_registerButton.frame));
    [_forgetPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPassword setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _forgetPassword.titleLabel.font = _registerButton.titleLabel.font;
    [_forgetPassword addTarget:self action:@selector(forgetPasswordButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_forgetPassword];
    
    //  登录
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(Padding, CGRectGetMaxY(_registerButton.frame) + 20, kCommonScreenWidth - Padding * 2, 40);
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_loginButton];
    
    //  微信登录
    _wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _wechatButton.frame = CGRectMake(Padding, CGRectGetMaxY(_loginButton.frame) + 20, 50, 50);
    [_wechatButton setImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateNormal];
    [_wechatButton addTarget:self action:@selector(wechatButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_wechatButton];
    
    //  qq登录
    _qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _qqButton.frame = CGRectMake(kCommonScreenWidth - Padding - 50, CGRectGetMinY(_wechatButton.frame), CGRectGetWidth(_wechatButton.frame), CGRectGetHeight(_wechatButton.frame));
    [_qqButton setImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateNormal];
    [_qqButton addTarget:self action:@selector(qqButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:_qqButton];
    
    //  通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIButton - Action

- (void)closeButtonAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)registerButtonAction {
    RegisterValidCodeViewController *vc = [[RegisterValidCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)forgetPasswordButtonAction {
    PasswordFindViewController *vc = [[PasswordFindViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)loginButtonAction {
    
    //  判断手机号 密码位数
    if (_phoneNumberTextField.text.length < 11) {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"手机号不符合规则" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
        }];
        return;
    }
    if (_passwordTextField.text.length < 4) {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"密码不符合规则，请使用4-12位字母或数字" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
        }];
        return;
    }
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    
    UserRequest *request = [[UserRequest alloc] init];
    [request login:_phoneNumberTextField.text password:_passwordTextField.text site:SiteTypeKKZ success:^(UserLogin * _Nullable userLogin) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

- (void)wechatButtonAction {
    
}

- (void)qqButtonAction {
    
}

#pragma mark - UITextField - Delegate

- (void)textFieldDidChangeNotification:(NSNotification *)notifi {
    UITextField *currentTF = notifi.object;
    if (currentTF == _phoneNumberTextField) {
        if (currentTF.text.length > 11) {
            _phoneNumberTextField.text = [_phoneNumberTextField.text substringToIndex:11];
        }
    } else if (currentTF == _passwordTextField) {
        if (currentTF.text.length > 12) {
            _passwordTextField.text = [_passwordTextField.text substringToIndex:12];
        }
    }
}

@end
