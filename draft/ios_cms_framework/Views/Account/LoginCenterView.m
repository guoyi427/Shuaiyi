//
//  LoginCenterView.m
//  CIASMovie
//
//  Created by avatar on 2017/3/30.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "LoginCenterView.h"
#import "UserLoginView.h"
#import "UserRegisterCodeView.h"
#import "UserRegisterPhoneView.h"
#import "UserForgetPWPhoneView.h"
#import "UserForgetPWCodeView.h"
#import "UserForgetResetPWView.h"
#import "UserRegisterSetPWView.h"
#import "UserDefault.h"
#import "UserRequest.h"
#import "User.h"
#import "DataEngine.h"
#import "UserRequest.h"
#import "UserLogin.h"

@interface LoginCenterView ()  <UserLoginViewDelegate,UserRegisterPhoneViewDelegate,UserRegisterCodeViewDelegate,UserForgetPWPhoneViewDelegate,UserForgetPWCodeViewDelegate,UserForgetResetPWViewDelegate,UserRegisterSetPWViewDelegate>
{
    //  wechat login
    NSString *_accessToken;
    NSString *_openId;
    NSString *_unionId;
    
}

@property (nonatomic, strong) UserLoginView         * loginView;
@property (nonatomic, strong) UserRegisterPhoneView * registerPhoneView;
@property (nonatomic, strong) UserRegisterCodeView  * registerCodeView;
@property (nonatomic, strong) UserForgetPWPhoneView * forgetPhoneView;
@property (nonatomic, strong) UserForgetPWCodeView  * forgetCodeView;
@property (nonatomic, strong) UserForgetResetPWView * forgetResetView;
@property (nonatomic, strong) UserRegisterSetPWView * registerSetPWView;
@property (nonatomic, strong) UIVisualEffectView    * blurEffectView;


@end

@implementation LoginCenterView

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"blurEffectViewBackgroundColor" object:nil];
}

- (id)initWithFrame:(CGRect)frame withIsCancelView:(BOOL)isCancelView delegate:(id<LoginCenterViewDelegate>)aDelegate {
    if (self = [super initWithFrame:frame]) {
        self.delegate = aDelegate;
        self.backgroundColor = [UIColor clearColor];
        self.isCancel = isCancelView;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangehangeBackGroundColor:) name:@"blurEffectViewBackgroundColor" object:nil];
        
        
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
            make.height.mas_equalTo(kCommonScreenHeight*1.2);
        }];
        
        //加载虚化浮层,这个浮层可以共用
        //最后添加浮层 75%透明度，颜色#000000
        [self addSubview:self.blurEffectView];
        //加载登录view
        //用于遮盖状态栏
        [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelAlert];
        self.loginView.wechatState = false;
        [self addSubview:self.loginView];
        [self.loginView updateStateToBind:self.isWechatBind];

    }
    return self;
}

- (void)savePersonArrayData:(User *)personObject {
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:personObject];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfoMData"];
}
//MARK: userLoginView Delegate
- (void) userLoginButtonClickWithAccount:(NSString *)account password:(NSString *)pw isFromRegister:(BOOL)isFromRegister{
    //MARK: 登录按钮点击请求
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:account forKey:@"phoneNumber"];
    [params setValue:pw forKey:@"password"];
    UserRequest *request = [[UserRequest alloc] init];
    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    /*
    [request requestLoginParams:params success:^(User * _Nullable data) {
        [weakSelf loginSuccessWithData:data isFromRegister:isFromRegister];
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        weakSelf.loginView.wechatState = false;
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.loginView];
        [self.loginView updateStateToBind:self.isWechatBind];

        weakSelf.blurEffectView.backgroundColor = [UIColor colorWithHex:@"#cc3300"];
        weakSelf.loginView.wrongTipsView.hidden = NO;
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
    */
    [request login:account password:pw site:SiteTypeKKZ success:^(UserLogin * _Nullable userLogin) {
        User *data = [[User alloc] init];
        data.nickName = userLogin.nickName;
        data.phoneNumber = userLogin.userName;
        data.accountToken = userLogin.lastSession;
        
        [weakSelf loginSuccessWithData:data isFromRegister:isFromRegister];
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        weakSelf.loginView.wechatState = false;
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.loginView];
        [self.loginView updateStateToBind:self.isWechatBind];
        
        weakSelf.blurEffectView.backgroundColor = [UIColor colorWithHex:@"#cc3300"];
        weakSelf.loginView.wrongTipsView.hidden = NO;
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

/**
 微信登录
 
 @param code 微信code
 */
- (void) wxLoginWithCode:(NSString *)code {
    UserRequest *req = [[UserRequest alloc] init];
    
    __weak LoginCenterView *weakSelf = self;
    [req wechatLoginWithCode:code success:^(User * _Nullable data) {
        //微信已经绑定手机号，调用登录方法
        [weakSelf loginSuccessWithData:data isFromRegister:false];
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        if (err.code == 30009) {
            //  status = 30009 微信需要绑定或注册无密用户 需要绑定手机号 调到绑定手机号界面（和忘记密码界面是一个）
            NSDictionary *data = [[err.userInfo kkz_objForKey:@"kkz.error.response"] kkz_objForKey:@"data"];
            if (data) {
                _accessToken = [data kkz_stringForKey:@"accessToken"];
                _openId = [data kkz_stringForKey:@"openId"];
                _unionId = [data kkz_stringForKey:@"unionId"];
                
                //  加载绑定手机号页面（忘记密码页面）
                weakSelf.blurEffectView.backgroundColor = [UIColor colorWithHex:@"#000000"];
                weakSelf.loginView.wrongTipsView.hidden = YES;
                weakSelf.isWechatBind = YES;
//                [weakSelf.forgetPhoneView updateStateToBind:weakSelf.isWechatBind];
                [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.registerPhoneView];
                [weakSelf.registerPhoneView updateStateToBind:weakSelf.isWechatBind];
                weakSelf.registerPhoneView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.registerPhoneView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
                    weakSelf.loginView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
                } completion:^(BOOL finished) {
                    if (weakSelf.loginView) {
                        [weakSelf.loginView removeFromSuperview];
                        weakSelf.loginView = nil;
                    }
                    weakSelf.loginView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
                }];
            }
        } else {
            [CIASPublicUtility showMyAlertViewForTaskInfo:err];
        }
    }];
}

