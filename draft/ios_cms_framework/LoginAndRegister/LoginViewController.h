//
//  LoginViewController.h
//  CIASMovie
//
//  Created by kokozu on 18/10/2017.
//  Copyright © 2017 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>
@optional
- (void)loginControllerLoginSucceed;
- (void)loginControllerLoginCancelled;
@end

@interface LoginViewController : UIViewController

/**
 *  得到代理对象
 */
@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;

@end
