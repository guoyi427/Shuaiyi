//
//  UserResetPWPasswordView.h
//  CIASMovie
//
//  Created by avatar on 2017/2/20.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
//添加代理方法
@protocol UserResetPWPasswordViewDelegate <NSObject>

- (void) userResetPWPasswordButtonClickWithAccount:(NSString *)account passWord:(NSString *)password;
- (void) backBtnClickOfResetPWPasswordView;

@end

@interface UserResetPWPasswordView : UIView<UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *backBtnOfRegister, *loginBtnOfRegister, *loginBtnOfRegister2, *gotoRegisterBtn;
    UILabel *titleLabelOfRegister, *phoneLabelOfRegister, *phoneTipsLabelOfRegister, *phoneTipsLabelOfRegister1,*phoneTipsLabelOfRegister2,*passwordLabelOfReset;
    UITextField *passwordField;
    UIScrollView *holderView;
    UIView *bgView;
    UIImageView *passwordImageViewOfReset;
    UIView *line1View;
    
}
@property (nonatomic, weak) id <UserResetPWPasswordViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame delegate:(id <UserResetPWPasswordViewDelegate>)aDelegate;
- (void)beginEdit;
- (void)endEdit;

@end