//  微信绑定并登录
- (void)wechatBindAndLoginWithAccount:(NSString *)account password:(NSString *)password {
    UserRequest *req = [[UserRequest alloc] init];
    __weak LoginCenterView *weakSelf = self;
    [req wechatLoginAndBindWithPhoneNumber:account password:password unionId:_unionId success:^(User * _Nullable data) {
        [weakSelf loginSuccessWithData:data isFromRegister:false];
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

//  登录完成
- (void)loginSuccessWithData:(User *)data isFromRegister:(BOOL)isFromRegister {
    [[UIConstants sharedDataEngine] stopLoadingAnimation];
    //        DLog(@"data %@",data);
    User *user = (User *)data;
    [self savePersonArrayData:user];
    
    [[DataEngine sharedDataEngine] loginSucceededWithSession:user.accountToken userId:[NSString stringWithFormat:@"%d",user.userId.intValue] userName:user.phoneNumber];
    //        DLog(@"%@", [DataEngine sharedDataEngine].sessionId);
    //下发通知，更改个人中心页面
    if (isFromRegister) {
        NSDictionary *dic = @{@"data":data,@"isFromRegister":@"YES"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"handleLoginViewSuccess" object:nil userInfo:dic];
    } else {
        NSDictionary *dic = @{@"data":data,@"isFromRegister":@"NO"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"handleLoginViewSuccess" object:nil userInfo:dic];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(newAccountDidFinishLogin)]) {
        [self.delegate newAccountDidFinishLogin];
    }
    
    [UIView animateWithDuration:.2 animations:^{
        //取消遮盖状态栏
        USER_DEFAULT_REGISTERCODE_WRITE(nil);
        [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
        //隐藏背景视图，等待下次调用
        //            weakSelf.blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
        if (self.blurEffectView.superview) {
            [_blurEffectView removeFromSuperview];
        }
        //移除registerCodeView
        if (self.loginView) {
            [self.loginView removeFromSuperview];
            self.loginView = nil;
        }
        if (self.registerCodeView) {
            [self.registerCodeView removeFromSuperview];
            self.registerCodeView = nil;
        }
        [self backFromLoginCenterView];
        
    } completion:^(BOOL finished) {
    }];
}

- (void) shouldChangehangeBackGroundColor:(NSNotification *)notification {
    BOOL isCanChangeBackgroundColor = [notification object];
    if (isCanChangeBackgroundColor) {
        self.blurEffectView.backgroundColor = [UIColor colorWithHex:@"#000000"];
    }
}

- (void) backFromLoginCenterView {
    if (self.subviews.count>0) {
        for (UIView * view in self.subviews) {
            [view removeFromSuperview];
        }
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(backBtnClickOfLoginCenterView)]) {
    //        [self.delegate respondsToSelector:@selector(backBtnClickOfLoginCenterView)];
    //    }
}

#pragma mark -- 登陆页面点击事件 代理方法
//MARK: 注册页面
- (void) userRegisterButtonClick {
    //加载注册页面
    self.blurEffectView.backgroundColor = [UIColor colorWithHex:@"#000000"];
    self.loginView.wrongTipsView.hidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.registerPhoneView];
    [self.registerPhoneView updateStateToBind:self.isWechatBind];
    self.registerPhoneView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.registerPhoneView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
        self.loginView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
    } completion:^(BOOL finished) {
        self.loginView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
        if (self.loginView) {
            [self.loginView removeFromSuperview];
            self.loginView = nil;
        }
    }];
    
}
//MARK: 忘记密码
- (void) forgetPasswordButtonClick {
    //加载忘记密码页面
    self.blurEffectView.backgroundColor = [UIColor colorWithHex:@"#000000"];
    self.loginView.wrongTipsView.hidden = YES;
//    [self.forgetPhoneView updateStateToBind:false];
    [[UIApplication sharedApplication].keyWindow addSubview:self.forgetPhoneView];
    self.forgetPhoneView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
    [UIView animateWithDuration:0.25 animations:^{
        self.forgetPhoneView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
        self.loginView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
    } completion:^(BOOL finished) {
        self.loginView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
        if (self.loginView) {
            [self.loginView removeFromSuperview];
            self.loginView = nil;
        }
    }];
}

