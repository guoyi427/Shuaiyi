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
static const CGFloat kDividerHeight = 1.f;

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
@property (nonatomic, strong) RoundCornersButton *doneButton;

@end

@implementation PasswordChangeViewController

#pragma mark - View lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"修改登录密码";

    [self.view addSubview:self.content];

    [self.content addSubview:self.contentField];

    [self.contentField addSubview:[self dividerWithLeft:0 andTop:0]];
    [self.contentField addSubview:self.oldPasswordField];
    [self.contentField addSubview:[self dividerWithLeft:kPageMargin andTop:(kDividerHeight + kInputHeight)]];
    [self.contentField addSubview:self.newPasswordField];
    [self.contentField addSubview:[self dividerWithLeft:kPageMargin andTop:(kDividerHeight + kInputHeight) * 2]];
    [self.contentField addSubview:self.confirmPasswordField];
    [self.contentField addSubview:[self dividerWithLeft:0 andTop:(kDividerHeight + kInputHeight) * 3]];

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
        _contentField = [[UIView alloc] initWithFrame:CGRectMake(0, 15, screentWith, height)];
        [_contentField setBackgroundColor:[UIColor whiteColor]];
    }
    return _contentField;
}

- (UIView *)dividerWithLeft:(CGFloat)left andTop:(CGFloat)top {
    UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(left, top, screentWith, kDividerHeight)];
    divider.backgroundColor = kDividerColor;
    return divider;
}

- (KKZTextField *)oldPasswordField {
    if (!_oldPasswordField) {
        CGFloat width = screentWith - kPageMargin - 8;
        CGRect frame = CGRectMake(kPageMargin, kDividerHeight, width, kInputHeight);

        _oldPasswordField = [[KKZTextField alloc] initWithFrame:frame
                                                   andFieldType:KKZTextFieldWithClearAndSecret];
        _oldPasswordField.placeholder = @"当前登录密码";
        _oldPasswordField.delegate = self;
        _oldPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _oldPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _oldPasswordField.autocorrectionType = UITextAutocorrectionTypeNo;
        _oldPasswordField.secureTextEntry = NO;
        _oldPasswordField.font = [UIFont systemFontOfSize:14];
        _oldPasswordField.textColor = [UIColor blackColor];
        _oldPasswordField.keyboardType = UIKeyboardTypeDefault;
        _oldPasswordField.returnKeyType = UIReturnKeyNext;
        _oldPasswordField.secureTextEntry = YES;
    }
    return _oldPasswordField;
}

- (KKZTextField *)newPasswordField {
    if (!_newPasswordField) {
        CGFloat top = kDividerHeight * 2 + kInputHeight;
        CGFloat width = screentWith - kPageMargin - 8;
        CGRect frame = CGRectMake(kPageMargin, top, width, kInputHeight);

        _newPasswordField = [[KKZTextField alloc] initWithFrame:frame
                                                   andFieldType:KKZTextFieldWithClearAndSecret];
        _newPasswordField.placeholder = @"新密码（6-16位字母或数字）";
        _newPasswordField.delegate = self;
        _newPasswordField.font = [UIFont systemFontOfSize:14];
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
        CGFloat width = screentWith - kPageMargin - 8;
        CGRect frame = CGRectMake(kPageMargin, top, width, kInputHeight);

        _confirmPasswordField = [[KKZTextField alloc]
                initWithFrame:frame
                 andFieldType:KKZTextFieldWithClearAndSecret];
        _confirmPasswordField.placeholder = @"确认新密码";
        _confirmPasswordField.delegate = self;
        _confirmPasswordField.font = [UIFont systemFontOfSize:14];
        _confirmPasswordField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _confirmPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _confirmPasswordField.autocorrectionType = UITextAutocorrectionTypeNo;
        _confirmPasswordField.keyboardType = UIKeyboardTypeDefault;
        _confirmPasswordField.returnKeyType = UIReturnKeyDone;
        _confirmPasswordField.secureTextEntry = YES;
    }
    return _confirmPasswordField;
}

- (RoundCornersButton *)doneButton {
    if (!_doneButton) {
        CGFloat top = self.contentField.frame.origin.y + self.contentField.frame.size.height + 15;
        _doneButton = [[RoundCornersButton alloc] initWithFrame:CGRectMake(0, top, screentWith, 45)];
        _doneButton.enabled = YES;
        _doneButton.selected = NO;
        _doneButton.cornerNum = 0;
        _doneButton.titleName = @"确定修改";
        _doneButton.titleColor = [UIColor whiteColor];
        _doneButton.titleFont = [UIFont systemFontOfSize:14];
        _doneButton.backgroundColor = appDelegate.kkzBlue;
        [_doneButton addTarget:self action:@selector(changePassword) forControlEvents:UIControlEventTouchUpInside];
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
