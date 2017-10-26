//
//  UserManager.h
//  KoMovie
//
//  Created by Albert on 28/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "User.h"
#import "UserLogin.h"
#import "LoginViewController.h"

@interface UserManager : NSObject

@property (nonatomic, strong) User *_Nullable user;

+ (instancetype _Nonnull) shareInstance;

/**
 登录
 
 @param userName 用户名 第三方登录传uid
 @param password 密码(不需要对其进行 MD5 加密) 第三方登录传token
 @param site     登录类型
 @param success  成功回调
 @param failure  失败回调
 */
- (void) login:(NSString * _Nonnull)userName
      password:(NSString * _Nonnull)password
          site:(SiteType )site
       success:(nullable void (^)(UserLogin *_Nullable userLogin))success
       failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 执行注销操作
 */
- (void) logout:(nullable void (^)())success
        failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 更新用户余额

 @param success 成功回调
 @param failure 失败回调
 */
- (void) updateBalance:(nullable void (^)(NSNumber * _Nullable vipAccount))success
               failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 判断用户是否已经登录。

 @return 如果已登录返回TRUE，未登录则返回FALSE
 */
- (BOOL)isUserAuthorized;

/**
 判断用户是否已经登录，并且未登录跳转到登录页面。

 @param controller 跳转到登录页之前的未登录页面
 @return 如果已登录返回TRUE，未登录则返回FALSE
 */
- (BOOL)isUserAuthorizedWithController:(UIViewController *_Nonnull)controller;

/**
 跳转到登录页面。
 
 @param controller 跳转到登录页之前的未登录页面
 */
- (void)gotoLoginControllerFrom:(UIViewController *_Nonnull)controller;

/**
 跳转到登录页面。
 
 @param controller 跳转到登录页之前的未登录页面
 @param loginDelegate 登录页面的 delegate
 */
- (void)gotoLoginControllerFrom:(UIViewController *_Nonnull)controller
                  loginDelegate:(id<LoginViewControllerDelegate> _Nonnull)delegate;

@end
