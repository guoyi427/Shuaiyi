//
//  UserRegisterSetPWView.h
//  CIASMovie
//
//  Created by avatar on 2017/1/8.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加代理方法
@protocol UserRegisterSetPWViewDelegate <NSObject>

- (void) userSetRegisterPWButtonClickWithAccount:(NSString *)account passWord:(NSString *)password;

@end

@interface UserRegisterSetPWView : UIView<UITextFieldDelegate, UIScrollViewDelegate>
{
    UIButton *backBtnOfRegister, *loginBtnOfRegister, *loginBtnOfRegister2, *gotoRegisterBtn;
    UILabel *titleLabelOfRegister, *phoneLabelOfRegister, *phoneTipsLabelOfRegister, *phoneTipsLabelOfRegister1,*phoneTipsLabelOfRegister2,*passwordLabelOfReset;
    UITextField *passwordField;
    UIScrollView *holderView;
    UIView *bgView;
    UIImageView *passwordImageViewOfReset;
    UIView *line1View;
    
}
@property (nonatomic, weak) id <UserRegisterSetPWViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame delegate:(id <UserRegisterSetPWViewDelegate>)aDelegate;
- (void)beginEdit;
- (void)endEdit;

@end
