//
//  修改登录密码
//
//  Created by da zhang on 11-7-18.
//  Copyright 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "DataEngine.h"
#import "KKZTextField.h"
#import "KKZUtility.h"
#import "NotificationName.h"
#import "PasswordChangeViewController.h"
#import "RoundCornersButton.h"
#import "TaskQueue.h"
#import "UIColor+Hex.h"
#import "UIConstants.h"
#import "UserManager.h"
#import "UserRequest.h"
#import "LoginConstants.h"

static const NSInteger kPasswordMaxLength = 16;
static const NSString *kPasswordLimit = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

static const CGFloat kPageMargin = 15.f;
static const CGFloat kInputHeight = 44.f;
static const CGFloat kDividerHeight = .5f;

@interface PasswordChangeViewController ()

/**
 * 页面内容布局。
 */
@property (nonatomic, strong) UIScrollView *content;

/**
 * 输入框的内容布局。
 */
@property (nonatomic, strong) UIView *contentField;

/**
 * 修改密码是否成功。
 */
@property (nonatomic, assign) BOOL changePassSuccess;

/**
 * 当前登录密码输入框。
 */
@property (nonatomic, strong) KKZTextField *oldPasswordField;

/**
 * 新密码输入框。
 */
@property (nonatomic, strong) KKZTextField *newPasswordField;

/**
 * 确认密码输入框。
 */
@property (nonatomic, strong) KKZTextField *confirmPasswordField;

/**
 * 确定按钮。
 */
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation PasswordChangeViewController

#pragma mark - View lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.kkzTitleLabel.text = @"密码设置";
    
    [self.view addSubview:self.content];
    
    // 添加背景试图
    [self.content addSubview:self.contentField];
    // 添加原始密码
    [self.contentField addSubview:[self createTitleLabel:@"原始密码" andTop:kPageMargin]];
    [self.contentField addSubview:self.oldPasswordField];
    [self.contentField addSubview:[self dividerWithLeft:0 andTop:(kDividerHeight + kInputHeight)]];
    // 添加新密码
    [self.contentField addSubview:[self createTitleLabel:@"新密码" andTop:kPageMargin + kInputHeight]];
    [self.contentField addSubview:[self dividerWithLeft:0 andTop:(kDividerHeight + kInputHeight) * 2]];
    [self.contentField addSubview:self.newPasswordField];
    // 添加验证码
    [self.contentField addSubview:[self createTitleLabel:@"手机令牌" andTop:(kDividerHeight + kInputHeight) * 2 + kPageMargin]];
    [self.contentField addSubview:self.confirmPasswordField];
    // 验证码按钮
    UIButton *getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - kPageMargin - 80, (kDividerHeight + kInputHeight) * 2 + 5, 80, kInputHeight - 10)];
    [getCodeBtn setBackgroundImage:[UIImage imageNamed:@"Login_TextField"] forState:UIControlStateNormal];
    [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentField addSubview:getCodeBtn];
    
    [self.content addSubview:self.doneButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.oldPasswordField becomeFirstResponder];
}

#pragma mark Init views
- (UIScrollView *)content {
    if (!_content) {
        _content = [[UIScrollView alloc]
                    initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
        _content.backgroundColor = HEX(@"#F5F5F5");
        _content.alwaysBounceVertical = YES;
    }
    return _content;
}

- (UIView *)contentField {
    if (!_contentField) {
        CGFloat height = kInputHeight * 3 + kDividerHeight * 4;
        _contentField = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, height)];
        [_contentField setBackgroundColor:[UIColor whiteColor]];
    }
    return _contentField;
}

- (UIView *)dividerWithLeft:(CGFloat)left andTop:(CGFloat)top {
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(left, top, screentWith, kDividerHeight)];
    divider.backgroundColor = kDividerColor;
    return divider;
}

- (UILabel *)createTitleLabel:(NSString *)title andTop:(CGFloat)top {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPageMargin, top, 60, kInputHeight - kPageMargin * 2)];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:13];
    return titleLabel;
}

- (KKZTextField *)oldPasswordField {
    if (!_oldPasswordField) {
        CGFloat width = kPageMargin * 2 + 60;
        CGRect frame = CGRectMake(width, kDividerHeight, screentWith - width, kInputHeight);
        
        _oldPasswordField = [[KKZTextField alloc] initWithFrame:frame
                                                   andFieldType:KKZTextFieldWithClearAndSecret];
        _oldPasswordField.placeholder = @"请输入原始密码";
        _oldPasswordField.delegate = self;
        _oldPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _oldPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _oldPasswordField.autocorrectionType = UITextAutocorrectionTypeNo;
        _oldPasswordField.secureTextEntry = NO;
        _oldPasswordField.font = [UIFont systemFontOfSize:10];
        _oldPasswordField.textColor = [UIColor grayColor];
        _oldPasswordField.keyboardType = UIKeyboardTypeDefault;
        _oldPasswordField.returnKeyType = UIReturnKeyNext;
        _oldPasswordField.secureTextEntry = YES;
    }
    return _oldPasswordField;
}

- (KKZTextField *)newPasswordField {
    if (!_newPasswordField) {
        CGFloat top = kDividerHeight * 2 + kInputHeight;
        CGFloat width =  kPageMargin * 2 + 60;
        CGRect frame = CGRectMake(width, top, screentWith - width, kInputHeight);
        
        _newPasswordField = [[KKZTextField alloc] initWithFrame:frame
                                                   andFieldType:KKZTextFieldWithClearAndSecret];
        _newPasswordField.placeholder = @"请输入新密码";
        _newPasswordField.delegate = self;
        _newPasswordField.font = [UIFont systemFontOfSize:10];
        _newPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _newPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _newPasswordField.autocorrectionType = UITextAutocorrectionTypeNo;
        _newPasswordField.keyboardType = UIKeyboardTypeDefault;
        _newPasswordField.returnKeyType = UIReturnKeyDone;
        _newPasswordField.secureTextEntry = YES;
    }
    return _newPasswordField;
}

