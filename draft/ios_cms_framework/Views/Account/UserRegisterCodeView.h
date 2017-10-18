//
//  UserRegisterCodeView.h
//  CIASMovie
//
//  Created by avatar on 2017/1/6.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
//添加代理方法
@protocol UserRegisterCodeViewDelegate <NSObject>

- (void) userRegisterButtonClickWithAccount:(NSString *)account codeStr:(NSString *)codeStr;
- (void) gotoLoginViewOfGetCodeViewButtonClick;
- (void) backBtnClickOfGetCodeView;
- (void) wechatBindRegistPhoneWithAccount:(NSString *)account codeStr:(NSString *)codeStr;

@end

@interface UserRegisterCodeView : UIView<UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *backBtnOfRegister, *loginBtnOfRegister, *loginBtnOfRegister2, *gotoRegisterBtn;
    UILabel *titleLabelOfRegister, *phoneLabelOfRegister, *phoneTipsLabelOfRegister, *phoneTipsLabelOfRegister1,*phoneTipsLabelOfRegister2;
    UITextField *codeField;
    UIButton *codeRightView;
    UIScrollView *holderView;
    UIView *bgView;
    UIView *line1View;
    UIView *bottomYellowProgressBar;
}
@property (nonatomic, weak) id <UserRegisterCodeViewDelegate> delegate;

@property (nonatomic, assign) BOOL wechatBindPhoneState;

- (id)initWithFrame:(CGRect)frame delegate:(id <UserRegisterCodeViewDelegate>)aDelegate;
- (void)beginEdit;
- (void)endEdit;
- (void)updateStateToBind:(BOOL)isWechatBind;

/**
 更新验证码倒计时

 @param time 倒计时
 */
- (void)updateCodeInputViewWithTime:(NSInteger)time;


@end
