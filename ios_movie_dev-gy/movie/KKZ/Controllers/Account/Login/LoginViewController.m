//
//  登录页面
//
//  Created by 艾广华 on 15/11/5.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "LoginViewController.h"

#import "UIColor+Hex.h"

#import "CacheEngine.h"
#import "ThirdPartLoginEngine.h"
#import "KKZUtility.h"
#import "UserManager.h"
#import "RoundCornersButton.h"
#import "KKZTextField.h"
#import "LoginConstants.h"
#import "ValidcodeRequest.h"
#import "UIViewController+HideKeyboard.h"
#import "RegisterValidCodeViewController.h"
#import "PasswordFindViewController.h"

#define kInputLineNormal HEX(@"#DDDDDD")
#define kInputLineFocused HEX(@"#008cff")
#define kInputTextNormal [UIColor whiteColor]
#define kInputTextFocused HEX(@"#008cff")
#define kLoginEnabled HEX(@"#008cff")
#define kLoginDisabled HEX(@"#99d1ff")
#define kValidcodeEnabled HEX(@"#008cff")
#define kValidcodeDisabled HEX(@"#d3d3d3")
#define kVoiceValidcodeEnabled HEX(@"#999999")
#define kVoiceValidcodeDisabled HEX(@"#D3D3D3")

/****************登录页面顶部logo********************/
static const CGFloat loginLogoViewTop = 52.0f;

/****************登录页面输入框背景********************/
static const CGFloat inputContentTop = 28.0f;
static const CGFloat inputContentLeft = 15.0f;
static const CGFloat inputContentHeight = 121;

/****************登录页面输入框文字********************/
static const CGFloat mobileTitleWidth = 50.0f;
static const CGFloat mobileTitleHeight = 44.0f;

/****************登录页面手机号输入框********************/
static const CGFloat mobileFieldLeft = 8.0f;

/****************登录页面手机号下分割线********************/
static const CGFloat mobileLineHeight = 1.0f;

/****************登录页面登录按钮********************/
static const CGFloat loginBtnTop = 20.0f;
static const CGFloat loginBtnLeft = 15.0f;
static const CGFloat loginBtnRight = 15.0f;
static const CGFloat loginBtnHeight = 44.0f;
static const CGFloat weixinBtnBottom = 100.0f;

/****************关闭按钮********************/
static const CGFloat closeButtonInsets = 15.0f;

typedef enum : NSUInteger {
    wechatLoginTag = 2000,
    qqLoginTag,
    weiboLoginTag,
    closeButtonTag,
    loginButtonTag,
    validcodeButtonTag,
    voiceButtonTag,
} loginMainButtonClickTag;

@interface LoginViewController () <UITextFieldDelegate, LoginViewControllerDelegate, KKZTextFieldDelegate, UIScrollViewDelegate, KKZKeyboardTopViewDelegate> {

    //第三方登录引擎
    ThirdPartLoginEngine *thirdEngine;

    //是否正在执行pop动画
    BOOL _isPoping;
    
    BOOL isQueriedSMSValidcode;
    
    BOOL isKeyboardShown;
    
    NSTimer *timer;
    int timeCount;
    
    UIButton *_registerButton;
    UIButton *_forgetPassword;
    
    UIButton *_sendValidCodeButton;
}

//滚动条
@property (nonatomic, strong) UIScrollView *contentView;

//关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

//Logo
@property (nonatomic, strong) UIImageView *logoImageView;

//输入框视图
@property (nonatomic, strong) UIView *inputContent;

//手机号输入框的提示标题
//@property (nonatomic, strong) UIImageView *mobileTitle;

//手机号输入框
@property (nonatomic, strong) KKZTextField *mobileInputField;

//手机号输入框分割线
@property (nonatomic, strong) UIView *mobileBottomLine;

//获取验证码
@property (nonatomic, strong) RoundCornersButton *queryValidcodeButton;

