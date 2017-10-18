//
//  ValidcodeRequest.h
//  KoMovie
//
//  Created by Albert on 10/11/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 查询验证码相关的接口
 */
@interface ValidcodeRequest : NSObject

/**
 刷新图形验证码
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestAuthResetSuccess:(nullable void (^)(NSString *_Nullable codeKey, NSString *_Nullable codeUrl))success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 验证图形验证码

 @param codeKey codeKey
 @param validCode validCode
 @param action action
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestAuthCode:(NSString *_Nonnull)codeKey
              validCode:(NSString *_Nonnull)validCode
                 action:(NSString *_Nonnull)action
                success:(nullable void (^)())success
                failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 获取重置密码时的验证

 @param mobile mobile
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestResetPasswordValidcode:(NSString *_Nonnull)mobile
                              success:(nullable void (^)())success
                              failure:(nullable void (^)(NSError *_Nullable err))failure;

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
                      failure:(nullable void(^)(NSError *_Nullable err))failure;

@end
