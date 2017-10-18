//
//  LoginCenterView.h
//  CIASMovie
//
//  Created by avatar on 2017/3/30.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加代理方法
@protocol LoginCenterViewDelegate <NSObject>

- (void) backBtnClickOfLoginCenterView;
- (void)newAccountDidFinishLogin;

@end

@interface LoginCenterView : UIView<UIScrollViewDelegate>
{
    UIScrollView *holderView;
    UIView *bgView;
    int timeCountOfRegister,timeCountOfForget;
}

@property (nonatomic, strong) NSTimer *timerOfRegister;
@property (nonatomic, strong) NSTimer *timerOfForget;
@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, assign) BOOL isWechatBind;//微信绑定手机号   YES是选择微信需要绑定手机号   NO是正常流程

@property (nonatomic, weak) id <LoginCenterViewDelegate> delegate;


- (id)initWithFrame:(CGRect)frame withIsCancelView:(BOOL)isCancelView delegate:(id <LoginCenterViewDelegate>)aDelegate;

@end
