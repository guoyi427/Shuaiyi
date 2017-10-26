//
//  UserManager.m
//  KoMovie
//
//  Created by Albert on 28/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserManager.h"
#import "KKZUtility.h"
#import "NSStringExtra.h"
#import "NewLoginViewModel.h"
#import "UserLogin.h"
#import "UserRequest.h"
#import "LoginViewController.h"
#import "DataEngine.h"

@interface UserManager ()
@property (nonatomic, strong) UserLogin *userLogin;
@property (nonatomic) SiteType site;
@end

@implementation UserManager
static UserManager *_shareInstance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[self alloc] init];
    });
    return _shareInstance;
}

/**
 登录
 
 @param userName 用户名 第三方登录传uid
 @param password 密码(不需要对其进行 MD5 加密) 第三方登录传token
 @param site     登录类型
 @param success  成功回调
 @param failure  失败回调
 */
- (void)login:(NSString *_Nonnull)userName
     password:(NSString *_Nonnull)password
         site:(SiteType)site
      success:(nullable void (^)(UserLogin *_Nullable userLogin))success
      failure:(nullable void (^)(NSError *_Nullable err))failure {

    //统计事件：用户登录
    StatisEvent(EVENT_USER_LOGIN);

    self.site = site;

    UserRequest *request = [[UserRequest alloc] init];
    [request login:userName
            password:password
                site:site
             success:^(UserLogin *_Nullable userLogin) {

                 [self loginSunccess:userLogin];

                 if (success) {
                     success(userLogin);
                 }
                 
                 if (site == SiteTypeKKZValidcode) {
                     BOOKING_PHONE_WRITE(userName);
                 }
                 
                 USER_DEFAULT_ID_WRITE(userLogin.userId);

             }
             failure:failure];
}

/**
 处理登录成功

 @param userLogin 用户登录信息
 */
- (void)loginSunccess:(UserLogin *)userLogin {

    self.userLogin = userLogin;

    //统计事件：用户登录成功
    StatisEvent(EVENT_USER_LOGIN_SUCCESS);
    NSString *platform;
    if (self.site == SiteTypeWX) {
        platform = @"Wechat";
    } else if (self.site == SiteTypeQQ) {
        platform = @"QQ";
    } else if (self.site == SiteTypeSina) {
        platform = @"SinaWeibo";
    } else if (self.site == SiteTypeKKZ) {
        platform = @"KKZ";
    }
    [StatisticsComponent loginEvent:[DataEngine sharedDataEngine].userId platform:platform];

    //注册推送通知
    [self rigistKotaPush];

    //删除用户登录信息
    [NewLoginViewModel deleteLoginDataFromDataBase];

    //重新复制用户信息
    if ([KKZUtility stringIsEmpty:userLogin.nickName]) {
        userLogin.nickName = [NSString stringWithFormat:@"用户%@", userLogin.userId];
    }
    [NewLoginViewModel insertLoginDataIntoDataBase:self.userLogin];

    //将请求的类型赋值给全局登录信息类
    [[DataEngine sharedDataEngine] setUserDataModel:self.userLogin];
    [DataEngine sharedDataEngine].site = self.site;

    //支付宝的token值
    USER_AlIPAY_TOKEN_WRITE(nil);

    //判断当前请求的类型
    if (self.site == SiteTypeKKZ) {

        //标记一下不是用手机号码登录的
        [DataEngine sharedDataEngine].isPhoneNum = YES;

        //设置login_phoneName为YES
        USER_LOGIN_PHONE_WRITE(YES);

    } else {

        //标记一下不是用手机号码登录的
        [DataEngine sharedDataEngine].isPhoneNum = NO;

        //设置login_phoneName为NO
        USER_LOGIN_PHONE_WRITE(NO);
    }
}

/**
 *  注册推送通知
 */
- (void)rigistKotaPush {
    UserRequest *request = [UserRequest new];
    [request updateUserPosition];
}

/**
 执行注销操作
 */
- (void)logout:(nullable void (^)())success
       failure:(nullable void (^)(NSError *_Nullable err))failure {
    UserRequest *request = [[UserRequest alloc] init];
    [request logout:^{

        if (success) {
            success();
        }

    }
            failure:failure];
}

/**
 更新用户余额
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)updateBalance:(nullable void (^)(NSNumber *_Nullable vipAccount))success
              failure:(nullable void (^)(NSError *_Nullable err))failure {
    UserRequest *request = [[UserRequest alloc] init];

    [request requestUserDetail:^(User *_Nullable user) {
        if (user) {
            self.user.vipAccount = user.vipAccount;
            [DataEngine sharedDataEngine].vipBalance = user.vipAccount.floatValue;
            if (success) {
                success(user.vipAccount);
            }
        } else {
            failure(nil);
            [DataEngine sharedDataEngine].vipBalance = 0.0f;
        }
    }
                       failure:failure];
}

- (BOOL)isUserAuthorized {
    return appDelegate.isAuthorized;
}

- (BOOL)isUserAuthorizedWithController:(CommonViewController *)controller {
    if (!appDelegate.isAuthorized) {
        [self gotoLoginControllerFrom:controller];
        return FALSE;
    }
    return TRUE;
}

/**
 跳转到登录页面。
 
 @param controller 跳转到登录页之前的未登录页面
 @param loginDelegate 登录页面的 delegate
 */
- (void)gotoLoginControllerFrom:(UIViewController *_Nonnull)controller {
    
    LoginViewController *loginController = [[LoginViewController alloc] init];
    UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController:loginController];
    [naviC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [controller presentViewController:naviC
                             animated:YES
                           completion:nil];
}

/**
 跳转到登录页面。
 
 @param controller 跳转到登录页之前的未登录页面
 @param loginDelegate 登录页面的 delegate
 */
- (void)gotoLoginControllerFrom:(UIViewController *_Nonnull)controller
                  loginDelegate:(id<LoginViewControllerDelegate> _Nonnull)delegate {
    
    LoginViewController *loginController = [[LoginViewController alloc] init];
    loginController.delegate = delegate;
    UINavigationController *naviC = [[UINavigationController alloc] initWithRootViewController:loginController];
    [naviC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [controller presentViewController:naviC
                             animated:YES
                           completion:nil];
}

@end
