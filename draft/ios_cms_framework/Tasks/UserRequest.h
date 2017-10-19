//
//  UserRequest.h
//  CIASMovie
//
//  Created by avatar on 2017/1/18.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User, UserLogin;
@interface UserRequest : NSObject

//MARK: 判断用户是否注册过
- (void)requestIsHaveRegisterParams:(NSDictionary *_Nullable)params
                            success:(nullable void (^)(NSDictionary *_Nullable data))success
                            failure:(nullable void (^)(NSError *_Nullable err))failure;
//MARK: 获取注册验证码
- (void)requestGetRegisterCodeParams:(NSDictionary *_Nullable)params
                             success:(nullable void (^)(NSDictionary *_Nullable data))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure;
//MARK: 校验注册验证码是否正确
- (void)requestValidRegisterCodeParams:(NSDictionary *_Nullable)params
                               success:(nullable void (^)(NSDictionary *_Nullable data))success
                               failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK: 注册
- (void)requestRegisterParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSDictionary *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK: 登录
- (void)requestLoginParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(User *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK: 重置密码
- (void)requestResetPasswordParams:(NSDictionary *_Nullable)params
                   success:(nullable void (^)(NSDictionary *_Nullable data))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK: 意见反馈
- (void)requestSenderSuggestionParams:(NSDictionary *_Nullable)params
                           success:(nullable void (^)(NSDictionary *_Nullable data))success
                           failure:(nullable void (^)(NSError *_Nullable err))failure;


//MARK: 修改其他资料
- (void)requestUserOtherInfomationParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(NSDictionary *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure;


//MARK: 修改头像资料
- (void)requestUserHeadInfomationParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(NSDictionary *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure;


//MARK: 查看用户详细资料
- (void)requestUserInfomationParams:(NSDictionary *_Nullable)params
                                success:(nullable void (^)(NSDictionary *_Nullable data))success
                                failure:(nullable void (^)(NSError *_Nullable err))failure;


//MARK: 个人中心页查看用户详细资料
- (void)requestUserDataParams:(NSDictionary *_Nullable)params
                            success:(nullable void (^)(NSDictionary *_Nullable data))success
                            failure:(nullable void (^)(NSError *_Nullable err))failure;

//cucapi/modifyUser    修改其它
//cucapi/modifyHead   修改头像

//微信登录
- (void)wechatLoginWithCode:(NSString *_Nullable)code
                    success:(nullable void (^)(User *_Nullable data))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure;

//微信注册
- (void)wechatRegisterWithPhoneNumber:(NSString *_Nullable)phone
                                 code:(NSString *_Nullable)code
                              unionId:(NSString *_Nullable)unionId
                                token:(NSString *_Nullable)token
                               openId:(NSString *_Nullable)openId
                              success:(nullable void (^)(User *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure;

//微信绑定并登录
- (void)wechatLoginAndBindWithPhoneNumber:(NSString *_Nullable)phone
                                 password:(NSString *_Nullable)password
                                  unionId:(NSString *_Nullable)unionId
                                  success:(nullable void (^)(User *_Nullable data))success
                                  failure:(nullable void (^)(NSError *_Nullable err))failure;


//  kkz
/**
 登录
 
 @param userName 用户名 第三方登录传uid
 @param password 密码(md5) 第三方登录传token
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
 退出登录
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void) logout:(nullable void (^)())success
        failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 重置密码
 
 @param mobile    手机号
 @param password  新密码
 @param validCode 验证码
 @param success   成功回调
 @param failure   失败回调
 */
- (void) resetPassword:(NSString *_Nonnull)mobile
              password:(NSString *_Nonnull)password
             validCode:(NSString *_Nonnull)validCode
               success:(nullable void (^)())success
               failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 注册

 @param phoneNumber 手机号
 @param password 密码
 @param nickName 昵称
 @param validCode 验证码
 */
- (void)registerPhoneNumber:(NSString *_Nonnull)phoneNumber
                   password:(NSString *_Nonnull)password
                   nickName:(NSString *_Nonnull)nickName
                  validCode:(NSString *_Nonnull)validCode
                    success:(nullable void (^)(UserLogin *_Nullable user))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure;



@end