//验证码输入的提示信息
//@property (nonatomic, strong) UIImageView *validcodeTitle;

//验证码输入框
@property (nonatomic, strong) KKZTextField *validcodeInputField;

//验证码输入框分割线
@property (nonatomic, strong) UIView *validcodeBottomLine;

//登录按钮
@property (nonatomic, strong) UIButton *loginBtn;

//获取语音验证码按钮
@property (nonatomic, strong) UIButton *voiceValidcodeBtn;

//微信登录按钮
@property (nonatomic, strong) UIButton *wechatLoginBtn;

//QQ登录按钮
@property (nonatomic, strong) UIButton *qqLoginBtn;

//新浪微博登录按钮
@property (nonatomic, strong) UIButton *sinaLoginBtn;

//是否点击了登录按钮
@property (nonatomic, assign) BOOL isClickedLogin;

@end

@implementation LoginViewController

/**
 *  视图将要消失的时候
 *
 *  @param animated
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self resignFirstResponders];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self setStatusBarDefaultStyle];
}

/**
 *  视图加载完成
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:true];
    self.view.backgroundColor = [UIColor blackColor];
    
    //加载主页面
    [self loadContentViews];

    //初始化第三方登录类
    thirdEngine = [[ThirdPartLoginEngine alloc] init];

    [self registerKeyboardNotifications];
}

- (void)dealloc {
    [self removeKeyboardNotifications];
}

/**
 * 加载页面
 */
- (void)loadContentViews {
    
    //滚动条视图
    [self.view addSubview:self.contentView];
    
    //关闭按钮
    [self.contentView addSubview:self.closeButton];
    
    //logo
    [self.contentView addSubview:self.logoImageView];
    
    //输入框内容
    [self.contentView addSubview:self.inputContent];
    
    //  background view
    UIImageView *mobileBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_TextField"]];
    [self.inputContent addSubview:mobileBgView];
    [mobileBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.inputContent);
        make.height.mas_equalTo(111/2.0);
    }];
    
    UIImageView *mobileIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_Mobile"]];
    [mobileBgView addSubview:mobileIcon];
    [mobileIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(23.5);
        make.centerY.equalTo(mobileBgView);
    }];
    
    //手机输入框
    [self.inputContent addSubview:self.mobileInputField];
    [self.mobileInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(mobileIcon.mas_right).offset(10);
        make.centerY.equalTo(mobileBgView);
        make.right.equalTo(mobileBgView).offset(-20);
        make.height.mas_equalTo(44);
    }];
    
    //  background view
    UIImageView *validBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_TextField"]];
    validBgView.userInteractionEnabled = true;
    [self.inputContent addSubview:validBgView];
    [validBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.inputContent);
        make.height.mas_equalTo(111/2.0);
    }];
    
    UIImageView *validIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_Password"]];
    [validBgView addSubview:validIcon];
    [validIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(21.5);
        make.centerY.equalTo(validBgView);
    }];
    
    //验证码输入框
    [self.inputContent addSubview:self.validcodeInputField];
    [self.validcodeInputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(validIcon.mas_right).offset(10);
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
    
    //登录按钮
    [self.contentView addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(validBgView);
        make.top.equalTo(validBgView.mas_bottom).offset(10);
    }];
    
//    CGFloat Padding = 30.0f;
    
    /*
    //  注册
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake(Padding, CGRectGetMaxY(self.loginBtn.frame) + 20, 100, 30);
    [_registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_registerButton addTarget:self action:@selector(registerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_registerButton];
    
    //  忘记密码
    _forgetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetPassword.frame = CGRectMake(kCommonScreenWidth - Padding - 80, CGRectGetMinY(_registerButton.frame), 80, CGRectGetHeight(_registerButton.frame));
    [_forgetPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPassword setTitleColor:appDelegate.kkzPink forState:UIControlStateNormal];
    _forgetPassword.titleLabel.font = _registerButton.titleLabel.font;
    [_forgetPassword addTarget:self action:@selector(forgetPasswordButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_forgetPassword];
    */
    
    //获取语音验证码按钮
