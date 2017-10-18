//
//  AccoutViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/2/20.
//  Copyright © 2017年 cias. All rights reserved.
//


#import "AccoutViewController.h"
#import <SDWebImage/SDImageCache.h>
#import "KKZTextUtility.h"
#import "UserResetPWPhoneView.h"
#import "UserResetPWCodeView.h"
#import "UserResetPWPasswordView.h"
#import "UserDefault.h"
#import "UserRequest.h"
#import "User.h"
#import "DataEngine.h"
#import "CIASActivityIndicatorView.h"

@interface AccoutViewController ()<UserResetPWPhoneViewDelegate,UserResetPWCodeViewDelegate,UserResetPWPasswordViewDelegate>
@property (nonatomic, strong) UIView * resetPWView;
@property (nonatomic, strong) UserResetPWPhoneView * resetPhoneView;
@property (nonatomic, strong) UserResetPWCodeView * resetCodeView;
@property (nonatomic, strong) UserResetPWPasswordView * resetPasswordView;

@property (nonatomic, strong) UIVisualEffectView * blurEffectView;

@end

@implementation AccoutViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
#if K_HENGDIAN
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"账户";
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //MARK: 添加设置view
    [self addAccountView];
    //最后添加浮层 75%透明度，颜色#000000
    [[UIApplication sharedApplication].keyWindow addSubview:self.blurEffectView];
}

- (void) addAccountView {
    //MARK: 清空缓存  点击事件
    CGFloat positionY = 0;
    if (self.resetPWView) {
        [self.resetPWView removeFromSuperview];
        self.resetPWView = nil;
    }
    self.resetPWView = [self viewForSettingWithTitleLabelStr:@"重置登录密码" withLabelStr:nil withPositionY:positionY];
    
    UITapGestureRecognizer *resetPWViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetPWViewBtnClick:)];
    [self.resetPWView addGestureRecognizer:resetPWViewSingleTap];
//    //MARK: 意见反馈
//    positionY += 44;
//    if (self.suggestView) {
//        [self.suggestView removeFromSuperview];
//        self.suggestView = nil;
//    }
//    self.suggestView = [self viewForSettingWithTitleLabelStr:@"意见反馈" withLabelStr:@"" withPositionY:positionY];
//    UITapGestureRecognizer *suggestViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suggestViewBtnClick:)];
//    [self.suggestView addGestureRecognizer:suggestViewSingleTap];
//    //MARK: 给个好评
//    positionY += 44;
//    if (self.commentView) {
//        [self.commentView removeFromSuperview];
//        self.commentView = nil;
//    }
//    self.commentView = [self viewForSettingWithTitleLabelStr:@"给个好评" withLabelStr:@"" withPositionY:positionY];
//    UITapGestureRecognizer *commentViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentViewBtnClick:)];
//    [self.commentView addGestureRecognizer:commentViewSingleTap];
//    //MARK: 拨打客服热线
//    positionY += 44;
//    if (self.customView) {
//        [self.customView removeFromSuperview];
//        self.customView = nil;
//    }
//    self.customView = [self viewForSettingWithTitleLabelStr:@"拨打客服热线" withLabelStr:kHotLineForDisplay withPositionY:positionY];
//    UITapGestureRecognizer *customViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(customViewBtnClick:)];
//    [self.customView addGestureRecognizer:customViewSingleTap];
//    
//    UIButton *signOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [signOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
//    signOutBtn.backgroundColor = [UIColor colorWithHex:@"#ffcc00"];
//    [signOutBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
//    signOutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    if (Constants.isAuthorized) {
//        signOutBtn.hidden = NO;
//    } else {
//        signOutBtn.hidden = YES;
//    }
//    [self.view addSubview:signOutBtn];
//    [signOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom).offset(0);
//        make.height.equalTo(@50);
//    }];
//    [signOutBtn addTarget:self action:@selector(signOutOfSetting) forControlEvents:UIControlEventTouchUpInside];
    
}

//MARK: 点击加载重置密码输入手机页面
- (void)resetPWViewBtnClick:(id)sender {
    //加载虚化浮层,这个浮层可以共用
    if (Constants.isAuthorized) {
        [UIView animateWithDuration:.2 animations:^{
            self.blurEffectView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
            
        } completion:^(BOOL finished) {
            //加载登录view
            //用于遮盖状态栏
            [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelAlert];
            [[UIApplication sharedApplication].keyWindow addSubview:self.resetPhoneView];
        }];
    }
}

