//
//  找回密码页面
//
//  Created by xuyang on 13-2-26.
//  Copyright 2013年 Ariadne’s Thread Co., Ltd. All rights reserved.
//


#import "KKZTextField.h"
#import "PasswordFindViewController.h"
#import "RoundCornersButton.h"
#import "UIAlertView+Blocks.h"
#import "UIConstants.h"
#import "UserRequest.h"
#import "ValidcodeRequest.h"

#define kPhoneNumberLimit @"0123456789"
#define kPasswordLimit @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

static const CGFloat kDividerHeight = 1.f;
static const CGFloat kInputHeight = 44.f;
static const NSInteger kPasswordMaxLength = 16;
static const NSInteger kValidcodeMaxLength = 6;

@interface PasswordFindViewController () {

    NSTimer *timer;
    int timeCount;
}

@property (nonatomic, strong) UIScrollView *holder;

@property (nonatomic, strong) UIView *inputHolder;

@property (nonatomic, strong) KKZTextField *phoneNumberField;

@property (nonatomic, strong) KKZTextField *passwordField;

@property (nonatomic, strong) KKZTextField *validcodeField;

@property (nonatomic, strong) RoundCornersButton *queryValidcodeButton;

@property (nonatomic, strong) RoundCornersButton *doneButton;

@end

@implementation PasswordFindViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"找回密码";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.holder];

    [self.holder addSubview:self.inputHolder];

    [self.inputHolder addSubview:[self dividerWithLeft:0 andTop:0]];
    [self.inputHolder addSubview:[self inputHintLabelWithText:@"手机号" andTop:kDividerHeight]];
    [self.inputHolder addSubview:self.phoneNumberField];

    [self.inputHolder addSubview:[self dividerWithLeft:15 andTop:kDividerHeight + kInputHeight]];
    [self.inputHolder addSubview:[self inputHintLabelWithText:@"新密码" andTop:kDividerHeight * 2 + kInputHeight]];
    [self.inputHolder addSubview:self.passwordField];

    [self.inputHolder addSubview:[self dividerWithLeft:15 andTop:(kDividerHeight + kInputHeight) * 2]];
    [self.inputHolder addSubview:[self inputHintLabelWithText:@"验证码" andTop:kDividerHeight * 3 + kInputHeight * 2]];
    [self.inputHolder addSubview:self.validcodeField];
    [self.inputHolder addSubview:self.queryValidcodeButton];
    [self.inputHolder addSubview:[self dividerWithLeft:0 andTop:(kDividerHeight + kInputHeight) * 3]];

    [self.holder addSubview:self.doneButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.phoneNumberField becomeFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Init views
- (UIScrollView *)holder {
    if (!_holder) {
        _holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kCommonScreenWidth, kCommonScreenHeight - 64)];
        _holder.backgroundColor = [UIColor whiteColor];
        _holder.delaysContentTouches = NO;
//        _holder.contentSize = CGSizeMake(0, kCommonScreenHeight - 64);
    }
    return _holder;
}

- (UIView *)inputHolder {
    if (!_inputHolder) {
        CGFloat height = kInputHeight * 3 + kDividerHeight * 4;
        _inputHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 15, kCommonScreenWidth, height)];
        _inputHolder.backgroundColor = [UIColor whiteColor];
    }
    return _inputHolder;
}

