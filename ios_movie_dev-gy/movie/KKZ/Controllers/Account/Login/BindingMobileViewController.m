//
//  BindingMobileViewController.m
//  KoMovie
//
//  Created by kokozu on 23/11/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "BindingMobileViewController.h"

//  View
#import "KKZTextField.h"
#import "RoundCornersButton.h"
#import "KKZUtility.h"

//  Request
#import "ValidcodeRequest.h"
#import "UserRequest.h"

#define kValidcodeEnabled HEX(@"#008cff")
#define kValidcodeDisabled HEX(@"#d3d3d3")

@interface BindingMobileViewController () <KKZTextFieldDelegate, KKZKeyboardTopViewDelegate, UITextFieldDelegate>
{
    //  Data
    NSInteger timeCount;
    NSTimer *timer;
    
}
@property (nonatomic, strong) KKZTextField *mobileInputField;
@property (nonatomic, strong) KKZTextField *validcodeInputField;
@property (nonatomic, strong) RoundCornersButton *queryValidcodeButton;
@property (nonatomic, strong) UIButton *loginBtn;
@end

@implementation BindingMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.kkzTitleLabel.text = @"绑定手机";
    
    //  background view
    UIImageView *mobileBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_TextField"]];
    [self.view addSubview:mobileBgView];
    [mobileBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(64 + 40);
        make.height.mas_equalTo(111/2.0);
    }];
    
    //手机输入框
    [self.view addSubview:self.mobileInputField];
    [self.mobileInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mobileBgView).offset(20);
        make.centerY.equalTo(mobileBgView);
        make.right.equalTo(mobileBgView).offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    //  background view
    UIImageView *validBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_TextField"]];
    validBgView.userInteractionEnabled = true;
    [self.view addSubview:validBgView];
    [validBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.equalTo(mobileBgView.mas_bottom).offset(20);
        make.height.mas_equalTo(111/2.0);
    }];
    
    //验证码输入框
    [validBgView addSubview:self.validcodeInputField];
    [self.validcodeInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.equalTo(validBgView);
        make.right.equalTo(validBgView).offset(-120);
        make.height.mas_equalTo(44);
    }];
    
    //  验证吗
    [validBgView addSubview:self.queryValidcodeButton];
    [self.queryValidcodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(validBgView);
        make.centerY.equalTo(validBgView);
    }];
    
    [self.view addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mobileBgView);
        make.right.equalTo(mobileBgView);
        make.top.equalTo(self.validcodeInputField.mas_bottom).offset(20);
        make.height.mas_equalTo(111/2.0);
    }];
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

#pragma mark - Private - Methods

- (BOOL)checkValidcodeButtonEnable {
    BOOL enabled = (self.mobileInputField.text.length == 11 && [self.mobileInputField.text hasPrefix:@"1"] && timeCount <= 0);
    [self setValidcodeButtonEnable:enabled];
    return enabled;
}

- (void)setValidcodeButtonEnable:(BOOL)enabled {
    self.queryValidcodeButton.enabled = enabled;
    
    if (enabled) {
        self.queryValidcodeButton.rimColor = kValidcodeEnabled;
        self.queryValidcodeButton.titleColor = kValidcodeEnabled;
    }
    else {
        self.queryValidcodeButton.rimColor = kValidcodeDisabled;
        self.queryValidcodeButton.titleColor = kValidcodeDisabled;
    }
}

- (BOOL)isNetworkConnected {
    if (!isConnected) {
        [UIAlertView showAlertView:@"当前网络未连接，请您稍后重试" buttonText:@"确定"];
        return NO;
    }
    return YES;
}

- (NSString *)mobile {
    NSString *mobile = self.mobileInputField.text;
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    return mobile;
}

- (void)handleQueryValidcodeResult:(NSDictionary *)userInfo
                            status:(BOOL)succeeded
                              type:(ValidcodeType)type {
    
    [KKZUtility hidenIndicator];
    
    if (succeeded) {
        
        [UIAlertView showAlertView:@"验证码已经发出，请您耐心等待"
                        buttonText:@"确定"];
        
        [self.validcodeInputField becomeFirstResponder];
        
        [self setValidcodeButtonEnable:NO];
        
        timeCount = 60;
        [self startValidcodeButtonCountdown];
        
        [timer invalidate];
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countdownValidcodeEnable:) userInfo:nil repeats:YES];
    } else {
        [appDelegate showAlertViewForRequestInfo:userInfo];
    }
}

