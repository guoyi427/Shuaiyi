//
//  UserRegisterSetPWView.m
//  CIASMovie
//
//  Created by avatar on 2017/1/8.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "UserRegisterSetPWView.h"
#import "KKZTextUtility.h"
#import "UserDefault.h"

#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."
#define  ACCOUNT_MAX_CHARS    16
#define  NICKNAME_MAX_CHARS    20

@implementation UserRegisterSetPWView


- (id)initWithFrame:(CGRect)frame delegate:(id<UserRegisterSetPWViewDelegate>)aDelegate {
    if (self = [super initWithFrame:frame]) {
        self.delegate = aDelegate;
        self.backgroundColor = [UIColor clearColor];
        holderView = [[UIScrollView alloc] init];
        bgView = [[UIView alloc] init];
        holderView.delegate = self;
        holderView.backgroundColor = [UIColor clearColor];
        [holderView setShowsVerticalScrollIndicator:YES];
        [holderView setShowsHorizontalScrollIndicator:NO];
        
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
        
        
        //MARK: 登录标题
        NSString *registerStr = @"注册";
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
        
        
        //MARK: 登录标题
        NSString *phoneTipsStr = @"创建密码";
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
        NSString *phoneTipsStr1 = @"输入至少8位的数字或字母";
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
        
        NSString *phoneTipsStr2 = @"最好包含至少1个标点符号";
        CGSize phoneTipsStrSize2 = [KKZTextUtility measureText:phoneTipsStr2 size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
        phoneTipsLabelOfRegister2 = [[UILabel alloc] init];
        [bgView addSubview:phoneTipsLabelOfRegister2];
        phoneTipsLabelOfRegister2.text = phoneTipsStr2;
        phoneTipsLabelOfRegister2.font = [UIFont systemFontOfSize:13];
        phoneTipsLabelOfRegister2.textColor = [UIColor colorWithHex:@"#999999"];
        [phoneTipsLabelOfRegister2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(phoneTipsLabelOfRegister1.mas_bottom).offset(2);
            make.size.mas_equalTo(CGSizeMake(phoneTipsStrSize2.width+5, phoneTipsStrSize2.height));
        }];
        
        
        UIImage *passwordImage = [UIImage imageNamed:@"login_password"];
        passwordImageViewOfReset = [[UIImageView alloc] initWithImage:passwordImage];
        passwordImageViewOfReset.contentMode = UIViewContentModeScaleAspectFill;
        [bgView addSubview:passwordImageViewOfReset];
        [passwordImageViewOfReset mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(phoneTipsLabelOfRegister2.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(passwordImage.size.width, passwordImage.size.height));
        }];
        
        NSString *passwordLabelStr = @"密码";
        CGSize passwordLabelStrSize = [KKZTextUtility measureText:passwordLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
        passwordLabelOfReset = [[UILabel alloc] init];
        passwordLabelOfReset.text = passwordLabelStr;
        passwordLabelOfReset.font = [UIFont systemFontOfSize:10];
        passwordLabelOfReset.textColor = [UIColor colorWithHex:@"#cccccc"];
        [bgView addSubview:passwordLabelOfReset];
        [passwordLabelOfReset mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passwordImageViewOfReset.mas_right).offset(15);
            make.top.equalTo(phoneTipsLabelOfRegister2.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(passwordLabelStrSize.width+10, passwordLabelStrSize.height));
        }];
        
        passwordField = [[UITextField alloc] init];
        NSString *passwordFieldPlaceHolderStr = @"请输入密码";
        CGSize passwordFieldPlaceHolderStrSize = [KKZTextUtility measureText:passwordFieldPlaceHolderStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
        passwordField.textColor = [UIColor colorWithHex:@"#ffffff"];
        passwordField.font = [UIFont systemFontOfSize:16];
        passwordField.secureTextEntry = YES;
        passwordField.delegate = self;
        [self setRightViewWithTextField:passwordField imageName:@"password_view" imageNameOfSelected:@"password_unview"];
        UIColor *passwordFieldPlaceholderColor = [UIColor colorWithHex:@"666666"];
        UIFont *passwordFieldPlaceholderFont = [UIFont systemFontOfSize:14];
        passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:passwordFieldPlaceHolderStr attributes:@{NSForegroundColorAttributeName:passwordFieldPlaceholderColor, NSFontAttributeName:passwordFieldPlaceholderFont}];
        [passwordField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
        [bgView addSubview:passwordField];
        [passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(passwordImageViewOfReset.mas_right).offset(15);
            make.top.equalTo(passwordLabelOfReset.mas_bottom).offset(9);
            make.right.equalTo(bgView.mas_right).offset(-30);
            make.height.equalTo(@(passwordFieldPlaceHolderStrSize.height));
        }];
        
        line1View = [[UIView alloc] init];
        line1View.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        line1View.alpha = .2;
        [bgView addSubview:line1View];
        [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left);
            make.top.equalTo(passwordImageViewOfReset.mas_bottom).offset(15);
            make.right.equalTo(bgView.mas_right);
            make.height.equalTo(@(1));
        }];
        
        
        gotoRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [gotoRegisterBtn setTitle:@"完成" forState:UIControlStateNormal];
        //        [gotoRegisterBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
        //        gotoRegisterBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [gotoRegisterBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateNormal];
        gotoRegisterBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        gotoRegisterBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        gotoRegisterBtn.layer.cornerRadius = 3.5;
        gotoRegisterBtn.clipsToBounds = YES;
        [bgView addSubview:gotoRegisterBtn];
        [gotoRegisterBtn addTarget:self action:@selector(gotoBtnClickOfSetPWView:) forControlEvents:UIControlEventTouchUpInside];
        [gotoRegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(line1View.mas_bottom).offset(152);
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
        UIView *bottomYellowProgressBar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-4, kCommonScreenWidth, 4)];
        bottomYellowProgressBar.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [self addSubview:bottomYellowProgressBar];
    }
    return self;
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

- (void) rightBtnOfTextFieldClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        passwordField.secureTextEntry = YES;
    } else {
        passwordField.secureTextEntry = NO;
    }
}


- (void) gotoBtnClickOfSetPWView:(id)sender {
    if (passwordField.text.length < 8) {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"密码不符合规则，请使用8-12位字母或数字" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
        }];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userSetRegisterPWButtonClickWithAccount:passWord:)]) {
        [self.delegate userSetRegisterPWButtonClickWithAccount:USER_DEFAULT_REGISTERPHONE passWord:passwordField.text];
    }
}




#pragma mark - UITapGestureRecognizer
- (void)singleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    if (!CGRectContainsPoint(passwordField.frame, point) && !CGRectContainsPoint(gotoRegisterBtn.frame, point)) {
        [passwordField resignFirstResponder];
        [UIView animateWithDuration:.2
                         animations:^{
                             [gotoRegisterBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.top.equalTo(line1View.mas_bottom).offset(152);
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

- (void)textFieldDidChange {
    if (passwordField.text.length > 7) {
        [gotoRegisterBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
        gotoRegisterBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    } else {
        [gotoRegisterBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateNormal];
        gotoRegisterBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //kNumbers
    if (textField == passwordField) {
        
        int length = (int)textField.text.length;
        if (length >= 12 && string.length > 0) {
            
            return NO;
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
    
    if (textField == passwordField) {
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
    if (textField == passwordField) {
        
        [gotoRegisterBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line1View.mas_bottom).offset(152);
        }];
        
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


- (void)beginEdit {
    [passwordField becomeFirstResponder];
}

- (void)endEdit {
    [passwordField resignFirstResponder];
}



@end