//MARK: UserLoginViewDelegate
- (void) backBtnClickOfLoginView {
    if (self.isCancel) {
        [UIView animateWithDuration:.2 animations:^{
            //取消遮盖状态栏
            [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
            //隐藏背景视图，等待下次调用
            
            self.blurEffectView.frame = CGRectMake(0, kCommonScreenHeight, CGRectGetWidth(self.blurEffectView.frame), CGRectGetHeight(self.blurEffectView.frame));
            self.loginView.frame = CGRectMake(0, kCommonScreenHeight, CGRectGetWidth(self.loginView.frame), CGRectGetHeight(self.loginView.frame));
            
        } completion:^(BOOL finished) {
            self.blurEffectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.blurEffectView.frame), CGRectGetHeight(self.blurEffectView.frame));
            self.loginView.frame = CGRectMake(0, 0, CGRectGetWidth(self.loginView.frame), CGRectGetHeight(self.loginView.frame));
            
            if (self.blurEffectView.superview) {
                [_blurEffectView removeFromSuperview];
            }
            //移除loginview
            if (_loginView) {
                [_loginView removeFromSuperview];
            }
            [self backFromLoginCenterView];
        }];
    } else {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"请您先登录" cancleTitle:@"好的" callback:^(BOOL confirm) {
        }];
    }
    
}

#pragma mark -- 注册 手机号页面 点击事件 代理方法
- (void) userGetCodeButtonClickWithAccount:(NSString *)account {
    USER_DEFAULT_REGISTERPHONE_WRITE(account);
    //MARK: 这里添加 ----发送验证码的服务器请求
    DLog(@"注册手机号：%@", account);
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:account forKey:@"phoneNumber"];
    UserRequest *request = [[UserRequest alloc] init];
    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    //先检查手机号是否注册
    [request requestIsHaveRegisterParams:params success:^(NSDictionary * _Nullable data) {
        DLog(@"发送验证码成功：%@", data);
        User *user = (User *)data;
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        if (user.refundResult.intValue == 1) {
            //1 手机号没有注册 发送验证码
            //MARK: 未注册，可以接收验证码，传手机号和验证码类型
            [[UIConstants sharedDataEngine] loadingAnimation];
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
            [params setValue:account forKey:@"phoneNumber"];
            //  MARK:  1为注册，2为忘记密码
            [params setValue:@"1" forKey:@"msgTypeId"];
            [request requestGetRegisterCodeParams:params success:^(NSDictionary * _Nullable data) {
                DLog(@"发送验证码成功：%@", data);
                timeCountOfRegister = 60;
                self.timerOfRegister = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethodOfRegister:) userInfo:nil repeats:YES];
                //MARK: 该用户尚未注册
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                
                if (!weakSelf.registerCodeView.superview) {
                    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.registerCodeView];
                }
                [weakSelf.registerCodeView updateStateToBind:weakSelf.isWechatBind];
                weakSelf.registerCodeView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.registerCodeView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
                    weakSelf.registerPhoneView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
                } completion:^(BOOL finished) {
                    weakSelf.registerPhoneView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
                    if (weakSelf.registerPhoneView.superview) {
                        [weakSelf.registerPhoneView removeFromSuperview];
                        weakSelf.registerPhoneView = nil;
                    }
                }];
                
            } failure:^(NSError * _Nullable err) {
                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                [CIASPublicUtility showMyAlertViewForTaskInfo:err];
            }];
            
        } else {
            //此手机号已经注册过，请登录
            /*
             [[CIASAlertCancleView new] show:@"温馨提示" message:@"此号码已经注册过，请确认填写正确，或者尝试找回密码" cancleTitle:@"知道了" callback:^(BOOL confirm) {
             }];
             */
            weakSelf.registerPhoneView.wrongTipsView.hidden = NO;
            self.blurEffectView.backgroundColor = [UIColor colorWithHex:@"#cc3300"];
            [weakSelf.registerPhoneView updateErrorStatus:true];
        }
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
    
    
}