- (KKZTextField *)confirmPasswordField {
    if (!_confirmPasswordField) {
        CGFloat top = kDividerHeight * 3 + kInputHeight * 2;
        CGFloat width = kPageMargin * 2 + 60;
        CGRect frame = CGRectMake(width, top, screentWith - width - kPageMargin - 60, kInputHeight);
        
        _confirmPasswordField = [[KKZTextField alloc]
                                 initWithFrame:frame
                                 andFieldType:KKZTextFieldNormal];
        _confirmPasswordField.placeholder = @"";
        _confirmPasswordField.delegate = self;
        _confirmPasswordField.font = [UIFont systemFontOfSize:10];
        _confirmPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _confirmPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _confirmPasswordField.autocorrectionType = UITextAutocorrectionTypeNo;
        _confirmPasswordField.keyboardType = UIKeyboardTypeDefault;
        _confirmPasswordField.returnKeyType = UIReturnKeyDone;
    }
    return _confirmPasswordField;
}

- (UIButton *)doneButton {
    if (!_doneButton) {
        CGFloat top = self.contentField.frame.origin.y + self.contentField.frame.size.height + 15;
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake((screentWith - 45 * 2.26) * 0.5, top, 45 * 2.26, 45)];
        [_doneButton setBackgroundImage:[UIImage imageNamed:@"Login_ValidCode"] forState:UIControlStateNormal];
        [_doneButton setTitle:@"确认修改" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_doneButton addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
        [self.contentField addSubview:_doneButton];
    }
    return _doneButton;
}

#pragma mark - Network tasks
- (void)changePassword {
    if (self.oldPasswordField.text.length == 0) {
        [UIAlertView showAlertView:@"请输入当前登录密码" buttonText:@"确定" buttonTapped:nil];
        return;
    }
    if (self.newPasswordField.text.length == 0) {
        [UIAlertView showAlertView:@"请输入新密码" buttonText:@"确定" buttonTapped:nil];
        return;
    }
    if (self.confirmPasswordField.text.length == 0) {
        [UIAlertView showAlertView:@"请输入确认密码" buttonText:@"确定" buttonTapped:nil];
        return;
    }
    if (self.oldPasswordField.text.length < 6 || self.newPasswordField.text.length < 6) {
        [UIAlertView showAlertView:@"密码至少要6位哦～" buttonText:@"确定" buttonTapped:nil];
        return;
    }
    
    NSString *newPassword = self.newPasswordField.text;
    NSString *confirmPassword = self.confirmPasswordField.text;
    if (![newPassword isEqualToString:confirmPassword]) {
        [UIAlertView showAlertView:@"两次输入的密码不一致" buttonText:@"确定" buttonTapped:nil];
        return;
    }
    
    NSString *oldPassword = self.oldPasswordField.text;
    if ([oldPassword isEqualToString:newPassword]) {
        [UIAlertView showAlertView:@"您"
         @"输入的新密码和当前登录密码一样，请重新输入"
                        buttonText:@"确定"
                      buttonTapped:nil];
        return;
    }
    
    [self dismissKeyBoard]; // 关闭键盘
    
    [KKZUtility showIndicatorWithTitle:@"正在修改密码" atView:self.view];
    
    UserRequest *request = [UserRequest new];
    [request changeOriginalPassword:oldPassword newPassword:newPassword success:^{
        
        __weak typeof(self) weak_self = self;
        [[UserManager shareInstance] login:[DataEngine sharedDataEngine].phoneNum
                                  password:self.newPasswordField.text
                                      site:SiteTypeKKZ
                                   success:^(UserLogin * _Nullable userLogin) {
                                       
                                       weak_self.changePassSuccess = TRUE;
                                       [weak_self showChangePwd];
                                       
                                   } failure:^(NSError * _Nullable err) {
                                       
                                       weak_self.changePassSuccess = FALSE;
                                       [weak_self showChangePwd];
                                       
                                   }];
        
    } failure:^(NSError * _Nullable err) {
        [KKZUtility hidenIndicator];
        [appDelegate showAlertViewForTitle:nil message:[err.userInfo objectForKey:KKZRequestErrorMessageKey] cancelButton:@"知道了"];
    }];
    
}

#pragma mark Handle task result

- (void)showChangePwd {
    [KKZUtility hidenIndicator];
    
    [UIAlertView showAlertView:@"密码修改成功"
                    buttonText:@"确定"
                  buttonTapped:^() {
                      
                      if (self.changePassSuccess) {
                          [self popViewControllerAnimated:YES];
                      } else {
                          [[NSNotificationCenter defaultCenter] postNotificationName:changePasswordSuccessNotification
                                                                              object:nil];
                      }
                  }];
}

#pragma mark - UITextField deleagte
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.oldPasswordField) {
        [self.newPasswordField becomeFirstResponder];
    } else {
        if (self.newPasswordField.text.length >= 6) {
            [self.newPasswordField resignFirstResponder];
        } else {
            [self.oldPasswordField becomeFirstResponder];
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSInteger length = textField.text.length;
    if (length >= kPasswordMaxLength && string.length > 0) {
        return NO;
    }
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:K_PASSWORD_LIMIT] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    return basic;
}

- (void)dismissKeyBoard {
    [self.view endEditing:YES];
}

@end

