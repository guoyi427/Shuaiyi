//
//  AccountRequest.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//


#import "User.h"
#import "UserSocoal.h"

typedef void (^UpdateProfilSuccess)();
typedef void (^UpdateProfilFailed)(NSError *_Nullable err);


/**
 用户相关接口
 */
@interface AccountRequest : NSObject

/**
 *  上传用户的签名
 *
 *  @param sigature     签名
 *  @param sucuessBack  成功回调
 *  @param failBack     失败回调
 */
-(void)startPostSigature:(NSString *_Nonnull)sigature
                 Sucuess:(nullable UpdateProfilSuccess) sucuessBack
                    Fail:(nullable UpdateProfilFailed) failBack;

/**
 *  上传用户喜欢的影片类型
 *
 *  @param hobbyMovieType 影片类型
 *  @param sucuessBack
 *  @param failBack
 */
-(void)startPostHobbyMovieType:(NSString *_Nonnull)hobbyMovieType
                       Sucuess:(nullable UpdateProfilSuccess) sucuessBack
                          Fail:(nullable UpdateProfilFailed) failBack;
/**
 *  上传用户常去的影院类型
 *
 *  @param oftenCinema 常去的影院类型
 *  @param sucuessBack 成功回调
 *  @param failBack    失败回调
 */
-(void)startPostOftenCinema:(NSString *_Nonnull)oftenCinema
                       Sucuess:(nullable UpdateProfilSuccess) sucuessBack
                          Fail:(nullable UpdateProfilFailed) failBack;

/**
 *  上传用户爱好
 *
 *  @param hobby        爱好
 *  @param sucuessBack  成功回调
 *  @param failBack     失败回调
 */
-(void)startPostHobby:(NSString *_Nonnull)hobby
              Sucuess:(nullable UpdateProfilSuccess) sucuessBack
                 Fail:(nullable UpdateProfilFailed) failBack;

/**
 *  上传用户职业信息
 *
 *  @param job         用户职业信息
 *  @param sucuessBack 成功回调
 *  @param failBack    失败回调
 */
-(void)startPostJob:(NSString *_Nonnull)job
            Sucuess:(nullable UpdateProfilSuccess) sucuessBack
               Fail:(nullable UpdateProfilFailed) failBack;

/**
 *  上传用户体重
 *
 *  @param weight       用户的体重
 *  @param sucuessBack  成功回调
 *  @param failBack     失败回调
 */
-(void)startPostWeight:(NSString *_Nonnull)weight
               Sucuess:(nullable UpdateProfilSuccess) sucuessBack
                  Fail:(nullable UpdateProfilFailed) failBack;

/**
 *  上传用户身高
 *
 *  @param height      用户的身高
 *  @param sucuessBack 成功回调
 *  @param failBack    失败回调
 */
-(void)startPostHeight:(NSString *_Nonnull)height
              Sucuess:(nullable UpdateProfilSuccess) sucuessBack
                 Fail:(nullable UpdateProfilFailed) failBack;

/**
 *  上传用户城市信息
 *
 *  @param cityId       城市ID
 *  @param cityName     城市名
 */
-(void)startPostCity_Id:(NSString *_Nonnull)cityId
              City_Name:(NSString *_Nonnull)cityName
               Sucuess:(nullable UpdateProfilSuccess) sucuessBack
                   Fail:(nullable UpdateProfilFailed) failBack;

/**
 *  上传用户出生日期
 *
 *  @param year        年
 *  @param month       月
 *  @param day         日
 *  @param sucuessBack 成功回调
 *  @param failBack    失败回调
 */
- (void)startPostBirthYear:(NSString *_Nonnull)year
                     month:(NSString *_Nonnull)month
                       day:(NSString *_Nonnull)day
                   Sucuess:(nullable UpdateProfilSuccess) sucuessBack
                      Fail:(nullable UpdateProfilFailed) failBack;
/**
 *  上传用户昵称
 *
 *  @param nickname    昵称
 *  @param sucuessBack 成功回调
 *  @param failBack    失败回调
 */
- (void)startNickName:(NSString *_Nonnull)nickname
              Sucuess:(nullable UpdateProfilSuccess) sucuessBack
                 Fail:(nullable UpdateProfilFailed) failBack;

/**
 *  上传用户性别
 *
 *  @param gender      性别
 *  @param sucuessBack 成功回调
 *  @param failBack    失败回调
 */
- (void)startgender:(NSString *_Nonnull)gender
            Sucuess:(nullable UpdateProfilSuccess) sucuessBack
               Fail:(nullable UpdateProfilFailed) failBack;

/**
 *  上传用户头像
 *
 *  @param headimg     头像
 *  @param sucuessBack 成功回调
 *  @param failBack    失败回调
 */
- (void)startHeadimg:(UIImage *_Nonnull)headimg
            Sucuess:(nullable UpdateProfilSuccess) sucuessBack
               Fail:(nullable UpdateProfilFailed) failBack;




/**
 查询用户信息

 @param userID  user ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestUser:(nullable NSNumber *)userID
             success:(nullable void (^)(User *_Nullable user))success
             failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 查询用户的社交信息
 
 @param userID  user ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestUserDetail:(nullable NSNumber *)userID
                   success:(nullable void (^)(UserSocoal *_Nullable userSocoal))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure;

@end