//MARK: 重置密码输入手机页面根据手机号查询是否注册过，未注册提示去注册，已注册，发送验证码
- (void)userResetPWPhoneButtonClickWithAccount:(NSString *)account {
    USER_DEFAULT_RESETPWPHONE_WRITE(account);
    //MARK: 先校验手机号是否被注册，如果没有注册，则提示去注册
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:account forKey:@"phoneNumber"];
    UserRequest *request = [[UserRequest alloc] init];
    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    [request requestIsHaveRegisterParams:params success:^(NSDictionary * _Nullable data) {
        DLog(@"发送验证码成功：%@", data);
        User *user = (User *)data;
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        //1 不存在 2 存在
        if (user.refundResult.intValue == 1) {
            [[CIASAlertCancleView new] show:@"温馨提示" message:@"该用户尚未注册，快去注册吧" cancleTitle:@"知道了" callback:^(BOOL confirm) {
            }];
        } else {
            //MARK: 已注册，可以接收验证码，传手机号和验证码类型
            [[UIConstants sharedDataEngine] loadingAnimation];
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
            [params setValue:account forKey:@"phoneNumber"];
            //  MARK:  1为注册，2为忘记密码
            [params setValue:@"2" forKey:@"msgTypeId"];
            [request requestGetRegisterCodeParams:params success:^(NSDictionary * _Nullable data) {
                DLog(@"发送验证码成功：%@", data);
                timeCountOfAccount = 60;
                self.timerOfAccount = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethodOfAccount:) userInfo:nil repeats:YES];
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                
                if (weakSelf.resetPhoneView) {
                    [weakSelf.resetPhoneView removeFromSuperview];
                    weakSelf.resetPhoneView = nil;
                }
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.resetCodeView];
                
            } failure:^(NSError * _Nullable err) {
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                [CIASPublicUtility showMyAlertViewForTaskInfo:err];
            }];
        }
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

//MARK: 重置密码输入手机页面返回事件
- (void)backBtnClickOfResetPWPhoneView {
    USER_DEFAULT_RESETPWPHONE_WRITE(nil);
    [UIView animateWithDuration:.2 animations:^{
        //取消遮盖状态栏
        [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
        //隐藏背景视图，等待下次调用
        self.blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
        
        //移除resetPhoneView
        if (self.resetPhoneView) {
            [self.resetPhoneView removeFromSuperview];
            self.resetPhoneView = nil;
        }
    } completion:^(BOOL finished) {
    }];
}

//重置密码输入验证码页面，交验验证码事件
- (void)userOfResetPWCodeButtonClickWithAccount:(NSString *)account codeStr:(NSString *)codeStr {
    USER_DEFAULT_RESETCODE_WRITE(codeStr);
    if (self.timerOfAccount.isValid) {
        [self.timerOfAccount invalidate];
        self.timerOfAccount = nil;
    }

    //MARK: 先校验验证码是否正确，正确了才能跳转设置重置密码页面
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:account forKey:@"phoneNumber"];
    [params setValue:codeStr forKey:@"code"];
    //  MARK:  1为注册，2为忘记密码
    [params setValue:@"2" forKey:@"msgTypeId"];
    
    UserRequest *request = [[UserRequest alloc] init];
    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    [request requestValidRegisterCodeParams:params success:^(NSDictionary * _Nullable data) {
        DLog(@"发送验证码成功：%@", data);
        
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        //MARK: 重置密码
        if (weakSelf.resetCodeView) {
            [weakSelf.resetCodeView removeFromSuperview];
            weakSelf.resetCodeView = nil;
        }
        if (self.timerOfAccount.isValid) {
            [self.timerOfAccount invalidate];
            self.timerOfAccount = nil;
        }
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.resetPasswordView];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}
- (void) backBtnClickTOResetPWPhoneView{
    if (self.timerOfAccount.isValid) {
        [self.timerOfAccount invalidate];
        self.timerOfAccount = nil;
    }
    if (self.resetCodeView) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.resetPhoneView];
        self.resetPhoneView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
        
        [UIView animateWithDuration:0.25 animations:^{
            self.resetPhoneView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
            self.resetCodeView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
            
        } completion:^(BOOL finished) {
            self.resetCodeView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
            [self.resetCodeView removeFromSuperview];
            self.resetCodeView = nil;
        }];
        
    }

}

