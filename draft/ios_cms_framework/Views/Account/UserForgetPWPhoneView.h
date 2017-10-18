//
//  UserForgetPWPhoneView.h
//  CIASMovie
//
//  Created by avatar on 2017/1/7.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加代理方法
@protocol UserForgetPWPhoneViewDelegate <NSObject>

- (void) userGetCodeOfPWButtonClickWithAccount:(NSString *)account wechatBindPhoneState:(BOOL)isWechat;
- (void) gotoLoginViewOfPWButtonClick;
- (void) wechatHasAccountBefore;
- (void) backBtnClickOfPWView;

@end

@interface UserForgetPWPhoneView : UIView<UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *backBtnOfRegister, *loginBtnOfRegister, *loginBtnOfRegister2, *getCodeBtn;
    UILabel *titleLabelOfRegister, *phoneLabelOfRegister, *phoneTipsLabelOfRegister,*phoneTipsLabelOfRegister2;
    UITextField *phoneField;
    UIImageView *phoneImageViewOfRegister;
    UIScrollView *holderView;
    UIView *bgView;
    UIView *line1View;
    UIView *bottomYellowProgressBar;
}

@property (nonatomic, weak) id <UserForgetPWPhoneViewDelegate> delegate;
@property (nonatomic, assign) BOOL wechatBindPhoneState;

- (id)initWithFrame:(CGRect)frame delegate:(id <UserForgetPWPhoneViewDelegate>)aDelegate;
- (void)beginEdit;
- (void)endEdit;
- (void)updateStateToBind:(BOOL)isWechatBind;

@end