- (void)startValidcodeButtonCountdown {
    NSString *titleName = [NSString stringWithFormat:@"%ld秒后重发", timeCount];
    
    [self.queryValidcodeButton setTitle:titleName forState:UIControlStateNormal];
    [self.queryValidcodeButton setNeedsDisplay];
}


/**
 *  点击键盘取消按钮
 */
- (void)dismissKeyBoard {
    [self resignFirstResponders];
}

/**
 *  取消键盘
 */
- (void)resignFirstResponders {
    [self.mobileInputField resignFirstResponder];
    [self.validcodeInputField resignFirstResponder];
}

- (void)checkLoginButtonEnable {
    if (self.mobileInputField.text.length == 11 && [self.mobileInputField.text hasPrefix:@"1"] && self.validcodeInputField.text.length >= 6 && self.validcodeInputField.text.length <= 12) {
        self.loginBtn.enabled = YES;
        //        self.loginBtn.backgroundColor = kLoginEnabled;
    }
    else {
        self.loginBtn.enabled = NO;
        //        self.loginBtn.backgroundColor = kLoginDisabled;
    }
}

#pragma mark - NSTimer - Action

- (void)countdownValidcodeEnable:(NSTimer *)time {
    timeCount--;
    
    if (timeCount <= 0) {
        self.queryValidcodeButton.enabled = YES;
        [self.queryValidcodeButton setNeedsDisplay];
        [self.queryValidcodeButton setTitle:@"获取验证码"
                                   forState:UIControlStateNormal];
        [timer invalidate];
        timer = nil;
        [self checkValidcodeButtonEnable];
    }
    else { //倒计时显示
        NSString *titleName = [NSString stringWithFormat:@"%ld秒后重发", timeCount];
        [self.queryValidcodeButton setTitle:titleName
                                   forState:UIControlStateNormal];
        [self.queryValidcodeButton setNeedsDisplay];
    }
}

#pragma mark - TextField - Action

- (void)KKZKeyboardDismissed {
    [self dismissKeyBoard];
}

- (void)mobileTextFieldChanged {
    [self checkValidcodeButtonEnable];
    [self checkLoginButtonEnable];
}

- (void)validcodeTextFieldChanged {
    [self checkLoginButtonEnable];
}

#pragma mark - UIButton - Action

- (void)cancelViewController {
    [super cancelViewController];
    [appDelegate signout];
}
- (void)queryValidcodeButtonAction {
    ValidcodeType type = SMSValidcode;
    if (![self isNetworkConnected]) {
        return;
    }
    
    if (![self checkValidcodeButtonEnable]) {
        return;
    }
    
    //显示加载框
    [KKZUtility showIndicatorWithTitle:@"请稍候..." atView:self.view];
    
    WeakSelf
    ValidcodeRequest *request = [[ValidcodeRequest alloc] init];
    [request requestLoginValidcode:[self mobile]
                     validcodeType:type
                           success:^ {
                               
                               [weakSelf handleQueryValidcodeResult:nil status:YES type:type];
                           }
                           failure:^(NSError * _Nullable err) {
                               
                               [weakSelf handleQueryValidcodeResult:err.userInfo status:NO type:type];
                           }];
}

- (void)loginMainBtnClick:(UIButton *)sender {
    if (sender.tag == 200) {
        //  获取验证码
        [self queryValidcodeButtonAction];
    } else if (sender.tag == 201) {
        //  绑定手机号   user_Binding
        WeakSelf
        UserRequest *request = [[UserRequest alloc] init];
        [request bindAccountPhoneNum:[self mobile] password:self.validcodeInputField.text code:@"" success:^{
            [weakSelf dismissViewControllerAnimated:true completion:nil];
        } failure:^(NSError * _Nullable err) {
            [appDelegate showAlertViewForRequestInfo:err.userInfo];
        }];
    }
}

#pragma mark - Setter