//MARK: 重置密码输入验证码页面返回事件
- (void) backBtnClickOfResetPWCodeView {
    USER_DEFAULT_RESETCODE_WRITE(nil);
    if (self.timerOfAccount.isValid) {
        [self.timerOfAccount invalidate];
        self.timerOfAccount = nil;
    }

    [UIView animateWithDuration:.2 animations:^{
        //取消遮盖状态栏
        [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
        //隐藏背景视图，等待下次调用
        self.blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
        
        //移除resetCodeView
        if (self.resetCodeView) {
            [self.resetCodeView removeFromSuperview];
            self.resetCodeView = nil;
        }
        if (self.timerOfAccount.isValid) {
            [self.timerOfAccount invalidate];
            self.timerOfAccount = nil;
        }
    } completion:^(BOOL finished) {
    }];
}


//MARK: 重置密码校验密码页面 校验密码事件
- (void)userResetPWPasswordButtonClickWithAccount:(NSString *)account passWord:(NSString *)password {
    //MARK: 先校验验证码是否正确，正确了才能修改密码并重新登录
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:account forKey:@"phoneNumber"];
    [params setValue:USER_DEFAULT_RESETCODE forKey:@"code"];
    [params setValue:password forKey:@"password"];
    //  MARK:  1为注册，2为忘记密码
    [params setValue:@"2" forKey:@"msgTypeId"];
    
    UserRequest *request = [[UserRequest alloc] init];
    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    [request requestResetPasswordParams:params success:^(NSDictionary * _Nullable data) {
        
        DLog(@"发送验证码成功：%@", data);
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        //MARK: 重置密码
        //移除forgetResetView
        if (weakSelf.resetPasswordView) {
            [weakSelf.resetPasswordView removeFromSuperview];
            weakSelf.resetPasswordView = nil;
        }
        [UIView animateWithDuration:.2 animations:^{
            //取消遮盖状态栏
            USER_DEFAULT_RESETCODE_WRITE(nil);
            USER_DEFAULT_RESETPWPHONE_WRITE(nil);
            [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
            //隐藏背景视图，等待下次调用
            weakSelf.blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
        } completion:^(BOOL finished) {
        }];
        [weakSelf userLoginInResetPWWithAccount:account password:password isFromRegister:NO];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

- (void)beforeActivityMethodOfAccount:(NSTimer *)time {
    timeCountOfAccount--;
    [self.resetCodeView updateCodeInputViewWithTime:timeCountOfAccount];
    if (timeCountOfAccount ==  0) {
        /*
        [[CIASAlertVIew new] show:@"" message:@"未收到验证码或总是输入错怎么办？" image:nil cancleTitle:@"再试试" otherTitle:@"重新获取" callback:^(BOOL confirm) {
            if (confirm) {
                [[UIConstants sharedDataEngine] loadingAnimation];
                UserRequest *request = [[UserRequest alloc] init];
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
                [params setValue:USER_DEFAULT_RESETPWPHONE forKey:@"phoneNumber"];
                //  MARK:  1为注册，2为忘记密码
                [params setValue:@"2" forKey:@"msgTypeId"];
                __weak __typeof(self) weakSelf = self;
                [request requestGetRegisterCodeParams:params success:^(NSDictionary * _Nullable data) {
                    DLog(@"发送验证码成功：%@", data);
                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                    
                } failure:^(NSError * _Nullable err) {
                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                    [CIASPublicUtility showMyAlertViewForTaskInfo:err];
                }];
            }
        }];
         */
        [self.timerOfAccount invalidate];
        self.timerOfAccount = nil;
        
    }else {
    }
}

//MARK: -- 登录
- (void) userLoginInResetPWWithAccount:(NSString *)account password:(NSString *)pw isFromRegister:(BOOL)isFromRegister {
    //MARK: 登录按钮点击请求
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:account forKey:@"phoneNumber"];
    [params setValue:pw forKey:@"password"];
    UserRequest *request = [[UserRequest alloc] init];
    [[UIConstants sharedDataEngine] loadingAnimation];
    [request requestLoginParams:params success:^(User * _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        User *user = (User *)data;
        [self savePersonArrayData:user];
        [[DataEngine sharedDataEngine] loginSucceededWithSession:user.accountToken userId:[NSString stringWithFormat:@"%d",user.userId.intValue] userName:user.phoneNumber];
        //下发通知，更改个人中心页面
        if (isFromRegister) {
            NSDictionary *dic = @{@"data":data,@"isFromRegister":@"YES"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"handleLoginViewSuccess" object:nil userInfo:dic];
        } else {
            NSDictionary *dic = @{@"data":data,@"isFromRegister":@"NO"};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"handleLoginViewSuccess" object:nil userInfo:dic];
        }
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
    
}

- (void)savePersonArrayData:(User *)personObject {
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:personObject];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfoMData"];
}

//MARK: 重置密码输入密码页面 返回事件
- (void)backBtnClickOfResetPWPasswordView {
    USER_DEFAULT_RESETCODE_WRITE(nil);
    USER_DEFAULT_RESETPWPHONE_WRITE(nil);
    [UIView animateWithDuration:.2 animations:^{
        //取消遮盖状态栏
        [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
        //隐藏背景视图，等待下次调用
        self.blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
        
        //移除resetPasswordView
        if (self.resetPasswordView) {
            [self.resetPasswordView removeFromSuperview];
            self.resetPasswordView = nil;
        }
    } completion:^(BOOL finished) {
    }];
}



- (UserResetPWCodeView *) resetCodeView {
    if (!_resetCodeView) {
        _resetCodeView = [[UserResetPWCodeView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight) delegate:self];
    }
    return _resetCodeView;
}

- (UserResetPWPhoneView *)resetPhoneView {
    if (!_resetPhoneView) {
        _resetPhoneView = [[UserResetPWPhoneView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight) delegate:self];
    }
    return _resetPhoneView;
}

- (UserResetPWPasswordView *) resetPasswordView {
    if (!_resetPasswordView) {
        _resetPasswordView = [[UserResetPWPasswordView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight) delegate:self];
    }
    return _resetPasswordView;
}

- (UIVisualEffectView *)blurEffectView {
    if (!_blurEffectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
        _blurEffectView.backgroundColor = [UIColor colorWithHex:@"#000000"];
        _blurEffectView.alpha = 0.75;
    }
    return _blurEffectView;
}

#pragma mark -- 可复用的视图

- (UIView *) viewForSettingWithTitleLabelStr:(NSString *)titleLabelstr withLabelStr:(NSString *)labelStr withPositionY:(CGFloat)positionY {
    UIView *viewForSet = [[UIView alloc] init];
    viewForSet.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    viewForSet.userInteractionEnabled = YES;
    [self.view addSubview:viewForSet];
    [viewForSet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(positionY);
        make.height.equalTo(@(44));
    }];
    
    UILabel *titleLabelOfSet = [KKZTextUtility getLabelWithText:titleLabelstr font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
    [viewForSet addSubview:titleLabelOfSet];
    CGSize titleLabelStrSize = [KKZTextUtility measureText:titleLabelstr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    [titleLabelOfSet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(viewForSet.mas_left).offset(15);
        make.top.equalTo(viewForSet.mas_top).offset((44-titleLabelStrSize.height)/2);
        make.size.mas_equalTo(CGSizeMake(titleLabelStrSize.width + 5, titleLabelStrSize.height));
    }];
    
    UIImage *imageOfSet = [UIImage imageNamed:@"home_more"];
    
    if (labelStr.length > 0) {
        UILabel *labelOfSet = [KKZTextUtility getLabelWithText:labelStr font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
        [viewForSet addSubview:labelOfSet];
        CGSize labelStrSize = [KKZTextUtility measureText:labelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
        [labelOfSet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewForSet.mas_top).offset((44-labelStrSize.height)/2);
            make.right.equalTo(viewForSet.mas_right).offset(-(9+imageOfSet.size.width+15));
            make.size.mas_equalTo(CGSizeMake(labelStrSize.width+6, labelStrSize.height));
        }];
    }
    
    UIImageView *imageViewOfSet = [[UIImageView alloc] init];
    [viewForSet addSubview:imageViewOfSet];
    imageViewOfSet.image = imageOfSet;
    imageViewOfSet.contentMode = UIViewContentModeScaleAspectFill;
    [imageViewOfSet mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForSet.mas_top).offset((44-imageOfSet.size.height)/2);
        make.right.equalTo(viewForSet.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(imageOfSet.size.width, imageOfSet.size.height));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [viewForSet addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(viewForSet);
        make.top.equalTo(viewForSet.mas_top).offset(43);
        make.height.equalTo(@(1));
    }];
    
    return viewForSet;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
