//
//  UserResetPWPhoneView.h
//  CIASMovie
//
//  Created by avatar on 2017/2/20.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
//添加代理方法
@protocol UserResetPWPhoneViewDelegate <NSObject>

- (void) userResetPWPhoneButtonClickWithAccount:(NSString *)account;
- (void) backBtnClickOfResetPWPhoneView;

@end

@interface UserResetPWPhoneView : UIView<UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *backBtnOfRegister, *loginBtnOfRegister, *loginBtnOfRegister2, *getCodeBtn;
    UILabel *titleLabelOfRegister, *phoneLabelOfRegister, *phoneTipsLabelOfRegister,*phoneTipsLabelOfRegister2;
    UITextField *phoneField;
    UIImageView *phoneImageViewOfRegister;
    UIScrollView *holderView;
    UIView *bgView;
    UIView *line1View;
    
}

@property (nonatomic, weak) id <UserResetPWPhoneViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame delegate:(id <UserResetPWPhoneViewDelegate>)aDelegate;
- (void)beginEdit;
- (void)endEdit;


@end
