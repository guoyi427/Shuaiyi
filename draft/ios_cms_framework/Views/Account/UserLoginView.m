//
//  UserLoginView.m
//  CIASMovie
//
//  Created by avatar on 2017/1/5.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "UserLoginView.h"
#import "KKZTextUtility.h"
#import <WechatOpenSDK/WXApi.h>

#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."
#define  ACCOUNT_MAX_CHARS    16
#define  NICKNAME_MAX_CHARS    20
@interface UserLoginView ()
{
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
}
@end

@implementation UserLoginView

- (id)initWithFrame:(CGRect)frame delegate:(id<UserLoginViewDelegate>)aDelegate {
    if (self = [super initWithFrame:frame]) {
        self.delegate = aDelegate;
        self.backgroundColor = [UIColor clearColor];
        holderView = [[UIScrollView alloc] init];
        bgView = [[UIView alloc] init];
        holderView.delegate = self;
        holderView.backgroundColor = [UIColor clearColor];
        [holderView setShowsVerticalScrollIndicator:YES];
        [holderView setShowsHorizontalScrollIndicator:NO];
        //        [holderView setContentSize:CGSizeMake(kCommonScreenWidth, kCommonScreenHeight*1.2)];
        
        [holderView addSubview:bgView];
        [self addSubview:holderView];
        
        [holderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(holderView);
            make.width.mas_equalTo(holderView);
            make.height.mas_equalTo(kCommonScreenHeight*1.1);
        }];
        
        //MARK: x返回按钮
        UIImage *backImage = [UIImage imageNamed:@"login_close"];
        backBtnOfLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtnOfLogin setImage:backImage forState:UIControlStateNormal];
        [backBtnOfLogin addTarget:self action:@selector(backBtnOfLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:backBtnOfLogin];
        [backBtnOfLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top).offset(30);
            make.right.equalTo(bgView.mas_right).offset(-30);
            make.size.mas_equalTo(CGSizeMake(backImage.size.width, backImage.size.height));
        }];
        
        //MARK: 登录标题
        NSString *loginStr = @"登录";
        CGSize loginStrSize = [KKZTextUtility measureText:@"绑定已有账号" size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:30]];
        titleLabelOfLogin = [[UILabel alloc] init];
        [bgView addSubview:titleLabelOfLogin];
        titleLabelOfLogin.text = loginStr;
        titleLabelOfLogin.font = [UIFont systemFontOfSize:30];
        titleLabelOfLogin.textColor = [UIColor colorWithHex:@"#ffffff"];
        [titleLabelOfLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(bgView.mas_top).offset(110);
            make.size.mas_equalTo(CGSizeMake(loginStrSize.width+5, loginStrSize.height));
        }];
        
        
        //MARK: 注册按钮
        UIImage *registerImage = [UIImage imageNamed:@"login_arrow"];
        NSString *registerStr = @"立即注册";
        CGSize registerStrSize = [KKZTextUtility measureText:registerStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18]];
        registerBtnOfLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        registerBtnOfLogin2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgView addSubview:registerBtnOfLogin];
        [bgView addSubview:registerBtnOfLogin2];
        [registerBtnOfLogin setTitle:registerStr forState:UIControlStateNormal];
        [registerBtnOfLogin setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateNormal];
        registerBtnOfLogin.titleLabel.font = [UIFont systemFontOfSize:18];
        [registerBtnOfLogin2 setImage:registerImage forState:UIControlStateNormal];
        [registerBtnOfLogin addTarget:self action:@selector(registerBtnOfLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        [registerBtnOfLogin2 addTarget:self action:@selector(registerBtnOfLoginClick:) forControlEvents:UIControlEventTouchUpInside];
        [registerBtnOfLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top).offset(115);
            make.right.equalTo(bgView.mas_right).offset(-(5+30+registerImage.size.width));
            make.size.mas_equalTo(CGSizeMake(registerStrSize.width + 5, registerStrSize.height));
        }];
        
        [registerBtnOfLogin2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top).offset(115);
            make.right.equalTo(bgView.mas_right).offset(-30);
            make.size.mas_equalTo(CGSizeMake(registerImage.size.width, registerImage.size.height));
        }];
        
        UIImage *phoneImage = [UIImage imageNamed:@"login_phone"];
        phoneImageViewOfLogin = [[UIImageView alloc] initWithImage:phoneImage];
        phoneImageViewOfLogin.contentMode = UIViewContentModeScaleAspectFill;
        [bgView addSubview:phoneImageViewOfLogin];
        [phoneImageViewOfLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(102);
            make.size.mas_equalTo(CGSizeMake(phoneImage.size.width, phoneImage.size.height));
        }];
        
        NSString *phoneLabelStr = @"手机号码";
        CGSize phoneLabelStrSize = [KKZTextUtility measureText:phoneLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
        phoneLabelOfLogin = [[UILabel alloc] init];
        phoneLabelOfLogin.text = phoneLabelStr;
        phoneLabelOfLogin.font = [UIFont systemFontOfSize:10];
        phoneLabelOfLogin.textColor = [UIColor colorWithHex:@"#cccccc"];
        [bgView addSubview:phoneLabelOfLogin];
        [phoneLabelOfLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(phoneImageViewOfLogin.mas_right).offset(15);
            make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(102);
            make.size.mas_equalTo(CGSizeMake(phoneLabelStrSize.width+5, phoneLabelStrSize.height));
        }];
        
        phoneField = [[UITextField alloc] init];
        NSString *phoneFieldPlaceHolderStr = @"请输入手机号";
        CGSize phoneFieldPlaceHolderStrSize = [KKZTextUtility measureText:phoneFieldPlaceHolderStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
        phoneField.textColor = [UIColor colorWithHex:@"#ffffff"];
        phoneField.font = [UIFont systemFontOfSize:16];
        phoneField.keyboardType = UIKeyboardTypePhonePad;
        phoneField.delegate = self;
        UIColor *phonePlaceholderColor = [UIColor colorWithHex:@"666666"];
        UIFont *phonePlaceholderFont = [UIFont systemFontOfSize:14];
        phoneField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:phoneFieldPlaceHolderStr attributes:@{NSForegroundColorAttributeName:phonePlaceholderColor, NSFontAttributeName:phonePlaceholderFont}];
        [bgView addSubview:phoneField];
        //textField变化时事件
        [phoneField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(phoneImageViewOfLogin.mas_right).offset(15);
            make.top.equalTo(phoneLabelOfLogin.mas_bottom).offset(9);
            make.right.equalTo(bgView.mas_right).offset(-30);
            make.height.equalTo(@(phoneFieldPlaceHolderStrSize.height));
        }];
        
        UIView *line1View = [[UIView alloc] init];
        line1View.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        line1View.alpha = .2;
        [bgView addSubview:line1View];
        [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left);
            make.top.equalTo(phoneImageViewOfLogin.mas_bottom).offset(15);
            make.right.equalTo(bgView.mas_right);
            make.height.equalTo(@(1));
        }];
        
        UIImage *passwordImage = [UIImage imageNamed:@"login_password"];
        passwordImageViewOfLogin = [[UIImageView alloc] initWithImage:passwordImage];
        passwordImageViewOfLogin.contentMode = UIViewContentModeScaleAspectFill;
        [bgView addSubview:passwordImageViewOfLogin];
        [passwordImageViewOfLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(line1View.mas_bottom).offset(45);
            make.size.mas_equalTo(CGSizeMake(passwordImage.size.width, passwordImage.size.height));
        }];
        
        NSString *passwordLabelStr = @"密码";
        CGSize passwordLabelStrSize = [KKZTextUtility measureText:passwordLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
        passwordLabelOfLogin = [[UILabel alloc] init];
        passwordLabelOfLogin.text = passwordLabelStr;
        passwordLabelOfLogin.font = [UIFont systemFontOfSize:10];
        passwordLabelOfLogin.textColor = [UIColor colorWithHex:@"#cccccc"];
        [bgView addSubview:passwordLabelOfLogin];
        [passwordLabelOfLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passwordImageViewOfLogin.mas_right).offset(15);
            make.top.equalTo(line1View.mas_bottom).offset(45);
            make.size.mas_equalTo(CGSizeMake(passwordLabelStrSize.width+10, passwordLabelStrSize.height));
        }];
        
        passwordField = [[UITextField alloc] init];
        NSString *passwordFieldPlaceHolderStr = @"请输入密码";
        CGSize passwordFieldPlaceHolderStrSize = [KKZTextUtility measureText:passwordFieldPlaceHolderStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
        passwordField.textColor = [UIColor colorWithHex:@"#ffffff"];
        passwordField.font = [UIFont systemFontOfSize:16];
        passwordField.secureTextEntry = YES;
        passwordField.delegate = self;
        [passwordField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [self setRightViewWithTextField:passwordField imageName:@"password_view" imageNameOfSelected:@"password_unview"];
        UIColor *passwordFieldPlaceholderColor = [UIColor colorWithHex:@"666666"];
        UIFont *passwordFieldPlaceholderFont = [UIFont systemFontOfSize:14];
        passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:passwordFieldPlaceHolderStr attributes:@{NSForegroundColorAttributeName:passwordFieldPlaceholderColor, NSFontAttributeName:passwordFieldPlaceholderFont}];
        [bgView addSubview:passwordField];
        [passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passwordImageViewOfLogin.mas_right).offset(15);
            make.top.equalTo(passwordLabelOfLogin.mas_bottom).offset(9);
            make.right.equalTo(bgView.mas_right).offset(-30);
            make.height.equalTo(@(passwordFieldPlaceHolderStrSize.height));
        }];
        
        UIView *line2View = [[UIView alloc] init];
        line2View.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        line2View.alpha = .2;
        [bgView addSubview:line2View];
        [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left);
            make.top.equalTo(passwordImageViewOfLogin.mas_bottom).offset(15);
            make.right.equalTo(bgView.mas_right);
            make.height.equalTo(@(1));
        }];
        //  微信登陆
        wechatLoginLabel = [[UILabel alloc] init];
        wechatLoginLabel.text = @"使用第三方\n账号登录";
        wechatLoginLabel.numberOfLines = 2;
        wechatLoginLabel.font = [UIFont systemFontOfSize:10];
        wechatLoginLabel.textColor = [UIColor colorWithHex:@"#999999"];
        [bgView addSubview:wechatLoginLabel];
        [wechatLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@30);
            make.top.equalTo(line2View.mas_bottom).offset(25);
        }];
        
        //  微信登录按钮
        wechatLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [wechatLoginButton setImage:[UIImage imageNamed:@"login_wechat"] forState:UIControlStateNormal];
        [wechatLoginButton addTarget:self action:@selector(wechatLoginButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:wechatLoginButton];
        [wechatLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wechatLoginLabel.mas_right).offset(15);
            make.centerY.equalTo(wechatLoginLabel);
        }];

        NSString *forgetPasswordStr = @"忘记密码";
        CGSize forgetPasswordStrSize = [KKZTextUtility measureText:forgetPasswordStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
        forgetPasswordBtnOfLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetPasswordBtnOfLogin setTitle:forgetPasswordStr forState:UIControlStateNormal];
        forgetPasswordBtnOfLogin.titleLabel.font = [UIFont systemFontOfSize:14];
        [forgetPasswordBtnOfLogin setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateNormal];
        [bgView addSubview:forgetPasswordBtnOfLogin];
        [forgetPasswordBtnOfLogin addTarget:self action:@selector(forgetPasswordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [forgetPasswordBtnOfLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line2View.mas_bottom).offset(30);
            make.right.equalTo(bgView.mas_right).offset(-24);
            make.size.mas_equalTo(CGSizeMake(forgetPasswordStrSize.width+6, forgetPasswordStrSize.height));
        }];
        
        loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        //        [loginBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
        //        loginBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [loginBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateNormal];
        loginBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        loginBtn.layer.cornerRadius = 3.5;
        loginBtn.clipsToBounds = YES;
        [bgView addSubview:loginBtn];
        [loginBtn addTarget:self action:@selector(loginBtnClickOfLoginView:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(forgetPasswordBtnOfLogin.mas_bottom).offset(30);
            make.right.equalTo(bgView.mas_right).offset(-30);
            make.height.equalTo(@(50));
        }];
        
        self.wrongTipsView = [[UIView alloc] init];
        self.wrongTipsView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        self.wrongTipsView.hidden = YES;
        [bgView addSubview:self.wrongTipsView];
        [self.wrongTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(bgView);
            make.bottom.equalTo(self);
            make.height.equalTo(@(50));
        }];
        NSString *strOfTips = @"错误 输入的账号密码错误,请尝试重新输入或点击忘记密码";
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:strOfTips];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithHex:@"#ff6600"]
                              range:NSMakeRange(0, 2)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
                              value:[UIColor colorWithHex:@"#333333"]
                              range:NSMakeRange(3, 22)];
        UILabel *tipsLabel = [[UILabel alloc] init];
        [self.wrongTipsView addSubview:tipsLabel];
        tipsLabel.font = [UIFont systemFontOfSize:13];
        tipsLabel.attributedText = AttributedStr;
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.wrongTipsView);
        }];
        
        [holderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bgView.mas_bottom).offset(80).priorityLow();
            make.bottom.mas_greaterThanOrEqualTo(self);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        tap.cancelsTouchesInView = NO;
        [bgView addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthSuccessNotification:) name:@"UserAuthSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthFailureNotification:) name:@"UserAuthFail" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userAuthCancelNotification:) name:@"UserAuthCancel" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  给UITextField设置右侧的图片
 *
 *  @param textField UITextField
 *  @param imageName 图片名称
 */
