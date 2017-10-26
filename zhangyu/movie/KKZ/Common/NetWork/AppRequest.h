//
//  AppRequest.h
//  KoMovie
//
//  Created by Albert on 9/21/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppVersion;

/**
 查询应用相关的接口
 */
@interface AppRequest : NSObject

/**
 查询应用的 Splash

 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestSplashSuccess:(nullable void (^)(NSArray *_Nullable splashe))success
                     failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 查询版本更新
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestAppVersionSuccess:(nullable void (^)(AppVersion *_Nullable version))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
  上传日志

 @param path    日志路径
 @param success 成功回调
 @param failure 失败回调
 */
- (void)uploadLog:(NSString *_Nonnull)path
          success:(nullable void (^)())success
          failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 app菜单配置
 
 @param type    菜单类型 0 我的， 1 发现
 @param success 成功回调
 @param failure 失败回调
 */
- (void)requestMenus:(NSNumber *_Nonnull)type
             success:(nullable void (^)(NSArray *_Nullable singleCenterModels))success
             failure:(nullable void (^)(NSError *_Nullable err))failure;



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
               failure:(nullable void (^)(NSError *_Nullable err))failure;

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
               failure:(nullable void (^)(NSError *_Nullable err))failure;


//TODO: 热修复

@end
