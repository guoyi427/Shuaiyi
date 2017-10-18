//
//  UserRequest.m
//  CIASMovie
//
//  Created by avatar on 2017/1/18.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "UserRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"
#import "DataEngine.h"
#import "User.h"
#import "KKZBaseRequestParamsMD5.h"
#import "UserLogin.h"

@implementation UserRequest


- (void)requestResetPasswordParams:(NSDictionary *_Nullable)params
                   success:(nullable void (^)(NSDictionary *_Nullable data))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *userLoginCodeParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [userLoginCodeParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/resetPassword"];
//    @"/webservice/", 
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"cucapi/resetPassword", newParams);
    [request POST:@"cucapi/resetPassword"
       parameters:newParams
      resultClass:[User class]
          success:^(id _Nullable data, id _Nullable respomsObject) {
              //             DLog(@"requestUserLoginCodeParams == /n%@/n", data);
              //             DLog(@"requestUserLoginCodeParams == /n%@/n", respomsObject);
              
              if (success) {
                  success(data);
              }
          }
          failure:failure];
}

//MARK: 意见反馈
- (void)requestSenderSuggestionParams:(NSDictionary *_Nullable)params
                              success:(nullable void (^)(NSDictionary *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *userLoginCodeParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [userLoginCodeParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/insertAdvice"];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"cucapi/insertAdvice", newParams);
    [request POST:@"cucapi/insertAdvice"
       parameters:newParams
      resultClass:nil
          success:^(id _Nullable data, id _Nullable respomsObject) {
              
              if (success) {
                  success(respomsObject);
              }
          }
          failure:failure];
}

- (void)requestLoginParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(User *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *userLoginCodeParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [userLoginCodeParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/userLogin"];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"cucapi/userLogin", newParams);
    [request POST:@"cucapi/userLogin"
       parameters:newParams
      resultClass:[User class]
          success:^(id _Nullable data, id _Nullable respomsObject) {
//               DLog(@"requestUserLogindata == /n%@/n", data);
               DLog(@"requestUserLoginrespomsObject == /n%@/n", respomsObject);
              
              if (success) {
                  success(data);
              }
          }
          failure:failure];
}

- (void)requestRegisterParams:(NSDictionary *_Nullable)params
                               success:(nullable void (^)(NSDictionary *_Nullable data))success
                               failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *userLoginCodeParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [userLoginCodeParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/userRegister"];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"cucapi/userRegister", newParams);
    [request POST:@"cucapi/userRegister"
       parameters:newParams
      resultClass:[User class]
          success:^(id _Nullable data, id _Nullable respomsObject) {
              //             DLog(@"requestUserLoginCodeParams == /n%@/n", data);
              //             DLog(@"requestUserLoginCodeParams == /n%@/n", respomsObject);
              
              if (success) {
                  success(data);
              }
          }
          failure:failure];
}

- (void)requestValidRegisterCodeParams:(NSDictionary *_Nullable)params
                             success:(nullable void (^)(NSDictionary *_Nullable data))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *userLoginCodeParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [userLoginCodeParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/validUserMessage"];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"cucapi/validUserMessage", newParams);
    [request POST:@"cucapi/validUserMessage"
       parameters:newParams
      resultClass:[User class]
          success:^(id _Nullable data, id _Nullable respomsObject) {
              //             DLog(@"requestUserLoginCodeParams == /n%@/n", data);
              //             DLog(@"requestUserLoginCodeParams == /n%@/n", respomsObject);
              
              if (success) {
                  success(data);
              }
          }
          failure:failure];
}

- (void)requestGetRegisterCodeParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSDictionary *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *userLoginCodeParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [userLoginCodeParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/sendUserMessage"];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"cucapi/sendUserMessage", newParams);
    [request POST:@"cucapi/sendUserMessage"
      parameters:newParams
     resultClass:[User class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
//             DLog(@"requestUserLoginCodeParams == /n%@/n", data);
//             DLog(@"requestUserLoginCodeParams == /n%@/n", respomsObject);

             if (success) {
                 success(data);
             }
         }
         failure:failure];
}

- (void)requestIsHaveRegisterParams:(NSDictionary *_Nullable)params
                             success:(nullable void (^)(NSDictionary *_Nullable data))success
                             failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *userLoginCodeParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [userLoginCodeParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/haveUser"];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"cucapi/haveUser", newParams);
    [request POST:@"cucapi/haveUser"
       parameters:newParams
      resultClass:[User class]
          success:^(id _Nullable data, id _Nullable respomsObject) {
              //             DLog(@"requestUserLoginCodeParams == /n%@/n", data);
              //             DLog(@"requestUserLoginCodeParams == /n%@/n", respomsObject);
              
              if (success) {
                  success(data);
              }
          }
          failure:failure];
}

//



//MARK: 修改其他资料
- (void)requestUserOtherInfomationParams:(NSDictionary *_Nullable)params
                                 success:(nullable void (^)(NSDictionary *_Nullable data))success
                                 failure:(nullable void (^)(NSError *_Nullable err))failure {
    
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *userLoginCodeParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [userLoginCodeParams setValue:ciasChannelId forKey:@"channelId"];
    [userLoginCodeParams setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
    [userLoginCodeParams setValue:[DataEngine sharedDataEngine].userId forKey:@"id"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getUserInfoDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/modifyUser"];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"cucapi/modifyUser", newParams);
    
    [request POST:@"cucapi/modifyUser"
       parameters:newParams
      resultClass:nil
          success:^(id _Nullable data, id _Nullable respomsObject) {
              DLog(@"修改信息结果:%@", respomsObject);
              if (success) {
                  success(respomsObject);
              }
          }
          failure:failure];
    
}


//MARK: 修改头像资料
- (void)requestUserHeadInfomationParams:(NSDictionary *_Nullable)params
                                success:(nullable void (^)(NSDictionary *_Nullable data))success
                                failure:(nullable void (^)(NSError *_Nullable err))failure {
    
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *userLoginCodeParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [userLoginCodeParams setValue:ciasChannelId forKey:@"channelId"];
    [userLoginCodeParams setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
    [userLoginCodeParams removeObjectForKey:@"file"];
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getUserInfoDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/modifyHead"];
    
//    NSMutableDictionary *lastParams = [NSMutableDictionary dictionaryWithDictionary:newParams];
//    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        [lastParams setValue:obj forKey:key];
//    }];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"cucapi/modifyHead", newParams);
    NSData *data = params[@"file"];
    
    [request upload:@"cucapi/modifyHead"
         parameters:newParams
           fromData:^(id<AFMultipartFormData>  _Nonnull formData) {
               if (data != nil) {
                   NSDate *date = [NSDate date];
                   [formData appendPartWithFileData:data name:@"file" fileName:[NSString stringWithFormat:@"%ld%@.jpg",(long)[date timeIntervalSince1970],[DataEngine sharedDataEngine].userId] mimeType:@"jpg"];
               }
        }
        resultClass:nil
            success:^(id  _Nullable data, id  _Nullable responseObject) {
                DLog(@"修改头像结果:%@", responseObject);
                if (success) {
                    success(responseObject);
                }
            }
            failure:failure];
    
}


//MARK: 查看用户详细资料
- (void)requestUserInfomationParams:(NSDictionary *_Nullable)params
                            success:(nullable void (^)(NSDictionary *_Nullable data))success
                            failure:(nullable void (^)(NSError *_Nullable err))failure {
    
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *userLoginCodeParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [userLoginCodeParams setValue:ciasChannelId forKey:@"channelId"];
    [userLoginCodeParams setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getUserInfoDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/selectByIdTenantId"];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"cucapi/selectByIdTenantId", newParams);
    
    [request POST:@"cucapi/selectByIdTenantId"
       parameters:newParams
      resultClass:[User class]
          success:^(id _Nullable data, id _Nullable respomsObject) {
              DLog(@"用户详情：%@", respomsObject);
              if (data) {
                  User *user = (User *)data;
                  [self savePersonArrayData:user];
              }
              
              if (success) {
                  success(respomsObject);
              }
          }
          failure:failure];
    
}

- (void)savePersonArrayData:(User *)personObject {
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:personObject];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfoMData"];
}

//MARK: 个人中心页查看用户详细资料
- (void)requestUserDataParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSDictionary *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure {
    
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *userLoginCodeParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [userLoginCodeParams setValue:ciasChannelId forKey:@"channelId"];
    [userLoginCodeParams setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getUserInfoDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/selectByIdTenantId"];
    
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, @"cucapi/selectByIdTenantId", newParams);
    
    [request POST:@"cucapi/selectByIdTenantId"
       parameters:newParams
      resultClass:[User class]
          success:^(id _Nullable data, id _Nullable respomsObject) {
              DLog(@"个人中心用户详情：%@", respomsObject);
              if (success) {
                  success(data);
              }
          }
          failure:failure];
    
    
}


//cucapi/modifyUser    修改其它
//cucapi/modifyHead   修改头像

//微信登录
- (void)wechatLoginWithCode:(NSString *_Nullable)code
                    success:(nullable void (^)(User *_Nullable data))success
                    failure:(nullable void (^)(NSError *_Nullable err))failure {
    if (!code || code.length == 0) {
        return;
    }
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSDictionary *userLoginCodeParams = @{
                                          @"channelId":ciasChannelId,
                                          @"code":code
                                          };

    NSDictionary *newParams = [KKZBaseRequestParamsMD5 getDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/WXLogin"];
    [request POST:@"cucapi/WXLogin"
       parameters:newParams
      resultClass:[User class]
          success:^(id _Nullable data, id _Nullable respomsObject) {
              DLog(@"wxlogin response == /n%@/n", respomsObject);
              if (success) {
                  success(data);
              }
          }
          failure:failure];
}

//微信注册
- (void)wechatRegisterWithPhoneNumber:(NSString *_Nullable)phone
                                 code:(NSString *_Nullable)code
                              unionId:(NSString *_Nullable)unionId
                                token:(NSString *_Nullable)token
                               openId:(NSString *_Nullable)openId
                              success:(nullable void (^)(User *_Nullable data))success
                              failure:(nullable void (^)(NSError *_Nullable err))failure {
    if (!phone || !code || !unionId || !token || !openId) {
        return;
    }
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSDictionary *userLoginCodeParams = @{
                                          @"channelId":[NSNumber numberWithDouble:[ciasChannelId doubleValue]],
                                          @"registrySource":@"4",
                                          @"phoneNumber":phone,
                                          @"code":code,
                                          @"unionId":unionId,
                                          @"WXAccessToken":token,
                                          @"accessToken":@"-2",
                                          @"openId":openId,
                                          };
    
    NSDictionary *newParams = [KKZBaseRequestParamsMD5 getDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/WXCreateUser"];
    [request POST:@"cucapi/WXCreateUser"
       parameters:newParams
      resultClass:[User class]
          success:^(id _Nullable data, id _Nullable respomsObject) {
              DLog(@"wx create user response == /n%@/n", respomsObject);
              if (success) {
                  success(data);
              }
          }
          failure:failure];
}

//微信绑定并登录
- (void)wechatLoginAndBindWithPhoneNumber:(NSString *_Nullable)phone
                                 password:(NSString *_Nullable)password
                                  unionId:(NSString *_Nullable)unionId
                                  success:(nullable void (^)(User *_Nullable data))success
                                  failure:(nullable void (^)(NSError *_Nullable err))failure {
    if (!phone || !password || !unionId) {
        return;
    }
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSDictionary *userLoginCodeParams = @{
                                          @"channelId":[NSNumber numberWithDouble:[ciasChannelId doubleValue]],
                                          @"phoneNumber":phone,
                                          @"unionId":unionId,
                                          @"password":password,
                                          };
    
    NSDictionary *newParams = [KKZBaseRequestParamsMD5 getDecryptParams:userLoginCodeParams withMethod:@"POST" withRequestPath:@"/webservice/cucapi/WXLoginAndBinding"];
    [request POST:@"cucapi/WXLoginAndBinding"
       parameters:newParams
      resultClass:[User class]
          success:^(id _Nullable data, id _Nullable respomsObject) {
              DLog(@"wx login and bind user response == /n%@/n", respomsObject);
              if (success) {
                  success(data);
              }
          }
          failure:failure];
}

#pragma mark - kkz

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
       failure:(nullable void (^)(NSError *_Nullable err))failure {
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:userName forKey:@"user_name"];
    if (site == SiteTypeKKZ) {
        NSString *ms5 = [password MD5String];
        [dicParams setValue:ms5 forKey:@"password"];
    }else{
        [dicParams setValue:password forKey:@"password"];
    }
    
    [dicParams setValue:[NSNumber numberWithInt:site] forKey:@"site"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServerPath(@"user_Login")
      parameters:newParams
    resultKeyMap:@{@"user": [UserLogin class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 success([data objectForKey:@"user"]);
             }
             
         } failure:failure];
}

/**
 退出登录
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void) logout:(nullable void (^)())success
        failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"exit_user.chtml")
      parameters:newParams
    resultKeyMap:nil
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 success();
             }
             
         } failure:failure];
}

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
               failure:(nullable void (^)(NSError *_Nullable err))failure {
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:4];
    [dicParams setValue:@"user_Reset" forKey:@"action"];
    [dicParams setValue:mobile forKey:@"mobile"];
    [dicParams setValue:[password MD5String] forKey:@"new_password"];
    [dicParams setValue:validCode forKey:@"valid_code"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:nil
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 success();
             }
             
         } failure:failure];
}

@end