-(void)setRightViewWithTextField:(UITextField *)textField imageName:(NSString *)imageName imageNameOfSelected:(NSString *)imageNameOfSelected{
    
    UIButton *rightBtnOfTextField = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtnOfTextField setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightBtnOfTextField setImage:[UIImage imageNamed:imageNameOfSelected] forState:UIControlStateSelected];
    [rightBtnOfTextField addTarget:self action:@selector(rightBtnOfTextFieldClick:) forControlEvents:UIControlEventTouchUpInside];
    rightBtnOfTextField.selected = YES;
    rightBtnOfTextField.frame = CGRectMake(0, 0, 20, 20);
    rightBtnOfTextField.contentMode = UIViewContentModeCenter;
    textField.rightView = rightBtnOfTextField;
    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    
}

#pragma mark - Button Action

- (void) rightBtnOfTextFieldClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        passwordField.secureTextEntry = YES;
    } else {
        passwordField.secureTextEntry = NO;
    }
}

- (void) backBtnOfLoginClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClickOfLoginView)]) {
        [self.delegate backBtnClickOfLoginView];
    }
}

- (void) registerBtnOfLoginClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(userRegisterButtonClick)]) {
        [self.delegate userRegisterButtonClick];
    }
}

- (void) forgetPasswordBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(forgetPasswordButtonClick)]) {
        [self.delegate forgetPasswordButtonClick];
    }
}

