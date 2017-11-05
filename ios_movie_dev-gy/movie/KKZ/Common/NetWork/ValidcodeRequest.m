//
//  ValidcodeRequest.m
//  KoMovie
//
//  Created by Albert on 10/11/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ValidcodeRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ/KKZBaseNetRequest.h>

@implementation ValidcodeRequest

- (void)requestAuthResetSuccess:(nullable void (^)(NSString *_Nullable codeKey, NSString *_Nullable codeUrl))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setValue:@"authcode_Reset" forKey:@"action"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:para];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 success(respomsObject[@"code"][@"codeKey"], respomsObject[@"code"][@"codeUrl"]);
             }
             
         }
         failure:failure];
    
}



- (void)requestAuthCode:(NSString *_Nonnull)codeKey
              validCode:(NSString *_Nonnull)validCode
                 action:(NSString *_Nonnull)action
                success:(nullable void (^)())success
                failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:4];
    [para setValue:@"authcode_Check" forKey:@"action"];
    [para setValue:codeKey forKey:@"code_key"];
    [para setValue:validCode forKey:@"valid_code"];
    [para setValue:action forKey:@"action_name"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:para];
    
    [request GET:kKSSPServer
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 success();
             }
             
         }
         failure:failure];

}



- (void)requestResetPasswordValidcode:(NSString *_Nonnull)mobile
                              success:(nullable void (^)())success
                              failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setValue:@"validcode_Query" forKey:@"action"];
    [para setValue:mobile forKey:@"mobile"];
    [para setValue:@"2" forKey:@"valid_type"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:para];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 success(data);
             }
             
         }
         failure:failure];
    
}

/**
 获取登录的验证码
 
 @param mobile 手机号
 @param type 验证码类型：短信/语音
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestLoginValidcode:(NSString *_Nonnull)mobile
                validcodeType:(ValidcodeType)type
                      success:(nullable void(^)())success
                      failure:(nullable void(^)(NSError *_Nullable err))failure
{
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setValue:@"validcode_Query" forKey:@"action"];
    [para setValue:mobile forKey:@"mobile"];
    [para setValue:@(type) forKey:@"validation_type"];
    [para setValue:@"4" forKey:@"size"];
    [para setValue:@"3" forKey:@"valid_type"];  //1 注册，2重置密码，3登陆
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:para];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 success(data);
             }
             
         }
         failure:failure];
    
}

/**
 获取注册的验证码
 
 @param mobile 手机号
 @param type 验证码类型：短信/语音
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestRegisterValidcode:(NSString *_Nonnull)mobile
                   validcodeType:(ValidcodeType)type
                         success:(nullable void(^)())success
                         failure:(nullable void(^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
    [para setValue:@"validcode_Query" forKey:@"action"];
    [para setValue:mobile forKey:@"mobile"];
    [para setValue:@(type) forKey:@"validation_type"];
    [para setValue:@"4" forKey:@"size"];
    [para setValue:@"1" forKey:@"valid_type"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:para];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 success(data);
             }
             
         }
         failure:failure];
}

@end
