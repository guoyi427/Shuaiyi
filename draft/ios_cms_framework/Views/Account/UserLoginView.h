//
//  UserLoginView.h
//  CIASMovie
//
//  Created by avatar on 2017/1/5.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加代理方法
@protocol UserLoginViewDelegate <NSObject>

- (void) userLoginButtonClickWithAccount:(NSString *)account password:(NSString *)pw isFromRegister:(BOOL) isFromRegister;
//  微信登陆
- (void) wxLoginWithCode:(NSString *)code;
//  微信绑定并登录
- (void) wechatBindAndLoginWithAccount:(NSString *)account password:(NSString *)password;
- (void) userRegisterButtonClick;
- (void) forgetPasswordButtonClick;
- (void) backBtnClickOfLoginView;

@end

@interface UserLoginView : UIView<UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *backBtnOfLogin, *registerBtnOfLogin, *registerBtnOfLogin2, *forgetPasswordBtnOfLogin, *loginBtn;
    UILabel *titleLabelOfLogin, *phoneLabelOfLogin, *passwordLabelOfLogin;
    UITextField *phoneField, *passwordField;
    UIImageView *phoneImageViewOfLogin, *passwordImageViewOfLogin;
    UIScrollView *holderView;
    UIView *bgView;
    UILabel *wechatLoginLabel;
    UIButton *wechatLoginButton;
}

@property (nonatomic, weak) id <UserLoginViewDelegate> delegate;
@property (nonatomic, assign) BOOL wechatState;

@property (nonatomic, strong) UIView *wrongTipsView;

- (id)initWithFrame:(CGRect)frame delegate:(id <UserLoginViewDelegate>)aDelegate;
- (void)beginEdit;
- (void)endEdit;
- (void)updateStateToBind:(BOOL)isWechatBind;


@end