- (void) loginBtnClickOfLoginView:(id)sender {
    if (phoneField.text.length != 13 || ![phoneField.text hasPrefix:@"1"]) {
        //        [[CIASAlertCancleView new] show:@"请填写正确的手机号码" message:@"如果号码不正确，您将无法登录" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
        //        }];
        return;
    }
    if ([passwordField.text length] < 6) {
        [[CIASAlertCancleView new] show:@"" message:@"密码要求至少6位" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
        }];
        return;
    }
    
    NSString *phoneNumber = [phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (_wechatState) {
        //  微信绑定 并 登录
        if (self.delegate && [self.delegate respondsToSelector:@selector(wechatBindAndLoginWithAccount:password:)]) {
            [self.delegate wechatBindAndLoginWithAccount:phoneNumber password:passwordField.text];
        }
    } else {
        //  普通登录
        if (self.delegate && [self.delegate respondsToSelector:@selector(userLoginButtonClickWithAccount:password:isFromRegister:)]) {
            [self.delegate userLoginButtonClickWithAccount:phoneNumber password:passwordField.text isFromRegister:NO];
        }
    }
    
}

/**
 微信登录按钮
 */
- (void)wechatLoginButtonAction {
    if ([WXApi isWXAppInstalled] || [WXApi isWXAppSupportApi]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"hengdian";
        [WXApi sendReq:req];

    }else{
        [[CIASAlertCancleView new] show:@"" message:@"未按照微信客户端或版本不支持" cancleTitle:@"知道了" callback:^(BOOL confirm) {
        }];
    }
    DLog(@"微信登录按钮");
}