- (KKZTextField *)mobileInputField {
    if (!_mobileInputField) {
        _mobileInputField = [[KKZTextField alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.frame) - 40, 40) andFieldType:KKZTextFieldWithClear];
        _mobileInputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _mobileInputField.font = [UIFont systemFontOfSize:kText45PX];
        _mobileInputField.backgroundColor = [UIColor clearColor];
        [_mobileInputField setValue:HEX(@"#D3D3D3") forKeyPath:@"_placeholderLabel.textColor"];
        NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"
                                                                          attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
        _mobileInputField.attributedPlaceholder = placeholder;
        _mobileInputField.clearImage = [UIImage imageNamed:@"ic_login_clear_input"];
        _mobileInputField.textColor = [UIColor blackColor];
        _mobileInputField.delegate = self;
        _mobileInputField.kkzDelegate = self;
        _mobileInputField.keyboardDelegate = self;
        _mobileInputField.keyboardType = UIKeyboardTypePhonePad;
        _mobileInputField.returnKeyType = UIReturnKeyNext;
        [_mobileInputField addTarget:self
                              action:@selector(mobileTextFieldChanged)
                    forControlEvents:UIControlEventEditingChanged];
    }
    return _mobileInputField;
}


- (KKZTextField *)validcodeInputField {
    if (!_validcodeInputField) {
        _validcodeInputField = [[KKZTextField alloc] initWithFrame:CGRectMake(20, 0, CGRectGetWidth(_mobileInputField.frame), 40) andFieldType:KKZTextFieldWithClear];
        _validcodeInputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _validcodeInputField.font = [UIFont systemFontOfSize:kText45PX];
        _validcodeInputField.backgroundColor = [UIColor clearColor];
        [_validcodeInputField setValue:HEX(@"#d3d3d3") forKeyPath:@"_placeholderLabel.textColor"];
        NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"请输入验证码"
                                                                          attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
        _validcodeInputField.attributedPlaceholder = placeholder;
        _validcodeInputField.clearImage = [UIImage imageNamed:@"ic_login_clear_input"];
        _validcodeInputField.textColor = [UIColor blackColor];
        _validcodeInputField.delegate = self;
        _validcodeInputField.kkzDelegate = self;
        _validcodeInputField.keyboardDelegate = self;
        //        _validcodeInputField.keyboardType = UIKeyboardTypeNumberPad;
        _validcodeInputField.returnKeyType = UIReturnKeyGo;
        //        _validcodeInputField.secureTextEntry = true;
        [_validcodeInputField addTarget:self
                                 action:@selector(validcodeTextFieldChanged)
                       forControlEvents:UIControlEventEditingChanged];
    }
    return _validcodeInputField;
}


- (RoundCornersButton *)queryValidcodeButton {
    if (!_queryValidcodeButton) {
        _queryValidcodeButton = [[RoundCornersButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 96, 5, 96, 30)];
        _queryValidcodeButton.tag = 200;
        _queryValidcodeButton.enabled = NO;
        //        _queryValidcodeButton.backgroundColor = [UIColor clearColor];
        //        _queryValidcodeButton.rimWidth = 1;
        //        _queryValidcodeButton.rimColor = kValidcodeDisabled;
        //        _queryValidcodeButton.cornerNum = 3;
        //        _queryValidcodeButton.titleName = @"获取验证码";
        //        _queryValidcodeButton.titleColor = kValidcodeDisabled;
        //        _queryValidcodeButton.titleFont = [UIFont systemFontOfSize:kText36PX];
        [_queryValidcodeButton setBackgroundImage:[UIImage imageNamed:@"Login_ValidCode"] forState:UIControlStateNormal];
        [_queryValidcodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _queryValidcodeButton.titleLabel.font = [UIFont systemFontOfSize:kText36PX];
        [_queryValidcodeButton addTarget:self
                                  action:@selector(loginMainBtnClick:)
                        forControlEvents:UIControlEventTouchUpInside];
    }
    return _queryValidcodeButton;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:0];
        _loginBtn.frame = CGRectMake(20, CGRectGetMaxY(self.validcodeInputField.frame) + 20, screentWith - 40, 40);
        //        _loginBtn.backgroundColor = kLoginDisabled;
        _loginBtn.tag = 201;
        _loginBtn.layer.cornerRadius = 3;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.enabled = NO;
        [_loginBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:kText51PX]];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"Login_Button"] forState:UIControlStateNormal];
        [_loginBtn addTarget:self
                      action:@selector(loginMainBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

@end
