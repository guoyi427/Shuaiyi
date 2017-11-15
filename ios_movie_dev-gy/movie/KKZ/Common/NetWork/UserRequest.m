//
//  UserRequest.m
//  KoMovie
//
//  Created by Albert on 28/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserRequest.h"
#import "HXUserInfo.h"
#import "MemContainer.h"
#import "NewLoginViewModel.h"

@implementation UserRequest
/**
 登录
 
 @param userName 用户名 第三方登录传uid
 @param password 密码（无需做加密处理，第三方登录传token）
 @param site     登录类型
 @param success  成功回调
 @param failure  失败回调
 */

/*
- (void) login:(NSString * _Nonnull)userName
      password:(NSString * _Nonnull)password
          site:(SiteType )site
       success:(nullable void (^)(UserLogin *_Nullable userLogin))success
       failure:(nullable void (^)(NSError *_Nullable err))failure
{
    
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
    
    [request GET:KKSSPKotaPath(@"user_login.chtml")
      parameters:newParams
    resultKeyMap:@{@"user": [UserLogin class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 success([data objectForKey:@"user"]);
             }
             
         } failure:failure];
    
}
*/
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
    [dicParams setValue:@"user_Login" forKey:@"action"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"user": [UserLogin class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 UserLogin *model = [data objectForKey:@"user"];
                 success(model);
                 [NewLoginViewModel deleteLoginDataFromDataBase];
                 [NewLoginViewModel insertLoginDataIntoDataBase:model];
                 [[DataEngine sharedDataEngine] setUserDataModel:model];
             }
             
         } failure:failure];
}

/**
 退出登录
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void) logout:(nullable void (^)())success
        failure:(nullable void (^)(NSError *_Nullable err))failure
{
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
 更新用户位置信息、token
 */
- (void) updateUserPosition
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:@"ios" forKey:@"entity.channel"];
    [dicParams setValue:USER_DEVICE_ID forKey:@"entity.pushChannelId"];
    [dicParams setValue:USER_DEVICE_TOKEN forKey:@"entity.pushUserId"];
    [dicParams setValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
    if ([USER_LATITUDE length] && [USER_LONGITUDE length]) {
        [dicParams setValue:USER_LATITUDE forKey:@"entity.latitude"];
        [dicParams setValue:USER_LONGITUDE forKey:@"entity.longitude"];
    }else{
        //未获取坐标
        return;
    }
   
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"update_position.chtml")
      parameters:newParams
    resultKeyMap:nil
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             
         } failure:^(NSError * _Nullable err) {
             DLog(@"update user position faile, error: %@", err);
         }];
}


/**
 查询别人的个人主页的背景图

 @param userId  用户ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestUserHomePageBg:(NSNumber * _Nonnull) userId
                       success:(nullable void (^)(NSString *_Nullable url))success
                       failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:userId forKey:@"user_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"queryUserLastOrderMovie.chtml")
      parameters:newParams
    resultKeyMap:nil
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 success([responseObject objectForKey:@"url"]);
             }
             
         } failure:failure];
}

/**
 查询环信用户信息
 
 @param userId  用户Uid,用逗号分开
 @param success 成功回调 <HXUserInfo>
 @param failure 失败回调
 */
- (void) requestHXUsers:(NSString * _Nonnull) userIds
                success:(nullable void (^)(NSArray *_Nullable hxusers))success
                failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:userIds forKey:@"user_ids"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"querySmallUsers.chtml")
      parameters:newParams
    resultKeyMap:@{@"users":[HXUserInfo class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             NSArray *users = [data objectForKey:@"users"];
             if (success) {
                 success(users);
             }
             
             if (users.count > 0) {
                 for (HXUserInfo * user in users) {
                     [[MemContainer me] putObject:user];
                 }
                 
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
               failure:(nullable void (^)(NSError *_Nullable err))failure
{
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


/**
 修改密码
 
 @param originalPassword    原密码
 @param newPassword         新密码
 @param success             成功回调
 @param failure             失败回调
 */
- (void) changeOriginalPassword:(NSString *_Nonnull)originalPassword
                    newPassword:(NSString *_Nonnull)newPassword
                        success:(nullable void (^)())success
                        failure:(nullable void (^)(NSError *_Nullable err))failure;
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:5];
    [dicParams setValue:@"user_Edit" forKey:@"action"];
    [dicParams setValue:[originalPassword MD5String] forKey:@"old_password"];
    [dicParams setValue:[newPassword MD5String] forKey:@"new_password"];
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


/**
 查询账户详情

 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestUserDetail:(nullable void (^)(User *_Nullable user))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:@"user_Query" forKey:@"action"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"user":[User class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             User *newUser = data[@"user"];
             if (success && newUser) {
                 success(newUser);
                 [[UserManager shareInstance] setUser:newUser];
                 [DataEngine sharedDataEngine].userName = newUser.nickName;
                 [DataEngine sharedDataEngine].headImg = newUser.headImg;
                 [NewLoginViewModel updateLoginModelKey:@"nickName" modelValue:newUser.nickName];
                 [NewLoginViewModel updateLoginModelKey:@"headimg" modelValue:newUser.headImg];
             }
         } failure:failure];

}
/**
 查询绑定账户列表
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestUserBindList:(nullable void (^)(UserBind *_Nullable bindAccount))success
                     failure:(nullable void (^)(NSError *_Nullable err))failure

{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"queryUserAccounts.chtml")
      parameters:newParams
    resultKeyMap:nil
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             
             UserBind * bindAccount = [UserBind mj_objectWithKeyValues:[responseObject objectForKey:@"userAccounts"]];
             
             if (success) {
                 success(bindAccount);
             }
             
         } failure:failure];
}


/**
  社交平台绑定账户

 @param site    平台
 @param thirdId 社交平台userID
 @param token   token
 @param success 成功回调
 @param failure 失败回调
 */
- (void) bindAccount:(SiteType )site
             thirdId:(NSString *_Nonnull) thirdId
               token:(NSString *_Nonnull) token
             success:(nullable void (^)())success
             failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:thirdId forKey:@"user_name"];
    [dicParams setValue:token forKey:@"password"];
    [dicParams setValue:[NSNumber numberWithInt:site] forKey:@"site"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"accountBinding.chtml")
      parameters:newParams
    resultKeyMap:nil
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 success();
             }
             
         } failure:failure];
    
}