#pragma mark - UITapGestureRecognizer
- (void)singleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    if (!CGRectContainsPoint(phoneField.frame, point)
        && !CGRectContainsPoint(passwordField.frame, point)
        ) {
        [phoneField resignFirstResponder];
        [passwordField resignFirstResponder];
        [UIView animateWithDuration:.2
                         animations:^{
                             [titleLabelOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.top.equalTo(bgView.mas_top).offset(110);
                             }];
                             [registerBtnOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.top.equalTo(bgView.mas_top).offset(115);
                             }];
                             
                             [registerBtnOfLogin2 mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.top.equalTo(bgView.mas_top).offset(115);
                             }];
                             [phoneImageViewOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(102);
                             }];
                             [phoneLabelOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(102);
                             }];
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

#pragma mark scrollview delegate
// 滑动到顶部时调用该方法
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
}

// scrollView 已经滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
}

// scrollView 开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

// scrollView 结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

// scrollView 开始减速（以下两个方法注意与以上两个方法加以区别）
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
}

// scrollview 减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    DLog(@"scrollViewDidEndDecelerating");
}
#pragma mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    if (textField == phoneField) {
        [passwordField becomeFirstResponder];
    }
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.wrongTipsView.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"blurEffectViewBackgroundColor" object:@YES];
}

