//
//  RegisterValidCodeViewController.m
//  CIASMovie
//
//  Created by kokozu on 19/10/2017.
//  Copyright © 2017 cias. All rights reserved.
//

#import "RegisterValidCodeViewController.h"

#import "ValidcodeRequest.h"
#import "RegisterPasswordViewController.h"

@interface RegisterValidCodeViewController () <UITextFieldDelegate>
{
    //  UI
    UITextField *_phoneNumberTextField;
    UITextField *_validCodeTextField;
    UIButton *_sendValidCodeButton;
    
}
@end

@implementation RegisterValidCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kkzTitleLabel.text = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame = CGRectMake(screentWith - 80, 0, 80, 44);
    [rightBarBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [rightBarBtn addTarget:self action:@selector(rightBarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:rightBarBtn];

    CGFloat Padding = 20.0f;
    
    UIImageView *phoneBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_TextField"]];
    phoneBgView.userInteractionEnabled = true;
    [self.view addSubview:phoneBgView];
    [phoneBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.mas_equalTo(Padding + 64);
    }];
    
    UIImageView *phoneIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_Mobile"]];
    [phoneBgView addSubview:phoneIconView];
    [phoneIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.width.mas_equalTo(23.5);
        make.centerY.equalTo(phoneBgView);
    }];
    
    _phoneNumberTextField = [[UITextField alloc] init];
    _phoneNumberTextField.delegate = self;
    _phoneNumberTextField.placeholder = @"请输入手机号";
    _phoneNumberTextField.font = [UIFont systemFontOfSize:15];
    _phoneNumberTextField.textColor = [UIColor blackColor];
    _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneBgView addSubview:_phoneNumberTextField];
    [_phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneIconView.mas_right).offset(Padding);
        make.right.equalTo(phoneBgView).offset(-Padding);
        make.centerY.equalTo(phoneBgView);
        make.height.mas_equalTo(44);
    }];
    
    /// 验证码
    UIImageView *validBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_TextField"]];
    validBgView.userInteractionEnabled = true;
    [self.view addSubview:validBgView];
    [validBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.right.mas_equalTo(-Padding);
        make.top.equalTo(phoneBgView.mas_bottom).offset(Padding);
    }];
    
    UIImageView *validIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_Password"]];
    [validBgView addSubview:validIconView];
    [validIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(Padding);
        make.width.mas_equalTo(21.5);
        make.centerY.equalTo(validBgView);
    }];
    
    _validCodeTextField = [[UITextField alloc] init];
    _validCodeTextField.delegate = self;
    _validCodeTextField.placeholder = @"请输入验证码";
    _validCodeTextField.font = _phoneNumberTextField.font;
    _validCodeTextField.textColor = _phoneNumberTextField.textColor;
    [validBgView addSubview:_validCodeTextField];
    [_validCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(validIconView.mas_right).offset(Padding);
        make.right.equalTo(validBgView).offset(-Padding-120);
        make.centerY.equalTo(validBgView);
        make.height.mas_equalTo(44);
    }];
    
    _sendValidCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendValidCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _sendValidCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sendValidCodeButton setBackgroundImage:[UIImage imageNamed:@"Login_ValidCode"] forState:UIControlStateNormal];
    [_sendValidCodeButton addTarget:self action:@selector(sendValidCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [validBgView addSubview:_sendValidCodeButton];
    [_sendValidCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(validBgView);
        make.centerY.equalTo(validBgView);
    }];
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    [self.view addSubview:bottomLabel];
    
    NSMutableAttributedString *bottomText = [[NSMutableAttributedString alloc] initWithString:@"如果获取不到手机验证码，请尝试电话获取"];
    [bottomText addAttributes:@{
                                NSFontAttributeName: [UIFont systemFontOfSize:15],
                                NSForegroundColorAttributeName: [UIColor blackColor],
                                } range:NSMakeRange(0, bottomText.string.length)];
    [bottomText addAttributes:@{
                                NSForegroundColorAttributeName: [UIColor blueColor],
                                NSUnderlineStyleAttributeName: @1.0f
                                } range:NSMakeRange(bottomText.string.length - 4, 4)];
    bottomLabel.attributedText = bottomText;
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-Padding);
        make.top.equalTo(validBgView.mas_bottom).offset(Padding);
    }];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomButton addTarget:self action:@selector(sendMobileValidCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.equalTo(bottomLabel);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UIButton - Action

- (void)rightBarButtonAction {
    RegisterPasswordViewController *vc = [[RegisterPasswordViewController alloc] init];
    vc.phoneNumber = _phoneNumberTextField.text;
    vc.validCode = _validCodeTextField.text;
    [self.navigationController pushViewController:vc animated:true];
}

- (void)sendValidCodeButtonAction {
    
    if (_phoneNumberTextField.text.length < 11) {
        [UIAlertView showAlertView:@"手机号不符合规则" buttonText:@"重新填写"];
        return;
    }
    
    ValidcodeRequest *request = [[ValidcodeRequest alloc] init];
    [request requestRegisterValidcode:_phoneNumberTextField.text validcodeType:SMSValidcode success:^{

        [UIAlertView showAlertView:@"验证码已经发出，请您耐心等待" buttonText:@"确定"];
    } failure:^(NSError * _Nullable err) {
        [UIAlertView showAlertView:err.userInfo[@"kkz.error.message"] buttonText:@"确定"];
    }];
}

- (void)sendMobileValidCodeButtonAction {
    if (_phoneNumberTextField.text.length < 11) {
        [UIAlertView showAlertView:@"手机号不符合规则" buttonText:@"重新填写"];
        return;
    }
    
    ValidcodeRequest *request = [[ValidcodeRequest alloc] init];
    [request requestRegisterValidcode:_phoneNumberTextField.text validcodeType:VoiceValidcode success:^{
        [UIAlertView showAlertView:@"我们将通过电话方式告知您验证码，请注意接听" buttonText:@"确定"];
    } failure:^(NSError * _Nullable err) {
        
    }];
}

#pragma mark - UITextField - Delegate

- (void)textFieldDidChangeNotification:(NSNotification *)notifi {
    UITextField *currentTF = notifi.object;
    if (currentTF == _phoneNumberTextField) {
        if (currentTF.text.length > 11) {
            _phoneNumberTextField.text = [_phoneNumberTextField.text substringToIndex:11];
        }
    }
}

- (BOOL)showTitleBar {
    return true;
}

- (BOOL)showBackButton {
    return true;
}

@end