//    [self.contentView addSubview:self.voiceValidcodeBtn];
    
    //QQ登录按钮
    [self.contentView addSubview:self.qqLoginBtn];
    
    //微信登录按钮
    [self.contentView addSubview:self.wechatLoginBtn];
    
    //新浪微博登录按钮
//    [self.contentView addSubview:self.sinaLoginBtn];

    //如果微信没有安装
    if (![ThirdPartLoginEngine isWeixinInstall] // !THIRD_LOGIN
        ) {
        self.wechatLoginBtn.hidden = YES;

        CGFloat distance = (CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(self.qqLoginBtn.frame) - CGRectGetWidth(self.wechatLoginBtn.frame)) / 3;

        CGRect qqFrame = self.qqLoginBtn.frame;
        qqFrame.origin.x = distance;
        self.qqLoginBtn.frame = qqFrame;

        CGRect weiboFrame = self.sinaLoginBtn.frame;
        weiboFrame.origin.x = distance * 2 + CGRectGetWidth(qqFrame);
        self.sinaLoginBtn.frame = weiboFrame;
    }

    //设置滚动条的内容尺寸
    self.contentView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.contentView.frame) + 5);
}

#pragma mark - Init views
- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.delegate = self;
    }
    return _contentView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        UIImage *closeImg = [UIImage imageNamed:@"ic_login_close"];
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, 18, closeImg.size.width + closeButtonInsets * 2, closeImg.size.height + closeButtonInsets * 2);
        _closeButton.backgroundColor = [UIColor clearColor];
        [_closeButton setImage:closeImg forState:UIControlStateNormal];
        [_closeButton setImageEdgeInsets:UIEdgeInsetsMake(closeButtonInsets, closeButtonInsets, closeButtonInsets, closeButtonInsets)];
        _closeButton.tag = closeButtonTag;
        [_closeButton addTarget:self
                         action:@selector(loginMainBtnClick:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        UIImage *loginLogoImg = [UIImage imageNamed:@"Login-icon"];
        
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - loginLogoImg.size.width) * 0.5f, loginLogoViewTop, loginLogoImg.size.width, loginLogoImg.size.height)];
        [_logoImageView setBackgroundColor:[UIColor clearColor]];
        _logoImageView.layer.cornerRadius = loginLogoImg.size.width * 0.5f;
        _logoImageView.clipsToBounds = YES;
        _logoImageView.image = loginLogoImg;
        _logoImageView.userInteractionEnabled = YES;
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _logoImageView;
}

- (UIView *)inputContent {
    if (!_inputContent) {
        _inputContent = [[UIView alloc] initWithFrame:CGRectMake(inputContentLeft, CGRectGetMaxY(self.logoImageView.frame) + inputContentTop, screentWith - inputContentLeft * 2, inputContentHeight)];
        _inputContent.backgroundColor = [UIColor clearColor];
    }
    return _inputContent;
}