- (void)textFieldEditingChanged:(UITextField *)textField {
    
    //  手机号长度==13 并且 密码>=6 显示黄色
    if (passwordField.text.length >= 6 && phoneField.text.length == 13) {
        //  正常
        [loginBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
        loginBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    } else {
        [loginBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateNormal];
        loginBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    }
    
    if (textField == phoneField) {
        //限制手机账号长度（有两个空格）
        if (textField.text.length == 13) {
            DLog(@"%@", textField.text);
            if ([self isValidPhone:[textField.text stringByReplacingOccurrencesOfString:@" " withString:@""]]) {
                if (!textField.rightView) {
                    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
                    rightImageView.image = [UIImage imageNamed:@"login_right"];
                    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
                    textField.rightView = rightImageView;
                    textField.rightViewMode = UITextFieldViewModeAlways;
                }
                
            } else {
                if (textField.rightView) {
                    textField.rightView = nil;
                }
            }
        } else {
            if (textField.rightView) {
                textField.rightView = nil;
            }
        }
        if (textField.text.length > 13) {
            textField.text = [textField.text substringToIndex:13];
        }
        
        NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
        
        NSString *currentStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *preStr = [previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        DLog(@"currentStr :%@\n preStr:%@", currentStr, preStr);
        //正在执行删除操作时为0，否则为1
        char editFlag = 0;
        if (currentStr.length <= preStr.length) {
            editFlag = 0;
        }
        else {
            editFlag = 1;
        }
        DLog(@"ADD ? delete:%d", editFlag);
        
        NSMutableString *tempStr = [NSMutableString new];
        
        int spaceCount = 0;
        if (currentStr.length < 3 && currentStr.length > -1) {
            spaceCount = 0;
        }else if (currentStr.length < 7 && currentStr.length > 2) {
            spaceCount = 1;
        }else if (currentStr.length < 12 && currentStr.length > 6) {
            spaceCount = 2;
        }
        DLog(@"spaceCount %d", spaceCount);
        
        for (int i = 0; i < spaceCount; i++) {
            if (i == 0) {
                [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 3)], @" "];
            }else if (i == 1) {
                [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(3, 4)], @" "];
            }else if (i == 2) {
                [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
            }
        }
        DLog(@"tempStr: %@", tempStr);
        
        if (currentStr.length == 11) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
        }
        DLog(@"tempStr: %@", tempStr);
        
        if (currentStr.length < 4) {
            [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
        }else if(currentStr.length > 3 && currentStr.length <12) {
            NSString *str = [currentStr substringFromIndex:3];
            [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
            if (currentStr.length == 11) {
                [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
            }
        }
        DLog(@"tempStr: %@", tempStr);
        
        textField.text = tempStr;
        // 当前光标的偏移位置
        NSUInteger curTargetCursorPosition = targetCursorPosition;
        
        if (editFlag == 0) {
            //删除
            if (targetCursorPosition == 9 || targetCursorPosition == 4) {
                curTargetCursorPosition = targetCursorPosition - 1;
            }
        }else {
            //添加
            if (currentStr.length == 8 || currentStr.length == 4) {
                curTargetCursorPosition = targetCursorPosition + 1;
            }
        }
        UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:curTargetCursorPosition];
        [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //kNumbers
    self.wrongTipsView.hidden = YES;
    
    if (textField == phoneField) {
        
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        
        int length = (int)textField.text.length;
        
        if (length >= 13 && string.length > 0) {
            
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
        
    }
    
    if (textField == passwordField) {
        int length = (int)textField.text.length;
        if (length >= ACCOUNT_MAX_CHARS  &&  string.length >0)
        {
            return  NO;
        }
        
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == phoneField) {
        if (!Constants.isIphone5) {
            [UIView animateWithDuration:.2
                             animations:^{
                                 [titleLabelOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.top.equalTo(bgView.mas_top).offset(85);
                                 }];
                                 [registerBtnOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.top.equalTo(bgView.mas_top).offset(90);
                                 }];
                                 
                                 [registerBtnOfLogin2 mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.top.equalTo(bgView.mas_top).offset(90);
                                 }];
                                 [phoneImageViewOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(20);
                                 }];
                                 [phoneLabelOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(20);
                                 }];
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        } else {
            [titleLabelOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(85);
            }];
            [registerBtnOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(90);
            }];
            
            [registerBtnOfLogin2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(90);
            }];
            [phoneImageViewOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(50);
            }];
            [phoneLabelOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(50);
            }];
        }
        
    }
    
    if (textField == passwordField) {
        if (!Constants.isIphone5) {
            [UIView animateWithDuration:.2
                             animations:^{
                                 [titleLabelOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.top.equalTo(bgView.mas_top).offset(85);
                                 }];
                                 [registerBtnOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.top.equalTo(bgView.mas_top).offset(90);
                                 }];
                                 
                                 [registerBtnOfLogin2 mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.top.equalTo(bgView.mas_top).offset(90);
                                 }];
                                 [phoneImageViewOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(20);
                                 }];
                                 [phoneLabelOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(20);
                                 }];
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        } else {
            [titleLabelOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(85);
            }];
            [registerBtnOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(90);
            }];
            
            [registerBtnOfLogin2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(90);
            }];
            [phoneImageViewOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(50);
            }];
            [phoneLabelOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(50);
            }];
        }
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == passwordField || textField == phoneField) {
        if ((passwordField.text.length == 0)||(phoneField.text.length == 11)) {
            
        } else {
            [titleLabelOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(110);
            }];
            [registerBtnOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(115);
            }];
            
            [registerBtnOfLogin2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(bgView.mas_top).offset(115);
            }];
            [phoneImageViewOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(102);
            }];
            [phoneLabelOfLogin mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabelOfLogin.mas_bottom).offset(102);
            }];
        }
        
    }
    
    
    return YES;
}

