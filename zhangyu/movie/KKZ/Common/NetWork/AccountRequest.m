//
//  AccountRequest.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "AccountRequest.h"
#import "DataEngine.h"
#import "Constants.h"
#import "NewLoginViewModel.h"


#import <NetCore_KKZ/KKZBaseNetRequest.h>
#import <NetCore_KKZ/KKZBaseRequestParams.h>

@implementation AccountRequest

-(void)startPostSigature:(NSString *)sigature
                 Sucuess:(UpdateProfilSuccess) sucuessBack
                    Fail:(UpdateProfilFailed) failBack
{
    [self startRequest:[NSDictionary dictionaryWithObjectsAndKeys:sigature, @"signature", nil]
               Sucuess:sucuessBack
                  Fail:failBack];
}

-(void)startPostHobbyMovieType:(NSString *)hobbyMovieType
                       Sucuess:(UpdateProfilSuccess) sucuessBack
                          Fail:(UpdateProfilFailed) failBack
{
    [self startRequest:[NSDictionary dictionaryWithObjectsAndKeys:hobbyMovieType, @"hobby_movie_type", nil]
               Sucuess:sucuessBack
                  Fail:failBack];
}

-(void)startPostOftenCinema:(NSString *)oftenCinema
                    Sucuess:(UpdateProfilSuccess) sucuessBack
                       Fail:(UpdateProfilFailed) failBack
{
    [self startRequest:[NSDictionary dictionaryWithObjectsAndKeys:oftenCinema, @"often_cinema", nil]
               Sucuess:sucuessBack
                  Fail:failBack];
}

-(void)startPostHobby:(NSString *)hobby
              Sucuess:(UpdateProfilSuccess) sucuessBack
                 Fail:(UpdateProfilFailed) failBack
{
    [self startRequest:[NSDictionary dictionaryWithObjectsAndKeys:hobby, @"hobby", nil]
               Sucuess:sucuessBack
                  Fail:failBack];
}

-(void)startPostJob:(NSString *)job
            Sucuess:(UpdateProfilSuccess) sucuessBack
               Fail:(UpdateProfilFailed) failBack
{
    [self startRequest:[NSDictionary dictionaryWithObjectsAndKeys:job, @"job", nil]
               Sucuess:sucuessBack
                  Fail:failBack];
}

- (void)startPostWeight:(NSString *)weight
                Sucuess:(UpdateProfilSuccess)sucuessBack
                   Fail:(UpdateProfilFailed)failBack
{
    [self startRequest:[NSDictionary dictionaryWithObjectsAndKeys:weight, @"weight", nil]
               Sucuess:sucuessBack
                  Fail:failBack];
}

- (void)startPostHeight:(NSString *)height
                Sucuess:(UpdateProfilSuccess)sucuessBack
                   Fail:(UpdateProfilFailed)failBack
{
    [self startRequest:[NSDictionary dictionaryWithObjectsAndKeys:height, @"height", nil]
               Sucuess:sucuessBack
                  Fail:failBack];
}

-(void)startPostCity_Id:(NSString *)cityId
              City_Name:(NSString *)cityName
                Sucuess:(UpdateProfilSuccess) sucuessBack
                   Fail:(UpdateProfilFailed) failBack
{
    
    //添加上传参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
    [dic setValue:cityId forKey:@"city_id"];
    [dic setValue:cityName forKey:@"city_name"];
    
    [self startRequest:[dic copy]
               Sucuess:sucuessBack
                  Fail:failBack];
}

- (void)startPostBirthYear:(NSString *)year
                     month:(NSString *)month
                       day:(NSString *)day
                   Sucuess:(UpdateProfilSuccess) sucuessBack
                      Fail:(UpdateProfilFailed) failBack
{
    //添加上传参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [dic setValue:year forKey:@"year"];
    [dic setValue:month forKey:@"month"];
    [dic setValue:day forKey:@"day"];
    //开始请求
    [self startRequest:[dic copy]
               Sucuess:sucuessBack
                  Fail:failBack];
}

