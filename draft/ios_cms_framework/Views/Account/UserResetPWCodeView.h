//
//  UserResetPWCodeView.h
//  CIASMovie
//
//  Created by avatar on 2017/2/20.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
//添加代理方法
@protocol UserResetPWCodeViewDelegate <NSObject>

- (void) userOfResetPWCodeButtonClickWithAccount:(NSString *)account codeStr:(NSString *)codeStr;
- (void) backBtnClickOfResetPWCodeView;
- (void) backBtnClickTOResetPWPhoneView;


@end
@interface UserResetPWCodeView : UIView<UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *backBtnOfRegister, *loginBtnOfRegister, *loginBtnOfRegister2, *gotoRegisterBtn;
    UILabel *titleLabelOfRegister, *phoneLabelOfRegister, *phoneTipsLabelOfRegister, *phoneTipsLabelOfRegister1,*phoneTipsLabelOfRegister2;
    UITextField *codeField;
    UIButton *codeRightView;

    UIScrollView *holderView;
    UIView *bgView;
    UIView *line1View;
    
}
@property (nonatomic, weak) id <UserResetPWCodeViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame delegate:(id <UserResetPWCodeViewDelegate>)aDelegate;
- (void)beginEdit;
- (void)endEdit;

/**
 更新验证码倒计时
 
 @param time 倒计时
 */
- (void)updateCodeInputViewWithTime:(NSInteger)time;

@end