-(BOOL) isValidPhone:(NSString *)phoneNumStr
{
    NSString *phone = phoneNumStr;
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,183,184,147,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|47|83|84|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,176,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|76|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153，177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        if([regextestcm evaluateWithObject:phone] == YES) {
            DLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:phone] == YES) {
            DLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:phone] == YES) {
            DLog(@"China Unicom");
        } else {
            DLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark - Notification Center - Action
// 微信登录  通知回调
- (void)userAuthSuccessNotification:(NSNotification *)notifi {
    NSString *code = notifi.userInfo[@"code"];
    NSLog(@"wechat login success! code = %@", code);
    if (self.delegate && [self.delegate respondsToSelector:@selector(wxLoginWithCode:)] && code && code.length) {
        [self.delegate wxLoginWithCode:code];
    }
}

- (void)userAuthFailureNotification:(NSNotification *)notifi {
    NSLog(@"wechat login failure");
}

- (void)userAuthCancelNotification:(NSNotification *)notifi {
    NSLog(@"wechat login user cancel");
}

#pragma mark - Publich - Methods

- (void)beginEdit {
    [phoneField becomeFirstResponder];
}

- (void)endEdit {
    [phoneField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (void)updateStateToBind:(BOOL)isWechatBind{
    self.wechatState = isWechatBind;
    if (isWechatBind) {
        titleLabelOfLogin.text = @"已有账号";
        wechatLoginLabel.hidden = YES;
        wechatLoginButton.hidden = YES;
        forgetPasswordBtnOfLogin.hidden = YES;
    }else{
        titleLabelOfLogin.text = @"登录";

        wechatLoginLabel.hidden = NO;
        wechatLoginButton.hidden = NO;
        forgetPasswordBtnOfLogin.hidden = NO;
    }
}

@end