- (void)startNickName:(NSString *)nickname
              Sucuess:(UpdateProfilSuccess) sucuessBack
                 Fail:(UpdateProfilFailed) failBack
{
    [self startRequest:[NSDictionary dictionaryWithObjectsAndKeys:nickname, @"nick_name", nil]
               Sucuess:sucuessBack
                  Fail:failBack];
}

- (void)startgender:(NSString *)gender
            Sucuess:(UpdateProfilSuccess) sucuessBack
               Fail:(UpdateProfilFailed) failBack
{
    [self startRequest:[NSDictionary dictionaryWithObjectsAndKeys:gender, @"sex", nil]
               Sucuess:sucuessBack
                  Fail:failBack];
}

- (void)startHeadimg:(UIImage *)headimg
             Sucuess:(UpdateProfilSuccess) sucuessBack
                Fail:(UpdateProfilFailed) failBack
{
    
    [self startRequest:nil image:headimg Sucuess:sucuessBack Fail:failBack];
    
}

- (void)startRequest:(NSDictionary * _Nonnull) params
             Sucuess:(UpdateProfilSuccess) successBack
                Fail:(UpdateProfilFailed) failBack
{
    [self startRequest:params image:nil Sucuess:successBack Fail:failBack];
}


/**
 具体的请求

 @param params      参数
 @param image       图片
 @param successBack 成功回调
 @param failBack    失败回调
 */
- (void)startRequest:(NSDictionary * _Nullable) params
               image:(UIImage * _Nullable) image
             Sucuess:(UpdateProfilSuccess) successBack
                Fail:(UpdateProfilFailed) failBack
{
    //开始请求
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:USER_SERVE baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [dicParams setValue:[DataEngine sharedDataEngine].userId forKey:@"user_id"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    //全部请求以multipart形式
    [request upload:USER_SERVE_API_PATH(@"user/update") parameters:newParams fromData:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (image) {
            NSData *nsData = UIImageJPEGRepresentation(image, 0.5f);
            [formData appendPartWithFileData:nsData name:@"head_img" fileName:@"file.jpg" mimeType:@"image/jpeg"];
        }
    } resultClass:nil success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (successBack) {
            successBack();
        }
        
        if (image) {
            //修改头像成功
           [self parserData:responseObject];
        }
        
    } failure:failBack];
    
}


-(void)parserData:(NSDictionary *)dic{
    NSDictionary *userDict = dic[@"result"];
    NSString *headImg = userDict[@"headImg"];
    [DataEngine sharedDataEngine].headImg = headImg;
}


/**
 查询用户信息
 
 @param userID  user ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestUser:(nullable NSNumber *)userID
             success:(nullable void (^)(User *_Nullable user))success
             failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:USER_SERVE baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:3];
    [dicParams setValue:userID forKey:@"user_id"];
    [dicParams setValue:[DataEngine sharedDataEngine].sessionId forKey:@"session_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:USER_SERVE_API_PATH(@"user/query")
      parameters:newParams
    resultKeyMap:@{@"result": [User class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 success([data objectForKey:@"result"]);
             }
             
    } failure:failure];


}

/**
 查询用户的社交信息
 
 @param userID  user ID
 @param success 成功回调
 @param failure 失败回调
 */
- (void) requestUserDetail:(nullable NSNumber *)userID
                   success:(nullable void (^)(UserSocoal *_Nullable userSocoal))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:userID forKey:@"user_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:KKSSPKotaPath(@"query_user_detail.chtml")
      parameters:newParams
    resultKeyMap:@{@"user": [UserSocoal class]}
         success:^(NSDictionary * _Nullable data, id  _Nullable responseObject) {
             if (success) {
                 success([data objectForKey:@"user"]);
             }
             
         } failure:failure];
}

@end
