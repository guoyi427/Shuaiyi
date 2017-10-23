//
//  CityRequest.m
//  CIASMovie
//
//  Created by hqlgree2 on 29/12/2016.
//  Copyright © 2016 cias. All rights reserved.
//

#import "CityRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

#import "NSArraySort.h"
#import "City.h"
#import "KKZBaseRequestParamsMD5.h"
#import "MemContainer.h"

@implementation CityRequest

//返回城市数组，不带index
- (void)requestCityListParams:(NSDictionary *_Nullable)params
                      success:(nullable void (^)(NSArray *_Nullable data))success
                      failure:(nullable void (^)(NSError *_Nullable err))failure{
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    // set model peaer key
    request.parseKey = @"data";
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:dicParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews,@"queryCinemaCitys"]];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", ciasFilmNews,@"queryCinemaCitys"], newParams);
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews,@"queryCinemaCitys"]
      parameters:newParams
     resultClass:[City class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestCityListParams == /n%@/n", data);

             if (success) {
                 success(data);
             }
         }
         failure:failure];

}


/*
- (void)requestCityListSuccess:(nullable void (^)(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes))success
                       failure:(nullable void (^)(NSError * _Nullable err))failure {
    KKZBaseNetRequest *request =
    [KKZBaseNetRequest requestWithBaseURL:ciasSSPServerBaseURL
                               baseParams:nil];
    
    request.parseKey = @"data";
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setValue:ciasChannelId forKey:@"channelId"];

    NSDictionary *newParams =
    [KKZBaseRequestParamsMD5 getDecryptParams:dicParams withMethod:@"GET" withRequestPath:[NSString stringWithFormat:@"%@%@%@", @"/webservice/", ciasFilmNews, @"queryCinemaCitys"]];
    DLog(@"self.baseURL == %@%@\n parameters==%@\n", ciasSSPServerBaseURL, [NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryCinemaCitys"], newParams);
    //60 cache
    [request GET:[NSString stringWithFormat:@"%@%@", ciasFilmNews, @"queryCinemaCitys"]
      parameters:newParams
    resultKeyMap:@{@"data":[City class]}
  cacheValidTime:1
         success:^(id _Nullable data, id _Nullable respomsObject) {
             DLog(@"requestCityListSuccess == /n%@/n", respomsObject);
             [self handle:data finish:success];
         }
         failure:failure];
}
*/

- (void)handle:(NSArray *)cityList finish:(nullable void (^)(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes))finish
{
    
    NSMutableDictionary *cities = [[NSMutableDictionary alloc] init];
    NSMutableArray* cityIndexes = [[NSMutableArray alloc] init];
    
    //处理城市列表 排序 分组 索引提取
    //TODO: 优化 KCV实现
    
    if ([cityList count]) {
        
        for (City *city in cityList) {
            
            [[MemContainer me] putObject:city];
            
            NSMutableArray *hotCity = (NSMutableArray *)[cities objectForKey:@"!"];
            if (hotCity.count<=0 && city.cityHot.integerValue > 0) {
                hotCity = [[NSMutableArray alloc] init];
                [cities setValue:hotCity forKey:@"!"];
                [cityIndexes addObject:@"!"];
            }
            if (city.cityHot.integerValue > 0) {
                [hotCity addObject:city];
            }
            
            NSMutableArray *group = (NSMutableArray *)[cities objectForKey:city.nameFirst];
            if (!group && city.nameFirst) {
                group = [[NSMutableArray alloc] init];
                [cities setValue:group forKey:city.nameFirst];
                [cityIndexes addObject:city.nameFirst];
            }
            [group addObject:city];
        }
        
        for (NSString *key in [cities allKeys]) {
            NSMutableArray *group = [cities objectForKey:key];
            if ([key isEqualToString:@"!"]) {
                [group sortBy:@"cityHot asc", nil];
            }else{
                [group sortBy:@"nameFirst asc", @"cityHot desc", @"cityPinYin asc", @"cityId asc", nil];
            }
        }
        [cityIndexes sortUsingSelector:@selector(caseInsensitiveCompare:)];
        
    }
    
    if (finish) {
        finish([cities copy], [cityIndexes copy]);
    }
}

//  --------------- kkz

/**
 查询城市列表
 
 @param success 成功回调 cities{index : City} cityIndexes<NSString> 索引
 @param failure 失败会掉
 */
- (void)requestCityListSuccess:(nullable void (^)(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes))success
                       failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:1];
    [dicParams setObject:@"city_query" forKey:@"action"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    //120 cache
    [request GET:kKSSPServer
      parameters:newParams
    resultKeyMap:@{@"cities":[City class]}
         success:^(NSDictionary *_Nullable data, id _Nullable respomsObject) {
             [self handle:[data objectForKey:@"cities"] finish:success];
         }
         failure:failure];
}

@end
