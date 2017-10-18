//
//  CodeView.m
//  HengDianMovie
//
//  Created by avatar on 2017/2/10.
//  Copyright © 2017年 kokozu. All rights reserved.
//

#import "CodeView.h"
#import "DataEngine.h"
#import "VipCardRequest.h"
#import "KKZTextUtility.h"
@interface CodeView ()

@property(nonatomic,strong)UITextField *TF;

@end

@implementation CodeView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"InputVipCodeSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"InputVipCodeBegin" object:nil];
    [_timer invalidate];
    _timer = nil;
}

- (id)initWithFrame:(CGRect)frame delegate:(id<CodeViewDelegate>)aDelegate andOrderNo:(NSString *)orderNoStr{
    if (self = [super initWithFrame:frame]) {
        self.delegate = aDelegate;
        self.orderNo = orderNoStr;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        float postionY = 20;
        UIImage *btnImage = [UIImage imageNamed:@"titlebar_close"];
        NSString *strOfTitleOfCW = @"输入验证码";
        CGSize strOfTitleOfCWSize = [KKZTextUtility measureText:strOfTitleOfCW size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18]];
        
        _titleOfCW = [[UILabel alloc] initWithFrame:CGRectMake(btnImage.size.width + 20, postionY, self.frame.size.width - (btnImage.size.width + 20)*2, strOfTitleOfCWSize.height)];
        _titleOfCW.text = strOfTitleOfCW;
        _titleOfCW.font = [UIFont systemFontOfSize:18];
        _titleOfCW.textColor = [UIColor colorWithHex:@"#333333"];
        _titleOfCW.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleOfCW];
        
        
        
        _btnOfCW = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnOfCW setImage:btnImage forState:UIControlStateNormal];
        _btnOfCW.frame = CGRectMake(self.frame.size.width - (btnImage.size.width + 20), postionY + 1, btnImage.size.width, btnImage.size.height);
        [_btnOfCW addTarget:self action:@selector(btnOfCWClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnOfCW];
        postionY += strOfTitleOfCWSize.height;
        
        postionY += 25;
        NSString *strOfTipTitleOfCW = [NSString stringWithFormat:@"验证码发送至%@", [self formatPhoneNum:[DataEngine sharedDataEngine].userName]];
        CGSize strOfTipTitleOfCWSize = [KKZTextUtility measureText:strOfTipTitleOfCW size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
        _tipTitleOfCW = [[UILabel alloc] initWithFrame:CGRectMake(0, postionY, self.frame.size.width, strOfTipTitleOfCWSize.height)];
        _tipTitleOfCW.textAlignment = NSTextAlignmentCenter;
        _tipTitleOfCW.font = [UIFont systemFontOfSize:13];
        _tipTitleOfCW.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:strOfTipTitleOfCW];
        NSRange range = [strOfTipTitleOfCW rangeOfString:[self formatPhoneNum:[DataEngine sharedDataEngine].userName]];                              //范围
        [attStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:@"#333333"]} range:range];//添加属性
        [_tipTitleOfCW setAttributedText:attStr];
        [self addSubview:_tipTitleOfCW];
        postionY += strOfTipTitleOfCWSize.height;
        
        postionY += 10;
        NSString *strOfWrongTipsLabel = @"验证码错误！请核对后重新输入";
        CGSize strOfWrongTipsLabelSize = [KKZTextUtility measureText:strOfWrongTipsLabel size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
        _wrongTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, postionY, self.frame.size.width, strOfWrongTipsLabelSize.height)];
        _wrongTipsLabel.text = strOfWrongTipsLabel;
        _wrongTipsLabel.hidden = YES;
        _wrongTipsLabel.font = [UIFont systemFontOfSize:10];
        _wrongTipsLabel.textColor = [UIColor colorWithHex:@"#ff3333"];
        _wrongTipsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_wrongTipsLabel];
        postionY += strOfWrongTipsLabelSize.height;
        
        
        postionY += 25;
        
        getCodeBtnOfCW = [UIButton buttonWithType:UIButtonTypeCustom];
        [getCodeBtnOfCW setFrame:CGRectMake((self.frame.size.width - 95)/2, postionY, 95, 30)];
        getCodeBtnOfCW.layer.cornerRadius = 3.5;
        getCodeBtnOfCW.layer.borderWidth = 0.5;
        getCodeBtnOfCW.titleLabel.font = [UIFont systemFontOfSize:13];
        getCodeBtnOfCW.layer.borderColor = [UIColor colorWithHex:@"#b2b2b2"].CGColor;
        [getCodeBtnOfCW setTitleColor:[UIColor colorWithHex:@"#b2b2b2"] forState:UIControlStateNormal];
        [getCodeBtnOfCW setTitle:@"60s后重新发送" forState:UIControlStateNormal];
        [getCodeBtnOfCW addTarget:self action:@selector(getVipCardCode) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:getCodeBtnOfCW];
        
        postionY += 30;
        
        //添加控件
        postionY += 30;
        _pzxView = [[PZXVerificationCodeView alloc] initWithFrame:CGRectMake((self.frame.size.width - 286 + 30)/2, postionY, 286, 40)];
        _pzxView.selectedColor = [UIColor redColor];
        _pzxView.deselectColor = [UIColor grayColor];
        _pzxView.VerificationCodeNum = 6;
        _pzxView.Spacing = 2;//每个格子间距属性
        [self addSubview:_pzxView];
        [self getVipCardCode];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVipCodeFinishedNotification:) name:@"InputVipCodeSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInputCodeFinishedNotification:) name:@"InputVipCodeBegin" object:nil];
    }
    return self;
}
- (void) handleInputCodeFinishedNotification:(NSNotification *)notification {
    _wrongTipsLabel.hidden = YES;
    CGRect originRect = self.frame;
    if (kCommonScreenWidth>320) {
        originRect.origin.y = (kCommonScreenHeight-230-49)/2-50;
    } else {
        originRect.origin.y = (kCommonScreenHeight-230-49)/2-70;
    }
    self.frame = originRect;
    for (UITextField *tf in _pzxView.textFieldArray) {
        tf.layer.borderColor = [UIColor grayColor].CGColor;
    }
}