- (KKZTextField *)mobileInputField {
    if (!_mobileInputField) {
        CGFloat mobileOriginX = 50 + mobileFieldLeft;
        
        _mobileInputField = [[KKZTextField alloc] initWithFrame:CGRectMake(mobileOriginX, 0, CGRectGetWidth(self.inputContent.frame) - mobileOriginX - 8, mobileTitleHeight) andFieldType:KKZTextFieldWithClear];
        _mobileInputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _mobileInputField.font = [UIFont systemFontOfSize:kText45PX];
        _mobileInputField.backgroundColor = [UIColor clearColor];
        [_mobileInputField setValue:HEX(@"#D3D3D3") forKeyPath:@"_placeholderLabel.textColor"];
        NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"请输入手机号"
                                                                          attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
        _mobileInputField.attributedPlaceholder = placeholder;
        _mobileInputField.clearImage = [UIImage imageNamed:@"ic_login_clear_input"];
        _mobileInputField.textColor = kInputTextNormal;
        _mobileInputField.delegate = self;
        _mobileInputField.kkzDelegate = self;
        _mobileInputField.keyboardDelegate = self;
        _mobileInputField.keyboardType = UIKeyboardTypePhonePad;
        _mobileInputField.returnKeyType = UIReturnKeyNext;
        if (LOGIN_MOBILE_INPUT) {
            _mobileInputField.text = LOGIN_MOBILE_INPUT;
            [self checkValidcodeButtonEnable];
        }
        [_mobileInputField addTarget:self
                              action:@selector(mobileTextFieldChanged)
                    forControlEvents:UIControlEventEditingChanged];
    }
    return _mobileInputField;
}

- (RoundCornersButton *)queryValidcodeButton {
    if (!_queryValidcodeButton) {
        _queryValidcodeButton = [[RoundCornersButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.inputContent.frame) - 96, (mobileTitleHeight - 30) / 2.f + mobileTitleHeight, 96, 30)];
        _queryValidcodeButton.tag = validcodeButtonTag;
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

- (UIView *)mobileBottomLine {
    if (!_mobileBottomLine) {
        _mobileBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, mobileTitleHeight + mobileLineHeight, screentWith - 2 * inputContentLeft, mobileLineHeight)];
        _mobileBottomLine.backgroundColor = kInputLineNormal;
    }
    return _mobileBottomLine;
}

- (KKZTextField *)validcodeInputField {
    if (!_validcodeInputField) {
        CGFloat passOriginX = 50 + mobileFieldLeft;
        _validcodeInputField = [[KKZTextField alloc] initWithFrame:CGRectMake(passOriginX, CGRectGetMaxY(self.mobileBottomLine.frame), CGRectGetWidth(_mobileInputField.frame), mobileTitleHeight)
                                                      andFieldType:KKZTextFieldWithClear];
        _validcodeInputField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _validcodeInputField.font = [UIFont systemFontOfSize:kText45PX];
        _validcodeInputField.backgroundColor = [UIColor clearColor];
        [_validcodeInputField setValue:HEX(@"#d3d3d3") forKeyPath:@"_placeholderLabel.textColor"];
        NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"请输入验证码"
                                                                          attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
        _validcodeInputField.attributedPlaceholder = placeholder;
        _validcodeInputField.clearImage = [UIImage imageNamed:@"ic_login_clear_input"];
        _validcodeInputField.textColor = kInputTextNormal;
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

- (UIView *)validcodeBottomLine {
    if (!_validcodeBottomLine) {
        _validcodeBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, inputContentHeight - mobileLineHeight, screentWith - 2 * inputContentLeft, mobileLineHeight)];
        _validcodeBottomLine.backgroundColor = kInputLineNormal;
    }
    return _validcodeBottomLine;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:0];
        _loginBtn.frame = CGRectMake(loginBtnLeft, CGRectGetMaxY(self.inputContent.frame) + loginBtnTop, screentWith - loginBtnLeft - loginBtnRight, loginBtnHeight);
