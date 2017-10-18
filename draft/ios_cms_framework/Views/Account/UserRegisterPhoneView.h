//
//  UserRegisterPhoneView.h
//  CIASMovie
//
//  Created by avatar on 2017/1/6.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加代理方法
@protocol UserRegisterPhoneViewDelegate <NSObject>

- (void) userGetCodeButtonClickWithAccount:(NSString *)account;
- (void) gotoLoginViewButtonClick;
- (void) backBtnClickOfRegisterView;

@end

@interface UserRegisterPhoneView : UIView <UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *backBtnOfRegister, *loginBtnOfRegister, *loginBtnOfRegister2, *getCodeBtn;
    UILabel *titleLabelOfRegister, *phoneLabelOfRegister, *phoneTipsLabelOfRegister;
    UITextField *phoneField;
    UIImageView *phoneImageViewOfRegister;
    UIScrollView *holderView;
    UIView *bgView;
    UIView *line1View;
    UIView *bottomYellowProgressBar;

}

@property (nonatomic, weak) id <UserRegisterPhoneViewDelegate> delegate;
@property (nonatomic, strong) UIView *wrongTipsView;
@property (nonatomic, assign) BOOL wechatBindPhoneState;


- (id)initWithFrame:(CGRect)frame delegate:(id <UserRegisterPhoneViewDelegate>)aDelegate;
- (void)beginEdit;
- (void)endEdit;
- (void)updateStateToBind:(BOOL)isWechatBind;

/**
 更新错误状态

 @param error true:错误
 */
- (void)updateErrorStatus:(BOOL)error;

@end
