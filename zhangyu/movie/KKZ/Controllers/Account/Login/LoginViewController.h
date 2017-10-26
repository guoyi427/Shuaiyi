//
//  登录页面
//
//  Created by 艾广华 on 15/11/5.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "CommonViewController.h"

@protocol LoginViewControllerDelegate <NSObject>
@optional
- (void)loginControllerLoginSucceed;
- (void)loginControllerLoginCancelled;
@end

@interface LoginViewController : CommonViewController

/**
 *  得到代理对象
 */
@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;

@end
