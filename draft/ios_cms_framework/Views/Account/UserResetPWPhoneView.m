//
//  UserResetPWPhoneView.m
//  CIASMovie
//
//  Created by avatar on 2017/2/20.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "UserResetPWPhoneView.h"
#import "CIASActivityIndicatorView.h"
#import "KKZTextUtility.h"

#define kAlphaNum   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define kAlpha      @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
#define kNumbers     @"0123456789"
#define kNumbersPeriod  @"0123456789."
#define  ACCOUNT_MAX_CHARS    16
#define  NICKNAME_MAX_CHARS    20

@interface UserResetPWPhoneView ()
{
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
}
@end

@implementation UserResetPWPhoneView


- (id)initWithFrame:(CGRect)frame delegate:(id<UserResetPWPhoneViewDelegate>)aDelegate {
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
        
        //MARK: x返回按钮
        UIImage *backImage = [UIImage imageNamed:@"login_close"];
        backBtnOfRegister = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtnOfRegister setImage:backImage forState:UIControlStateNormal];
        [backBtnOfRegister addTarget:self action:@selector(backBtnOfReserPWClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:backBtnOfRegister];
        [backBtnOfRegister mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView.mas_top).offset(30);
            make.right.equalTo(bgView.mas_right).offset(-30);
            make.size.mas_equalTo(CGSizeMake(backImage.size.width, backImage.size.height));
        }];
        
        //MARK: 登录标题
        NSString *registerStr = @"重置登录密码";
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
        NSString *phoneTipsStr = @"请输入您的手机号码";
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
        
        //MARK: 登录标题
        NSString *phoneTipsStr1 = @"以查找您的账号";
        CGSize phoneTipsStrSize1 = [KKZTextUtility measureText:phoneTipsStr1 size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:16]];
        phoneTipsLabelOfRegister2 = [[UILabel alloc] init];
        [bgView addSubview:phoneTipsLabelOfRegister2];
        phoneTipsLabelOfRegister2.text = phoneTipsStr1;
        phoneTipsLabelOfRegister2.font = [UIFont systemFontOfSize:16];
        phoneTipsLabelOfRegister2.textColor = [UIColor colorWithHex:@"#ffffff"];
        [phoneTipsLabelOfRegister2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(phoneTipsLabelOfRegister.mas_bottom).offset(2);
            make.size.mas_equalTo(CGSizeMake(phoneTipsStrSize1.width+5, phoneTipsStrSize1.height));
        }];
        
        
        UIImage *phoneImageOfRegister = [UIImage imageNamed:@"login_phone"];
        phoneImageViewOfRegister = [[UIImageView alloc] initWithImage:phoneImageOfRegister];
        phoneImageViewOfRegister.contentMode = UIViewContentModeScaleAspectFill;
        [bgView addSubview:phoneImageViewOfRegister];
        [phoneImageViewOfRegister mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(phoneTipsLabelOfRegister2.mas_bottom).offset(50);
            make.size.mas_equalTo(CGSizeMake(phoneImageOfRegister.size.width, phoneImageOfRegister.size.height));
        }];
        
        NSString *phoneLabelStr = @"手机号码";
        CGSize phoneLabelStrSize = [KKZTextUtility measureText:phoneLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
        phoneLabelOfRegister = [[UILabel alloc] init];
        phoneLabelOfRegister.text = phoneLabelStr;
        phoneLabelOfRegister.font = [UIFont systemFontOfSize:10];
        phoneLabelOfRegister.textColor = [UIColor colorWithHex:@"#cccccc"];
        [bgView addSubview:phoneLabelOfRegister];
        [phoneLabelOfRegister mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(phoneImageViewOfRegister.mas_right).offset(15);
            make.top.equalTo(phoneTipsLabelOfRegister2.mas_bottom).offset(50);
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
            make.left.equalTo(phoneImageViewOfRegister.mas_right).offset(15);
            make.top.equalTo(phoneLabelOfRegister.mas_bottom).offset(9);
            make.right.equalTo(bgView.mas_right).offset(-30);
            make.height.equalTo(@(phoneFieldPlaceHolderStrSize.height));
        }];
        
        line1View = [[UIView alloc] init];
        line1View.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        line1View.alpha = .2;
        [bgView addSubview:line1View];
        [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left);
            make.top.equalTo(phoneImageViewOfRegister.mas_bottom).offset(15);
            make.right.equalTo(bgView.mas_right);
            make.height.equalTo(@(1));
        }];
        
        
        getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [getCodeBtn setTitle:@"下一步" forState:UIControlStateNormal];
//        [getCodeBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
//        getCodeBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [getCodeBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateNormal];
        getCodeBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        getCodeBtn.layer.cornerRadius = 3.5;
        getCodeBtn.clipsToBounds = YES;
        [bgView addSubview:getCodeBtn];
        [getCodeBtn addTarget:self action:@selector(getCodeBtnClickOfReserPWView:) forControlEvents:UIControlEventTouchUpInside];
        [getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(30);
            make.top.equalTo(line1View.mas_bottom).offset(139);
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
        UIView *bottomYellowProgressBar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-4, kCommonScreenWidth/3.0, 4)];
        bottomYellowProgressBar.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [bgView addSubview:bottomYellowProgressBar];

    }
    return self;
}



- (void) backBtnOfReserPWClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClickOfResetPWPhoneView)]) {
        [self.delegate backBtnClickOfResetPWPhoneView];
    }
}


- (void) getCodeBtnClickOfReserPWView:(id)sender {
    if (phoneField.text.length != 13 || ![phoneField.text hasPrefix:@"1"]) {
//        [[CIASAlertCancleView new] show:@"请填写正确的手机号码" message:@"如果号码不正确，您将无法登录" cancleTitle:@"重新填写" callback:^(BOOL confirm) {
//        }];
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userResetPWPhoneButtonClickWithAccount:)]) {
        [self.delegate userResetPWPhoneButtonClickWithAccount:[phoneField.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
}




#pragma mark - UITapGestureRecognizer
- (void)singleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    if (!CGRectContainsPoint(phoneField.frame, point) && !CGRectContainsPoint(getCodeBtn.frame, point)) {
        [phoneField resignFirstResponder];
        [UIView animateWithDuration:.2
                         animations:^{
                             [getCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.top.equalTo(line1View.mas_bottom).offset(139);
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
    if (textField == phoneField) {
        //限制手机账号长度（有两个空格）
        if (textField.text.length == 13 && [textField.text hasPrefix:@"1"]) {
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
            
            [getCodeBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
            getCodeBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        } else {
            if (textField.rightView) {
                textField.rightView = nil;
            }
            [getCodeBtn setTitleColor:[UIColor colorWithWhite:1 alpha:0.3] forState:UIControlStateNormal];
            getCodeBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
        }
        if (textField.text.length > 13) {
            textField.text = [textField.text substringToIndex:13];
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
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == phoneField) {
        if (!Constants.isIphone5) {
            [UIView animateWithDuration:.2
                             animations:^{
                                 [getCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                                     make.top.equalTo(line1View.mas_bottom).offset(30);
                                 }];
                             }
                             completion:^(BOOL finished) {
                                 
                             }];
        } else {
            [getCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line1View.mas_bottom).offset(73);
            }];
        }
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == phoneField) {
        if ((phoneField.text.length == 11)) {
            
        } else {
            [getCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(line1View.mas_bottom).offset(139);
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
     16         * 130,131,132,152,155,156,176，185,186
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


- (void)beginEdit {
    [phoneField becomeFirstResponder];
}

- (void)endEdit {
    [phoneField resignFirstResponder];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
