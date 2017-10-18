//
//  UserForgetPWCodeView.m
//  CIASMovie
//
//  Created by avatar on 2017/1/8.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "UserForgetPWCodeView.h"
#import "UserDefault.h"
#import "KKZTextUtility.h"

#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."
#define  ACCOUNT_MAX_CHARS    16
#define  NICKNAME_MAX_CHARS    20

@interface UserForgetPWCodeView ()
{
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
    NSTimer *registerCodeTimer; //  60s 重发 倒计时 计时器
    NSInteger currentTimeDownCount;    //  60s 重发 倒计时 当前秒
    
    BOOL _wechatBindPhoneState;
}
@end


@implementation UserForgetPWCodeView

- (void)dealloc
{
    [registerCodeTimer invalidate];
    registerCodeTimer = nil;
    
}

- (id)initWithFrame:(CGRect)frame delegate:(id<UserForgetPWCodeViewDelegate>)aDelegate {
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
            make.height.mas_equalTo(kCommonScreenHeight*1.0);
        }];
        
        //MARK: x返回按钮
        UIImage *backImage = [UIImage imageNamed:@"login_close"];
        backBtnOfRegister = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtnOfRegister setImage:backImage forState:UIControlStateNormal];
        [backBtnOfRegister addTarget:self action:@selector(backBtnOfPWClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:backBtnOfRegister];
        [backBtnOfRegister mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top).offset(30);
            make.right.equalTo(bgView.mas_right).offset(-30);
            make.size.mas_equalTo(CGSizeMake(backImage.size.width, backImage.size.height));
        }];
        
        //MARK: 登录标题
        NSString *registerStr = @"忘记密码？";
        CGSize registerStrSize = [KKZTextUtility measureText:registerStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:30]];
        titleLabelOfRegister = [[UILabel alloc] init];
        [bgView addSubview:titleLabelOfRegister];
        titleLabelOfRegister.text = registerStr;
        titleLabelOfRegister.font = [UIFont systemFontOfSize:30];
        titleLabelOfRegister.textColor = [UIColor colorWithHex:@"#ffffff"];
        [titleLabelOfRegister mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(bgView.mas_top).offset(110);
            make.size.mas_equalTo(CGSizeMake(registerStrSize.width+5, registerStrSize.height));
        }];
        
        
        //MARK: 注册按钮
        UIImage *loginImage = [UIImage imageNamed:@"login_arrow"];
        NSString *loginStr = @"上一步";
        CGSize loginStrSize = [KKZTextUtility measureText:loginStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18]];
        loginBtnOfRegister = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtnOfRegister2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [bgView addSubview:loginBtnOfRegister];
        [bgView addSubview:loginBtnOfRegister2];
        [loginBtnOfRegister setTitle:loginStr forState:UIControlStateNormal];
        [loginBtnOfRegister setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor] forState:UIControlStateNormal];
        loginBtnOfRegister.titleLabel.font = [UIFont systemFontOfSize:18];
        [loginBtnOfRegister2 setImage:loginImage forState:UIControlStateNormal];
        [loginBtnOfRegister addTarget:self action:@selector(loginBtnOfPWViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtnOfRegister2 addTarget:self action:@selector(loginBtnOfPWViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [loginBtnOfRegister mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top).offset(115);
            make.right.equalTo(bgView.mas_right).offset(-(5 + 30 + loginImage.size.width));
            make.size.mas_equalTo(CGSizeMake(loginStrSize.width + 5, loginStrSize.height));
        }];
        
        [loginBtnOfRegister2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top).offset(115);
            make.right.equalTo(bgView.mas_right).offset(-30);
            make.size.mas_equalTo(CGSizeMake(loginImage.size.width, loginImage.size.height));
        }];
        
        //MARK: 登录标题
        NSString *phoneTipsStr = @"请输入6位验证码";
        CGSize phoneTipsStrSize = [KKZTextUtility measureText:phoneTipsStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:16]];
        phoneTipsLabelOfRegister = [[UILabel alloc] init];
        [bgView addSubview:phoneTipsLabelOfRegister];
        phoneTipsLabelOfRegister.text = phoneTipsStr;
        phoneTipsLabelOfRegister.font = [UIFont systemFontOfSize:16];
        phoneTipsLabelOfRegister.textColor = [UIColor colorWithHex:@"#ffffff"];
        [phoneTipsLabelOfRegister mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(titleLabelOfRegister.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(phoneTipsStrSize.width+5, phoneTipsStrSize.height));
        }];
        NSString *phoneNum = USER_DEFAULT_FORGETPWPHONE;
        NSString *modifyPhoneStr = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        NSString *phoneTipsStr1 = [NSString stringWithFormat:@"我们向%@发送了一个验证码", modifyPhoneStr];
        CGSize phoneTipsStrSize1 = [KKZTextUtility measureText:phoneTipsStr1 size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
        phoneTipsLabelOfRegister1 = [[UILabel alloc] init];
        [bgView addSubview:phoneTipsLabelOfRegister1];
        phoneTipsLabelOfRegister1.text = phoneTipsStr1;
        phoneTipsLabelOfRegister1.font = [UIFont systemFontOfSize:13];
        phoneTipsLabelOfRegister1.textColor = [UIColor colorWithHex:@"#999999"];
        [phoneTipsLabelOfRegister1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(phoneTipsLabelOfRegister.mas_bottom).offset(9);
            make.size.mas_equalTo(CGSizeMake(phoneTipsStrSize1.width+5, phoneTipsStrSize1.height));
        }];
        
        
        NSString *phoneTipsStr2 = @"请在下方输入验证码";
        CGSize phoneTipsStrSize2 = [KKZTextUtility measureText:phoneTipsStr2 size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
        phoneTipsLabelOfRegister2 = [[UILabel alloc] init];
        [bgView addSubview:phoneTipsLabelOfRegister2];
        phoneTipsLabelOfRegister2.text = phoneTipsStr2;
        phoneTipsLabelOfRegister2.font = [UIFont systemFontOfSize:13];
        phoneTipsLabelOfRegister2.textColor = [UIColor colorWithHex:@"#999999"];
        [phoneTipsLabelOfRegister2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(phoneTipsLabelOfRegister1.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(phoneTipsStrSize2.width+5, phoneTipsStrSize2.height));
        }];
        
        
        NSString *phoneLabelStr = @"6位验证码";
        CGSize phoneLabelStrSize = [KKZTextUtility measureText:phoneLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
        phoneLabelOfRegister = [[UILabel alloc] init];
        phoneLabelOfRegister.text = phoneLabelStr;
        phoneLabelOfRegister.font = [UIFont systemFontOfSize:10];
        phoneLabelOfRegister.textColor = [UIColor colorWithHex:@"#cccccc"];
        [bgView addSubview:phoneLabelOfRegister];
        [phoneLabelOfRegister mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(phoneTipsLabelOfRegister2.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(phoneLabelStrSize.width+5, phoneLabelStrSize.height));
        }];
        
        codeField = [[UITextField alloc] init];
        NSString *codeFieldPlaceHolderStr = @"请输入短信中的验证码";
        CGSize codeFieldPlaceHolderStrSize = [KKZTextUtility measureText:codeFieldPlaceHolderStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
        codeField.textColor = [UIColor colorWithHex:@"#ffffff"];
        codeField.font = [UIFont systemFontOfSize:16];
        codeField.keyboardType = UIKeyboardTypePhonePad;
        codeField.delegate = self;
        UIColor *phonePlaceholderColor = [UIColor colorWithHex:@"666666"];
        UIFont *phonePlaceholderFont = [UIFont systemFontOfSize:14];
        codeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:codeFieldPlaceHolderStr attributes:@{NSForegroundColorAttributeName:phonePlaceholderColor, NSFontAttributeName:phonePlaceholderFont}];
        [bgView addSubview:codeField];
        //textField变化时事件
        [codeField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [codeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(phoneLabelOfRegister.mas_bottom).offset(9);
            make.right.equalTo(bgView.mas_right).offset(-30);
            make.height.equalTo(@(codeFieldPlaceHolderStrSize.height));
        }];
        
        codeRightView = [UIButton buttonWithType:UIButtonTypeCustom];
        codeRightView.frame = CGRectMake(0, 0, 80, 20);
        codeField.rightView = codeRightView;
        codeField.rightViewMode = UITextFieldViewModeAlways;
        codeRightView.titleLabel.font = [UIFont systemFontOfSize:16];
        [codeRightView setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor] forState:UIControlStateNormal];
        [codeRightView setTitle:@"60" forState:UIControlStateNormal];
        codeRightView.enabled = false;
        [codeRightView addTarget:self action:@selector(codeRightViewAction:) forControlEvents:UIControlEventTouchUpInside];
        codeRightView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        
        line1View = [[UIView alloc] init];
        line1View.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        line1View.alpha = .2;
        [bgView addSubview:line1View];
        [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left);
            make.top.equalTo(codeField.mas_bottom).offset(15);
            make.right.equalTo(bgView.mas_right);
            make.height.equalTo(@(1));
        }];
        
        
        gotoRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [gotoRegisterBtn setTitle:@"下一步" forState:UIControlStateNormal];
        //        [gotoRegisterBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
        //        gotoRegisterBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [gotoRegisterBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateNormal];
        gotoRegisterBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        gotoRegisterBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        gotoRegisterBtn.layer.cornerRadius = 3.5;
        gotoRegisterBtn.clipsToBounds = YES;
        [bgView addSubview:gotoRegisterBtn];
        [gotoRegisterBtn addTarget:self action:@selector(gotoBtnClickOfForgetPWView:) forControlEvents:UIControlEventTouchUpInside];
        [gotoRegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(line1View.mas_bottom).offset(115);
            make.right.equalTo(bgView.mas_right).offset(-30);
            make.height.equalTo(@(50));
        }];
        
        [holderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(bgView.mas_bottom).offset(80).priorityLow();
            make.bottom.mas_greaterThanOrEqualTo(self);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        tap.cancelsTouchesInView = NO;
        [bgView addGestureRecognizer:tap];
        
        //  底部黄色进度条
        bottomYellowProgressBar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-4, kCommonScreenWidth/3.0*2, 4)];
        bottomYellowProgressBar.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [self addSubview:bottomYellowProgressBar];
        
    }
    return self;
}



