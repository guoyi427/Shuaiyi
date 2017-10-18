//
//  AppConfigureRequest.m
//  CIASMovie
//
//  Created by cias on 2017/2/9.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "AppConfigureRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>

#import "AppTemplate.h"
#import "AppConfig.h"
#import "Banner.h"
#import "KKZBaseRequestParamsMD5.h"
#import <AFNetworking/AFURLSessionManager.h>
#import "BannerNew.h"

@implementation AppConfigureRequest

//外观配置接口
- (void)requestQueryTemplateParams:(NSDictionary *_Nullable)params
                           success:(nullable void (^)(NSDictionary *_Nullable data))success
                           failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    [bannerParams setValue:@"3" forKey:@"type"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasConfigNews, @"queryTemplate"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasConfigNews, @"queryTemplate"]
      parameters:newParams
     resultKeyMap:@{@"data":[AppTemplate class]}
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"外观配置接口:%@", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];

}
//外观配置接口 --- banner
- (void)requestQueryBannerTemplateParams:(NSDictionary *_Nullable)params
                                 success:(nullable void (^)(NSArray *_Nullable data))success
                                 failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    [bannerParams setValue:@"3" forKey:@"type"];
    [bannerParams setValue:@"home.homeBanner" forKey:@"pageName"];
    [bannerParams setValue:@"http,https,cms" forKey:@"protocol"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasConfigNews, @"queryTemplate"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasConfigNews, @"queryTemplate"]
      parameters:newParams
     resultClass:[Banner class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(data);
             }
         }
         failure:failure];

}
//外观配置接口 --- seatIcon
- (void)requestQuerySeatIconTemplateParams:(NSDictionary *_Nullable)params
                                   success:(nullable void (^)(NSDictionary *_Nullable data))success
                                   failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    [bannerParams setValue:@"3" forKey:@"type"];
    [bannerParams setValue:@"detail.seatIconList" forKey:@"pageName"];
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasConfigNews, @"queryTemplate"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasConfigNews, @"queryTemplate"]
      parameters:newParams
    resultKeyMap:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];

}


//基础配置接口
- (void)requestQueryConfigParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(AppConfig *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    [bannerParams setValue:@"3" forKey:@"type"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasConfigNews, @"queryConfig"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasConfigNews, @"queryConfig"]
      parameters:newParams
     resultKeyMap:@{@"data":[AppConfig class]}
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"基础配置接口:%@", data);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
    

}

//MARK: 资讯列表接口
- (void)requestArticleListParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(ArticleTotal *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    [bannerParams setValue:@"3" forKey:@"type"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasConfigNews, @"queryArticleList"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasConfigNews, @"queryArticleList"]
      parameters:newParams
    resultKeyMap:@{@"data":[ArticleTotal class]}
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"资讯列表返回%@", respomsObject);

             if (success) {
                 success(data);
             }
         }
         failure:failure];
}


- (void) requestADdataWithUrlStr:(NSString *_Nullable) urlStr {
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    //AFN3.0+基于封住URLSession的句柄
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //请求
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    //下载Task操作
    NSURLSessionDownloadTask *_downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // @property int64_t totalUnitCount;  需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        // 给Progress添加监听 KVO
//        NSLog(@"%f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
//        // 回到主队列刷新UI
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
//        });
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString *pathFileName = @"";
        NSString *path = @"";
        NSString *deletePath = @"";
        if ([urlStr hasSuffix:@".mp4"]) {
            pathFileName = @"flash.mp4";
            // 判读缓存数据是否存在
            deletePath = [cachesPath stringByAppendingPathComponent:@"flash.png"];
        } else if ([urlStr hasSuffix:@".jpg"] || [urlStr hasSuffix:@".png"]) {
            pathFileName = @"flash.png";
            deletePath = [cachesPath stringByAppendingPathComponent:@"flash.mp4"];
        } else {
            pathFileName = @"flash.png";
            deletePath = [cachesPath stringByAppendingPathComponent:@"flash.mp4"];
        }
        // 判读缓存数据是否存在
        if ([[NSFileManager defaultManager] fileExistsAtPath:deletePath]) {
            // 删除旧的缓存数据
            [[NSFileManager defaultManager] removeItemAtPath:deletePath error:nil];
        }
        path = [cachesPath stringByAppendingPathComponent:pathFileName];
        DLog(@"%@", path);
        return [NSURL fileURLWithPath:path];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // filePath就是你下载文件的位置，你可以解压，也可以直接拿来使用
    }];
//    //暂停下载
//    [_downloadTask suspend];
    //开始下载
    [_downloadTask resume];
    
}







//MARK: banner接口
- (void)requestQueryBannerParams:(NSDictionary *_Nullable)params
                         success:(nullable void (^)(NSArray *_Nullable data))success
                         failure:(nullable void (^)(NSError *_Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
    [bannerParams setValue:@"3" forKey:@"slideType"];
//    [bannerParams setValue:@"home.homeBanner" forKey:@"pageName"];
//    [bannerParams setValue:@"http,https,cms" forKey:@"protocol"];
    
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasConfigNews, @"querySlideImg"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasConfigNews, @"querySlideImg"]
      parameters:newParams
     resultClass:[BannerNew class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"新轮播图接口信息：%@", respomsObject);
             if (success) {
                 success(data);
             }
         }
         failure:failure];
}


//MARK: seatIcon接口
- (void)requestQuerySeatIconParams:(NSDictionary *_Nullable)params
                           success:(nullable void (^)(NSDictionary *_Nullable data))success
                           failure:(nullable void (^)(NSError *_Nullable err))failure {
    
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *bannerParams =
    [NSMutableDictionary dictionaryWithDictionary:params];
    [bannerParams setValue:ciasChannelId forKey:@"channelId"];
//    [bannerParams setValue:@"3" forKey:@"type"];
//    [bannerParams setValue:@"detail.seatIconList" forKey:@"pageName"];
    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:bannerParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasConfigNews, @"querySeatImg"]];
    
    [request GET:[NSString stringWithFormat:@"%@%@", ciasConfigNews, @"querySeatImg"]
      parameters:newParams
    resultKeyMap:nil
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"新座位图接口信息：%@", respomsObject);
             if (success) {
                 success(respomsObject);
             }
         }
         failure:failure];
    
}










@end
