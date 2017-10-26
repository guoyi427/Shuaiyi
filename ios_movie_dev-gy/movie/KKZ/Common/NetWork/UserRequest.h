//
//  UserRequest.h
//  KoMovie
//
//  Created by Albert on 28/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserLogin.h"
#import "User.h"
#import "UserBind.h"
/**
 查询用户的相关接口
 在UserManager内完成用户相关业务处理。
 */
@interface UserRequest : NSObject

//-----------------UserManager Only Start-------------//

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
 使用手机号+验证码登录
 
 @param mobile 手机号
 @param validcode 验证码
 @param success  成功回调
 @param failure  失败回调
 */
- (void) login:(NSString * _Nonnull)mobile
      validcode:(NSString * _Nonnull)validcode
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
 更新用户位置信息、token
 */
- (void) updateUserPosition;


//-----------------UserManager Only End-------------//


/**
 查询别人的个人主页的背景图
 
 @param userId  用户ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestUserHomePageBg:(NSNumber * _Nonnull) userId
                       success:(nullable void (^)(NSString *_Nullable url))success
                       failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 查询环信用户信息
 
 @param userId  用户Uid,用逗号分开
 @param success 成功回调 <HXUserInfo>
 @param failure 失败回调
 */
- (void) requestHXUsers:(NSString * _Nonnull) userIds
                success:(nullable void (^)(NSArray *_Nullable hxusers))success
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

/**
 查询账户详情
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestUserDetail:(nullable void (^)(User *_Nullable user))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 查询绑定账户列表

 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestUserBindList:(nullable void (^)(UserBind *_Nullable bindAccount))success
                     failure:(nullable void (^)(NSError *_Nullable err))failure;

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
             failure:(nullable void (^)(NSError *_Nullable err))failure;


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
                     failure:(nullable void (^)(NSError *_Nullable err))failure;

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
               failure:(nullable void (^)(NSError *_Nullable err))failure;

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