- (void)beforeActivityMethodOfRegister:(NSTimer *)time {
    timeCountOfRegister--;
    //  验证码倒计时，更新验证码页面倒计时数字
    [self.registerCodeView updateCodeInputViewWithTime:timeCountOfRegister];
    
    if (timeCountOfRegister ==  0) {/*
                                     [[CIASAlertVIew new] show:@"" message:@"未收到验证码或总是输入错怎么办？" image:nil cancleTitle:@"再试试" otherTitle:@"重新获取" callback:^(BOOL confirm) {
                                     if (confirm) {
                                     [[UIConstants sharedDataEngine] loadingAnimation];
                                     UserRequest *request = [[UserRequest alloc] init];
                                     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
                                     [params setValue:USER_DEFAULT_REGISTERPHONE forKey:@"phoneNumber"];
                                     //  MARK:  1为注册，2为忘记密码
                                     [params setValue:@"1" forKey:@"msgTypeId"];
                                     [request requestGetRegisterCodeParams:params success:^(NSDictionary * _Nullable data) {
                                     [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                     
                                     } failure:^(NSError * _Nullable err) {
                                     [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                     [CIASPublicUtility showMyAlertViewForTaskInfo:err];
                                     }];
                                     }
                                     }];*/
        [self.timerOfRegister invalidate];
        self.timerOfRegister = nil;
        
    }else {
        
    }
}

- (void) gotoLoginViewButtonClick {
    
    self.loginView.wechatState = self.isWechatBind;
    self.loginView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:self.loginView];
    [self.loginView updateStateToBind:self.isWechatBind];
    [UIView animateWithDuration:0.25 animations:^{
        self.registerPhoneView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
        self.loginView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
    } completion:^(BOOL finished) {
        if (self.registerPhoneView) {
            [self.registerPhoneView removeFromSuperview];
            self.registerPhoneView = nil;
        }
        self.registerPhoneView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
    }];
}
- (void) backBtnClickOfRegisterView {
    if (self.isCancel) {
        [UIView animateWithDuration:.25 animations:^{
            //取消遮盖状态栏
            [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
            //隐藏背景视图，等待下次调用
            //        self.blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
            self.blurEffectView.frame = CGRectMake(0, kCommonScreenHeight, CGRectGetWidth(self.blurEffectView.frame), CGRectGetHeight(self.blurEffectView.frame));
            self.registerPhoneView.frame = CGRectMake(0, kCommonScreenHeight, CGRectGetWidth(self.registerPhoneView.frame), CGRectGetHeight(self.registerPhoneView.frame));

        } completion:^(BOOL finished) {
            self.blurEffectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.blurEffectView.frame), CGRectGetHeight(self.blurEffectView.frame));
            self.registerPhoneView.frame = CGRectMake(0, 0, CGRectGetWidth(self.registerPhoneView.frame), CGRectGetHeight(self.registerPhoneView.frame));
            
            self.blurEffectView.backgroundColor = [UIColor colorWithHex:@"#000000"];
            if (self.blurEffectView.superview) {
                [_blurEffectView removeFromSuperview];
            }
            //移除registerPhoneView
            if (self.registerPhoneView) {
                [self.registerPhoneView removeFromSuperview];
                self.registerPhoneView = nil;
            }
            [self backFromLoginCenterView];
        }];
    } else {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"请您先注册" cancleTitle:@"好的" callback:^(BOOL confirm) {
        }];
    }
    
}

