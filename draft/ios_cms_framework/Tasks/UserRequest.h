//
//  UserRequest.h
//  CIASMovie
//
//  Created by avatar on 2017/1/18.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
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
@end