//        _loginBtn.backgroundColor = kLoginDisabled;
        _loginBtn.tag = loginButtonTag;
        _loginBtn.layer.cornerRadius = 3;
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.enabled = NO;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:kText51PX]];
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"Login_Button"] forState:UIControlStateNormal];
        [_loginBtn addTarget:self
                      action:@selector(loginMainBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)voiceValidcodeBtn {
    if (!_voiceValidcodeBtn) {
        _voiceValidcodeBtn = [UIButton buttonWithType:0];
        _voiceValidcodeBtn.frame = CGRectMake((screentWith - 200) * 0.5f, CGRectGetMaxY(self.loginBtn.frame) + 13, 200, 44);
        _voiceValidcodeBtn.backgroundColor = [UIColor clearColor];
        _voiceValidcodeBtn.tag = voiceButtonTag;
        [_voiceValidcodeBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:kText36PX]];
        [_voiceValidcodeBtn setAttributedTitle:[self setupVoiceValidcodeBtnTitle:NO]
                                      forState:UIControlStateNormal];
        [_voiceValidcodeBtn addTarget:self
                               action:@selector(loginMainBtnClick:)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceValidcodeBtn;
}

- (NSMutableAttributedString *)setupVoiceValidcodeBtnTitle:(BOOL)enabled {
    UIColor *fontColor = enabled ? kVoiceValidcodeEnabled : kVoiceValidcodeDisabled;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"收不到短信，试试语音验证码"];
    NSRange strRange = {0, [str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:fontColor range:strRange];
    return str;
}

- (UIButton *)wechatLoginBtn {
    if (!_wechatLoginBtn) {
        UIImage *image = [UIImage imageNamed:@"Login_Wechat"];
        
        _wechatLoginBtn = [UIButton buttonWithType:0];
        _wechatLoginBtn.frame = CGRectMake((screentWith - image.size.width) / 2.0f,
                                           screentHeight - image.size.height - weixinBtnBottom,
                                           image.size.width, image.size.height);
        _wechatLoginBtn.tag = wechatLoginTag;
        [_wechatLoginBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_wechatLoginBtn addTarget:self
                            action:@selector(loginMainBtnClick:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatLoginBtn;
}

- (UIButton *)qqLoginBtn {
    if (!_qqLoginBtn) {
        UIImage *image = [UIImage imageNamed:@"Login_QQ"];
        
        _qqLoginBtn = [UIButton buttonWithType:0];
        _qqLoginBtn.frame = CGRectMake(CGRectGetMinX(self.wechatLoginBtn.frame) - 65.0f - image.size.width, CGRectGetMinY(self.wechatLoginBtn.frame), image.size.width, image.size.height);
        _qqLoginBtn.tag = qqLoginTag;
        [_qqLoginBtn setImage:image forState:UIControlStateNormal];
        [_qqLoginBtn addTarget:self
                        action:@selector(loginMainBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqLoginBtn;
}

- (UIButton *)sinaLoginBtn {
    if (!_sinaLoginBtn) {
        UIImage *image = [UIImage imageNamed:@"ic_login_weibo"];
        
        _sinaLoginBtn = [UIButton buttonWithType:0];
        _sinaLoginBtn.frame = CGRectMake(CGRectGetMaxX(self.wechatLoginBtn.frame) + 65.f, CGRectGetMinY(self.wechatLoginBtn.frame), image.size.width, image.size.height);
        _sinaLoginBtn.tag = weiboLoginTag;
        [_sinaLoginBtn setImage:image forState:UIControlStateNormal];
        [_sinaLoginBtn addTarget:self
                          action:@selector(loginMainBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _sinaLoginBtn;
}

- (void)registerButtonAction {
    RegisterValidCodeViewController *vc = [[RegisterValidCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

- (void)forgetPasswordButtonAction {
    PasswordFindViewController *vc = [[PasswordFindViewController alloc] init];
    [self.navigationController pushViewController:vc animated:true];
}

/**
 *  按钮点击事件
 *
 *  @param sender
 */
- (void)loginMainBtnClick:(UIButton *)sender {

    //设置请求类型
    SiteType requestType;
    if (sender.tag == qqLoginTag) {
        requestType = SiteTypeQQ;
    }
    else if (sender.tag == wechatLoginTag) {
        requestType = SiteTypeWX;
    }
    else if (sender.tag == weiboLoginTag) {
        requestType = SiteTypeSina;
    }

    switch (sender.tag) {
        case validcodeButtonTag: //获取短信验证码
            [self queryValidcodeWithType:SMSValidcode];
            break;
            
        case voiceButtonTag: //获取语音验证码
            [self queryValidcodeWithType:VoiceValidcode];
            break;
            
        case closeButtonTag: {

            //防止用户连续点击两个关闭按钮方法
            if (self.isClickedLogin) {
                return;
            }

            //调用代理对象实现关闭页面方法
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(loginControllerLoginCancelled)]) {
                    [self.delegate loginControllerLoginCancelled];
                }
            }];
            break;
        }
        
        case qqLoginTag:
        case wechatLoginTag:
        case weiboLoginTag: {

            //先判断网络连接再清空缓存数据
            if (![self isNetworkConnected]) {
                return;
            }

            //如果用户未点击第三方登录按钮
            if (!self.isClickedLogin) {
                self.isClickedLogin = YES;
            }

            //取消键盘
            [self dismissKeyBoard];

            __weak typeof(self) weak_self = self;
            [thirdEngine startThirdPartLog:requestType
                            showDialogView:self.view
                                    result:^(BOOL result) {
                                        
                                        if (result) {
                                            //第三方登录请求
                                            [weak_self handleLoginSucceed];
                                        } else {
                                            [UIAlertView showAlertView:@"登录失败" buttonText:@"确定"];
                                        }
                                        weak_self.isClickedLogin = NO;
                                    }];
            break;
        }

        case loginButtonTag: {

            //用户点击登录按钮操作
            [self kkzLogin];
            break;
        }

        default:
            break;
    }
}

#pragma mark - Network
- (void)queryValidcodeWithType:(ValidcodeType)type {
    if (![self isNetworkConnected]) {
        return;
    }
    
    if (![self checkValidcodeButtonEnable]) {
        return;
    }
    
    //显示加载框
    [KKZUtility showIndicatorWithTitle:@"请稍候..." atView:self.view];

    ValidcodeRequest *request = [[ValidcodeRequest alloc] init];
    [request requestLoginValidcode:[self mobile]
                     validcodeType:type
                           success:^ {
                               
                               [self handleQueryValidcodeResult:nil status:YES type:type];
                           }
                           failure:^(NSError * _Nullable err) {
                               
                               [self handleQueryValidcodeResult:err.userInfo status:NO type:type];
                           }];
}

- (void)handleQueryValidcodeResult:(NSDictionary *)userInfo
                            status:(BOOL)succeeded
                              type:(ValidcodeType)type {
    
    [KKZUtility hidenIndicator];
    
    if (succeeded) {
        isQueriedSMSValidcode = (type == SMSValidcode);
        if (isQueriedSMSValidcode) {
            [UIAlertView showAlertView:@"验证码已经发出，请您耐心等待"
                            buttonText:@"确定"];
        }
        else {
            [UIAlertView showAlertView:@"我们将通过电话方式告知您验证码，请注意接听"
                            buttonText:@"确定"];
        }
        
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
    NSString *titleName = isQueriedSMSValidcode ? [NSString stringWithFormat:@"%d秒后重发", timeCount] : @"获取验证码";
//    self.queryValidcodeButton.titleName = titleName;
    [self.queryValidcodeButton setTitle:titleName forState:UIControlStateNormal];
    [self.queryValidcodeButton setNeedsDisplay];
    
    NSMutableAttributedString *title = [self setupVoiceValidcodeBtnTitle:NO];
    [self.voiceValidcodeBtn setAttributedTitle:title
                                      forState:UIControlStateNormal];
}

- (void)countdownValidcodeEnable:(NSTimer *)time {
    timeCount--;
    
    if (timeCount <= 0) {
        self.queryValidcodeButton.enabled = YES;
        [self.queryValidcodeButton setNeedsDisplay];
//        self.queryValidcodeButton.titleName = @"获取验证码";
        [self.queryValidcodeButton setTitle:@"获取验证码"
                                   forState:UIControlStateNormal];
        [timer invalidate];
        timer = nil;
        [self checkValidcodeButtonEnable];
    }
    else { //倒计时显示
        NSString *titleName = isQueriedSMSValidcode ? [NSString stringWithFormat:@"%d秒后重发", timeCount] : @"获取验证码";
//        self.queryValidcodeButton.titleName = titleName;
        [self.queryValidcodeButton setTitle:titleName
                                   forState:UIControlStateNormal];
        [self.queryValidcodeButton setNeedsDisplay];
    }
}

/**
 *  用户点击登录按钮操作
 */
- (void)kkzLogin {

    //取消键盘
    [self dismissKeyBoard];
    
    if (![self isNetworkConnected]) {
        return;
    }
    
    //存储用户的手机号
    LOGIN_MOBILE_INPUT_WRITE(self.mobileInputField.text);

    //显示加载框
    [KKZUtility showIndicatorWithTitle:@"正在登录，请稍候..." atView:self.view];

    __weak typeof(self) weak_self = self;

    //使用手机号+验证码登录
    NSString *validcodeText = self.validcodeInputField.text;
    [[UserManager shareInstance] login:[self mobile]
                              password:validcodeText
                                  site:SiteTypeKKZValidcode
                               success:^(UserLogin *_Nullable userLogin) {

                                   [weak_self handleLoginSucceed];
                               }
                               failure:^(NSError *_Nullable err) {

                                   [appDelegate showAlertViewForRequestInfo:err.userInfo];
                                   [KKZUtility hidenIndicator];

                               }];
}

- (NSString *)mobile {
    NSString *mobile = self.mobileInputField.text;
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    return mobile;
}

/**
 * 第三方和非第三方登录成功
 * 登录成功后页面停留1秒，用来显示用户的头像
 */
- (void)handleLoginSucceed {

    [KKZUtility hidenIndicator];
    
    //加载用户的头像
//    NSURL *headimgUrl = [NSURL URLWithString:[DataEngine sharedDataEngine].headImg];
//    [self.logoImageView sd_setImageWithURL:headimgUrl];
    
    [self performSelector:@selector(performLoginSucceed)
               withObject:nil
               afterDelay:1.f];
}

- (void)performLoginSucceed {
    //回到上一个视图
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginControllerLoginSucceed)]) {
            [self.delegate loginControllerLoginSucceed];
        }
    }];
}

- (BOOL)isNetworkConnected {
    if (!isConnected) {
        [UIAlertView showAlertView:@"当前网络未连接，请您稍后重试" buttonText:@"确定"];
        return NO;
    }
    return YES;
}

/**
 *  点击键盘取消按钮
 */
- (void)dismissKeyBoard {
    isKeyboardShown = NO;
    [self resignFirstResponders];
    
    [UIView animateWithDuration:.2
            animations:^{
                
                [self.contentView setContentOffset:CGPointZero];
            }
            completion:^(BOOL finished) {
                
                [self.contentView setContentOffset:CGPointZero];
                [self resignFirstResponders];
            }];
}

/**
 *  取消键盘
 */
- (void)resignFirstResponders {
    [self.mobileInputField resignFirstResponder];
    [self.validcodeInputField resignFirstResponder];
}

#pragma mark - Delegates
#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isKeyboardShown) {
        [self resignFirstResponders];
    }
}

#pragma mark UITextFieldDelegate
/**
 *  文本开始编辑的时候代理
 *
 *  @param textField
 *
 *  @return
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGFloat offsetY = self.inputContent.frame.origin.y - 30;

    [UIView animateWithDuration:.2
                     animations:^{

                         [self.contentView setContentOffset:CGPointMake(0, offsetY)];
                     }
                     completion:nil];

    if (textField == self.mobileInputField) {
//        self.mobileTitle.textColor = kInputTextFocused;
        self.mobileBottomLine.backgroundColor = kInputLineFocused;
//        self.validcodeTitle.textColor = kInputTextNormal;
        self.validcodeBottomLine.backgroundColor = kInputLineNormal;
    }
    else if (textField == self.validcodeInputField) {
//        self.mobileTitle.textColor = kInputTextNormal;
        self.mobileBottomLine.backgroundColor = kInputLineNormal;
//        self.validcodeTitle.textColor = kInputTextFocused;
        self.validcodeBottomLine.backgroundColor = kInputLineFocused;
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

/**
 *  文本开始变化的时候
 *
 *  @param textField
 *  @param range
 *  @param string
 *
 *  @return
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger length = textField.text.length;
    if (textField == self.mobileInputField) {
        if (length >= K_PHONE_LENGTH && string.length > 0) {
            return NO;
        }
        
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:K_PHONE_LIMITS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        if (!basic) {
            return NO;
        }
        
        if (string.length > 0) { //输入字符
            if (textField.text.length == 3) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
            else if (textField.text.length == 8) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
        else { //删除字符
            NSString *text = textField.text;
            if (text.length == 5 || text.length == 10) {
                textField.text = [text substringToIndex:text.length - 1];
            }
        }
    }
    else if (textField == self.validcodeInputField) {
        if (length >= K_VALIDCODE_LENGTH && string.length > 0) {
            return NO;
        }
        
        //invertedSet方法是去反字符,把所有的除了kNumber里的字符都找出来(包含去空格功能)
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:K_VALIDCODE_LIMITS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
    }
    return YES;
}

/**
 *  用户点击return键操作
 *
 *  @param textField
 *
 *  @return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self kkzLogin];
    return YES;
}

#pragma mark KKZTextField delegate
- (void)kkzTextFieldClear:(KKZTextField *)field {
    if (field == self.mobileInputField) {
        [self mobileTextFieldChanged];
    }
    else if (field == self.validcodeInputField) {
        [self validcodeTextFieldChanged];
    }
}

#pragma mark - Keyboard notifications
- (void)registerKeyboardNotifications {
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWasShown:(NSNotification*)notification {
    isKeyboardShown = YES;
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    isKeyboardShown = NO;
    
}

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

- (void)setValidcodeButtonEnable:(BOOL)enabled {
    self.queryValidcodeButton.enabled = enabled;
    self.voiceValidcodeBtn.enabled = enabled;
    
    NSMutableAttributedString *title = [self setupVoiceValidcodeBtnTitle:enabled];
    [self.voiceValidcodeBtn setAttributedTitle:title
                                      forState:UIControlStateNormal];
    if (enabled) {
        self.queryValidcodeButton.rimColor = kValidcodeEnabled;
        self.queryValidcodeButton.titleColor = kValidcodeEnabled;
    }
    else {
        self.queryValidcodeButton.rimColor = kValidcodeDisabled;
        self.queryValidcodeButton.titleColor = kValidcodeDisabled;
    }
}

- (BOOL)checkValidcodeButtonEnable {
    BOOL enabled = (self.mobileInputField.text.length == K_PHONE_LENGTH && [self.mobileInputField.text hasPrefix:@"1"] && timeCount <= 0);
    [self setValidcodeButtonEnable:enabled];
    return enabled;
}

- (void)checkLoginButtonEnable {
    if (self.mobileInputField.text.length == K_PHONE_LENGTH && [self.mobileInputField.text hasPrefix:@"1"] && self.validcodeInputField.text.length >= 6 && self.validcodeInputField.text.length <= 12) {
        self.loginBtn.enabled = YES;
//        self.loginBtn.backgroundColor = kLoginEnabled;
    }
    else {
        self.loginBtn.enabled = NO;
//        self.loginBtn.backgroundColor = kLoginDisabled;
    }
}

#pragma mark - Override super methods
- (BOOL)showNavBar {
    return NO;
}

@end