#pragma mark -- 注册验证码页面 下一步
- (void) userRegisterButtonClickWithAccount:(NSString *)account codeStr:(NSString *)codeStr {
    USER_DEFAULT_REGISTERCODE_WRITE(codeStr);
    //MARK: 先校验验证码是否正确，正确了才能跳转设置注册密码页面
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:account forKey:@"phoneNumber"];
    [params setValue:codeStr forKey:@"code"];
    //  MARK:  1为注册，2为忘记密码
    [params setValue:@"1" forKey:@"msgTypeId"];
    
    UserRequest *request = [[UserRequest alloc] init];
    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    [request requestValidRegisterCodeParams:params success:^(NSDictionary * _Nullable data) {
        DLog(@"校验验证码成功：%@", data);
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        //MARK: 设置注册密码
        if (weakSelf.timerOfRegister.isValid) {
            [weakSelf.timerOfRegister invalidate];
            weakSelf.timerOfRegister = nil;
        }
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.registerSetPWView];
        weakSelf.registerSetPWView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.registerSetPWView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
            weakSelf.registerCodeView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
        } completion:^(BOOL finished) {
            weakSelf.registerCodeView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
            if (weakSelf.registerCodeView) {
                [weakSelf.registerCodeView removeFromSuperview];
                weakSelf.registerCodeView = nil;
            }
        }];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
    
    
}
//注册获取验证码，上一步   返回到注册输入手机号界面
- (void) gotoLoginViewOfGetCodeViewButtonClick {
    if (self.timerOfRegister.isValid) {
        [self.timerOfRegister invalidate];
        self.timerOfRegister = nil;
    }

    if (self.registerCodeView) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.registerPhoneView];
        [self.registerPhoneView updateStateToBind:self.isWechatBind];
        self.registerPhoneView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
        
        [UIView animateWithDuration:0.25 animations:^{
            self.registerPhoneView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
            self.registerCodeView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
            
        } completion:^(BOOL finished) {
            self.registerCodeView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
            [self.registerCodeView removeFromSuperview];
            self.registerCodeView = nil;
        }];
        
    } else if (self.timerOfRegister.isValid) {
        [self.timerOfRegister invalidate];
        self.timerOfRegister = nil;
        self.loginView.wechatState = false;
        [[UIApplication sharedApplication].keyWindow addSubview:self.loginView];
        [self.loginView updateStateToBind:self.isWechatBind];
    }
    
}
- (void) backBtnClickOfGetCodeView {
    if (self.timerOfRegister.isValid) {
        [self.timerOfRegister invalidate];
        self.timerOfRegister = nil;
    }

    if (self.isCancel) {
        [UIView animateWithDuration:.2 animations:^{
            //取消遮盖状态栏
            USER_DEFAULT_REGISTERPHONE_WRITE(nil);
            [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
            //隐藏背景视图，等待下次调用
            //        self.blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
            self.blurEffectView.frame = CGRectMake(0, kCommonScreenHeight, CGRectGetWidth(self.blurEffectView.frame), CGRectGetHeight(self.blurEffectView.frame));
            self.registerCodeView.frame = CGRectMake(0, kCommonScreenHeight, CGRectGetWidth(self.registerCodeView.frame), CGRectGetHeight(self.registerCodeView.frame));
            
        } completion:^(BOOL finished) {
            self.blurEffectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.blurEffectView.frame), CGRectGetHeight(self.blurEffectView.frame));
            self.registerCodeView.frame = CGRectMake(0, 0, CGRectGetWidth(self.registerCodeView.frame), CGRectGetHeight(self.registerCodeView.frame));
            
            self.blurEffectView.backgroundColor = [UIColor colorWithHex:@"#000000"];
            if (self.blurEffectView.superview) {
                [_blurEffectView removeFromSuperview];
            }
            //移除registerCodeView
            if (self.registerCodeView) {
                [self.registerCodeView removeFromSuperview];
                self.registerCodeView = nil;
            }
            if (self.timerOfRegister.isValid) {
                [self.timerOfRegister invalidate];
                self.timerOfRegister = nil;
            }
            [self backFromLoginCenterView];
        }];
    } else {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"请您先输入验证码" cancleTitle:@"好的" callback:^(BOOL confirm) {
        }];
    }
    
}

#pragma mark -- 设置注册密码页面
- (void) userSetRegisterPWButtonClickWithAccount:(NSString *)account passWord:(NSString *)password {
    //MARK: 注册之后进行登录
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:account forKey:@"phoneNumber"];
    [params setValue:USER_DEFAULT_REGISTERCODE forKey:@"code"];
    //  MARK:  1-web,2-ios,3-android,4-h5
    [params setValue:@"2" forKey:@"registrySource"];
    [params setValue:password forKey:@"password"];
    
    UserRequest *request = [[UserRequest alloc] init];
    [[UIConstants sharedDataEngine] loadingAnimation];
    __weak __typeof(self) weakSelf = self;
    [request requestRegisterParams:params success:^(NSDictionary * _Nullable data) {
        DLog(@"注册成功：%@", data);
        if (weakSelf.registerSetPWView) {
            [weakSelf.registerSetPWView removeFromSuperview];
            weakSelf.registerSetPWView = nil;
            [weakSelf userLoginButtonClickWithAccount:account password:password isFromRegister:YES];
        }
        
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

#pragma mark -- 忘记密码填写手机号 下一步
- (void) userGetCodeOfPWButtonClickWithAccount:(NSString *)account wechatBindPhoneState:(BOOL)isWechat{
    USER_DEFAULT_FORGETPWPHONE_WRITE(account);
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
        //1 手机号不存在
        if (user.refundResult.intValue == 1) {
            if (isWechat) {
                //微信绑定账号 按照注册流程来  发送验证码  输入验证码直接调用微信联合注册接口

                
                [[UIConstants sharedDataEngine] loadingAnimation];
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
                [params setValue:account forKey:@"phoneNumber"];
                //  MARK:  1为注册，2为忘记密码
                [params setValue:@"1" forKey:@"msgTypeId"];
                [request requestGetRegisterCodeParams:params success:^(NSDictionary * _Nullable data) {
                    DLog(@"发送验证码成功：%@", data);
                    timeCountOfForget = 60;
                    weakSelf.timerOfForget = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethodOfForget:) userInfo:nil repeats:YES];
                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.forgetCodeView];
                    weakSelf.forgetCodeView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
                    [UIView animateWithDuration:0.25 animations:^{
                        weakSelf.forgetCodeView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
                        weakSelf.forgetPhoneView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
                    } completion:^(BOOL finished) {
                        weakSelf.forgetPhoneView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
                        if (weakSelf.forgetPhoneView) {
//                            [weakSelf.forgetCodeView updateStateToBind:weakSelf.isWechatBind];
                            [weakSelf.forgetPhoneView removeFromSuperview];
                            weakSelf.forgetPhoneView = nil;
                        }
                    }];
                    
                } failure:^(NSError * _Nullable err) {
                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                    [CIASPublicUtility showMyAlertViewForTaskInfo:err];
                }];
            

                
            }else{
                //忘记密码界面提示
                [[CIASAlertCancleView new] show:@"温馨提示" message:@"该用户尚未注册，快去注册吧" cancleTitle:@"知道了" callback:^(BOOL confirm) {
                }];
            }
            
        } else {
           // 2 手机号存在
            if (isWechat) {
                //如果是微信登录  弹出提示就可以
                [[CIASAlertCancleView new] show:@"温馨提示" message:@"已存在相关此手机号的账户，请尝试登录" cancleTitle:@"知道了" callback:^(BOOL confirm) {
                }];
            }else{
                //忘记密码---获取验证码
                //MARK: 已注册，可以接收验证码，传手机号和验证码类型
                [[UIConstants sharedDataEngine] loadingAnimation];
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
                [params setValue:account forKey:@"phoneNumber"];
                //  MARK:  1为注册，2为忘记密码
                [params setValue:@"2" forKey:@"msgTypeId"];
                [request requestGetRegisterCodeParams:params success:^(NSDictionary * _Nullable data) {
                    DLog(@"发送验证码成功：%@", data);
                    timeCountOfForget = 60;
                    weakSelf.timerOfForget = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethodOfForget:) userInfo:nil repeats:YES];
                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.forgetCodeView];
                    weakSelf.forgetCodeView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
                    [UIView animateWithDuration:0.25 animations:^{
                        weakSelf.forgetCodeView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
                        weakSelf.forgetPhoneView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
                    } completion:^(BOOL finished) {
                        weakSelf.forgetPhoneView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
                        if (weakSelf.forgetPhoneView) {
//                            [weakSelf.forgetCodeView updateStateToBind:weakSelf.isWechatBind];
                            [weakSelf.forgetPhoneView removeFromSuperview];
                            weakSelf.forgetPhoneView = nil;
                        }
                    }];
                    
                } failure:^(NSError * _Nullable err) {
                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                    [CIASPublicUtility showMyAlertViewForTaskInfo:err];
                }];
            }
            
        }
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
    
}


