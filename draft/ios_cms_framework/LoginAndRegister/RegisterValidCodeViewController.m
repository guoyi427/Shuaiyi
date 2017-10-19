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
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];

    CGFloat Padding = 10.0f;
    _phoneNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(Padding, Padding, kCommonScreenWidth - Padding * 2, 40)];
    _phoneNumberTextField.delegate = self;
    _phoneNumberTextField.placeholder = @"请输入手机号";
    _phoneNumberTextField.font = [UIFont systemFontOfSize:15];
    _phoneNumberTextField.textColor = [UIColor blackColor];
    [self.view addSubview:_phoneNumberTextField];
    
    _validCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(Padding, CGRectGetMaxY(_phoneNumberTextField.frame), kCommonScreenWidth - Padding * 2 - 100, CGRectGetHeight(_phoneNumberTextField.frame))];
    _validCodeTextField.delegate = self;
    _validCodeTextField.placeholder = @"请输入验证码";
    _validCodeTextField.font = _phoneNumberTextField.font;
    _validCodeTextField.textColor = _phoneNumberTextField.textColor;
    [self.view addSubview:_validCodeTextField];
    
    _sendValidCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendValidCodeButton.frame = CGRectMake(CGRectGetMaxX(_validCodeTextField.frame), CGRectGetMinY(_validCodeTextField.frame), 100, CGRectGetHeight(_validCodeTextField.frame));
    _sendValidCodeButton.backgroundColor = [UIColor blueColor];
    [_sendValidCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_sendValidCodeButton addTarget:self action:@selector(sendValidCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendValidCodeButton];
    
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
        make.top.equalTo(_sendValidCodeButton.mas_bottom).offset(Padding);
    }];
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomButton addTarget:self action:@selector(sendMobileValidCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.equalTo(bottomLabel);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
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
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"手机号不符合规则" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
        }];
        return;
    }
    
    ValidcodeRequest *request = [[ValidcodeRequest alloc] init];
    [request requestRegisterValidcode:_phoneNumberTextField.text validcodeType:SMSValidcode success:^{
        [[CIASAlertCancleView new] show:@"验证码已经发出，请您耐心等待" message:nil cancleTitle:@"确定" callback:nil];

    } failure:^(NSError * _Nullable err) {
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

- (void)sendMobileValidCodeButtonAction {
    if (_phoneNumberTextField.text.length < 11) {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"手机号不符合规则" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
        }];
        return;
    }
    
    ValidcodeRequest *request = [[ValidcodeRequest alloc] init];
    [request requestRegisterValidcode:_phoneNumberTextField.text validcodeType:VoiceValidcode success:^{
        [[CIASAlertCancleView new] show:@"我们将通过电话方式告知您验证码，请注意接听" message:nil cancleTitle:@"确定" callback:nil];

    } failure:^(NSError * _Nullable err) {
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

#pragma mark - UITextField - Delegate


@end