- (void) backBtnOfPWClick:(id)sender {
    if (registerCodeTimer.isValid) {
        [registerCodeTimer invalidate];
        registerCodeTimer = nil;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClickOfForgetPWView)]) {
        [self.delegate backBtnClickOfForgetPWView];
    }
}

//上一步
- (void) loginBtnOfPWViewClick:(id)sender {
    if (registerCodeTimer.isValid) {
        [registerCodeTimer invalidate];
        registerCodeTimer = nil;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoLoginViewOfForgetPWViewButtonClick)]) {
        [self.delegate gotoLoginViewOfForgetPWViewButtonClick];
    }
}

//下一步按钮
- (void) gotoBtnClickOfForgetPWView:(id)sender {
    if (codeField.text.length < 7) {
        //        [[CIASAlertCancleView new] show:@"请填写短信里的验证码" message:@"如果验证码不正确，您将无法重置密码" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
        //        }];
        return;
    }
    if (registerCodeTimer && registerCodeTimer.isValid) {
        [registerCodeTimer invalidate];
        registerCodeTimer = nil;
    }

    if (_wechatBindPhoneState) {
        //  如果是微信登录绑定手机号
        if (self.delegate && [self.delegate respondsToSelector:@selector(wechatBindPhoneWithAccount:codeStr:)]) {
            [self.delegate wechatBindPhoneWithAccount:USER_DEFAULT_FORGETPWPHONE codeStr:[codeField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
    } else {
        //  如果是忘记密码
        if (self.delegate && [self.delegate respondsToSelector:@selector(userOfForgetPWButtonClickWithAccount:codeStr:)]) {
            [self.delegate userOfForgetPWButtonClickWithAccount:USER_DEFAULT_FORGETPWPHONE codeStr:[codeField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
    }
}

//  重新发送 验证码按钮
- (void)codeRightViewAction:(UIButton *)button {
    //  重启倒计时
    if (registerCodeTimer && registerCodeTimer.isValid) {
        [registerCodeTimer invalidate];
        registerCodeTimer = nil;
    }
    currentTimeDownCount = 60;
    registerCodeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethodOfRegister) userInfo:nil repeats:YES];
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    UserRequest *request = [[UserRequest alloc] init];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:USER_DEFAULT_REGISTERPHONE forKey:@"phoneNumber"];
    //  MARK:  1为注册，2为忘记密码
    if (_wechatBindPhoneState) {
        [params setValue:@"1" forKey:@"msgTypeId"];

    }else{
        [params setValue:@"2" forKey:@"msgTypeId"];
    }
    [request requestGetRegisterCodeParams:params success:^(NSDictionary * _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

- (void)beforeActivityMethodOfRegister {
    currentTimeDownCount --;
    [self updateCodeInputViewWithTime:currentTimeDownCount];
}

/**
 更新验证码倒计时
 
 @param time 倒计时
 */
- (void)updateCodeInputViewWithTime:(NSInteger)time {
    if (time > 0) {
        [codeRightView setTitle:[NSString stringWithFormat:@"%ld", (long)time] forState:UIControlStateNormal];
        codeRightView.enabled = false;
    } else {
        [codeRightView setTitle:@"重新发送" forState:UIControlStateNormal];
        codeRightView.enabled = true;
        if (registerCodeTimer && registerCodeTimer.isValid) {
            [registerCodeTimer invalidate];
            registerCodeTimer = nil;
        }
    }
}



#pragma mark - UITapGestureRecognizer
- (void)singleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    if (!CGRectContainsPoint(codeField.frame, point) && !CGRectContainsPoint(gotoRegisterBtn.frame, point)) {
        [codeField resignFirstResponder];
        [UIView animateWithDuration:.2
                         animations:^{
                             [gotoRegisterBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.top.equalTo(line1View.mas_bottom).offset(115);
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
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"blurEffectViewBackgroundColor" object:@YES];
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    if (textField == codeField) {
        if (textField.text.length > 7) {
            textField.text = [textField.text substringToIndex:7];
        }
        
        if (textField.text.length == 7) {
            [gotoRegisterBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
            gotoRegisterBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        } else {
            [gotoRegisterBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateNormal];
            gotoRegisterBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        }
        
        NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
        
        NSString *currentStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *preStr = [previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //正在执行删除操作时为0，否则为1
        char editFlag = 0;
        if (currentStr.length <= preStr.length) {
            editFlag = 0;
        }
        else {
            editFlag = 1;
        }
        
        NSMutableString *tempStr = [NSMutableString new];
        
        int spaceCount = 0;
        if (currentStr.length < 3 && currentStr.length > -1) {
            spaceCount = 0;
        }else if (currentStr.length < 7 && currentStr.length > 2) {
            spaceCount = 1;
        }else if (currentStr.length < 12 && currentStr.length > 6) {
            spaceCount = 2;
        }
        
        for (int i = 0; i < spaceCount; i++) {
            if (i == 0) {
                [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 3)], @" "];
            }else if (i == 1) {
                [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(3, 4)], @" "];
            }else if (i == 2) {
                [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
            }
        }
        
        if (currentStr.length == 11) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
        }
        if (currentStr.length < 4) {
            [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
        }else if(currentStr.length > 3 && currentStr.length <12) {
            NSString *str = [currentStr substringFromIndex:3];
            [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
            if (currentStr.length == 11) {
                [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
            }
        }
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
    if (textField == codeField) {
        
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        
        int length = (int)textField.text.length;
        if (length >= 7 && string.length > 0) {
            
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basic = [string isEqualToString:filtered];
        return basic;
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == codeField) {
        if (!Constants.isIphone5) {
            [UIView animateWithDuration:.2
                             animations:^{
                                 [gotoRegisterBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.top.equalTo(line1View.mas_bottom).offset(15);
                                 }];
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        } else {
            [gotoRegisterBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line1View.mas_bottom).offset(36);
            }];
        }
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == codeField) {
        if ((codeField.text.length == 11)) {
            
        } else {
            [gotoRegisterBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line1View.mas_bottom).offset(115);
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
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
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

#pragma mark - Public - Methods

- (void)beginEdit {
    [codeField becomeFirstResponder];
}

- (void)endEdit {
    [codeField resignFirstResponder];
}

- (void)updateStateToBind:(BOOL)isWechatBind {
    _wechatBindPhoneState = isWechatBind;

    if (isWechatBind) {
        [bottomYellowProgressBar setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-4, kCommonScreenWidth, 4)];

        titleLabelOfRegister.text = @"绑定手机号";
//        loginBtnOfRegister.hidden = true;
//        loginBtnOfRegister2.hidden = true;
    } else {
        [bottomYellowProgressBar setFrame:CGRectMake(0, CGRectGetHeight(self.frame)-4, kCommonScreenWidth/3.0*2, 4)];

        titleLabelOfRegister.text = @"忘记密码？";
//        loginBtnOfRegister.hidden = false;
//        loginBtnOfRegister2.hidden = false;
    }
}

@end