- (void)beforeActivityMethodOfForget:(NSTimer *)time {
    timeCountOfForget--;
    [self.forgetCodeView updateCodeInputViewWithTime:timeCountOfForget];
    
    if (timeCountOfForget ==  0) {
//        [[CIASAlertVIew new] show:@"" message:@"未收到验证码或总是输入错怎么办？" image:nil cancleTitle:@"再试试" otherTitle:@"重新获取" callback:^(BOOL confirm) {
//            if (confirm) {
//                [[UIConstants sharedDataEngine] loadingAnimation];
//                UserRequest *request = [[UserRequest alloc] init];
//                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
//                [params setValue:USER_DEFAULT_FORGETPWPHONE forKey:@"phoneNumber"];
//                //  MARK:  1为注册，2为忘记密码
//                [params setValue:@"2" forKey:@"msgTypeId"];
//                [request requestGetRegisterCodeParams:params success:^(NSDictionary * _Nullable data) {
//                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
//                    
//                } failure:^(NSError * _Nullable err) {
//                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
//                    [CIASPublicUtility showMyAlertViewForTaskInfo:err];
//                }];
//            }
//        }];
        [self.timerOfForget invalidate];
        self.timerOfForget = nil;
        
    }else {
    }
}



- (void) gotoLoginViewOfPWButtonClick {
    self.loginView.wechatState = false;
    [[UIApplication sharedApplication].keyWindow addSubview:self.loginView];
    [self.loginView updateStateToBind:self.isWechatBind];
    self.loginView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.loginView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
        self.forgetCodeView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
    } completion:^(BOOL finished) {
        if (self.forgetPhoneView) {
            self.forgetPhoneView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
            [self.forgetPhoneView removeFromSuperview];
            self.forgetPhoneView = nil;
        }
    }];
}

- (void)wechatHasAccountBefore {
    self.loginView.wechatState = true;
    [[UIApplication sharedApplication].keyWindow addSubview:self.loginView];
    [self.loginView updateStateToBind:self.isWechatBind];

    self.loginView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
    [UIView animateWithDuration:0.25 animations:^{
        self.loginView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
        self.forgetPhoneView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
    } completion:^(BOOL finished) {
        if (self.forgetPhoneView) {
            [self.forgetPhoneView removeFromSuperview];
            self.forgetPhoneView = nil;
        }
        self.forgetPhoneView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
    }];
}