/**
 绑定手机账户

 @param phoneNum 手机号
 @param password 密码
 @param code     验证码
 @param success  成功回调
 @param failure  失败回调
 */
- (void) bindAccountPhoneNum:(NSString *_Nonnull) phoneNum
                    password:(NSString *_Nonnull) password
                        code:(NSString *_Nonnull) code
                     success:(nullable void (^)())success
                     failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:phoneNum forKey:@"user_name"];
    [dicParams setValue:password forKey:@"password"];
    [dicParams setValue:code forKey:@"valid_code"];
    [dicParams setValue:[NSNumber numberWithInt:SiteTypeKKZ] forKey:@"site"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"accountBinding.chtml")
      parameters:newParams
    resultKeyMap:nil
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 success();
             }
             
         } failure:failure];
}


/**
 解除绑定

 @param site     平台
 @param password 密码（手机解绑时才需要）
 @param success  成功回调
 @param failure  失败回调
 */
- (void) unbindAccount:(SiteType ) site
              password:(NSString * _Nullable) password
               success:(nullable void (^)())success
               failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:KKSSPKota baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    if (password && site == SiteTypeKKZ) {
       [dicParams setValue:[password MD5String] forKey:@"password"];
    }
    
    [dicParams setValue:[NSNumber numberWithInt:site] forKey:@"site"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"removeAccountBinding.chtml")
      parameters:newParams
    resultKeyMap:nil
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 success();
             }
             
         } failure:failure];
}



/**
 获取用户消息数量

 @param userID 用户ID
 @param success 成功回调（inviteMovieCount：约电影个数；availableCouponCount：优惠劵个数；needCommentOrderCount：待评价个数；articleCount：帖子个数）
 @param failure 失败回调
 */
- (void) requestMessageCount:(NSNumber *_Nullable) userID
                     success:(nullable void (^)(NSNumber *_Nullable inviteMovieCount,
                                                NSNumber *_Nullable availableCouponCount,
                                                NSNumber *_Nullable needCommentOrderCount,
                                                NSNumber *_Nullable articleCount))success
                     failure:(nullable void (^)(NSError *_Nullable err))failure;
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [dicParams setValue:userID forKey:@"user_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"query_message_count.chtml")
      parameters:newParams
    resultKeyMap:nil
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             
             NSNumber *num_inviteMovieCount = [responseObject objectForKey:@"inviteMovieCount"];
             NSNumber *num_availableCouponCount = [responseObject objectForKey:@"availableCouponCount"];
             NSNumber *num_needCommentOrderCount = [responseObject objectForKey:@"needCommentOrderCount"];
             NSNumber *num_articleCount = [responseObject objectForKey:@"articleCount"];
             
             if (success) {
                 success(num_inviteMovieCount, num_availableCouponCount, num_needCommentOrderCount, num_articleCount);
             }
             
         } failure:failure];
}

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
                    success:(nullable void (^)(UserLogin * _Nullable))success
                    failure:(nullable void (^)(NSError * _Nullable))failure {
    if (!phoneNumber || !password || !nickName || !validCode) {
        return;
    }
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSDictionary *params = [KKZBaseRequestParams getDecryptParams:@{
                                                                    @"user_name": phoneNumber,
                                                                    @"nick_name": nickName,
                                                                    @"password": [password MD5String],
                                                                    @"valid_code": validCode,
                                                                    @"action": @"user_Register"
                                                                    }];
    [request GET:kKSSPServer parameters:params resultKeyMap:@{@"user": [UserLogin class]} success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
        if (success) {
            UserLogin *model = [data objectForKey:@"user"];
            success(model);
            [NewLoginViewModel deleteLoginDataFromDataBase];
            [NewLoginViewModel insertLoginDataIntoDataBase:model];
            [[DataEngine sharedDataEngine] setUserDataModel:model];
        }
    } failure:failure];
}

- (void)editNickname:(NSString *_Nonnull)nickname
             success:(nullable void (^)())success
             failure:(nullable void (^)(NSError *_Nullable err))failure {
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:@{
                                                                       @"action": @"user_Update",
                                                                       @"nick_name": nickname
                                                                       }];
    [request POST:kKSSPServer parameters:newParams resultClass:nil success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            success();
        }
    } failure:failure];
}

- (void)editHeadImage:(UIImage *_Nonnull)image
              success:(nullable void (^)())success
              failure:(nullable void (^)(NSError *_Nullable err))failure {
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
    if (imageData == nil) {
        return;
    }
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:5];
    [dicParams setValue:@"user_Update" forKey:@"action"];
//    [dicParams setValue:imageData forKey:@"head_image"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request upload:kKSSPServer parameters:newParams fromData:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (imageData) {
            [formData appendPartWithFileData:imageData name:@"head_img" fileName:@"file.jpg" mimeType:@"image/jpeg"];
        }
    } resultClass:nil success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            success();
        }
    } failure:failure];
    
//    [request POST:kKSSPServer parameters:newParams resultClass:nil success:^(id  _Nullable data, id  _Nullable responseObject) {
//        if (success) {
//            success();
//        }
//    } failure:failure];
}

@end