- (void) handleVipCodeFinishedNotification:(NSNotification *)notification {
    
    NSString *codeStr = [notification object];
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnBeClickWith:)]) {
        [self.delegate backBtnBeClickWith:codeStr];
    }
}

- (void)getVipCardCode {
    getCodeBtnOfCW.enabled = NO;
    timeCount = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethodOfCodeView:) userInfo:nil repeats:YES];
    if (!_wrongTipsLabel.hidden) {
        _wrongTipsLabel.hidden = YES;
        for (UITextField *tf in _pzxView.textFieldArray) {
            tf.layer.borderColor = [UIColor grayColor].CGColor;
            tf.text = @"";
        }
    }
//调用获取支付验证码接口
    [[UIConstants sharedDataEngine] loadingAnimation];
    VipCardRequest *request = [[VipCardRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode", nil];
    [request requestPayOrderCodeWithVipCardParams:pagrams success:^(NSDictionary *_Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        getCodeBtnOfCW.enabled = YES;
        [getCodeBtnOfCW setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        getCodeBtnOfCW.layer.borderColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor].CGColor;
        getCodeBtnOfCW.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [getCodeBtnOfCW setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
        
        [_timer invalidate];
        _timer = nil;
        
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
        
    }];
}

- (void)beforeActivityMethodOfCodeView:(NSTimer *)time
{
    
    
    if (timeCount ==  0) {
        getCodeBtnOfCW.enabled = YES;
        [getCodeBtnOfCW setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        getCodeBtnOfCW.layer.borderColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor].CGColor;
        getCodeBtnOfCW.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
        [getCodeBtnOfCW setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
        
        [_timer invalidate];
        _timer = nil;
        
    }else {
        //倒计时显示
        NSString *countDownStr = @"";
        getCodeBtnOfCW.enabled = NO;
        if (timeCount < 0) {
            countDownStr = [NSString stringWithFormat:@"60s后重新发送"];
        }else{
            countDownStr = [NSString stringWithFormat:@"%ds后重新发送",timeCount];
        }
        [getCodeBtnOfCW setTitle:countDownStr forState:UIControlStateNormal];
        getCodeBtnOfCW.layer.borderColor = [UIColor colorWithHex:@"#b2b2b2"].CGColor;
        getCodeBtnOfCW.backgroundColor = [UIColor colorWithHex:@"#b2b2b2"];
        [getCodeBtnOfCW setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    }
    timeCount--;
}

- (void)btnOfCWClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClickOfCodeView)]) {
        [self.delegate backBtnClickOfCodeView];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGRect originRect = self.frame;
    originRect.origin.y = (kCommonScreenHeight-230-49)/2;
    self.frame = originRect;
    
    for (UITextField *tf in _pzxView.textFieldArray) {
        [tf resignFirstResponder];
    }    
}

//MARK: 手机号344格式
- (NSString *)formatPhoneNum:(NSString *)phoneNumStr {
    NSString *str1 = [phoneNumStr substringWithRange:NSMakeRange(0, 3)];
    NSString *str2 = [phoneNumStr substringWithRange:NSMakeRange(3, 4)];
    NSString *str3 = [phoneNumStr substringWithRange:NSMakeRange(7, 4)];
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@", str1, str2, str3];
    return str;
}


@end