- (void) backBtnClickOfPWView {
    if (self.isCancel) {
        [UIView animateWithDuration:.2 animations:^{
            //取消遮盖状态栏
            [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
            //隐藏背景视图，等待下次调用
            //        self.blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
            self.blurEffectView.frame = CGRectMake(0, kCommonScreenHeight, CGRectGetWidth(self.blurEffectView.frame), CGRectGetHeight(self.blurEffectView.frame));
            self.forgetPhoneView.frame = CGRectMake(0, kCommonScreenHeight, CGRectGetWidth(self.forgetPhoneView.frame), CGRectGetHeight(self.forgetPhoneView.frame));
            
        } completion:^(BOOL finished) {
            self.blurEffectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.blurEffectView.frame), CGRectGetHeight(self.blurEffectView.frame));
            self.forgetPhoneView.frame = CGRectMake(0, 0, CGRectGetWidth(self.forgetPhoneView.frame), CGRectGetHeight(self.forgetPhoneView.frame));
            
            self.blurEffectView.backgroundColor = [UIColor colorWithHex:@"#000000"];
            if (self.blurEffectView.superview) {
                [_blurEffectView removeFromSuperview];
            }
            //移除forgetPhoneView
            if (self.forgetPhoneView) {
                [self.forgetPhoneView removeFromSuperview];
                self.forgetPhoneView = nil;
            }
            [self backFromLoginCenterView];
        }];
    } else {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"请您先设置密码" cancleTitle:@"好的" callback:^(BOOL confirm) {
        }];
    }
    
}
#pragma mark -- 忘记密码 验证码页面
- (void) userOfForgetPWButtonClickWithAccount:(NSString *)account codeStr:(NSString *)codeStr {
    USER_DEFAULT_FORGETCODE_WRITE(codeStr);
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
        if (weakSelf.timerOfForget.isValid) {
            [weakSelf.timerOfForget invalidate];
            weakSelf.timerOfForget = nil;
        }
        [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.forgetResetView];
        weakSelf.forgetResetView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.forgetResetView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
            weakSelf.forgetCodeView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
        } completion:^(BOOL finished) {
            if (weakSelf.forgetCodeView) {
                [weakSelf.forgetCodeView removeFromSuperview];
                weakSelf.forgetCodeView = nil;
            }
            weakSelf.forgetCodeView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
        }];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
    
}
//注册 获取验证码 下一步按钮    微信绑定手机号和验证码直接注册接口
- (void) wechatBindRegistPhoneWithAccount:(NSString *)account codeStr:(NSString *)codeStr{
    UserRequest *req = [[UserRequest alloc] init];
    __weak LoginCenterView *weakSelf = self;
    [req wechatRegisterWithPhoneNumber:account code:codeStr unionId:_unionId token:_accessToken openId:_openId success:^(User * _Nullable data) {
        [weakSelf loginSuccessWithData:data isFromRegister:false];
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];

}

//忘记密码 获取验证码 下一步按钮    微信绑定手机号和验证码直接注册接口
- (void)wechatBindPhoneWithAccount:(NSString *)account codeStr:(NSString *)codeStr {
}

//上一步   忘记密码验证码   返回到输入手机号界面
- (void) gotoLoginViewOfForgetPWViewButtonClick {
    if (self.timerOfForget.isValid) {
        [self.timerOfForget invalidate];
        self.timerOfForget = nil;
    }

    if (self.forgetCodeView) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.forgetPhoneView];
        self.forgetPhoneView.frame = CGRectMake(-kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
        
        [UIView animateWithDuration:0.25 animations:^{
            self.forgetPhoneView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
            self.forgetCodeView.frame = CGRectMake(kCommonScreenWidth, 0, kCommonScreenWidth, kCommonScreenHeight);
            
        } completion:^(BOOL finished) {
            self.forgetCodeView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
            [self.forgetCodeView removeFromSuperview];
            self.forgetCodeView = nil;
        }];
        
    } else if (self.timerOfForget.isValid) {
        [self.timerOfForget invalidate];
        self.timerOfForget = nil;
        [[UIApplication sharedApplication].keyWindow addSubview:self.loginView];
        [self.loginView updateStateToBind:self.isWechatBind];

    }
    
}
//MARK: 忘记密码验证码页面 x 掉返回
- (void) backBtnClickOfForgetPWView {
    if (self.timerOfForget.isValid) {
        [self.timerOfForget invalidate];
        self.timerOfForget = nil;
    }

    if (self.isCancel) {
        [UIView animateWithDuration:.2 animations:^{
            //取消遮盖状态栏
            USER_DEFAULT_FORGETPWPHONE_WRITE(nil);
            [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
            //隐藏背景视图，等待下次调用
            //        self.blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
            
            self.blurEffectView.frame = CGRectMake(0, kCommonScreenHeight, CGRectGetWidth(self.blurEffectView.frame), CGRectGetHeight(self.blurEffectView.frame));
            self.forgetCodeView.frame = CGRectMake(0, kCommonScreenHeight, CGRectGetWidth(self.forgetCodeView.frame), CGRectGetHeight(self.forgetCodeView.frame));
            
        } completion:^(BOOL finished) {
            self.blurEffectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.blurEffectView.frame), CGRectGetHeight(self.blurEffectView.frame));
            self.forgetCodeView.frame = CGRectMake(0, 0, CGRectGetWidth(self.forgetCodeView.frame), CGRectGetHeight(self.forgetCodeView.frame));
            
            self.blurEffectView.backgroundColor = [UIColor colorWithHex:@"#000000"];
            if (self.blurEffectView.superview) {
                [_blurEffectView removeFromSuperview];
            }
            //移除forgetCodeView
            if (self.forgetCodeView) {
                [self.forgetCodeView removeFromSuperview];
                self.forgetCodeView = nil;
            }
            if (self.timerOfForget.isValid) {
                [self.timerOfForget invalidate];
                self.timerOfForget = nil;
            }
            [self backFromLoginCenterView];
        }];
    } else {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"请您先输入验证码" cancleTitle:@"好的" callback:^(BOOL confirm) {
        }];
    }
    
}

