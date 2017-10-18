//
//  UserForgetResetPWView.h
//  CIASMovie
//
//  Created by avatar on 2017/1/8.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加代理方法
@protocol UserForgetResetPWViewDelegate <NSObject>

- (void) userResetPWButtonClickWithAccount:(NSString *)account passWord:(NSString *)password;
- (void) backBtnClickOfForgetPWResetPWView;

@end

@interface UserForgetResetPWView : UIView<UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *backBtnOfRegister, *loginBtnOfRegister, *loginBtnOfRegister2, *gotoRegisterBtn;
    UILabel *titleLabelOfRegister, *phoneLabelOfRegister, *phoneTipsLabelOfRegister, *phoneTipsLabelOfRegister1,*phoneTipsLabelOfRegister2,*passwordLabelOfReset;
    UITextField *passwordField;
    UIScrollView *holderView;
    UIView *bgView;
    UIImageView *passwordImageViewOfReset;
    UIView *line1View;
    
}
@property (nonatomic, weak) id <UserForgetResetPWViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame delegate:(id <UserForgetResetPWViewDelegate>)aDelegate;
- (void)beginEdit;
- (void)endEdit;

@end