- (KKZTextField *)phoneNumberField {
    if (!_phoneNumberField) {
        CGFloat width = kCommonScreenWidth - 70 - 12;

        _phoneNumberField = [[KKZTextField alloc] initWithFrame:CGRectMake(70, kDividerHeight, width, kInputHeight) andFieldType:KKZTextFieldWithClear];
        _phoneNumberField.placeholder = @"注册时使用的手机号";
        _phoneNumberField.font = [UIFont systemFontOfSize:14];
        _phoneNumberField.keyboardType = UIKeyboardTypePhonePad;
        _phoneNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneNumberField.delegate = self;
        _phoneNumberField.returnKeyType = UIReturnKeyNext;
        _phoneNumberField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _phoneNumberField;
}

- (KKZTextField *)passwordField {
    if (!_passwordField) {
        CGFloat top = kDividerHeight * 2 + kInputHeight;
        CGFloat width = kCommonScreenWidth - 70 - 12;

        _passwordField = [[KKZTextField alloc] initWithFrame:CGRectMake(70, top, width, kInputHeight) andFieldType:KKZTextFieldWithClearAndSecret];
        _passwordField.placeholder = @"请输入6-16位字母或数字";
        _passwordField.delegate = self;
        _passwordField.font = [UIFont systemFontOfSize:14];
        _passwordField.secureTextEntry = YES;
        _passwordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _passwordField.keyboardType = UIKeyboardTypeAlphabet;
        _passwordField.returnKeyType = UIReturnKeyNext;
    }
    return _passwordField;
}

- (KKZTextField *)validcodeField {
    if (!_validcodeField) {
        CGFloat top = kDividerHeight * 3 + kInputHeight * 2;
        CGFloat width = kCommonScreenWidth - 70 - 90 - 20;

        _validcodeField = [[KKZTextField alloc] initWithFrame:CGRectMake(70, top, width, kInputHeight) andFieldType:KKZTextFieldWithClear];
        _validcodeField.placeholder = @"短信接收到的数字";
        _validcodeField.font = [UIFont systemFontOfSize:14];
        _validcodeField.keyboardType = UIKeyboardTypePhonePad;
        _validcodeField.clearButtonMode = UITextFieldViewModeNever;
        _validcodeField.delegate = self;
        _validcodeField.returnKeyType = UIReturnKeyDone;
        _validcodeField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return _validcodeField;
}

- (RoundCornersButton *)queryValidcodeButton {
    if (!_queryValidcodeButton) {
        CGFloat left = kCommonScreenWidth - 90 - 15;
        CGFloat top = kDividerHeight * 3 + kInputHeight * 2 + (kInputHeight - 32) / 2;

        _queryValidcodeButton = [[RoundCornersButton alloc] initWithFrame:CGRectMake(left, top, 90, 32)];
        _queryValidcodeButton.backgroundColor = [UIColor clearColor];
        _queryValidcodeButton.rimWidth = 1;
        _queryValidcodeButton.rimColor = [UIColor blueColor];
        _queryValidcodeButton.cornerNum = 4;
        _queryValidcodeButton.titleName = @"免费获取";
        _queryValidcodeButton.titleColor = [UIColor blueColor];
        _queryValidcodeButton.titleFont = [UIFont systemFontOfSize:13];
        [_queryValidcodeButton addTarget:self action:@selector(queryValidcode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _queryValidcodeButton;
}

- (RoundCornersButton *)doneButton {
    if (!_doneButton) {
        CGFloat top = CGRectGetMaxY(self.inputHolder.frame) + 20;

        _doneButton = [[RoundCornersButton alloc] initWithFrame:CGRectMake(0, top, kCommonScreenWidth, 45)];
        _doneButton.backgroundColor = [UIColor blueColor];
        _doneButton.cornerNum = 0;
        _doneButton.titleName = @"确定";
        _doneButton.titleColor = [UIColor whiteColor];
        _doneButton.titleFont = [UIFont systemFontOfSize:15];
        [_doneButton addTarget:self action:@selector(sendFindPassword) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (UIView *)dividerWithLeft:(CGFloat)left andTop:(CGFloat)top {
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, top, kCommonScreenWidth, kDividerHeight)];
    divider.backgroundColor = [UIColor whiteColor];
    return divider;
}

- (UILabel *)inputHintLabelWithText:(NSString *)text andTop:(CGFloat)top {
    UILabel *hint = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 50, 45)];
    hint.text = text;
    hint.textColor = [UIColor grayColor];
    hint.font = [UIFont systemFontOfSize:14];
    return hint;
}

#pragma mark - Override CommonViewController
- (void)cancelViewController {
    if (timer) {
        [timer invalidate];
        [self performSelector:@selector(closeViewController) withObject:nil afterDelay:0.5];
    } else {
        [self closeViewController];
    }
}

- (void)closeViewController {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Network tasks
- (void)queryValidcode {
    NSString *phoneNumber = self.phoneNumberField.text;
    if ([phoneNumber length] != 11 || ![phoneNumber hasPrefix:@"1"]) {
        [[CIASAlertCancleView new] show:@"请输入正确的手机号码" message:nil cancleTitle:@"确定" callback:nil];
        return;
    }
    
    ValidcodeRequest *request = [ValidcodeRequest new];
    [request requestResetPasswordValidcode:phoneNumber success:^{
        self.queryValidcodeButton.enabled = NO;
        [[CIASAlertCancleView new] show:@"验证码已经发出" message:nil cancleTitle:@"确定" callback:nil];
        
        timeCount = 60;
        [timer invalidate];
        timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countdownValidcodeEnable:) userInfo:nil repeats:YES];

    } failure:^(NSError * _Nullable err) {
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
    
}

- (void)sendFindPassword {
    if (self.phoneNumberField.text.length < 11 || ![self.phoneNumberField.text hasPrefix:@"1"]) {
        [[CIASAlertCancleView new] show:@"请输入正确的手机号码" message:nil cancleTitle:@"确定" callback:nil];
        return;
    }
    if (self.passwordField.text.length < 6) {
        [[CIASAlertCancleView new] show:@"密码要求至少6位哦～" message:nil cancleTitle:@"确定" callback:nil];
        return;
    }
    if (self.validcodeField.text.length == 0) {
        [[CIASAlertCancleView new] show:@"请输入验证码" message:nil cancleTitle:@"确定" callback:nil];
        return;
    }

    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    UserRequest *request = [UserRequest new];
    [request resetPassword:self.phoneNumberField.text
            password:self.passwordField.text
            validCode:self.validcodeField.text
            success:^{

                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                [[CIASAlertCancleView new] show:@"密码修改成功" message:nil cancleTitle:@"确定"
                                       callback:^(BOOL confirm) {
                                           [weakSelf cancelViewController];
                                       }];
            }
            failure:^(NSError *_Nullable err) {

                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                [CIASPublicUtility showMyAlertViewForTaskInfo:err];
            }];
}

#pragma mark - timer

- (void)countdownValidcodeEnable:(NSTimer *)time {
    timeCount--;

    if (timeCount <= 0) {
        self.queryValidcodeButton.enabled = YES;
        [self.queryValidcodeButton setNeedsDisplay];
        self.queryValidcodeButton.titleName = @"免费获取";
        [timer invalidate];
        timer = nil;
    } else { // 倒计时显示
        NSString *countDownStr = [NSString stringWithFormat:@"重新获取%ds", timeCount];
        self.queryValidcodeButton.titleName = countDownStr;
        [self.queryValidcodeButton setNeedsDisplay];
    }
}

#pragma mark - Text Field Deleagte
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.phoneNumberField) {
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [self.validcodeField becomeFirstResponder];
    } else {
        if (self.validcodeField.text.length >= 4) {
            [self sendFindPassword];
        } else {
            [self.phoneNumberField becomeFirstResponder];
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField == self.phoneNumberField) {
        NSInteger length = textField.text.length;
        if (length >= 11 && string.length > 0) {
            return NO;
        }

        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kPhoneNumberLimit] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    } else if (textField == self.passwordField) {
        NSInteger length = textField.text.length;
        if (length >= kPasswordMaxLength && string.length > 0) {
            return NO;
        }

        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kPasswordLimit] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    } else if (textField == self.validcodeField) {
        NSInteger length = textField.text.length;
        if (length >= kValidcodeMaxLength && string.length > 0) {
            return NO;
        }
    }

    return YES;
}

@end