#pragma mark -- 重置密码页面
- (void) userResetPWButtonClickWithAccount:(NSString *)account passWord:(NSString *)password {
    //MARK: 先校验验证码是否正确，正确了才能修改密码并重新登录
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:account forKey:@"phoneNumber"];
    [params setValue:USER_DEFAULT_FORGETCODE forKey:@"code"];
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
        if (weakSelf.forgetResetView) {
            [weakSelf.forgetResetView removeFromSuperview];
            weakSelf.forgetResetView = nil;
        }
        [weakSelf userLoginButtonClickWithAccount:account password:password isFromRegister:NO];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
    
}

- (void) backBtnClickOfForgetPWResetPWView {
    if (self.isCancel) {
        [UIView animateWithDuration:.2 animations:^{
            //取消遮盖状态栏
            USER_DEFAULT_FORGETPWPHONE_WRITE(nil);
            [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelNormal];
            //隐藏背景视图，等待下次调用
            //        self.blurEffectView.frame = CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0);
            
            self.blurEffectView.frame = CGRectMake(0, kCommonScreenHeight, CGRectGetWidth(self.blurEffectView.frame), CGRectGetHeight(self.blurEffectView.frame));
            self.forgetResetView.frame = CGRectMake(0, kCommonScreenHeight, CGRectGetWidth(self.forgetResetView.frame), CGRectGetHeight(self.forgetResetView.frame));
            
        } completion:^(BOOL finished) {
            
            self.blurEffectView.frame = CGRectMake(0, 0, CGRectGetWidth(self.blurEffectView.frame), CGRectGetHeight(self.blurEffectView.frame));
            self.forgetResetView.frame = CGRectMake(0, 0, CGRectGetWidth(self.forgetResetView.frame), CGRectGetHeight(self.forgetResetView.frame));
            
            self.blurEffectView.backgroundColor = [UIColor colorWithHex:@"#000000"];
            if (self.blurEffectView.superview) {
                [_blurEffectView removeFromSuperview];
            }
            //移除forgetCodeView
            if (self.forgetResetView) {
                [self.forgetResetView removeFromSuperview];
                self.forgetResetView = nil;
            }
            [self backFromLoginCenterView];
        }];
    } else {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"请您先设置密码" cancleTitle:@"好的" callback:^(BOOL confirm) {
        }];
    }
    
}











- (UserLoginView *) loginView {
    if (!_loginView) {
        _loginView = [[UserLoginView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight) delegate:self];
    }
    return _loginView;
}

- (UserRegisterPhoneView *)registerPhoneView {
    if (!_registerPhoneView) {
        _registerPhoneView = [[UserRegisterPhoneView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight) delegate:self];
    }
    return _registerPhoneView;
}

- (UserRegisterCodeView *)registerCodeView {
    if (!_registerCodeView) {
        _registerCodeView = [[UserRegisterCodeView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight) delegate:self];
    }
    return _registerCodeView;
}

- (UserForgetPWPhoneView *)forgetPhoneView {
    if (!_forgetPhoneView) {
        _forgetPhoneView = [[UserForgetPWPhoneView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight) delegate:self];
    }
    return _forgetPhoneView;
}

- (UserForgetPWCodeView *) forgetCodeView {
    if (!_forgetCodeView) {
        _forgetCodeView = [[UserForgetPWCodeView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight) delegate:self];
    }
    return _forgetCodeView;
}

- (UserForgetResetPWView *)forgetResetView {
    if (!_forgetResetView) {
        _forgetResetView = [[UserForgetResetPWView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight) delegate:self];
    }
    return _forgetResetView;
}

- (UserRegisterSetPWView *) registerSetPWView {
    if (!_registerSetPWView) {
        _registerSetPWView = [[UserRegisterSetPWView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight) delegate:self];
    }
    return _registerSetPWView;
}

- (UIVisualEffectView *)blurEffectView {
    if (!_blurEffectView) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _blurEffectView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
        _blurEffectView.backgroundColor = [UIColor colorWithHex:@"#000000"];
        _blurEffectView.alpha = 0.75;
    }
    return _blurEffectView;
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

@end
