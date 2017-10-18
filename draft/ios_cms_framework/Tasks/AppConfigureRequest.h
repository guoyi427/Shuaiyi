//
//  AppConfigureRequest.h
//  CIASMovie
//
//  Created by cias on 2017/2/9.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConfig.h"
#import "ArticleTotal.h"

@interface AppConfigureRequest : NSObject

//MARK: 外观配置接口
- (void)requestQueryTemplateParams:(NSDictionary *_Nullable)params
                          success:(nullable void (^)(NSDictionary *_Nullable data))success
                          failure:(nullable void (^)(NSError *_Nullable err))failure;
//MARK: 外观配置接口 --- banner
- (void)requestQueryBannerTemplateParams:(NSDictionary *_Nullable)params
                                 success:(nullable void (^)(NSArray *_Nullable data))success
                                 failure:(nullable void (^)(NSError *_Nullable err))failure;
//MARK: 外观配置接口 --- seatIcon
- (void)requestQuerySeatIconTemplateParams:(NSDictionary *_Nullable)params
                                   success:(nullable void (^)(NSDictionary *_Nullable data))success
                                   failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK: 基础配置接口
- (void)requestQueryConfigParams:(NSDictionary *_Nullable)params
                          success:(nullable void (^)(AppConfig *_Nullable data))success
                          failure:(nullable void (^)(NSError *_Nullable err))failure;

//MARK: 资讯列表接口
- (void)requestArticleListParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(ArticleTotal *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure;



//MARK: 缓存开机广告
- (void) requestADdataWithUrlStr:(NSString *_Nullable) urlStr;



//MARK: banner接口
- (void)requestQueryBannerParams:(NSDictionary *_Nullable)params
                                 success:(nullable void (^)(NSArray *_Nullable data))success
                                 failure:(nullable void (^)(NSError *_Nullable err))failure;
//MARK: seatIcon接口
- (void)requestQuerySeatIconParams:(NSDictionary *_Nullable)params
                                   success:(nullable void (^)(NSDictionary *_Nullable data))success
                                   failure:(nullable void (^)(NSError *_Nullable err))failure;


@end
