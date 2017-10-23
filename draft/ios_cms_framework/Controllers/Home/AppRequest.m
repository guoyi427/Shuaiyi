//
//  AppRequest.m
//  KoMovie
//
//  Created by Albert on 9/21/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AppRequest.h"

#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "UIConstants.h"
#import "Constants.h"
//#import "AppVersion.h"
//#import "SingleCenterModel.h"
#import "Banner.h"

@implementation AppRequest
/**
 查询应用的 Splash
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestSplashSuccess:(nullable void (^)(NSArray *_Nullable splashes))success
                     failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:3];
    [para setObject:@"splash_Query" forKey:@"action"];
    [para setObject:[NSNumber numberWithFloat:kCommonScreenWidth] forKey:@"width"];
    [para setObject:[NSNumber numberWithFloat:kCommonScreenHeight] forKey:@"height"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:para];
    
    request.parseKey = @"splashes";
    
    [request GET:kKSSPServer
      parameters:newParams
     resultClass:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             
             if (success && respomsObject) {
                 NSArray *splashs = [respomsObject objectForKey:@"splashes"];
                 NSArray *urls = [splashs valueForKeyPath:@"@unionOfObjects.image"];
                 success(urls);
             }
             
         }
         failure:failure];
}


/**
 上传日志
 
 @param path    日志路径
 @param success 成功回调
 @param failure 失败回调
 */
- (void)uploadLog:(NSString *_Nonnull)path
          success:(nullable void (^)())success
          failure:(nullable void (^)(NSError *_Nullable err))failure
{
    if (path.length == 0) {
        return;
    }
    
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:3];
    [para setObject:@"app_Log" forKey:@"action"];
    [para setObject:@"ios" forKey:@"type"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:para];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data == nil) {
        return;
    }
    
    [request upload:kKSSPServer parameters:newParams fromData:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"application/octet-stream"];
    } resultClass:nil success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success ) {
            success(data);
        }
    } failure:failure];
    
}

/**
 广告
 
 @param cityID      城市ID
 @param targetType  类型  1 影片, 2 影院, 6 约电影, 10 订单 11首页广告 15发现页面的广告 16购票成功后的衍生品广告
 @param success     成功回调
 @param failure     失败回调
 */
- (void)requestBanners:(NSNumber *_Nonnull) cityID
            targetType:(NSNumber *_Nonnull) targetType
               success:(nullable void (^)(NSArray *_Nullable banners))success
               failure:(nullable void (^)(NSError *_Nullable err))failure
{
    [self requestBanners:cityID targetID:nil targetType:targetType success:success failure:failure];
}

/**
 广告
 
 @param cityID      城市ID
 @param targetID    banner的相关id, 如影片id 活动id
 @param targetType  类型  1 影片, 2 影院, 6 约电影, 10 订单 11首页广告 15发现页面的广告 16购票成功后的衍生品广告
 @param success     成功回调
 @param failure     失败回调
 */
- (void)requestBanners:(NSNumber *_Nonnull) cityID
              targetID:(NSNumber *_Nullable) targetID
            targetType:(NSNumber *_Nonnull) targetType
               success:(nullable void (^)(NSArray *_Nullable banners))success
               failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:3];
    [para setObject:@"banner_Query" forKey:@"action"];
    [para setValue:cityID forKey:@"city_id"];
    [para setValue:targetID forKey:@"target_id"];
    [para setValue:targetType forKey:@"target_type"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:para];
    
    request.parseKey = @"banners";
    
    [request GET:kKSSPServer
      parameters:newParams
     resultClass:[Banner class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             
             if (success ) {
                 NSArray *arr = nil;
                 if (data && [data isKindOfClass:[NSArray class]] == NO) {
                     //有时（首页广告）返回单个Banner对象
                     arr = [NSArray arrayWithObject:data];
                 }else{
                     arr = data;
                 }
                 
                 success(arr);
             }
             
         }
         failure:failure];
}

@end
